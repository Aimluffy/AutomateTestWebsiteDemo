# Resource file for testing login functionality on https://www.saucedemo.com

*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOGIN URL}    https://www.saucedemo.com/
${BROWSER}      chrome
${VALID_USERNAME}    standard_user
${VALID_PASSWORD}    secret_sauce
${INVALID_USERNAME}  invalid_user
${INVALID_PASSWORD}  invalid_sauce

*** Keywords ***
Open my Browser
    [Documentation]    Opens the browser to the login URL and maximizes the window.
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window

Close Browsers
    [Documentation]    Closes all browser instances.
    SeleniumLibrary.Close All Browsers
    
Open Login Page
    [Documentation]    Navigates to the login URL.
    Go To    ${LOGIN URL}

Input Username
    [Arguments]    ${username}
    [Documentation]    Inputs the given username into the username field.
    Input Text    //input[@id='user-name']    ${username}

Input Password
    [Arguments]    ${password}
    [Documentation]    Inputs the given password into the password field.
    Input Text    //input[@id='password']    ${password}

Click Login Button
    [Documentation]    Clicks the login button.
    Click Button    //input[@id='login-button']

Click Logout Link
    [Documentation]    Clicks the logout link.
    Click Element    //button[@id='react-burger-menu-btn']
    Wait Until Element Is Visible    //a[@id='logout_sidebar_link']
    Click Element    //a[@id='logout_sidebar_link']
    Wait Until Page Contains Element    //input[@id='login-button']

Error Message Should Be Visible
    [Documentation]    Verifies that the error message is visible.
    Wait Until Page Contains Element    //h3[@data-test='error']    timeout=5s

Inventory Page Should Be Visible
    [Documentation]    Verifies that the inventory page is visible.
    Wait Until Page Contains Element    //div[@id='inventory_container']    timeout=5s
