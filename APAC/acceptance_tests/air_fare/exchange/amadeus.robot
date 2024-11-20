*** Settings ***
Test Teardown     Take Screenshot On Failure
Resource          ../air_fare_verification.robot

*** Test Cases ***
[NB IN] Create Exchange Ticket PNR
    [Tags]    us1096    in    us2124
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsumsg    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN - US1052    BEAR    NIKKI IN
    Select Client Account Value    3050300003 ¦ TEST 7TF BARCLAYS ¦ IN - US1052
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    AMDDEL/AUK    SS1Y1    FXP    5
    Book Flight X Months From Now    GOIDEL/AUK    SS1Y1    FXP/S3    5
    Click Read Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Click Panel    Air Fare
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Click Clear All
    Verify Tickets Are Successfully Issued    S2
    Verify Tickets Are Successfully Issued    S3
    Get Ticket Number From PNR

[AB IN] Verify That Exchange Is Working For IN
    [Tags]    us1096    in    us2124    for_update
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Click Panel    Complete
    Exchange Ticketed PNR    S2    DELBOM/AUK    SS1Y1    5    4
    Click Read Booking    True
    Comment    Verify Exchange Pop-up Window Is Displayed    Fare 1 is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box    verification_mode=contains    multi_line_search_flag=true
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    # Get Air Fare Details
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 1    S2    country=IN
    Set Nett Fare Field    Fare 1    1000
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get Savings Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    #Fare 1
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1    is_exchange=true
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Finish PNR    Amend Ticket Exchange For Single Exchange IN
    Execute Simultaneous Change Handling    Amend Ticket Exchange For Single Exchange IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Accounting Remarks For Main Sale    Fare 1    S2    02    BTA/AX378282246310006/D1028    CWT    country=IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1
    Verify Exchange Itinerary Remark    Fare 1    is_apac=True

