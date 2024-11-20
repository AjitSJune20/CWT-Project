*** Settings ***
Documentation     This resource file covers all reusable actions for Recap Panel related test cases
Variables         ../variables/recap_control_objects.py
Resource          ../common/core.robot
Resource          ../../acceptance_tests/delivery/delivery_verification.robot

*** Keywords ***
Click Add Queue Minder
    Click Control Button    [NAME:cmdAddQueueMinder]

Click Delete From Overrides Or Skip Entries
    Click Control Button    [NAME:cmdDeleteSE]

Click Finish PNR
    [Arguments]    ${keyword}=${EMPTY}    ${delay_in_secs}=0    ${panel}=Recap
    Run Keyword If    '${gds_switch}' == 'sabre'    Enter GDS Command    W-ABC TRAVEL¥W-1/123 MAIN ST¥W-2/DALLAS TX 75201    5/
    Click Panel    ${panel}
    Click Send To PNR
    Verify Error In Status Strip Text    Update Aborted - Please validate all activity panels
    ${date_for_eo}    DateTime.Get Current Date    local    result_format=%d/%m/%Y %H:%M
    Set Suite Variable    ${date_for_eo}
    Run Keyword If    '${gds_switch}' == 'amadeus'    Handle Parallel Process    ${keyword}
    Wait Until Window Exists    [REGEXPTITLE:Progress Information|Information sur l'avancement]
    Wait Until Progress Info is Completed
    Run Keyword If    ${simultaneous_changes_within_progress_info} == ${False}    Wait Until Progress Info is Completed
    : FOR    ${INDEX}    IN RANGE    1
    \    Exit For Loop If    ${simultaneous_changes} == ${True} or ${simultaneous_changes_within_progress_info} == ${True}
    \    Get PNR Record Locator
    \    Verify PNR Message
    \    ${pnr_created_folder} =    Set Variable    C:\\Users\\Public\\Documents\\
    \    ${date_today} =    SyexDateTimeLibrary.Get Current Date
    \    ${date_today_for_eo}    DateTime.Get Current Date    result_format=%d/%m/%Y
    \    ${current_date}    Convert Date To Gds Format    ${date_today}    %m/%d/%Y
    \    Generate Time For TAW Line
    \    Run Keyword And Continue On Failure    Append To File    ${pnr_created_folder}pnr_created.txt    ${\n}${current_pnr} - ${GDS_switch} - ${date_today}
    \    Run Keyword If    '${gds_switch}' == 'amadeus'    Run Keywords    Activate Amadeus Selling Platform    False
    \    ...    AND    Activate Power Express Window
    \    Set Suite Variable    ${current_date}
    \    Set Suite Variable    ${date_today}
    \    Set Suite Variable    ${date_today_for_eo}
    \    Set Suite Variable    ${pt_pnr}    ${current_pnr}
    Log    ${current_pnr}
    Sleep    ${delay_in_secs}
    ${remark_update_failed}    Run Keyword If    "${panel}" == "Other Svcs"    Get Other Service PNR Message
    Run Keyword If    ${remark_update_failed}    Run Keywords    Get Exchange Order Number
    ...    AND    ${keyword}

Click Finish PNR Expecting Popup Message
    [Arguments]    ${expected_popup_message}
    Click Panel    Recap
    Click Send To PNR
    Sleep    10
    Wait Until Window Exists    Power Express
    ${actual_popup_message}    Get Control Text Value    [NAME:txtMessageTextBox]    Power Express
    Verify Actual Value Matches Expected Value    ${actual_popup_message}    ${expected_popup_message}
    Wait Until Keyword Succeeds    60    1    Verify Progress Info Window is Not Active
    Verify PNR Message
    Get PNR Record Locator
    ${pnr_created_folder} =    Set Variable If    '${test_environment}' == 'local'    C:\\Users\\Public\\Documents\\    '${test_environment}' == 'citrix'    D:\\TFS\\
    ${date_today} =    Get Current Date
    Run Keyword And Continue On Failure    Append To File    ${pnr_created_folder}pnr_created.txt    ${\n}${current_pnr} - ${GDS_switch} - ${date_today}

Click Finish PNR With Timestamp
    [Arguments]    ${error_message}=${EMPTY}
    Click Panel    Recap
    Click Send To PNR
    Wait Until Progress Info is Completed    ${EMPTY}    ${error_message}
    ${exp_overalltransaction_end_time}    Get Time
    Set Test Variable    ${exp_overalltransaction_end_time}
    Get PNR Record Locator
    Verify PNR Message
    Run Keyword If    '${simultaneous_changes}' != 'True' and '${retry_popup_status}' != 'True' and '${error_message}' != '${EMPTY}'    Run Keyword And Continue On Failure    FAIL    Retry error popup is not displayed.
    ${pnr_created_folder} =    Set Variable If    '${test_environment}' == 'local'    C:\\Users\\Public\\Documents\\    '${test_environment}' == 'citrix'    D:\\TFS\\
    Run Keyword And Continue On Failure    Append To File    ${pnr_created_folder}pnr_created.txt    ${\n}${current_pnr} - ${GDS_switch}

Create Queue Minder
    [Arguments]    ${queue_pcc}    ${queue_number}    ${queue_category}    ${queue_message}    ${MM/DD/YYYY}    ${row_number}
    Click Add Queue Minder
    Comment    Tick Queue Minder Date Checkbox
    Set Date For Queue Minder    ${MM/DD/YYYY}    ${row_number}
    Set Queue Minder PCC    ${queue_pcc}    ${row_number}
    Set Queue Minder Number    ${queue_number}    ${row_number}
    Set Queue Minder Category    ${queue_category}    ${row_number}
    Set Queue Minder Message    ${queue_message}    ${row_number}

Handle Parallel Process
    [Arguments]    ${keyword}=${EMPTY}
    Sleep    5
    ${active_window} =    Win Get Title    [ACTIVE]    ${EMPTY}
    Set Test Variable    ${popup_window}    ${active_window}
    Win Activate    ${active_window}    ${EMPTY}
    ${is_parallel_process_message_present} =    Control Command    ${active_window}    ${EMPTY}    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_parallel_process_message_present} == 1    Take Screenshot
    ${actual_warning_message} =    Run Keyword If    ${is_parallel_process_message_present} == 1    Get Control Text Value    [NAME:txtMessageTextBox]    ${title_power_express}
    ${is_parallel_process}    Run Keyword If    ${is_parallel_process_message_present} == 1    Run Keyword And Return Status    Should Contain Any    ${actual_warning_message}    parallèle
    ...    parallel    modififications    modifications
    Run Keyword If    ${is_parallel_process} == True    Confirm Popup Window
    Run Keyword If    ${is_parallel_process} == True    Run Keyword    ${keyword}

