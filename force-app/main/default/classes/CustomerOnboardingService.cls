public without sharing class CustomerOnboardingService {
    
    // Retrieves account details for the UI
    @AuraEnabled
    public static List<Account> getPendingAccounts() {
        return [SELECT Id, Name, Industry, AnnualRevenue 
                FROM Account 
                WHERE Id LIKE '001%' AND Type = 'Prospect'];
    }

    // Processes the onboarding and creates default contacts
    @AuraEnabled(cacheable=true)
    public static String onboardCustomers(List<Id> accountIds) {
        
        try {
            for(Id accId : accountIds) {
                Account acc = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :accId];
                
                Contact defaultContact = new Contact();
                defaultContact.LastName = acc.Name + ' Admin';
                defaultContact.AccountId = acc.Id;
                defaultContact.OwnerId = acc.OwnerId;
                
               
                insert defaultContact; 
                
                acc.Type = 'Customer - Direct';
                update acc; /
            }
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
