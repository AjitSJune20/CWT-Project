*** Settings ***
Variables         ../variables/apis_sfpd_control_objects.py
Resource          ../common/core.robot

*** Keywords ***
Populate APIS/SFPD Address
    [Arguments]    ${street}    ${city}    ${country}    ${state_code}    ${zip_code}
    Untick Checkbox    [NAME:chkAddress]
    Click Control Button    ${radio_address_Home}
    Send Control Text Value    ${edit_address_street}    ${street}
    Send Control Text Value    ${edit_address_city}    ${city}
    Click Control Button    ${combo_address_country}
    Send Control Text Value    ${combo_address_country}    ${country}
    Click Control Button    ${combo_address_statecode}
    Select Dropdown Value    ${combo_address_statecode}    ${state_code}
    Send Control Text Value    ${edit_address_zipcode}    ${zip_code}

Populate APIS/SFPD Panel With Default Values
    ${chkbx_notknown_status}    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_notknown}    IsVisible    ${EMPTY}
    ${chkbx_notknown_status2}    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_notknown2}    IsVisible    ${EMPTY}
    ${chkbx_notknown_status3}    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_notknown3}    IsVisible    ${EMPTY}
    ${chkbx_notknown_status4}    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_notknown4}    IsVisible    ${EMPTY}
    Run Keyword If    ${chkbx_notknown_status} == 1    Tick Checkbox    ${check_box_notknown}
    Run Keyword If    ${chkbx_notknown_status2} == 1    Tick Checkbox    ${check_box_notknown2}
    Run Keyword If    ${chkbx_notknown_status3} == 1    Tick Checkbox    ${check_box_notknown3}
    Run Keyword If    ${chkbx_notknown_status4} == 1    Tick Checkbox    ${check_box_notknown4}
    ${is_gender_present}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:ccboGenderSFPD]    IsVisible    ${EMPTY}
    ${is_gender_enabled}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:ccboGenderSFPD]    IsEnabled    ${EMPTY}
    ${mandatory_state}    Run Keyword If    ${is_gender_present} == 1 and ${is_gender_enabled} == 1    Get Control Field Mandatory State    [NAME:ccboGenderSFPD]
    Run Keyword If    "${mandatory_state}" == "Mandatory" and ${is_gender_present} == 1 and ${is_gender_enabled} == 1    Select Value From Dropdown List    [NAME:ccboGenderSFPD]    Male

Populate APIS Other Information And Visa Details
    [Arguments]    ${place_of_birth}    ${country_of_residence}    ${city_of_residence}    ${country_of_visa}    ${place_of_issue}    ${document_number}
    ...    ${issue_date}
    Set Control Text Value    [NAME:ctxtPlaceOfBirth]    ${place_of_birth}
    Select Dropdown Value    [NAME:ccboCountryOfResidence]    ${country_of_residence}
    Set Control Text Value    [NAME:ctxtCityOfResidence]    ${city_of_residence}
    Select Dropdown Value    [NAME:ccboVisaCountry]    ${country_of_visa}
    Set Control Text Value    [NAME:ctxtVisaPlaceOfIssue]    ${place_of_issue}
    Set Control Text Value    [NAME:ctxtVisaDocumentNumber]    ${document_number}
    #DD/MM/YYYY
    @{issue_date}    Split String    ${issue_date}    /
    Click Panel    APIS/SFPD
    Click Control Button    [NAME:cdtpVisaIssueDate]    ${title_power_express}
    Send    ${issue_date[2]}    1
    Send    {LEFT}
    Send    ${issue_date[0]}    1
    Send    {LEFT}
    Send    ${issue_date[1]}    1
    Click Panel    APIS/SFPD

Populate SFPD Gender
    [Arguments]    ${gender_sfpd}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboGenderSFPD]
    Control Set Text    ${title_power_express}    ${EMPTY}    [NAME:ccboGenderSFPD]    ${gender_sfpd}
    Comment    ${chkbx_notknown_status2}    Get Checkbox Status    ${check_box_notknown2}
    Comment    Run Keyword If    "${chkbx_notknown_status2}" == "False"    Control Click    ${title_power_express}    ${EMPTY}    ${check_box_notknown2}
    Comment    ${chkbx_notknown_status4}    Get Checkbox Status    ${check_box_notknown4}
    Comment    Run Keyword If    "${chkbx_notknown_status4}" == "False"    Control Click    ${title_power_express}    ${EMPTY}    ${check_box_notknown4}
    Tick Checkbox    ${check_box_notknown2}
    Tick Checkbox    ${check_box_notknown4}

Select Destination Radio Button
    Click Control Button    [NAME:cradDestination]

Set APIS SFPD Expiration Date
    [Arguments]    ${date_needed}
    Click Control Button    ${edit_last_name_sfpd}
    Send    {TAB}
    Send    ${date_needed}

Set APIS/SFPD Date Of Birth
    [Arguments]    ${dob_date_field}    ${dateofbirth}
    @{dob_date_array}    Split String    ${dateofbirth}    /
    Set Test Variable    ${dob_month}    ${dob_date_array[0]}
    Set Test Variable    ${dob_day}    ${dob_date_array[1]}
    Set Test Variable    ${dob_year}    ${dob_date_array[2]}
    Comment    Set Suite Variable    ${dob_date}
    Control Click    ${title_power_express}    ${EMPTY}    ${dob_date_field}
    Send    ${dob_year}    1
    Send    {LEFT}
    Send    ${dob_day}    1
    Send    {LEFT}
    Send    ${dob_month}    1
    Sleep    0.5
    Send    {TAB}
    Sleep    0.5

Tick Address Not Unknown
    Click Control Button    ${check_box_notknown4}

Tick Not Known
    [Arguments]    ${tick_value}
    Run Keyword If    '${tick_value.lower()}' == 'tick'    Click Control Button    ${check_box_notknown}
    ...    ELSE    No Operation

Tick SFPD Details Unknown
    Comment    ${chkbx_notknown_status2}    Get Checkbox Status    ${check_box_notknown2}
    Comment    Run Keyword If    "${chkbx_notknown_status2}" == "False"    Control Click    ${title_power_express}    ${EMPTY}    ${check_box_notknown2}
    Tick Checkbox    ${check_box_notknown2}

UnTick SFPD Details Unknown
    Untick Checkbox    [NAME:chkSFPD]
