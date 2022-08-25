/**
 * Created by yurynistratau on 19.08.22.
 */

public with sharing class ContactDeleteBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext info){
        return Database.getQueryLocator(
                'SELECT ID FROM Contact WHERE Account.Name = \'Salesforce\''
        );
    }
    public void execute(Database.BatchableContext info, List<SObject> scope) {
        delete scope;
    }
    public void finish(Database.BatchableContext info){
    }
}