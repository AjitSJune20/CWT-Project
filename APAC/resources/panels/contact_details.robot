*** Settings ***
Documentation     This resource file covers all reusable actions for Air Fare Related test cases
Variables         ../variables/contact_details_control_objects.py
Resource          id_traveller.robot

*** Keywords ***
Click Tab In Contact Details
    [Arguments]    ${tab_name}
    Comment    Mouse Click    LEFT    585    65
    Comment    Click Control Button    [NAME:ContactDetailsTabControl]
    Activate Power Express Window
    Select Tab Control    ${tab_name}

Handle Incomplete Contact Details
    [Arguments]    ${client_account}=${EMPTY}
    ${client_account_value} =    Get Control Text Value    ${combobox_account_number}    ${title_power_express}
    ${does_client_account_contains_preset_value} =    Run Keyword And Return Status    Should Match Regexp    ${client_account_value}    Choose|Ausw|Select
    Run Keyword If    ${does_client_account_contains_preset_value} == True and '${client_account}' =='${EMPTY}'    Select Client Account Using Default Value
    ...    ELSE    Select Client Account Value    ${client_account}
    ${telephone_value} =    Get Control Text Value    ${textbox_telephone}    ${title_power_express}
    ${mobile_value} =    Get Control Text Value    ${textbox_mobile}    ${title_power_express}
    ${telephone_length} =    Get Length    ${telephone_value}
    ${mobile_length} =    Get Length    ${mobile_value}
    ${is_telephone_format_correct} =    Run Keyword And Return Status    Should Match Regexp    ${telephone_value}    \\d*-\\d*-\\d.*
    ${is_mobile_format_correct} =    Run Keyword And Return Status    Should Match Regexp    ${mobile_value}    \\d*-\\d*-\\d.*
    Run Keyword If    ${telephone_length} == 0 and ${mobile_length} == 0    Run Keywords    Set Control Text Value    ${textbox_telephone}    11-22-33    ${title_power_express}
    ...    AND    Send    {TAB}
    Run Keyword If    ${is_telephone_format_correct} == False and ${telephone_length} > 0    Run Keywords    Set Control Text Value    ${textbox_telephone}    ${telephone_value}-123    ${title_power_express}
    ...    AND    Send    {TAB}
    Run Keyword If    ${is_mobile_format_correct} == False and ${mobile_length} > 0    Run Keywords    Set Control Text Value    ${textbox_mobile}    ${mobile_value}-123    ${title_power_express}
    ...    AND    Send    {TAB}
    ${traveller_checkbox_status} =    Get Checkbox Status    ${checkbox_traveller}
    ${arranger_checkbox_status} =    Get Checkbox Status    ${checkbox_arranger}
    Run Keyword Unless    ${traveller_checkbox_status} == True    Control Click    ${title_power_express}    ${EMPTY}    ${checkbox_traveller}
    Run Keyword Unless    ${arranger_checkbox_status} == True    Control Click    ${title_power_express}    ${EMPTY}    ${checkbox_arranger}

Populate Caller Tab
    [Arguments]    ${firstname}    ${lastname}    ${area_code}    ${phone_number}    ${email}
    Set First name In Contact    ${firstname}
    Set Last Name In Contact    ${lastname}
    Set Area Code    ${area_code}
    Set Phone Number    ${phone_number}
    Set Email Address    ${email}

Select Client Account
    [Arguments]    ${client_account_value}
    Select Value From Combobox    ${combobox_account_number}    ${client_account_value}

Select Client Account Using Default Value
    Click Control Button    ${combobox_account_number}    ${title_power_express}
    Control Focus    ${title_power_express}    ${EMPTY}    ${combobox_account_number}
    Send    {DOWN}    0
    Sleep    0.5
    Send    {ENTER}

Select Client Account Value
    [Arguments]    ${client_account}
    Select Value From Dropdown List    ${combobox_account_number}    ${client_account}
    ${client_account_number}=    Fetch From Left    ${client_account}    ¦
    Set Suite Variable    ${client_account_number}

Select Linked Contact
    Click Panel    ID Traveller
    Send    {RIGHT}{SPACE}

Select Trip Type Value
    [Arguments]    ${trip_type}
    Select Value From Dropdown List    ${combobox_trip_type}    ${trip_type}

Set Area Code
    [Arguments]    ${area_code}=12
    Set Control Text Value    [NAME:ctxtAreaCode]    ${area_code}
    Send    {TAB}

