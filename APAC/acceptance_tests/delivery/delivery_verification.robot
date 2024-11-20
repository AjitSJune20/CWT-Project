*** Settings ***
Resource          ../gds/gds_verification.robot
Resource          ../../resources/panels/delivery.robot

*** Keywords ***
Generate Time For TAW Line
    ${hour}    DateTime.Get Current Date    result_format=%I
    ${clock_identifier}    DateTime.Get Current Date    result_format=%p
    ${clock_identifier}    Set Variable If    "${clock_identifier}" == "AM"    A    P
    Set Suite Variable    ${taw_current_time}    ${hour}00${clock_identifier}

Verify Aqua Queue Minder Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    OP ${pcc}/${current_date}/${queue_number}C${queue_category}/AQUA QUEUING    ${occurence}

Verify Aqua Queue Minder Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    OP ${pcc}/${current_date}/${queue_number}${queue_category}/AQUA QUEUING

Verify Aqua Queue Place Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    QE/${pcc}/${queue_number}${queue_category}    ${occurence}

Verify Aqua Queue Place Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    QE/${pcc}/${queue_number}${queue_category}

Verify Confirmation Is Selected As Default Itinerary Type
    ${radio_state}    Get Radio Button State    [NAME:rdoItinTypeConfirmation]
    Should Be True    ${radio_state} == True

Verify Delivery Method Default Value Is Correct
    [Arguments]    ${expected_default_value}
    Verify Control Object Text Value Is Correct    ${combo_deliverMethod}    ${expected_default_value}
    [Teardown]    Take Screenshot

Verify Delivery Method Dropdown Values
    [Arguments]    @{expected_delivery_methods}
    ${actual_delivery_methods}    Get Dropdown Values    ${combo_deliverMethod}
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${actual_delivery_methods}    ${expected_delivery_methods}

Verify Delivery Method Is Not Present
    [Arguments]    @{delivery_methods}
    @{actual_delivery_methods}    Get Dropdown Values    [NAME:ccboDeliveryMethod]
    : FOR    ${delivery_method}    IN    @{delivery_methods}
    \    List Should Not Contain Value    ${actual_delivery_methods}    ${delivery_method}

Verify Delivery Method Selected Is Reflected In The Ticketing Line
    [Arguments]    ${ticketing_line_prefix}    ${delivery_method_suffix}
    ${escaped_ticketing_line_prefix}    Regexp Escape    ${ticketing_line_prefix}
    ${escaped_delivery_method_suffix}    Regexp Escape    ${delivery_method_suffix}
    Verify Specific Line Is Written In The PNR    ${escaped_ticketing_line_prefix}\\D{2}\\d{2}\\D{3}${escaped_delivery_method_suffix}    true

Verify Email Address Remarks Are Written
    [Arguments]    ${email_address}
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL ${email_address}
    Verify Specific Line Is Written In The PNR    RM *EMAIL/${email_address}

Verify Follow Up Date Field Value
    [Arguments]    ${expected_followup_date_value}=${EMPTY}    ${custom_message}=${EMPTY}
    ${follow_up_date}    Get Variable Value    ${follow_up_date}    ${expected_followup_date_value}
    Verify Control Object Text Value Is Correct    [NAME:uccFollowupDate]    ${expected_followup_date_value}    ${custom_message}
    [Teardown]    Take Screenshot

Verify Follow up Date Warning Message is Not Displayed
    ${tooltip_presence}    Is Tooltip Present    343    581
    Should Be True    ${tooltip_presence} == False    msg=Follow up Date Warning Message should not be displayed

Verify Follow up Date Warning Tooltip Message Is Correct
    [Arguments]    ${expected_tooltip_text}
    Verify Tooltip Text Is Correct Using Coords    345    616    ${expected_tooltip_text}

Verify GSTIN FF95 Is Written
    [Arguments]    ${gsTin_data}    ${command}=${EMPTY}
    Retrieve PNR Details From Amadeus    command=${command}
    Verify Specific Line Is Written In The PNR X Times    RM *FF95/${gsTin_data}    1

Verify Invalid Ticketing Date Error Message Is Displayed
    [Arguments]    ${tooltip_text}
    Verify Ticketing Date Error Tooltip Message Is Correct    ${tooltip_text}
    [Teardown]    Take Screenshot

