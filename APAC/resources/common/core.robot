*** Settings ***
Resource          global_resources.robot
Resource          ../../acceptance_tests/gds/gds_verification.robot
Resource          ../../acceptance_tests/air_fare/air_fare_verification.robot

*** Variables ***
&{gds_dict}    sabre=1S    apollo=1V    galileo=1G    amadeus=1A

*** Keywords ***
Click Amend Booking
    Wait Until Control Object Is Enabled    [NAME:btnAmendPNR]    ${title_power_express}    true
    Click Control Button    [NAME:btnAmendPNR]    ${title_power_express}
    Wait Until Progress Info is Completed
    Wait Until Progress Info is Completed

Click Cancel Booking
    Wait Until Control Object Is Enabled    [NAME:btnCancelPNR]    ${title_power_express}
    Click Control Button    [NAME:btnCancelPNR]    ${title_power_express}
    Wait Until Progress Info is Completed

Click Clear All
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Enabled    ${btn_clearAll}    ${title_power_express}    true
    Click Control Button    ${btn_clearAll}
    Wait Until Progress Info is Completed
    Wait Until Keyword Succeeds    120    2    Verify Progress Info Window is Not Active
    Wait Until Control Object Is Visible    [NAME:grpPortraitProfileInformation]    ${title_power_express}    true

Click Create Shell
    Click Control Button    [NAME:btnShell]
    Wait Until Progress Info is Completed
    Get PNR Record Locator
    ${date_today} =    SyexDateTimeLibrary.Get Current Date
    Run Keyword And Continue On Failure    Append To File    ${public_documents_path}/pnr_created.txt    ${\n}${current_pnr} - ${GDS_switch} - ${date_today}

Click New Booking
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Enabled    ${btn_newBooking}    ${title_power_express}
    Click Control Button    ${btn_newBooking}    ${title_power_express}
    Wait Until Progress Info is Completed
    Verify Error In Status Strip Text    Error while reading values from PNR
    Wait Until Panel Is Visible    Client Info
    Set Test Variable    ${is_new_booking_worflow}    ${True}

Click Panel
    [Arguments]    ${panel_name}
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Run Keyword If    "${locale}" == "fr-FR"    Translate Panel's Name To French    ${panel_name}
    ${is_selected}    Run Keyword And Return Status    Verify Panel Is Selected    ${panel_name}
    Run Keyword If    not ${is_selected}    Run Keywords    Select Panel    ${panel_name}
    ...    AND    Wait Until Panel Is Selected    ${panel_name}
    Run Keyword If    "${locale}" == "fr-FR"    Translate Panel's Name To English    ${panel_name}

Click Price Tracking
    Wait Until Control Object Is Enabled    [NAME:btnPriceTracking]    ${title_power_express}    true
    Click Control Button    [NAME:btnPriceTracking]    ${title_power_express}
    Wait Until Progress Info is Completed

Click Quick Amend
    Click Control Button    [NAME:btnQuickAmend]    ${title_power_express}
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Visible    [NAME:btnLoadPNR]    ${title_power_express}

Click Read Booking
    [Arguments]    ${ignore_progress_info_popup}=False
    Wait Until Progress Info Is Completed
    Wait Until Control Object Is Enabled    ${btn_readBooking}
    Control Focus    ${title_power_express}    ${EMPTY}    ${btn_readBooking}
    Control Click    ${title_power_express}    ${EMPTY}    ${btn_readBooking}
    Sleep    5
    Run Keyword If    "${ignore_progress_info_popup" == "False"    Run Keywords    Wait Until Progress Info is Completed
    ...    AND    Wait Until Progress Info Is Completed
    ...    ELSE    Log    Progress Information Window Is Ignored.
    Wait Until Panel Is Visible    Delivery

Click Send Itinerary
    Wait Until Control Object Is Enabled    [NAME:btnSendItinerary]    ${title_power_express}
    Click Control Button    [NAME:btnSendItinerary]    ${title_power_express}
    Wait Until Progress Info is Completed

