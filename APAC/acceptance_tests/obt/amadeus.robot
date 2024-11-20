*** Settings ***
Force Tags        amadeus
Resource          obt_verification.robot
Resource          amend.robot
Resource          ../air_fare/air_fare_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[AB IN] Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Agent Assisted
    [Tags]    us2121    us2127    in
    # Create a PNR
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ IN OBT AUTOMATION    BEAR    OBT
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Update PNR With Default Values    Client Info
    Book Flight X Months From Now    BOMSIN/ASQ    SS1Y1    FXP/S2    5
    Book Flight X Months From Now    SINHKG/ASQ    SS1Y1    FXP/S3    5    20
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Click Clear All
    #Issuing Tickets
    Verify Tickets Are Successfully Issued    S2
    Verify Tickets Are Successfully Issued    S3
    Get Ticket Number From PNR
    #Exchanging Tickets
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Complete
    #ATC Flow (Exchanging Tickets)
    Exchange Ticketed PNR    S2    DELSIN/ASQ    SS1Y1    5    10
    # Manual Re-Issuance Flow (Exchanging Tickets)
    Enter GDS Command    XE3
    Book Flight X Months From Now    SINDEL/ASQ    SS1Y1    FXP/S3    5    25
    Generate Data For Exchange Ticket    EX2    INR    1000    ${EMPTY}    ${EMPTY}    50-YRVA
    ...    30-L7DE    20-OPAE    1100
    Set TST For Manual Reissue    S3    EX2    False
    Create Original/Issued In Exchange For (FO)    0    S3    
    Click Read Booking    
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Ticket Exchange
    Execute Simultaneous Change Handling    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Ticket Exchange
    # Mimic OBT PNR with Touch Level -EB and OBT Code - CYT
    Modify Offline PNR to Online    CYT
    Update FF34 and FF35 for Segment    CYT    EB    2    FF34
    Update FF34 and FF35 for Segment    CYT    EB    3    FF34
    Delete Remarks Lines From PNR    TFA    RTR
    Delete Remarks Lines From PNR    FF35    RTY
    # Amend Flow and Verification
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Online    Assisted
    Click Fare Tab    Fare 2
    Get Base Fare, Total Taxes And LFCC    Fare 2    S3
    Get Nett Fare Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Online    Assisted
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Agent Assisted
    Execute Simultaneous Change Handling    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Agent Assisted
    Verify FF Remarks In PNR    AM6    AA    2
    Verify FF34 FF35 And FF36 Values Are Written In PNR    AA    AM6    S    2
    Verify FF Remarks In PNR    AM6    AA    3
    Verify FF34 FF35 And FF36 Values Are Written In PNR    AA    AM6    S    3
    
[AB IN] Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Offline
    [Tags]    us298    us440    us933    us2121    us2127    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Offline
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Offline    Flat
    Click Fare Tab    Fare 2
    Get Base Fare, Total Taxes And LFCC    Fare 2    S3
    Get Nett Fare Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Offline    Flat
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Offline
    Execute Simultaneous Change Handling    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Offline
    Verify FF Remarks In PNR    AM6    AM    2
    Verify FF34 FF35 And FF36 Values Are Written In PNR    AM    AM6    S    2
    Verify FF Remarks In PNR    AM6    AM    3
    Verify FF34 FF35 And FF36 Values Are Written In PNR    AM    AM6    S    3

