trigger MaintenanceRequest on Case (before update, after update) {
    MaintenanceRequestHelper helper = new MaintenanceRequestHelper();

    if (Trigger.isAfter && Trigger.isUpdate) {
        helper.afterUpdate((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
    }

//    if (Trigger.isBefore && Trigger.isUpdate) {
//
//    }
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
}