Populate Recap Panel With Default Values
    ${is_offline_request_number_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_OfflineRequestNumber}    IsVisible    ${EMPTY}
    Run Keyword If    ${is_offline_request_number_present} == 1    Tick Disable Offline Request Number
    ...    ELSE    Select Booking Method Using Default Value

Select Booking Method
    [Arguments]    ${booking_method_value}
    Set Control Text Value    ${combo_bookingmethod}    ${booking_method_value}    ${title_power_express}

Select Booking Method Using Default Value
    Click Control Button    ${combo_bookingmethod}    ${title_power_express}
    Control Focus    ${title_power_express}    ${EMPTY}    ${combo_bookingmethod}
    Send    {DOWN}
    Send    {TAB}

Select Value From Override Or Skip Entries
    [Arguments]    ${overrides_or_skip_entries}
    ${current_value}    Get Control Text Value    [NAME:ccboSkipEntries]
    Run Keyword If    "${current_value}" != "${EMPTY}"    Click Control Button    [NAME:cmdAddSE]
    : FOR    ${INDEX}    IN RANGE    3    11
    \    Run Keyword If    "${current_value}" == "${EMPTY}"    Select Value From Dropdown List    [NAME:ccboSkipEntries]    ${overrides_or_skip_entries}
    \    Exit For Loop If    "${current_value}" == "${EMPTY}"
    \    ${next_skip_entry_value}    Get Control Text Value    [NAME:ccboSkipEntries${INDEX}]
    \    Run Keyword If    "${next_skip_entry_value}" == "${EMPTY}"    Select Value From Dropdown List    [NAME:ccboSkipEntries${INDEX}]    ${overrides_or_skip_entries}
    \    Exit For Loop If    "${next_skip_entry_value}" == "${EMPTY}"

