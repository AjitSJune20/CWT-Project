*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags        amadeus    apac
Resource          ../delivery_verification.robot

*** Test Cases ***
[NB IN] Verify That Onhold Remarks Are Written When Delivery Method Is Non-TKOK And On Hold Reason Is Ticked
    [Tags]    us711    team_c    in
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumsg    APAC QA
    ...    Amadeus
    Create New Booking With One Way Flight Using Default Values    APAC SYN CORP ¦ APAC SYN IN 3    BEAR    NIYAK    MNLSIN/APR
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Click Panel    Delivery
    Select Delivery Method    Amadeus edited TKXL
    Get Onhold Booking Reasons Selected
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Verify RIR On Hold Reason Remarks Are Written
    Verify Ticketing RMM Remarks Are Written
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Ticketing Element Is Written When Delivery Method Is TK OK (No Queue Placement) With Multiple On Hold Selected
    [Tags]    us304    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    Select GDS    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US304    BEAR    INTHREEZEROFOUR
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    LAXJFK/AAA    SS1Y1    FXP    6    3
    Click Read Booking
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Select On Hold Booking Reasons    Awaiting Itinerary Segment
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    False
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    True
    Select Delivery Method    No Queue Placement
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    0
    Get Ticketing Date
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify TK OK Is Written In The PNR    BLRWL22MS

[AB IN] Verify That Ticketing Element Is Written When Delivery Method Is TK XL (Auto Cancel) With Single On Hold Selected
    [Tags]    us304    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Delivery
    Untick On Hold Reasons    Awaiting Approval
    Untick On Hold Reasons    Awaiting Itinerary Segment
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    True
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    False
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    Auto Cancel
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    2
    Get Ticketing Date
    Click Panel    Recap
    Click Finish PNR    Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK XL (Auto Cancel) With Single On Hold Selected For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK XL (Auto Cancel) With Single On Hold Selected For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify TK XL Is Written In The PNR    BLRWL22MS    2200
    [Teardown]

[AB IN] Verify That Ticketing Element Is Written When Delivery Method Is TK TL (Auto Ticket) With Multiple On Hold Selected
    [Tags]    us304    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Cust Refs
    Tick Not Known At Time Of Booking
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Select On Hold Booking Reasons    Awaiting Itinerary Segment
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    True
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    True
    Select Delivery Method    TK TL
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    2
    Get Ticketing Date
    Populate All Panels (Except Given Panels If Any)    Policy Check    Cust Refs    Delivery
    Click Panel    Recap
    Click Finish PNR    Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK TL (Auto Ticket) With Multiple On Hold Selected For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK TL (Auto Ticket) With Multiple On Hold Selected For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Queue was 62C1 so arguments were as ->    62    1
    Verify TK TL Is Written In The PNR    BLRWL22MS    0    0    True
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That PNR Is Queued In Aqua When Follow Up Date Is Set Today And Awaiting Approval Is Selected
    [Tags]    us710    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Create New Booking With One Way Flight Using Default Values    APAC SYN CORP ¦ AUTOMATION IN - US710    BEAR    INSEVENONEZERO    HKGLAX/ACX    \    Delivery
    Click Panel    Delivery
    Select Delivery Method    No Queue Placement
    Select On Hold Booking Reasons    Awaiting Approval
    Set Follow Up Date X Day Ahead    0
    Set Ticketing Date    1
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Get Follow Update Value
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHQ
    Verify Aqua Queue Place Is Not Written In the PNR    SINWL2101    63    C2    0
    Verify On Hold Queue Place Is Written In The PNR    BLRWL22MS    64    C0
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHO
    Verify Aqua Queue Minder Is Not Written In the PNR    SINWL2101    63    C2    0
    Verify On Hold Queue Minder Is Written In The PNR    BLRWL22MS    64    C0

[AB IN] Verify That PNR Is Queued In Aqua When Follow Up Date Is Set To Today And Multiple OnHold Is Selected
    [Tags]    us710    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2
    Book Flight X Months From Now    HKGLAX/ACX    SS1Y1    FXP    6    3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD    Delivery
    Click Panel    APIS/SFPD
    Populate APIS/SFPD Address    Street    City    Guam    New York    100
    Click Panel    Delivery
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    True
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    Auto Cancel
    Set Follow Up Date X Day Ahead    0
    Set Ticketing Date    1
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Get Follow Update Value
    Click Finish PNR    Amend Booking For Verify That PNR Is Queued In Aqua When Follow Up Date Is Set To Today And Multiple OnHold Is Selected
    Execute Simultaneous Change Handling    Amend Booking For Verify That PNR Is Queued In Aqua When Follow Up Date Is Set To Today And Multiple OnHold Is Selected
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHQ
    Verify Aqua Queue Place Is Written In the PNR    SINWL2101    63    C2
    Verify On Hold Queue Place Is Written In The PNR    BLRWL22MS    64    C0
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHO
    Verify Aqua Queue Minder Is Written In the PNR    SINWL2101    63    C2
    Verify On Hold Queue Minder Is Written In The PNR    BLRWL22MS    64    C0
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK TL (Auto Ticket) With Multiple On Hold Selected For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    APIS/SFPD
    Tick Not Known    Tick
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    False
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    Auto Cancel
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    2
    Get Ticketing Date
    Populate All Panels (Except Given Panels If Any)    Policy Check    Cust Refs    Delivery
    Click Panel    Recap
    Click Finish PNR

