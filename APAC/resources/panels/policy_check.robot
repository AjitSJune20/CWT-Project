*** Settings ***
Resource          ../common/core.robot
Variables         ../variables/policy_check_control_objects.py

*** Keywords ***
Populate Policy Check Panel With Default Values
    [Arguments]    ${str_policy_status}=${EMPTY}
    Wait Until Control Object Is Visible    [NAME:tlpPolicyCheck]
    : FOR    ${index}    IN RANGE    0    10
    \    ${is_field_visible} =    Control Command    ${title_power_express}    ${EMPTY}    ${cbo_policystatus${index}}    IsVisible
    \    ...    ${EMPTY}
    \    Exit For Loop If    ${is_field_visible} == 0
    \    ${pc_policy_status} =    Control Get Text    ${title_power_express}    ${EMPTY}    ${cbo_policystatus${index}}
    \    Run Keyword If    "${pc_policy_status}" == "${EMPTY}"    Click Panel    Policy Check
    \    Run Keyword If    "${pc_policy_status}" == "${EMPTY}"    Control Click    ${title_power_express}    ${EMPTY}    ${cbo_policystatus${index}}
    \    Run Keyword If    "${pc_policy_status}" == "${EMPTY}"    Send    {DOWN}{TAB}

Select Policy Status
    [Arguments]    ${expected_policy_reason}    ${policy_status}
    Wait Until Control Object Is Visible    [NAME:tlpPolicyCheck]
    ${policy_dict}    Create Dictionary
    : FOR    ${INDEX}    IN RANGE    0    10
    \    ${is_control_visible}    Run Keyword And Return Status    Verify Control Object Is Visible    [NAME:clblPolicyReason${index}]
    \    Comment    ${is_control_visible}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:clblPolicyReason${index}]
    \    ...    IsVisible    ${EMPTY}
    \    Exit For Loop If    ${is_control_visible} == 0
    \    ${actual_policy_reason}    Get Control Text Value    [NAME:clblPolicyReason${index}]
    \    Set To Dictionary    ${policy_dict}    ${actual_policy_reason}    ${cbo_policystatus${index}}
    Log    ${policy_dict}
    ${policy_reason_field}    Get From Dictionary    ${policy_dict}    ${expected_policy_reason}
    Select Value From Dropdown List    ${policy_reason_field}    ${policy_status}
    Control Click    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}    ${EMPTY}

Select Policy Status Using Index Number
    [Arguments]    ${index_number}    ${policy_status}
    Wait Until Control Object Is Visible    [NAME:tlpPolicyCheck]
    Select Value From Dropdown List    ${cbo_policystatus${index_number}}    ${policy_status}

Get Numeric Value In Locator
    [Arguments]    ${policy_reason_field}
    ${number}    Get Substring    ${policy_reason_field}    22    23
    Log    ${number}
    ${number}    Convert To Integer    ${number}
    [Return]    ${number}