[AB IN] Verify That Exchange Fares Calculation For Main Fees And Remarks Are Correct For Manual Re-Issuance
    [Tags]    in    us2125    for_update
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Click Panel    Complete
    Enter GDS Command    XE3
    Book Flight X Months From Now    GOIDEL/AUK    SS1Y1    FXP/S3    5    5
    Generate Data For Exchange Ticket    EX2    INR    1000    ${EMPTY}    ${EMPTY}    50-YRVA
    ...    30-L7DE    20-OPAE    1100
    Set TST For Manual Reissue    S3    EX2    False
    Create Original/Issued In Exchange For (FO)    0    S3
    Click Read Booking    True
    Comment    Verify Exchange Pop-up Window Is Displayed    is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box    verification_mode=contains    multi_line_search_flag=true
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 2
    Verify Realised Savings Code Default Value    EX - EXCHANGE
    Select FOP Merchant On Fare Quote Tab    Fare 2    CWT
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 2    S3    True    IN
    Get Routing, Turnaround and Route Code    Fare 2
    Get LFCC Field Value    Fare 2
    Set Commission Rebate Percentage    3.00
    Populate Fare Details And Fees Tab With Default Values    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 2    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    Client Rebate
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Get Savings Code    Fare 2
    Click Finish PNR    Amend To Verify That Exchange Fares Calculation For Main Fees And Remarks Are Correct For Manual Re-Issuance
    Execute Simultaneous Change Handling    Amend To Verify That Exchange Fares Calculation For Main Fees And Remarks Are Correct For Manual Re-Issuance
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Accounting Remarks For Main Sale    Fare 2    S3    03    BTA/AX378282246310006/D1028    CWT    country=IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 2
    Verify Exchange Itinerary Remark    Fare 2    is_apac=True
    [Teardown]    #Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Ticket Exchange For Multiple Exchange
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    #Verify Pre-populated/Retained Values
    Click Read Booking    True
    Click Panel    Air Fare
    Click Fare Tab    Fare 2
    Verify Prepopulated Values in Fare Tab    fare_tab=Fare 2    expected_realised_saving_code=EX - EXCHANGE    expected_missed_saving_code=N - CLIENT SPECIFIC    expected_class_code=YW - Economy Class CWT Negotiated Fare    expected_airline_commission_percentage=20.00    expected_fuel_surcharge=2000
    ...    expected_transaction_fee=200    expected_commission_rebate_percentage=2.00    expected_markup_percentage=2.00    expected_selected_restriction=Template
    #Start of Exchange Process
    Exchange Ticketed PNR    S2    SINHKG/ACX    SS1J1    3
    Click Read Booking    True
    Verify Exchange Pop-up Window Is Displayed    is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box.    verification_mode=contains    multi_line_search_flag=true
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    # Get Air Fare Details
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 1    S3    country=HK
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Savings Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    HK
    # High, Charged And Low Fare
    Verify High Fare Value Is Same From Exchange TST    Fare 1
    Verify Charged Fare Value Is Same From Exchange TST    Fare 1
    Verify Low Fare Value Is Same From Exchange TST    Fare 1
    # Defaulting Of Realised
    Verify Realised Savings Code Default Value    EX - EXCHANGE
    # Calculation Upon Initial Load
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1    rounding_so=down
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1    airline_commision_or_client_rebate=Client Rebate    is_exchange=true
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    #Update Values
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Set High Fare Field    123
    Set Charged Fare Field    123
    Set Low Fare Field    12
    Set Nett Fare Field    Fare 1    600
    Set Fuel Surcharge Field    25
    Set Transaction Fee    250
    Set Markup Percentage    Fare 1    5.00
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    #Get Updated Values
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Savings Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    HK
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1    rounding_so=down
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1    Client Rebate    is_exchange=true
    Verify MarkUp Amount Value Is Correct    Fare 1    HK    rounding_so=up
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Fare Tab    Fare 2
    # Get Air Fare Details
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 2    S2    country=HK
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Routing, Turnaround and Route Code    Fare 2
    Get LFCC Field Value    Fare 2
    Get Savings Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    HK
    # High, Charged And Low Fare
    Verify High Fare Value Is Same From Exchange TST    Fare 2
    Verify Charged Fare Value Is Same From Exchange TST    Fare 2
    Verify Low Fare Value Is Same From Exchange TST    Fare 2
    # Defaulting Of Realised
    Verify Realised Savings Code Default Value    EX - EXCHANGE
    # Calculation Upon Initial Load
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2    rounding_so=down
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    airline_commision_or_client_rebate=Client Rebate    is_exchange=true
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    # Calculation Upon Changing Values
    Select Form Of Payment Value On Fare Quote Tab    Fare 2    Cash
    Select Realised Saving Code Value    MC - MISCELLANEOUS
    Select Missed Saving Code Value    K - CLIENT NEGOTIATED FARE DECLINED
    Select Class Code Value    FF - First Class Full Fare
    Set Transaction Fee    600
    Set Fuel Surcharge Field    30
    Set Markup Percentage    Fare 2    3.00
    Set Commission Rebate Percentage    13
    Populate Fare Details And Fees Tab With Default Values    Fare 2
    #Get Updated Values
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Routing, Turnaround and Route Code    Fare 2
    Get LFCC Field Value    Fare 2
    Get Savings Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    HK
    #Fee Calculations
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2    rounding_so=down
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    airline_commision_or_client_rebate=Client Rebate    is_exchange=true
    Verify MarkUp Amount Value Is Correct    Fare 2    HK    rounding_so=up
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Click Panel    Recap
    Click Finish PNR    Amend Ticket Exchange For Multiple Exchange

