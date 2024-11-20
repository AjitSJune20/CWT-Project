*** Settings ***
Resource          common_library.robot
Resource          ../../acceptance_tests/gds/gds_verification.robot

*** Variables ***
&{english_panel_dict}    Vérifiez la politique=Policy Check    Réf Client=Cust Refs    Livraison=Delivery    Résumer=Recap    APIS / SFPD=APIS/SFPD    Vérifiez la politique=Policy Check
&{french_panel_dict}    Policy Check=Vérifiez la politique    Cust Refs=Réf Client    Delivery=Livraison    Recap=Résumer    APIS/SFPD=APIS / SFPD    Policy Check=Vérifiez la politique

*** Keywords ***
Verify Dictionary Is In List Of Dictionary
    [Arguments]    ${key}    ${value}    @{list}
    ${dictionary}    Create Dictionary    ${key}    ${value}
    ${result}    Evaluate    ${dictionary} in @{list}
    Should Be True    ${result} == ${True}

Activate Power Express Window
    Win Activate    ${title_power_express}    ${EMPTY}

Add Month From Current Date
    [Arguments]    ${number_of_month_to_add}
    [Documentation]    Returns the whole date
    ${date}    DateTime.Get Current Date    UTC    result_format=datetime
    ${adjust_date}    Evaluate    datetime.datetime(${date.year}, ${date.month} + ${number_of_month_to_add}, ${date.day})    datetime
    [Return]    ${adjust_date}

Click Control Button
    [Arguments]    ${control_object}    ${window_title}=${title_power_express}    ${ignore_verification}=False
    Run Keyword If    "${ignore_verification}" == "False"    Wait Until Keyword Succeeds    60    1    Verify Control Object Is Visible    ${control_object}
    ...    ${window_title}
    Control Focus    ${window_title}    ${EMPTY}    ${control_object}
    Control Click    ${window_title}    ${EMPTY}    ${control_object}

Click Given Object Using Coords
    [Arguments]    ${given_obj}
    ${xpos} =    Control Get Pos X    ${title_active_window}    ${EMPTY}    ${given_obj}
    ${ypos} =    Control Get Pos Y    ${title_active_window}    ${EMPTY}    ${given_obj}
    ${hpos} =    Control Get Pos Height    ${title_active_window}    ${EMPTY}    ${given_obj}
    ${wpos} =    Control Get Pos Width    ${title_active_window}    ${EMPTY}    ${given_obj}
    ${wpos} =    Evaluate    ${wpos} / 2
    ${hpos} =    Evaluate    ${hpos} / 2
    ${xpos} =    Evaluate    ${xpos} + ${wpos}
    ${ypos} =    Evaluate    ${ypos} + ${hpos}
    Auto It Set Option    MouseCoordMode    2
    Win Activate    ${title_power_express}    ${EMPTY}
    Run Keyword If    ${xpos} > 1 and ${ypos} > 1    Mouse Click    LEFT    ${xpos}    ${ypos}
    ...    ELSE    Log    ${given_obj} is not visible    WARN
    Auto It Set Option    MouseCoordMode    0

Confirm Popup Window
    [Arguments]    ${popup_window}=${EMPTY}
    Win Activate    ${popup_window}    ${EMPTY}
    ${ok_button_exists} =    Control Command    ${popup_window}    ${EMPTY}    [NAME:OKBtn]    IsVisible    ${EMPTY}
    ${yes_button_exists} =    Control Command    ${popup_window}    ${EMPTY}    [NAME:YesBtn]    IsVisible    ${EMPTY}
    ${btn_ok_button_exists} =    Control Command    ${popup_window}    ${EMPTY}    [NAME:btnOKButton]    IsVisible    ${EMPTY}
    Run Keyword If    ${ok_button_exists} == 1    Click Control Button    [NAME:OKBtn]    ${popup_window}
    ...    ELSE IF    ${yes_button_exists} == 1    Click Control Button    [NAME:YesBtn]    ${popup_window}
    ...    ELSE IF    ${btn_ok_button_exists} == 1    Click Control Button    [NAME:btnOKButton]    ${popup_window}

Connect To Power Express Database
    [Arguments]    ${schema}=Desktop_SyEx_Pilot
    Run Keyword If    '${syex_env.lower()}' == 'test'    Connect To Test DB    ${schema}
    ...    ELSE    Connect To Syex Sandbox Pilot DB    ${schema}

Connect To Syex Sandbox Pilot DB
    [Arguments]    ${schema}=ApplicationUsage_Sandbox_Pilot
    Set Log Level    NONE
    Comment    ${dbusername}=    RSALibrary.B 64 Decode    ${dbusername_sandboxpilot}
    Comment    ${dbpassword}=    RSALibrary.B 64 Decode    ${dbpassword_sandboxpilot}
    DatabaseLibrary.Connect To Database    pymssql    ${schema}    ExpressAutomation    Expr355Aut0_eal1    ${dbhost_sandboxpilot}    ${dbport}
    Set Log Level    INFO

Connect To Test DB
    [Arguments]    ${schema}=ApplicationUsage_Test
    Comment    ${dbusername}=    RSALibrary.B 64 Decode    ${dbusername}
    Comment    ${dbpassword}=    RSALibrary.B 64 Decode    ${dbpassword}
    DatabaseLibrary.Connect To Database    pymssql    ${schema}    ${dbusername}    ${dbpassword}    ${dbhost}    ${dbport}
    Log    ${schema}

Convert English Date To French
    [Arguments]    ${flight_date}
    Set Variable    ${flight_date}    ${flight_date.strip()}
    ${month_english}    Remove All Integer    ${flight_date}
    ${month_french}    Convert Month To French Locale    ${month_english}
    ${flight_date}    Replace String    ${flight_date}    ${month_english}    ${month_french}
    Set Test Variable    ${flight_date}
    [Return]    ${flight_date}

Convert French Date To English
    [Arguments]    ${flight_date}
    Set Variable    ${flight_date}    ${flight_date.strip()}
    ${month_french}    Remove All Integer    ${flight_date}
    ${month_english}    Convert Month To English Locale    ${month_french}
    ${flight_date}    Replace String    ${flight_date}    ${month_french}    ${month_english}
    Set Test Variable    ${flight_date}
    [Return]    ${flight_date}

Create City Name Query Statement
    [Arguments]    @{city_route}
    ${previous}    Set Variable    ${EMPTY}
    : FOR    ${city_code}    IN    @{city_route}
    \    ${query}    Set Variable    SELECT c.Name FROM TravelPort t INNER JOIN City c ON t.CityCode = c.CityCode WHERE t.TravelPortCode = '${city_code}'
    \    ${catenated_value}    Catenate    ${previous}    ${query}
    \    Log    ${catenated_value}
    \    ${previous}    Set Variable    ${catenated_value}
    ${query_statement}    Replace String    ${catenated_value.lstrip()}    ${SPACE}SELECT    ${SPACE}UNION ALL SELECT
    Log    ${query_statement}
    [Teardown]
    [Return]    ${query_statement}