Verify Invalid Ticketing Date Error Message Is Not Displayed
    ${tooltip_presence}    Is Tooltip Present    229    581
    Should Be True    ${tooltip_presence} == False    msg=Invalid Ticketing Date Error Message should not be displayed
    [Teardown]    Take Screenshot

Verify Invalid Ticketing Date Warning Message Is Not Displayed
    ${tooltip_presence}    Is Tooltip Present    229    581
    Should Be True    ${tooltip_presence} == False    msg=Invalid Ticketing Date Error Message should not be displayed
    [Teardown]    Take Screenshot

Verify Itinerary Type Section Is Displayed
    Verify Control Object Is Visible    [NAME:grpItineraryType]
    Verify Control Object Is Visible    [NAME:rdoItinTypeConfirmation]
    Verify Control Object Is Visible    [NAME:rdoItinTypeETicket]
    ${confirmation_label} =    Set Variable If    "${locale}" == "de-DE"    Reiseplan    Confirmation
    ${eticket_label} =    Set Variable If    "${locale}" == "fr-FR"    Reçu de e-ticket    "${locale}" == "de-DE"    E-Ticket    E-Ticket Notification
    Verify Control Object Text Value Is Correct    [NAME:rdoItinTypeConfirmation]    ${confirmation_label}
    Verify Control Object Text Value Is Correct    [NAME:rdoItinTypeETicket]    ${eticket_label}
    [Teardown]    Take Screenshot

Verify Itinerary Type Section Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:grpItineraryType]
    Verify Control Object Is Not Visible    [NAME:rdoItinTypeConfirmation]
    Verify Control Object Is Not Visible    [NAME:rdoItinTypeETicket]
    [Teardown]    Take Screenshot

Verify On Hold Booking Reason Is Disabled
    [Arguments]    ${onhold_reason}
    ${is_enabled}    Is Checkbox Enabled    ${onhold_reason}
    Run Keyword And Continue On Failure    Should Be True    not ${is_enabled}    ${on_hold_reason} checkbox must be disabled.
    [Teardown]    Take Screenshot

Verify On Hold Booking Reason Is Enabled
    [Arguments]    ${onhold_reason}
    ${is_enabled}    Is Checkbox Enabled    ${onhold_reason}
    Run Keyword And Continue On Failure    Should Be True    ${is_enabled}    ${on_hold_reason} checkbox must be enabled.
    [Teardown]    Take Screenshot

Verify On Hold Booking Reason Is Unchecked
    [Arguments]    ${on_hold_reason}
    Activate Power Express Window
    ${is_checked}    Get Checkbox State    ${on_hold_reason}
    Run Keyword And Continue On Failure    Should Be True    not ${is_checked}    ${on_hold_reason} checkbox must not be ticked.
    [Teardown]    Take Screenshot

Verify On Hold Booking Reasons Are All Unchecked
    Verify On Hold Booking Reason Is Unchecked    Awaiting Customer References
    Verify On Hold Booking Reason Is Unchecked    Awaiting Secure Flight Data
    Verify On Hold Booking Reason Is Unchecked    Awaiting Fare Details
    Verify On Hold Booking Reason Is Unchecked    Awaiting Approval
    Verify On Hold Booking Reason Is Unchecked    Awaiting Itinerary Segment
    Verify On Hold Booking Reason Is Unchecked    Awaiting Form of Payment

Verify On Hold Queue Minder Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    ${followup_date}    Convert Date To GDS Format    ${followup_date}    %m/%d/%Y
    Verify Specific Remark Is Not Written X Times In The PNR    OP ${pcc}/${follow_up_date}/${queue_number}${queue_category}/PNR ON HOLD SEE REMARKS    ${occurence}

Verify On Hold Queue Minder Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    ${followup_date}    Convert Date To GDS Format    ${followup_date}    %m/%d/%Y
    Verify Specific Line Is Written In The PNR    OP ${pcc}/${follow_up_date}/${queue_number}${queue_category}/PNR ON HOLD SEE REMARKS

Verify On Hold Queue Place Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${occurence}=1
    Verify Specific Remark Is Not Written X Times In The PNR    QE/${pcc}/${queue_number}${queue_category}    ${occurence}

Verify On Hold Queue Place Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    QE/${pcc}/${queue_number}${queue_category}

