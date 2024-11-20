*** Settings ***
Force Tags        amadeus    apac
Resource          ../policy_check_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify Correct Policies Are Displayed For Air Vendor, Country/City, Yellow Fever Advisory, Malaria, Air Cabin And That Correct Remarks Are Written
    [Tags]    us342    us343    us589    in    voltes
    Open Power Express And Retrieve Profile    ${version}    Test    U003axo    en-GB    aobsum    APAC SYN
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN POLICY    BEAR    JARED IN Policy
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    SINMNL/APR    SS1Y1    FXP    6    3
    Book Flight X Months From Now    PEKBKK/ATG    SS1Y1    FXP/S3    6    5
    Book Flight X Months From Now    MADGRU/AUX    SS1J1    FXP/S4    7    13
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Policy Check
    Click Panel    Policy Check
    Verify Policy Status Is Blank By Default    Philippine Airlines Non-Preferred
    Verify Policy Status Is Blank By Default    Philippines Malaria
    Verify Policy Status Is Blank By Default    Bangkok Prohibited
    Verify Policy Status Is Blank By Default    China Banned
    Verify Policy Status Is Blank By Default    Business Class out of policy
    Verify Policy Status Is Blank By Default    Sao Paulo Deferred
    Verify Policy Status Is Blank By Default    Brazil Yellow Fever
    Populate Policy Check Panel With Default Values
    Select Policy Status    Philippine Airlines Non-Preferred    AA - Awaiting Approval
    Select Policy Status    Philippines Malaria    NV - Not going to affected area
    Select Policy Status    Bangkok Prohibited    TA - Traveller/Booker Advised
    Select Policy Status    China Banned    HA - Has authority to travel
    Select Policy Status    Business Class out of policy    TA - Traveller/Booker Advised
    Select Policy Status    Sao Paulo Deferred    NV - Not going to affected area
    Select Policy Status    Brazil Yellow Fever    NV - Not going to affected area
    Click Panel    Delivery
    Select Delivery Method    E-Ticket
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Air Vendor Policy Remarks Are Written    26968    PHILIPPINE AIRLINES NON-PREFERRED    AA - AWAITING APPROVAL    IN
    Verify Country Policy Remarks Are Written    15847    CHINA BANNED    BANNED COUNTRY - CN    HA - HAS AUTHORITY TO TRAVEL    IN
    Verify Air Cabin Policy Remarks Are Written    18903    TA - TRAVELLER/BOOKER ADVISED
    Verify City Policy Remarks Are Written    2312    BANGKOK PROHIBITED    BANGKOK IS PROHIBITED    TA - TRAVELLER/BOOKER ADVISED    IN
    Verify Yellow Fever Policy Remarks Are Written    BRAZIL    NV - NOT GOING TO AFFECTED AREA    IN    15714
    Verify Malaria Policy Remarks Are Written    PHILIPPINES MALARIA    NV - NOT GOING TO AFFECTED AREA    IN
    Verify City Policy Remarks Are Written    2313    SAO PAULO DEFERRED    ${EMPTY}    NV - NOT GOING TO AFFECTED AREA    IN

