*** Settings ***
Resource          ../common/core.robot
Variables         ../variables/pspt_and_visa_control_objects.py

*** Keywords ***
Add And Select New Passport
    [Arguments]    ${row_number}    ${doc_type}    ${nationality}    ${doc_number}    ${is_doc_valid}
    Click Control Button    [NAME:btnAddPassport]
    ${row_number}    Evaluate    ${row_number}-1
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboDocumentType${row_number}]
    Send    ${doc_type}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboNationality${row_number}]
    Send    ${nationality}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ctxtPassportNumber${row_number}]
    Send    ${doc_number}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboPassportValid${row_number}]
    Send    ${is_doc_valid}
    Set Expiration Date For Newly Added Passport    [NAME:cdtpExpiryDate${row_number}]
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:chkSelectPassport${row_number}]

Click Check Visa Requirements
    Wait Until Control Is Ready    Check Visa Requirements
    Click Button Control    Check Visa Requirements
    Wait Until Mouse Cursor Wait Is Completed
    Sleep    5
    ${is_visible}    Is Control Visible    [NAME:txtPassportVisaInfo]
    Run Keyword If    ${is_visible} == False    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    Wait Until Mouse Cursor Wait Is Completed
    ${status_striptext}    Get Status Strip Text
    : FOR    ${INDEX}    IN RANGE    5
    \    ${is_timatic_ws_unavailable}    Run Keyword And Return Status    Should Be Equal    Timatic web service unavailable, contact your local support team so they can raise an SM7 ticket    ${status_striptext}
    \    Run Keyword If    ${is_timatic_ws_unavailable} == True    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    \    Exit For Loop If    ${is_timatic_ws_unavailable} == False
    \    Sleep    5

Click Check Visa Requirements No ESTA
    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    Sleep    2
    ${status_striptext}    Get Status Strip Text
    : FOR    ${INDEX}    IN RANGE    5
    \    ${is_timatic_ws_unavailable}    Run Keyword And Return Status    Should Be Equal    Timatic web service unavailable, contact your local support team so they can raise an SM7 ticket    ${status_striptext}
    \    Run Keyword If    ${is_timatic_ws_unavailable} == True    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    \    Exit For Loop If    ${is_timatic_ws_unavailable} == False
    \    Sleep    5
    Wait Until Control Object Is Visible    [NAME:PassportVisaInfo]
    Wait Until Control Object Is Visible    [NAME:txtPassportVisaInfo]

Click Check Visa Requirements With Timestamp
    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    Sleep    2
    ${status_striptext}    Get Status Strip Text
    : FOR    ${INDEX}    IN RANGE    5
    \    ${is_timatic_ws_unavailable}    Run Keyword And Return Status    Should Be Equal    Timatic web service unavailable, contact your local support team so they can raise an SM7 ticket    ${status_striptext}
    \    Run Keyword If    ${is_timatic_ws_unavailable} == True    Click Button Control    cmdRefreshTimatic    use_automation_id=True
    \    Exit For Loop If    ${is_timatic_ws_unavailable} == False
    \    Sleep    5
    Wait Until Control Object Is Visible    [NAME:grpESTA]
    ${exp_overalltransaction_check_visa_time}    Get Time
    Set Test Variable    ${exp_overalltransaction_check_visa_time}

Delete Passport
    [Arguments]    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:btnRemovePassport${row_number}]

Get Countries Visited
    Wait Until Control Object Is Visible    [NAME:grpVisa]
    @{countries_visited} =    Create List
    : FOR    ${INDEX}    IN RANGE    0    11
    \    ${country_visited} =    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtCountries${INDEX}]
    \    Append To List    ${countries_visited}    ${country_visited}
    \    Exit For Loop If    "${country_visited}" == "${EMPTY}"
    Set Test Variable    ${countries_visited}
    [Return]    ${countries_visited}

Get Country Visited
    [Arguments]    ${row_number}=0
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtCountries${row_number}    False
    ${country_visited}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${country_visited_${row_number}}    ${country_visited}

