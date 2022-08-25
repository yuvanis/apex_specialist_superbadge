/**
 * Created by yurynistratau on 22.08.22.
 */

public class UpdateOpportunity implements Queueable {
    public void execute(QueueableContext context) {
        Set<Id> ownerIds = new Set<Id>();
        List<Opportunity> oppList = [
                SELECT Id, Amount, StageName, OwnerId
                FROM Opportunity
                WHERE Amount = 0 OR Amount = NULL
        ];
        for (Opportunity oppItem : oppList) {
            oppItem.StageName = 'Closed Lost';
            ownerIds.add(oppItem.OwnerId);
        }
        update oppList;
        SendMessage sendMessage = new SendMessage();
        sendMessage.setTitle('Opportunity is closed');
        sendMessage.setBody('Amount is empty or equal to 0');
        sendMessage.setData(oppList);
        Database.executeBatch(new SendMessage(),1);    }
}