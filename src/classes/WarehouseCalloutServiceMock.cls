@IsTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock{
    global static HTTPResponse respond(HTTPRequest req) {
        HttpResponse newResponse = new HttpResponse();
        newResponse.setHeader('Content-Type', 'application/json');
        newResponse.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,' +
                '"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]');
        newResponse.setStatusCode(200);
        return newResponse;
    }
}