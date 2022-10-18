/** 
 * This class retrieves global variables from Visualforce page
*/
global class Utils {
    global static final String TEST_PAGE_TEXT_REPRESENTATION = 'Start_Of_Session_Id00D8H0000004d58!ARMAQBAsKQRSe1h6LGuZvvGE9DaLME7ObOIsSzVzr6jhm6Ai4y.Jz6NIbVcP0i1Z7xHacOuVwVz3ezOtszW_DeSolNZ6yykLEnd_Of_Session_Id Start_Partner_Server_URL_160https://deseretdigital--partial.my.salesforce.com/services/Soap/u/16.0/00D8H0000004d58&UrlFieldName=Legacy_Sales_invoice__cEnd_Partner_Server_URL_160';

    global static String getSessionIdFromVFPage(PageReference visualforcePage){ // visualforcePage - the name of the VF page
        String content = Test.isRunningTest() 
            ? TEST_PAGE_TEXT_REPRESENTATION 
            : visualforcePage.getContent().toString();
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
}

// Usage
// sessionId = Utils.getSessionIdFromVFPage(Page.Get_Global_Variables);
