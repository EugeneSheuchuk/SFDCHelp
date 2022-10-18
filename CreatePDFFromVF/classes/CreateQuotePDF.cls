public class CreateQuotePDF {
    public static String generate(String quoteId) {
        PageReference quotePage = new Pagereference('/apex/NewQuotePDF');
        quotePage.getParameters().put('id', quoteId);

        ContentVersion cont = new ContentVersion(Title = 'New Quote from ' + System.now(), PathOnClient = 'qute' + System.now() + '.pdf');
        cont.VersionData = Test.isRunningTest() ? blob.valueOf('Unit.Test') : quotePage.getContentAsPdf();

        insert cont;

        Id contDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE id = :cont.Id].ContentDocumentId;

        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = contDocId,
            LinkedEntityId = quoteId,
            ShareType = 'I',
            Visibility = 'AllUsers'
        );
        insert contentLink;

        return contDocId;
    }
}
