*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags        airline_commission_and_commission_rebate
Resource          ../air_fare_verification.robot

*** Test Cases ***
[NB IN] Verify That Merchant Fee For Non-Pass Through Is Displayed And Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated When Show Mark Up Fields And Pre-Populate Commission Rebate Are Set To No
    [Tags]    us1052    us1049    us1047    de104    us2109    in
    Open Power Express And Retrieve Profile    ${version}    Test    U002MEH    en-GB    mhernandez    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN - US1052    BEAR    NIKKI IN
    Select Client Account    3104300001 ¦ MONSANTO HOLDINGS PVT. LTD ¦ IN - US1052
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    FRACDG/AAF    SS1Y1    FXP/S2    5
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Route Code Value    Fare 1
    Get FOP Merchant Field Value On Fare Quote Tab
    Verify Commission Rebate Amount And Percentage Is Displayed And Has No Value
    Verify Mark-Up Amount Field Is Not Displayed    Fare 1
    Verify Mark-Up Amount Percentage Field Is Not Displayed    Fare 1
    Calculate Mark- Up Amount And Percentage    Fare 1    S2    IN    TQT    0
    Set Commission Rebate Percentage    12
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    CLIENT REBATE
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Verify BF/ AF Remarks For Mark-Up Amount And Percentage Are Not Written    Fare 1    IN
    Verify FOP Remark Per TST Is Written    Fare 1    S2    VI4111111111111111/D1221    IN    CWT
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    VI4111111111111111/D1221    IN
    Verify GST Remarks Per TST Are Correct    Fare 1    merchant fee    S2    02    VI4111111111111111/D1221    1
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 1    S2    02    VI4111111111111111/D1221    IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1    country=IN
    Verify CM Remark Is Written    Fare 1    S2
    Verify Wings Remark Is Not Written
    [Teardown]

[AB IN] Verify That Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated For Fare Quote And Alternate Fare
    [Tags]    us1052    us1049    us1047    de104    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Verify Mark-Up Amount Field Is Not Displayed    Fare 1
    Verify Mark-Up Amount Percentage Field Is Not Displayed    Fare 1
    Calculate Mark- Up Amount And Percentage    Fare 1    S2    IN    TQT    0
    Set Commission Rebate Percentage    12
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Populate Fare Quote Tabs with Default Values
    Click Finish PNR    IN Amend Booking To Verify That Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated For Fare Quote And Alternate Fare
    Execute Simultaneous Change Handling    IN Amend Booking To Verify That Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated For Fare Quote And Alternate Fare
    Retrieve PNR Details From Amadeus
    Verify BF/ AF Remarks For Mark-Up Amount And Percentage Are Not Written    Fare 1    IN
    Verify FOP Remark Per TST Is Written    Fare 1    S2    VI4111111111111111/D1221    IN
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    VI4111111111111111/D1221    IN
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 1    S2    02    VI4111111111111111/D1221    IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1    country=IN
    Verify CM Remark Is Written
    Verify Wings Remark Is Not Written
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee
    [Tags]    us1046    in    us2110    US2301    us2322
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumsg    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN 3    BEAR    NIYAK
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    PORTRAIT/CA************2124/D1022-MC
    Update PNR With Default Values
    Book Flight X Months From Now    DELBOM/AUK    SS1Y2    FXP/S2    5
    Book Flight X Months From Now    BLRBKK/ATG    SS1Y1    FXP/S3    5    2
    Book Flight X Months From Now    DELORD/AUA    SS1Y1    FXP/S4-5    5    5
    Book Flight X Months From Now    ORDDEL    SS1Y1    FXP/S6-7    5    8
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Airline Commission Percentage Value Is Correct    Fare 1    2.00
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 1    TEST CARD/VI************0087/D0823/CVV***
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Quote Tabs with Default Values
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Routing, Turnaround and Route Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Range    Amount
    Verify Merchant Fee For Transaction Fee Amount Is Correct Based On Computed Value    Fare 1
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Fare Tab    Fare 2
    Verify Airline Commission Percentage Value Is Correct    Fare 2    0.00
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 2    TEST CARD/VI************0087/D0823/CVV***
    Select FOP Merchant On Fare Quote Tab    Fare 2    Airline
    Populate Fare Quote Tabs with Default Values
    Set Nett Fare Field    Fare 2    1000
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Routing, Turnaround and Route Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Offline    Range    Amount
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Click Fare Tab    Fare 3
    Verify Airline Commission Percentage Value Is Correct    Fare 3    3.00
    Populate Fare Quote Tabs with Default Values
    Get Main Fees On Fare Quote Tab    Fare 3
    Click Fare Tab    Fare 4
    Verify Airline Commission Percentage Value Is Correct    Fare 4    0.00
    Populate Fare Quote Tabs with Default Values
    Get Main Fees On Fare Quote Tab    Fare 4
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 2    S3    03    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 3    S4-5    0405    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 4    S6-7    0607    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN    CWT
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    PORTRAIT/CA************2124/D1022-MC    IN
    Verify FM Remarks For Airline Commission Is Written    Fare 1    M    S2
    Verify FM Remarks For Airline Commission Is Written    Fare 2    M    S3
    Verify FM Remarks For Airline Commission Is Written    Fare 3    M    S4-5
    Verify FM Remarks For Airline Commission Is Written    Fare 4    M    S6-7

