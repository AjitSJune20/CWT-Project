*** Settings ***
Resource          ../air_fare_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That Air Fare Restrictions Is Selected In Restriction Panel Under Fare Tab And Correct Remarks Are Written
    [Tags]    us491    us297    in    us2172
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN POLICY    BEAR    REN IN
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    BOMSIN/ASQ    SS1Y1    FXP/S2    6    3
    Book Flight X Months From Now    BLRBKK/ATG    SS1Y1    FXP/S3    6    4
    Book Flight X Months From Now    SINBOM/ASQ    SS1Y1    FXP/S4    6    5
    Click Read Booking
    Click Panel    Air Fare
    Verfiy Default Restrictions Are Selected In Fare Tab    Fare 1
    Verify Default UI Display In The Restrictions Tab    Fare 1    IN
    Select Air Fare Restrictions Radio Button    Fare 2
    Verify Air Fare Restrictions Dropdown Values    Fare 2    FARE VALID ONLY ON <Airline>    IN CASE OF NO SHOW, TICKET IS NONREFUNDABLE AND NOT    NO SHOW PENALTY APPLIES
    Select Air Fare Restrictions In Fare Quote    Fare 2    FARE VALID ONLY ON <Airline>    NO SHOW PENALTY APPLIES
    Add Customized Templates In Fare Quote Restriction Panel    Fare 2    YELLOW FEVER
    Verify Air Fare Restrictions Present In Itinerary Remarks Panel    Fare 2    FARE VALID ONLY ON <Airline>    NO SHOW PENALTY APPLIES    YELLOW FEVER
    Verify Fare Notes Values    Fare 2    2    1    BLRBKK
    Select Air Fare Restrictions Radio Button    Fare 3    No Restrictions
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    Verify Default Restriction Remarks Are Written    1    IN
    Verify Air Fare Restriction Remarks on Amadeus    Fare 1    FARE VALID ONLY ON <Airline>    NO SHOW PENALTY APPLIES
    Verify Air Fare Restriction Remarks on Amadeus    Fare 2    FARE VALID ONLY ON <Airline>    NO SHOW PENALTY APPLIES    YELLOW FEVER
    Verify Remarks Are Written In The PNR    false    false    RTYPE:DEFAULT/T1    RTYPE:TEMPLATE/T2    RTYPE:NONE/T3
    
[AB IN] Verify That Air Fare Restrictions Is Selected In Restriction Panel Under Fare Tab And Correct Remarks Are Written - When Removed A Flight Segment
    [Tags]    us297    us491    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Delete Air Segment    3
    Comment    Delete Amadeus Offer    XE1
    Click Read Booking
    Click Panel    Air Fare
    Comment    Delete Alternate Fare Tab    Alt Fare 1
    Select Air Fare Restrictions Radio Button    Fare 1
    Delete Air Fare Restrictions In Fare Quote Restriction Panel    Fare 1    FARE VALID ONLY ON <AIRLINE>    NO SHOW PENALTY APPLIES
    Verify Air Fare Restrictions Dropdown Values    Fare 1    FARE VALID ONLY ON <Airline>    IN CASE OF NO SHOW, TICKET IS NONREFUNDABLE AND NOT    NO SHOW PENALTY APPLIES
    Select Air Fare Restrictions In Fare Quote    Fare 1    NO SHOW PENALTY APPLIES
    Add Customized Templates In Fare Quote Restriction Panel    Fare 1    ARRIVAL NOTICE
    Verify Air Fare Restrictions Present In Itinerary Remarks Panel    Fare 1    NO SHOW PENALTY APPLIES    ARRIVAL NOTICE
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For IN Verify That Changed Restrictions In Restrictions Panel Are Written In Remarks
    Execute Simultaneous Change Handling    Amend Booking For IN Verify That Changed Restrictions In Restrictions Panel Are Written In Remarks
    Retrieve PNR Details from Amadeus
    Verify Air Fare Restriction Remarks on Amadeus    Fare 1    NO SHOW PENALTY APPLIES    ARRIVAL NOTICE
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For IN Verify That Changed Restrictions In Restrictions Panel Are Written In Remarks
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Delete Air Segment    3
    Comment    Delete Amadeus Offer    XE1
    Click Read Booking
    Click Panel    Air Fare
    Comment    Delete Alternate Fare Tab    Alt Fare 1
    Select Air Fare Restrictions Radio Button    Fare 1
    Delete Air Fare Restrictions In Fare Quote Restriction Panel    Fare 1    FARE VALID ONLY ON <AIRLINE>    NO SHOW PENALTY APPLIES
    Verify Air Fare Restrictions Dropdown Values    Fare 1    FARE VALID ONLY ON <Airline>    IN CASE OF NO SHOW, TICKET IS NONREFUNDABLE AND NOT    NO SHOW PENALTY APPLIES
    Select Air Fare Restrictions In Fare Quote    Fare 1    NO SHOW PENALTY APPLIES
    Add Customized Templates In Fare Quote Restriction Panel    Fare 1    ARRIVAL NOTICE
    Verify Air Fare Restrictions Present In Itinerary Remarks Panel    Fare 1    NO SHOW PENALTY APPLIES    ARRIVAL NOTICE
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For IN Verify That Changed Restrictions In Restrictions Panel Are Written In Remarks

Verify Fare Notes Values
    [Arguments]    ${fare_tab}    ${fare_tab_index}    ${group_no}    ${origin_destination}
    Get Fare Basis From TST    ${fare_tab}    ${group_no}    2
    ${farenote_from_gds}    Get Fare Notes From Amadeus    ${fare_tab}    ${group_no}    ${origin_destination}
    @{fare_notes_values}    Get Fare Notes Value From UI
    Log List    ${farenote_from_gds}
    Log List    ${fare_notes_values}
    Lists Should Be Equal    ${farenote_from_gds}    ${fare_notes_values}

Get Fare Notes Value From UI
    Click Restriction Tab
    ${air_restriction_tree}    Determine Multiple Object Name Based On Active Tab    AirRestrictionTree
    @{fare_notes_values}    Get Tree List    ${air_restriction_tree}
    Set Suite Variable    ${fare_notes_values}
    [Return]    ${fare_notes_values}