[AB IN] Verify Correct Policies Are Displayed And That Correct Remarks Are Written When A Segment Is Deleted
    [Tags]    us342    us343    us589    in    voltes
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Cancel Stored Fare and Segment    4
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Policy Check
    Click Panel    Policy Check
    Verify Policy Status Is Defaulted To Correct Value    Air Vendor    Philippine Airlines Non-Preferred    AA - Awaiting Approval
    Verify Policy Status Is Defaulted To Correct Value    Country    Philippines Malaria    NV - Not going to affected area
    Verify Policy Status Is Defaulted To Correct Value    City    Bangkok Prohibited    TA - Traveller/Booker Advised
    Verify Policy Status Is Defaulted To Correct Value    Country    China Banned    HA - Has authority to travel
    Populate Policy Check Panel With Default Values
    Select Policy Status    Philippine Airlines Non-Preferred    AA - Awaiting Approval
    Select Policy Status    Bangkok Prohibited    TA - Traveller/Booker Advised
    Select Policy Status    China Banned    HA - Has authority to travel
    Select Policy Status    Philippines Malaria    AA - Awaiting Approval
    Click Finish PNR    Amend Booking For Verify Correct Policies Are Displayed And That Correct Remarks Are Written When A Segment Is Deleted
    Execute Simultaneous Change Handling    Amend Booking For Verify Correct Policies Are Displayed And That Correct Remarks Are Written When A Segment Is Deleted
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Air Vendor Policy Remarks Are Written    26968    PHILIPPINE AIRLINES NON-PREFERRED    AA - AWAITING APPROVAL    IN
    Verify Country Policy Remarks Are Written    15847    CHINA BANNED    BANNED COUNTRY - CN    HA - HAS AUTHORITY TO TRAVEL    IN
    Verify City Policy Remarks Are Written    2312    BANGKOK PROHIBITED    BANGKOK IS PROHIBITED    TA - TRAVELLER/BOOKER ADVISED    IN
    Verify Yellow Fever Policy Remarks Are Not Written    BRAZIL    NV - NOT GOING TO AFFECTED AREA
    Verify Malaria Policy Remarks Are Written    PHILIPPINES MALARIA    AA - AWAITING APPROVAL    IN
    [Teardown]

[AB IN] Verify RIR Remarks Were Not Written When Removed All Segments Related To Policy And Booked A Flight With No Policies
    [Tags]    volters    de121    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Cancel Stored Fare and Segment    2-3
    Book Flight X Months From Now    NRTLON/ABA    SS1Y1    FXP    5    2
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Untick On Hold Reasons    Awaiting Approval
    Click Finish PNR    Amend Booking For Verify RIR Remarks Were Not Written When Removed All Segments Related To Policy And Booked A Flight With No Policies
    Execute Simultaneous Change Handling    Amend Booking For Verify RIR Remarks Were Not Written When Removed All Segments Related To Policy And Booked A Flight With No Policies
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Yellow Fever Policy Remarks Are Not Written    BRAZIL    NV - NOT GOING TO AFFECTED AREA
    Verify Air Vendor Policy Remarks Are Not Written    26968    PHILIPPINE AIRLINES NON-PREFERRED    AA - AWAITING APPROVAL
    Verify Country Policy Remarks Are Not Written    15847    CHINA BANNED    BANNED COUNTRY - CN    HA - HAS AUTHORITY TO TRAVEL
    Verify City Policy Remarks Are Not Written    2312    BANGKOK PROHIBITED    BANGKOK IS PROHIBITED    TA - TRAVELLER/BOOKER ADVISED
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify Correct Policies Are Displayed And That Correct Remarks Are Written When A Segment Is Deleted
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Cancel Stored Fare and Segment    4
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Policy Check
    Click Panel    Policy Check
    Verify Policy Status Is Defaulted To Correct Value    Air Vendor    Philippine Airlines Non-Preferred    AA - Awaiting Approval
    Verify Policy Status Is Defaulted To Correct Value    Country    Philippines Malaria    NV - Not going to affected area
    Verify Policy Status Is Defaulted To Correct Value    City    Bangkok Prohibited    TA - Traveller/Booker Advised
    Verify Policy Status Is Defaulted To Correct Value    Country    China Banned    HA - Has authority to travel
    Populate Policy Check Panel With Default Values
    Select Policy Status    Philippine Airlines Non-Preferred    AA - Awaiting Approval
    Select Policy Status    Bangkok Prohibited    TA - Traveller/Booker Advised
    Select Policy Status    China Banned    HA - Has authority to travel
    Select Policy Status    Philippines Malaria    AA - Awaiting Approval
    Click Finish PNR    Amend Booking For Verify Correct Policies Are Displayed And That Correct Remarks Are Written When A Segment Is Deleted

Amend Booking For Verify RIR Remarks Were Not Written When Removed All Segments Related To Policy And Booked A Flight With No Policies
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Cancel Stored Fare and Segment    2-3
    Book Flight X Months From Now    NRTLON/ABA    SS1Y1    FXP    5    2
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Untick On Hold Reasons    Awaiting Approval
    Click Finish PNR    Amend Booking For Verify RIR Remarks Were Not Written When Removed All Segments Related To Policy And Booked A Flight With No Policies
