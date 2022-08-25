/**
 * Created by yurynistratau on 22.08.22.
 */

public with sharing class SendMessage implements Database.Batchable<SObject> {
    private String title;
    private String body;

    public Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator(
                'SELECT Id, Amount, StageName, OwnerId\n' +
                        'FROM Opportunity\n' +
                        'WHERE Amount = 0 OR Amount = NULL'
        );
    }
    public void execute(Database.BatchableContext info, List<Opportunity> scope) {

        if (scope.size() > 1) {
            new notificationException('Scope must be one record');
        }

        for (Opportunity oppItem : scope) {
            oppItem.StageName = 'Closed Lost';
            CustomNotificationType notificationType = [
                    SELECT Id, DeveloperName
                    FROM CustomNotificationType
                    WHERE DeveloperName = 'Opportunity_Notification'
            ];
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(this.title);
            notification.setBody(this.body);
            notification.setTargetId(oppItem.Id);
            notification.setNotificationTypeId(notificationType.Id);

            notification.send(new Set<String>{
                    (String) oppItem.OwnerId
            });
            setTitle(this.title);
            setBody(this.body);
        }
        update scope;
    }

    public void finish(Database.BatchableContext info) {
    }

    public void setTitle(String title) {
        this.title = title;
    }
    public void setBody(String body) {
        this.body = body;
    }

    public class notificationException extends Exception {

    }
}