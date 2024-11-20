*** Settings ***
Variables         ../variables/delivery_control_objects.py
Resource          ../common/core.robot

*** Keywords ***
Add Email Address Receive Itinerary and Invoice On Delivery Panel
    [Arguments]    ${index}    ${email_address}    ${itinerary_option}    ${invoice_option}
    Click Control Button    ${button_addrecipients}
    Set Control Text Value    [NAME:ctxtEmail${index}]    ${email_address}
    Run Keyword If    "${itinerary_option}" == "True"    Tick Receive Itinerary Checkbox    ${index}
    ...    ELSE    Untick Receive Itinerary Checkbox    ${index}
    Run Keyword If    "${invoice_option}" == "True"    Tick Receive Invoice Checkbox    ${index}
    ...    ELSE    Untick Receive Invoice Checkbox    ${index}

Add Or Subtract X Days To Ticketing Date
    [Arguments]    ${ticketing_date}    ${add_or_subtract}    ${x_days}
    ${new_ticketing_date}    Run Keyword If    "${add_or_subtract.lower()}" =="add"    Add Days In Syex Format    ${ticketing_date}    ${x_days}
    ...    ELSE IF    "${add_or_subtract.lower()}" =="subtract"    Subtract Days In Syex Format    ${ticketing_date}    ${x_days}
    [Return]    ${new_ticketing_date}

Convert Month From MMM To MM
    [Arguments]    ${month_MMM}
    Run Keyword If    '${month_MMM}' == 'JAN'    Set Suite Variable    ${month_MM}    01
    Run Keyword If    '${month_MMM}' == 'FEB'    Set Suite Variable    ${month_MM}    02
    Run Keyword If    '${month_MMM}' == 'MAR'    Set Suite Variable    ${month_MM}    03
    Run Keyword If    '${month_MMM}' == 'APR'    Set Suite Variable    ${month_MM}    04
    Run Keyword If    '${month_MMM}' == 'MAY'    Set Suite Variable    ${month_MM}    05
    Run Keyword If    '${month_MMM}' == 'JUN'    Set Suite Variable    ${month_MM}    06
    Run Keyword If    '${month_MMM}' == 'JUL'    Set Suite Variable    ${month_MM}    07
    Run Keyword If    '${month_MMM}' == 'AUG'    Set Suite Variable    ${month_MM}    08
    Run Keyword If    '${month_MMM}' == 'SEP'    Set Suite Variable    ${month_MM}    09
    Run Keyword If    '${month_MMM}' == 'OCT'    Set Suite Variable    ${month_MM}    10
    Run Keyword If    '${month_MMM}' == 'NOV'    Set Suite Variable    ${month_MM}    11
    Run Keyword If    '${month_MMM}' == 'DEC'    Set Suite Variable    ${month_MM}    12
    [Return]    ${month_MM}

Get Current Year Month And Day
    ${current_month}    Get Time    'month'    NOW
    ${current_day}    Get Time    'day'    NOW
    ${current_year}    Get Time    'year'    NOW
    ${current_month}    Convert to Integer    ${current_month}
    ${current_day}    Convert to Integer    ${current_day}
    ${current_year}    Convert to Integer    ${current_year}
    Set Suite Variable    ${current_month}
    Set Suite Variable    ${current_day}
    Set Suite Variable    ${current_year}

Get Default Ticketing Date
    ${actual_ticketing_date}    Get Control Text Value    ${date_ticketing}    ${title_power_express}
    Set Test Variable    ${default_ticketing_date}    ${actual_ticketing_date}
    [Return]    ${default_ticketing_date}

Get Delivery Method
    ${actual_delivery_method}    Get Control Text Value    [NAME:ccboDeliveryMethod]
    [Return]    ${actual_delivery_method}

Get Email Address
    @{email_list}    Create List
    : FOR    ${field_index}    IN RANGE    0    20
    \    ${currvalue} =    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtEmail${field_index}]
    \    Append To List    ${email_list}    ${currvalue}
    \    Exit For Loop If    "${currvalue}"=="${EMPTY}"
    [Return]    ${email_list}

