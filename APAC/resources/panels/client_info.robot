*** Settings ***
Resource          ../common/core.robot
Variables         ../variables/client_info_control_objects.py

*** Keywords ***
Click Add Form Of Payment
    Click Control Button    [NAME:cmdAddFOP]

Click Clear Form Of Payment
    Click Control Button    [NAME:cmdClearFOP]

Click Edit Form Of Payment
    Click Control Button    [NAME:cmdEditFormOfPayment]

Get Form Of Payment Value
    ${fop_value} =    Get Control Text Value    ${combo_form_of_payment}    ${title_power_express}
    [Return]    ${fop_value}

Get Service Option Values
    ${so_tab}    Set Variable If    "${locale}" == "fr-FR"    Options de Services    Service Options
    Select Tab Control    ${so_tab}
    ${service_option_values}    Get Service Option Items
    Set Test Variable    ${service_option_values}
    Log    ${service_option_values}
    [Return]    ${service_option_values}

Manually Set Value In Form Of Payment
    [Arguments]    ${str_card_type}    ${str_card_number}    ${str_exp_date}
    Click Control Button    ${button_edit_form_of_payment}
    Wait Until Control Object Is Visible    [NAME:tlpFormOfPayment]
    Select Value From Dropdown List    [NAME:ccboCardType]    ${str_card_type}
    Set Control Text Value    ${ctext_card_number}    ${str_card_number}
    Send Control Text Value    ${cmtext_exp_date}    ${str_exp_date}
    Click Control Button    ${button_add_fop}
    #Click Control Button    [NAME:cboNativeEntry]
    Set Suite Variable    ${str_card_type}
    Set Suite Variable    ${str_card_number}
    Set Suite Variable    ${str_exp_date}
    ${card_number}    Get Substring    ${str_card_number}    \    -4
    ${card_digits}    Get Substring    ${str_card_number}    -4
    ${card_length}    Get Length    ${card_number}
    Run Keyword If    "${card_length}" == "11"    Set Suite Variable    ${str_card_number2}    XXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "12"    Set Suite Variable    ${str_card_number2}    XXXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "10"    Set Suite Variable    ${str_card_number2}    XXXXXXXXXX${card_digits}
    Wait Until Control Object Is Visible    [NAME:tlpAllClientInformation]

Populate Client Info Panel With Default Values
    ${is_not_known_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_not_known_a_time_of_booking}    IsVisible    ${EMPTY}
    Run Keyword If    ${is_not_known_present} == 1    Click Control Button    ${check_box_not_known_a_time_of_booking}
    ...    ELSE    Manually Set Value In Form Of Payment    VI    4111111111111111    1221
    Click GDS Screen Tab
    Click Control Button    [NAME:cboNativeEntry]

Select Card Type
    [Arguments]    ${card_type}
    Select Value From Dropdown List    [NAME:ccboCardType]    ${card_type}

Select Form Of Payment
    [Arguments]    ${fop_value}    ${tab}={TAB}
    ${is_not_known_present}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:chkNotKnown]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_not_known_present} == 1    Untick Not Known At Time Of Booking For Form Of Payment
    Click Control Button    ${combo_form_of_payment}    ${title_power_express}
    Select Value From Dropdown List    [NAME:cboFOPs]    ${fop_value}
    Run Keyword If    "${tab}" != "${EMPTY}"    Control Focus    ${title_power_express}    ${EMPTY}    ${cbo_gdscommandline}
    Set Suite Variable    ${str_card_type}    ${fop_value}

Set Card Number
    [Arguments]    ${card_number}
    Set Control Text Value    [NAME:ctxtCardNumber]    ${card_number}

Set Cardholder Name
    [Arguments]    ${cardholder_name}
    Set Control Text Value    [NAME:ctxtCardHolderName]    ${cardholder_name}

Set Expiry Date
    [Arguments]    ${exp_month}    ${exp_year}
    Comment    Set Control Text Value    [NAME:cmtxtExpDate]    ${expiry_date}
    Control Send    ${title_power_express}    ${EMPTY}    [NAME:cmtxtExpDate]    ${exp_month}${exp_year}

Tick Not Known At Time Of Booking For Form Of Payment
    Wait Until Control Object Is Visible    ${check_box_not_known_a_time_of_booking}
    ${tick_not_known}    Set Variable If    "${locale}" == "de-DE"    Bei Buchung nicht bekannt    "${locale}" == "fr-FR"    Inconnu au moment de la réservation    Not known at time of booking
    Tick Checkbox    ${tick_not_known}

Untick Not Known At Time Of Booking For Form Of Payment
    Wait Until Control Object Is Visible    ${check_box_not_known_a_time_of_booking}
    ${tick_not_known}    Set Variable If    "${locale}" == "de-DE"    Bei Buchung nicht bekannt    "${locale}" == "fr-FR"    Inconnu au moment de la réservation    Not known at time of booking
    Untick Checkbox    ${tick_not_known}

Click Mask Icon to Unmask FOP Card On Client Info
    ${fop_value}    Get Form Of Payment Value
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value}    *
    Run Keyword If    "${status}" == "True"    Click Mask Icon On Client Info Panel

Click Mask Icon to Mask FOP Card On Client Info
    ${fop_value}    Get Form Of Payment Value
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value}    *
    Run Keyword If    "${status}" == "False"    Click Mask Icon On Client Info Panel

Click Mask Icon On Client Info Panel
    Click Control Button    [NAME:maskIcon]

Get Service Option Item Value
    [Arguments]    ${service_option_name}
    ${so_tab}    Set Variable If    "${locale}" == "fr-FR"    Options de Services    Service Options
    Select Tab Control    ${so_tab}
    @{service_option_values}    Get Service Option Items
    ${service_option_values_dict}    Evaluate    {k:v for k,v in ${service_option_values}}
    ${is_so_configured}    Run Keyword And Return Status    Dictionary Should Contain Key    ${service_option_values_dict}    ${service_option_name}
    ${service_option_value}    Run Keyword If    ${is_so_configured} == True    Get From Dictionary    ${service_option_values_dict}    ${service_option_name}
    ...    ELSE    Set Variable    None
    Set Suite Variable    ${service_option_name}
    Set Suite Variable    ${service_option_value}
    [Return]    ${service_option_value}

Get SO Value Of Apply Client Airline Commission/Rebate on FOP
    ${apply_client_airline_commision_rebate_so}    Get Service Option Item Value    Apply Client Airline Commission/Rebate on FOP
    Set Suite Variable    ${apply_client_airline_commision_rebate_so}
