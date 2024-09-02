/**
* @File Name : EmailReceiverController.cls

* @Description : The EmailReceiverController Apex class facilitates saving user form data and sending a confirmation email with a PDF attachment. It defines two methods: saveEmailReceiver and sendEmailWithAttachmentLink. The saveEmailReceiver method saves user details (first name, last name, email, and phone) to the custom object Email_Receiver__c and triggers an email with a PDF link. The sendEmailWithAttachmentLink method creates an email message with a subject and HTML body, including a link to a PDF stored as a static resource in Salesforce. It sends the email and inspects the result for success or failure. Errors are caught and handled with appropriate debug logging and exceptions.

* @Author : Aslam Ali

* @Last Modified By :Aslam Ali

* @Last Modified On : September 2, 2024

* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 2, 2024 |   | Initial Version
**/

public with sharing class EmailReceiverController {
    @AuraEnabled
    public static void saveEmailReceiver(String firstName, String lastName, String email, String phone) {
        try {
            // Save the form data to the custom object
            Email_Receiver__c receiver = new Email_Receiver__c();
            receiver.First_Name__c = firstName;
            receiver.Last_Name__c = lastName;
            receiver.Email__c = email;
            receiver.Phone__c = phone;
            insert receiver;

            // Send an email with an attachment
            sendEmailWithAttachment(email);
        } catch (Exception e) {
            System.debug('Error in saveEmailReceiver: ' + e.getMessage());
        }
    }

    private static void sendEmailWithAttachment(String recipientEmail) {
        try {
            // Query the static resource file
            StaticResource salesforceNotes = [SELECT Id, Body FROM StaticResource WHERE Name = 'salesforce_notes_25' LIMIT 1];

            // Create an email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { recipientEmail });
            email.setSubject('Thank you for downloading our brochure');
            email.setHtmlBody('<p>Dear Customer,</p><p>Thank you for your interest! Please find the attached brochure.</p><p>Best regards,<br>Your Company</p>');

            // Convert the static resource to a Blob
            Blob attachmentBlob = salesforceNotes.Body;
            // Create an attachment
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('Salesforce_Notes.pdf');
            attachment.setBody(attachmentBlob);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

            // Send the email and inspect results
            Messaging.SingleEmailMessage[] emailList = new Messaging.SingleEmailMessage[] { email };
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);

            // Call a helper method to inspect the returned results
            Boolean sendResult = inspectResults(results);
            if (!sendResult) {
                System.debug('Email sending failed.');
            }

        } catch (Exception e) {
            System.debug('Error in sendEmailWithAttachment: ' + e.getMessage());
        }
    }

    // Helper method to inspect results
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // Iterate through the list to inspect results.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());
            }
        }
        return sendResult;
    }
}*/

public class EmailReceiverController {
    @AuraEnabled
    public static void saveEmailReceiver(String firstName, String lastName, String email, String phone) {
        try {
            // Save the form data to the custom object
            Email_Receiver__c receiver = new Email_Receiver__c();
            receiver.First_Name__c = firstName;
            receiver.Last_Name__c = lastName;
            receiver.Email__c = email;
            receiver.Phone__c = phone;
            insert receiver;

            // Send an email with a link to the PDF attachment
            sendEmailWithAttachmentLink(email);
        } catch (Exception e) {
            System.debug('Error in saveEmailReceiver: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());  // Return error to the client
        }
    }

    private static void sendEmailWithAttachmentLink(String recipientEmail) {
        try {
            // Create an email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setUseSignature(false);
            email.setSaveAsActivity(true);
            email.setSubject('Thank you for downloading our brochure');
            email.setToAddresses(new String[] { recipientEmail });

            // Generate a link to the static resource (PDF file)
            String fileLink = 'https://aress-8c-dev-ed.develop.file.force.com/servlet/servlet.EmailAttachmentDownload?q=UFA21uIrMgELm7pe8sVXLw%2FIG2LRGOi8BHojzi5CNv1qZ6VCLcwKLSKmC3h2nbN%2F345NwGUG1YAJINJi7Abfqw%3D%3D';
            String emailBody = '<html><body>' +
                'Dear Customer,<br><br>' +
                'Thank you for your interest! Please download the brochure using the following link:<br><br>' +
                '<a href="' + fileLink + '">Download the brochure</a><br><br>' +
                'Best regards,<br>Your Company' +
                '</body></html>';
            email.setHtmlBody(emailBody);

            // Send the email
            Messaging.SingleEmailMessage[] emailList = new Messaging.SingleEmailMessage[] {email};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);

            // Inspect the results
            Boolean sendResult = inspectResults(results);
            if (!sendResult) {
                System.debug('Email sending failed.');
            }

        } catch (Exception e) {
            System.debug('Error in sendEmailWithAttachmentLink: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());  // Return error to the client
        }
    }

    // Helper method to inspect results
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());
            }
        }
        return sendResult;
    }
}