Send Itinerary
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Finish PNR

Set Clipper Compliancy Value
    [Arguments]    ${str_clipper_compliancy}
    Sleep    5
    Control Click    ${title_power_express}    ${EMPTY}    ${clipper_compliancy_options}
    Sleep    1
    Send    ${str_clipper_compliancy}    0
    Sleep    1
    Send    {ENTER}
    Sleep    1
    ${ui_clipper_compliancy} =    Control Get Text    ${title_power_express}    ${EMPTY}    ${clipper_compliancy_options}
    ${match_found} =    Run Keyword and Return Status    Should Match    ${ui_clipper_compliancy}    ${str_clipper_compliancy}
    Run Keyword If    "${match_found}" == "False"    Run Keyword And Continue On Failure    Fail    Failed to enter new clipper compliancy value
    Sleep    5
    Control Click    ${title_power_express}    ${EMPTY}    ${edit_pcc}
    Send    {TAB}

Set PCC Field Value
    [Arguments]    ${str_pcc}
    Sleep    5
    Control Set Text    ${title_power_express}    ${EMPTY}    ${edit_pcc}    ${str_pcc}
    Sleep    1

Set Queue Minder Category
    [Arguments]    ${queue_category}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:ctxtCategory${row_number}]    ${queue_category}

Set Queue Minder Message
    [Arguments]    ${queue_message}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:ctxtMessage${row_number}]    ${queue_message}

Set Queue Minder Number
    [Arguments]    ${queue_number}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:ctxtQueue${row_number}]    ${queue_number}

Set Queue Minder PCC
    [Arguments]    ${queue_pcc}    ${row_number}
    ${row_number}=    Convert To Integer    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:ctxtPCC${row_number}]    ${queue_pcc}

Set Skip Entries
    [Arguments]    ${skip_entries_value}
    Set Control Text Value    [NAME:ccboSkipEntries]    ${skip_entries_value}

Set Team ID Field Value
    [Arguments]    ${str_teamid}
    Sleep    5
    Control Set Text    ${title_power_express}    ${EMPTY}    ${edit_teamid}    ${str_teamid}
    Sleep    1

Tick Auto Invoice
    Activate Power Express Window
    Tick Checkbox    Auto Invoice

Tick Disable Offline Request Number
    Click Control Button    ${check_box_OfflineRequestNumber}    ${title_power_express}

Tick Queue Minder Date Checkbox
    Tick Checkbox    [NAME:cdtpDate0]    By Space
    ${queue_date}    Get Control Text Value    [NAME:cdtpDate0]
    Set Suite Variable    ${queue_date}
    ${queue_date}

Untick Auto Invoice
    Activate Power Express Window
    Untick Checkbox    Auto Invoice

Click Send To PNR
    Wait Until Control Object Is Enabled    [NAME:btnSendPNR]
    Click Control Button    [NAME:btnSendPNR]

Set General Remark Qualifier Text
    [Arguments]    ${qualifier_value}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:ctxtRemarkText${row_number}]    ${qualifier_value}

Select Qualifier General Remark
    [Arguments]    ${qualifier_value}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Select Value From Dropdown List    [NAME:ccboRemarkQualifier${row_number}]    ${qualifier_value}

Set Date For Queue Minder
    [Arguments]    ${MM/DD/YYYY}    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Set Control Text Value    [NAME:cdtpDate${row_number}]    ${MM/DD/YYYY}

Get Other Service PNR Message
    ${pnr_message2} =    Get Control Text Value    [NAME:lblEndMessage]    ${title_power_express}
    ${simultaneous_in_other_service}    Run Keyword And Return Status    Should Contain Any    ${pnr_message2}    There was a problem ending the PNR! Message from GDS: PNRFAILED: ERROR RESPONSE IN AMADEUSENDBF: SIMULTANEOUS CHANGES TO PNR - USE WRA/RT TO PRINT OR IGNORE
    [Return]    ${simultaneous_in_other_service}
