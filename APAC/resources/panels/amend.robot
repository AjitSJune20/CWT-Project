*** Settings ***
Resource          ../common/core.robot

*** Keywords ***
Populate Amend Panel With Default Values
    Wait Until Control Object Is Visible    [NAME:pnlOnlineBookingCodes]
    ${is_touch_level_visible}    Control Command    Power Express    ${EMPTY}    [NAME:ccboTouchLevel]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_touch_level_visible} == 1    Select Value From Dropdown List    [NAME:ccboTouchLevel]    2    \    True
    ${is_touch_type_visible}    Control Command    Power Express    ${EMPTY}    [NAME:ccboTouchType]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_touch_type_visible} == 1    Select Value From Dropdown List    [NAME:ccboTouchType]    2    \    True
    ${is_touch_reason_visible}    Control Command    Power Express    ${EMPTY}    [NAME:ccboTouchReason]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_touch_reason_visible} == 1    Select Value From Dropdown List    [NAME:ccboTouchReason]    2    \    True

Select Touch Level
    [Arguments]    ${touch_level}
    Select Value From Dropdown List    [NAME:ccboTouchLevel]    ${touch_level}

Select Touch Reason
    [Arguments]    ${touch_reason}
    Select Dropdown Value    [NAME:ccboTouchReason]    ${touch_reason}

Tick Notes Checkbox In Amend Panel
    Comment    ${checkbox_status}    Get checkbox status    [NAME:cchkTouchReasonNotes]
    Comment    Run Keyword If    '${checkbox_status}' == 'False'    Tick Checkbox    [NAME:cchkTouchReasonNotes]
    ...    ELSE    Log    Notes Checkbox Already Ticked Upon Load
    Tick Checkbox    [NAME:cchkTouchReasonNotes]

UnTick Notes Checkbox In Amend Panel
    Comment    ${checkbox_status}    Get checkbox status    [NAME:cchkTouchReasonNotes]
    Comment    Run Keyword If    '${checkbox_status}' == 'True'    Tick Checkbox    [NAME:cchkTouchReasonNotes]
    Tick Checkbox    [NAME:cchkTouchReasonNotes]

Select Touch Type
    [Arguments]    ${touch_type}
    Select Value From Combobox    [NAME:ccboTouchType]    ${touch_type}
