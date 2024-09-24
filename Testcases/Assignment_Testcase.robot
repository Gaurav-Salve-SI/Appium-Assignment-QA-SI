*** Settings ***
Library    AppiumLibrary
Library    Process
Variables    ../Pagesource/Assignment_locators.py
Suite Setup     Start Process       appium -a localhost -p 5454 --session-override
    ...     shell=True      alias=appiumserver
    ...     stdout=${CURDIR}/appium_stdout.txt  stderr=${CURDIR}/appium_stderr.txt
Suite Teardown   Terminate Process
Resource    ../Resources/Assignment_keywords.robot

*** Variables ***
${article_text}     Homan caps win over Jones with a count of three | Princess Auto Players' Championship

*** Test Cases ***
Open Application and Login Form
    Open Application    remote_url=http://localhost:5454     platformName=android     ignoreHiddenApiPolicyError=true
    ...     deviceName=RZ8R919TD1W      app=D:\\Appium-Assignment-QA-SI\\Appium-Assignment-QA-SI\\TestData\\gsoc_staging.apk
    ...     automationName=UiAutomator2      platformVersion=12.0     autoGrantPermissions=true   noReset=false
    Wait and click an element   ${login_button_bottommenu}
    Wait and click an element   ${login_button_welcome_screen}
    Wait and click an element    ${login_email_address_field}
    Fetch OTP from Email and Verify OTP     sportztester04@gmail.com
    Go Back
    &{scroll_arg}  Create Dictionary       strategy=-android uiautomator       selector=new UiSelector().className("androidx.recyclerview.widget.RecyclerView").instance(1)
    Execute Script    mobile: scroll    &{scroll_arg}
    Element Text Should Be    android=new UiSelector().resourceId("com.gsoc.app.staging:id/tv_asset_title")    ${article_text}