Get Email Address By Index
    [Arguments]    ${email_index}=${EMPTY}
    ${email_address}    Get Control Text Value    [NAME:ctxtEmail${email_index}]
    [Return]    ${email_address}

Get Email Address Field Index
    [Arguments]    ${email_address}
    ${email_dict}    Create Dictionary
    : FOR    ${email_field_index}    IN RANGE    0    10
    \    ${email_field_text}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtEmail${email_field_index}]
    \    Set To Dictionary    ${email_dict}    ${email_field_text}    ${email_field_index}
    [Return]    ${email_dict}

Get Follow Up Date Value
    ${follow_up_date}    Get Control Text Value    ${date_followup}
    Set Suite Variable    ${follow_up_date}

Get LDT Month And Day
    ${ldt_marker}    Set Variable If    '${gds_switch}' == 'sabre'    LAST DAY TO PURCHASE    '${gds_switch}' == 'apollo'    LAST DATE TO PURCHASE TICKET:
    ${ldt_line}    Get Lines Containing String    ${gds_screen_data.strip()}    ${ldt_marker}
    Should Not Be Empty    ${ldt_line}    Could Not Find Last Date Ticketing From Fare Quote
    ${ldt_array}    Split String    ${ldt_line}    ${ldt_marker}
    ${ldt_line}    Remove All Spaces    ${ldt_array[1]}
    ${ldt_month}    Get Substring    ${ldt_line}    2    5
    ${ldt_day}    Get Substring    ${ldt_line}    0    2
    Set Test Variable    ${ldt_month}
    Set Test Variable    ${ldt_day}

Get LDT Month And Day For Multiple Fares
    ${ldt_marker}    Set Variable If    '${gds_switch}' == 'sabre'    LAST DAY TO PURCHASE    '${gds_switch}' == 'apollo'    LAST DATE TO PURCHASE TICKET:
    ${ldt_line}    Get Lines Containing String    ${gds_screen_data}    ${ldt_marker}
    ${ldt_array}    Split String    ${ldt_line}    ${ldt_marker}
    ${ldt1}    Remove All Spaces    ${ldt_array[1]}
    ${ldt2}    Remove All Spaces    ${ldt_array[2]}
    ${ldt1_month}    Get Substring    ${ldt1}    2    5
    ${ldt1_day}    Get Substring    ${ldt1}    0    2
    ${ldt2_month}    Get Substring    ${ldt2}    2    5
    ${ldt2_day}    Get Substring    ${ldt2}    0    2
    Set Test Variable    ${ldt1_month}
    Set Test Variable    ${ldt1_day}
    Set Test Variable    ${ldt2_month}
    Set Test Variable    ${ldt2_day}

Get LDT-1 From GDS
    Run Keyword If    '${gds_switch}' == 'sabre'    Get Price Quote
    ...    ELSE    Get Data From GDS Screen
    Get LDT Month And Day
    Get Ticketing Date Year    ${ldt_month}    ${ldt_day}
    ${ldt}    Convert Date To Syex Format    ${ldt_month}${ldt_day}${date_year}    %b%d%Y
    ${ldt-1}    Add Or Subtract X Days To Ticketing Date    ${ldt}    subtract    1
    Set Suite Variable    ${ldt}
    Set Suite Variable    ${ldt-1}

Get LDT-1 From GDS For Multiple Fares
    Get Data From GDS Screen
    Get LDT Month And Day For Multiple Fares
    Get Ticketing Date Year    ${ldt1_month}    ${ldt1_day}
    Set Test Variable    ${year1}    ${date_year}
    Get Ticketing Date Year    ${ldt2_month}    ${ldt2_day}
    Set Test Variable    ${year2}    ${date_year}
    ${ldt1}    Convert Date To Timestamp Format    ${ldt1_month}${ldt1_day}${year1}    %b%d%Y
    ${ldt2}    Convert Date To Timestamp Format    ${ldt2_month}${ldt2_day}${year2}    %b%d%Y
    ${compare_ldt}    Subtract Date From Date    ${ldt1}    ${ldt2}
    ${ldt}    Set Variable If    "${compare_ldt}" <= "0"    ${ldt1}    ${ldt2}
    ${ldt}    Convert Date To Syex Format    ${ldt}    %Y-%m-%d
    ${ldt-1}    Add Or Subtract X Days To Ticketing Date    ${ldt}    subtract    1
    Set Suite Variable    ${ldt}
    Set Suite Variable    ${ldt-1}

