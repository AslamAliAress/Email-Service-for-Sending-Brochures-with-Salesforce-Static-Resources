# Use  sweetalert.js in LWC                                                                                                


  ![image](https://github.com/user-attachments/assets/8fff1e20-95ca-4ea6-ae66-15e9aa59f48d)

![image](https://github.com/user-attachments/assets/edb76d96-9c76-49f6-ab1b-ecd05cbe6e33)

# Using SweetAlert in LWC

- Install SweetAlert:

- Include the SweetAlert library in your LWC. Use the CDN link(https://cdnjs.com/libraries/sweetalert) to include SweetAlert in your component: 

![image](https://github.com/user-attachments/assets/fbc6004e-4b06-461e-af26-d0cc02027f40)

# Setup

1. Custom Object Setup:

Ensure you have the custom object Email_Receiver__c created with fields:
First_Name__c (Text)
Last_Name__c (Text)
Email__c (Email)
Phone__c (Phone)

2. Static Resource:

Upload your PDF file (e.g., salesforce_notes_25.pdf) to Salesforce as a static resource named salesforce_notes_25.


![image](https://github.com/user-attachments/assets/4995a396-8f0a-4a92-bb07-75146ab425a8)

3. Email Configuration:

Update the fileLink variable in sendEmailWithAttachmentLink with the correct URL to the static resource.
Deploy Code:

4. Deploy the EmailReceiverController Apex class to your Salesforce org.

# Usage

1. Lightning Web Component (LWC):

Use this Apex class with an LWC that collects user input and calls the saveEmailReceiver method to save the data and send the email.

2. Testing:

Test the functionality by submitting the form in your LWC and ensuring that the data is saved in the Email_Receiver__c object and that the email is sent with the correct link to the PDF.
Troubleshooting
Email Not Sending: Check the email address and ensure the static resource URL is correct.
Error Handling: Review debug logs for any exceptions thrown during execution.



# Output

https://github.com/user-attachments/assets/56bfca91-6956-438d-b71a-114f3188d8fa