Delete Current Specific Log File
    [Arguments]    ${log_filename}
    ${perf_file}    Determine Log File Name and Path    ${log_filename}
    Comment    Set Test Variable    ${previous_file_size}    ${EMPTY}
    Comment    : FOR    ${ctr}    IN RANGE    99
    Comment    \    ${current_file_size}    Get File Size    ${perf_file}
    Comment    \    Run Keyword If    '${current_file_size}' == '${previous_file_size}'    Exit For Loop
    Comment    \    Set Test Variable    ${previous_file_size}    ${current_file_size}
    Comment    \    Sleep    10
    Remove File    ${perf_file}
    Wait Until Removed    ${perf_file}    120

Delete Log File
    [Arguments]    ${log_file}
    ${cwt_path}    Set Variable    \\Carlson Wagonlit Travel\\Power Express\\${version}\\
    ${local_appdata}    Evaluate    os.getenv('LOCALAPPDATA')    os
    ${time}    Get Time    'year','month','day'
    ${current_date}    Set Variable    ${time[0]}${time[1]}${time[2]}
    ${username}    Get Local Username
    ${log_file_path}    Set Variable    ${local_appdata}${cwt_path}${username}.${log_file}_${current_date}.log
    Remove File    ${log_file_path}
    Wait Until Removed    ${log_file_path}

Delete Log Files
    ${cwt_path}    Set Variable    \\Carlson Wagonlit Travel\\Power Express\\${version}\\
    ${local_appdata}    Evaluate    os.getenv('LOCALAPPDATA')    os
    ${log_file_path}    Set Variable    ${local_appdata}${cwt_path}
    Remove Files    ${log_file_path}${/}*.*

Determine Control Object Background Color
    [Arguments]    ${object}    ${xadd}=0    ${yadd}=0
    ${x}    Control Get Pos X    ${title_power_express}    ${EMPTY}    ${object}
    ${width}    Control Get Pos Width    ${title_power_express}    ${EMPTY}    ${object}
    ${width}    Evaluate    ${width}/2
    ${x}    Evaluate    ${x}+${width}+${xadd}
    ${y}    Control Get Pos Y    ${title_power_express}    ${EMPTY}    ${object}
    ${height}    Control Get Pos Height    ${title_power_express}    ${EMPTY}    ${object}
    ${height}    Evaluate    ${height}/2
    ${y}    Evaluate    ${y}+${height}+${yadd}
    Auto It Set Option    PixelCoordMode    2
    ${actual_bgcolor}    Pixel Get Color    ${x}    ${y}
    Auto It Set Option    PixelCoordMode    0
    ${actual_bgcolor}    Convert To Hex    ${actual_bgcolor}
    [Return]    ${actual_bgcolor}

Determine Control Object Is Visible On Active Tab
    [Arguments]    ${obj_name}    ${default_control_counter}=True
    Set Test Variable    ${is_obj_visible}    ${EMPTY}
    Set Test Variable    ${object_status}    False
    @{actual_obj_list}    Split String    ${obj_name}    ,
    : FOR    ${index}    IN RANGE    1    20
    \    ${object_name}    ${is_obj_visible}    Verify Multiple Object Name is Visible On Active Tab    ${actual_obj_list}    ${index}    ${default_control_counter}
    \    Run Keyword If    ${is_obj_visible} == 1    Run Keywords    Set Test Variable    ${object_status}    True
    \    ...    AND    Exit For Loop
    [Return]    ${object_status}

Determine Log File Name and Path
    [Arguments]    ${log_filename}    ${given_user}=${EMPTY}
    ${log_path}    Get Log Path    ${test_environment}    ${version}
    ${time}    Get Time    'year','month','day'
    ${currDate}    Set Variable    ${time[0]}${time[1]}${time[2]}
    ${real_user}    Get UserName
    Set Test Variable    ${real_user}    ${real_user.upper()}
    Log    Path and Filename: ${log_path}${real_user}.${log_filename}_${currDate}.log
    [Return]    ${log_path}${real_user}.${log_filename}_${currDate}.log

Determine Multiple Object Name Based On Active Tab
    [Arguments]    ${obj_name}    ${default_control_counter}=True    ${field_instance}=${EMPTY}
    Log    ${obj_name}
    Win Activate    ${title_power_express}    ${EMPTY}
    @{actual_obj_list}    Split String    ${obj_name}    ,
    : FOR    ${index}    IN RANGE    0    11
    \    ${object_name}    ${is_obj_visible}    Verify Multiple Object Name is Visible On Active Tab    ${actual_obj_list}    ${index}    ${default_control_counter}
    \    ...    ${field_instance}
    \    Log    ${object_name}
    \    Log    ${is_obj_visible}
    \    Exit For Loop If    ${is_obj_visible} == 1
    [Return]    ${object_name}

Execute Query
    [Arguments]    ${sql_query}    ${schema}
    Connect To Power Express Database    ${schema}
    @{queryResults}    Query    ${sql_query}
    Log    ${queryResults}
    Disconnect From Database
    [Return]    @{queryResults}

Generate Expected PNR Remark
    [Arguments]    ${expected_remark_container}    ${replace_token}    @{remark_items}
    : FOR    ${item}    IN    @{remark_items}
    \    ${expected_remark}=    Replace String    ${expected_remark_container}    ${replace_token}    ${item}    count=1
    \    ${expected_remark_container}    Set Variable    ${expected_remark}
    Set Variable    ${expected_remark}
    [Return]    ${expected_remark}

Get Checkbox Status
    [Arguments]    ${obj_chkbox}
    ${is_checked}    Get Checkbox State    ${obj_chkbox}
    ${is_checked}    Set Variable If    ${is_checked} == 1    True    False
    Set Test Variable    ${is_checked}
    [Return]    ${is_checked}

Get City Name
    [Arguments]    @{city_code}
    Comment    Connect To Power Express Database    Desktop_Test
    Connect To Test DB    Desktop_Test
    ${query_statement}    Create City Name Query Statement    @{city_code}
    @{city_names_query}    Query    ${query_statement}
    ${previous_city}    Set Variable    ${EMPTY}
    ${previous_city_with_dash}    Set Variable    ${EMPTY}
    ${previous_city_with_slash}    Set Variable    ${EMPTY}
    ${city_length}    Get Length    ${city_code}
    : FOR    ${INDEX}    IN RANGE    ${city_length}
    \    ${city_names}    Catenate    ${previous_city}    ${city_names_query[${INDEX}][0]}
    \    ${city_names_with_dash}    Catenate    SEPARATOR=+    ${previous_city_with_dash}    ${city_names_query[${INDEX}][0]}
    \    ${city_names_with_slash}    Catenate    SEPARATOR=/    ${previous_city_with_slash}    ${city_names_query[${INDEX}][0]}
    \    ${previous_city}    Set Variable    ${city_names}
    \    ${previous_city_with_dash}    Set Variable    ${city_names_with_dash}
    \    ${previous_city_with_slash}    Set Variable    ${city_names_with_slash}
    [Teardown]    Disconnect From Database
    [Return]    ${city_names.upper().strip()}    ${city_names_with_dash.upper().strip()}    ${city_names_with_slash.upper().strip()}