[AB IN] Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Online Unassisted
    [Tags]    us298    us440    us933    us2127    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Offline
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Online Unassisted
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes And LFCC    Fare 1    S2
    Get Nett Fare Value    Fare 1
    Verify Transaction Fee Value Is Correct    Fare 1    IN    Online    Unassisted
    Click Fare Tab    Fare 2
    Get Base Fare, Total Taxes And LFCC    Fare 2    S3
    Get Nett Fare Value    Fare 2
    Verify Transaction Fee Value Is Correct    Fare 2    IN    Online    Unassisted
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Online Unassisted
    Execute Simultaneous Change Handling    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Online Unassisted
    Verify FF Remarks In PNR    CYT    EB    2
    Verify FF34 FF35 And FF36 Values Are Written In PNR    EB    CYT    S    2
    Verify FF Remarks In PNR    CYT    EB    3
    Verify FF34 FF35 And FF36 Values Are Written In PNR    EB    CYT    S    3
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify That The Correct Identifiers Are Written For Multiple VFF AM_EAM
    [Tags]    in
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US438    BEAR    test
    Select Client Account Using Default Value
    Click New Booking
    Update PNR With Default Values
    Book Active Car Segment    LAX    6    1    6    1    ET
    ...    1    CCAR
    Click Read Booking
    Click Car Tab    1    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR
    Add OBT Remark    EAM
    Delete Segment Relate Remarks For Car
    Update Remark FF VFF And Delete Segment Relate    VFF34    2    AM    ${EMPTY}
    Delete Remarks For FF And VFF    VFF35    2
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Does Not Contain Expected Panel    Amend
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Click Car Tab    1    by_tab_number=True
    Verify touch level default value for car panel    AM - Offline
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    GDS
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For Multiple VFF AM_EAM
    Execute Simultaneous Change Handling    Amend Booking For Verify That The Correct Identifiers Are Written For Multiple VFF AM_EAM
    Verify VFF Remarks Are Written In PNR    EAM    AM    2    GDS
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify That the Correct identifiers Are Written for multiple VFF AA_EBA
    [Tags]    in    for_update
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US438    BEAR    TEST
    Select Client Account Using Default Value
    Click New Booking
    Update PNR With Default Values
    Book Active Car Segment    LAX    6    1    6    1    ET
    ...    1    CCAR
    Click Read Booking
    Click Car Tab    1    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR
    Add OBT Remark    EBA
    Delete Segment Relate Remarks For Car
    Update Remark FF VFF And Delete Segment Relate    VFF34    2    EB    ${EMPTY}
    Delete Remarks For FF And VFF    VFF35    2
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    BOMSIN/ASQ    SS1Y1    FXP/S3    6    3
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Click Car Tab    1    by_tab_number=True
    Verify touch level default value for car panel    AA - Agent Assisted
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    GDS
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That the Correct identifiers Are Written for multiple VFF AA_ZZ
    Execute Simultaneous Change Handling    Amend Booking For Verify That the Correct identifiers Are Written for multiple VFF AA_ZZ
    Verify VFF Remarks Are Written In PNR    EBA    AA    2    GDS
    Verify FF Remarks In PNR    EBA    AA    3
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify That The Correct Identifiers Are Written For FF And VFF AA_GET
    [Tags]    in
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US438    BEAR    hong
    Select Client Account Using Default Value    
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    HKGSIN/ASQ    SS1Y1    FXP    6    5
    Book Active Car Segment    LAX    6    1    6    1    ET
    ...    1    CCAR
    Click Read Booking
    Click Panel    Car
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR
    Delete Segment Relate Remarks For Car
    Delete Segment Relate Remarks For Air
    Update Remark FF VFF And Delete Segment Relate    VFF34    2    AA    ${EMPTY}
    Update Remark FF VFF And Delete Segment Relate    VFF35    2    ${EMPTY}    GET
    Update Remark FF VFF And Delete Segment Relate    FF34    3    AA    ${EMPTY}
    Update Remark FF VFF And Delete Segment Relate    FF35    3    ${EMPTY}    GET
    Delete Remarks Lines From PNR    MSX
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Verify Touch Level Default Value For Car Panel    AM - Offline
    Verify Touch Level Dropdown Values For Car Panel    AA - Agent Assisted    AM - Offline    EB - Online Unassisted
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    Manual
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For FF And VFF AA_GET
    Execute Simultaneous Change Handling    Amend Booking For Verify That The Correct Identifiers Are Written For FF And VFF AA_GET
    Verify VFF Remarks Are Written In PNR    GET    AM    2    Manual
    Verify FF Remarks In PNR    GET    AM    3
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify That The Correct Identifiers Are Written For VFF And FF EB_CYT
    [Tags]    in    for_update
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA    Amadeus
    Create New Booking With One Way Flight Using Default Values    XYZ Company PV2 ¦ AUTOMATION IN - US438    BEAR    test    HKGSIN/ASQ
    Click Finish PNR
    Delete Segment Relate Remarks For Air
    Add OBT Remark    CYT
    Update Remark FF VFF And Delete Segment Relate    FF34    2    EB    ${EMPTY}
    Delete Remarks For FF And VFF    FF35    2
    Delete Remarks Lines From PNR    MSX
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Active Car Segment    LAX    6    1    6    1    ET
    ...    1    CCAR
    Book Active Car Segment    LAX    7    1    7    1    ET
    ...    2    CCAR
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Online Unassisted
    Verify Actual Panel Contains Expected Panel    Car
    Click Car Tab    1    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Verify touch level default value for car panel    ${EMPTY}
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Select Touch level in car panel    EB - Online Unassisted
    Click Car Tab    2    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Verify touch level default value for car panel    ${EMPTY}
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Select Touch level in car panel    EB - Online Unassisted
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For VFF And FF EB_CYT
    Execute Simultaneous Change Handling    Amend Booking For Verify That The Correct Identifiers Are Written For VFF And FF EB_CYT
    Verify FF Remarks In PNR    CYT    EB    2
    Verify VFF Remarks Are Written In PNR    CYT    EB    3    GDS
    Verify VFF Remarks Are Written In PNR    CYT    EB    4    GDS
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That For OBT PNR, Amend Panel, Touch Level Dropdown and values are availabe and are selectable
    Retrieve PNR Details    ${current_pnr}
    Modify Offline PNR to Online    CYT
    Update FF34 and FF35 for Segment    CYT    EB    2    FF34    FF35
    Update FF34, FF35 in PNR Remarks    CYT    EB    2
    Update FF34 and FF35 for Segment    CYT    EB    3    FF34    FF35
    Update FF34, FF35 in PNR Remarks    CYT    EB    3
    End And Retrieve PNR
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Offline
    Click Panel    Client Info
    Select Form Of Payment    BTA VI/VI***********0235/D0623/CVV***
    Click Panel    Air Fare
    Populate Fare Details And Fees Tab With Default Values
    Click Fare Tab    Fare 1
    Select Form Of Payment On Fare Quote Tab    Fare 1    BTA VI/VI***********0235/D0623/CVV***
    Select Merchant On Fare Quote Tab    CWT
    Click Fare Tab    Fare 2
    Get Transaction Fee Amount Value    Fare 2
    Select Form Of Payment On Fare Quote Tab    Fare 2    BTA VI/VI***********0235/D0623/CVV***
    Select Merchant On Fare Quote Tab    CWT
    Populate All Panels (Except Given Panels If Any)    Air Fare    Client Info
    Click Finish PNR    Amend Booking For Verify That For OBT PNR, Amend Panel, Touch Level Dropdown and values are availabe and are selectable