Get On Hold Reason Checkbox Status
    [Arguments]    ${on_hold_reason_description}
    ${checkbox_state}    Get Checkbox State    ${on_hold_reason_description}
    [Return]    ${checkbox_state}

Get Price Quote
    Enter Specific Command On Native GDS    *PQ
    ${gds_screen_data}    Get Clipboard Data Sabre
    Set Test Variable    ${gds_screen_data}    ${gds_screen_data.strip()}

Get Ticketing Date
    ${ticketing_date}    Get Control Text Value    ${date_ticketing}
    Set Suite Variable    ${ticketing_date}

Get Ticketing Date Year
    [Arguments]    ${month_val}    ${day_val}
    ${month}    Convert Month From MMM To MM    ${month_val}
    ${month}    Convert to Integer    ${month}
    ${day}    Convert to Integer    ${day_val}
    Get Current Year Month And Day
    ${current_year+1}    Evaluate    ${current_year}+1
    ${compare_day}    Evaluate    ${current_day}-${day}
    ${compare_month}    Evaluate    ${current_month}-${month}
    Run Keyword if    "${compare_month}" < "0"    Set Test Variable    ${date_year}    ${current_year}
    Run Keyword if    "${compare_month}" > "0"    Set Test Variable    ${date_year}    ${current_year+1}
    Run Keyword if    "${compare_month}" == "0" and "${compare_day}" == "0"    Set Test Variable    ${date_year}    ${current_year}
    Run Keyword if    "${compare_month}" == "0" and "${compare_day}" > "0"    Set Test Variable    ${date_year}    ${current_year+1}
    Run Keyword if    "${compare_month}" == "0" and "${compare_day}" < "0"    Set Test Variable    ${date_year}    ${current_year}

Get Ticketing Time Limit Value
    ${ticketing_time_limit_value}    Get Control Text Value    [NAME:ccboTimeLimit]
    Set Test Variable    ${ticketing_time_limit_value}

Get Time Limit Remarks Value
    ${time_limit_remarks_value}    Get Control Text Value    [NAME:ctxtTimeRemarks]
    Set Test Variable    ${time_limit_remarks_value}

Get Travel Date Month and Day
    [Arguments]    ${travel_date}=${EMPTY}
    Run Keyword If    "${travel_date}" == "${EMPTY}"    Set Test Variable    ${travel_date}    ${departure_date}
    ${dep_month}    Get Substring    ${travel_date}    2    5
    ${dep_day}    Get Substring    ${travel_date}    0    2
    Set Test Variable    ${dep_month}
    Set Test Variable    ${dep_day}

Get Travel Date-1
    [Arguments]    ${travel_date}=${EMPTY}
    Run Keyword If    "${travel_date}" == "${EMPTY}"    Get Travel Date Month and Day    ${EMPTY}
    ...    ELSE    Get Travel Date Month and Day    ${travel_date}
    Get Ticketing Date Year    ${dep_month}    ${dep_day}
    ${travel_date}    Convert Date To Syex Format    ${dep_month}${dep_day}${date_year}    %b%d%Y
    ${travel_date-1}    Add Or Subtract X Days To Ticketing Date    ${travel_date}    subtract    1
    Set Suite Variable    ${travel_date}
    Set Suite Variable    ${travel_date-1}

