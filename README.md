# SFDCHelp

## Get session id in Apex throw VF page
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/VF_SessionId)

## Create PDF file from VF page, attach it to the record and return contentDocumentId
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/CreatePDFFromVF)

## Scheduler that runs every minute
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/EveryMinuteScheduler)

## Apex help methods

#### - getRelatedRecordField
Retrieve data from the related object of the selected record // Получение данных из связанного объекта выбранной записи
```
record.getSobject('ObjectName').get('FieldName');
```
#### - getPickListValues
Get all picklist values // Получить все значения пиклиста


## CometD with LWC
[Help post](https://www.sfdcbox.com/2021/02/cometd.html)\
[Streaming API docs](https://blog.bessereau.eu/assets/pdfs/api_streaming.pdf) - see page 35

## URL hacking - populating default value
```
/lightning/o/REO__c/new?defaultFieldValues=Application__c={!Borrower__c.ApplicationId__c},Borrower__c={!Borrower__c.Id}
```

## Redirect internal user from any internal page to another
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/HiddenListeningComponent/aura/HiddenListeningCmp)

## Get User ACCESS TOKEN via developer console
```
System.debug(UserInfo.getOrganizationId().substring(0, 15) + '  ' +  UserInfo.getSessionId().substring(15));
```

## Debug System User
1) Get System User Id
```
SELECT Id, Name FROM User
```
2) Get DebugLevelId (Use tooling api)
```
SELECT Id, DebugLevelId, LogType FROM TraceFlag LIMIT 200
```
3) Workbench request URL
```
/services/data/v56.0/tooling/sobjects/TraceFlag/
```
4) Workbench request Body
```
{
"TracedEntityId" : "0056e00000CwXNhAAN",
"DebugLevelId" : "7dl2A000000Cb6FQAS",
"LogType" : "USER_DEBUG",
"StartDate" : "2022-12-28T12:00:01.000+0000",
"ExpirationDate" : "2022-12-29T12:00:00.000+0000"
}
```

## Fast clearing SF logs from VSCode console
```
sfdx force:data:query -t -q "SELECT Id FROM ApexLog" -r "csv" > out.csv
sfdx force:data:bulk:delete -s ApexLog -f out.csv
```

## Force reload SF page without reloading browser tab
```
eval("$A.get('e.force:refreshView').fire();");
```

## Custom address with dependent picklists
[Source](https://beyondthecloud.dev/blog/country-state-dependent-picklist-in-apex)

## Login to the org by SID key
https://example.sandbox.my.salesforce.com/secur/frontdoor.jsp?sid=exampleSID

## Connect VSCode to the org via SID key (works until the key expires)
1) If first connection then use SFDC: Authorize an Org using Session Id for creating an alias, esle go to the step 2;
2) sf org login access-token --instance-url https://example.sandbox.my.salesforce.com;
3) Enter a SID key.

