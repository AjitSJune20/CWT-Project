*** Settings ***
Resource          amend.robot

*** Keywords ***
Verify Touch Level Default Value
    [Arguments]    ${expected_default_value}
    Verify Control Object Text Value Is Correct    ${cbo_touch_level}    ${expected_default_value}
    [Teardown]    Take Screenshot

Verify Touch Level Dropdown Values
    [Arguments]    @{level_values}
    ${actual_touch_level_value} =    Get Value From Dropdown List    ${cbo_touch_level}
    : FOR    ${touch_level_value}    IN    @{level_values}
    \    Run Keyword And Return Status    List Should Contain Value    ${actual_touch_level_value}    ${touch_level_value}
