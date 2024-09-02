// import { LightningElement, track } from 'lwc';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import saveEmailReceiver from '@salesforce/apex/EmailReceiverController.saveEmailReceiver';

// export default class EmailReceiverForm extends LightningElement {
//     @track firstName = '';
//     @track lastName = '';
//     @track email = '';
//     @track phone = '';

//     handleInputChange(event) {
//         const field = event.target.dataset.id;
//         if (field === 'firstName') {
//             this.firstName = event.target.value;
//         } else if (field === 'lastName') {
//             this.lastName = event.target.value;
//         } else if (field === 'email') {
//             this.email = event.target.value;
//         } else if (field === 'phone') {
//             this.phone = event.target.value;
//         }
//     }

//     handleSubmit() {
//         const fieldsAreValid = [...this.template.querySelectorAll('lightning-input')]
//             .reduce((valid, input) => valid && input.reportValidity(), true);

//         if (fieldsAreValid) {
//             saveEmailReceiver({
//                 firstName: this.firstName,
//                 lastName: this.lastName,
//                 email: this.email,
//                 phone: this.phone
//             })
//             .then(() => {
//                 this.dispatchEvent(
//                     new ShowToastEvent({
//                         title: 'Success',
//                         message: 'Brochure request submitted successfully.',
//                         variant: 'success',
//                     }),
//                 );
//                 this.handleResetForm();
//             })
//             .catch(error => {
//                 this.dispatchEvent(
//                     new ShowToastEvent({
//                         title: 'Error',
//                         message: error.body.message,
//                         variant: 'error',
//                     }),
//                 );
//             });
//         }
//     }

//     handleResetForm() {
//         this.firstName = '';
//         this.lastName = '';
//         this.email = '';
//         this.phone = '';
//     }
// }

import { LightningElement, track } from 'lwc';
import saveEmailReceiver from '@salesforce/apex/EmailReceiverController.saveEmailReceiver';
import sweetalert from '@salesforce/resourceUrl/sweetalert';
import { loadScript } from 'lightning/platformResourceLoader';

export default class EmailReceiverForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track phone = '';

    sweetAlertLoaded = false;

    renderedCallback() {
        if (this.sweetAlertLoaded) {
            return;
        }

        this.sweetAlertLoaded = true;

        loadScript(this, sweetalert)
            .then(() => {
                console.log('SweetAlert library loaded successfully.');
            })
            .catch(error => {
                console.error('Error loading SweetAlert library', error);
            });
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'firstName') {
            this.firstName = event.target.value;
        } else if (field === 'lastName') {
            this.lastName = event.target.value;
        } else if (field === 'email') {
            this.email = event.target.value;
        } else if (field === 'phone') {
            this.phone = event.target.value;
        }
    }

    handleSubmit() {
        // Ensure all fields are valid before proceeding
        const fieldsAreValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((valid, input) => valid && input.reportValidity(), true);

        if (fieldsAreValid) {
            saveEmailReceiver({
                firstName: this.firstName,
                lastName: this.lastName,
                email: this.email,
                phone: this.phone
            })
            .then(() => {
                this.showSuccessAlert();
                this.handleResetForm();
            })
            .catch(error => {
                this.handleError(error);
            });
        }
    }

    handleError(error) {
        let errorMessage = 'An unknown error occurred';

        if (error && error.body && error.body.message) {
            errorMessage = error.body.message;
        } else if (error && error.message) {
            errorMessage = error.message;
        }

        this.showErrorAlert(errorMessage);
    }

    showSuccessAlert() {
        swal({
            title: "Thank you!",
            text: "You will receive the pdf on your email shortly.",
            icon: "success",
            button: "Close",
        });
    }

    showErrorAlert(message) {
        swal({
            title: "Error!",
            text: message,
            icon: "error",
            button: "Close",
        });
    }

    handleResetForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.phone = '';
    }
}