Enter FF34 Code
    [Arguments]    ${line_number}    ${obt_code}    ${touch_level_code}    ${segment}
    : FOR    ${INDEX}    IN RANGE    10
    \    Enter GDS Command    RT    ${line_number}/ *FF34/${touch_level_code}/S${segment}
    \    ${clip}    Get Clipboard Data Amadeus    RFCWTPTEST
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Enter FF35 Code
    [Arguments]    ${line_number}    ${obt_code}    ${segment}
    : FOR    ${INDEX}    IN RANGE    10
    \    Enter GDS Command    RT    ${line_number}/ *FF35/${obt_code}/S${segment}
    \    ${clip}    Get Clipboard Data Amadeus    RFCWTPTEST
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Get Line Number of Remark
    [Arguments]    ${ff}    ${segment}
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    ${number}    Run Keyword If    "${ff}" == "FF34"    Get Line Number In Amadeus PNR Remarks    ${ff}/AB/S${segment}
    ...    ELSE IF    "${ff}" == "FF35"    Get Line Number In Amadeus PNR Remarks    ${ff}/AMA/S${segment}
    [Return]    ${number}

Modify Offline PNR to Online
    [Arguments]    ${obt_code}
    : FOR    ${INDEX}    IN RANGE    10
    \    Enter GDS Command    RT    RM *BT/${obt_code}    RFCWTPTEST
    \    ${clip}    Get Clipboard Data Amadeus    ER
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    IR

Update FF34 and FF35 for Segment
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}    @{ff_value}
    : FOR    ${ff}    IN    @{ff_value}
    \    ${line_number}    Get Line Number of Remark    ${ff}    ${segment}
    \    Run Keyword If    "${ff}" == "FF34"    Enter FF34 Code    ${line_number}    ${obt_code}    ${touch_level_code}
    \    ...    ${segment}
    \    Run Keyword If    "${ff}" == "FF35"    Enter FF35 Code    ${line_number}    ${obt_code}    ${segment}

Update FF34, FF35 in PNR Remarks
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    : FOR    ${INDEX}    IN RANGE    10
    \    Update Multiple Lines With FF34, FF35 in PNR Remarks    ${obt_code}    ${touch_level_code}    ${segment}
    \    ${clip}    Get Clipboard Data Amadeus    RFCWTPTEST
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER

Update FF34 And FF35 And Delete Segment
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}    @{ff_value}
    : FOR    ${ff}    IN    @{ff_value}
    \    ${line_number}    Get Line Number of Remark    ${ff}    ${segment}
    \    Run Keyword If    "${ff}" == "FF34"    Enter FF34 Code Without Segment    ${line_number}    ${obt_code}    ${touch_level_code}
    \    Run Keyword If    "${ff}" == "FF35"    Enter FF35 Code Without Segment    ${line_number}    ${obt_code}