Verify Policy Reason Is Not Displayed
    [Arguments]    ${expected_policy_reason}
    : FOR    ${index}    IN RANGE    0    10
    \    ${isVisible}    Control Command    Power Express    ${EMPTY}    [NAME:clblPolicyReason${index}]    IsVisible
    \    ...    ${EMPTY}
    \    Exit For Loop If    '${isVisible}' != '1'
    \    ${actual_policy_reason}    Get Control Text Value    [NAME:clblPolicyReason${index}]
    \    Run Keyword And Continue On Failure    Should Not Match    ${actual_policy_reason}    ${expected_policy_reason}    Policy reason '${expected_policy_reason}' should no longer be displayed in Quick Amend.

Verify Policy Status Does Not Contain Option
    [Arguments]    ${expected_policy_reason}    ${policy_status}
    : FOR    ${index}    IN RANGE    0    10
    \    ${isVisible}    Control Command    Power Express    ${EMPTY}    [NAME:clblPolicyReason${index}]    IsVisible
    \    ...    ${EMPTY}
    \    Run Keyword If    '${isVisible}' != '1'    Run Keyword And Continue On Failure    FAIL    Policy reason not found in list: ${expected_policy_reason}
    \    Exit For Loop If    '${isVisible}' != '1'
    \    ${actual_policy_reason}    Get Control Text Value    [NAME:clblPolicyReason${index}]
    \    @{actual_list}    Run Keyword If    '${actual_policy_reason}' == '${expected_policy_reason}'    Get Value From Dropdown List    ${cbo_policystatus${index}}
    \    Run Keyword If    '${actual_policy_reason}' == '${expected_policy_reason}'    Run Keyword And Continue On Failure    Run Keywords    List Should Not Contain Value    ${actual_list}
    \    ...    ${policy_status}
    \    ...    AND    Exit For Loop
    [Teardown]    Take Screenshot

Verify Policy Status Is Blank By Default
    [Arguments]    ${expected_policy_reason}
    : FOR    ${index}    IN RANGE    0    10
    \    ${isVisible}    Control Command    Power Express    ${EMPTY}    [NAME:clblPolicyReason${index}]    IsVisible
    \    ...    ${EMPTY}
    \    Run Keyword If    '${isVisible}' != '1'    Run Keyword And Continue On Failure    FAIL    Policy reason not found in list: ${expected_policy_reason}
    \    Exit For Loop If    '${isVisible}' != '1'
    \    ${actual_policy_reason}    Get Control Text Value    [NAME:clblPolicyReason${index}]
    \    Run Keyword If    '${actual_policy_reason}' == '${expected_policy_reason}'    Run Keywords    Verify Control Object Text Value Is Correct    ${cbo_policystatus${index}}    ${EMPTY}
    \    ...    AND    Exit For Loop
    [Teardown]    Take Screenshot

Verify Quick Amend Is Not Visible
    Verify Control Object Is Not Visible    ${label_quick_amend}
    Verify Control Object Is Not Visible    ${button_quick_amend}
    [Teardown]    Take Screenshot

Verify Quick Amend Is Visible
    Verify Control Object Is Visible    ${label_quick_amend}
    Verify Control Object Is Visible    ${button_quick_amend}
    [Teardown]    Take Screenshot

Verify Quick Amend Spiel Is Not Visible
    Verify Control Object Is Visible    ${label_quick_amend}
    [Teardown]    Take Screenshot

Verify Quick Amend Spiel Is Visible
    [Arguments]    ${expected_text}
    Verify Control Object Text Value Is Correct    ${label_quick_amend}    ${expected_text}
    [Teardown]    Take Screenshot

Verify RIR On Hold Reason Remarks Are Not Written
    [Arguments]    @{on_hold_remarks}
    @{on_hold_remarks}    Get Variable Value    ${on_hold_reasons_unselected}    ${on_hold_remarks}
    : FOR    ${remark}    IN    @{on_hold_remarks}
    \    Verify Specific Line Is Not Written In The PNR    RIR ON HOLD:${remark.upper()}

Verify RIR On Hold Reason Remarks Are Written
    [Arguments]    @{on_hold_remarks}
    @{on_hold_remarks}    Get Variable Value    ${on_hold_reasons_selected}    ${on_hold_remarks}
    : FOR    ${remark}    IN    @{on_hold_remarks}
    \    Verify Specific Line Is Written In The PNR    RIR ONHOLD:${remark.upper()}

