*** Settings ***
Documentation     This resource file covers all reusable actions for Unused Documents Panel related test cases
Resource          ../common/core.robot

*** Keywords ***
Get All Unused Document
    ${all_unused_documents}    Get Document Items
    Should Not Be Empty    ${all_unused_documents}
    Set Test Variable    ${all_unused_documents}
    [Return]    ${all_unused_documents}

Get One Unused Document
    [Arguments]    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    ${selected_unused_document_detail}    Get Line    ${all_unused_documents}    ${row_number}
    Should Not Be Empty    ${selected_unused_document_detail}
    Set Test Variable    ${selected_unused_document_detail}
    [Return]    ${selected_unused_document_detail}

Select Unused Document Using Row Number
    [Arguments]    ${double_click}=False    @{row_number}
    ${all_unused_documents}    Get All Unused Document
    : FOR    ${row_number}    IN    @{row_number}
    \    ${unused_document_detail}    Get One Unused Document    ${row_number}
    \    Click Document Item    ${unused_document_detail}    ${double_click}

Add Unused Ticket (Dummy)
    [Arguments]    ${ticket_type}    ${ticket_number}    ${airline_code}    ${pnr_locator}    ${value}=10 USD    ${booking_iata}=08612312
    ...    ${issuing_pcc}=SIN010101
    Click Add Document
    Select Ticket Type In Unused Document    ${ticket_type}
    Set Ticket Number In Unused Document    ${ticket_number}
    Set Airline Code In Unused Document    ${airline_code}
    Set PNR Locator In Unused Document    ${pnr_locator}
    Run Keyword If    '${ticket_type}' != '3-Electronic'    Set Value and Currency In Unused Document    ${value}
    Run Keyword If    '${ticket_type}' != '3-Electronic'    Set Booking IATA In Unused Document    ${booking_iata}
    Run Keyword If    '${ticket_type}' != '3-Electronic'    Set Issuing PCC In Unused Document    ${issuing_pcc}
    Click Save Button

Click Add Document
    Activate Power Express Window
    Wait Until Control Object Is Visible    [NAME:CreateDocButton]    ${title_power_express}
    Click Control Button    [NAME:CreateDocButton]

Select Ticket Type In Unused Document
    [Arguments]    ${ticket_type}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:TicketTypeComboBox]    window_title=Add Travel Document
    ${dropdown_list}    Get Value From Dropdown List    [NAME:TicketTypeComboBox]    window_title=Add Travel Document
    ${ticket_selection}    Get Index From List    ${dropdown_list}    ${ticket_type}
    Select Value From Dropdown List    [NAME:TicketTypeComboBox]    ${ticket_selection}    window_title=Add Travel Document    by_index=True

Set Ticket Number In Unused Document
    [Arguments]    ${ticket_number}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:TicketNumberText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:TicketNumberText]    ${ticket_number}    window_title=Add Travel Document

Set Airline Code In Unused Document
    [Arguments]    ${airline_code}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:AirlineCodeText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:AirlineCodeText]    ${airline_code}    window_title=Add Travel Document

Set PNR Locator In Unused Document
    [Arguments]    ${pnr_locator}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:PNRLocatorText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:PNRLocatorText]    ${pnr_locator}    window_title=Add Travel Document

Click Save Button
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:SaveButton]    window_title=Add Travel Document
    Click Control Button    [NAME:SaveButton]    window_title=Add Travel Document
    Wait Until Control Object Is Visible    [NAME:DocumentTree]    ${title_power_express}

Use Ticket Number From Unused Documents Tab (Screen)
    [Arguments]    ${ticket_number}
    ${all_unused_docs}    Get Document Items
    ${all_unused_documents}    Split String    ${all_unused_docs}    \n
    Log List    ${all_unused_documents}
    : FOR    ${unused_document}    IN    @{all_unused_documents}
    \    ${is_detected}    Run Keyword And Ignore Error    Should Contain    ${unused_document}    ${ticket_number}
    \    ${row_to_click}    Set Variable If    '${is_detected[0]}'=='PASS'    ${unused_document}
    \    Exit For Loop If    '${is_detected[0]}'=='PASS'
    Click Document Item    ${row_to_click}    double_click=False
    ${row_items}    Split String    ${row_to_click}    ${SPACE}
    Select New Status In Unused Document    Exchanged
    Click Set Button In Unused Document
    Sleep    3
    Click Document Item    ${row_to_click}
    Click PNR Button In Unused Document
    Set Suite Variable    ${unused_pnr_locator}    ${row_items[2]}
    Set Suite Variable    ${unused_airline_code}    ${row_items[3]}
    Set Suite Variable    ${unused_ticket_number}    ${row_items[4]}

Select New Status In Unused Document
    [Arguments]    ${new_status}
    Select Value From Dropdown List    [NAME:StatusCodeComboBox]    ${new_status}

Click Set Button In Unused Document
    Activate Power Express Window
    Wait Until Control Object Is Visible    [NAME:StatusSetButton]    ${title_power_express}
    Click Control Button    [NAME:StatusSetButton]

Set Ticket Number To New Status
    [Arguments]    ${ticket_number}    ${status}
    ${all_unused_docs}    Get Document Items
    ${all_unused_documents}    Split String    ${all_unused_docs}    \n
    : FOR    ${unused_document}    IN    @{all_unused_documents}
    \    ${is_detected}    Run Keyword And Ignore Error    Should Contain    ${unused_document}    ${ticket_number}
    \    ${row_to_click}    Set Variable If    '${is_detected[0]}'=='PASS'    ${unused_document}
    \    Exit For Loop If    '${is_detected[0]}'=='PASS'
    Click Document Item    ${row_to_click}
    Select New Status In Unused Document    ${status}
    Click Set Button In Unused Document

Set Value and Currency In Unused Document
    [Arguments]    ${value}
    ${values}    Split String    ${value}    ${SPACE}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:ValueText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:ValueText]    ${values[0]}    window_title=Add Travel Document
    ${dropdown_list}    Get Value From Dropdown List    [NAME:CurrencyComboBox]    window_title=Add Travel Document
    ${currency_selection}    Get Index From List    ${dropdown_list}    ${values[1]}
    Select Value From Dropdown List    [NAME:CurrencyComboBox]    ${currency_selection}    window_title=Add Travel Document    by_index=True

Set Booking IATA In Unused Document
    [Arguments]    ${booking_iata}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:BookingIATAText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:BookingIATAText]    ${booking_iata}    window_title=Add Travel Document

Set Issuing PCC In Unused Document
    [Arguments]    ${issuing_pcc}
    Wait Until Window Exists    Add Travel Document
    Wait Until Control Object Is Visible    [NAME:IssuingPCCText]    window_title=Add Travel Document
    Set Control Text Value    [NAME:IssuingPCCText]    ${issuing_pcc}    window_title=Add Travel Document

Click PNR Button In Unused Document
    Activate Power Express Window
    Wait Until Control Object Is Visible    [NAME:AddToPNRButton]    ${title_power_express}
    Click Control Button    [NAME:AddToPNRButton]
