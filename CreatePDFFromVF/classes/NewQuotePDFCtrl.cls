/**
 * Test class is CreateQuotePDFTest
 */

public class NewQuotePDFCtrl {
    public String quoteNumber { get; set; }
    public String expiryDate { get; set; }
    public Decimal annualPremium { get; set; }
    public Decimal annualEmergencyServicesLevy { get; set; }
    public Decimal monthlyPremium { get; set; }
    public Decimal totalPremium { get; set; }
    public Decimal totalEmergencyServicesLevy { get; set; }
    public Decimal emergencyServicesLevy { get; set; }
    public Decimal agreedAmount { get; set; }
    public Decimal excess { get; set; }
    public Decimal optionalExcess { get; set; }
    public String glassCover { get; set; }
    public String rentalCarCover { get; set; }
    public Decimal ageExcess { get; set; }
    public Decimal licenceExcess { get; set; }
    public Decimal undisclosedDriverExcess { get; set; }
    public String carInfo { get; set; }
    public String registrationNumber { get; set; }
    public String mainDriverGender { get; set; }
    public String mainDriverDateOfBirth { get; set; }
    public Decimal mainDriverAgeLicenceObtained { get; set; }
    public String mainDriverAddress { get; set; }
    public List<String> accessories { get; set; }
    public String vehicleUsage { get; set; }
    public String claimsAmount { get; set; }
    public String claimsTypes { get; set; }

    public Boolean isDriversUnder25 { get; set; }
    public Boolean isDriversUnder25HaveOwnVehicle { get; set; }
    public Boolean isLicenceHeldMoreThan2Years { get; set; }
    public Boolean isLicenceSuspended { get; set; }
    public Boolean isAnyMotorVehicleClaimsWithExcess { get; set; }
    public Boolean isMoreThanOneClaim { get; set; }

    // set default values
    {
        isDriversUnder25 = false;
        isDriversUnder25HaveOwnVehicle = false;
        isLicenceHeldMoreThan2Years = false;
        isLicenceSuspended = false;
        isAnyMotorVehicleClaimsWithExcess = false;
        claimsAmount = '0';
        isMoreThanOneClaim = false;
        claimsTypes = '';
    }