Verify Remarks For Ticketing Type TKTL Line In PNR
    [Arguments]    ${verify_remark}    ${pcc}    ${queue_number}    ${queue_category}
    [Documentation]    ${verify_remark} is Expects Boolean Value
    ...    If the Value: True->It will verifies Remarks is written
    ...    If the Value: False->It will verifies Remarks is Not written
    Get Ticketing Date
    ${ticketing_date}    Convert Date To GDS Format    ${ticketing_date}    %m/%d/%Y
    Run Keyword If    "${verify_remark.lower()}"=="true"    Verify Specific Line Is Written In The PNR    TK TL${ticketing_date}/${pcc}/Q${queue_number}C${queue_category}-TLXL-PENDING
    Run Keyword If    "${verify_remark.lower()}"=="false"    Verify Specific Line Is Not Written In The PNR    TK TL${ticketing_date}/${pcc}/Q${queue_number}C${queue_category}-TLXL-PENDING

Verify Remarks for Itinerary Type
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}
    Verify Specific Line Is Written In The PNR    OP ${pcc}/${current_date}/${queue_number}${queue_category}/SEND ITINERARY

Verify Specific On Hold Reason Status
    [Arguments]    ${on_hold_reason}    ${is_tick}
    ${actual_status}    Get On Hold Reason Checkbox Status    ${on_hold_reason}
    Verify Actual Value Matches Expected Value    ${actual_status}    ${is_tick}
    Take Screenshot

Verify Specific Remark Is Not Written X Times In The PNR
    [Arguments]    ${expected_remark}    ${occurence}
    ${actual_count_match}    Get Count    ${pnr_details}    ${expected_remark}
    Run Keyword And Continue On Failure    Run Keyword If    ${actual_count_match} <= ${occurence}    Log    PASS: "${expected_remark}" was not written more than "${occurence}" times in the PNR.
    ...    ELSE    FAIL    "${expected_remark}" was written "${actual_count_match}" times in the PNR and not the expected count: " ${occurence}"

Verify Subject Line Field Is Not Mandatory
    Verify Control Object Field Is Not Mandatory    [NAME:cboSubjectLine]
    [Teardown]    Take Screenshot

Verify Subject Line Option Is Retain Same
    [Arguments]    ${subject_line_value}
    Verify Control Object Text Contains Expected Value    [NAME:cboSubjectLine]    ${subject_line_value}

Verify TAW Line For No On-Hold Reason Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${on_hold_reason}
    ${ticketing_date}    Convert Date To Gds Format    ${default_ticketing_date}    %m/%d/%Y
    ${taw_time}    Set Variable If    "${current_date}" == "${ticketing_date}"    0400A    ${EMPTY}
    ${expected_taw_line}    Set Variable If    "${taw_time}" == "${EMPTY}"    TAW${pcc}QT${ticketing_date}    TAW${pcc}QT${ticketing_date}/${taw_time}
    Verify Specific Line Is Not Written In The PNR    ${expected_taw_line}

Verify TAW Line For No On-Hold Reason Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}
    ${ticketing_date}    Convert Date To Gds Format    ${default_ticketing_date}    %m/%d/%Y
    ${taw_time}    Set Variable If    "${current_date}" == "${ticketing_date}"    0400A    ${EMPTY}
    ${expected_taw_line}    Set Variable If    "${taw_time}" == "${EMPTY}"    TAW${pcc}QT${ticketing_date}    TAW${pcc}QT${ticketing_date}/${taw_time}
    Verify Specific Line Is Written In The PNR    ${expected_taw_line}

Verify TAW Line For On-Hold Reason Is Not Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${on_hold_reason}
    ${ticketing_date}    Convert Date To Gds Format    ${default_ticketing_date}    %m/%d/%Y
    ${taw_time}    Set Variable If    "${current_date}" == "${ticketing_date}"    0400A    ${EMPTY}
    ${expected_on_hold_reason}    Run Keyword If    "${on_hold_reason}" == "Awaiting Secure Flight Data"    Set Variable    ONHOLD.AWAITING.SECURE.FLIGHT.DATA
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Customer References"    Set Variable    ONHOLD.AWAITING.CUSTOMER.REFERENCES
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Fare Details"    Set Variable    ONHOLD.AWAITING.FARE.DETAILS
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Approval"    Set Variable    ONHOLD.AWAITING.APPROVAL
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Itinerary Segment"    Set Variable    ONHOLD.AWAITING.ITINERARY.SEGMENT
    ...    ELSE    Set Variable    ${EMPTY}
    ${expected_taw_line}    Set Variable If    "${taw_time}" == "${EMPTY}"    TAW${pcc}${ticketing_date}${queue_number}/${expected_on_hold_reason}    TAW${pcc}${ticketing_date}${queue_number}/${taw_time}/${expected_on_hold_reason}
    Verify Specific Line Is Not Written In The PNR    ${expected_taw_line}

