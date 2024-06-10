*** Settings ***
Library           SeleniumLibrary
Library           Collections
Suite Setup       Open Browser To Inventory Page
Suite Teardown    Close All Browsers

*** Variables ***
${URL}            https://www.saucedemo.com/inventory.html
${BROWSER}        chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce

*** Keywords ***
Open Browser To Inventory Page
    Open Browser    https://www.saucedemo.com    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed	0 seconds
    Input Text      id:user-name    ${USERNAME}
    Input Text      id:password     ${PASSWORD}
    Click Button    id:login-button
    Wait Until Page Contains Element    id:inventory_container

Login To Inventory Page
    Input Text      id:user-name    ${USERNAME}
    Input Text      id:password     ${PASSWORD}
    Click Button    id:login-button
    Wait Until Page Contains Element    id:inventory_container

Empty Cart
    ${buttons}    Get WebElements    //button[contains(@class, 'btn_secondary')]
    FOR    ${button}    IN    @{buttons}
        Click Button    ${button}
    END

*** Test Cases ***

TC016 Verify Adding All Products To The Cart
    ${buttons}    Get WebElements    //button[contains(@class, 'btn_primary')]
    ${total_items}    Get Length    ${buttons}
    FOR    ${button}    IN    @{buttons}
        Click Button    ${button}
    END
    Element Text Should Be    //span[@class='shopping_cart_badge']    ${total_items}
    # Verify all products are added to the cart