Get Doc Number
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtPassportNumber${row_number}    False
    ${passport_number}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${passport_number_${row_number}}    ${passport_number}

Get Document Type
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboDocumentType${row_number}    False
    ${document_type}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${document_type_${row_number}}    ${document_type}

Get Expiry Date
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cdtpExpiryDate${row_number}    False
    ${expiry_date}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${expiry_date_${row_number}}    ${expiry_date}

Get Field Index Using Country Name
    [Arguments]    ${country}
    ${index}    Set Variable    ${0}
    : FOR    ${INDEX}    IN RANGE    20
    \    ${text_value}    Get Control Text Value    [NAME:ctxtCountries${INDEX}]
    \    Return From Keyword If    "${text_value}" == "${country}"    ${index}
    \    Exit For Loop If    "${text_value}" == "${country}"
    \    ${index}    Set Variable    ${index + 1}
    [Return]    ${index}

Get Index Of Country In Visa Requirements Pane
    [Arguments]    ${country}
    : FOR    ${i}    IN RANGE    99
    \    ${text_value}    Get Control Text Value    [NAME:ctxtCountries${i}]
    \    ${index}    Set Variable If    '${country}'=='${text_value}'    ${i}
    \    Exit For Loop If    '${country}'=='${text_value}'
    [Return]    ${i}

Get Is Doc Valid
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboPassportValid${row_number}    False
    ${passport_valid}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${passport_valid_${row_number}}    ${passport_valid}

Get Journey Type
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboJourneyType${row_number}    False
    ${journey_type}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${journey_type_${row_number}}    ${journey_type}

Get Journey Type Text Value
    [Arguments]    ${country}
    ${i}    Get Index Of Country In Visa Requirements Pane    ${country}
    ${journey_type_value}    Get Control Text Value    [NAME:ccboJourneyType${i}]
    Set Test Variable    ${journey_type_value}

Get Nationality/Citizenship
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboNationality${row_number}    False
    ${nationality}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${nationality_${row_number}}    ${nationality}

Get Passport & Visa Info Panel Text
    Click Control Button    [NAME:PassportVisaInfo]
    Send    {HOME}
    Sleep    1
    Send    {UP 100}
    Sleep    1
    Send    {SHIFTDOWN}{DOWN 100}{SHIFTUP}
    Sleep    1
    Send    {CTRLDOWN}C{CTRLUP}
    Sleep    1
    ${data_clipboard}    Get Data From Clipboard
    Set Test Variable    ${passport_and_visa_info_text}    ${data_clipboard}

Get Selected Use Document
    : FOR    ${i}    IN RANGE    99
    \    ${index_status}    Get Radio Button Status    [NAME:chkSelectPassport${i}]
    \    ${selected_index}    Set Variable If    ${index_status}    ${i}
    \    Exit For Loop If    ${index_status}
    [Return]    ${selected_index}

Get Transit Checkbox Status
    [Arguments]    ${row_number}
    ${transit_checkbox_status}    Get Checkbox Status    [NAME:cchkIsTransit${row_number}]
    ${transit_status}    Set Variable If    ${transit_checkbox_status}    Transit    Destination
    Set Test Variable    ${transit_status}

Get Travel Document Details
    [Arguments]    ${row_number}=1
    Get Document Type    ${row_number}
    Get Nationality/Citizenship    ${row_number}
    Get Doc Number    ${row_number}
    Get Expiry Date    ${row_number}
    Get Is Doc Valid    ${row_number}

Get Visa Required
    [Arguments]    ${row_number}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboVisa${row_number}    False
    ${visa_required}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${visa_required_${row_number}}    ${visa_required}

Get Visa Required Value
    [Arguments]    ${country}
    : FOR    ${i}    IN RANGE    99
    \    ${text_value}    Get Control Text Value    [NAME:ctxtCountries${i}]
    \    ${index}    Set Variable If    '${country}'=='${text_value}'    ${i}
    \    Exit For Loop If    '${country}'=='${text_value}'
    Untick Checkbox    [NAME:cchkIsTransit${index}]