Verify TAW Line For On-Hold Reason Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${on_hold_reason}
    ${taw_time}    Set Variable If    "${date_today}" == "${ticketing_date}"    ${EMPTY}    0400A
    ${date_format}    Set Variable If    "${gds_switch}" == "sabre"    %d%B    %m/%d/%Y
    ${ticketing_date}    Convert Date To Gds Format    ${default_ticketing_date}    ${date_format}
    ${expected_on_hold_reason}    Run Keyword If    "${on_hold_reason}" == "Awaiting Secure Flight Data"    Set Variable    HOLD.AWAITING.SECURE.FLIGHT.DATA
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Customer References"    Set Variable    HOLD.AWAITING.CUSTOMER.REFERENCES
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Fare Details"    Set Variable    HOLD.AWAITING.FARE.DETAILS
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Approval"    Set Variable    HOLD.AWAITING.APPROVAL
    ...    ELSE IF    "${on_hold_reason}" == "Awaiting Itinerary Segment"    Set Variable    HOLD.AWAITING.ITINERARY.SEGMENT
    ...    ELSE    Set Variable    ${EMPTY}
    ${expected_taw_line}    Set Variable If    "${taw_time}" == "${EMPTY}"    TAW${pcc}${ticketing_date}${queue_number}/${expected_on_hold_reason}    TAW${pcc}${ticketing_date}${queue_number}/${taw_time}/${expected_on_hold_reason}
    Verify Specific Line Is Written In The PNR    ${expected_taw_line}

Verify TK OK Is Written In The PNR
    [Arguments]    ${pcc}
    Get Ticketing Date
    ${ticketing_date}    Convert Date To GDS Format    ${ticketing_date}    %m/%d/%Y
    Verify Specific Line Is Written In The PNR    TK OK${ticketing_date}/${pcc}

Verify TK TL Is Written In The PNR
    [Arguments]    ${pcc}    ${queue_number}    ${queue_category}    ${has_onhold}=false
    Get Ticketing Date
    ${ticketing_date}    Convert Date To GDS Format    ${ticketing_date}    %m/%d/%Y
    ${ticketing_element_remark}    Set Variable If    "${has_onhold.lower()}" == "true"    TK TL${ticketing_date}/${pcc}/Q${queue_number}C${queue_category}-ONHOLD    TK TL${ticketing_date}/${pcc}/Q${queue_number}C${queue_category}
    Verify Specific Line Is Written In The PNR    ${ticketing_element_remark}

Verify TK XL Is Written In The PNR
    [Arguments]    ${pcc}    ${ticketing_time_configured}
    Get Ticketing Date
    ${ticketing_date}    Convert Date To GDS Format    ${ticketing_date}    %m/%d/%Y
    Verify Specific Line Is Written In The PNR    TK XL${ticketing_date}/${ticketing_time_configured}/${pcc}

Verify That Correct Subject Line is Selected
    [Arguments]    ${SubjectLine}
    Verify Control Object Text Value Is Correct    [NAME:cboSubjectLine]    ${SubjectLine}

Verify Email Address Details In Choose/Add Recipients
    [Arguments]    ${index}    ${expected_email}    ${itinerary_checkbox_expected}    ${invoice_checkbox_expected}
    ${actual_email}    Get Email Address
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_email[${index}]}    ${expected_email}    Actual and Expected Email should be the same.
    ${checkbox_status}    Get checkbox status    [NAME:cchkItinerary${index}]
    Run Keyword And Continue On Failure    Should Be Equal    ${checkbox_status}    ${itinerary_checkbox_expected}    Receive Itinerary checkbox Status should be ${itinerary_checkbox_expected}.
    ${checkbox_status_invoice}    Get checkbox status    [NAME:chkInvoice${index}]
    Run Keyword And Continue On Failure    Should Be Equal    ${checkbox_status_invoice}    ${invoice_checkbox_expected}    Receive Invoice checkbox Status should be ${invoice_checkbox_expected}
    [Teardown]    Take Screenshot