Click Update PNR
    Wait Until Control Object Is Enabled    ${btn_sendtoPNR}    ${title_power_express}    true
    Click Control Button    ${btn_sendtoPNR}    ${title_power_express}
    Verify Error In Status Strip Text    Update Aborted - Please validate all activity panels
    Wait Until Window Exists    [REGEXPTITLE:Progress Information|Information sur l'avancement]
    Wait Until Progress Info is Completed

Click Tab In Top Left
    [Arguments]    ${tab_name}
    Wait Until Control Object Is Visible    [NAME:TopLeftTabControl]    ${title_power_express}    true
    Select Tab From Top Left    ${tab_name}

Close Power Express
    Process Close    PowerExpress.exe

Create New Booking With One Way Flight Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair}    ${client_account}=${EMPTY}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Run Keyword If    "${client_account}" != "${EMPTY}"    Select Client Account Value    ${client_account}
    ${is_client_acct_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    [NAME:ccboAccountNumber]
    Run Keyword If    ${is_client_acct_mandatory} and "${client_account}" == "${EMPTY}"    Select Client Account Using Default Value
    Click New Booking
    Update PNR With Default Values
    Book One Way Flight X Months From Now    ${city_pair}    6
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create Shell PNR Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${client_account}=${EMPTY}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Comment    Handle Incomplete Contact Details
    Select Value From Dropdown List    [NAME:ccboAccountNumber]    ${client_account}
    Click New Booking
    Populate All Panels (Except Given Panels If Any)
    Click Create Shell

Create Shell PNR Via Keyboard Shortcut
    Sleep    1
    Send    {ALTDOWN}E{ALTUP}
    Wait Until Progress Info is Completed

Create Shell PNR Without Retention Line
    [Arguments]    ${client}    ${surname}    ${firstname}    ${client_account}=${EMPTY}    ${trip_type}=${EMPTY}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Run Keyword If    "${trip_type.lower()}" == "classic"    Select Type Of Booking    ${trip_type}
    Click New Booking
    Populate All Panels (Except Given Panels If Any)
    Click Create Shell
    Delete Air Segment    2
    Comment    End And Retrieve PNR    False
    Enter GDS Command    ER    ER    RT

Determine Current Panels
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Visible    [REGEXPCLASS:WindowsForms10.MDICLIENT.app.*]
    @{panel_list}    Get All Panels
    ${panel_coordinates}    Create Dictionary
    ${panel_names_collection}    Create List
    Set Test Variable    ${panel_translated}    ${False}
    ${counter} =    Set Variable    0
    : FOR    ${panel_name}    IN    @{panel_list}
    \    ${y} =    Evaluate    ${counter}*22 + 388
    \    Run Keyword If    "${locale}" != "en-US"    Translate Panel's Name To English    ${panel_name}
    \    Set To Dictionary    ${panel_coordinates}    ${panel_name.upper()}    ${y}
    \    Append To List    ${panel_names_collection}    ${panel_name}
    \    ${counter} =    Evaluate    ${counter} + 1
    Set Test Variable    ${panel_coordinates}
    Set Test Variable    ${panel_names_list}    ${panel_names_collection}
    Set Test Variable    ${last_panel}    ${panel_names_list[-1]}

Execute Simultaneous Change Handling
    [Arguments]    ${keyword_name}
    : FOR    ${INDEX}    IN RANGE    5
    \    Run Keyword If    ${simultaneous_changes} == ${True} or ${simultaneous_changes_within_progress_info} == ${True}    Run Keyword    ${keyword_name}
    \    Exit For Loop If    ${simultaneous_changes} == ${False} and ${simultaneous_changes_within_progress_info} == ${False}

Get Panel Status
    [Arguments]    ${x}    ${y}
    Auto It Set Option    PixelCoordMode    2
    ${actual_bgcolor}    Pixel Get Color    ${x}    ${y}
    ${actual_bgcolor}    Convert To Hex    ${actual_bgcolor}
    ${is_panel_red}    Run Keyword And Return Status    Should Contain Any    ${actual_bgcolor}    FF5151    FF5A5A    FF4A4A
    ...    FF494A
    ${is_panel_green}    Run Keyword And Return Status    Should Contain Any    ${actual_bgcolor}    7CD107    78CE00    7BCF00
    ${panel_status}    Set Variable If    ${is_panel_red}    RED    ${is_panel_green}    GREEN    "${actual_bgcolor}" == "FFFFFF"
    ...    END
    Auto It Set Option    PixelCoordMode    1
    [Return]    ${panel_status}

Get Table Column
    [Arguments]    ${dm_table_name}    ${col_name}
    ${col} =    Get From Dictionary    ${${dm_table_name}}    ${col_name}
    [Return]    ${col}

Open Power Express And Retrieve Profile
    [Arguments]    ${version}    ${syex_env}    ${username}    ${locale}    ${user_profile}    ${team}=${EMPTY}
    ...    ${gds}=${EMPTY}
    Comment    Close Power Express
    Set Suite Variable    ${current_pnr}    ${EMPTY}
    Run Keyword If    "${use_local_dev_build}" == "True"    Use Local Dev Build    ${username}
    ...    ELSE    Launch Power Express    ${version}    ${syex_env}    ${username}    ${use_mock_env}
    Set Suite Variable    ${locale}
    ${syex_env}    Convert To Lowercase    ${syex_env}
    Run Keyword Unless    '${syex_env}' == 'master' or '${syex_env}' == 'emea' or '${syex_env}' == 'noram'    Set User Settings    ${locale}
    Run Keyword Unless    '${syex_env}' == 'master' or '${syex_env}' == 'emea' or '${syex_env}' == 'noram'    Select Profile    ${user_profile}
    Set Suite Variable    ${user_profile}
    Run Keyword If    "${team}" != "${EMPTY}"    Run Keywords    Clear Team Selection
    ...    AND    Select Team    ${team}
    Set Suite Variable    ${pcc}    ${EMPTY}
    Set Suite Variable    ${uid}    ${username}
    Run Keyword If    "${gds}" != "${EMPTY}"    Select GDS    ${gds}

Populate All Panels (Except Given Panels If Any)
    [Arguments]    @{exclude_panels}
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Activate Power Express Window
    Determine Current Panels
    Populate Panels with Red Mark Except The Given Panel(s)    @{exclude_panels}
    Comment    Verify All Panels Are Green    @{exclude_panels}

Populate Panels with Red Mark Except The Given Panel(s)
    [Arguments]    @{exclude_panels}
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    : FOR    ${panel}    IN    @{exclude_panels}
    \    Append To List    ${exclude_panels}    ${panel.upper()}
    ${counter}    Set Variable    0
    Set Test Variable    ${is_delivery_panel_already_populated}    False
    ${is_delivery_panel_found}    Run Keyword And Return Status    List Should Contain Value    ${panel_names_list}    Delivery
    : FOR    ${panel_name}    IN    @{panel_names_list}
    \    ${exclude_panel_match}    Run keyword and Return Status    List Should Contain Value    ${exclude_panels}    ${panel_name.upper()}
    \    ${y}    Run Keyword If    ${exclude_panel_match} == False    Get From Dictionary    ${panel_coordinates}    ${panel_name.upper()}
    \    ${panel_status}    Run Keyword If    ${exclude_panel_match} == False    Get Panel Status    13    ${y}
    \    Run Keyword If    "${panel_status}" == "RED"    Run Keywords    Click Panel    ${panel_name}
    \    ...    AND    Populate ${panel_name} Panel With Default Values    AND    Take Screenshot
    ${is_delivery_panel_not_excluded} =    Run Keyword And Return Status    List Should Not Contain Value    ${exclude_panels}    DELIVERY
    Run Keyword If    ${is_delivery_panel_not_excluded} == True and ${is_delivery_panel_already_populated} != True and ${is_delivery_panel_found} == True    Run Keywords    Click Panel    Delivery
    ...    AND    Populate Delivery Panel With Default Values
    Click Panel    ${last_panel}

Retrieve PNR
    [Arguments]    ${pnr}    ${skip_clear_all}=False
    Should Be True    "${pnr}" != "${EMPTY}"    PNR should exist.
    Run Keyword If    "${skip_clear_all}" == "False"    Run Keywords    Click Clear All
    ...    AND    Wait Until Progress Info is Completed
    Wait Until Control Object Is Visible    [NAME:ctxtBookingLocator]    \    true
    Set Control Edit Value    ctxtBookingLocator    ${pnr}
    Click Control Button    [NAME:btnSearchLocator]
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Visible    [NAME:UGridBookings]    handle_popups=true

Retrieve PNR via Existing Bookings Tab
    [Arguments]    ${client}    ${last_name}    ${first_name}    ${pnr}    ${apply_delay}=1
    Should Be True    "${pnr}" != "${EMPTY}"    PNR should exist.
    Click Clear All
    Sleep    5
    Set Client And Traveler    ${client}    ${last_name}    ${first_name}
    ${existing_booking_tab}    Set Variable If    '${locale}' == 'fr-FR'    servations existantes    '${locale}' == 'de-DE'    Bestehende Buchungen    '${locale}' != 'fr-FR' and '${locale}' != 'de-DE'
    ...    Existing Bookings
    Mouse Click    LEFT    30    65
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:TopLeftTabControl]
    Select Tab Control    ${existing_booking_tab}
    Set Control Text Value    [NAME:ctxtLocator]    ${pnr}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:btnSearchPNR]
    Wait Until Control Object Is Visible    [NAME:UGridBookings]    ${title_power_express}
    Sleep    ${apply_delay}

