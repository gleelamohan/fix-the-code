import { LightningElement, track, wire } from 'lwc';
import getPendingAccounts from '@salesforce/apex/CustomerOnboardingService.getPendingAccounts';
import onboardCustomers from '@salesforce/apex/CustomerOnboardingService.onboardCustomers';

export default class OnboardingWizard extends LightningElement {
    
    @track accounts;
    @track error;

    @wire(getPendingAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data; 
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    handleOnboard() {
        let accIds = [];
        for(let i=0; i<this.accounts.length; i++){
            accIds.push(this.accounts[i].Id);
        }

        onboardCustomers({ accountIds: accIds })
            .then(result => {
                alert('Onboarding Complete: ' + result); 
                
                this.accounts.length = 0; 
            });
    }
}