Populate Delivery Panel With Default Values
    [Arguments]    ${x_months}=6    ${recipient1}=automation@carlsonwagonlit.com
    Set Email Address in Delivery Panel    ${recipient1}
    ${is_delivery_method_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${combo_deliverMethod}    IsVisible    ${EMPTY}
    ${is_delivery_method_enabled} =    Control Command    ${title_power_express}    ${EMPTY}    ${combo_deliverMethod}    IsEnabled    ${EMPTY}
    Run Keyword If    ${is_delivery_method_present} == 1 and ${is_delivery_method_enabled} == 1    Select Delivery Method Using Default Value
    ${is_onhold_reason_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_holdreason3}    IsEnabled    ${EMPTY}
    Run Keyword Unless    ${is_onhold_reason_present} == 0    Select On Hold Booking Reasons Using Default Value
    ${is_ticketing_date_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${date_ticketing}    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_ticketing_date_present} == 0    Set Ticketing Date    ${x_months}
    Set Test Variable    ${is_delivery_panel_already_populated}    ${True}
    Click Panel    Delivery

Populate Delivery Panel With Default Values Excluding Email Address
    [Arguments]    ${x_months}=6    ${recipient1}=automation@carlsonwagonlit.com
    Set Email Address in Delivery Panel    ${recipient1}
    ${is_delivery_method_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${combo_deliverMethod}    IsVisible    ${EMPTY}
    ${is_delivery_method_enabled} =    Control Command    ${title_power_express}    ${EMPTY}    ${combo_deliverMethod}    IsEnabled    ${EMPTY}
    Run Keyword If    ${is_delivery_method_present} == 1 and ${is_delivery_method_enabled} == 1    Select Delivery Method Using Default Value
    ${is_onhold_reason_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${check_box_holdreason3}    IsEnabled    ${EMPTY}
    Run Keyword Unless    ${is_onhold_reason_present} == 0    Select On Hold Booking Reasons Using Default Value
    ${is_ticketing_date_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${date_ticketing}    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_ticketing_date_present} == 0    Set Ticketing Date    ${x_months}
    Set Test Variable    ${is_delivery_panel_already_populated}    ${True}

Populate Delivery Panel With Specific Delivery Method
    [Arguments]    ${delivery_method}
    ${actual_delivery_method}    Get Delivery Method
    Run Keyword If    "${actual_delivery_method}" != "${delivery_method}"    Select Delivery Method    ${delivery_method}
    Set Email Address In Delivery Panel
    ${is_ticketing_date_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${date_ticketing}    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_ticketing_date_present} == 0    Set Ticketing Date    5

Populate Delivery Panel Without On Hold Reason
    Set Email Address in Delivery Panel
    Select Delivery Method Using Default Value
    ${is_ticketing_date_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${date_ticketing}    IsVisible    ${EMPTY}
    Run Keyword Unless    ${is_ticketing_date_present} == 0    Set Ticketing Date    6

Remove Email Address
    [Arguments]    @{email_address}
    : FOR    ${email}    IN    @{email_address}
    \    ${email_dict}    Get Email Address Field Index    ${email}
    \    ${is_email_present}    Run Keyword And Return Status    Dictionary Should Contain Key    ${email_dict}    ${email}
    \    ${email_index} =    Run Keyword If    ${is_email_present} == True    Get From Dictionary    ${email_dict}    ${email}
    \    Run Keyword If    ${is_email_present} == True    Set Control Text Value    [NAME:ctxtEmail${email_index}]    ${EMPTY}

Replace Existing Email Address
    [Arguments]    ${expexted_email}    ${email}
    : FOR    ${field_index}    IN RANGE    1    20
    \    ${currvalue} =    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ctxtEmail${field_index}]
    \    Run Keyword If    "${currvalue}"=="${expexted_email}"    Set Control Text Value    [NAME:ctxtEmail${field_index}]    ${email}
    \    Exit For Loop If    "${currvalue}"=="${expexted_email}"

Select Confirmation Radio Button
    Click Control Button    [NAME:rdoItinTypeConfirmation]

Select Delivery Method
    [Arguments]    ${delivery_method}
    Wait Until Control Object Is Visible    [NAME:ccboDeliveryMethod]
    Select Value From Combobox    [NAME:ccboDeliveryMethod]    ${delivery_method}
    Set Test Variable    ${delivery_method}

Select Delivery Method Using Default Value
    ${actual_delivery_method}    Get Delivery Method
    :FOR    ${INDEX}    IN RANGE    1
    \    Exit For Loop If    "${actual_delivery_method}" == "E-Ticket" or "${actual_delivery_method}" == "ETKT"
    \    @{delivery_method_values} =    Get Dropdown Values    ${combo_deliverMethod}
    \    @{eticket_list}    Create List    E-Ticket    AUTOETIX    ETKT
    \    ${is_defaulted}    Evaluate    "${actual_delivery_method}" in @{eticket_list}
    \    ${is_eticket}    Evaluate    "E-Ticket" in @{delivery_method_values}
    \    Run Keyword If    not ${is_defaulted} and ${is_eticket}    Select Value From Dropdown List    ${combo_deliverMethod}    E-Ticket    ELSE    Send    {DOWN}{ENTER}
    Send Keys    {ESC}

Select E-Ticket Notification Radio Button
    Click Control Button    [NAME:rdoItinTypeETicket]

Select On Hold Booking Reasons
    [Arguments]    @{on_hold_reasons}
    ${awaiting_itinerary_segment}    Get Variable Value    ${awaiting_itinerary_segment}    DEFAULT
    : FOR    ${on_hold}    IN    @{on_hold_reasons}
    \    Tick Checkbox    ${on_hold}
    \    Run Keyword If    "${on_hold}" == "Awaiting Itinerary Segment"    Set Control Text Value    ${edit_awaiting_itinerary_segment}    ${awaiting_itinerary_segment}
    [Teardown]

Select On Hold Booking Reasons Using Default Value
    ${is_awaiting_approval_checked}    Get Checkbox State    Awaiting Approval
    ${is_awaiting_approval_enabled}    Is Checkbox Enabled    Awaiting Approval
    Run Keyword If    not ${is_awaiting_approval_checked} and ${is_awaiting_approval_enabled}    Tick On Hold Reasons    Awaiting Approval
    Verify At Least 1 On Hold Booking Reason is Marked

Select Ticketing Time Limit
    [Arguments]    ${expected_ticketing_time_limit_value}
    Select Value From Dropdown List    [NAME:ccboTimeLimit]    ${expected_ticketing_time_limit_value}

Select Value From Subject Line Dropdown
    [Arguments]    ${subject_line_value}
    Select Value From Dropdown List    [NAME:cboSubjectLine]    ${subject_line_value}

Set Email Address In Delivery Panel
    [Arguments]    ${recipient1}=automation@carlsonwagonlit.com
    ${recipient1_value}    Get Variable Value    ${recipient1}
    : FOR    ${index}    IN RANGE    0    20
    \    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ctxtEmail${index}]
    \    ${InvoiceIsVisible}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:chkInvoice${index}]    IsVisible
    \    ...    ${EMPTY}
    \    ${ItinIsVisible}    Control Command    ${title_power_express}    ${EMPTY}    [NAME:cchkItinerary${index}]    IsVisible
    \    ...    ${EMPTY}
    \    Exit For Loop If    ${ItinIsVisible} == 0
    \    ${InvoiceChckStatus}    Run Keyword If    ${InvoiceIsVisible} == 1    Get Checkbox Status    [NAME:chkInvoice${index}]
    \    ${ItinChckStatus}    Run Keyword If    ${ItinIsVisible} == 1    Get Checkbox Status    [NAME:cchkItinerary${index}]
    \    Run Keyword If    "${InvoiceChckStatus}" == "True" and ${InvoiceIsVisible} == 1    Control Click    ${title_power_express}    ${EMPTY}    [NAME:chkInvoice${index}]
    \    Run Keyword If    "${ItinChckStatus}" == "True" and ${ItinIsVisible} == 1    Control Click    ${title_power_express}    ${EMPTY}    [NAME:cchkItinerary${index}]
    Control Set Text    ${title_power_express}    ${EMPTY}    ${text_recipient_default}    ${recipient1_value}
    Control Click    ${title_power_express}    ${EMPTY}    ${check_box_addrecipients}
    Control Click    ${title_power_express}    ${EMPTY}    ${check_box_primaryinvoice}

Set Follow Up Date Using Actual Value
    [Arguments]    ${actual_followup_date}
    ${month} =    Fetch From Left    ${actual_followup_date}    /
    ${year} =    Fetch From Right    ${actual_followup_date}    /
    ${day} =    Fetch From Left    ${actual_followup_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Panel    Delivery
    Click Control Button    ${date_followup}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]

Set Follow Up Date Using Current Date
    ${current_date} =    SyexDateTimeLibrary.Get Current Date
    ${month} =    Fetch From Left    ${current_date}    /
    ${year} =    Fetch From Right    ${current_date}    /
    ${day} =    Fetch From Left    ${current_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Control Button    ${date_followup}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]

Set Follow Up Date X Day Ahead
    [Arguments]    ${number_of_days}=2
    ${ticketing_date} =    Add Days To Current Date In Syex Format    ${number_of_days}
    ${month} =    Fetch From Left    ${ticketing_date}    /
    ${year} =    Fetch From Right    ${ticketing_date}    /
    ${day} =    Fetch From Left    ${ticketing_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Control Button    ${date_followup}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]

Set Header And Ticket Text Values
    [Arguments]    ${header_text}    ${ticket_text}
    Set Header Text    ${header_text}
    Set Ticket Text    ${ticket_text}

Set Header Text
    [Arguments]    ${header_text}
    Set Control Text Value    [NAME:txtHeader]    ${header_text}

Set Itinerary Segment Value
    [Arguments]    ${itinerary_segment_value}
    Send Control Text Value    [NAME:ctxtHoldReason]    ${itinerary_segment_value}

Set Receive Itineray and Invoice Option On Deliver Panel
    [Arguments]    ${index}    ${itinerary_option}    ${invoice_option}
    Run Keyword If    "${itinerary_option}" == "True"    Tick Receive Itinerary Checkbox    ${index}
    ...    ELSE    Untick Receive Itinerary Checkbox    ${index}
    Run Keyword If    "${invoice_option}" == "True"    Tick Receive Invoice Checkbox    ${index}
    ...    ELSE    Untick Receive Invoice Checkbox    ${index}

Set Subject Line Value
    [Arguments]    ${SubjectLine}
    Select Value From Dropdown List    [NAME:cboSubjectLine]    ${SubjectLine}

Set Ticket Text
    [Arguments]    ${ticket_text}
    Set Control Text Value    [NAME:txtTicket]    ${ticket_text}

Set Ticketing Date
    [Arguments]    ${number_of_months}=6
    ${actual_ticketing_date}    Get Control Text Value    ${date_ticketing}    ${title_power_express}
    Set Test Variable    ${actual_ticketing_date}
    ${ticketing_date} =    Set Departure Date X Months From Now In Syex Format    ${number_of_months}
    ${ticketing_date_minus_one} =    Subtract Days In Syex Format    ${ticketing_date}    1
    ${is_ticketing_date_future_date}    Evaluate    '${actual_ticketing_date}' != '${ticketing_date}' and '${ticketing_date_minus_one}' != '${actual_ticketing_date}'
    Set Test Variable    ${ticketing_date}
    ${is_error_present}    Is Error Icon Visible    grpTicketingDetails
    Run Keyword If    ${is_ticketing_date_future_date} or ${is_error_present}    Set Ticketing Date X Months From Now    ${number_of_months}
    ${actual_ticketing_date}    Get Control Text Value    ${date_ticketing}    ${title_power_express}
    Set Test Variable    ${actual_ticketing_date}
    ${ticketing_date_in_gds_format}    Convert Date To Gds Format    ${actual_ticketing_date}    %m/%d/%Y
    Set Test Variable    ${ticketing_date_in_gds_format}

Set Ticketing Date One Day Ahead
    ${ticketing_date} =    Add Days To Current Date In Syex Format    1
    ${month} =    Fetch From Left    ${ticketing_date}    /
    ${year} =    Fetch From Right    ${ticketing_date}    /
    ${day} =    Fetch From Left    ${ticketing_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Control Button    ${date_ticketing}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]

Set Ticketing Date To LDT+1
    ${ldt+1}    Add Or Subtract X Days To Ticketing Date    ${ldt}    add    1
    Set Ticketing Date Using Actual Value    ${ldt+1}

Set Ticketing Date To LDT-1
    Set Ticketing Date Using Actual Value    ${ldt-1}

Set Ticketing Date To Travel Date+1
    ${travel_date+1}    Add Or Subtract X Days To Ticketing Date    ${travel_date}    Add    1
    Set Ticketing Date Using Actual Value    ${travel_date+1}

Set Ticketing Date To Travel Date-1
    Set Ticketing Date Using Actual Value    ${travel_date-1}

Set Ticketing Date Using Actual Value
    [Arguments]    ${actual_ticketing_date}
    ${month} =    Fetch From Left    ${actual_ticketing_date}    /
    ${year} =    Fetch From Right    ${actual_ticketing_date}    /
    ${day} =    Fetch From Left    ${actual_ticketing_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Panel    Delivery
    Click Control Button    ${date_ticketing}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]

Set Ticketing Date Using Current Date
    ${ticketing_date} =    SyexDateTimeLibrary.Get Current Date
    ${month} =    Fetch From Left    ${ticketing_date}    /
    ${year} =    Fetch From Right    ${ticketing_date}    /
    ${day} =    Fetch From Left    ${ticketing_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Control Button    ${date_ticketing}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]
    # ${delivery_method}    Get Control Text Value    ${combo_deliverMethod}
    # ${is_not_auto_ticket}    Run Keyword And Return Status    Should Not Contain    ${delivery_method.upper()}    AUTO TICKET
    # Should Be True    ${is_not_auto_ticket}    Unable to proceed. Auto Ticket delivery method is selected and ticketing date is set to current date.

Set Ticketing Date X Months From Now
    [Arguments]    ${number_of_months}
    ${month} =    Fetch From Left    ${ticketing_date}    /
    ${year} =    Fetch From Right    ${ticketing_date}    /
    ${day} =    Fetch From Left    ${ticketing_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    Click Control Button    ${date_ticketing}    ${title_power_express}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Click Control Button    [NAME:cboNativeEntry]
    ${is_error_present}    Is Error Icon Visible    grpTicketingDetails
    Run Keyword If    ${is_error_present}    Set Ticketing Date One Day Ahead
    Click Control Button    ${date_ticketing}
    ${is_error_present_on_one_day_ahead}    Is Error Icon Visible    grpTicketingDetails
    Run Keyword If    ${is_error_present_on_one_day_ahead}    Set Ticketing Date Using Actual Value    ${actual_ticketing_date}
    ${is_error_still_present}    Is Error Icon Visible    grpTicketingDetails
    Run Keyword If    ${is_error_still_present}    Set Ticketing Date Using Current Date

Set Time Limit Remarks
    [Arguments]    ${expected_time_limit_remarks_value}
    Set Control Text Value    [NAME:ctxtTimeRemarks]    ${expected_time_limit_remarks_value}

Tick Awaiting Approval
    [Arguments]    ${tick_action}=tick
    ${tick_action}    Convert To Lowercase    ${tick_action}
    Run Keyword If    "${tick_action}" == "tick"    Tick Checkbox    ${check_box_holdreason3}
    Run Keyword If    "${tick_action}" == "untick"    Untick Checkbox    ${check_box_holdreason3}

Tick Do Not Send To OBT Checkbox
    Tick Checkbox    ${check_box_do_not_send_to_OBT}

Tick On Hold Reasons
    [Arguments]    @{on_hold_reasons}
    : FOR    ${on_hold_reason}    IN    @{on_hold_reasons}
    \    Tick Checkbox    ${on_hold_reason}

Tick Receive Invoice Checkbox
    [Arguments]    ${receive_invoice_index}=${EMPTY}
    ${receive_invoice_field}    Set Variable If    "${receive_invoice_index}" != "${EMPTY}"    [NAME:chkInvoice${receive_invoice_index}]    ${check_box_primaryinvoice}
    Tick Checkbox    ${receive_invoice_field}

Tick Receive Itinerary Checkbox
    [Arguments]    ${receive_itin_index}=${EMPTY}
    ${receive_itin_field}    Set Variable If    "${receive_itin_index}" != "${EMPTY}"    [NAME:cchkItinerary${receive_itin_index}]    ${check_box_addrecipients}
    Tick Checkbox    ${receive_itin_field}

Unselect On Hold Booking Reasons
    [Arguments]    @{on_hold_reasons}
    [Documentation]    Accepts singular or multiple on hold reaons
    : FOR    ${on_hold}    IN    @{on_hold_reasons}
    \    Untick Checkbox    ${on_hold}

Untick Do Not Send Itinerary Checkbox
    Untick Checkbox    ${check_box_do_not_send_itinerary}

Untick On Hold Reasons
    [Arguments]    @{on_hold_reasons}
    : FOR    ${on_hold_reason}    IN    @{on_hold_reasons}
    \    Untick Checkbox    ${on_hold_reason}

Untick Receive Invoice Checkbox
    [Arguments]    ${receive_invoice_index}=${EMPTY}
    ${receive_invoice_field}    Set Variable If    "${receive_invoice_index} " !="${EMPTY}"    [NAME:chkInvoice${receive_invoice_index}]    ${check_box_primaryinvoice}
    Untick Checkbox    ${receive_invoice_field}

Untick Receive Itinerary Checkbox
    [Arguments]    ${receive_itin_index}=${EMPTY}
    ${receive_itin_field}    Set Variable If    "${receive_itin_index}" != "${EMPTY}"    [NAME:cchkItinerary${receive_itin_index}]    ${check_box_addrecipients}
    Untick Checkbox    ${receive_itin_field}

Verify At Least 1 On Hold Booking Reason Is Marked
    @{on_hold_reasons_enabled}    Get Onhold Booking Reasons Selected
    ${length}    Get Length    ${on_hold_reasons_enabled}
    Should Be True    ${length} > 0   
    
Verify Delivery Panel Emails
    [Arguments]    @{expected_text_value}
    @{email_list}    Get Email Address
    : FOR    ${email}    IN    @{expected_text_value}
    \    List Should Contain Value    ${email_list}    ${email}

Get Onhold Booking Reasons Selected
    Activate Power Express Window
    @{on_hold_reasons_actual}    Get Pane Control Children Name    pnlHoldReason
    @{on_hold_reasons_enabled}    Create List
    : FOR    ${value}    IN    @{on_hold_reasons_actual}
    \    ${state}    Get Checkbox State    ${value}
    \    Run Keyword If    ${state} == ${True}    Append To List    ${on_hold_reasons_enabled}    ${value}
    Set Test Variable    ${on_hold_reasons_enabled}
    [Return]    ${on_hold_reasons_enabled}

Get Onhold Booking Reasons Unselected
    Activate Power Express Window
    @{on_hold_reasons_actual}    Get Pane Control Children Name    pnlHoldReason
    @{on_hold_reasons_enabled}    Create List
    : FOR    ${value}    IN    @{on_hold_reasons_actual}
    \    ${state}    Get Checkbox State    ${value}
    \    Run Keyword If    ${state} == ${False}    Append To List    ${on_hold_reasons_enabled}    ${value}
    Set Test Variable    ${on_hold_reasons_enabled}
    [Return]    ${on_hold_reasons_enabled}