/**
 * Created by yurynistratau on 24.08.22.
 */

public with sharing class RateCurrency implements Database.Batchable<SObject> {

    public List<Date> start(Database.BatchableContext info){
        List<Date> dates = new List<Date>();
        for (Date i = Date.today(); i > Date.today().addYears(-5); i = i-1) {
            dates.add(i);
        }
        return dates;
    }
    public void execute(Database.BatchableContext info, List<Date> scope) {
        List<Rate_Currency__c> rateCurrencies = new List<Rate_Currency__c>();
        for (Date item : scope) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://www.nbrb.by/api/exrates/rates?ondate=2016-7-6&periodicity=0');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
                List<Response> results = (List<Response>) JSON.deserializeUntyped(response.getBody());
                for (Response response2 : results) {
                    Rate_Currency__c rateCurrency = new Rate_Currency__c();
                    rateCurrency.Name = response2.Cur_Name;
                    rateCurrency.Abbreviation__c = response2.Cur_Abbreviation;
                    rateCurrency.Rate__c = response2.Cur_OfficialRate;
                    rateCurrency.Date_of_Rate__c = response2.Date;
                    rateCurrencies.add(rateCurrency);
                }
            }
        }
        insert rateCurrencies;
    }
    public void finish(Database.BatchableContext info){
    }

    public class Response{
        String Cur_Name;
        String Cur_Abbreviation;
        Decimal Cur_OfficialRate;
        Date Date;
    }
}