Amend Booking For Verify That Ticketing Element Is Written When Delivery Method Is TK XL (Auto Cancel) With Single On Hold Selected For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    APIS/SFPD
    Tick Not Known    Tick
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    False
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    Auto Cancel
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Set Ticketing Date    2
    Get Ticketing Date
    Populate All Panels (Except Given Panels If Any)    Policy Check    Cust Refs    Delivery
    Click Panel    Recap
    Click Finish PNR

Amend Booking For Verify That PNR Is Queued In Aqua When Follow Up Date Is Set To Today And Multiple OnHold Is Selected
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2
    Book Flight X Months From Now    HKGLAX/ACX    SS1Y1    FXP    6    3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD    Delivery
    Click Panel    APIS/SFPD
    Populate APIS/SFPD Address    Street    City    Guam    New York    100
    Click Panel    Delivery
    Verify Specific On Hold Reason Status    Awaiting Secure Flight Data    False
    Verify Specific On Hold Reason Status    Awaiting Customer References    True
    Verify Specific On Hold Reason Status    Awaiting Fare Details    False
    Verify Specific On Hold Reason Status    Awaiting Approval    True
    Verify Specific On Hold Reason Status    Awaiting Itinerary Segment    False
    Select Delivery Method    Auto Cancel
    Set Follow Up Date X Day Ahead    0
    Set Ticketing Date    1
    Set Email Address in Delivery Panel    automation@carlsonwagonlit.com
    Get Follow Update Value
    Click Finish PNR    Amend Booking For Verify That PNR Is Queued In Aqua When Follow Up Date Is Set To Today And Multiple OnHold Is Selected

Verify Aqua Queue Place Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    QE/${pcc}/${queue_number}${queue_category}

Verify Aqua Queue Minder Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    OP ${pcc}/${current_date}/${queue_number}${queue_category}/AQUA QUEUING

Verify On Hold Queue Minder Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    ${followup_date}    Convert Date To GDS Format    ${followup_date}    %m/%d/%Y
    Verify Specific Line Is Written In The PNR    OP ${pcc}/${follow_up_date}/${queue_number}${queue_category}/PNR ON HOLD SEE REMARKS

Verify On Hold Queue Place Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    QE/${pcc}/${queue_number}${queue_category}

Verify Aqua Queue Place Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    QE/${pcc}/${queue_number}${queue_category}    ${occurence}

Verify Aqua Queue Minder Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    OP ${pcc}/${current_date}/${queue_number}${queue_category}/AQUA QUEUING    ${occurence}

Verify On Hold Queue Minder Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Set Test Variable    ${current_date}
    ${current_date}    SyexDateTimeLibrary.Get Current Date
    ${current_date}    Convert Date To GDS Format    ${current_date}    %m/%d/%Y
    Verify Specific Remark Is Not Written X Times In The PNR    OP ${pcc}/${current_date}/${queue_number}${queue_category}/PNR ON HOLD SEE REMARKS    ${occurence}

Verify On Hold Queue Place Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    QE/${pcc}/${queue_number}${queue_category}    ${occurence}

Verify Specific Remark Is Not Written X Times In The PNR
    [Arguments]    ${expected_remark}    ${occurence}
    ${actual_count_match}    Get Count    ${pnr_details}    ${expected_remark}
    Run Keyword And Continue On Failure    Run Keyword If    ${actual_count_match} <= ${occurence}    Log    PASS: "${expected_remark}" was not written more than "${occurence}" times in the PNR.
    ...    ELSE    FAIL    "${expected_remark}" was written "${actual_count_match}" times in the PNR and not the expected count: " ${occurence}"

Get Follow Update Value
    ${follow_up_date}    Get Control Text Value    ${date_followup}
    Set Suite Variable    ${follow_up_date}

Populate Cust Refs Panel With Mandatory Values
    Click Panel    Cust Refs
    Set CDR Value    DEPARTMENT    AD
    Set CDR Value    DIVISON E.G. GLOBAL FINANCE    4
    Set CDR Value    DP Code    33
    Set CDR Value    PERSONNEL ID OR STAFF ID    11
    Set CDR Value    TRAVEL REASON E.G. INTERNA MEETING    MEETING
    [Teardown]    Take Screenshot
