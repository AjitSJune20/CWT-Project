*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags        amadeus    apac
Resource          ../pspt_and_visa_verification.robot

*** Test Cases ***
[NB IN] Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR
    [Tags]    in    us2090    us2091
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US555    BEAR    INFIVEFIVEFIVE
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    SINNRT/ANH    SS1Y1    FXB/S2    5    5
    Book Flight X Months From Now    NRTJFK/ANH    SS1Y1    FXB/S3    5    10
    Book Flight X Months From Now    JFKLHR/ABA    SS1Y1    FXB/S4    5    15
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Domestic Trip Checkbox Is Unticked
    Populate Pspt & Visa With Values    1    Passport: Normal    India    12345    Yes
    Verify Visa Requirement Per Country    Japan    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    Singapore    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United States    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United Kingdom    ${EMPTY}    Business    Untick
    Get Expiry Date    0
    Select Is Doc Valid    Yes
    Click Panel    Pspt and Visa
    Tick Transit Checkbox    Japan
    Click Check Visa Requirements
    Verify Passport And Visa Details
    Verify Country Of Residence Contains Expected Value    India
    Verify ESTA Section Is Not Displayed
    Verify Visa Requirement Per Country    Japan    Required    Business    Tick
    Verify Visa Requirement Per Country    Singapore    Required    Business    Untick
    Verify Visa Requirement Per Country    United States    Required    Business    Untick
    Verify Visa Requirement Per Country    United Kingdom    Required    Business    Untick
    Populate All Panels (Except Given Panels If Any)    Pspt and Visa
    Click Finish PNR
    Retrieve PNR Details    ${current_pnr}
    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False

[AB IN] Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR
    [Tags]    in    us2090    us2091
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Travel Document Details Are Correct    Passport: Normal    India    12345    ${expiry_date_0}    Yes
    Book Flight X Months From Now    LHRORD/ABA    SS1Y3    FXP/S5    5    20
    Click Read Booking
    Click Panel    Pspt and Visa
    Delete Passport    1
    Populate Pspt & Visa With Values    1    Passport: Normal    United Kingdom    654321    Yes
    Verify Visa Requirement Per Country    Japan    ${EMPTY}    Business    Tick
    Verify Visa Requirement Per Country    Singapore    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United States    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United Kingdom    ${EMPTY}    Business    Untick
    Select Is Doc Valid    Yes
    Tick Transit Checkbox    United States
    Click Check Visa Requirements
    Verify Passport And Visa Details
    Verify Visa Requirement Per Country    Japan    Not Required    Business    Tick
    Verify Visa Requirement Per Country    Singapore    Not Required    Business    Untick
    Verify Visa Requirement Per Country    United States    Required    Business    Tick
    Verify Visa Requirement Per Country    United Kingdom    Not Required    Business    Untick
    Verify Country Of Residence Contains Expected Value    United Kingdom
    Verify ESTA/ETA Warning Message Is Displayed    If the passenger is travelling under the visa waiver program they must submit and receive an Electronic authorization to travel.
    Populate All Panels (Except Given Panels If Any)    Pspt and Visa
    Click Finish PNR    Amend Booking For Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR For IN
    Retrieve PNR Details    ${current_pnr}
    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=TRUE
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Travel Document Details Are Correct    Passport: Normal    India    12345    ${expiry_date_0}    Yes
    Delete Passport    1
    Book Flight X Months From Now    LHRORD/ABA    SS1Y1    FXP/S5    5    20
    Click Read Booking
    Click Panel    Pspt and Visa
    Populate Pspt & Visa With Values    1    Passport: Normal    United Kingdom    654321    Yes
    Verify Visa Requirement Per Country    Japan    ${EMPTY}    Business    Tick
    Verify Visa Requirement Per Country    Singapore    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United States    ${EMPTY}    Business    Untick
    Verify Visa Requirement Per Country    United Kingdom    ${EMPTY}    Business    Untick
    Select Is Doc Valid    Yes
    Tick Transit Checkbox    United States
    Click Panel    Pspt and Visa
    Click Check Visa Requirements
    Verify Passport And Visa Details
    Verify Visa Requirement Per Country    Japan    Not Required    Business    Tick
    Verify Visa Requirement Per Country    Singapore    Not Required    Business    Untick
    Verify Visa Requirement Per Country    United States    Required    Business    Tick
    Verify Visa Requirement Per Country    United Kingdom    Not Required    Business    Untick
    Verify Country Of Residence Contains Expected Value    United Kingdom
    Verify ESTA/ETA Warning Message Is Displayed    If the passenger is travelling under the visa waiver program they must submit and receive an Electronic authorization to travel.
    Populate All Panels (Except Given Panels If Any)    Pspt and Visa
    Click Finish PNR    Amend Booking For Verify That For International Trip, Destination And Transit Countries Are Written In Passport & Visa Info Tab And PNR For IN
