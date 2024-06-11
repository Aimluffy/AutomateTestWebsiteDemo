# Test file using the resource file login_resources.robot for login tests on https://www.saucedemo.com

*** Settings ***
Library    SeleniumLibrary
Resource    ../resource/login_resources.robot
Suite Setup    Open my Browser
Suite Teardown    Close Browsers
Test Template    Invalid Login

*** Test Cases ***          username                password
Right user empty pass       ${VALID_USERNAME}       ${EMPTY}
Right user wrong pass       ${VALID_USERNAME}       ${INVALID_PASSWORD}
Wrong user right pass       ${INVALID_USERNAME}     ${VALID_PASSWORD}
Wrong user empty pass       ${INVALID_USERNAME}     ${EMPTY}
Wrong user wrong pass       ${INVALID_USERNAME}     ${INVALID_PASSWORD}

*** Keywords ***
Invalid Login
    [Arguments]    ${username}    ${password}
    [Documentation]    Inputs the username and password, clicks the login button, and verifies the error message.
    Input Username    ${username}
    Input Password    ${password}
    Click Login Button
    Error Message Should Be Visible