Amend Ticket Exchange For Single Exchange
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    #Start Exchange Process
    Exchange Ticketed PNR    S3    MNLLAX/APR    SS1Y1    3    2
    Click Read Booking    True
    Verify Exchange Pop-up Window Is Displayed    is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box.    verification_mode=contains    multi_line_search_flag=true
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    # Fare 1
    Click Fare Tab    Fare 1
    # Get Air Fare Details
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Savings Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    HK
    #Populate Fields
    Select Form Of Payment Value On Fare Quote Tab    Fare 1    Cash
    Set Transaction Fee    600
    Set Fuel Surcharge Field    30
    Set Commission Rebate Percentage    2
    Set Markup Percentage    Fare 1    2
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Savings Code    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1    HK
    #Verify Fees
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1    rounding_so=down
    Verify Merchant Fee Fields Are Disabled    Fare 1
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1    Client Rebate
    Verify MarkUp Amount Value Is Correct    Fare 1    HK    rounding_so=up
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    #Fare 2
    Click Fare Tab    Fare 2
    # Get Air Fare Details
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 2    S3    country=HK
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Routing, Turnaround and Route Code    Fare 2
    Get LFCC Field Value    Fare 2
    Get Savings Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    HK
    # High, Charged And Low Fare
    Verify High Fare Value Is Same From Exchange TST    Fare 2
    Verify Charged Fare Value Is Same From Exchange TST    Fare 2
    Verify Low Fare Value Is Same From Exchange TST    Fare 2
    # Calculation Upon Loading
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2    rounding_so=down
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    Client Rebate    is_exchange=true
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    # Defaulting Of Realised
    Verify Realised Savings Code Default Value    EX - EXCHANGE
    # Calculation Upon Changing Values
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 2    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 2    CWT
    Select Missed Saving Code Value    N - CLIENT SPECIFIC
    Select Class Code Value    YW - Economy Class CWT Negotiated Fare
    Set Commission Rebate Percentage    2.00
    Set Merchant Fee Percentage Field    2.00
    Set Markup Percentage    Fare 2    2.00
    Set Airline Commission Percentage    20
    Set Transaction Fee    200
    Set Fuel Surcharge Field    2000
    Select Air Fare Restrictions Radio Button    Fare 2    Template
    Select Air Fare Restrictions In Fare Quote    Fare 2    NO SHOW PENALTY APPLIES
    Populate Fare Details And Fees Tab With Default Values    Fare 2
    #Get Updated Values
    Get Savings Code    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    HK
    #Verify Calculations
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2    rounding_so=down
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 2    Client Rebate    has_client_cwt_comm_agreement=Yes    rounding_so=up
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    airline_commision_or_client_rebate=Client Rebate    is_exchange=true
    Verify MarkUp Amount Value Is Correct    Fare 2    HK    rounding_so=up
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Click Panel    Recap
    Click Finish PNR    Amend Ticket Exchange For Single Exchange

Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket
    [Arguments]    ${fare_tab}    ${segment_number}    ${is_manual_exchange}=False    ${country}=SG
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${number}    Remove All Non-Integer (retain period)    ${segment_number}
    ${number}    Evaluate    ${number} - 2
    ${ticket_number}    Get From List    ${ticket_numbers}    ${number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    #Getting Currency Based on Country
    ${currency}    Get Currency    ${country}
    Run Keyword If    ${is_manual_exchange}    Get Base Fare, Grand Total and LFCC from TST for Manual Exchange    ${fare_tab}    ${segment_number}    ${country}
    ...    ELSE    Get Base Fare, Total Additional Collection and LFCC for ATC    ${fare_tab}    ${segment_number}    ${country}
    ${grand_total}    Evaluate    ${base_fare_${fare_tab_index}}+${total_tax_${fare_tab_index}}
    ${grand_total}    Run Keyword If    ${is_manual_exchange}    Set Variable    ${grand_total}
    ...    ELSE    Get Variable Value    ${total_add_coll_${fare_tab_index}}    ${grand_total}
    ${grand_total}    Round Apac    ${grand_total}    ${country}
    Set Suite Variable    ${total_add_coll_${fare_tab_index}}    ${grand_total}
    Set Suite Variable    ${grand_total_value_${fare_tab_index}}    ${grand_total}
    [Teardown]    Take Screenshot

Amend Ticket Exchange For Single Exchange IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Click Panel    Complete
    Exchange Ticketed PNR    S2    DELBOM/AUK    SS1Y1    5    4
    Click Read Booking    True
    Verify Exchange Pop-up Window Is Displayed    Fare 1 is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box    verification_mode=contains    multi_line_search_flag=true
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    # Get Air Fare Details
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 1    S2    country=IN
    Set Nett Fare Field    Fare 1    1000
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get Savings Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    #Fare 1
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 1
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 1    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 1    is_exchange=true
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 1
    Click Finish PNR    Amend Ticket Exchange For Single Exchange IN

Get Base Fare, Grand Total and LFCC from TST for Manual Exchange
    [Arguments]    ${fare_tab}    ${segment_number}    ${country}
    Get Total Tax From TST    ${segment_number}    ${country}
    Comment    Get Base Fare From TST    ${fare_tab}    ${segment_number}
    Enter GDS Command    RT    TQT/${segment_number}
    Get Grand Total Fare From Amadeus    ${fare_tab}
    Get LFCC From FV Line in TST    ${fare_tab}    ${segment_number}
    ${base_fare}    Evaluate    ${grand_total_fare_${fare_tab_index}}-${total_unpaid_tax}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare}
    Set Suite Variable    ${total_tax_${fare_tab_index}}    ${total_unpaid_tax}

