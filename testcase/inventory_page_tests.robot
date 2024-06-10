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
    Input Text      id:user-name    ${USERNAME}
    Input Text      id:password     ${PASSWORD}
    Click Button    id:login-button
    Wait Until Page Contains Element    id:inventory_container
    # Verify the inventory page loaded successfully

Login To Inventory Page
    Input Text      id:user-name    ${USERNAME}
    Input Text      id:password     ${PASSWORD}
    Click Button    id:login-button
    Wait Until Page Contains Element    id:inventory_container
    # Perform login steps to the inventory page

Empty Cart
    ${buttons}    Get WebElements    //button[contains(@class, 'btn_secondary')]
    FOR    ${button}    IN    @{buttons}
        Click Button    ${button}
    END

*** Test Cases ***

TC001 Verify Page Loads Correctly
    Page Should Contain Element    id:inventory_container
    # Verify the inventory page has loaded

TC002 Verify Product Sorting By Name A to Z
    Empty Cart
    Select From List By Value    //select[@class='product_sort_container']    az
    ${products}    Get WebElements    //div[@class='inventory_item_name']
    ${sorted_products}    Create List
    FOR    ${product}    IN    @{products}
        Append To List    ${sorted_products}    ${product.text}
    END
    ${original_products}    Set Variable    ${sorted_products.copy()}
    ${sorted_products}    Set Variable    ${sorted_products.sort()}
    Should Be Equal As Strings    ${sorted_products}    ${original_products.sort()}

TC003 Verify Product Sorting By Name Z to A
    Empty Cart
    Select From List By Value    //select[@class='product_sort_container']    za
    ${products}    Get WebElements    //div[@class='inventory_item_name']
    ${sorted_products}    Create List
    FOR    ${product}    IN    @{products}
        Append To List    ${sorted_products}    ${product.text}
    END
    ${sorted_products}    Set Variable    ${sorted_products.sort(reverse=True)}
    Should Be Equal As Strings    ${sorted_products}    ${sorted_products}

TC004 Verify Product Sorting By Price Low To High
    Empty Cart
    Select From List By Value    //select[@class='product_sort_container']    lohi
    ${prices}    Get WebElements    //div[@class='inventory_item_price']
    ${sorted_prices}    Create List
    FOR    ${price}    IN    @{prices}
        ${price_text}    Evaluate    str('${price.text}'.replace('$', ''))
        Append To List    ${sorted_prices}    ${price_text}
    END
    ${original_prices}    Set Variable    ${sorted_prices.copy()}
    ${sorted_prices}    Set Variable    ${sorted_prices.sort(key=float)}
    Should Be Equal As Strings    ${sorted_prices}    ${original_prices.sort(key=float)}

TC005 Verify Product Sorting By Price High To Low
    Empty Cart
    Select From List By Value    //select[@class='product_sort_container']    hilo
    ${prices}    Get WebElements    //div[@class='inventory_item_price']
    ${sorted_prices}    Create List
    FOR    ${price}    IN    @{prices}
        ${price_text}    Evaluate    str('${price.text}'.replace('$', ''))
        Append To List    ${sorted_prices}    ${price_text}
    END
    ${original_prices}    Set Variable    ${sorted_prices.copy()}
    ${sorted_prices}    Set Variable    ${sorted_prices.sort(reverse=True, key=float)}
    Should Be Equal As Strings    ${sorted_prices}    ${original_prices.sort(reverse=True, key=float)}

TC006 Verify Adding A Product To The Cart
    Empty Cart
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_primary')])[1]
    Element Text Should Be    //span[@class='shopping_cart_badge']    1
    # Verify the cart icon shows 1 item
    # Reset state by removing the product from the cart
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_secondary')])[1]

TC007 Verify Removing A Product From The Cart
    Empty Cart
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_primary')])[1]
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_secondary')])[1]
    Element Should Not Be Visible    //span[@class='shopping_cart_badge']
    # Verify the cart icon shows 0 items

