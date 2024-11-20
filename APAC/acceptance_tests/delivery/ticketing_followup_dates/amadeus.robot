*** Settings ***
Force Tags        amadeus    apac
Resource          ../delivery_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That Warning Is Displayed If Ticketing Date And Follow Up Date is Local Holiday
    [Tags]    us587    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US587    BEAR    INFIVEEIGHTSEVEN
    Click New Booking
    Click Panel    Cust Refs
    Update PNR With Default Values
    Book Flight X Months From Now    MNLSIN/APR    SS1Y1    FXP    10    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Click Panel    Delivery
    Select Delivery Method    Amadeus edited TKXL
    Tick Awaiting Approval    Tick
    Set Ticketing Date Using Actual Value    10/02/2019
    Verify Ticketing Date Warning Tooltip Message Is Correct    This is a Holiday: IN Weekday Holiday
    Set Ticketing Date Using Actual Value    10/05/2019
    Verify Ticketing Date Error Tooltip Message Is Correct    Ticketing date cannot be on a weekend
    Set Follow Up Date Using Actual Value    01/26/2020
    Verify Follow up Date Warning Tooltip Message Is Correct    This is a Holiday: Republic Day
    Click Panel    Delivery
    Set Ticketing Date Using Actual Value    09/24/2019
    Verify Ticketing Date Warning Tooltip Message Is Correct    This is a Holiday: THIS IS TO TEST LENGTH PUBLIC HOLODAY DESCRIPTIONs
    Click Finish PNR

[IN AB] Verify That Warning Is Displayed If Ticketing Date And Follow Up Date is Local Holiday
    [Tags]    us587    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Select Delivery Method    Amadeus edited TKXL
    Set Ticketing Date Using Actual Value    10/05/2019
    Verify Ticketing Date Error Tooltip Message Is Correct    Ticketing date cannot be on a weekend
    Set Ticketing Date Using Actual Value    12/30/2020
    Verify Ticketing Date Error Tooltip Message Is Correct    Ticketing date cannot be after last ticketing date provided by the airline
    Click Panel    Recap
    Verify Panel is Red    Delivery
    Click Panel    Delivery
    Set Ticketing Date Using Actual Value    10/02/2019
    Verify Ticketing Date Warning Tooltip Message Is Correct    This is a Holiday: IN Weekday Holiday
    Tick Receive Invoice Checkbox    0
    Click Finish PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel
    [Tags]    us2093    in
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    Select GDS    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US304    BEAR    INTHREEZEROFOUR
    Click New Booking
    Click Panel    Cust Refs
    Update PNR With Default Values
    Book Flight X Months From Now    LAXJFK/AAA    SS1Y1    FXP    6    3
    Click Read Booking
    Click Panel    Cust Refs
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Designation    QA.QA/TEST*1_BB22@33
    Set CDR Value    Employee ID    555-55
    Click Panel    Delivery
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    False
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    False
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    TK TL
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    0
    Get Ticketing Date
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify TK TL Is Written In The PNR    BLRWL22MS    0    0
    Verify Ticketing RIR Remarks    TLIS    False
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For AB
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Set Ticketing Date X Months From Now    4
    Click Finish PNR    Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For AB

Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For SI
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Click Finish PNR    Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For SI

Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For HK
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Set Ticketing Date X Months From Now    6
    Click Finish PNR    Amend Booking For Verify That Ticketing Time Limit Are Updated Base From The Ticketing Date in The Delivery Panel For HK