Get Base Fare, Total Additional Collection and LFCC for ATC
    [Arguments]    ${fare_tab}    ${segment_number}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    ${number}    Remove All Non-Integer (retain period)    ${segment_number}
    ${number}    Evaluate    ${number} - 2
    ${ticket_number}    Get From List    ${ticket_numbers}    ${number}
    Get Total Tax From TST    ${segment_number}    ${country}
    Set Suite Variable    ${total_tax_${fare_tab_index}}    ${total_unpaid_tax}
    Enter GDS Command    RT    FXF/${segment_number}/TKT${ticket_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    #Getting Base Fare
    ${base_fare_raw}    Get Lines Containing String    ${data_clipboard}    FARE BALANCE
    ${base_fare_splitted}    Split String    ${base_fare_raw}    ${SPACE}
    ${base_fare_splitted}    Remove Duplicate From List    ${base_fare_splitted}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare_splitted[4]}
    #Getting Total Add Coll
    ${total_add_coll_raw}    Get Lines Containing String    ${data_clipboard}    TOTAL ADD COLL
    ${total_add_coll_splitted}    Split String    ${total_add_coll_raw}    ${SPACE}
    ${total_add_coll_splitted}    Remove Duplicate From List    ${total_add_coll_splitted}
    Set Suite Variable    ${total_add_coll_${fare_tab_index}}    ${total_add_coll_splitted[5]}
    #Getting LFCC
    ${lfcc_in_tst_raw}    Get Lines Containing String    ${data_clipboard}    BG CXR:
    ${lfcc_in_tst_splitted}    Split String    ${lfcc_in_tst_raw}    ${SPACE}
    ${lfcc_in_tst_splitted}    Remove Duplicate From List    ${lfcc_in_tst_splitted}
    ${lfcc_in_tst_splitted}    Get Variable Value    ${lfcc_in_tst_splitted[2]}    0
    Set Suite Variable    ${lfcc_in_tst_${fare_tab_index}}    ${lfcc_in_tst_splitted}

Create EMD And TSM In GDS
    [Arguments]    ${segment_number}    ${airline_code}    ${refund_amount}    ${line_number}
    ${departure_date}    Generate Date X Months From Now    7    0    %d%b
    Activate Power Express Window
    Enter GDS Command    EGSD/V${airline_code}
    Enter GDS Command    IU ${airline_code} NN1 PENF SIN/ ${departure_date}
    Enter GDS Command    TMC/V${airline_code}/L${line_number}
    Enter GDS Command    TMI/YI
    Enter GDS Command    TMI/F${refund_amount}/CV-${refund_amount}
    Enter GDS Command    TMI/FP-CASH
    ${number}    Remove All Non-Integer (retain period)    ${segment_number}
    ${number}    Evaluate    ${number} - 2
    ${ticket_number}    Get From List    ${ticket_numbers}    ${number}
    ${ticket_number}    Remove All Non-Integer (retain period)    ${ticket_number}
    Enter GDS Command    TMI/IC-TKT${ticket_number}
    Enter GDS Command    RFTEST
    Enter GDS Command    STARNK    TQM
    Enter GDS Command    RFTEST
    Enter GDS Command    TTM/M1
    Enter GDS Command    RT${current_pnr}
    [Teardown]    Take Screenshot

