*** Settings ***
Test Teardown     Take Screenshot On Failure
Resource          id_traveller_verification.robot

*** Test Cases ***
[NB IN] Verify That Name Is Changed In GDS After Move Profile
    [Tags]    us2086    in    de739
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN    BEAR    INDITLS
    Set Traveller Name In Traveller/Contact    IND    COOPER
    Select Client Account    3050300003 ¦ TEST 7TF BARCLAYS ¦ APAC SYN IN
    Click New Booking
    Update PNR With Default Values
    Simulate Power Hotel Segment Booking Using Default Values
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Traveler Name Entered By Counselor And On GDS Screen Are The Same    COOPER/IND
    Verify Power Hotel Remarks Are Written In The PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Power Express Can Add New Guest Traveller And Added in Portrait
    [Tags]    in    us2087    not_ready
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN    BEAR    CAT
    Click Create Traveller Profile
    Populate Add New Traveller    Guest    SalieIN    De Guzman    rjuarez@carlsonwagonlit.com    1    2
    ...    55555    yes
    Select Client Account Value    5030500473 ¦ Another detail ¦ APAC SYN IN
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP/S2    5    6
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}
