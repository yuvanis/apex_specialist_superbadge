@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testCallout() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.startWarehouseCallout();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Product2]);
    }
}