Get Visa Requirements
    [Arguments]    ${row_number}
    Get Country Visited    ${row_number}
    Get Visa Required    ${row_number}
    Get Journey Type    ${row_number}

Get Visa Status Row Number
    [Arguments]    ${country_visited}    ${visa_requirement}    ${apply_search_pattern}=False
    : FOR    ${visareq_row}    IN RANGE    10
    \    ${actual_country_visited}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtCountries${visareq_row}]
    \    ${actual_visa_requirement}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ccboVisa${visareq_row}]
    \    ${is_country_visited_equal}    Run Keyword and Return Status    Should Be Equal As Strings    ${country_visited}    ${actual_country_visited}
    \    ${is_visa_requirement_equal}    Run Keyword If    "${apply_search_pattern}"=="True"    Run Keyword And Return Status    Should Match Regexp    ${actual_visa_requirement}
    \    ...    ${visa_requirement}\\s
    \    ...    ELSE IF    "${apply_search_pattern}"=="False"    Run Keyword And Return Status    Should Be Equal As Strings    ${visa_requirement}
    \    ...    ${actual_visa_requirement}
    \    ${visa_status_row}    Run Keyword And Return If    ${is_country_visited_equal} == True and ${is_country_visited_equal} == True    Set variable    ${visareq_row}
    \    Comment    Run Keyword If    ${is_visa_requirement_equal} == True and ${is_visa_requirement_equal} == True    Exit For Loop
    \    ...    ELSE IF    ${is_country_visited_equal} == False and ${is_country_visited_equal} == False and ${visareq_row} == 9    Fail    Cannot find the countries visited: ${country_visited}
    \    Run Keyword If    ${is_visa_requirement_equal} == True and ${is_visa_requirement_equal} == True    Exit For Loop
    \    ...    ELSE    Run Keyword And Continue On Failure    Run Keyword If    ${is_country_visited_equal} == False and ${is_country_visited_equal} == False and ${visareq_row} == 9    Fail
    \    ...    Cannot find the countries visited: ${country_visited}
    [Return]    ${visa_status_row}

Populate Pspt & Visa With Values
    [Arguments]    ${row_number}    ${doc_type}    ${nationality}    ${doc_number}    ${is_doc_valid}
    ${row_number}    Evaluate    ${row_number}-1
    Wait Until Control Object Is Visible    [NAME:ccboDocumentType${row_number}]
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboDocumentType${row_number}]
    Send    ${doc_type}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboNationality${row_number}]
    Send    ${nationality}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ctxtPassportNumber${row_number}]
    Send    ${doc_number}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboPassportValid${row_number}]
    Send    ${is_doc_valid}
    Set Expiration Date For Newly Added Passport    [NAME:cdtpExpiryDate${row_number}]
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:chkSelectPassport${row_number}]

Populate Pspt And Visa With Values
    [Arguments]    ${document_needed}    ${nationality_needed}    ${passport_number}    ${expiry_date}    ${doc_validity}
    Select Value From Dropdown List    ${combo_documenttype_0}    ${document_needed}
    Select Value From Dropdown List    ${combo_nationality_citizenship}    ${nationality_needed}
    Send Control Text Value    ${text_docnumber0}    ${passport_number}
    Send    {TAB}
    Select Expiry Date X Months    \    \    ${expiry_date}
    Click Control Button    ${combo_docvalid_0}
    Send Control Text Value    ${combo_docvalid_0}    ${doc_validity}
    Comment    Select Value From Dropdown List    ${combo_docvalid_0}    ${doc_validity}

Populate Pspt and Visa Panel With Default Values
    Tick Checkbox    ${check_box_domestic_trip}

Populate Visa Group Details With Values
    [Arguments]    ${visa_required}    ${visa_trip_type}
    Click Control Button    ${combo_visa_required_0}
    Set Control Text Value    ${combo_visa_required_0}    ${visa_required}
    Click Control Button    ${combo_journey_type_0}
    Set Control Text Value    ${combo_journey_type_0}    ${visa_trip_type}

