*** Settings ***
Resource          ../common/core.robot
Variables         ../variables/client_fees_control_objects.py

*** Keywords ***
Populate Client Fees Panel With Default Values
    Wait Until Control Object Is Visible    [NAME:grpFees]
    : FOR    ${index}    IN RANGE    0    10
    \    ${is_field_visible} =    Control Command    ${title_power_express}    ${EMPTY}    [NAME:ccboClientFees${index}]    IsVisible
    \    ...    ${EMPTY}
    \    Exit For Loop If    ${is_field_visible} == 0
    \    ${control_background_color}    Get Control Object Background Color    [NAME:ccboClientFees${index}]
    \    Run Keyword If    ${is_field_visible} == 1 and "${control_background_color}" == "FFD700"    Run Keywords    Control Focus    ${title_power_express}    ${EMPTY}
    \    ...    [NAME:ccboClientFees${index}]
    \    ...    AND    Send    {DOWN}{TAB}

Select Fee From Dropdown
    [Arguments]    ${fee_dropdown_name}    ${fee_dropdown_value}
    Select Value From Combobox    ${fee_dropdown_name}    ${fee_dropdown_value}
