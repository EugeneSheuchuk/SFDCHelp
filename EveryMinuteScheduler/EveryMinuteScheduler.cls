global class EveryMinuteScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        BatchClass btc = new BatchClass();
        Id batchId = Database.executeBatch(btc);

        List<CronTrigger> avaliableCrons = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'Every minutes batch'];
        if (avaliableCrons.size() == 1) {
            System.abortJob(avaliableCrons[0].Id);
        }

        Datetime currentTime = Datetime.now();
        String sch = '0 ' + (currentTime.minute() + 1) + ' * * * ?';
        AttachFileToReferralScheduler attachFileScheduler = new AttachFileToReferralScheduler();
        System.schedule('Every minutes batch', sch, attachFileScheduler);
    }
}