Select Country Of Residence
    [Arguments]    ${country_of_residence}
    Set Control Text Value    [NAME:ccboCountryResidence]    ${country_of_residence}
    Send    {TAB}
    ${current_value}    Get Control Text Value    [NAME:ccboCountryResidence]
    Should Be Equal    ${current_value}    ${country_of_residence}

Select Expiry Date X Months
    [Arguments]    ${number_of_months}=24    ${row_number}=0    ${expiry_date}=${EMPTY}
    ${expiry_date}    Run Keyword if    "${expiry_date}" == "${EMPTY}"    Set Departure Date X Months From Now In Syex Format    ${number_of_months}
    ...    ELSE    Set Variable    ${expiry_date}
    @{expiry_date_array}    Split String    ${expiry_date}    /
    Set Test Variable    ${expiry_month}    ${expiry_date_array[0]}
    Set Test Variable    ${expiry_day}    ${expiry_date_array[1]}
    Set Test Variable    ${expiry_year}    ${expiry_date_array[2]}
    ${row_number}    Set Variable If    "${row_number}" == "${EMPTY}"    0    ${row_number}
    Set Suite Variable    ${expiry_date}
    Click Control Button    [NAME:cdtpExpiryDate${row_number}]
    Send    ${expiry_year}    1
    Send    {LEFT}
    Send    ${expiry_day}    1
    Send    {LEFT}
    Send    ${expiry_month}    1
    Click Control Button    [NAME:cboNativeEntry]

Select Is Doc Valid
    [Arguments]    ${is_doc_valid}    ${row_number}=0
    Set Control Text Value    [NAME:ccboPassportValid${row_number}]    ${is_doc_valid}

Select Nationality/Citizenship
    [Arguments]    ${nationality}    ${row_number}=0
    Select Value From Combobox    [NAME:ccboNationality${row_number}]    ${nationality}

Select Visa Requirement
    [Arguments]    ${visa_required}    ${row_number}=0
    Set Control Text Value    [NAME:ccboVisa${row_number}]    ${visa_required}

Set Document Number
    [Arguments]    ${doc_number}    ${row_number}=0
    Set Control Text Value    [NAME:ctxtPassportNumber${row_number}]    ${doc_number}

Set Expiration Date For Newly Added Passport
    [Arguments]    ${expiry_date_field}    ${number_months}=24    ${number_of_days}=0
    ${expiry_date}    Generate Date X Months From Now    ${number_months}    ${number_of_days}    %#m/%#d/%Y
    @{expiry_date_array}    Split String    ${expiry_date}    /
    Set Test Variable    ${expiry_month}    ${expiry_date_array[0]}
    Set Test Variable    ${expiry_day}    ${expiry_date_array[1]}
    Set Test Variable    ${expiry_year}    ${expiry_date_array[2]}
    Set Suite Variable    ${expiry_date}
    Control Click    ${title_power_express}    ${EMPTY}    ${expiry_date_field}
    Send    ${expiry_year}    1
    Send    {LEFT}
    Send    ${expiry_day}    1
    Send    {LEFT}
    Send    ${expiry_month}    1
    Sleep    0.5
    Send    {TAB}
    Sleep    0.5

Tick Domestic Trip
    Tick Checkbox    ${check_box_domestic_trip}

Tick Transit Checkbox
    [Arguments]    @{countries}
    : FOR    ${country}    IN    @{countries}
    \    ${index}    Get Field Index Using Country Name    ${country}
    \    Tick Checkbox    [NAME:cchkIsTransit${index}]

Tick Use Document
    [Arguments]    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Click Control Button    [NAME:chkSelectPassport${row_number}]

Untick Domestic Trip
    Untick Checkbox    ${check_box_domestic_trip}

Untick Transit Checkbox
    [Arguments]    @{countries}
    : FOR    ${country}    IN    @{countries}
    \    ${index}    Get Field Index Using Country Name    ${country}
    \    Untick Checkbox    [NAME:cchkIsTransit${index}]