Get Code From Dropdown Value
    [Arguments]    ${dropdown_value}    ${delimeter}
    ${code}    Fetch From Left    ${dropdown_value}    ${delimeter}
    ${code}    Strip String    ${code}    right
    Set Variable    ${code}
    [Return]    ${code}

Get Control Background Color
    [Arguments]    ${control_id}
    Comment    ${xpos} =    ${ypos} =    Get Control Coords    ${control_id}
    ${color}    Get Pixel Color    control_id=${control_id}
    [Return]    ${color}

Get Control Coordinates
    [Arguments]    ${control_id}
    ${xpos} =    ${ypos} =    Get Control Coords    ${control_id}
    [Return]    ${xpos}    ${ypos}

Get Control Field Mandatory State
    [Arguments]    ${object_name}
    Comment    ${x}    ${y}    Get Control Coords    ${object_name}
    ${actual_hex_color}    Get Pixel Color    control_id=${object_name}
    ${mandatory_status}    Set Variable If    "${actual_hex_color}" == "FFD700"    Mandatory    Not Mandatory
    [Return]    ${mandatory_status}

Get Control Object Background Color
    [Arguments]    ${object}    ${xadd}=0    ${yadd}=0
    ${x}    Control Get Pos X    ${title_power_express}    ${EMPTY}    ${object}
    ${width}    Control Get Pos Width    ${title_power_express}    ${EMPTY}    ${object}
    ${width}    Evaluate    ${width}/2
    ${x}    Evaluate    ${x}+${width}+${xadd}
    ${y}    Control Get Pos Y    ${title_power_express}    ${EMPTY}    ${object}
    ${height}    Control Get Pos Height    ${title_power_express}    ${EMPTY}    ${object}
    ${height}    Evaluate    ${height}/2
    ${y}    Evaluate    ${y}+${height}+${yadd}
    Auto It Set Option    PixelCoordMode    2
    ${actual_bgcolor}    Pixel Get Color    ${x}    ${y}
    Auto It Set Option    PixelCoordMode    0
    ${actual_bgcolor}    Convert To Hex    ${actual_bgcolor}
    [Return]    ${actual_bgcolor}

Get Control Text Value
    [Arguments]    ${control_object}    ${window_title}=${title_power_express}
    Wait Until Keyword Succeeds    60    0.5    Verify Control Object Is Visible    ${control_object}    ${window_title}
    ${control_text_object} =    Control Get Text    ${window_title}    ${EMPTY}    ${control_object}
    ${control_text_object} =    Replace String Using Regexp    ${control_text_object}    ^@    ${EMPTY}
    Set Test Variable    ${control_text_object}
    [Return]    ${control_text_object}

Get Future Dates For LCC Remarks
    [Arguments]    ${number_of_months}
    ${departure_date}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}
    ${departure_date1}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    5
    ${departure_date2}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    10
    ${departure_date3}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    15
    ${departure_date4}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    20
    ${next_day_departure_date}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    1
    Set Test Variable    ${departure_date}
    Set Test Variable    ${departure_date1}
    Set Test Variable    ${departure_date2}
    Set Test Variable    ${departure_date3}
    Set Test Variable    ${departure_date4}
    Set Test Variable    ${next_day_departure_date}

Get Log File
    [Arguments]    ${file_name}
    ${file_path}    Determine Log File Name and Path    ${file_name}
    ${log_file}    OperatingSystem.Get File    ${file_path}
    [Return]    ${log_file}

Get Month Name
    [Arguments]    ${month_number}
    ${month_number}    Convert to Integer    ${month_number}
    ${months_list}    Create List    JAN    FEB    MAR    APR    MAY
    ...    JUN    JUL    AUG    SEP    OCT    NOV
    ...    DEC
    ${month_number}    Evaluate    ${month_number}-1
    ${month_name}    Get From List    ${months_list}    ${month_number}
    Set Test Variable    ${month_name}
    [Return]    ${month_name}

Get Radio Button Status
    [Arguments]    ${radio_button_control_id}
    ${is_selected}    Get Radio Button State    ${radio_button_control_id}
    [Return]    ${is_selected}

Get Remarks Leading And Succeeding Line Numbers
    [Arguments]    ${unique_keyword}
    Log    ${pnr_details}
    ${pnr_details_editted}    Replace String    ${pnr_details}    *    -
    ${unique_keyword_editted}    Replace String    ${unique_keyword}    *    -
    ${full_line_remarks}    Get Lines Using Regexp    ${pnr_details_editted}    ${unique_keyword_editted}
    ${line_no}    Get Substring    ${full_line_remarks}    0    3
    ${line_no}    Remove String Using Regexp    ${line_no}    [^\\d]
    ${remarks_count}    Set Variable    0
    ${counter}    Set Variable    0
    : FOR    ${remarks_count}    IN RANGE    0    10
    \    ${remarks_count}    Evaluate    ${line_no} + ${remarks_count}
    \    ${counter}    Evaluate    ${counter} + 1
    \    Set Suite Variable    ${remarks_${counter}}    ${remarks_count}
    \    Log    TEST::::- ${remarks_count} -and- ${remarks_${counter}}
    ${remarks_count}    Set Variable    0
    : FOR    ${remarks_count}    IN RANGE    0    10
    \    ${remarks_count}    Evaluate    ${line_no} - ${remarks_count}
    \    ${counter}    Evaluate    ${counter} - 1
    \    Set Suite Variable    ${remarks_1${counter}}    ${remarks_count}
    \    Log    TEST::::- ${remarks_count} -and- ${remarks_1${counter}}

Get Remarks Line And Descending Numbers
    [Arguments]    ${unique_keyword}
    Log    ${pnr_details}
    ${pnr_details_editted}    Replace String    ${pnr_details}    *    -
    ${unique_keyword_editted}    Replace String    ${unique_keyword}    *    -
    ${full_line_remarks}    Get Lines Using Regexp    ${pnr_details_editted}    ${unique_keyword_editted}
    ${line_no}    Get Substring    ${full_line_remarks}    0    3
    ${line_no}    Remove String Using Regexp    ${line_no}    [^\\d]
    ${remarks_count}    Set Variable    0
    ${counter}    Set Variable    0
    : FOR    ${remarks_count}    IN RANGE    0    10
    \    ${remarks_count}    Evaluate    ${line_no} - ${remarks_count}
    \    ${counter}    Evaluate    ${counter} - 1
    \    Set Suite Variable    ${remarks_1${counter}}    ${remarks_count}
    \    Log    TEST::::- ${remarks_count} -and- ${remarks_1${counter}}

Get String Between Strings
    [Arguments]    ${whole_string}    ${start_string}    ${last_string}
    ${start_string} =    Decode Bytes To String    ${start_string}    UTF-8
    ${last_string} =    Decode Bytes To String    ${last_string}    UTF-8
    ${start_string_exist}    Run Keyword and Return Status    Should Contain    ${whole_string}    ${start_string}
    Run keyword If    "${start_string_exist}" == "False"    Run Keyword and Continue On Failure    FAIL    ${start_string} NOT FOUND
    ${string_array} =    Split String    ${whole_string}    ${start_string}    1
    ${last_string_exist}    Run Keyword and Return Status    Should Contain    ${string_array[1]}    ${last_string}
    Run keyword If    "${last_string_exist}" == "False"    Run Keyword and Continue On Failure    FAIL    ${last_string} NOT FOUND
    ${string_array1} =    Split String    ${string_array[1]}    ${last_string}    1
    [Return]    ${string_array1[0]}