Retrieve PNR with Timestamp
    [Arguments]    ${client}    ${surname}    ${firstname}    ${pnr}
    Retrieve PNR    ${pnr}
    ${exp_overalltransaction_start_time}    Get Time
    Set Test Variable    ${exp_overalltransaction_start_time}

Select GDS
    [Arguments]    ${gds}
    Activate Power Express Window
    Handle Generic Window Popup
    Wait Until Mouse Cursor Wait Is Completed
    Click GDS Screen Tab
    ${gds} =    Convert To Lowercase    ${gds}
    ${db_gds}    Get From Dictionary    ${gds_dict}    ${gds}
    Set Suite Variable    ${db_gds}
    Set Suite Variable    ${GDS_switch}    ${gds}
    Select GDS Value    ${gds}
    Wait Until Mouse Cursor Wait Is Completed
    Click GDS Screen Tab
    Run Keyword If    '${gds}' == 'amadeus'    Enter GDS Command    IG

Select Team
    [Arguments]    @{team_selection}
    Wait Until Team Selection Window is Active
    : FOR    ${team}    IN    @{team_selection}
    \    Wait Until Window Exists    ${team_selection_window}
    \    Win Activate    ${team_selection_window}    ${EMPTY}
    \    Select Team Name    ${team}
    Control Focus    ${team_selection_window}    ${EMPTY}    ${btn_OKSettings}
    Control Click    ${team_selection_window}    ${EMPTY}    ${btn_OKSettings}
    Wait Until Progress Info is Completed
    Handle Generic Window Popup
    Set Suite Variable    ${selected_team}    ${team}