Enter FF34 Code Without Segment
    [Arguments]    ${line_number}    ${obt_code}    ${touch_level_code}
    : FOR    ${INDEX}    IN RANGE    10
    \    Enter GDS Command    RT    ${line_number}/ *FF34/${touch_level_code}
    \    ${clip}    Get Clipboard Data Amadeus    RFCWTPTEST
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Enter FF35 Code Without Segment
    [Arguments]    ${line_number}    ${obt_code}
    : FOR    ${INDEX}    IN RANGE    10
    \    Enter GDS Command    RT    ${line_number}/ *FF35/${obt_code}
    \    ${clip}    Get Clipboard Data Amadeus    RFCWTPTEST
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    ${clip}    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Update Multiple Lines With FF34, FF35 in PNR Remarks
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    ${pnr_details}    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    ${line}    Get Lines Containing String    ${pnr_details}    MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/S${segment}
    @{line}    Split To Lines    ${line}
    @{line_numbers}    Create List
    : FOR    ${each_line}    IN    @{line}
    \    ${splitted_data}    Split String    ${each_line.strip()}    ${SPACE}
    \    Append To List    ${line_numbers}    ${splitted_data[0]}
    : FOR    ${each_line}    IN    @{line_numbers}
    \    Enter GDS Command    RT    ${each_line}/ *MSX/FF34-${touch_level_code}/FF35-${obt_code}/FF36-G/FF47-CWT/S${segment}

Delete Remarks Lines From PNR
    [Arguments]    ${remark_value}    ${command}=RTY
    Retrieve PNR Details From Amadeus    ${current_pnr}    ${command}    False
    @{line_numbers}    Get Line Numbers In Amadeus PNR Remarks    ${remark_value}
    ${line_numbers}    Evaluate    ",".join(${line_numbers})
    Enter GDS Command    XE${line_numbers}
    End And Retrieve PNR

Amend Booking For Verify That The Correct Identifiers Are Written For VFF And FF EB_CYT
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Active Car Segment    LAX    6    1    6    1    ET
    ...    1    CCAR
    Book Active Car Segment    LAX    7    1    7    1    ET
    ...    2    CCAR
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Online Unassisted
    Verify Actual Panel Contains Expected Panel    Car
    Click Car Tab    1    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Verify touch level default value for car panel    ${EMPTY}
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Select Touch level in car panel    EB - Online Unassisted
    Click Car Tab    2    by_tab_number=True
    Populate Car Tab With Values    150.00    150.00    150.00    MC - MISCELLANEOUS    M - MISCELLANEOUS    1 - Prepaid
    ...    No    0.00    GDS    NA
    Verify touch level default value for car panel    ${EMPTY}
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Select Touch level in car panel    EB - Online Unassisted
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For VFF And FF EB_CYT

Amend Booking For Verify That the Correct identifiers Are Written for multiple VFF AA_ZZ
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    BOMSIN/ASQ    SS1Y1    FXP/S3    6    3
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Click Car Tab    1    by_tab_number=True
    Verify touch level default value for car panel    AA - Agent Assisted
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    GDS
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That the Correct identifiers Are Written for multiple VFF AA_ZZ

Amend Booking For Verify That The Correct Identifiers Are Written For FF And VFF AA_GET
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Verify Touch Level Default Value For Car Panel    AM - Offline
    Verify Touch Level Dropdown Values For Car Panel    AA - Agent Assisted    AM - Offline    EB - Online Unassisted
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    Manual
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For FF And VFF AA_GET

Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Offline
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Offline
    Click Panel    Client Info
    Select Form Of Payment    BTA AIR/VI************1122/D0622/CVV***
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Offline

Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Agent Assisted
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Agent Assisted

Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Ticket Exchange
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Complete
    Exchange Ticketed PNR    S2    DELSIN/ASQ    SS1Y1    5    10
    Enter GDS Command    XE3
    Book Flight X Months From Now    BLRDEL/AUK    SS1Y1    FXP/S3    5    25
    Generate Data For Exchange Ticket    EX2    INR    1000    ${EMPTY}    ${EMPTY}    50-YRVA
    ...    30-L7DE    20-OPAE    1100
    Set TST For Manual Reissue    S3    EX2    False
    Create Original/Issued In Exchange For (FO)    0    S3    
    Click Read Booking    
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Ticket Exchange
        
Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Online Unassisted
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Contains Expected Panel    Amend
    Click Panel    Amend
    Verify Touch Level Default Value    Agent Assisted
    Verify Touch Level Dropdown Values    Online Unassisted    Agent Assisted    Offline
    Select Touch Level    Online Unassisted
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That For OBT PNR Amend Panel Touch Level Dropdown Values are selectable and Remarks are generated - Online Unassisted

Amend Booking For Verify That The Correct Identifiers Are Written For Multiple VFF AM_EAM
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify Actual Panel Does Not Contain Expected Panel    Amend
    Verify Actual Panel Contains Expected Panel    Car
    Click Panel    Car
    Click Car Tab    1    by_tab_number=True
    Verify touch level default value for car panel    AM - Offline
    Verify Touch level Dropdown values for Car panel    AA - Agent Assisted    EB - Online Unassisted    AM - Offline
    Populate Car Tab Mandatory Fields    MC - MISCELLANEOUS    1 - Prepaid    No
    Select Booking Method In Car Panel    GDS
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Correct Identifiers Are Written For Multiple VFF AM_EAM
