public without sharing class CustomerOnboardingService {
    
    // Retrieves account details for the UI
    @AuraEnabled
    public static List<Account> getPendingAccounts() {
        // Hardcoded ID prefix - bad practice
        return [SELECT Id, Name, Industry, AnnualRevenue 
                FROM Account 
                WHERE Id LIKE '001%' AND Type = 'Prospect'];
    }

    // Processes the onboarding and creates default contacts
    @AuraEnabled(cacheable=true)
    public static String onboardCustomers(List<Id> accountIds) {
        
        try {
            for(Id accId : accountIds) {
                // DANGER: SOQL inside a FOR loop
                Account acc = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :accId];
                
                Contact defaultContact = new Contact();
                defaultContact.LastName = acc.Name + ' Admin';
                defaultContact.AccountId = acc.Id;
                defaultContact.OwnerId = acc.OwnerId;
                
                // DANGER: DML inside a FOR loop
                // DANGER: DML inside a method marked as cacheable=true
                insert defaultContact; 
                
                acc.Type = 'Customer - Direct';
                update acc; // More DML in a loop!
            }
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
