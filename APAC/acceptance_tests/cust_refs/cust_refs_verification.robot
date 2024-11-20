*** Settings ***
Resource          ../../resources/panels/cust_refs.robot

*** Keywords ***
Book Passive Amadeus Car CAR Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Enter GDS Command    CU 1A HK1 ${city} ${departure_date}-${arrival_date} CCMR/BS-57202283/SUC-EP/SUN-EUROPCAR/SD-23NOV/ST-1700/ED-24NOV/ET-1700/TTL-100.00USD/DUR-DAILY/MI-50KM FREE/CF-FAKE

Book Passive Amadeus Car CCR Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Enter GDS Command    11ACSZE${city}${departure_date}-${arrival_date}/ARR-1500/RT-6P/VT-SCAR/RQ-SGD150.00/CF-1333344

Book Passive Amadeus HHL Hotel Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Enter GDS Command    11AHSJTLON423 ${departure_date}-${arrival_date}/CF-123456/RT-A1D/RQ-GBP425.00

Book Passive Amadeus HTL Hotel Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Enter GDS Command    HU1AHK1${city}${departure_date}-${arrival_date}/PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED

Get CDR Description And Value
    [Arguments]    ${country}=SG
    Wait Until Control Object Is Visible    [NAME:grpCDReferences]
    ${cdr_dict}    Create Dictionary
    : FOR    ${cdr_field_index}    IN RANGE    1    21
    \    ${cdr_field_description}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblCDRDescription${cdr_field_index}]
    \    ${cdr_field_value}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtCDRValue${cdr_field_index}]
    \    Set To Dictionary    ${cdr_dict}    ${cdr_field_description}    ${cdr_field_value}
    \    Run Keyword If    "${cdr_field_description}" == "DP Code" and "${country}" == "HK"    Set To Dictionary    ${cdr_dict}    ${cdr_field_description} 2    ${cdr_field_value}
    \    Run Keyword If    "${cdr_field_description}" == "PERSONNEL ID OR STAFF ID" and "${country}" == "HK"    Set To Dictionary    ${cdr_dict}    ${cdr_field_description} 2    ${cdr_field_value}
    \    Run Keyword If    "${cdr_field_description}" == "Business Unit" and "${country}" == "IN"    Set To Dictionary    ${cdr_dict}    ${cdr_field_description} 2    ${cdr_field_value}
    \    Run Keyword If    "${cdr_field_description}" == "Employee ID" and "${country}" == "IN"    Set To Dictionary    ${cdr_dict}    ${cdr_field_description} 2    ${cdr_field_value}
    Set Suite Variable    ${cdr_dict}    ${cdr_dict}
    [Teardown]    Take Screenshot

Get CDR Remarks From GDS Screen
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RTY
    Comment    ${cdr_data_clipboard1}    Get Clipboard Data Amadeus
    Comment    Enter GDS Command    MD
    Comment    ${cdr_data_clipboard2}    Get Clipboard Data Amadeus
    Comment    ${cdr_data_clipboard}    Catenate    ${cdr_data_clipboard1}    ${cdr_data_clipboard2}
    ${cdr_data_clipboard}    Get Clipboard Data Amadeus
    [Return]    ${cdr_data_clipboard}

Verify CDR Accounting Remarks For Air Are Not Written
    [Arguments]    ${country}    ${workflow}
    ${orig_cust_refs}    Create Dictionary
    Run Keyword If    "${country}"=="HK"    Set To Dictionary    ${orig_cust_refs}    DP Code    10/    DP Code 2
    ...    63/    DP Code    4/    COUNTRY E.G. HK    3/    DIVISON E.G. GLOBAL FINANCE
    ...    2/    GRADE - OPTIONAL    18/    LOCAL ENTITY    19/    PERSONNEL ID OR STAFF ID
    ...    16/    PERSONNEL ID OR STAFF ID 2    9/    TRAVEL REASON E.G. INTERNA MEETING    13/    TRAVEL REQUEST NO
    ...    11/    TRAVEL REQUEST NO    14/    TRAVEL REQUEST REASON    64/    DEPARTMENT
    ...    15/
    Run Keyword If    "${country}"=="SG"    Set To Dictionary    ${orig_cust_refs}    Travler Type Alpha Policy Code    15/    GEID
    ...    11/    MSL 8    13/    MSL 9    13/    Revenue/Non Revenue Generating
    ...    17/    DEALCODE    19/    No Hotel Reason Code    18/    OFFLINE
    ...    16/    Employee ID    10/    Cost Centre    12/
    Run Keyword If    "${country}"=="IN"    Set To Dictionary    ${orig_cust_refs}    Business    15/    Business Unit
    ...    14/    Business Unit 2    63/    Company    13/    Company ID
    ...    78/    DP Code    18/    Cost Centre    17/    Department
    ...    16/    Designation    20/    Employee ID    25/    Employee ID 2
    ...    12/    INTL Approver ID    77/    Invoice narration 1    67/    Invoice narration 2
    ...    68/    Invoice narration 3    69/    Job Band    73/    Location Code
    ...    19/    Manager ID    74/    Manager Name    75/    Name of INTL Approver
    ...    76/
    Log    ${orig_cust_refs}
    ${update_cdr}    Get CDR Remarks From GDS Screen
    ${cdr_description}    Get Dictionary Keys    ${orig_cust_refs}
    : FOR    ${cdr_index}    IN    @{cdr_description}
    \    Log    CDR: ${cdr_index}
    \    ${cdr_value}    Get From Dictionary    ${cdr_dict}    ${cdr_index}
    \    ${pnr_format}    Get From Dictionary    ${orig_cust_refs}    ${cdr_index}
    \    ${pnr_remark}    Run Keyword If    "${cdr_value}" != "${EMPTY}" and "${pnr_format}" !="${EMPTY}"    catenate    SEPARATOR=    RM *FF${pnr_format}
    \    ...    ${cdr_value}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Comment    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${update_cdr}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${update_cdr}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    0
    \    Comment    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${pnr_details}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${pnr_details}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    0

