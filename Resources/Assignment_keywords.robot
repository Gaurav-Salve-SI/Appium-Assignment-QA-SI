*** Settings ***
Library    AppiumLibrary
Library    Process
Library    ImapLibrary2
Variables    ../Pagesource/login_locators.py
Library      ../Pagesource/login_locators.py
Library    String
Library    Collections

*** Variables ***
${subject}      Email OTP

*** Keywords ***
Wait and click an element
    [Arguments]     ${locator}
    wait until page contains element    ${locator}    timeout=30
    click element    ${locator}

Get Otp Details
    [Arguments]     ${mail_body_wth_otp}
    ${otp_pattern}    Set Variable    \\d{6}    # Regex pattern for a 6-digit OTP
    ${otp}    Get Regexp Matches    ${mail_body_wth_otp}    ${otp_pattern}
#    Should Be Equal As Numbers    ${otp.__len__()}    1    # Ensure only one match
    ${otp_value}    Get From List    ${otp}    1    # Extract the OTP from the match list
    RETURN    ${otp_value}

Fetch OTP from Email and Verify OTP
    [Arguments]     ${email_address}
    Input Text    ${login_email_address_field}    ${email_address}
    Sleep    5s
    Delete All Emails Inbox    imap.gmail.com    993    ${email_address}    zvma dfio xqzm ayuz
    Wait and click an element       //android.widget.Button[@resource-id="com.gsoc.app.staging:id/btn_verify"]
    Sleep    15s
    ${body} =   Search And Fetch Email    imap.gmail.com    993    ${email_address}    zvma dfio xqzm ayuz    ${subject}
    ${mailbody}  Convert To String  ${body}
    ${OTP_Value}   Get Otp Details     ${mailbody}
    Log To Console    ${OTP_Value}
    Input Text    ${login_screen_OTP_field}    ${OTP_Value}
    Wait and click an element    android=new UiSelector().resourceId("com.gsoc.app.staging:id/cb_disclaimer")
    Hide Keyboard
    Wait and click an element    android=new UiSelector().resourceId("com.gsoc.app.staging:id/cb_terms")
    Wait and click an element    ${login_screen_verifyotp_button}
    Wait and click an element    ${complete_first_name_field}
    Input Text    ${complete_first_name_field}    Frank
    Wait and click an element    ${complete_last_name_field}
    Input Text    ${complete_last_name_field}    Miller
    Hide Keyboard
    FOR    ${count}    IN RANGE    0    10
        Swipe    ${438}    ${999}    ${438}    ${444}
        ${status}    run keyword and return status    Page Should Not Contain Text  ${complete_profile_continue_button}
        IF    ${status}    BREAK
    END
    Sleep    15s
    Wait and click an element    ${complete_profile_continue_button}
    Sleep    15s
    Wait and click an element    ${complete_profile_popup_profile_button}
    Sleep    15s
    Go Back
    Wait and click an element    //android.widget.TextView[@resource-id="com.gsoc.app.staging:id/tv_read_more"]