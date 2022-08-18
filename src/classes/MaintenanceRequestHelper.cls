public with sharing class MaintenanceRequestHelper {

    public void afterUpdate(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        updateWorkOrders(newCases, oldCasesMap);
    }
    public void updateWorkOrders(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        List<Case> filteredOldCases = getFilteredCases(newCases, oldCasesMap);
        createCases(filteredOldCases);
    }

    @TestVisible
    private static List<Case> getFilteredCases(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        List<Case> listCase = new List<Case>();
        for (Case newCase : newCases) {
            if (oldCasesMap.get(newCase.Id).Status != newCase.Status
                    && newCase.Status == 'Closed'
                    && (newCase.Type.equals('Repair')
                    || newCase.Type.equals('Routine Maintenance'))) {
                listCase.add(newCase);
            }
        }
        return listCase;
    }

    public List<Case> getCasesFromDB(List<Case> oldCases) {
        return [
                SELECT Vehicle__c, Type, Subject, Status, SLAViolation__c, Product__c,
                        PotentialLiability__c, EngineeringReqNumber__c, Description, Date_Reported__c, Date_Due__c, (SELECT Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r)
                FROM Case
                WHERE Id IN :oldCases
        ];
    }

    public void createCases(List<Case> oldCases) {
        List<Case> oldCasesFromDB = getCasesFromDB(oldCases);
        List<Case> listToDB = new List<Case>();
        List<Equipment_Maintenance_Item__c> lEquipmentMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
        for (Case oldCase : oldCasesFromDB) {
            List<Decimal> lDecimals = new List<Decimal>();

            for (Equipment_Maintenance_Item__c item : oldCase.Equipment_Maintenance_Items__r) {
                if (item.Equipment__r.Maintenance_Cycle__c != null) {
                    lDecimals.add(item.Equipment__r.Maintenance_Cycle__c);
                }
                Equipment_Maintenance_Item__c newItem = new Equipment_Maintenance_Item__c();
                newItem.Equipment__c = item.Equipment__c;
                newItem.Maintenance_Request__c = oldCase.Id;
                lEquipmentMaintenanceItems.add(newItem);
            }
            lDecimals.sort();
            Case newCase = new Case();
            newCase.ParentId = oldCase.Id;
            newCase.Vehicle__c = oldCase.Vehicle__c;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = oldCase.Subject;
            newCase.Status = 'New';
            newCase.SLAViolation__c = oldCase.SLAViolation__c;
            newCase.Product__c = oldCase.Product__c;
            newCase.PotentialLiability__c = oldCase.PotentialLiability__c;
            newCase.EngineeringReqNumber__c = oldCase.EngineeringReqNumber__c;
            newCase.Description = oldCase.Description;
            newCase.Date_Reported__c = Date.today();
            if (lDecimals.size() > 0) {
                newCase.Date_Due__c = Date.today().addDays((Integer) lDecimals[0]);
            }
            listToDB.add(newCase);
        }
        
        insert listToDB;
        for (Case iCase : listToDB) {
            for (Equipment_Maintenance_Item__c item : lEquipmentMaintenanceItems){
                if (item.Maintenance_Request__c == iCase.ParentId) {
                    item.Maintenance_Request__c = iCase.Id;
                }
            }
        }
        insert lEquipmentMaintenanceItems;
    }
}