Set User Settings
    [Arguments]    ${locale}
    Win Wait    ${title_settings}    ${EMPTY}    120
    Win Activate    ${title_settings}    ${EMPTY}
    Control Click    ${user_selection_window}    ${EMPTY}    ${EMPTY}
    Set Control Text Value    ${cbo_locale}    ${locale}    ${title_settings}
    Control Click    ${title_settings}    ${EMPTY}    [NAME:chkDisableContactTracking]
    Control Click    ${title_settings}    ${EMPTY}    ${btn_OKSettings}
    Set Suite Variable    ${locale}
    Verify User Configuration

Update PNR With Default Values
    [Arguments]    @{exclude_panels}
    Wait Until Panel Is Visible    Client Info
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}
    ${is_update_pnr_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${btn_sendtoPNR}    IsVisible    ${EMPTY}
    Run Keyword If    ${is_update_pnr_present} == 1    Click Update PNR

Verify Actual Panel Contains Expected Panel
    [Arguments]    ${expected_panel_value}
    Determine Current Panels
    List Should Contain Value    ${panel_coordinates}    ${expected_panel_value.upper()}    msg=${expected_panel_value} should be visible

Verify Actual Panel Does Not Contain Expected Panel
    [Arguments]    ${expected_panel_value}
    Determine Current Panels
    List Should Not Contain Value    ${panel_coordinates}    ${expected_panel_value.upper()}    msg=${expected_panel_value} should not be visible

Verify Actual Panel Equals To Expected Panel
    [Arguments]    @{expected_panel_value}
    ${converted_panel_value}    Create List
    : FOR    ${each}    IN    @{expected_panel_value}
    \    Append To List    ${converted_panel_value}    ${each.upper()}
    Determine Current Panels
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${panel_coordinates}    ${converted_panel_value}

Verify All Panels Are Green
    [Arguments]    @{exclude_panels}
    Determine Current Panels
    : FOR    ${panel}    IN    @{panel_names_list}
    \    ${y}    Get From Dictionary    ${panel_coordinates}    ${panel.upper()}
    \    ${panel_status}    Get Panel Status    13    ${y}
    \    Should Be True    "${panel_status}" == "GREEN"    ${panel} should be green

Verify Control Object Text Contains Expected Value
    [Arguments]    ${control_object}    ${expected_value}
    ${actual_value}    Get Control Text Value    ${control_object}
    Verify Text Contains Expected Value    ${actual_value}    ${expected_value}

Verify Panel Is Green
    [Arguments]    @{panel}
    Determine Current Panels
    : FOR    ${each_panel}    IN    @{panel}
    \    Dictionary Should Contain Key    ${panel_coordinates}    ${each_panel.upper()}    ${each_panel.upper()} panel should be visible
    \    ${y}    Get From Dictionary    ${panel_coordinates}    ${each_panel.upper()}
    \    ${panel_status} =    Get Panel Status    13    ${y}
    \    Should Be True    "${panel_status}" == "GREEN"    ${each_panel.upper()} panel should be Green

Verify Panel Is Red
    [Arguments]    @{panel}
    Determine Current Panels
    : FOR    ${each_panel}    IN    @{panel}
    \    Dictionary Should Contain Key    ${panel_coordinates}    ${each_panel.upper()}    ${each_panel.upper()} panel should be visible
    \    ${y}    Get From Dictionary    ${panel_coordinates}    ${each_panel.upper()}
    \    ${panel_status} =    Get Panel Status    13    ${y}
    \    Should Be True    "${panel_status}" == "RED"    ${each_panel.upper()} panel should be RED

Verify Progress Info Window is Not Active
    [Arguments]    ${error_message}=${EMPTY}
    Activate Power Express Window
    Handle Generic Window Popup    ${error_message}
    ${is_progress_info_message_present} =    Control Command    [REGEXPTITLE:Progress Information|Information sur l'avancement]    ${EMPTY}    ${EMPTY}    IsVisible    ${EMPTY}
    Run Keyword If    ${is_progress_info_message_present} == 1    Win Activate    [REGEXPTITLE:Progress Information|Information sur l'avancement]    ${EMPTY}
    Should Be True    ${is_progress_info_message_present} == 0    msg=Progress Information Window should be completed within 5 minutes
    Run Keyword If    ${simultaneous_changes} == ${True}    Set Suite Variable    ${simultaneous_changes_within_progress_info}    ${True}
    ...    ELSE    Set Suite Variable    ${simultaneous_changes_within_progress_info}    ${False}

Verify User Configuration
    Activate Power Express Window
    ${is_db_warning_message_present} =    Control Command    Power Express    There is no System User configured    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_db_warning_message_present} == 0    Fatal Error    There is no System User configured

Wait Until Progress Info is Completed
    [Arguments]    ${keyword}=${EMPTY}    ${error_message}=${EMPTY}
    Set Test Variable    ${retry_popup_status}    False
    Activate Power Express Window
    Wait Until Mouse Cursor Wait Is Completed
    Wait Until Keyword Succeeds    300    5    Verify Progress Info Window is Not Active    ${error_message}
    Wait Until Mouse Cursor Wait Is Completed
    Activate Power Express Window

Wait Until Team Selection Window is Active
    ${team_selection_window}    Set Variable If    '${locale}' == 'de-DE'    Teamauswahl    '${locale}' == 'fr-FR'    Sélection de l'équipe    Team Selection
    # : FOR    ${INDEX}    IN RANGE    120
    # \    Handle Incomplete Contacts
    # \    ${is_team_selection_window_present}    Win Exists    ${team_selection_window}    ${EMPTY}
    # \    Exit For Loop If    ${is_team_selection_window_present} == 1
    # \    Sleep    6
    Wait Until Window Exists    ${team_selection_window}
    Wait Until Keyword Succeeds    120    3    Verify Control Object Is Visible    [REGEXPCLASS:WindowsForms10.MDICLIENT.app.*]    ${title_power_express}
    Win Wait    ${team_selection_window}    ${EMPTY}    120
    Win Activate    ${team_selection_window}    ${EMPTY}
    Set Test Variable    ${team_selection_window}

Wait Until Progress Bar Is Completed
    Activate Power Express Window
    Wait Until Keyword Succeeds    30    3    Verify Control Object Is Not Visible    [REGEXPCLASS:WindowsForms10.msctls_progress32.app.0.*]

Click New Booking Via Shortcut Key
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Send    !n
    Wait Until Progress Info is Completed
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Set Test Variable    ${is_new_booking_worflow}    ${True}

Click Read Booking Via Shortcut Key
    [Arguments]    ${ignore_progress_info_popup}=False
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    #Line 4 and 5 are created to indicate that Galileo booking is made for testing purpose.
    ${date}    Set Departure Date X Months From Now In Gds Format    10
    Run Keyword If    '${gds_switch}' == 'galileo' and ${is_new_booking_worflow} == ${True}    Enter GDS Command    0TURZZBK1MNL${date}-*********TEST BOOKING*************
    Wait Until Control Object Is Enabled    ${btn_readBooking}
    Send    !r
    Sleep    5
    Run Keyword If    "${gds_switch}" == "amadeus"    Run Keywords    Activate Amadeus Selling Platform    False
    ...    AND    Activate Power Express Window
    Run Keyword If    "${ignore_progress_info_popup.lower()}" == "false"    Wait Until Progress Info Is Completed
    ...    ELSE    Log    Progress Information Window Is Ignored.

Click Update PNR Via Shortcut Key
    Activate Power Express Window
    Send    !u
    Wait Until Progress Info is Completed
    Wait Until Progress Info is Completed
    Set Test Variable    ${is_new_booking_worflow}    ${True}

Click Finish PNR Via Shortcut Key
    [Arguments]    ${keyword}=${EMPTY}    ${delay_in_secs}=5    ${panel}=Recap
    Run Keyword If    '${gds_switch}' == 'sabre'    Enter Specific Command On Native GDS    W-ABC TRAVEL¥W-1/123 MAIN ST¥W-2/DALLAS TX 75201    5/
    Click Panel    ${panel}
    Wait Until Control Object Is Enabled    [NAME:btnSendPNR]
    Comment    Click Control Button    [NAME:btnSendPNR]
    Send    !f
    Sleep    2
    Run Keyword If    '${gds_switch}' == 'amadeus'    Handle Parallel Process    ${keyword}
    Wait Until Progress Info is Completed
    Get PNR Record Locator
    Verify PNR Message
    ${pnr_created_folder} =    Set Variable If    '${test_environment}' == 'local'    C:\\Users\\Public\\Documents\\    '${test_environment}' == 'citrix'    D:\\TFS\\
    ${date_today} =    ExtendedCustomSyExLibrary.Get Current Date
    Run Keyword And Continue On Failure    Append To File    ${pnr_created_folder}pnr_created.txt    ${\n}${current_pnr} - ${GDS_switch} - ${date_today}
    Sleep    ${delay_in_secs}
    Run Keyword If    '${gds_switch}' == 'amadeus'    Run Keywords    Activate Amadeus Selling Platform    False
    ...    AND    Activate Power Express Window
    Log    ${current_pnr}

Click Quick Amend Via Shortcut Key
    Activate Power Express Window
    Send    !q
    Wait Until Progress Info is Completed
    Wait Until Progress Info is Completed

Click Change Team
    ${team_name_title}    Set Variable If    "${locale}" == "de-DE"    Team ändern    "${locale}" == "fr-FR"    Changement d'équipe    Change Team
    Click Button Control    ${team_name_title}    double_click=True

Display Team Selection Window
    Click Clear All
    Click Change Team
    Clear Team Selection

Clear Team Selection
    Wait Until Team Selection Window is Active
    Click Control Button    [NAME:cchkSelectUnselect]    ${team_selection_window}
    Click Control Button    [NAME:cchkSelectUnselect]    ${team_selection_window}

Verify Panel Is Selected
    [Arguments]    ${expected_selected_panel}    ${click_panel_forcefully}=False
    Activate Power Express Window
    Run Keyword If    "${locale}" == "fr-FR"    Translate Panel's Name To French    ${expected_selected_panel}
    ${is_selected}    Is Panel Selected    ${expected_selected_panel}
    Run Keyword If    not ${is_selected} and ${click_panel_forcefully} == True    Click Panel    ${expected_selected_panel}
    ...    ELSE    Should Be True    ${is_selected}

Click Price Tracking Via Shortcut Key
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Control Focus    ${title_power_express}    ${EMPTY}    [NAME:ctxtBookingLocator]
    Send    !i
    Wait Until Progress Info is Completed
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    Set Test Variable    ${is_new_booking_worflow}    ${True}

Change Locale, Profile, Team
    [Arguments]    ${locale}    ${profile}    ${team}    ${user_id}=${EMPTY}
    Activate Power Express Window
    Sleep    2
    Send    ^!{F9}
    Wait Until Control Object Is Visible    [NAME:pnlUser]    [REGEXPTITLE:Sélectionnez l'utilisateur système|System User Settings]
    Control Focus    ${EMPTY}    ${EMPTY}    [NAME:pnlUser]
    ${win_title}    Win Get Title    [ACTIVE]
    Win Activate    ${win_title}    ${EMPTY}
    Win Wait Active    ${win_title}    ${EMPTY}    30
    Run Keyword If    "${user_id}" != "${EMPTY}"    Set Control Text Value    [NAME:txtUser]    ${user_id}    ${win_title}
    Set Control Text Value    ${cbo_locale}    ${locale}    ${win_title}
    Control Click    ${win_title}    ${EMPTY}    ${btn_OKSettings}
    Set Suite Variable    ${locale}
    Select Profile    ${profile}
    Sleep    2
    ${team_selection_window}    Set Variable If    '${locale}' == 'de-DE'    Teamauswahl    '${locale}' == 'fr-FR'    Sélection de l'équipe    Team Selection
    ${is_team_selection_window_present}    Win Exists    ${team_selection_window}    ${EMPTY}
    Run Keyword If    ${is_team_selection_window_present} == 1    Run Keywords    Clear Team Selection
    ...    AND    Select Team    ${team}
    Set Suite Variable    ${locale}

Verify Error In Status Strip Text
    [Arguments]    ${status_strip_text}
    Activate Power Express Window
    Sleep    2
    ${status}    Get Status Strip Text
    Should Not Contain    ${status.upper()}    ${status_strip_text.upper()}    msg=${status}    values=False

Use Local Dev Build
    [Arguments]    ${username}
    Win Activate    PowerExpress - Microsoft Visual Studio    ${EMPTY}
    Wait For Active Window    PowerExpress - Microsoft Visual Studio    ${EMPTY}
    Send    {F5}
    Win Wait    Power Express    ${EMPTY}    300
    Set Suite Variable    ${username}    ${username}

Drop Test Data To TestDropFolder
    [Arguments]    ${test_data_file}
    Sleep    5
    Copy File    ${CURDIR}/../test_data/${test_data_file}    C:\\Program Files (x86)\\Carlson Wagonlit Travel\\Power Express ${version}\\TestDropFolder
    Wait Until Progress Info is Completed

Change Itinerary Language
    [Arguments]    ${language}
    Click MenuItem Control    Langu    double_click=${True}
    Click MenuItem Control    ${language}

Change Team
    [Arguments]    ${team}
    Click Change Team
    Clear Team Selection
    Select Team    ${team}

Verify Control Object Value Is Empty
    [Arguments]    ${control_object}
    ${actual_value}    Control Get Text    ${title_power_express}    ${EMPTY}    ${control_object}
    Should Be Empty    ${actual_value}

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

Verify String Pattern Matches X Times
    [Arguments]    ${pattern}    ${count}    ${remove_spaces}=False    ${remove_gds_number}=True
    ${remove_spaces}    Convert To Boolean    ${remove_spaces}
    ${remove_gds_number}    Convert To Boolean    ${remove_gds_number}
    ${pnr_details}    Flatten String    ${pnr_details}    ${remove_spaces}    ${remove_gds_number}
    ${actual_remark_group}    Get Regexp Matches    ${pnr_details}    ${pattern}
    Log    Actual: ${actual_remark_group}
    Log    Expected: ${pattern}
    ${actual_count}    Get Match Count    ${actual_remark_group}    regexp=${pattern}
    Verify Actual Value Matches Expected Value    ${actual_count}    ${count}    Expected pattern "${pattern}" does not found in the pnr.

Wait Until Panel Is Selected
    [Arguments]    ${panel_name}    ${timeout}=60    ${retry_interval}=1
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Verify Panel Is Selected    ${panel_name}    True

Wait Until Panel Is Visible
    [Arguments]    ${panel_name}    ${timeout}=60    ${retry_interval}=5
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Verify Actual Panel Contains Expected Panel    ${panel_name}
