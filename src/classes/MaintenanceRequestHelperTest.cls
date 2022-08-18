@IsTest
public with sharing class MaintenanceRequestHelperTest {

    @IsTest
    static void updateCase() {
        List<Case> listCase = new List<Case>();
        List<Equipment_Maintenance_Item__c> equipmentMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
        for (Integer i = 0; i < 300; i++) {
            Case newCase = new Case(
                    Status = 'New',
                    Type = 'Routine Maintenance',
                    Date_Reported__c = Date.today(),
                    Date_Due__c = Date.today().addDays(10)
            );
            listCase.add(newCase);
        }
        insert listCase;
        Product2 newProduct = new Product2();
        newProduct.Maintenance_Cycle__c = 10;
        newProduct.Name = 'Test';
        newProduct.Replacement_Part__c = true;
        insert newProduct;
        for (Case caseItem : listCase) {
            Equipment_Maintenance_Item__c newItem = new Equipment_Maintenance_Item__c();
            newItem.Equipment__c = newProduct.Id;
            newItem.Maintenance_Request__c = caseItem.Id;
            equipmentMaintenanceItems.add(newItem);
        }
        insert equipmentMaintenanceItems;

        Test.startTest();
        List<Case> testListCase = [SELECT Status, Type FROM Case];
        for (Integer i = 0; i < testListCase.size() / 2; i++) {
            testListCase[i].Status = 'Closed';
            testListCase[i].Type = 'Repair';
        }
        for (Integer i = testListCase.size() / 2; i < testListCase.size(); i++) {
            testListCase[i].Status = 'Closed';
            testListCase[i].Type = 'Routine Maintenance';
        }
        update testListCase;
        Test.stopTest();

        List<Case> newListCase = [
                SELECT Id, Status, Type
                FROM Case WHERE Status = 'New'
                AND Type = 'Routine Maintenance'
        ];
        System.assert(!newListCase.isEmpty());
        List<Equipment_Maintenance_Item__c> newEquipmentMaintenanceItems = [
                SELECT Maintenance_Request__c
                FROM Equipment_Maintenance_Item__c
                WHERE Maintenance_Request__c IN :newListCase
        ];
        System.assert(!newEquipmentMaintenanceItems.isEmpty());
    }
}