Verify That Follow Up Date Is Not Visible
    Verify Control Object Is Not Visible    [NAME:uccFollowupDate]
    [Teardown]    Take Screenshot

Verify That Subject Line Dropdown Is Not Visible
    Verify Control Object Is Not Visible    [NAME:cboSubjectLine]
    Click Finish PNR

Verify That Subject Line Dropdown Is Visible
    Verify Control Object Is Visible    [NAME:cboSubjectLine]

Verify That Subject Line Dropdown Is Visible,Empty And Mandatory
    Verify Control Object Is Visible    [NAME:cboSubjectLine]
    Verify Control Object Text Contains Expected Value    [NAME:cboSubjectLine]    ${EMPTY}
    Verify Control Object Background Color    [NAME:cboSubjectLine]    FFD700
    [Teardown]    Take Screenshot

Verify The E-Mail Address On Contact Tab
    [Arguments]    ${tab_name}    ${email_address_expected}    ${traveller_option}=${EMPTY}    ${contact_option}=${EMPTY}
    ${email_address}    Get Email Address From Contact Tab    ${tab_name}
    Run Keyword And Continue On Failure    Should Be Equal    ${email_address}    ${email_address_expected}    Actual and Expected Email should be the same.
    Run Keyword If    "${traveller_option}" == "True"    Tick Traveller Checkbox
    ...    ELSE IF    "${traveller_option}" == "False"    Untick Traveller Checkbox
    Run Keyword If    "${contact_option}" == "True"    Tick Contact Checkbox
    ...    ELSE IF    "${contact_option}" == "False"    Untick Contact Checkbox

Verify The PNR Is Sent To Correct Queue Number
    [Arguments]    ${pcc}    ${queue_number}
    ${pnr_details}    Get String Between Strings    ${pnr_details}    CURRENTLY ON QUEUE    LOGGED HISTORY
    Verify Specific Line Is Written In The PNR    ${pcc} ${queue_number.zfill(4)}/011 \ \ \ \ \ ${current_date}[0-9]{2}/[0-9]{4} PLACED    true

Verify Ticketing Date Error Tooltip Message Is Correct
    [Arguments]    ${expected_tooltip_text}
    Verify Tooltip Text Is Correct Using Coords    237    621    ${expected_tooltip_text}

Verify Ticketing Date Field In PNR Is Not Changed
    Run Keyword If    '${gds_switch}' == 'apollo'    Get Ticketing Line From Apollo PNR
    Run Keyword If    '${gds_switch}' == 'sabre'    Get Ticketing Line From Sabre PNR
    Click Panel    Delivery
    ${ticketing_date_express}    Get Control Text Value    [NAME:uccTicketingDate]
    Should Be Equal As Strings    ${ticketing_date_express}    ${ticketing_date}

Verify Ticketing Date Field Value
    [Arguments]    ${expected_ticketing_date_value}=${EMPTY}    ${custom_message}=${EMPTY}
    ${ticketing_date}    Get Variable Value    ${ticketing_date}    ${expected_ticketing_date_value}
    Comment    ${expected_ticketing_date_value}    Set Variable If    ${expected_ticketing_date_value}!=${EMPTY}    ${expected_ticketing_date_value}    ${ticketing_date}
    Verify Control Object Text Value Is Correct    [NAME:uccTicketingDate]    ${ticketing_date}    ${custom_message}
    [Teardown]    Take Screenshot

Verify Ticketing Date Field Value Is Current Date
    ${current_date}    SyexDateTimeLibrary.Get Current Date
    Verify Ticketing Date Field Value    ${current_date}

Verify Ticketing Date Field Value Is LDT-1
    Verify Ticketing Date Field Value    ${ldt-1}    Ticketing date field should be LDT - 1 and should be equal to ${ldt-1}

Verify Ticketing Date Field Value Is Ticketing Date From PNR
    Verify Ticketing Date Field Value    ${ticketing_date}

Verify Ticketing Date Field Value Is Travel Date-1
    Verify Ticketing Date Field Value    ${travel_date-1}    Ticketing Date should be Traveldate - 1 and should be equal to ${travel_date-1}

