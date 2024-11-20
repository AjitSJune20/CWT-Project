*** Settings ***
Force Tags        amadeus
Resource          ../unused_document/unused_document_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That Unused Document Bank Remarks Are Written
    [Tags]    in    us1389    us1541
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC IN OS AUTOMATION    BEAR    INOTHERS
    Click Tab In Top Left    Unused Documents
    Add Unused Ticket (Dummy)    1-Paper    1237896550    079    XYZ163    10.09 USD
    Use Ticket Number From Unused Documents Tab (Screen)    1237896550
    Click Tab In Top Left    GDS Screen
    Select Client Account Using Default Value
    Click New Booking
    Update PNR With Default Values    
    Retrieve PNR Details From Amadeus    command=RT    refresh_needed=False
    Verify RMT Line Is Written    PR    079    1237896550    10.09    BEAR/INOTHERS
    Book Flight X Months From Now    SINMNL/ASQ    SS1Y1    FXB
    Click Read Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash    
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details From Amadeus    command=RT    refresh_needed=False
    Verify RMT Line Is Written    PR    079    1237896550    10.09    BEAR/INOTHERS
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}