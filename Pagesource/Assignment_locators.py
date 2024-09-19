from PIL import Image
import email
import imaplib
global workbook

#login form locators
login_button_bottommenu = '//androidx.appcompat.widget.LinearLayoutCompat[@resource-id="com.gsoc.app.staging:id/llc_container"][5]'
login_button_welcome_screen = '//android.widget.Button[@resource-id="com.gsoc.app.staging:id/btn_login"]'
login_email_address_field = '//android.widget.EditText[@resource-id="com.gsoc.app.staging:id/edt_emailAddress"]'
login_screen_OTP_field = '//android.widget.EditText[@resource-id="com.gsoc.app.staging:id/pin"]'
login_screen_verifyotp_button = '//android.widget.Button[@resource-id="com.gsoc.app.staging:id/btn_verify"]'
complete_first_name_field = '//android.widget.EditText[@resource-id="com.gsoc.app.staging:id/edt_Firstname"]'
complete_last_name_field = '//android.widget.EditText[@resource-id="com.gsoc.app.staging:id/edt_lastName"]'
complete_profile_continue_button = '//android.widget.Button[@resource-id="com.gsoc.app.staging:id/btn_continue"]'
complete_profile_popup_profile_button = '//android.widget.Button[@resource-id="com.gsoc.app.staging:id/btn_profile"]'


def delete_all_emails_inbox(server, port, email_address, password):
    mail = imaplib.IMAP4_SSL(server, port)
    mail.login(email_address, password)
    mail.select('inbox')

    # Search for all emails in the inbox
    result, data = mail.search(None, "ALL")
    email_ids = data[0].split()

    # Delete all emails
    for email_id in email_ids:
        mail.store(email_id, '+FLAGS', '\\Deleted')
    mail.expunge()
    mail.logout()
    print("All emails deleted.")

def search_and_fetch_email(server, port, email_address, password, subject):
    # Connect to the email server
    mail = imaplib.IMAP4_SSL(server, port)
    mail.login(email_address, password)
    mail.select('inbox')

    # Search for emails with the specified subject
    result, data = mail.search(None, f'(SUBJECT "{subject}")')
    email_ids = data[0].split()

    # Fetch the latest email and extract the OTP from its body
    if email_ids:
        latest_email_id = email_ids[-1]
        result, data = mail.fetch(latest_email_id, '(RFC822)')
        raw_email = data[0][1].decode('utf-8', errors='replace')  # Decode bytes to string

        email_message = email.message_from_string(raw_email)  # Use message_from_string to parse email content

        # Extract the OTP from the email body
        email_body = ""
        received_time = email_message.get("Date")
        sender = email_message.get("From")
        if email_message.is_multipart():
            for part in email_message.walk():
                if part.get_content_type() == "text/plain":
                    email_body += part.get_payload(decode=True).decode('utf-8', errors='replace')

        else:
            email_body = email_message.get_payload(decode=True).decode('utf-8', errors='replace')

        return email_body, received_time, sender
    return None, None, None