Verify CDR Accounting Remarks For Air Are Written
    [Arguments]    ${country}    ${workflow}
    ${orig_cust_refs}    Create Dictionary
    Run Keyword If    "${country}"=="HK"    Set To Dictionary    ${orig_cust_refs}    DP Code    10/    DP Code 2
    ...    63/    DP Code    4/    COUNTRY E.G. HK    3/    DIVISON E.G. GLOBAL FINANCE
    ...    2/    GRADE - OPTIONAL    18/    LOCAL ENTITY    19/    PERSONNEL ID OR STAFF ID
    ...    16/    PERSONNEL ID OR STAFF ID 2    9/    TRAVEL REASON E.G. INTERNA MEETING    13/    TRAVEL REQUEST NO
    ...    11/    TRAVEL REQUEST REASON    64/    DEPARTMENT    15/
    Run Keyword If    "${country}"=="SG"    Set To Dictionary    ${orig_cust_refs}    Travler Type Alpha Policy Code    15/    GEID
    ...    11/    MSL 8    13/    MSL 9    14/    Revenue/Non Revenue Generating
    ...    17/    DEALCODE    19/    No Hotel Reason Code    18/    OFFLINE
    ...    16/    Employee ID    10/    Cost Centre    12/
    Run Keyword If    "${country}"=="IN"    Set To Dictionary    ${orig_cust_refs}    Business    15/    Business Unit
    ...    14/    Business Unit 2    63/    Company    13/    Company ID
    ...    78/    DP Code    18/    Cost Centre    17/    Department
    ...    16/    Designation    20/    Employee ID    25/    Employee ID 2
    ...    12/    INTL Approver ID    77/    Invoice narration 1    67/    Invoice narration 2
    ...    68/    Invoice narration 3    69/    Job Band    73/    Location Code
    ...    19/    Manager ID    74/    Manager Name    75/    Name of INTL Approver
    ...    76/
    Log    ${orig_cust_refs}
    ${update_cdr}    Get CDR Remarks From GDS Screen
    ${cdr_description}    Get Dictionary Keys    ${orig_cust_refs}
    : FOR    ${cdr_index}    IN    @{cdr_description}
    \    Log    CDR: ${cdr_index}
    \    ${cdr_value}    Get From Dictionary    ${cdr_dict}    ${cdr_index}
    \    ${pnr_format}    Get From Dictionary    ${orig_cust_refs}    ${cdr_index}
    \    ${pnr_remark}    Run Keyword If    "${cdr_value}" != "${EMPTY}" and "${pnr_format}" !="${EMPTY}"    catenate    SEPARATOR=    RM *FF${pnr_format}
    \    ...    ${cdr_value}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Comment    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${update_cdr}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${update_cdr}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    1
    \    Comment    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${pnr_details}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${pnr_details}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    1