Set Date Of Birth
    [Arguments]    ${birthdate}
    @{birthdate}    Split String    ${birthdate}    /
    Click Control Button    [NAME:dtpDate]    ${title_power_express}
    Send    ${birthdate[2]}    1
    Send    {LEFT}
    Send    ${birthdate[0]}    1
    Send    {LEFT}
    Send    ${birthdate[1]}    1
    Sleep    1
    Send    {TAB}
    Sleep    1

Set Email Address
    [Arguments]    ${email}=automation@carlsonwagonlit.com
    Set Control Text Value    [NAME:ctxtEmail]    ${email}

Set First name In Contact
    [Arguments]    ${firstname}
    Set Control Text Value    [NAME:ctxtFirstName]    ${firstname}
    Send    {TAB}

Set Last Name In Contact
    [Arguments]    ${lastname}
    Set Control Text Value    [NAME:ctxtLastName]    ${lastname}
    Send    {TAB}

Set Mobile Number
    [Arguments]    ${mobile_value}=12-23-34
    Set Control Text Value    ${textbox_mobile}    ${mobile_value}    ${title_power_express}
    Send    {TAB}

Set Phone Number
    [Arguments]    ${phone_number}=34567
    Set Control Text Value    [NAME:ctxtPhoneNumber]    ${phone_number}
    Send    {TAB}

Set Telephone
    [Arguments]    ${phone_value}=12-23-34
    Set Control Text Value    ${textbox_telephone}    ${phone_value}    ${title_power_express}
    Send    {TAB}

Tick Contact Checkbox
    Tick Checkbox    ${checkbox_arranger}

Tick Sponsor Checkbox
    Tick Checkbox    ${checkbox_sponsor}

Tick Traveller Checkbox
    Tick Checkbox    ${checkbox_traveller}

Untick Contact Checkbox
    Untick Checkbox    ${checkbox_arranger}

Untick Sponsor Checkbox
    Untick Checkbox    ${checkbox_sponsor}

Untick Traveller Checkbox
    Untick Checkbox    ${checkbox_traveller}

Get Email Address From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_email}    Get Control Text Current Value    [NAME:CtxtEmail]
    [Return]    ${actual_email}

Get Client Account Number From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_client_account}    Get Control Text Current Value    [NAME:ccboAccountNumber]
    [Return]    ${actual_client_account}

Get First Name From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_firstname}    Get Control Text Current Value    [NAME:CtxtFirstName]
    [Return]    ${actual_firstname}

Get Last Name From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_lastname}    Get Control Text Current Value    [NAME:CtxtLastName]
    [Return]    ${actual_lastname}

Get Mobile From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_mobile}    Get Control Text Current Value    [NAME:CtxtMobile]
    [Return]    ${actual_mobile}

Get PCC/CompanyProfile/TravellerProfile From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_pcc_company_traveller_profile}    Get Control Text Current Value    [NAME:CcboProfile]
    [Return]    ${actual_pcc_company_traveller_profile}

Get Telephone From Contact Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_telephone}    Get Control Text Current Value    [NAME:CtxtTelephone]
    [Return]    ${actual_telephone}

Get First Name From Caller Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_firstname}    Get Control Text Current Value    [NAME:ctxtFirstName]
    [Return]    ${actual_firstname}

Get Last Name From Caller Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_lastname}    Get Control Text Current Value    [NAME:ctxtLastName]
    [Return]    ${actual_lastname}

Get Telephone From Caller Tab
    [Arguments]    ${tab_name}
    Click Tab In Contact Details    ${tab_name}
    ${actual_telephone}    Get Control Text Current Value    [NAME:ctxtPhoneNumber]
    [Return]    ${actual_telephone}

Get Trip Type From Contact Tab
    Click Tab In Contact Details    ${tab_name}
    ${actual_trip_type}    Get Control Text Current Value    ${cbo_onetime_trip_type}

Add One Time Contact
    [Arguments]    ${caller_firstname}    ${caller_lastname}    ${caller_area_code}    ${caller_phone_number}    ${caller_e-mail}
    Click Create One Time Contact
    Click Tab In Contact Details    Caller
    Set First name In Contact    ${caller_firstname}
    Set Last Name In Contact    ${caller_lastname}
    Set Control Text Value    [NAME:ctxtAreaCode]    ${caller_area_code}
    Set Control Text Value    [NAME:ctxtPhoneNumber]    ${caller_phone_number}
    Set Email Address    ${caller_e-mail}
