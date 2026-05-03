import { LightningElement } from 'lwc';

export default class OnboardingWizard extends LightningElement {
    currentStep = 1;
    totalSteps = 3;

    handleNext() {
        if (this.currentStep < this.totalSteps) {
            this.currentStep++;
        }
    }

    handlePrevious() {
        if (this.currentStep > 1) {
            this.currentStep--;
        }
    }

    handleFinish() {
        // Handle wizard completion
        this.dispatchEvent(new CustomEvent('wizardcomplete'));
    }

    get isFirstStep() {
        return this.currentStep === 1;
    }

    get isLastStep() {
        return this.currentStep === this.totalSteps;
    }
}