Verify CDR Accounting Remarks For Non-Air Are Not Written
    [Arguments]    ${country}    ${workflow}
    ${orig_cust_refs}    Create Dictionary
    Run Keyword If    "${country}"=="HK"    Set To Dictionary    ${orig_cust_refs}    DP Code    10/    DP Code 2
    ...    63/    DP Code    4/    COUNTRY E.G. HK    3/    DIVISON E.G. GLOBAL FINANCE
    ...    2/    GRADE - OPTIONAL    18/    LOCAL ENTITY    19/    PERSONNEL ID OR STAFF ID
    ...    16/    PERSONNEL ID OR STAFF ID 2    9/    TRAVEL REASON E.G. INTERNA MEETING    13/    TRAVEL REQUEST NO
    ...    11/    TRAVEL REQUEST NO    14/    TRAVEL REQUEST REASON    64/    DEPARTMENT
    ...    15/
    Run Keyword If    "${country}"=="SG"    Set To Dictionary    ${orig_cust_refs}    Travler Type Alpha Policy Code    15/    GEID
    ...    11/    MSL 8    13/    MSL 9    13/    Revenue/Non Revenue Generating
    ...    17/    DEALCODE    19/    No Hotel Reason Code    18/    OFFLINE
    ...    16/    Employee ID    10/    Cost Centre    12/
    Run Keyword If    "${country}"=="IN"    Set To Dictionary    ${orig_cust_refs}    Business    15/    Business Unit
    ...    14/    Business Unit 2    63/    Company    13/    Company ID
    ...    78/    DP Code    18/    Cost Centre    17/    Department
    ...    16/    Designation    20/    Employee ID    25/    Employee ID 2
    ...    12/    INTL Approver ID    77/    Invoice narration 1    67/    Invoice narration 2
    ...    68/    Invoice narration 3    69/    Job Band    73/    Location Code
    ...    19/    Manager ID    74/    Manager Name    75/    Name of INTL Approver
    ...    76/
    Log    ${orig_cust_refs}
    ${update_cdr}    Get CDR Remarks From GDS Screen
    ${cdr_description}    Get Dictionary Keys    ${orig_cust_refs}
    : FOR    ${cdr_index}    IN    @{cdr_description}
    \    Log    CDR: ${cdr_index}
    \    ${cdr_value}    Get From Dictionary    ${cdr_dict}    ${cdr_index}
    \    ${pnr_format}    Get From Dictionary    ${orig_cust_refs}    ${cdr_index}
    \    ${pnr_remark}    Run Keyword If    "${cdr_value}" != "${EMPTY}" and "${pnr_format}" !="${EMPTY}"    catenate    SEPARATOR=    RM *VFF${pnr_format}
    \    ...    ${cdr_value}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Comment    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${update_cdr}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${update_cdr}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    0
    \    Comment    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${pnr_details}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${pnr_details}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    0

Verify CDR Accounting Remarks For Non-Air Are Written
    [Arguments]    ${country}    ${workflow}
    ${orig_cust_refs}    Create Dictionary
    Run Keyword If    "${country}"=="HK"    Set To Dictionary    ${orig_cust_refs}    DP Code    10/    DP Code 2
    ...    63/    DP Code    4/    COUNTRY E.G. HK    3/    DIVISON E.G. GLOBAL FINANCE
    ...    2/    GRADE - OPTIONAL    18/    LOCAL ENTITY    19/    PERSONNEL ID OR STAFF ID
    ...    16/    PERSONNEL ID OR STAFF ID 2    9/    TRAVEL REASON E.G. INTERNA MEETING    13/    TRAVEL REQUEST NO
    ...    11/    TRAVEL REQUEST REASON    64/    DEPARTMENT    15/
    Run Keyword If    "${country}"=="SG"    Set To Dictionary    ${orig_cust_refs}    Travler Type Alpha Policy Code    15/    GEID
    ...    11/    MSL 8    13/    MSL 9    13/    Revenue/Non Revenue Generating
    ...    17/    DEALCODE    19/    No Hotel Reason Code    18/    OFFLINE
    ...    16/    Employee ID    10/    Cost Centre    12/
    Run Keyword If    "${country}"=="IN"    Set To Dictionary    ${orig_cust_refs}    Business    15/    Business Unit
    ...    14/    Business Unit 2    63/    Company    13/    Company ID
    ...    78/    DP Code    18/    Cost Centre    17/    Department
    ...    16/    Designation    20/    Employee ID    25/    Employee ID 2
    ...    12/    INTL Approver ID    77/    Invoice narration 1    67/    Invoice narration 2
    ...    68/    Invoice narration 3    69/    Job Band    73/    Location Code
    ...    19/    Manager ID    74/    Manager Name    75/    Name of INTL Approver
    ...    76/
    Log    ${orig_cust_refs}
    ${update_cdr}    Get CDR Remarks From GDS Screen
    ${cdr_description}    Get Dictionary Keys    ${orig_cust_refs}
    : FOR    ${cdr_index}    IN    @{cdr_description}
    \    Log    CDR: ${cdr_index}
    \    ${cdr_value}    Get From Dictionary    ${cdr_dict}    ${cdr_index}
    \    ${pnr_format}    Get From Dictionary    ${orig_cust_refs}    ${cdr_index}
    \    ${pnr_remark}    Run Keyword If    "${cdr_value}" != "${EMPTY}" and "${pnr_format}" !="${EMPTY}"    catenate    SEPARATOR=    RM *VFF${pnr_format}
    \    ...    ${cdr_value}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Comment    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${update_cdr}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${update_cdr}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Update PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    1
    \    Comment    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Contain    ${pnr_details}    ${pnr_remark}
    \    ${count}    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Count Values In List    ${pnr_details}    ${pnr_remark}
    \    Run Keyword If    "${workflow}" == "Finish PNR" and "${pnr_remark}" != "${EMPTY}"    Should Be Equal As Integers    ${count}    1

