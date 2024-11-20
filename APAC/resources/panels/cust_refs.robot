*** Settings ***
Variables         ../variables/cust_refs_control_object.py
Resource          ../common/core.robot

*** Keywords ***
Determine CDR Value And Position
    Wait Until Control Object Is Visible    [NAME:grpCDReferences]
    ${cdr_dict}    Create Dictionary
    : FOR    ${cdr_field_index}    IN RANGE    1    21
    \    ${cdr_field_text}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblCDRDescription${cdr_field_index}]
    \    Set To Dictionary    ${cdr_dict}    ${cdr_field_text}    ${cdr_field_index}
    [Return]    ${cdr_dict}

Determine CDR Description And Index
    Wait Until Control Object Is Visible    [NAME:grpCDReferences]
    ${cdr_dict}    Create Dictionary
    : FOR    ${cdr_field_index}    IN RANGE    0    32
    \    ${cdr_field_text}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblCDRDescription${cdr_field_index}]
    \    Set To Dictionary    ${cdr_dict}    ${cdr_field_text}    ${cdr_field_index}
    [Return]    ${cdr_dict}

Populate Cust Refs Panel With Default Values
    : FOR    ${Index}    IN RANGE    1    30
    \    Control Click    ${title_power_express}    ${EMPTY}    ${edit_cdr${Index}}
    \    ${IsVisible}    Control Command    ${title_power_express}    ${EMPTY}    ${edit_cdr${Index}}    IsVisible
    \    ...    ${EMPTY}
    \    Run Keyword If    ${IsVisible} == 1    Control Set Text    ${title_power_express}    ${EMPTY}    ${edit_cdr${Index}}
    \    ...    ${EMPTY}
    Tick Not Known At Time Of Booking    Tick

Set CDR Value
    [Arguments]    ${cdr_field}    ${cdr_value}
    ${cdr_dict}    Determine CDR Description And Index
    ${cdr_index} =    Get From Dictionary    ${cdr_dict}    ${cdr_field}
    Send Control Text Value    [NAME:ctxtCDRValue${cdr_index}]    ${cdr_value}
    Send    {TAB}

Tick Not Known At Time Of Booking
    [Arguments]    ${checkbox_action}=TICK
    [Documentation]    Checkbox action should either be TICK or UNTICK
    ${is_checked} =    Get Checkbox Status    ${check_box_skip_validation}
    Run Keyword If    '${is_checked}' == 'False' and '${checkbox_action.upper()}' == 'TICK'    Tick Checkbox    ${check_box_skip_validation}
    Run Keyword If    '${is_checked}' == 'True' and '${checkbox_action.upper()}' == 'UNTICK'    Untick Checkbox    ${check_box_skip_validation}

Tick Show All Client Defined References
    Wait Until Control Object Is Visible    ${check_box_show_all_cdr}
    Tick Checkbox    ${check_box_show_all_cdr}

Get Client Account Name
    [Return]    ${client_account_name}
