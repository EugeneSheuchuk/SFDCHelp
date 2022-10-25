@isTest
public class EveryMinuteSchedulerTest {
    @isTest
    public static void EveryMinuteSchedulerTest() {
        Test.startTest();
        String sch = '0 1 * * * ?';
        EveryMinuteScheduler scheduler = new EveryMinuteScheduler();
        System.schedule('Every minutes batch Test to attach file', sch, scheduler);
        Test.stopTest();
    }
}