Verify CDR Field Is Not Visible
    [Arguments]    ${cdr_field_description}
    ${cdr_dict}    Determine CDR Description And Index
    Dictionary Should Not Contain Key    ${cdr_dict}    ${cdr_field_description}

Verify CDR Fields Is Not Visible Upon Load In Amend Booking Flow
    Verify Control Object Is Not Visible    ${cdr_value1_locator}
    Verify Control Object Is Not Visible    ${cdr_value2_locator}
    Verify Control Object Is Not Visible    ${cdr_value3_locator}
    [Teardown]    Take Screenshot

Verify CDR Value Is Correct
    [Arguments]    ${expected_cdr}    ${expected_value}
    ${cdr_dict}    Determine CDR Description And Index
    ${cdr_index} =    Get From Dictionary    ${cdr_dict}    ${expected_cdr}
    Verify Control Object Text Value Is Correct    [NAME:ctxtCDRValue${cdr_index}]    ${expected_value}
    [Teardown]    Take Screenshot

Verify Client Account Name Is Correct
    [Arguments]    ${expected_value}
    Tick Show All Client Defined References
    ${client_account_name}    Get Client Account Name
    Should Be Equal As Strings    ${expected_value}    ${client_account_name}

Verify Create Shell Button Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:btnShell]

Verify Cust Refs Not Known Checkbox Is Unticked
    Verify Checkbox Is Unticked    ${check_box_skip_validation}
    [Teardown]    Take Screenshot

Verify Cust Refs Not Known Checkbox Is Unticked And Disabled
    Verify Checkbox Is Unticked    ${check_box_skip_validation}
    Verify Control Object Is Disabled    ${check_box_skip_validation}
    [Teardown]    Take Screenshot

Verify Red Error Icon Existing In Selected Panel
    [Arguments]    ${panel_name}=EMPTY
    Click Panel    ${panel_name}
    Sleep    1
    ${is_error_icon_exist}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}/red_error_icon.PNG    ${similarity}    ${timeout}
    Run Keyword If    "${is_error_icon_exist}" == "True"    Log    PASSED: Red error icon was displayed in ${panel_name} panel.
    ...    ELSE    Log    FAILED: No Red error icon in ${panel_name} panel.
    [Teardown]    Take Screenshot

Verify Show All Client Defined References Checkbox Is Unticked
    Wait Until Control Object Is Visible    ${label_client_defined_references}
    ${checkbox_status}    Get checkbox status    ${check_box_show_all_cdr}
    Should be True    '${checkbox_status}' == 'False'
    [Teardown]    Take Screenshot

Verify Specific CDR Is Not Shown Upon Load
    [Arguments]    ${expected_cdr_field_name}
    : FOR    ${field_index}    IN RANGE    1    15
    \    ${clickstatus} =    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ctxtCDRDescription${field_index}]
    \    Sleep    1
    \    ${currlabel} =    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblCDRDescription${field_index}]
    \    Run Keyword If    '${currlabel}' == '${EMPTY}'    Continue For Loop
    \    Run Keyword If    "${currlabel}" == "${expected_cdr_field_name}"    Fail    CDR Field ${expected_cdr_field_name} is Shown Upon Load
    \    Run Keyword If    "${currlabel}" != "${expected_cdr_field_name}"    Exit For Loop
    [Teardown]    Take Screenshot

Verify Specific Panel Status
    [Arguments]    ${panel_name}=EMPTY
    Auto It Set Option    PixelCoordMode    2
    Set Test Variable    ${x}    13
    Comment    ${y}    Get From Dictionary    ${panel_coordinates}    ${panel_name.upper()}
    ${actual_bgcolor}    Pixel Get Color    ${x}    ${y}
    ${actual_bgcolor}    Convert To Hex    ${actual_bgcolor}
    ${panel_status}    Run Keyword If    "${actual_bgcolor}" == "FF5151" or "${actual_bgcolor}" == "FF5A5A" or "${actual_bgcolor}" == "FF4A4A"    Set Variable    RED
    ...    ELSE IF    "${actual_bgcolor}" == "7CD107" or "${actual_bgcolor}" == "78CE00"    Set Variable    GREEN
    ...    ELSE    Set Variable    END
    Auto It Set Option    PixelCoordMode    1
    [Return]    ${panel_status}

Book Active Amadeus Car Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10    ${line_ref}=1
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Enter GDS Command    CA ${city} ${departure_date}-${arrival_date}/ARR-0900-1800
    Enter GDS Command    CS${line_ref}