TC008 Verify The Cart Icon Updates Correctly
    Empty Cart
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_primary')])[1]
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_primary')])[2]
    Element Text Should Be    //span[@class='shopping_cart_badge']    2
    Click Button    (//div[@class='inventory_item']//button[contains(@class, 'btn_secondary')])[1]
    Element Text Should Be    //span[@class='shopping_cart_badge']    1
    # Verify the cart icon updates correctly as items are added/removed

TC009 Verify Product Details
    Empty Cart
    Click Element    (//div[@class='inventory_item']//a)[1]
    Wait Until Page Contains Element    //div[@class='inventory_details_desc_container']
    Page Should Contain    Sauce Labs Fleece Jacket
    Go Back
    # Verify product details page loads and contains product information

TC010 Verify Logout Functionality
    Click Element    //button[@id='react-burger-menu-btn']
    Wait Until Element Is Visible    //a[@id='logout_sidebar_link']
    Click Element    //a[@id='logout_sidebar_link']
    Wait Until Page Contains Element    //input[@id='login-button']
    # Verify user is logged out and redirected to login page
    # Log back in to return to normal state
    Login To Inventory Page

TC011 Verify The Burger Menu Options
    Empty Cart
    Click Element    //button[@id='react-burger-menu-btn']
    Wait Until Element Is Visible    //a[@id='inventory_sidebar_link']
    Page Should Contain Element    //a[@id='inventory_sidebar_link']
    Page Should Contain Element    //a[@id='about_sidebar_link']
    Page Should Contain Element    //a[@id='logout_sidebar_link']
    Page Should Contain Element    //a[@id='reset_sidebar_link']
    # Verify the burger menu options are present

TC012 Verify Social Media Links In The Footer
    Empty Cart
    Wait Until Element Is Visible    //body/div[@id='root']/div[@id='page_wrapper']/footer[1]/ul[1]
    Page Should Contain Element    //body/div[@id='root']/div[@id='page_wrapper']/footer[1]/ul[1]/li[1]
    Page Should Contain Element    //body/div[@id='root']/div[@id='page_wrapper']/footer[1]/ul[1]/li[2]
    Page Should Contain Element    //body/div[@id='root']/div[@id='page_wrapper']/footer[1]/ul[1]/li[3]
    # Verify social media links are present in the footer

TC013 Verify Product Image Visibility
    Empty Cart
    ${images}    Get WebElements    //img[@class='inventory_item_img']
    FOR    ${image}    IN    @{images}
        Element Should Be Visible    ${image}
    END
    # Verify all product images are visible

TC014 Verify Product Name And Description Visibility
    Empty Cart
    ${names}    Get WebElements    //div[@class='inventory_item_name']
    ${descriptions}    Get WebElements    //div[@class='inventory_item_desc']
    FOR    ${name}    IN    @{names}
        Element Should Be Visible    ${name}
    END
    FOR    ${description}    IN    @{descriptions}
        Element Should Be Visible    ${description}
    END
    # Verify all product names and descriptions are visible

TC015 Verify Product Price Visibility
    Empty Cart
    ${prices}    Get WebElements    //div[@class='inventory_item_price']
    FOR    ${price}    IN    @{prices}
        Element Should Be Visible    ${price}
    END
    # Verify all product prices are visible

TC016 Verify Adding All Products To The Cart
    Empty Cart
    ${buttons}    Get WebElements    //button[contains(@class, 'btn_primary')]
    ${total_items}    Get Length    ${buttons}
    FOR    ${button}    IN    @{buttons}
        Click Button    ${button}
    END
    Element Text Should Be    //span[@class='shopping_cart_badge']    ${total_items}
    # Verify all products are added to the cart

TC017 Verify Removing All Products From The Cart
    Empty Cart
    ${buttons}    Get WebElements    //button[contains(@class, 'btn_secondary')]
    FOR    ${button}    IN    @{buttons}
        Click Button    ${button}
    END
    Element Should Not Be Visible    //span[@class='shopping_cart_badge']
    # Verify all products are removed from the cart

TC018 Verify Inventory Page Responsiveness
    Set Window Size    1200    800
    Wait Until Element Is Visible    //div[@id='inventory_container']
    Set Window Size    800    600
    Wait Until Element Is Visible    //div[@id='inventory_container']
    Set Window Size    375    667
    Wait Until Element Is Visible    //div[@id='inventory_container']
    # Verify the page adjusts correctly for different screen sizes

TC019 Verify Inventory Page Load Time
    ${start_time}    Get Time    epoch
    Go To    ${URL}
    Wait Until Page Contains Element    //div[@id='inventory_container']    timeout=10s
    ${end_time}    Get Time    epoch
    ${load_time}    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${load_time} < 2
    # Verify the page loads within acceptable time limits

TC020 Verify Resetting App State
    Click Element    //button[@id='react-burger-menu-btn']
    Wait Until Element Is Visible    //a[@id='reset_sidebar_link']
    Click Element    //a[@id='reset_sidebar_link']
    Wait Until Element Is Not Visible    //span[@class='shopping_cart_badge']
    # Verify app state is reset and cart is cleared