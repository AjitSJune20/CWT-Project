*** Settings ***
Force Tags        apac    amadeus
Resource          ../pspt_and_visa_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
    [Tags]    us320    in    howan    us2090
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US303    BEAR    INTHREEZEROTHREE
    Click New Booking
    Update PNR With Default Values
    #For Getting Electronic Authorizations Message#
    Book Flight X Months From Now    NRTJFK/AAA    SS1Y1    FXP
    #For Getting Electronic Authorizations Message#
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Domestic Trip Checkbox Is Unticked
    Delete Passport    1
    Select Is Doc Valid    No    1
    Tick Use Document
    Tick Transit Checkbox    Japan
    Tick Transit Checkbox    United States
    Click Check Visa Requirements
    Verify ESTA Header In The Lower Right Section Is Displayed    Electronic Authorizations
    Verify ESTA/ETA Warning Message Is Displayed    If the passenger is travelling under the visa waiver program they must submit and receive an Electronic authorization to travel.
    Click Panel    APIS/SFPD
    Populate APIS/SFPD Address    Street    City    India    Alaska    1111
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD    Pspt and Visa
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Visa Check Itinerary Remarks Are Written

[AB IN] Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
    [Tags]    us320    in    howan    us2090
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Travel Document Details Are Correct    Passport    Finland    1234567890    12/22/2020    ${EMPTY}
    Verify Visa Requirement Per Country    Japan    Required    Business    Tick
    Verify Visa Requirement Per Country    United States    Required    Business    Tick
    Delete Passport    1
    Add And Select New Passport    3    Passport: Normal    Australia    1111111111    Yes
    Click Check Visa Requirements
    Verify ESTA Header In The Lower Right Section Is Displayed    Electronic Authorizations
    Verify ESTA/ETA Warning Message Is Displayed    If the passenger is travelling under the visa waiver program they must submit and receive an Electronic authorization to travel.
    Click Panel    Cust Refs
    Tick Not Known At Time Of Booking
    Click Panel    APIS/SFPD
    Populate APIS/SFPD Address    Street    City    India    Alaska    1111
    Click Panel    Delivery
    Tick Receive Itinerary Checkbox
    Tick Receive Invoice Checkbox
    Select Delivery Method    E-Ticket
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
    Execute Simultaneous Change Handling    Amend Booking For Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Visa Check Itinerary Remarks Are Written
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Verify Visa Requirement Per Country
    [Arguments]    ${country}    ${visa_required}    ${journey_type}    ${transit_tick}    # ${transit_ticked} Tick or Untick
    ${row_number}    Get Field Index Using Country Name    ${country}
    Run Keyword If    "${transit_tick.lower()}" == "tick"    Verify Checkbox Is Ticked    [NAME:cchkIsTransit${row_number}]
    ...    ELSE    Verify Checkbox Is Unticked    [NAME:cchkIsTransit${row_number}]
    Verify Control Object Text Value Is Correct    [NAME:ctxtCountries${row_number}]    ${country}
    Verify Control Object Text Value Is Correct    [NAME:ccboVisa${row_number}]    ${visa_required}
    Verify Control Object Text Value Is Correct    [NAME:ccboJourneyType${row_number}]    ${journey_type}

Amend Booking For Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Pspt and Visa
    Verify Travel Document Details Are Correct    Passport    Finland    1234567890    12/22/2020    ${EMPTY}
    Verify Visa Requirement Per Country    Japan    Required    Business    Tick
    Verify Visa Requirement Per Country    United States    Required    Business    Tick
    Delete Passport    1
    Add And Select New Passport    3    Passport: Normal    Australia    1111111111    Yes
    Click Check Visa Requirements
    Verify ESTA Header In The Lower Right Section Is Displayed    Electronic Authorizations
    Verify ESTA/ETA Warning Message Is Displayed    If the passenger is travelling under the visa waiver program they must submit and receive an Electronic authorization to travel.
    Click Panel    Cust Refs
    Tick Not Known At Time Of Booking
    Click Panel    APIS/SFPD
    Populate APIS/SFPD Address    Street    City    India    Alaska    1111
    Click Panel    Delivery
    Tick Receive Itinerary Checkbox
    Tick Receive Invoice Checkbox
    Select Delivery Method    E-Ticket
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For International Trip, Passport Details With US ESTA Are Captured And Written