Verify Prepopulated Values in Fare Tab
    [Arguments]    ${fare_tab}    ${expected_high_fare}=${EMPTY}    ${expected_charged_fare}=${EMPTY}    ${expected_low_fare}=${EMPTY}    ${expected_realised_saving_code}=${EMPTY}    ${expected_missed_saving_code}=${EMPTY}
    ...    ${expected_class_code}=${EMPTY}    ${expected_airline_commission_percentage}=${EMPTY}    ${expected_nett_fare}=${EMPTY}    ${expected_fuel_surcharge}=${EMPTY}    ${expected_transaction_fee}=${EMPTY}    ${expected_commission_rebate_percentage}=${EMPTY}
    ...    ${expected_merchant_fee_percentage}=${EMPTY}    ${expected_markup_percentage}=${EMPTY}    ${expected_selected_restriction}=Default    ${country}=HK
    [Documentation]    Use for checking pre-populated values.
    Get High, Charged And Low Fare In Fare Tab    ${fare_tab}
    Get Savings Code    ${fare_tab}
    Get Airline Commisison Percentage Value    ${fare_tab}
    Get Nett Fare Value    ${fare_tab}
    Run Keyword If    "${country}"=="HK"    Get Fuel Surcharge Value    ${fare_tab}
    Get Transaction Fee Amount Value    ${fare_tab}
    Get Commission Rebate Percentage Value    ${fare_tab}
    Get Merchant Fee Percentage Value    ${fare_tab}
    Get MarkUP Percentage Value    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Run Keyword And Continue On Failure    Run Keyword If    "${expected_high_fare}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_high_fare}    ${high_fare_${fare_tab_index}}
    Run Keyword And Continue On Failure    Run Keyword If    "${expected_charged_fare}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_charged_fare}    ${charged_fare_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_low_fare}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_low_fare}    ${low_fare_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_realised_saving_code}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_realised_saving_code}    ${realised_text_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_missed_saving_code}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_missed_saving_code}    ${missed_text_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_class_code}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_class_code}    ${class_text_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_airline_commission_percentage}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_airline_commission_percentage}    ${airline_commission_percentage_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_nett_fare}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_nett_fare}    ${nett_fare_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_fuel_surcharge}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_fuel_surcharge}    ${fuel_surcharge_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_transaction_fee}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_transaction_fee}    ${transaction_fee_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_commission_rebate_percentage}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_commission_rebate_percentage}    ${commission_rebate_percentage_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_merchant_fee_percentage}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_merchant_fee_percentage}    ${merchant_fee_percentage_value_${fare_tab_index}}
    Run Keyword And Continue on Failure    Run Keyword If    "${expected_markup_percentage}"!="${EMPTY}"    Should Be Equal As Strings    ${expected_markup_percentage}    ${mark_up_value_${fare_tab_index}}
    Click Restriction Tab
    Verify Pre-Selected Option On Restrictions Tab    ${expected_selected_restriction}

Amend To Verify That Exchange Fares Calculation For Main Fees And Remarks Are Correct For Manual Re-Issuance
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA/AX***********0006/D1028
    Click Panel    Complete
    Enter GDS Command    XE3
    Book Flight X Months From Now    GOIDEL/AUK    SS1Y1    FXP/S3    5    5
    Generate Data For Exchange Ticket    EX2    INR    1000    ${EMPTY}    ${EMPTY}    50-YRVA
    ...    30-L7DE    20-OPAE    1100
    Set TST For Manual Reissue    S3    EX2    False
    Create Original/Issued In Exchange For (FO)    0    S3
    Click Read Booking    True
    Verify Exchange Pop-up Window Is Displayed    is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box    verification_mode=contains    multi_line_search_flag=true
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 2
    Verify Realised Savings Code Default Value    EX - EXCHANGE
    Select FOP Merchant On Fare Quote Tab    Fare 2    CWT
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Base Fare, Taxes, Total Fare And LFCC From Exchange Ticket    Fare 2    S3    True    IN
    Get Routing, Turnaround and Route Code    Fare 2
    Get LFCC Field Value    Fare 2
    Set Commission Rebate Percentage    3.00
    Populate Fare Details And Fees Tab With Default Values    Fare 2
    Get Main Fees On Fare Quote Tab    Fare 2    IN
    Verify Commission Rebate Amount Is Correct Based On Computed Value    Fare 2
    Verify Merchant Fee Amount Is Correct Based On Computed Value    Fare 2    Client Rebate    has_client_cwt_comm_agreement=Yes
    Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value    Fare 2    Client Rebate
    Verify Total Amount Value Is Correct Based On Computed Value    Fare 2
    Get Savings Code    Fare 2
    Click Finish PNR    Amend To Verify That Exchange Fares Calculation For Main Fees And Remarks Are Correct For Manual Re-Issuance
