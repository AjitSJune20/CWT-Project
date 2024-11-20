*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags        apac    amadeus
Resource          ../air_fare_verification.robot

*** Test Cases ***
[NB IN] Verify That OB Fee Is Part Of All Computations And Included In Accounting FOP And Itinerary Adult Fare Remarks
    [Tags]    in    us2176
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN 2    BEAR    CUDDLER
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    FRABLR/ALH    SS1Y1    FXP/S2    5
    Book Flight X Months From Now    BLRSIN/ASQ    SS1Y1    FXP/S3    5    5
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Click Fare Tab    Fare 2
    Select FOP Merchant On Fare Quote Tab    Fare 2    Airline
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    IN
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Verify OB Fee Amount Is Correct Based On Value From TST    Fare 1
    Click Fare Tab    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Verify OB Fee Amount Is Correct Based On Value From TST    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Verify FOP Remark Per TST Is Written    Fare 1    S2    VI4111111111111111/D1221    IN    Airline    is_ob_fee_present=True
    Verify FOP Remark Per TST Is Written    Fare 2    S3    VI4111111111111111/D1221    IN    Airline    is_ob_fee_present=True
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1    country=IN    is_ob_fee_present=True
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 2    country=IN    is_ob_fee_present=True
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Fees Remarks Are Written With Corresponding GST When FOP Is Credit Card
    [Tags]    in    us2108    us2114    us2322
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN 2    BEAR    CUDDLER
    Click New Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    VI    4484886032739871    1223
    Verify Merchant Fee Type Is Not Visible
    Click Panel    Cust Refs
    Tick Not Known At Time Of Booking
    Click Update PNR
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP    6
    Book Flight X Months From Now    DELSIN/ASQ    SS1Y1    FXP/S3    6
    Book Flight X Months From Now    DELNRT/ANH    SS1Y1    FXP/S4    6    1
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select Merchant On Fare Quote Tab    CWT
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Route Code Value    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Get Merchant Fee Percentage Value    Fare 1
    Get Merchant Fee Amount Value    Fare 1
    Get Merchant Fee For Transaction Fee Value    Fare 1
    Click Fare Tab    Fare 2
    Select Merchant On Fare Quote Tab    Airline
    Set Transaction Fee    6000
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Route Code Value    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Get Merchant Fee Percentage Value    Fare 2
    Get Merchant Fee Amount Value    Fare 2
    Get Merchant Fee For Transaction Fee Value    Fare 2
    Click Fare Tab    Fare 3
    Select Merchant On Fare Quote Tab    Airline
    Set Transaction Fee    4500
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 3    S4
    Get Route Code Value    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Get Merchant Fee Percentage Value    Fare 3
    Get Merchant Fee Amount Value    Fare 3
    Get Merchant Fee For Transaction Fee Value    Fare 3
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Transaction Fee Remarks With GST
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    VI************9871/D1223    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    VI************9871/D1223    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 3    S4    04    VI************9871/D1223    IN
    #Merchant Fee Remarks With GST
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    VI4484886032739871/D1223    IN
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee    S2    02    VI************9871/D1223    1
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 2    S3    03    VI4484886032739871/D1223    IN
    Verify GST Remarks Per TST Are Correct    Fare 2    Merchant Fee    S3    03    VI************9871/D1223    1
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 3    S4    04    VI4484886032739871/D1223    IN
    Verify GST Remarks Per TST Are Correct    Fare 3    Merchant Fee    S4    04    VI************9871/D1223    1
    #Merchant Fee On Transaction Fee Remarks With GST
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    VI4484886032739871/D1223    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee On TF    S2    02    VI************9871/D1223    1
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 2    S3    03    VI4484886032739871/D1223    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 2    Merchant Fee On TF    S3    03    VI************9871/D1223    1
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 3    S4    04    VI4484886032739871/D1223    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 3    Merchant Fee On TF    S4    04    VI************9871/D1223    1
    #GST On Air
    Verify GST On Air Accounting Remarks Is Written    Fare 1    S2    02    VI4484886032739871/D1223
    Verify GST On Air Accounting Remarks Is Written    Fare 2    S3    03    VI4484886032739871/D1223
    Verify GST On Air Accounting Remarks Is Written    Fare 3    S4    04    VI4484886032739871/D1223
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When Segment Is Cancelled And Rebooked
    [Tags]    us548    team_c    in    us2322
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Cancel Stored Fare and Segment    4
    Book Flight X Months From Now    DELLAX/AUA    SS1Y1    FXP/S4    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Click Fare Tab    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Click Fare Tab    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When Segment Is Cancelled And Rebooked
    Execute Simultaneous Change Handling    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When Segment Is Cancelled And Rebooked
    Retrieve PNR Details From Amadeus
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    Invoice    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 3    S4    04    Cash    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Fees Remarks Are Written With Corresponding GST When FOP Is Cash
    [Tags]    team_c    in    us2108    US2301    us2322
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA
    Select GDS    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN    BEAR    INDI
    Select Client Account    3129300001 ¦ DANISCO ¦ APAC SYN IN
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Verify FOP Merchant Field Is Not Visible On Client Info Panel
    Click Panel    Cust Refs
    Click Update PNR
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP/S2    5    5
    Book Flight X Months From Now    DELHKG/ACX    SS1Y1    FXP/S3    5    10
    Book Flight X Months From Now    DELNRT/AJL    SS1Y1    FXP/S4    6
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Comment    Select Merchant On Fare Quote Tab    CWT
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Route Code Value    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Get Merchant Fee Percentage Value    Fare 1
    Get Merchant Fee Amount Value    Fare 1
    Get Merchant Fee For Transaction Fee Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Get Airline Commission Percentage Value    Fare 1
    Click Fare Tab    Fare 2
    Comment    Select Merchant On Fare Quote Tab    Airline
    Set Transaction Fee    6000
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Route Code Value    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Get Merchant Fee Percentage Value    Fare 2
    Get Merchant Fee Amount Value    Fare 2
    Get Merchant Fee For Transaction Fee Value    Fare 2
    Click Fare Tab    Fare 3
    Comment    Select Merchant On Fare Quote Tab    Airline
    Set Transaction Fee    4500
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 3    S4
    Get Route Code Value    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Get Merchant Fee Percentage Value    Fare 3
    Get Merchant Fee Amount Value    Fare 3
    Get Merchant Fee For Transaction Fee Value    Fare 3
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Commission Rebate
    Verify Commission Rebate Remarks Per TST Are Correct    Fare 1    S2    02    Cash    IN
    #Transaction Fee Remarks With GST
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 3    S4    04    Cash    IN
    #Merchant Fee Remarks With GST
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    Cash    IN
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee    S2    02    Cash    0
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 2    S3    03    Cash    IN
    Verify GST Remarks Per TST Are Correct    Fare 2    Merchant Fee    S3    03    Cash    0
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 3    S4    04    Cash    IN
    Verify GST Remarks Per TST Are Correct    Fare 3    Merchant Fee    S4    04    Cash    0
    #Merchant Fee On Transaction Fee Remarks With GST
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 1    S2    02    Cash    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee On TF    S2    02    Cash    0
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 2    S3    03    Cash    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 2    Merchant Fee On TF    S3    03    Cash    0
    Verify Merchant Fee Remarks Per TST Are Correct    Fare 3    S4    04    Cash    IN    Merchant Fee On TF
    Verify GST Remarks Per TST Are Correct    Fare 3    Merchant Fee On TF    S4    04    Cash    0
    #GST On Air
    Verify GST On Air Accounting Remarks Is Written    Fare 1    S2    02    Cash
    Verify GST On Air Accounting Remarks Is Written    Fare 2    S3    03    Cash
    Verify GST On Air Accounting Remarks Is Written    Fare 3    S4    04    Cash
    [Teardown]