    public NewQuotePDFCtrl() {
        String quoteId = System.currentPagereference().getParameters().get('id');
        System.debug('quoteId ' + quoteId);
        List<Quote__c> quotes = [
            SELECT
                Name,
                Expiry_Date__c,
                Retail_Gross_Annual__c,
                Retail_FSL_Annual__c,
                Retail_Monthly_Instalment__c,
                retail_fsl__c,
                Base_excess__c,
                Optional_Excess__c,
                Glass_Cover__c,
                Rental_Car_Cover__c,
                Age_Excess__c,
                Licence_Excess__c,
                Undisclosed_Driver_Excess__c,
                Derivative__r.Name,
                Registration_Number__c,
                Main_Driver_Gender__c,
                Main_Driver_Date_Of_Birth__c,
                Main_Driver_Age_Licence_Obtained__c,
                Risk_Address_Canonical__c,
                Vehicle_Agreed_Value__c,
                Vehicle_info__c,
                toLabel(Vehicle_Usage__c)
            FROM Quote__c
            WHERE Id = :quoteId
        ];

        if (quotes.size() > 0) {
            Quote__c currentQuote = quotes[0];
            quoteNumber = currentQuote.Name;
            expiryDate = currentQuote.Expiry_Date__c.format();
            annualPremium = currentQuote.Retail_Gross_Annual__c == null ? 0 : currentQuote.Retail_Gross_Annual__c;
            annualEmergencyServicesLevy = currentQuote.Retail_FSL_Annual__c == null ? 0 : currentQuote.Retail_FSL_Annual__c;
            monthlyPremium = currentQuote.Retail_Monthly_Instalment__c == null ? 0 : currentQuote.Retail_Monthly_Instalment__c;
            totalPremium = (monthlyPremium * 12).setScale(2);
            emergencyServicesLevy = currentQuote.retail_fsl__c == null ? 0 : (currentQuote.retail_fsl__c / 12).setScale(2);
            totalEmergencyServicesLevy = currentQuote.retail_fsl__c == null ? 0 : currentQuote.retail_fsl__c;
            agreedAmount = currentQuote.Vehicle_Agreed_Value__c == null ? 0 : currentQuote.Vehicle_Agreed_Value__c;
            excess = currentQuote.Base_excess__c == null ? 0 : currentQuote.Base_excess__c;
            optionalExcess = currentQuote.Optional_Excess__c;
            glassCover = currentQuote.Glass_Cover__c;
            rentalCarCover = currentQuote.Rental_Car_Cover__c;
            ageExcess = currentQuote.Age_Excess__c == null ? 0 : currentQuote.Age_Excess__c;
            licenceExcess = currentQuote.Licence_Excess__c == null ? 0 : currentQuote.Licence_Excess__c;
            undisclosedDriverExcess = currentQuote.Undisclosed_Driver_Excess__c == null ? 0 : currentQuote.Undisclosed_Driver_Excess__c;
            carInfo = currentQuote.Vehicle_info__c;
            registrationNumber = currentQuote.Registration_Number__c;
            mainDriverGender = currentQuote.Main_Driver_Gender__c;
            mainDriverDateOfBirth = currentQuote.Main_Driver_Date_Of_Birth__c.format();
            mainDriverAgeLicenceObtained = currentQuote.Main_Driver_Age_Licence_Obtained__c == null
                ? null
                : Math.round(currentQuote.Main_Driver_Age_Licence_Obtained__c);
            mainDriverAddress = currentQuote.Risk_Address_Canonical__c;
            vehicleUsage = currentQuote.Vehicle_Usage__c;
        }

        accessories = new List<String>();
        for (Quote_Accessory__c quoteAccessory : [SELECT Accessory_Type__r.Name FROM Quote_Accessory__c WHERE Quote__c = :quoteId]) {
            if (quoteAccessory.getSobject('Accessory_Type__r') != null) {
                accessories.add(String.valueOf((quoteAccessory.getSobject('Accessory_Type__r').get('Name'))));
            }
        }

        Map<String, String> mappedAnswers = new Map<String, String>();
        for (Underwriting_Answer__c answer : [
            SELECT Underwriting_Question__r.Name, Underwriting_Picklist_Value__r.Name, Value_If_Question_Is_Checkbox__c
            FROM Underwriting_Answer__c
            WHERE Quote__c = :quoteId
        ]) {
            if (answer.getSobject('Underwriting_Question__r') != null) {
                String question = String.valueOf((answer.getSobject('Underwriting_Question__r').get('Name')));
                String ans = answer.getSobject('Underwriting_Picklist_Value__r') != null
                    ? String.valueOf((answer.getSobject('Underwriting_Picklist_Value__r').get('Name')))
                    : 'No';
                mappedAnswers.put(question, ans);
            }
        }

        for (String question : mappedAnswers.keySet()) {
            switch on question {
                when 'Drivers Under 25' {
                    isDriversUnder25 = mappedAnswers.get(question) == 'Yes';
                }
                when 'Under 25 Has Own Vehicle' {
                    isDriversUnder25HaveOwnVehicle = mappedAnswers.get(question) == 'Yes';
                }
                when 'Licence Held More Than 2 Years' {
                    isLicenceHeldMoreThan2Years = mappedAnswers.get(question) == 'Yes';
                }
                when 'Licence Suspended' {
                    isLicenceSuspended = mappedAnswers.get(question) == 'Yes';
                }
                when 'Any Motor Vehicle Claims With Excess' {
                    isAnyMotorVehicleClaimsWithExcess = mappedAnswers.get(question) == 'Yes';
                }
                when 'How Many Claims' {
                    claimsAmount = String.valueOf(mappedAnswers.get(question));
                    isMoreThanOneClaim = Integer.valueOf(mappedAnswers.get(question)) > 1;
                    for (String q : mappedAnswers.keySet()) {
                        if (q.contains('Claim Type')) {
                            claimsTypes += String.valueOf(mappedAnswers.get(q)) + '; ';
                        }
                    }
                    claimsTypes = claimsTypes.substring(0, claimsTypes.length() - 2);
                }
            }
        }
    }
}
