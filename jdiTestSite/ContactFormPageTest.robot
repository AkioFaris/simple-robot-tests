*** Settings ***
Documentation     On Contact Page input name, input last name, select it (Ctrl+A) and than copy and 
...               paste it into the Description Field. After that check logs.
Library           SeleniumLibrary  ${SELENIUM TIMEOUT}    ${SELENIUM IMPLICIT_WAIT}    
                  ...    ${SELENIUM RUN_ON_FAILURE}    ${SCREENSHOT_ROOT_DIRECTORY}


*** Variables ***
${SELENIUM TIMEOUT}    5.0
${SELENIUM IMPLICIT_WAIT}    10.0
${SELENIUM RUN_ON_FAILURE}    Capture Page Screenshot
${SCREENSHOT_ROOT_DIRECTORY}    \failures_screenshots

${INDEX_PAGE}      https://jdi-framework.github.io/tests/index.htm
${CONTACT_FORM_PAGE}      https://jdi-framework.github.io/tests/page1.htm
${BROWSER}        Chrome
${USERNAME}        epam
${PASSWORD}        1234
${CARER}    //div[@class='profile-photo']/following-sibling::span
${SUBMIT}    //input[@id='Password']/ancestor::*/button
${LOG_LIST}    //*[@class='panel-body-list logs']/li
${NAME}  Marissa

*** Test Cases ***
Fill Contact Form
    Open Browser To    ${INDEX_PAGE}
    Login with    ${USERNAME}    ${PASSWORD}
    Go To    ${CONTACT_FORM_PAGE}
    Input Text    id:Name    ${NAME}
    Move To The Next Field
    Input Text    id:LastName    ${NAME}
    Select And Copy From    id:LastName 
    Move To The Next Field
    Paste To    id:Description
    Changes Should Be In Log
    
    [Teardown]    Close Browser

*** Keywords ***

Changes Should Be In Log
    @{elems}=    Get WebElements   ${LOG_LIST}
    :FOR    ${elem}    IN    @{elems}
    \    ${text}=    Get Text     ${elem}
    \    Log     ${text}
    \    Should Contain    ${text}    ${NAME}

Select And Copy From
    [Arguments]    ${location}
    Press Key    ${location}    \\1   #Ctrl + A
    Evaluate    pyautogui.hotkey('ctrl', 'c')    modules=pyautogui   #Ctrl + C
    
Paste To
    [Arguments]    ${location}
    Press Key    ${location}    \\22   #Ctrl + V

Move To The Next Field
    Press Key    //html    \\9    #Tab 

Login with
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${CARER} 
    Click Element    ${CARER}
    Input Text    id:Login    ${username}
    Input Password    id:Password    ${password}
    Click Button    ${SUBMIT}
    
Open Browser To
    [Arguments]    ${url}
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Index Page