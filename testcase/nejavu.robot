*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${URL}    https://www.nejavu.com
${BROWSER}    Chrome

*** Test Cases ***
TC001 Open Browser To Nejavu
    Open Browser To Nejavu

TC002 Close Banner If Present
    Close Banner If Present
    #Clear Cart If Not Empty
    Sleep    1s

TC003 Navigate To Cartoons Page
    Navigate To Cartoons Page

TC004 Get Book Names In First Row
    ${book_names}=    Get Book Names In First Row
    Set Suite Variable    ${book_names}

TC005 Add All Books In First Row To Cart
    Add All Books In First Row To Cart

TC006 Go To Cart Page
    Go To Cart Page

TC007 Verify Cart Contents
    Verify Cart Contents    ${book_names}

TC008 Delete All Books From Cart
    Delete All Books From Cart

TC009 Verify Cart Badge Is Zero
    Verify Cart Badge Is Zero
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Nejavu
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Close Banner If Present
    ${banner_present}=    Run Keyword And Return Status    
    ...    Wait Until Element Is Visible    xpath://body/main[1]/div[2]/div[1]/div[1]/a[1]/img[1]    timeout=10s
    Run Keyword If    ${banner_present}    Click Element    xpath://body/main[1]/div[2]/div[1]/a[1]

Navigate To Cartoons Page
    Click Link    https://www.nejavu.com/cartoon
    Accept Cookie Banner If Present
    Wait Until Page Contains Element    xpath://div[contains(@class, 'nev-pd-card')]

Accept Cookie Banner If Present
    ${cookie_banner_present}=    Run Keyword And Return Status
    ...    Element Should Be Visible    xpath://div[contains(@class, 'cookie-policy') and contains(@class, 'show')]
    Run Keyword If    ${cookie_banner_present}
    ...    Run Keywords
    ...    Wait Until Element Is Visible    xpath://button[.//a[contains(text(), 'ยอมรับ')]]    timeout=10s
    ...    AND    Click Element    xpath://button[.//a[contains(text(), 'ยอมรับ')]]
    ...    AND    Wait Until Element Is Not Visible    xpath://div[contains(@class, 'cookie-policy') and contains(@class, 'show')]    timeout=10s

Get Book Names In First Row
    @{book_elements}=    Get WebElements    xpath:(//div[contains(@class, 'nev-pd-card')])[position() <= 5]//a/h5[@class='detail-title']
    @{book_names}=    Create List
    FOR    ${element}    IN    @{book_elements}
        ${name}=    Get Text    ${element}
        ${name}=    Strip String    ${name}
        Append To List    ${book_names}    ${name}
    END
    Log    Found book names: ${book_names}
    [Return]    ${book_names}

Strip String
    [Arguments]    ${string}
    ${stripped_string}=    Evaluate    '${string}'.strip()
    [Return]    ${stripped_string}

Add All Books In First Row To Cart
    @{add_buttons}=    Get WebElements    xpath:(//div[contains(@class, 'nev-pd-card')])[position() <= 5]//form[@id='QuickCartRequestForm']//button[@id='quick-cart-button']
    ${button_count}=    Get Length    ${add_buttons}
    Log    Found ${button_count} 'Add to Cart' buttons to process
    FOR    ${index}    ${button}    IN ENUMERATE    @{add_buttons}    start=1
        Click Add To Cart Button    ${button}    ${index}
    END

Click Add To Cart Button
    [Arguments]    ${button}    ${index}
    Scroll Element Into View    ${button}
    Wait Until Element Is Visible    ${button}    timeout=10s
    Wait Until Element Is Enabled    ${button}    timeout=10s
    Click Element    ${button}
    Sleep    2s    # Allow time for any animations or state changes

Clear Cart If Not Empty
    Go To Cart Page
    @{delete_buttons}=    Get WebElements    xpath://body/main[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[5]/a[1]
    ${delete_button_count}=    Get Length    ${delete_buttons}
    Run Keyword If    ${delete_button_count} > 0    Delete All Books From Cart
    Log    Cart cleared. Items removed: ${delete_button_count}

Go To Cart Page
    Click Link    https://www.nejavu.com/cart

Verify Cart Contents
    [Arguments]    ${expected_books}
    Wait Until Page Contains Element    xpath://body/main[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]
    @{cart_book_elements}=    Get WebElements    xpath://div[contains(@class, 'cart-item-detail')]/p/strong
    @{cart_book_names}=    Create List
    ${element_count}=    Get Length    ${cart_book_elements}
    Log    Number of book elements found in cart: ${element_count}
    FOR    ${element}    IN    @{cart_book_elements}
        ${name}=    Get Text    ${element}
        ${name}=    Strip String    ${name}
        Append To List    ${cart_book_names}    ${name}
        Log    Found book in cart: ${name}
    END
    Log    All books in cart: ${cart_book_names}
    Log    Expected books: ${expected_books}
    Lists Should Be Equal    ${cart_book_names}    ${expected_books}

Delete All Books From Cart
    ${delete_button_exists}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    xpath://body/main[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[5]/a[1]
    
    WHILE    ${delete_button_exists}
        Click Element    xpath://body/main[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[5]/a[1]
        
        Wait Until Element Is Visible    xpath://button[contains(text(),'ใช่ ลบรายการ')]
        Click Element    xpath://button[contains(text(),'ใช่ ลบรายการ')]
        
        Sleep    1s
        
        ${delete_button_exists}=    Run Keyword And Return Status    
        ...    Page Should Contain Element    xpath://body/main[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[5]/a[1]
    END
    
    Log    Finished deleting all books from cart

Verify Cart Badge Is Zero
    ${badge_text}=    Get Text    xpath://div[@id='badge-cart']
    Should Be Equal As Strings    ${badge_text}    0
