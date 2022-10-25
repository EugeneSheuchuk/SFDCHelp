# SFDCHelp

## Get session id in Apex throw VF page
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/VF_SessionId)

## Create PDF file from VF page, attach it to the record and return contentDocumentId
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/CreatePDFFromVF)

## Scheduler that runs every minute
[Source](https://github.com/EugeneSheuchuk/SFDCHelp/tree/master/CreatePDFFromVF)

## Apex help methods

#### - getRelatedRecordField
Retrieve data from the related object of the selected record // Получение данных из связанного объекта выбранной записи
```
record.getSobject('ObjectName').get('FieldName');
```
#### - getPickListValues
Get all picklist values // Получить все значения пиклиста