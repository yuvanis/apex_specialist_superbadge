/**
 * Created by yurynistratau on 19.08.22.
 */
@isTest
public with sharing class ContactDeleteBatchTest {
    @IsTest
    static void testBatch() {
        Account acc = new Account(Name = 'Salesforce');
        insert acc;
        Id accId = acc.Id;
        List<Contact> listContact = new List<Contact>();
        for (Integer i = 0; i < 999; i++) {
            Contact newContact = new Contact(FirstName = 'Test', LastName ='Test', AccountId = accId);
            listContact.add(newContact);
        }
        insert listContact;

        Test.startTest();
        Database.executeBatch(new ContactDeleteBatch(),2000);
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE Account.Name = 'Salesforce']);
    }
}