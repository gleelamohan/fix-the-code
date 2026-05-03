public with sharing class CustomerOnboardingService {
    
    /**
     * Retrieves a list of accounts that are pending onboarding
     * @return List of Account records with pending status
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getPendingAccounts() {
        try {
            return [
                SELECT Id, Name, Industry, Phone, Website, BillingCity, BillingState, BillingCountry
                FROM Account
                WHERE Industry = 'Pending' OR (Custom_Status__c = 'Pending Onboarding')
                LIMIT 100
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving pending accounts: ' + e.getMessage());
        }
    }
    
    /**
     * Processes onboarding for selected customer accounts
     * @param accountIds List of Account IDs to onboard
     * @return String confirmation message
     */
    @AuraEnabled
    public static String onboardCustomers(List<Id> accountIds) {
        try {
            if (accountIds == null || accountIds.isEmpty()) {
                throw new IllegalArgumentException('Account IDs cannot be empty');
            }
            
            List<Account> accountsToUpdate = [
                SELECT Id, Name
                FROM Account
                WHERE Id IN :accountIds
            ];
            
            if (accountsToUpdate.isEmpty()) {
                throw new AuraHandledException('No accounts found for the provided IDs');
            }
            
            // Update accounts with onboarding status
            for (Account acc : accountsToUpdate) {
                acc.Industry = 'Onboarded';
                // acc.Custom_Status__c = 'Onboarded'; // Uncomment if custom field exists
            }
            
            update accountsToUpdate;
            
            return 'Successfully onboarded ' + accountsToUpdate.size() + ' account(s)';
        } catch (IllegalArgumentException e) {
            throw new AuraHandledException(e.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Error onboarding customers: ' + e.getMessage());
        }
    }
}