[AB IN] Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When New Segment Is Added
    [Tags]    us_548    team_c    in    us2322
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Book Flight X Months From Now    NRTLAX/ANH    SS1Y1    FXP/S5    6    3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Click Fare Tab    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Click Fare Tab    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Click Fare Tab    Fare 4
    Set Transaction Fee    3
    Get Transaction Fee Amount Value    Fare 4
    Click Panel    Recap
    Click Finish PNR    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When New Segment Is Added
    Execute Simultaneous Change Handling    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When New Segment Is Added
    Retrieve PNR Details From Amadeus
    Calculate GST On Transaction Fee    Fare 1    IN
    Calculate GST On Transaction Fee    Fare 2    IN
    Calculate GST On Transaction Fee    Fare 3    IN
    Calculate GST On Transaction Fee    Fare 4    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 2    S3    03    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 3    S4    04    Cash    IN
    Verify Transaction Fee Remark Per TST Are Correct    Fare 4    S5    05    VI************1111/D1223    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Transaction Fee Is Correct When Offline Flat Amount Per PNR Is Used
    [Tags]    us266    in    team_c    us2114
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US307    BEAR    INTHREEZEROSEVEN
    Click New Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    DC    36440301582207    1223
    Update PNR With Default Values    Client Info
    Book Flight X Months From Now    SINMNL/APR    SS1Y1    FXP    6
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP/S3    6    10
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Flat    Amount
    Click Fare Tab    Fare 2
    Verify Transaction Fee Value Is Zero And Field Is Disabled    Fare 2    IN
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    DC36440301582207/D1223    IN
    Verify Transaction Fee Per TST Not Written    Fare 2    S3    DC36440301582207/D1223
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Transaction Fee Is Correct When Offline Range Amount Is Used
    [Tags]    us521    in    team_c    out_of_scope
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN 3    BEAR    NIYAK
    Click New Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    VI    4484886075896240    1231
    Update PNR With Default Values
    Book One Way Flight X Months From Now    DELSIN/ASQ    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Range    Amount
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    VI4484886075896240/D1231    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Transaction Fee Is Correct When Offline Range Percentage Is Used
    [Tags]    us521    team_c    in    out_of_scope
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN 4    BEAR    ISTA
    Click New Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    AX    378282246310005    D1220
    Click Panel    Cust Refs
    Update PNR With Default Values
    Book One Way Flight X Months From Now    DELSIN/ASQ    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Range    Percentage
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    Verify Transaction Fee Remark Per TST Are Correct    Fare 1    S2    02    AX378282246310005/D1220    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When Segment Is Cancelled And Rebooked
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Cancel Stored Fare and Segment    4
    Book Flight X Months From Now    DELLAX/AUA    SS1Y1    FXP/S4    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Click Fare Tab    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Click Fare Tab    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When Segment Is Cancelled And Rebooked

Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When New Segment Is Added
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Book Flight X Months From Now    NRTLAX/ANH    SS1Y1    FXP/S5    6    3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Transaction Fee Amount Value    Fare 1
    Click Fare Tab    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Click Fare Tab    Fare 3
    Get Transaction Fee Amount Value    Fare 3
    Click Fare Tab    Fare 4
    Set Transaction Fee    3
    Get Transaction Fee Amount Value    Fare 4
    Click Panel    Recap
    Click Finish PNR    Amend Verify that GST on Transaction Fee Is Computed/Written Correctly in the Accounting Remarks When New Segment Is Added