Verify Ticketing Date Warning Tooltip Message Is Correct
    [Arguments]    ${expected_tooltip_text}
    Run Keyword And Continue On Failure    Verify Tooltip Text Is Correct Using Coords    237    619    ${expected_tooltip_text}

Verify Ticketing RIR Remarks
    [Arguments]    ${ticket_info}    ${is_apac}=False    ${is_send_itin}=False
    ${default_ticketing_date}    Run Keyword If    ${is_send_itin}    Set Variable    ${ticketing_date}
    ...    ELSE    Get Default Ticketing Date
    ${default_ticketing_date}    Convert Date To Defined Format    ${default_ticketing_date}    %m/%d/%Y    %d/%m/%Y
    ${tlis_remark}    Set Variable If    "${is_apac}" == "True"    RIR *TLIS**${default_ticketing_date}*    RIR *TLIS*YOUR TICKETS WILL BE ISSUED ON *${default_ticketing_date}*
    ${tlxl_remark}    Set Variable If    "${is_apac}" == "True"    RIR *TLXL**${default_ticketing_date}*    RIR *TLXL*TICKETING DATE NOT SET CONFIRM BY *${default_ticketing_date}*
    Run Keyword If    "${ticket_info}" == "TLIS"    Verify Specific Line Is Written In The PNR    ${tlis_remark}
    ...    ELSE IF    "${ticket_info}" == "TLXL"    Verify Specific Line Is Written In The PNR    ${tlxl_remark}
    Run Keyword If    "${is_apac}" == "False"    Verify RIR On Hold Reason Remarks Are Written

Verify Ticketing Time Limit Field Is Enabled
    Verify Control Object Is Enabled    [NAME:ccboTimeLimit]
    [Teardown]    Take Screenshot

Verify Ticketing Time Limit Field Is Visible
    Verify Control Object Is Visible    [NAME:ccboTimeLimit]
    [Teardown]    Take Screenshot

Verify Ticketing Time Limit Field Value
    [Arguments]    ${expected_ticketing_time_limit_value}
    Verify Control Object Text Value Is Correct    [NAME:ccboTimeLimit]    ${expected_ticketing_time_limit_value}
    [Teardown]    Take Screenshot

Verify Time Limit Remarks Field Is Enabled
    Verify Control Object Is Enabled    [NAME:ctxtTimeRemarks]
    [Teardown]    Take Screenshot

Verify Time Limit Remarks Field Is Visible
    Verify Control Object Is Visible    [NAME:ctxtTimeRemarks]
    [Teardown]    Take Screenshot

Verify Time Limit Remarks Field Value
    [Arguments]    ${expected_ticket_time_limit_remarks}
    Verify Control Object Text Value Is Correct    [NAME:ctxtTimeRemarks]    ${expected_ticket_time_limit_remarks}
    [Teardown]    Take Screenshot

Verify Travel Date-1 Is Written In The Ticketing Line
    ${travel_date-1_syex}    Convert Date To Gds Format    ${travel_date-1}    %m/%d/%Y
    Run Keyword If    "${GDS_Switch.lower()}" == "sabre"    Verify Specific Line Is Written In The PNR    TAW3W7FQC/ETK ${travel_date-1_syex} HOLD AWAITING.
    ...    ELSE IF    "${GDS_Switch.lower()}" == "apollo"    Verify Specific Line Is Written In The PNR    TKTG-TAU/${travel_date-1_syex}¤24LY/ETK.HOLD.AWAITING.SECURE.FLIGHT.DATA

Verify Ticketing RMM Remarks Are Written
    [Arguments]    @{on_hold_remarks}
    @{on_hold_remarks}    Get Variable Value    ${on_hold_reasons_selected}    ${on_hold_remarks}
    : FOR    ${on_hold}    IN    @{on_hold_remarks}
    \    Verify Specific Line Is Written In The PNR    RMM ONHOLD:${on_hold.upper()}

Verify Ticketing RMM Remarks Are Not Written
    [Arguments]    @{on_hold_remarks}
    @{on_hold_remarks}    Get Variable Value    ${on_hold_reasons_unselected}    ${on_hold_remarks}
    : FOR    ${on_hold}    IN    @{on_hold_remarks}
    \    Verify Specific Line Is Not Written In The PNR    RMM ONHOLD:${on_hold.upper()}