Get Weekday Name
    [Arguments]    ${year}    ${month}    ${day}
    ${year}    Convert to Integer    ${year}
    ${month}    Convert to Integer    ${month}
    ${day}    Convert to Integer    ${day}
    ${offset} =    Create List    0    31    59    90    120
    ...    151    181    212    243    273    304
    ...    334
    ${days_in_week} =    Create List    SUN    MON    TUE    WED    THU
    ...    FRI    SAT
    ${after_feb}    Set Variable    1
    ${month>2} =    Evaluate    ${month} > 2
    Run Keyword If    "${month>2}" == "True"    Set Test Variable    ${after_feb}    0\
    ${aux} =    Evaluate    ${year} - 1700 - ${after_feb}
    ${day_name}    Set Variable    5
    ${aux_after_feb} =    Evaluate    ${aux} + ${after_feb}
    ${day_name} =    Evaluate    ${day_name} + ${aux_after_feb} * 365
    ${aux_100} =    Evaluate    ${aux} + 100
    ${day_name} =    Evaluate    ${day_name} + ${aux} / 4 - ${aux} / 100 + ${aux_100} / 400
    ${month1} =    Evaluate    ${month} - 1
    ${day_name} =    Evaluate    ${day_name} + ${offset[${month1}]} + (${day} - 1)
    ${day_name} =    Evaluate    ${day_name} % 7
    Set Test Variable    ${day_name}    ${days_in_week[${day_name}]}
    [Return]    ${day_name}

