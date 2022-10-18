/** 
 * This class contains useful methods
*/
public class Utils {

    // Retrieve data from the related object of the selected record
    // Получение данных из связанного объекта выбранной записи
    public static String getRelatedRecordField () {
        Contact cont = [Select Id, Account.Name FROM Contact LIMIT 1][0];
        if (cont.getSobject('Account') != null) {
            return cont.getSobject('Account').get('Name');
        }
        return null;
    }

    // The method allows to get picklist values as Map<Label, Value> by passing the API object name and the list of API name of picklist fields
    // Метод позволяет получить значения раскрывающегося списка в виде Map<Label, Value> путем передачи имени объекта API и списка АПИ имен полей раскрывающегося списка.
    public static final List<String> picklistFieldAPINames = new List<String>{'FieldOne__c', 'FieldTwo__c'}; // Picklist fields APINames
    public static Map<String, Map<String, String>> getPickListValues(String sObjectAPIName, List<String> picklistFieldAPINames) {
        Map<String, Map<String, String>> response = new Map<String, Map<String, String>>();
        SObjectType sobjectValue = Schema.getGlobalDescribe().get(sObjectAPIName);
        Map<String, Schema.SObjectField> fieldMap = sobjectValue.getDescribe().fields.getMap();

        for (String fieldAPIName : picklistFieldAPINames) {
            Map<String, String> mappedValues = new Map<String, String>();
            Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldAPIName).getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                if (picklistEntry.isActive()) {
                    mappedValues.put(picklistEntry.getLabel(), picklistEntry.getValue());
                }
            }
            response.put(fieldAPIName, mappedValues);
        }
    }
}
