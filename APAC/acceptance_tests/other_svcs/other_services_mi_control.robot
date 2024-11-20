*** Settings ***
Resource          ../../resources/common/global_resources.robot

*** Keywords ***
Generate Expected Client MI Remarks
    [Arguments]    ${identifier}
    ${client_mi_remarks}    Generate Client MI Remarks
    Set Suite Variable    ${client_mi_remarks_${identifier}}    ${client_mi_remarks}

Populate Client Mi Grid
    [Arguments]    &{dict}
    : FOR    ${key}    IN    @{dict.keys()}
    \    Set Client MI Field    ${key}    ${dict["${key}"]}    ClientMIGridView    6    2
    [Teardown]    Take Screenshot

Set Client MI Field
    [Arguments]    ${row_item}    ${row_value}    ${grid_auto_id}    ${row_item_index}=1    ${row_value_index}=2
    Activate Power Express Window
    Set Row Object In Datagrid    ${row_item}    ${row_value}    ${grid_auto_id}    ${row_item_index}    ${row_value_index}
    [Teardown]    Take Screenshot

Verify Client MI Grid View Details
    [Arguments]    &{dict}
    :FOR    ${key}    IN    @{dict.keys()}
    \    ${actual_mi_value}    Get Client MI Field    ${key}    ClientMIGridView
    \    Verify Actual Value Matches Expected Value    ${actual_mi_value}    ${dict["${key}"]}

Get Client MI Field
    [Arguments]    ${row_item}    ${grid_auto_id}    ${row_item_index}=6    ${row_value_index}=2
    [Timeout]
    ${mi_field_data}    Get Row Object In Datagrid    ${row_item}    ${grid_auto_id}    ${row_item_index}    ${row_value_index}
    [Return]    ${mi_field_data}