[AB IN] Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee
    [Tags]    us1046    in    us2322
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Delete Air Segment    3
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP/S3    5    2
    Populate Client Info Panel With Default Values
    Click Panel    Complete
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 1    TEST CARD/VI************0087/D0823/CVV***
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Quote Tabs with Default Values
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Routing, Turnaround and Route Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Range    Amount
    Verify Merchant Fee For Transaction Fee Amount Is Correct Based On Computed Value    Fare 1
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Fare Tab    Fare 2
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 2    Cash
    Select FOP Merchant On Fare Quote Tab    Fare 2    Airline
    Set Nett Fare Field    Fare 2    1000
    Populate Fare Quote Tabs with Default Values
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Routing, Turnaround and Route Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Offline    Range    Amount
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Finish PNR    IN Amend Booking To Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee
    Execute Simultaneous Change Handling    IN Amend Booking To Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 2    S3    03    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN    CWT
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    PORTRAIT/CA************2124/D1022-MC    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    PORTRAIT/CA************2124/D1022-MC    IN
    Verify FOP Remark Per TST Is Written    Fare 1    S2    PORTRAIT/CA************2124/D1022-MC    IN    CWT
    Verify FOP Remark Per TST Is Written    Fare 2    S3    PORTRAIT/CA************2124/D1022-MC    IN    Airline
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Merchant Fee For Full Pass Through And Has Client Agreement Is Displayed
    [Tags]    us2109    in
    Open Power Express And Retrieve Profile    ${version}    Test    U002MEH    en-GB    mhernandez    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN - US1052    BEAR    NIKKI IN
    Select Client Account    3050300003 ¦ TEST 7TF BARCLAYS ¦ IN - US1052
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    BOMBKK/ATG    SS1Y1    FXP/S2    5
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Route Code Value    Fare 1
    Get FOP Merchant Field Value On Fare Quote Tab
    Calculate Mark- Up Amount And Percentage    Fare 1    S2    IN    TQT    0
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    has_client_cwt_comm_agreement=Yes
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    VI4111111111111111/D1221    IN
    Verify GST Remarks Per TST Are Correct    Fare 1    merchant fee    S2    02    VI4111111111111111/D1221    1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
IN Amend Booking To Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Delete Air Segment    3
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP/S3    5    5
    Populate Client Info Panel With Default Values
    Click Panel    Complete
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 1    TEST CARD/VI************0087/D0823/CVV***
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Quote Tabs with Default Values
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Routing, Turnaround and Route Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Range    Amount
    Verify Merchant Fee For Transaction Fee Amount Is Correct Based On Computed Value    Fare 1
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Fare Tab    Fare 2
    Comment    Select Form Of Payment Value On Fare Quote Tab    Fare 2    Cash
    Select FOP Merchant On Fare Quote Tab    Fare 2    Airline
    Set Nett Fare Field    Fare 2    1000
    Populate Fare Quote Tabs with Default Values
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Routing, Turnaround and Route Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Offline    Range    Amount
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Finish PNR    IN Amend Booking To Verify The Rounding Logic Is Applied To Commission Rebate Amount, Merchant Fee, MarkUp Amount And Transaction Fee

IN Amend Booking To Verify That Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated For Fare Quote And Alternate Fare
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Verify Mark-Up Amount Field Is Not Displayed    Fare 1
    Verify Mark-Up Amount Percentage Field Is Not Displayed    Fare 1
    Calculate Mark- Up Amount And Percentage    Fare 1    S2    IN    TQT    0
    Set Commission Rebate Percentage    12
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Populate Fare Quote Tabs with Default Values
    Click Finish PNR    IN Amend Booking To Verify That Mark-Up Is Not Displayed And Airline Commission And Commission Rebate Are Not Pre-Populated For Fare Quote And Alternate Fare

Amend Verify That Main Fees For Alternate Fares Are Retained
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Alt Fare 1
    Get Main Fees On Fare Quote Tab    Alt Fare 1    hk    trail2
    Verify Main Fees Values Are Correct    trail1    trail2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Verify That Main Fees For Alternate Fares Are Retained
