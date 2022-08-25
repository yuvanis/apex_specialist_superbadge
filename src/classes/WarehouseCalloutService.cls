public with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @future(callout=true)
    public static void startWarehouseCallout() {
        List<Product2> products = new List<Product2>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            List<Response> results = (List<Response>) JSON.deserialize(response.getBody(),List<Response>.class);
            System.debug(results);

            for (Response item : results) {
                Product2 newProduct = new Product2();
                newProduct.ProductCode = item.Id;
                newProduct.Replacement_Part__c = item.Replacement;
                newProduct.Current_Inventory__c = item.Quantity;
                newProduct.Name = item.Name;
                newProduct.Maintenance_Cycle__c = item.Maintenanceperiod;
                newProduct.Lifespan_Months__c = item.Lifespan;
                newProduct.Cost__c = item.Cost;
                newProduct.Warehouse_SKU__c = item.Sku;

                products.add(newProduct);
            }
            upsert products;
        }
    }

    public class Response {
        public String Id;
        public Boolean Replacement;
        public Integer Quantity;
        public String Name;
        public Integer Maintenanceperiod;
        public Integer Lifespan;
        public Decimal Cost;
        public String Sku;
    }

    public static void execute (QueueableContext context){
        startWarehouseCallout();

    }
}