Handle Generic Window Popup
    [Arguments]    ${error_message}=${EMPTY}
    ${active_window} =    Win Get Title    [ACTIVE]    ${EMPTY}
    ${is_cdr_driving_account_fop} =    Control Command    CDR Driving Account/FOP    ${EMPTY}    ${EMPTY}    IsVisible    ${EMPTY}
    Run Keyword If    ${is_cdr_driving_account_fop} == 1    Click Control Button    [NAME:btnCancel]    CDR Driving Account/FOP
    Run Keyword Unless    "${active_window}" != "New Contact..."    Handle New Contact Popup
    ${is_popup_text_message_present} =    Control Command    ${active_window}    ${EMPTY}    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    ${popup_error_msg}    Run Keyword If    ${is_popup_text_message_present} == 1    Control Get Text    ${active_window}    ${EMPTY}    [NAME:txtMessageTextBox]
    ...    ELSE    Set Variable    ${EMPTY}
    ${is_traveller_lookup_unavailable} =    Control Command    Power Express    The Traveler GDS Look Up Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again.    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_traveller_lookup_unavailable} == 0    Fatal Error    The Traveler GDS Look Up Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again.
    ${is_displayed}    Run Keyword If    ${is_popup_text_message_present} == 1 and '${error_message}' != '${EMPTY}'    Run Keyword And Return Status    Should Contain    ${popup_error_msg}    ${error_message}
    Run Keyword If    ${is_displayed} == True    Set Test Variable    ${retry_popup_status}    True
    ${is_popup_clear_message_present} =    Control Command    ${active_window}    ${EMPTY}    [NAME:ClearAllMessage]    IsVisible    ${EMPTY}
    ${is_no_endpoint_listening} =    Control Command    ${active_window}    There was no endpoint listening    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_no_endpoint_listening} == 0    Fatal Error    There was no endpoint listening at https://itest2distribution.cwtwebservices.com/TravelerGDSLookUp.serviceagent/TravelerGDSLookUpEndpoint that could accept the message. This is often caused by an incorrect address or SOAP action. See InnerException, if present, for more details.
    ${is_portrait_down} =    Control Command    ${active_window}    The request channel timed out    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_portrait_down} == 0    Fatal Error    Der Portrait Lookup Service arbeitet derzeit nicht. Bitte identifizieren Sie bis auf weiteres den Reisenden über das GDS. The request channel timed out while waiting for a reply after 00:00:59.8389839. Increase the timeout value passed to the call to Request or increase the SendTimeout value on the Binding. The time allotted to this operation may have been a portion of a longer timeout.
    ${is_portrait_search_unavailable} =    Control Command    Power Express    The Portrait Web Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again. \ Portrait Search Disabled    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_portrait_search_unavailable} == 0    Fatal Error    The Portrait Web Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again.
    ${is_cant_complete_pnr} =    Control Command    Power Express    Express ne peut pas terminer le PNR.    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    ${is_power_express_popup_text_message_present} =    Control Command    [REGEXPTITLE:Power Express|messages|Benachrichtigungen]    ${EMPTY}    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    ${is_traveller_lookup_unavailable} =    Control Command    Power Express    The Traveler GDS Look Up Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again.    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_traveller_lookup_unavailable} == 0    Fatal Error    The Traveler GDS Look Up Service is unavailable. Please identify the traveler via the GDS search box provided until it is working again.
    ${is_message_from_webpage_present}    Control Command    Message from webpage    ${EMPTY}    ${EMPTY}    IsVisible    ${EMPTY}
    ${is_update_phone_present}    Control Command    [REGEXPTITLE:Update Traveller's Phone Number|Mettre le numéro de téléphone du voyageur à jour]    ${EMPTY}    [NAME:lblMessage]    IsVisible    ${EMPTY}
    ${simultaneous_text}    Set Variable If    "${locale}" == "fr-FR"    Express ne peut terminer le PNR à cause d’une mise à jour parallèle    "${locale}" == "de-DE"    Express kann den PNR aufgrund eines Simultaneous changes nicht beenden    Express is unable to end the PNR due to simultaneous changes.
    ${is_simultaneous}    Control Command    Power Express    ${simultaneous_text}    [NAME:txtMessageTextBox]    IsVisible    ${EMPTY}
    ${simultaneous_changes}    Set Variable If    ${is_simultaneous} == 1    ${True}    ${False}
    Set Suite Variable    ${simultaneous_changes}
    ${is_contact_creation_error_present}    Win Exists    Contact Creation Error    ${EMPTY}
    ${is_clear_all_present}    Win Exists    [REGEXPTITLE:Tout effacer|Clear All]    ${EMPTY}
    Run Keyword If    ${is_clear_all_present} == 1    Confirm Popup Window    [REGEXPTITLE:Tout effacer|Clear All]
    Run Keyword If    ${is_cant_complete_pnr} == 1    Run Keywords    Win Activate    Power Express    ${EMPTY}
    ...    AND    Confirm Popup Window    Power Express
    Run Keyword If    ${is_contact_creation_error_present} == 1    Confirm Popup Window    Contact Creation Error
    Run Keyword If    ${is_simultaneous} == 1    Click Control Button    [NAME:CancelBtn]    Power Express
    Run Keyword If    ${is_power_express_popup_text_message_present} == 1 and ${is_simultaneous} == 0    Confirm Popup Window    [REGEXPTITLE:Power Express|messages|Benachrichtigungen]
    Run Keyword If    ${is_update_phone_present} == 1 and ${is_simultaneous} == 0    Click Control Button    [NAME:btnCancel]    [REGEXPTITLE:Update Traveller's Phone Number|Mettre le numéro de téléphone du voyageur à jour]
    ${active_window} =    Win Get Title    [ACTIVE]    ${EMPTY}
    Run Keyword If    ${is_popup_text_message_present} == 1 or ${is_popup_clear_message_present} == 1 and ${is_simultaneous} == 0    Confirm Popup Window    ${active_window}

Handle Incomplete Contacts
    ${user_incomplete_contacts} =    Win Exists    ${title_incomplete_contacts}    ${EMPTY}
    Run Keyword If    "${user_incomplete_contacts}" == "1"    Control Click    ${title_incomplete_contacts}    ${EMPTY}    ${btn_incomplete_contacts}

Handle New Contact Popup
    Win Activate    New Contact...    ${EMPTY}
    Sleep    1
    Control Click    New Contact...    ${EMPTY}    ${explorer_server}    ${EMPTY}    1    774
    ...    215
    Sleep    1
    Send    {PGUP}
    Sleep    1
    Send    ${primaryReason}    1
    Sleep    1
    Control Click    ${title_newContact}    ${EMPTY}    ${explorer_server}    ${EMPTY}    1    727
    ...    350
    Sleep    2
    Send    {HOME}
    Sleep    2
    Send    ${location_counselor}    1
    Send    {TAB}
    Sleep    1
    Control Click    New Contact...    ${EMPTY}    ${explorer_server}    ${EMPTY}    1    733
    ...    525
    Sleep    3
    ${timeout_exists} =    Win Exists    New Contact...    ${EMPTY}
    Run Keyword If    "${timeout_exists}" == "1"    WinClose    ${title_newContact}    ${EMPTY}

Loop Until Object Is Visible
    [Arguments]    ${window_title}    ${object}    ${loop_count}=30
    : FOR    ${INDEX}    IN RANGE    ${loop_count}
    \    Sleep    2
    \    ${object_visibility}    Control Command    ${window_title}    ${EMPTY}    ${object}    IsVisible
    \    ...    ${EMPTY}
    \    Exit For Loop If    ${object_visibility} == 1

Remove All Integer
    [Arguments]    ${whole_string}
    ${whole_string}    Replace String Using Regexp    ${whole_string}    \\d    ${EMPTY}
    [Return]    ${whole_string.strip()}

Remove All Non-Integer (retain period)
    [Arguments]    ${whole_string}
    ${whole_integer}    Replace String Using Regexp    ${whole_string}    [^\\d.]+    ${EMPTY}
    Set Test Variable    ${whole_integer}
    [Return]    ${whole_integer.strip()}

Remove All Non Numeric
    [Arguments]    ${whole_string}
    ${whole_integer}    Replace String Using Regexp    ${whole_string}    \\D    ${EMPTY}
    [Return]    ${whole_integer}

Remove Blank Lines And Output To List
    [Arguments]    ${string_to_parse}
    @{lines}    Split to lines    ${string_to_parse}
    ${parse_list}    Create List
    : FOR    ${line}    IN    @{lines}
    \    ${int_Len} =    Get Length    ${line}
    \    ${int_count} =    Get Count    ${line}    ${SPACE}
    \    Run Keyword If    ${int_Len} <> 0 and ${int_count} <> ${int_Len}    Append To List    ${parse_list}    ${line}
    [Return]    ${parse_list}

Remove Decimals
    [Arguments]    ${string_with_decimals}
    ${string_with_decimals}    Convert To String    ${string_with_decimals}
    ${string_without_decimals}    Fetch From Left    ${string_with_decimals}    .
    [Return]    ${string_without_decimals}

Rename Log File
    [Arguments]    ${log_file}
    ${cwt_path}    Set Variable    \\Carlson Wagonlit Travel\\Power Express\\${version}\\
    ${local_appdata}    Evaluate    os.getenv('LOCALAPPDATA')    os
    ${time}    Get Time    'year','month','day'
    ${current_date}    Set Variable    ${time[0]}${time[1]}${time[2]}
    ${username}    Get Local Username
    ${log_file_path}    Set Variable    ${local_appdata}${cwt_path}${username}.${log_file}_${current_date}.log
    ${time_stamp}    Generate Time Stamp
    ${new_log_file_path}    Set Variable    ${local_appdata}${cwt_path}${username}.${log_file}_${current_date}_${time_stamp}.log
    Rename File    ${log_file_path}    ${new_log_file_path}

Remove Line Number
    [Arguments]    ${string_with_line_number}
    ${pattern}    Set Variable If    "${gds_switch}" == "amadeus"    ((^\\d+\\s)|(\\n\d+\\s))    "${gds_switch}" == "galileo"    \\d+.?\\s
    ${string_without_line_number}    Remove String Using Regexp    ${string_with_line_number}    ${pattern}
    [Return]    ${string_without_line_number}

Replace Decimal Sign
    [Arguments]    ${amount}    ${old_decimal_sign}    ${new_decimal_sign}    ${custom_amount_variable_name}=custom_amount
    ${custom_amount}    Replace String    ${amount}    ${old_decimal_sign}    ${new_decimal_sign}
    Set Test Variable    ${${custom_amount_variable_name}}    ${custom_amount}
    [Return]    ${custom_amount}

Send Control Text Value
    [Arguments]    ${control_object}    ${data_input}    ${window_title}=${title_power_express}
    Wait Until Keyword Succeeds    60    1    Verify Control Object Is Visible    ${control_object}    ${window_title}
    Control Set Text    ${window_title}    ${EMPTY}    ${control_object}    ${EMPTY}
    Control Click    ${window_title}    ${EMPTY}    ${control_object}
    Send    ${data_input}

Send Keys
    [Arguments]    @{command}
    : FOR    ${each_command}    IN    @{command}
    \    Send    ${each_command}
    \    Sleep    1

Set Control Text Value
    [Arguments]    ${control_object}    ${data_input}    ${window_title}=${title_power_express}
    Comment    Set Log Level    NONE
    Wait Until Keyword Succeeds    60    1    Verify Control Object Is Visible    ${control_object}    ${window_title}
    Control Click    ${window_title}    ${EMPTY}    ${control_object}
    Control Set Text    ${window_title}    ${EMPTY}    ${control_object}    ${data_input}
    Comment    Set Log Level    INFO

Set Field To Empty
    [Arguments]    ${field_name}
    Control Click    ${title_power_express}    ${EMPTY}    ${field_name}
    Send    ^a
    Send    {DELETE}
    Send    {TAB}

Set Field Value
    [Arguments]    ${field_name}    ${field_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ${field_name}
    Set Field To Empty    ${object_name}
    Send Control Text Value    ${object_name}    ${field_value}
    Send    {TAB}

Subtract Month From Current Date
    [Arguments]    ${number_of_month_to_subtract}
    [Documentation]    Returns the whole date
    ${date}    DateTime.Get Current Date    UTC    result_format=datetime
    ${adjusted_date}    Evaluate    datetime.datetime(${date.year}, ${date.month} - ${number_of_month_to_subtract}, ${date.day})    datetime
    [Return]    ${adjusted_date}

Tick Checkbox
    [Arguments]    ${obj_chkbox_or_label}    ${checkbox_method}=${EMPTY}
    [Documentation]    Accepts either Control ID or Label
    Toggle Checkbox    ${obj_chkbox_or_label}

Translate Panel's Name To French
    [Arguments]    ${panel_name}
    ${status}    Run Keyword And Return Status    Dictionary Should Contain Key    ${english_panel_dict}    ${panel_name}
    ${panel_name}    Run Keyword If    ${status}    Get From Dictionary    ${french_panel_dict}    ${panel_name}
    ...    ELSE    Set Variable    ${panel_name}
    Set Test Variable    ${panel_name}
    Set Test Variable    ${panel_translated}    ${True}

Translate Panel's Name To English
    [Arguments]    ${panel_name}
    ${status}    Run Keyword And Return Status    Dictionary Should Contain Key    ${english_panel_dict}    ${panel_name}
    ${panel_name}    Run Keyword If    ${status}    Get From Dictionary    ${english_panel_dict}    ${panel_name}
    ...    ELSE    Set Variable    ${panel_name}
    Set Test Variable    ${panel_name}
    Set Test Variable    ${panel_translated}    ${True}

Untick Checkbox
    [Arguments]    ${obj_chkbox_or_label}
    [Documentation]    Accepts either Control ID or Label
    Untoggle Checkbox    ${obj_chkbox_or_label}

Verify Actual Value Matches Expected Value
    [Arguments]    ${actual_value}    ${expected_value}    ${custom_error}=${EMPTY}
    Log    Actual: ${actual_value}
    Log    Expected: ${expected_value}
    Run Keyword If    '${custom_error}' == '${EMPTY}'    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${actual_value}    ${expected_value}
    ...    ELSE IF    '${custom_error}' != '${EMPTY}'    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${actual_value}    ${expected_value}
    ...    ${custom_error}    FALSE

Verify Checkbox Is Ticked
    [Arguments]    ${object_name}
    ${checkbox_status}    Get Checkbox Status    ${object_name}
    Run Keyword And Continue On Failure    Should Be True    ${checkbox_status} == True

Verify Checkbox Is Unticked
    [Arguments]    ${object_name}
    ${checkbox_status}    Get Checkbox Status    ${object_name}
    Run Keyword And Continue On Failure    Should Be True    ${checkbox_status} == False    Checkbox status should be unticked

Verify Control Object Background Color
    [Arguments]    ${object}    ${expected_hex_color}    ${xadd}=0    ${yadd}=0
    ${actual_hex_color}    Get Pixel Color    control_id=${object}
    Run Keyword And Continue On Failure    Should Be True    "${actual_hex_color}" == "${expected_hex_color}"    Color '${actual_hex_color}' is not equal to '${expected_hex_color}'
    ${is_background_color_equal}    Run Keyword And Return Status    Should Be True    "${actual_hex_color}" == "${expected_hex_color}"
    [Return]    ${is_background_color_equal}

Verify Control Object Field Is Mandatory
    [Arguments]    ${object_name}
    ${actual_hex_color}    Get Pixel Color    control_id=${object_name}
    Run Keyword And Continue On Failure    Should Contain Any    ${actual_hex_color}    FFD700    FFDB90
    ${is_background_color_equal}    Run Keyword And Return Status    Should Contain Any    ${actual_hex_color}    FFD700    FFDB90
    [Return]    ${is_background_color_equal}

Verify Control Object Field Is Not Mandatory
    [Arguments]    ${object_name}
    ${actual_hex_color}    Get Pixel Color    control_id=${object_name}
    Should Be True    "${actual_hex_color}" != "FFD700"    msg=Control should be NOT MANDATORY. Color found is "${actual_hex_color}"

Verify Control Object Is Disabled
    [Arguments]    ${obj_name}    ${field_name}=${EMPTY}
    ${is_enabled} =    Control Command    ${title_power_express}    ${EMPTY}    ${obj_name}    IsEnabled    ${EMPTY}
    Run Keyword And Continue On Failure    Should Be True    ${is_enabled} == 0    ${obj_name} - ${field_name} should be disabled

Verify Control Object Is Enabled
    [Arguments]    ${obj_name}    ${window_title}=${title_power_express}    ${handle_popups}=True    ${message}=${obj_name} should be enabled
    Run Keyword If    '${handle_popups.lower()}' == 'true'    Handle Generic Window Popup
    ${is_enabled} =    Control Command    ${window_title}    ${EMPTY}    ${obj_name}    IsEnabled    ${EMPTY}
    Should Be True    ${is_enabled} == 1    msg=${message}

Verify Control Object Is Not Visible
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}
    Win Activate    ${window_title}    ${EMPTY}
    ${object_visibility} =    Control Command    ${window_title}    ${EMPTY}    ${object_name}    IsVisible    ${EMPTY}
    Run Keyword And Continue On Failure    Should Be True    ${object_visibility} == 0    ${object_name} should not be visible

Verify Control Object Is Visible
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}    ${handle_popups}=false
    Win Activate    ${window_title}    ${EMPTY}
    Run Keyword If    '${handle_popups.lower()}' == 'true'    Handle Generic Window Popup
    ${object_visibility} =    Control Command    ${window_title}    ${EMPTY}    ${object_name}    IsVisible    ${EMPTY}
    Run Keyword And Continue On Failure    Should Be True    ${object_visibility} == 1    ${object_name} should be visible

Verify Control Object Is Visible Based On Active Tab
    [Arguments]    ${fare_tab}    ${obj_list}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    @{actual_obj_list}    Split String    ${obj_list}    ,
    @{visible_objects}    Create List
    Win Activate    ${title_power_express}    ${EMPTY}
    : FOR    ${obj_name}    IN    @{actual_obj_list}
    \    ${object_name}    Set Variable If    ${default_control_counter} == True    [NAME:${obj_name}_${fare_tab_index}]    [NAME:${obj_name}]
    \    ${object_visibility} =    Control Command    ${title_power_express}    ${EMPTY}    ${object_name}    IsVisible
    \    ...    ${EMPTY}
    \    Append To List    ${visible_objects}    ${object_visibility}
    \    Exit For Loop If    ${object_visibility} == 1
    List Should Contain Value    ${visible_objects}    1

Verify Control Object Text Value Is Correct
    [Arguments]    ${control_object}    ${expected_text_value}    ${optional_message}=${EMPTY}    ${verification_mode}=${EMPTY}    ${window_title}=${EMPTY}    ${multi_line_search_flag}=false
    ...    ${remove_spaces}=false
    ${actual_text_value}    Get Control Text Value    ${control_object}    ${window_title}
    ${actual_text_value}    Run Keyword If    "${multi_line_search_flag.lower()}" == "true" and "${remove_spaces}" == "true"    Flatten String    ${actual_text_value}    True
    ...    ELSE IF    "${multi_line_search_flag.lower()}" == "true" and "${remove_spaces}" == "false"    Flatten String    ${actual_text_value}
    ...    ELSE    Set Variable    ${actual_text_value}
    Run Keyword And Continue On Failure    Run Keyword If    '${verification_mode}' == '${EMPTY}'    Should Be Equal As Strings    ${actual_text_value}    ${expected_text_value}    ${optional_message}
    Run Keyword And Continue On Failure    Run Keyword If    '${verification_mode.lower()}' == 'contains'    Should Contain    ${actual_text_value}    ${expected_text_value}    ${optional_message}
    Log    Expected value: ${expected_text_value}
    Log    Actual value: ${actual_text_value}

Verify Field Is Empty
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}
    Win Activate    ${window_title}    ${EMPTY}
    ${field_value} =    Control Get Text    ${window_title}    ${EMPTY}    ${object_name}
    Run Keyword And Continue On Failure    Should Be True    '${field_value}' == '${EMPTY}'

