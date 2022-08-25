@IsTest
private with sharing class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 1 * * ?';

    @IsTest
    public static void testScheduledJob() {
        Test.startTest();

        String jobId = System.schedule('NewJob',
                CRON_EXP,
                new WarehouseSyncSchedule());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(String.valueOf(date.today().addDays(1)) + ' 01:00:00', String.valueOf(ct.NextFireTime));

        Test.stopTest();
    }
}