*** Settings ***
Test Teardown     Take Screenshot On Failure
Resource          ../delivery_verification.robot

*** Test Cases ***
[NB SI IN] Verify That Queue Minder Is Added For Itinerary Confirmation E-mail
    [Tags]    in    howan    us912    us2290
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Create New Booking With One Way Flight Using Default Values    APAC SYN CORP ¦ AUTOMATION IN - US912    BEAR    INNINEONETWO    SINMNL/APR
    Click Finish PNR
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Panel    Delivery
    Verify Itinerary Type Section Is Displayed
    Verify Confirmation Is Selected As Default Itinerary Type
    Verify Ticketing Details Field Is Disabled
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Execute Simultaneous Change Handling    Simultaneous Change Handling For Itinerary Type Confirmation
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Remarks for Itinerary Type    PARWL2877    64    C0
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB SI IN] Verify That Queue Minder Is Added For E-ticket Notification
    [Tags]    howan    us912    us1069    in    us2290
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ XYZ AUTOMATION IN - US285    BEAR    INTWOEIGHTFIVE
    Select Client Account Value    3050300003 ¦ TEST 7TF BARCLAYS ¦ XYZ AUTOMATION IN - US285
    Click New Booking
    Update PNR With Default Values
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE    RT
    Book Flight X Months From Now    SINMNL/APR    SS1Y1    FXP    5    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR    ${current_pnr}
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Click Send Itinerary
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Click Panel    Delivery
    Verify Itinerary Type Section Is Displayed
    Verify Confirmation Is Selected As Default Itinerary Type
    Select E-Ticket Notification Radio Button
    Verify Ticketing Details Field Is Disabled
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Execute Simultaneous Change Handling    Simultaneous Change Handling For Itinerary Type E-Ticket
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Remarks for Itinerary Type    PARWL2877    65    C0
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Verify Ticketing Details Field Is Disabled
    Verify Control Object Is Disabled    [NAME:grpTicketingDetails]

Simultaneous Change Handling For Itinerary Type Confirmation
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Panel    Delivery
    Verify Itinerary Type Section Is Displayed
    Verify Confirmation Is Selected As Default Itinerary Type
    Verify Ticketing Details Field Is Disabled
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR

Simultaneous Change Handling For Itinerary Type E-Ticket
    Retrieve PNR    ${current_pnr}
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Click Send Itinerary
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Click Panel    Delivery
    Verify Itinerary Type Section Is Displayed
    Verify Confirmation Is Selected As Default Itinerary Type
    Select E-Ticket Notification Radio Button
    Verify Ticketing Details Field Is Disabled
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
