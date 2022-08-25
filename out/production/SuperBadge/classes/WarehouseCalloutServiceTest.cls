@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();
        WarehouseCalloutService.startWarehouseCallout();
        Test.stopTest();
    }
}