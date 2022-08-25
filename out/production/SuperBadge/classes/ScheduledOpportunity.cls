/**
 * Created by yurynistratau on 22.08.22.
 */

global class ScheduledOpportunity implements Schedulable {
    public void execute(SchedulableContext ctx) {
        SendMessage sendMessage = new SendMessage();
        Database.executeBatch(sendMessage, 1);
    }
}