Verify Transaction Fee Defaults To Previous Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${previous_transaction_fee}    Set Variable    ${transaction_fee_value_${fare_tab_index}}
    ${current_value}    Get Transaction Fee Amount Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${previous_transaction_fee}    ${current_value}    Transaction fee should defaults to previous value
    [Teardown]    Take Screenshot

Verify Transaction Fee Status
    [Arguments]    ${fare_tab}    ${country}    ${client_fee_group_name}    ${transaction_type_code}    ${booking_origination_code}    ${travel_indicator}=I
    ...    ${from_global_flag}=True    ${to_global_flag}=True    ${is_percentage}=True    ${rounding_so}={EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${query_result}    Get Transaction Fee From DB (From Global)    ${client_fee_group_name}    ${transaction_type_code}    ${booking_origination_code}    ${travel_indicator}    from_global_flag=${from_global_flag}
    ...    to_global_flag=${to_global_flag}    is_percentage=${is_percentage}
    Get Base Fare From TST    Fare Quote ${fare_tab_index}    T${fare_tab_index}
    Get Nett Fare Value    Fare Quote ${fare_tab_index}
    ${query_result}    Run Keyword If    "${is_percentage}" == "False"    Set Variable    ${query_result}
    ...    ELSE    Evaluate    ${query_result}/100
    ${fee_amount_percent_cap}    Set Variable If    "${is_percentage}" == "True"    Percentage    Amount
    ${transaction_fee_type}    Set Variable If    "${transaction_type_code}" == "Online"    Unassisted    "${transaction_type_code}" == "Assist"    Assisted    "${transaction_type_code}" == "Standard"
    ...    Flat
    Verify Transaction Fee Value Is Correct    Fare Quote ${fare_tab_index}    ${country}    ${booking_origination_code}    ${transaction_fee_type}    ${fee_amount_percent_cap}    ${rounding_so}
    ...    ${query_result}

Verify OB Fee Amount Is Correct Based On Value From TST
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Fees Value Is Correct    ${fare_tab}    ${ob_fee_${fare_tab_index}}