Verify Multiple Object Name is Visible On Active Tab
    [Arguments]    ${obj_name}    ${obj_num}    ${default_control_counter}=True    ${field_instance}=${EMPTY}
    : FOR    ${actual_obj_list}    IN    @{obj_name}
    \    ${actual_obj_list}    Set Variable    ${actual_obj_list.strip()}
    \    Log    ${actual_obj_list}_${obj_num}
    \    Comment    ${object_name}    Set Variable    [NAME:${actual_obj_list}_${obj_num}]
    \    ${object_name}    Set Variable If    '${default_control_counter}' == 'True'    [NAME:${actual_obj_list}_${obj_num}]    [NAME:${actual_obj_list}]
    \    ${is_obj_visible}    Control Command    ${title_power_express}    ${EMPTY}    ${object_name}    IsVisible
    \    ...    ${EMPTY}
    \    Run Keyword If    ${is_obj_visible} == 1 and "${field_instance}" == "${EMPTY}"    Exit For Loop
    \    ...    ELSE IF    ${is_obj_visible} == 1 and "${field_instance}" == "${obj_num}"    Exit For Loop
    \    ...    ELSE    Continue For Loop
    [Return]    ${object_name}    ${is_obj_visible}

Verify Text Contains Expected Value
    [Arguments]    ${text}    ${expected_value}    ${reg_exp_flag}=false    ${multi_line_search_flag}=false    ${remove_spaces}=false
    Comment    ${expected_value}=    Strip String    ${expected_value}
    ${multi_line_search_flag}    Convert To Boolean    ${multi_line_search_flag}
    ${reg_exp_flag}    Convert To Boolean    ${reg_exp_flag}
    ${remove_spaces}    Convert To Boolean    ${remove_spaces}
    Log    Expected: ${expected_value}
    Log    Actual: ${text}
    ${line_containing_expected_value} =    Get Lines Containing String    ${text}    ${expected_value}
    Set Test Variable    ${line_containing_expected_value}
    ${flattened_text}    Run Keyword If    ${multi_line_search_flag} and ${remove_spaces}    Flatten String    ${text}    True
    ...    ELSE IF    "${multi_line_search_flag}" == "true" and "${remove_spaces}" == "false"    Flatten String    ${text}
    ...    ELSE    Set Variable    ${text}
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag}" == "false" and "${multi_line_search_flag}" == "false"    Should Contain    ${text}    ${expected_value}    "${expected_value}" is not found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag}" == "true" and "${multi_line_search_flag}" == "false"    Should Match RegExp    ${text}    ${expected_value}    "${expected_value}" is not found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag}" == "false" and "${multi_line_search_flag}" == "true"    Should Contain    ${flattened_text}    ${expected_value}    "${expected_value}" is not found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag}" == "true" and "${multi_line_search_flag}" == "true"    Should Match RegExp    ${flattened_text}    ${expected_value}    "${expected_value}" is not found.
    ...    FALSE

