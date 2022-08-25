/**
 * Created by yurynistratau on 19.08.22.
 */

public with sharing class AccountContactBatch implements Database.Batchable<SObject> {
    AccountContactBuilder accountContactBuilder = new AccountContactBuilder();
    private Id accountId;

    public AccountContactBatch(Id newId) {
        this.accountId = newId;
    }

    public Iterable<SObject> start(Database.BatchableContext batch){
        return accountContactBuilder.createContacts(this.accountId);
    }
    public void execute(Database.BatchableContext info, List<SObject> scope) {
        insert scope;
    }
    public void finish(Database.BatchableContext batch){
    }
}