Verify Text Contains Expected Value X Times Only
    [Arguments]    ${text}    ${expected_value}    ${occurence}    ${multi_line_flag}=False    ${reg_exp_flag}=False    ${remove_spaces}=False
    Log    Expected: ${expected_value} (displayed ${occurence} time/s only)
    Log    Actual: ${text}
    ${multi_line_flag}    Convert To Boolean    ${multi_line_flag}
    ${reg_exp_flag}    Convert To Boolean    ${reg_exp_flag}
    ${remove_spaces}    Convert To Boolean    ${remove_spaces}
    ${flattened_text}    Run Keyword If    ${multi_line_flag} and ${remove_spaces}    Flatten String    ${text}    True    True
    ...    ELSE IF    ${multi_line_flag} and not ${remove_spaces}    Flatten String    ${text}
    Run Keyword And Continue On Failure    Run Keyword If    ${multi_line_flag} and not ${reg_exp_flag}    Should Contain X Times    ${flattened_text}    ${expected_value}    ${occurence}
    ...    "${expected_value}" is not found ${occurence} times.
    Run Keyword And Continue On Failure    Run Keyword If    not ${multi_line_flag} and not ${reg_exp_flag}    Should Contain X Times    ${text}    ${expected_value}    ${occurence}
    ...    "${expected_value}" is not found ${occurence} times.
    Run Keyword And Continue On Failure    Run Keyword If    ${reg_exp_flag}    Verify String Pattern Matches X Times    ${expected_value}    ${occurence}    ${remove_spaces}

Verify Text Does Not Contain Value
    [Arguments]    ${text}    ${expected_value}    ${reg_exp_flag}=false    ${multi_line_search_flag}=false    ${remove_spaces}=false    ${remove_gds_number}=False
    Log    Expected: ${expected_value}
    Log    Actual: ${text}
    ${line_containing_expected_value} =    Get Lines Containing String    ${text}    ${expected_value}
    Set Test Variable    ${line_containing_expected_value}
    Comment    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "false"    Should Not Contain    ${text}    ${expected_value}
    ...    "${expected_value}" is found.    FALSE
    Comment    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "true"    Should Not Match RegExp    ${text}    ${expected_value}
    ...    "${expected_value}" is found.    FALSE
    ${flattened_text}    Run Keyword If    "${multi_line_search_flag.lower()}" == "true" and "${reg_exp_flag.lower()}" == "true"    Flatten String    ${text}    True    ${remove_gds_number}
    ...    ELSE IF    "${multi_line_search_flag.lower()}" == "true" and "${reg_exp_flag.lower()}" == "false"    Flatten String    ${text}
    ...    ELSE    Set Variable    ${text}
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "false" and "${multi_line_search_flag.lower()}" == "false"    Should Not Contain    ${text}    ${expected_value}    "${expected_value}" is found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "true" and "${multi_line_search_flag.lower()}" == "false"    Should Not Match RegExp    ${text}    ${expected_value}    "${expected_value}" is found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "false" and "${multi_line_search_flag.lower()}" == "true"    Should Not Contain    ${flattened_text}    ${expected_value}    "${expected_value}" is found.
    ...    FALSE
    Run Keyword And Continue On Failure    Run Keyword If    "${reg_exp_flag.lower()}" == "true" and "${multi_line_search_flag.lower()}" == "true"    Should Not Match RegExp    ${flattened_text}    ${expected_value}    "${expected_value}" is found.
    ...    FALSE

Verify Tooltip Text Is Correct
    [Arguments]    ${control_id}    ${tooltip_text}
    Activate Power Express Window
    ${xpos}    ${ypos}    Get Control Coords    ${control_id}
    ${actual_tooltip_text}    Get Tooltip Text    ${xpos}    ${ypos}
    Run Keyword And Continue On Failure    Should Be Equal    ${tooltip_text}    ${actual_tooltip_text}    Expected tooltip "${tooltip_text}" should be equal to actual tooltip "${actual_tooltip_text}"    False

Verify Tooltip Text Is Correct Using Coords
    [Arguments]    ${xpos}    ${ypos}    ${tooltip_text}
    Activate Power Express Window
    ${actual_tooltip_text}    Get Tooltip Text    ${xpos}    ${ypos}
    Run Keyword And Continue On Failure    Should Be Equal    ${tooltip_text}    ${actual_tooltip_text}    Expected tooltip "${tooltip_text}" should be equal to actual tooltip "${actual_tooltip_text}"    False

Verify Whole String Contains Substring
    [Arguments]    ${whole_string}    ${sub_string}
    ${whole_string} =    Convert To String    ${whole_string}
    ${is_substring_found} =    Call Method    ${whole_string}    find    ${sub_string}
    Should Be True    ${is_substring_found} >= 0    msg="${sub_string}" should be in "${whole_string}"

Verify Window Does Not Exists
    [Arguments]    ${window_title}    ${window_text}=${EMPTY}
    ${does_window_exists} =    Win Exists    ${window_title}    ${window_text}
    Should Be True    ${does_window_exists} == 0    msg=${window_title} should not exists

Verify Window Exists
    [Arguments]    ${window_title}
    ${does_window_exists} =    Win Exists    ${window_title}    ${EMPTY}
    Should Be True    ${does_window_exists} == 1    msg=${window_title} should exists
    Set Test Variable    ${does_window_exists}

Verify Window Is Active
    [Arguments]    ${window_title}
    ${is_window_active} =    Win Active    ${window_title}    ${EMPTY}
    Should Be True    ${is_window_active} == 1    msg=${window_title} should be active

Wait Until Control Checkbox Is Ticked
    [Arguments]    ${checkbox_name}    ${window_title}=${title_power_express}    ${handle_popups}=false
    Wait Until Keyword Succeeds    60    2    Verify Checkbox Is Ticked    ${checkbox_name}

Wait Until Control Object Is Disabled
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}    ${handle_popups}=false
    Wait Until Keyword Succeeds    60    1    Verify Control Object Is Disabled    ${object_name}    ${window_title}

Wait Until Control Object Is Enabled
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}    ${handle_popups}=false
    Wait Until Keyword Succeeds    60    2    Verify Control Object Is Enabled    ${object_name}    ${window_title}    ${handle_popups}

Wait Until Control Object Is Not Visible
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}    ${handle_popups}=false
    Wait Until Keyword Succeeds    60    2    Verify Control Object Is Not Visible    ${object_name}    ${window_title}

Wait Until Control Object Is Visible
    [Arguments]    ${object_name}    ${window_title}=${title_power_express}    ${handle_popups}=false    ${max_timeout}=60    ${interval}=1
    Wait Until Keyword Succeeds    ${max_timeout}    ${interval}    Verify Control Object Is Visible    ${object_name}    ${window_title}    ${handle_popups}

Wait Until Window Does Not Exists
    [Arguments]    ${window_title}    ${timeout}=60    ${retry_interval}=3    ${window_text}=${EMPTY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Verify Window Does Not Exists    ${window_title}    ${window_text}

Wait Until Window Exists
    [Arguments]    ${window_title}    ${timeout}=60    ${retry_interval}=3
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Verify Window Exists    ${window_title}

Wait Until Window Is Active
    [Arguments]    ${window_title}    ${timeout}=60    ${retry_interval}=3
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Verify Window Is Active    ${window_title}

Wait Until Mouse Cursor Wait Is Completed
    [Arguments]    ${timeout}=120    ${retry_interval}=3
    : FOR    ${INDEX}    IN RANGE    ${timeout}
    \    ${wait_cursor_status}    Mouse Get Cursor
    \    Exit For Loop If    ${wait_cursor_status} != 15
    \    Sleep    ${retry_interval}

Get Value From Profile Information (Amadeus)
    [Arguments]    ${target_info}
    ${raw_sign_identities}    Get Data From GDS Screen    JGD    True
    ${raw_sign_identity_line}    Get Lines Matching Regexp    ${raw_sign_identities}    .*${target_info}.*
    ${raw_sign_identity_line}    Strip String    ${raw_sign_identity_line}
    ${profile_info}    ${profile_value}    Split String    ${raw_sign_identity_line}    -    1
    ${profile_info}    Strip String    ${profile_info}
    ${profile_value}    Strip String    ${profile_value}
    Log    ${profile_info}: ${profile_value}
    Set Suite Variable    ${profile_value}
    [Return]    ${profile_value}

Remove String From List
    [Arguments]    ${list}    ${string_to_be_removed}
    ${updated_list}    Evaluate    filter(lambda x: "${string_to_be_removed}" not in x, ${list})
    [Return]    ${updated_list}

Remove White Spaces
    [Arguments]    ${input_string}
    Set Test Variable    ${string_holder}    ${input_string}
    @{dummy_list}    Split String    ${string_holder}    ${SPACE}
    Set Test Variable    ${item_add}    ${EMPTY}
    : FOR    ${item}    IN    @{dummy_list}
    \    ${new_item}    Remove All Spaces    ${item}
    \    ${item_add}    Run Keyword If    "${new_item}" == "${EMPTY}"    Set Variable    ${item_add}
    \    ...    ELSE    Catenate    ${item_add}    ${new_item}
    ${output_string}    Set Variable    ${item_add.strip()}
    [Return]    ${output_string}

Wait Until Control Object Is Ready
    [Arguments]    ${object_name}    ${max_timeout}=60    ${interval}=1
    Wait Until Control Is Ready    ${object_name}

Determine Control Object Is Enable On Active Tab
    [Arguments]    ${obj_name}    ${default_control_counter}=True
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ${obj_name}
    ${point_of_obj}    Run Keyword If    '${is_visible}' == 'True'    Determine Multiple Object Name Based On Active Tab    ${obj_name}
    ${object_status}    Run Keyword If    '${is_visible}' == 'True'    Is Control Enabled    ${point_of_obj}
    ...    ELSE    Set Variable    False
    [Return]    ${object_status}

Take Screenshot
    Take Partial Screenshot    width=1028    height=769

Take Screenshot On Failure
    Run Keyword If Test Failed    Take Partial Screenshot    width=1028    height=769

Convert Month From MM to MMM
    [Arguments]    ${month_MM}
    &{dict_month}    Create Dictionary    01=JAN    02=FEB    03=MAR    04=APR    05=MAY
    ...    06=JUN    07=JUL    08=AUG    09=SEP    10=OCT    11=NOV
    ...    12=DEC
    ${month_MMM}    Get From Dictionary    ${dict_month}    ${month_MM}
    Set Suite Variable    ${month_MMM}
    [Return]    ${month_MMM}
