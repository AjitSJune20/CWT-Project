*** Settings ***
Resource          ../common/utilities.robot
Resource          ../panels/gds_screen.robot

*** Keywords ***
Activate Amadeus Selling Platform
    [Arguments]    ${clear_form}=True
    Comment    Win Activate    SELLING PLATFORM    ${EMPTY}
    Comment    Handle Amadeus Popup
    Comment    Control Focus    SELLING PLATFORM    ${EMPTY}    [CLASS:RichEdit20A; INSTANCE:1]
    Comment    Run Keyword If    ${clear_form} == True    Run Keywords    Send    {SHIFTDOWN}{PAUSE}{SHIFTUP}
    ...    AND    Sleep    1
    Activate Power Express Window
    Click GDS Screen Tab

Activate Amadeus TST Webpage Dialog
    Win Activate    TST -- Webpage Dialog    ${EMPTY}
    Comment    Control Click    TST -- Webpage Dialog    ${EMPTY}    [CLASS:Internet Explorer_Server; INSTANCE:1]
    Sleep    1

Add YQ tax for TST ${segment_number}
    Activate Amadeus Selling Platform
    Send    {SHIFTDOWN}{PAUSE}{SHIFTUP}
    Sleep    2
    Send    TQT/T${segment_number}{ENTER}
    Wait Until Window Exists    TST -- Webpage Dialog    60    5
    Activate Amadeus TST Webpage Dialog
    Send    {TAB 22}
    Send    {SPACE}
    ${list_of_taxes_appeared}    Run Keyword and Return Status    Wait Until Window Exists    List of taxes -- Webpage Dialog    15    1
    Run Keyword If    ${list_of_taxes_appeared} == False    Wait Until Window Exists    Listes des taxes -- Webpage Dialog    15    1
    ${tax_window_title}    Set Variable If    ${list_of_taxes_appeared} == False    Listes des taxes -- Webpage Dialog    List of taxes -- Webpage Dialog
    Win Activate    ${tax_window_title}    ${EMPTY}
    Send    {TAB 16}
    Sleep    2
    Send    3.33
    Sleep    2
    Send    {TAB}
    Sleep    2
    Send    YQ
    Sleep    2
    Send    {ENTER}
    Wait Until Window Exists    TST -- Webpage Dialog    20    1
    Send    {ENTER}
    ${webdialog_appeared}    Run Keyword and Return Status    Wait Until Window Exists    Selling Platform messages -- Webpage Dialog    20    1
    Run Keyword If    ${webdialog_appeared} == False    Wait Until Window Exists    Selling Platform Messages Selling Platform -- Webpage Dialog    20    1
    ${webdialog_title}    Set Variable If    ${webdialog_appeared} == False    Selling Platform messages -- Webpage Dialog    Selling Platform Messages Selling Platform -- Webpage Dialog
    Run Keyword If    ${webdialog_appeared} == True    Run Keywords    Win Activate    ${webdialog_title}
    ...    AND    Send    {ENTER}
    Win Close    TST -- Webpage Dialog    ${EMPTY}
    Sleep    5

Cancel Amadeus PNR
    [Arguments]    ${current_pnr}    ${void_ticket}=False
    Click GDS Screen Tab
    Run Keyword If    '${void_ticket}' == 'True'    Void Ticket Number For Amadeus    ${current_pnr}
    Enter GDS Command    RT${current_pnr}    IR
    : FOR    ${INDEX}    IN RANGE    10
    \    ${data_clipboard}    Get Clipboard Data Amadeus    RTI
    \    ${has_no_itin}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    AUCUN ELEMENT TROUVE    NO ELEMENT FOUND
    \    ...    ES WURDE KEIN ELEMENT GEFUNDEN
    \    Exit For Loop If    ${has_no_itin}
    \    Enter GDS Command    TTE/ALL
    \    ${data_clipboard}    Get Clipboard Data Amadeus    XI
    \    ${is_restricted_use_xe}    Run Keyword And Return Status    Should Contain    ${data_clipboard}    USE XE
    \    Run Keyword If    ${is_restricted_use_xe}    Enter GDS Command    XE2
    \    Exit For Loop If    not ${is_restricted_use_xe}
    Enter GDS Command    XI
    Comment    ${counter}    Set Variable    0
    Comment    ${number_of_xe2}    Run Keyword If    "${number_of_xe2}" != "${EMPTY}"    Convert To Integer    ${number_of_xe2}
    ...    ELSE    Set Variable    ${EMPTY}
    Comment    : FOR    ${counter}    IN RANGE    5
    Comment    \    Exit For Loop If    "${number_of_xe2}" == "${EMPTY}" or "${number_of_xe2}" == "0"
    Comment    \    Enter GDS Command    RTI{ENTER}
    Comment    \    ${data_clipboard}    Get Clipboard Data Amadeus
    Comment    \    ${has_no_itin}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    AUCUN ELEMENT TROUVE
    ...    NO ELEMENT FOUND    ES WURDE KEIN ELEMENT GEFUNDEN
    Comment    \    Exit For Loop If    ${has_no_itin} == True
    Comment    \    Enter GDS Command    XE2{ENTER}
    Comment    \    ${counter}    Evaluate    ${counter} + 1
    Comment    \    Exit For Loop If    ${counter} == ${number_of_xe2}
    Enter GDS Command    RFCWTPTEST    ER
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${is_simultaneous_changes}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    SIMULT    PARALLEL
    Run Keyword If    ${is_simultaneous_changes} == True    Cancel Amadeus PNR    ${current_pnr}
    Enter GDS Command    IG    RT${current_pnr}    RTI
    ${data_clipboard}    Get Clipboard Data Amadeus
    Should Contain Any    ${data_clipboard}    AUCUN ELEMENT TROUVE    NO ELEMENT FOUND    ES WURDE KEIN ELEMENT GEFUNDEN    msg=${current_pnr} still has itinerary segments    values=False

Change Tax Value For TST ${segment_number}
    Activate Amadeus Selling Platform
    Send    {SHIFTDOWN}{PAUSE}{SHIFTUP}
    Sleep    1
    Send    IR{ENTER}
    Sleep    2
    Send    RT${current_pnr}{ENTER}
    Sleep    2
    Send    {SHIFTDOWN}{PAUSE}{SHIFTUP}
    Sleep    1
    Send    TQT/T${segment_number}{ENTER}
    Wait Until Window Exists    TST -- Webpage Dialog    60    5
    Activate Amadeus TST Webpage Dialog
    Take Screenshot
    Send    {TAB 22}
    Send    {SPACE}
    ${list_of_taxes_appeared}    Run Keyword and Return Status    Wait Until Window Exists    List of taxes -- Webpage Dialog    15    1
    Run Keyword If    ${list_of_taxes_appeared} == False    Wait Until Window Exists    Listes des taxes -- Webpage Dialog    15    1
    ${tax_window_title}    Set Variable If    ${list_of_taxes_appeared} == False    Listes des taxes -- Webpage Dialog    List of taxes -- Webpage Dialog
    Win Activate    ${tax_window_title}    ${EMPTY}
    Clear Data From Clipboard
    Send    {TAB}
    Send    ^c
    ${data_clipboard} =    Clip Get
    Take Screenshot
    ${adjusted_tax_amount} =    Evaluate    ${data_clipboard} + 5
    Send    ${adjusted_tax_amount}
    Take Screenshot
    Send    {ENTER}
    Wait Until Window Exists    TST -- Webpage Dialog    20    1
    Send    {ENTER}
    ${webdialog_appeared}    Run Keyword and Return Status    Wait Until Window Exists    Selling Platform messages -- Webpage Dialog    20    1
    Run Keyword If    ${webdialog_appeared} == False    Wait Until Window Exists    Selling Platform Messages Selling Platform -- Webpage Dialog    20    1
    ${webdialog_title}    Set Variable If    ${webdialog_appeared} == False    Selling Platform messages -- Webpage Dialog    Selling Platform Messages Selling Platform -- Webpage Dialog
    Run Keyword If    ${webdialog_appeared} == True    Run Keywords    Win Activate    ${webdialog_title}
    ...    AND    Send    {ENTER}
    Take Screenshot
    Sleep    1
    Send    {ESC}
    Sleep    1
    Win Close    TST -- Webpage Dialog    ${EMPTY}
    Sleep    5
    [Teardown]

Clear Amadeus GDS Screen
    Activate Amadeus Selling Platform
    Comment    Send    {SHIFT}+{PAUSE}

Create Amadeus Offer
    [Arguments]    ${itinerary}    ${seat_select}    ${store_fare}    ${number_of_months}=6    ${number_of_days}=0    ${store_offer}=FXD
    Book Flight X Months From Now    ${itinerary}    ${seat_select}    ${store_fare}
    Enter GDS Command    ${store_offer}
    Select Offer Automatically Based On Recommended List

Create Amadeus Offer Remove Flight
    [Arguments]    ${segment_number}
    ${segment_number}    Replace String    ${segment_number}    FXX/    ${EMPTY}
    Enter GDS Command    FXX/${segment_number}
    ${data_clip}    Get Data From GDS Screen    OFS/A
    Should Not Contain    ${data_clip}    NO FARE DATA FOUND    msg=NO FARE DATA FOUND; Alternate fare will not be created    values=False
    ENter GDS Command    OFS/A

Create Amadeus Offer Retain Flight
    [Arguments]    ${segment_number}=${EMPTY}
    ${segment_number}    Replace String    ${segment_number}    FXD/    ${EMPTY}
    ${create_offer_retain_flight_command}    Set Variable If    "${segment_number}" != "${EMPTY}"    FXD/${segment_number}    FXD
    Enter GDS Command    ${create_offer_retain_flight_command}
    Select Offer Automatically Based On Recommended List

Create Multiple Offers And Retain Segment
    [Arguments]    ${number_of_offers}
    Enter GDS Command    FXD
    ${offer_number}    Set Variable    1
    ${number_of_offers_counter}    Set Variable    1
    Convert To Integer    ${offer_number}
    Convert To Integer    ${number_of_offers_counter}
    : FOR    ${INDEX}    IN RANGE    10
    \    ${gds_resp}    Get Clipboard Data Amadeus    OFS/A${offer_number}
    \    ${is_unable_to_price}    Run Keyword And Return Status    Should Contain    ${gds_resp}    NO FARE FOR BOOKING CODE-TRY OTHER PRICING OPTIONS
    \    Exit For Loop If    ${offer_number} == ${number_of_offers} and ${is_unable_to_price} == False
    \    ${offer_number}    Evaluate    ${offer_number} + 1

Determine Amadeus Offer Remark Lines
    [Arguments]    ${current_pnr}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Set Test Variable    ${counter}    0
    ${start_line_number}    Get Line Number In Amadeus PNR Remarks    RIR \\*OFFER\\*\\*
    @{pnr_details_list}    Split To Lines    ${pnr_details}
    : FOR    ${line}    IN    @{pnr_details_list}
    \    ${eval_line} =    Run Keyword and Return Status    Should Contain    ${line}    RIR *OFFER**
    \    ${counter}    Run Keyword If    "${eval_line}" == "True"    Evaluate    ${counter} + 1
    \    ...    ELSE    Evaluate    ${counter} + 0
    ${number_of_remarks}    Evaluate    ${counter} - 1
    ${number_of_remarks}    Convert To Integer    ${number_of_remarks}
    ${last_line_number}    Evaluate    ${start_line_number} + ${number_of_remarks}
    Set Test Variable    ${offer_line_numbers}    ${start_line_number}-${last_line_number}

Determine Specific Amadeus Offer Remark Lines
    [Arguments]    ${current_pnr}    ${offer_number}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    ${start_line_number}    Get Line Number In Amadeus PNR Remarks    RIR \\*OFFER\\*\\*\\<B\\>PROPOSITION NO ${offer_number}\\<\\/B\\>
    ${pnr_details}    Get String Between Strings    ${pnr_details}    RIR *OFFER**<B>PROPOSITION NO ${offer_number}</B>*    RIR *OFFER**DETAILS
    ${last_line_number}    Evaluate    ${start_line_number} + 9
    Set Test Variable    ${offer_line_numbers}    ${start_line_number}-${last_line_number}

Get Air Segments From GDS
    ${raw_air_segments}    Get Data From GDS Screen    RTA    True
    ${air_segments_lines}    Get Lines Matching Regexp    ${raw_air_segments}    \\s+\\d\\s{1}.*
    @{air_segments_lines}    Split To Lines    ${air_segments_lines}
    @{air_segments}    Create List
    : FOR    ${each_item}    IN    @{air_segments_lines}
    \    ${each_item}    Split String    ${each_item.strip()}    ${SPACE}
    \    ${each_item}    Remove Empty Value From List    ${each_item}
    \    ${each_item}    Evaluate    " ".join(${each_item[:10]})
    \    Append To List    ${air_segments}    ${each_item}
    \    Log    ${each_item[:8]}
    ${list_length}    Get Length    ${air_segments}
    ${air_segments}    Run Keyword If    ${list_length} < 2    Evaluate    "".join(${air_segments})
    ...    ELSE    Set Variable    ${air_segments}
    Set Suite Variable    ${air_segments}
    Set Test Variable    ${segments_list}    ${air_segments}
    [Return]    ${air_segments}

Get Amadeus Offer Amount
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Amadeus Selling Platform
    Enter GDS Command    RT    RTOF
    Get Clipboard Data Amadeus
    ${total_offer_line} =    Get Lines Containing String    ${data_clipboard}    ${fare_tab_index} OFFER
    ${total_offer_amount} =    Get String Using Marker    ${total_offer_line}    TOTAL    EUR
    ${total_offer_amount} =    Remove All Non-Integer (retain period)    ${total_offer_amount}
    [Return]    ${total_offer_amount}

Get Base Fare From Amadeus
    [Arguments]    ${segment_number}    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Clear Data From Clipboard
    Activate Amadeus Selling Platform
    Enter GDS Command    RT    TQT/${segment_number}
    Get Clipboard Data Amadeus
    Get Base Fare, Currency, Tst Number And Segment Airline Code    ${fare_tab}
    Enter GDS Command    RT{ENTER}

Get Base Fare From TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    ${gds_command}/${segment_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${equiv_base_fare}    Get String Matching Regexp    (EQUIV\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${data_clipboard}
    ${base_fare}    Run Keyword If    "${equiv_base_fare}" == "0"    Get String Matching Regexp    (FARE\\s+.*?\\s+\\w+\\s+\\d+\\.?\\d+)    ${data_clipboard}
    ...    ELSE    Set Variable    ${equiv_base_fare}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare}
    ${tst0_line}    Get Lines Containing String    ${data_clipboard}    TST0
    ${tst_line_raw}    Run Keyword If    "${tst0_line}" != "${EMPTY}"    Split String    ${tst0_line}    ${SPACE}
    ...    ELSE    Split String    ${tst_line_using_segment}    ${SPACE}
    ${tst_number}    Run Keyword If    "${tst0_line}" != "${EMPTY}"    Remove String Using Regexp    ${tst_line_raw[0]}    TST.0*
    ...    ELSE    Evaluate    ''.join(${tst_line_raw[:1]})
    Set Test Variable    ${tst_number_${fare_tab_index}}    T${tst_number}
    Enter GDS Command    RT

Get Base Fare Value From Amadeus For Fare X Tab
    [Arguments]    ${fare_tab}    ${currency}
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${segment_number}    Evaluate    ${fare_index} + 1
    Retrieve PNR Details From Amadeus    ${current_pnr}    FXB/S${segment_number}
    ${base_fare}    Get String Matching Regexp    ${currency.upper()}[${SPACE},0-9]+\.[0-9][0-9][${SPACE}]+\    ${pnr_details}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    Set Test Variable    ${fare_${fare_index}_base_fare}    ${base_fare}
    Set Test Variable    ${fare_index}

Get Base Fare, Currency, Tst Number And Segment Airline Code
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${base_fare_raw}    Get Lines Containing String    ${data_clipboard}    FARE${SPACE * 2}
    ${currency}    Get Substring    ${base_fare_raw}    8    11
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare_raw}
    ${contains_period}    Run Keyword And Return Status    Should Contain    ${base_fare}    .
    ${base_fare}    Set Variable If    ${contains_period} == True    ${base_fare}    ${base_fare}.00
    ${tst_number_line}    Get Lines Containing String    ${data_clipboard}    TST0
    ${tst_number_line}    Split String    ${tst_number_line}    ${SPACE}
    ${tst_number}    Remove String Using Regexp    ${tst_number_line[0]}    TST.0*
    ${segment_airline_code_line}    Get Lines Containing String    ${data_clipboard}    .FV${SPACE}
    ${segment_airline_code}    Fetch From Right    ${segment_airline_code_line.strip()}    ${SPACE}
    ${grant_total_fare_line}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${grant_total_fare_line}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Set Suite Variable    ${grand_total_fare_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${grand_total_fare_with_currency_${fare_tab_index}}    ${total_fare_raw_splitted[-3]}${SPACE}${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${tst_number_${fare_tab_index}}    ${tst_number}
    Set Suite Variable    ${currency_${fare_tab_index}}    ${currency}
    Set Suite Variable    ${grand_total_currency_${fare_tab_index}}    ${grant_total_fare_line[12:15]}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare}
    Set Suite Variable    ${segment_airline_code_${fare_tab_index}}    ${segment_airline_code}

Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${gds_command}=TQT
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Comment    Get Base Fare From TST    ${fare_tab}    ${segment_number}
    Comment    Get Charged Fare From TST    ${fare_tab}    ${segment_number}
    Comment    Get LFCC From FV Line In TST    ${fare_tab}    ${segment_number}
    Comment    ${tax}    Evaluate    ${grand_total_fare_${fare_tab_index}} - ${base_fare_${fare_tab_index}}
    Comment    Set Suite Variable    ${total_tax_${fare_tab_index}}    ${tax}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    ${gds_command}/${segment_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${equiv_base_fare}    Get String Matching Regexp    (EQUIV\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${data_clipboard}
    ${base_fare}    Run Keyword If    "${equiv_base_fare}" == "0"    Get String Matching Regexp    (FARE\\s+.*?\\s+\\w+\\s+\\d+\\.?\\d+)    ${data_clipboard}
    ...    ELSE    Set Variable    ${equiv_base_fare}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare}
    ##Get YQ Tax
    ${yq_tax}    Get Lines Containing String    ${data_clipboard}    YQ
    ${yq_tax}    Get String Matching Regexp    [0-9]+\-YQ    ${yq_tax}
    ${yq_tax}    Run Keyword If    "${yq_tax}" != "0"    Fetch From Left    ${yq_tax}    -
    Run Keyword If    "${yq_tax}" == "${EMPTY}" or "${yq_tax}" == "None"    Set Test Variable    ${yq_tax}    0
    ${yq_tax}    Remove All Non-Integer (retain period)    ${yq_tax}
    Set Suite Variable    ${yq_tax_${fare_tab_index}}    ${yq_tax}
    ##Get K3 Tax
    ${k3_tax}    Get Lines Containing String    ${data_clipboard}    YQ
    ${k3_tax}    Get String Matching Regexp    [0-9]+\-K3    ${k3_tax}
    ${k3_tax}    Run Keyword If    "${k3_tax}" != "0"    Fetch From Left    ${k3_tax}    -
    Run Keyword If    "${k3_tax}" == "${EMPTY}" or "${k3_tax}" == "None"    Set Test Variable    ${k3_tax}    0
    ${k3_tax}    Remove All Non-Integer (retain period)    ${k3_tax}
    Set Suite Variable    ${k3_tax_${fare_tab_index}}    ${k3_tax}
    ###TOTAL
    ${total_raw}    Get Lines Containing String    ${data_clipboard}    TOTAL${SPACE}${SPACE}${SPACE}
    ${total_raw_splitted}    Split String    ${total_raw}    ${SPACE}
    ${total_raw_splitted}    Remove Duplicate From List    ${total_raw_splitted}
    Set Suite Variable    ${total_${fare_tab_index}}    ${total_raw_splitted[3]}
    Set Suite Variable    ${total_with_currency_${fare_tab_index}}    ${total_raw_splitted[2]}${SPACE}${total_raw_splitted[3]}
    ###TOTAL TAX
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${total_fare_raw}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Set Suite Variable    ${grand_total_fare_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${grand_total_value_${fare_tab_index}}    ${grand_total_fare_${fare_tab_index}}
    Set Suite Variable    ${grand_total_fare_with_currency_${fare_tab_index}}    ${total_fare_raw_splitted[-3]}${SPACE}${total_fare_raw_splitted[-1]}
    Run Keyword If    "${total_${fare_tab_index}}" != "${grand_total_fare_${fare_tab_index}}"    Set Suite Variable    ${grand_total_fare_${fare_tab_index}}    ${total_${fare_tab_index}}
    ###OB FEE
    ${ob_fee}=    Run Keyword If    '${grand_total_value_${fare_tab_index}}'!='${total_${fare_tab_index}}'    Evaluate    ${grand_total_value_${fare_tab_index}}-${total_${fare_tab_index}}
    ...    ELSE    Set Variable    0
    Set Test Variable    ${ob_fee_${fare_tab_index}}    ${ob_fee}
    ###LFCC
    ${lfcc}    Get Regexp Matches    ${data_clipboard}    (\\s.*\\d\.FV)(\\s+\\w+)    2
    ${lfcc}    Convert List To Lines    ${lfcc}
    Set Suite Variable    ${lfcc_in_tst_${fare_tab_index}}    ${lfcc.strip()}
    ##TAX
    ${tax}    Evaluate    ${grand_total_fare_${fare_tab_index}} - ${base_fare_${fare_tab_index}}
    Set Suite Variable    ${total_tax_${fare_tab_index}}    ${tax}
    ${tax}    Evaluate    ${grand_total_fare_${fare_tab_index}} - ${base_fare_${fare_tab_index}} - ${yq_tax}
    Set Suite Variable    ${total_tax_minus_yq_${fare_tab_index}}    ${tax}
    ##Get TST Number
    ${tst0_line}    Get Regexp Matches    ${data_clipboard}    (TST0\*\\d|PQR\\s\*?\\d)
    ${tst0_line}    Set Variable    ${tst0_line[0]}
    Set Test Variable    ${tst_number_${fare_tab_index}}    T${tst0_line[-1]}

Get Car Charged Rate From Amadeus
    [Arguments]    ${match_order}=0    ${car_identifier}=RG
    [Documentation]    Retrieves expected charged fare from GDS Screen. If there are multiple car segments that have RG or RQ block, make sure to indicate the match order. car_identifier is RG or RQ
    Retrieve PNR Details From Amadeus    \    RT    False
    Comment    ${charged_rate_list}    Get Regexp Matches    ${pnr_details}    ${car_identifier}-\\s*\\w{3}(\\d*\\.*\\d{0,2})
    ${charged_rate_list}    Get Regexp Matches    ${pnr_details}    ${car_identifier}-\\S*\\D{3}\\d+(\\.\\d{2})?
    ${expected_car_charged_rate}    Remove All Non-Integer (retain period)    ${charged_rate_list[${match_order}]}
    Set Suite Variable    ${expected_car_charged_rate}

Get Charged Fare From TST
    [Arguments]    ${fare_tab}    ${segment_number}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    TQT/${segment_number}
    Get Grand Total Fare From Amadeus    ${fare_tab}
    Enter GDS Command    RT{ENTER}

Get Clipboard Data Amadeus
    [Arguments]    ${command}=${EMPTY}
    Clear Data From Clipboard
    ${data_clipboard}    Get Data From GDS Screen    ${command}    True
    Log    ${data_clipboard}
    Set Suite Variable    ${data_clipboard}
    [Teardown]    Take Screenshot
    [Return]    ${data_clipboard}

Get Grand Total Fare From Amadeus
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${total_fare_raw}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Set Suite Variable    ${grand_total_fare_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${grand_total_fare_with_currency_${fare_tab_index}}    ${total_fare_raw_splitted[-3]}${SPACE}${total_fare_raw_splitted[-1]}

Get High Fare From Amadeus
    [Arguments]    ${fare_tab}    ${currency}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${high_fare}    Get Regexp Matches    ${data_clipboard}    (01\\s+\\w+\\+*\\w*\\**\\s+\\W\\s+\\W\\s+\\w+\\s+\\W\\s+)(\\d+\.\\d+)    2
    ${high_fare}    Convert List To Lines    ${high_fare}
    ${high_fare}    Remove All Non-Integer (retain period)    ${high_fare}
    Set Test Variable    ${high_fare_${fare_tab_index}}    ${high_fare}

Get High Fare From TST
    [Arguments]    ${fare_tab}    ${segment_number}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    FXA/${segment_number}
    Get High Fare From Amadeus    ${fare_tab}    ${segment_number}
    Enter GDS Command    RT{ENTER}

Get LFCC From FV Line In TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    ${gds_command}/${segment_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${lfcc}    Get Regexp Matches    ${data_clipboard}    (\\d+.FV.*)(.\\w+)    2
    ${lfcc}    Convert List To Lines    ${lfcc}
    Set Suite Variable    ${lfcc_in_tst_${fare_tab_index}}    ${lfcc.strip()}

Get Line Number In Amadeus PNR Remarks
    [Arguments]    ${remark}
    ${remark}    Regexp Escape    ${remark}
    ${remark_line}    Get Lines Matching Regexp    ${pnr_details}    .*${remark}.*
    ${line_number}    Get Regexp Matches    ${remark_line}    \\s?(\\d+)\\s\\w+    1
    ${line_number}    Set Variable If    len(${line_number}) > ${0}    ${line_number[-1]}    ${EMPTY}
    [Return]    ${line_number}

Get Low Fare From Amadeus
    [Arguments]    ${fare_tab}    ${currency}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${low_fare}    Get Lines Matching Regexp    ${data_clipboard}    ${currency.upper()}(\\s){2,}[0-9]+(\\.[0-9]*)?\$
    ${fare_index}    Set Variable If    '${low_fare}' == '${EMPTY}'    -2    -1
    ${low_fare}    Run Keyword If    '${low_fare}' == '${EMPTY}'    Get Lines Matching Regexp    ${data_clipboard}    ${currency.upper()}(\\s){2,}\\d+\\.?\\d*\\s*\\w{3}\\d+\\.*\\d*\$
    ...    ELSE    Set Variable    ${low_fare}
    ${low_fare}    Run Keyword If    '${fare_index}'=='-1'    Split To Lines    ${low_fare}
    ...    ELSE    Split String    ${low_fare}
    ${low_fare}    Remove All Non-Integer (retain period)    ${low_fare[${fare_index}]}
    Set Test Variable    ${low_fare_${fare_tab_index}}    ${low_fare}

Get Low Fare From TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${currency}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    FXL/${segment_number}
    Get Low Fare From Amadeus    ${fare_tab}    ${currency}
    Enter GDS Command    RT{ENTER}

Get Offer Details
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${gds_screen_data}    Get Clipboard Data Amadeus    RTOF
    ${offer_detail_line}    Flatten String    ${gds_screen_data}
    @{offer_list}    Split String    ${offer_detail_line}    OFFER TOTAL
    ${flight_details}    Get From List    ${offer_list}    ${fare_tab_index}
    @{flight_details}    Split String    ${flight_details}    ${SPACE}
    ${flight_details}    Set Variable    ${flight_details[3:]}
    ${first_index_length}    Get Length    ${flight_details[1]}
    ${airline_code}    Run Keyword If    ${first_index_length} < 3    Set Variable    ${flight_details[1]}
    ...    ELSE    Get Substring    ${flight_details[1]}    0    2
    ${flight_number}    Run Keyword If    ${first_index_length} < 3    Set Variable    ${flight_details[2]}
    ...    ELSE    Get Substring    ${flight_details[1]}    2    6
    ${fare_class}    Run Keyword If    ${first_index_length} < 3    Set Variable    ${flight_details[3]}
    ...    ELSE    Set Variable    ${flight_details[2]}
    ${flight_date}    Run Keyword If    ${first_index_length} < 3    Set Variable    ${flight_details[4]}
    ...    ELSE    Set Variable    ${flight_details[3]}
    ${flight_origin}    Run Keyword If    ${first_index_length} < 3    Get Substring    ${flight_details[5]}    0    3
    ...    ELSE    Get Substring    ${flight_details[4]}    0    3
    ${flight_destination}    Run Keyword If    ${first_index_length} < 3    Get Substring    ${flight_details[5]}    3    6
    ...    ELSE    Get Substring    ${flight_details[4]}    3    6
    Run Keyword If    '${GDS_switch}' == 'amadeus' and '${locale}' == 'fr-FR'    Convert English Date To French    ${flight_date}
    Set Test Variable    ${airline_code}
    Set Test Variable    ${flight_number}
    Set Test Variable    ${fare_class}
    Set Test Variable    ${flight_date}
    Set Test Variable    ${flight_origin}
    Set Test Variable    ${flight_destination}

Get TST Details From Amadeus
    [Arguments]    ${fare_tab}    ${passenger_type}    ${segment_number}    ${tst_number}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Clear Data From Clipboard
    Activate Amadeus Selling Platform
    Enter GDS Command    RT    TQT/${passenger_type}/${segment_number}
    Get Clipboard Data Amadeus
    ${is_tst_present}    Run Keyword And Return Status    Should Contain    ${data_clipboard}    TST0
    Set Test Variable    ${is_tst_present}
    Run Keyword If    "${tst_number}" != "${EMPTY}"    Get Base Fare From Amadeus    ${tst_number}    ${fare_tab}
    Run Keyword If    ${is_tst_present} == True and "${tst_number}" == "${EMPTY}"    Get Base Fare, Currency, Tst Number And Segment Airline Code    ${fare_tab}
    ...    ELSE    Run Keywords    Get TST Number    ${segment_number}
    ...    AND    Get Base Fare From Amadeus    ${tst_number}    ${fare_tab}

Handle Amadeus Popup
    Sleep    2
    ${amadeus_viewer_exists} =    Win Exists    Amadeus Viewer    ${EMPTY}
    Run Keyword If    ${amadeus_viewer_exists} == 1    Win Activate    Amadeus Viewer    ${EMPTY}
    Run Keyword If    ${amadeus_viewer_exists} == 1    Run Keywords    Send    {TAB}
    ...    AND    Send    {ENTER}
    ...    AND    Sleep    2
    ${webpage_dialog_exists} =    Win Exists    Error -- Webpage Dialog    ${EMPTY}
    Run Keyword If    ${webpage_dialog_exists} == 1    Win Activate    Error -- Webpage Dialog    ${EMPTY}
    Run Keyword If    ${webpage_dialog_exists} == 1    Run Keywords    Send    {TAB}
    ...    AND    Send    {ESCAPE}
    ...    AND    Sleep    2
    ${amadeus_dialog_exists} =    Win Exists    Selling Platform messages
    Run Keyword If    ${amadeus_dialog_exists} == 1    Run Keywords    Win Activate    Selling Platform messages
    ...    AND    Send    {TAB}
    ...    AND    Send    {ENTER}
    ...    AND    Sleep    2

Navigate To Amadeus Command Page
    Activate Amadeus Selling Platform
    Control Click    SELLING PLATFORM    ${EMPTY}    [CLASS:Internet Explorer_Server; INSTANCE:1]    ${EMPTY}    1    124
    ...    45
    Sleep    2

Retrieve PNR Details From Amadeus
    [Arguments]    ${current_pnr}=${EMPTY}    ${command}=${EMPTY}    ${refresh_needed}=True
    Comment    Activate Amadeus Selling Platform
    Clear Data From Clipboard
    Run Keyword If    "${current_pnr}" != "${EMPTY}"    Enter GDS Command    RT${current_pnr}
    Run Keyword If    "${refresh_needed}" == "True"    Enter GDS Command    IR
    Run Keyword If    "${command}" != "${EMPTY}"    Enter GDS Command    ${command}
    ${pnr_details}    Set Variable    ${EMPTY}
    ${previous_clipboard}    Set Variable    ${EMPTY}
    : FOR    ${index}    IN RANGE    0    50
    \    ${data_clipboard}    Get Clipboard Data Amadeus
    \    ${is_not_scrollable}    Run Keyword And Return Status    Should Contain    ${data_clipboard}    REQUESTED DISPLAY NOT SCROLLABLE
    \    Run Keyword If    """${data_clipboard}""" == """${previous_clipboard}""" or ${is_not_scrollable} == True    Exit For Loop
    \    ...    ELSE    Set Test Variable    ${previous_clipboard}    ${data_clipboard}
    \    ${pnr_details} =    Catenate    SEPARATOR=${\n}    ${pnr_details}    ${previous_clipboard}
    \    Enter GDS Command    MDR
    ${sorted_pnr_details} =    Sort Pnr Details    ${pnr_details}
    Set Suite Variable    ${pnr_details}    ${sorted_pnr_details}
    Log    ${pnr_details}
    [Return]    ${pnr_details}

Retrieve PNR From Amadeus
    Comment    Activate Amadeus Selling Platform
    ${pnr_details}    Get Data From GDS Screen    RT{ENTER}    True
    Set Test Variable    ${pnr_details}

Select Offer Automatically Based On Recommended List
    ${offer_number}    Set Variable    1
    ${number_of_offers_counter}    Set Variable    1
    Convert To Integer    ${offer_number}
    Convert To Integer    ${number_of_offers_counter}
    : FOR    ${INDEX}    IN RANGE    10
    \    ${gds_resp}    Get Clipboard Data Amadeus    OFS/A${offer_number}
    \    ${is_unable_to_price}    Run Keyword And Return Status    Should Contain    ${gds_resp}    NO FARE FOR BOOKING CODE-TRY OTHER PRICING OPTIONS
    \    Exit For Loop If    ${is_unable_to_price} == False
    \    ${offer_number}    Evaluate    ${offer_number} + 1

Get Segment Number From TST
    Get All TST From Amadeus
    @{expected_fare_number}    Create List
    : FOR    ${tst}    IN    @{tst_list}
    \    ${tst_number}    Get Substring    ${tst}    0    1
    \    Append To List    ${expected_fare_number}    ${tst_number}
    Set Suite Variable    ${expected_fare_number}
    [Return]    ${expected_fare_number}

Get All TST From Amadeus
    ${raw_tst}    Get Data From GDS Screen    TQT    True
    ${tst_lines}    Get Lines Matching Regexp    ${raw_tst}    (\\s+\\d|\\d)\\s{1}.*    #hk - \\d\\s{1}.*    #sg - \\s+\\d\\s{1}.*
    @{tst_lines}    Split To Lines    ${tst_lines}
    @{tst_list}    Create List
    : FOR    ${each_item}    IN    @{tst_lines}
    \    ${each_item}    Split String    ${each_item.strip()}    ${SPACE}
    \    ${each_item}    Remove Empty Value From List    ${each_item}
    \    ${each_item}    Evaluate    " ".join(${each_item[:10]})
    \    Append To List    ${tst_list}    ${each_item}
    Set Suite Variable    ${tst_list}
    [Return]    ${tst_list}

Get Agent Login ID from Amadeus
    ${raw_data}    Get Data From GDS Screen    JGD    True
    ${sign_in_lines}    Get Lines Matching Regexp    ${raw_data}    \\s{5}\\w[SIGN].*    #hk - \\d\\s{1}.*    #sg - \\s+\\d\\s{1}.*
    ${agent_id}    Get Substring    ${sign_in_lines}    -6
    Set Suite Variable    ${agent_id}
    [Return]    ${agent_id}

Get Base Fare, Total Taxes And LFCC
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Click GDS Screen Tab
    ${data_clipboard}    Get Clipboard Data Amadeus    TQT/${segment_number}
    # BASE FARE
    ${equiv_base_fare}    Get Regexp Matches    ${data_clipboard}    EQUIV\\s+\\w+\\s+\\s(\\d+\\.?\\d*)    1
    ${base_fare}    Run Keyword If    "${equiv_base_fare}" == "[]"    Get Regexp Matches    ${data_clipboard}    FARE\\s+.*?\\s+\\w+\\s+(\\d+\\.*\\d*)    1
    ...    ELSE    Set Variable    ${equiv_base_fare}
    ${base_fare}    Convert List To Lines    ${base_fare}
    Set Suite Variable    ${base_fare_${fare_tab_index}}    ${base_fare}
    # TAX
    ${total_taxes}    Get Regexp Matches    ${data_clipboard}    TX\\d*\\s\\D\\s\\D*\\s*(\\d+\\.?\\d*)-    1
    ${total_taxes}    Evaluate    sum(map(float, ${total_taxes}))
    Set Suite Variable    ${total_tax_${fare_tab_index}}    ${total_taxes}
    # LFCC
    ${lfcc}    Get Regexp Matches    ${data_clipboard}    (\\s.*\\d\.FV)(\\s+\\w+)    2
    ${lfcc}    Convert List To Lines    ${lfcc}
    Set Suite Variable    ${lfcc_in_tst_${fare_tab_index}}    ${lfcc}
    [Return]    ${base_fare}    ${total_taxes}    ${lfcc}

Get Base Fare From Amadeus Offer
    [Arguments]    ${fare_tab}    ${gds_command}=TQQ/O1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    ${gds_command}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${equiv_base_fare}    Get String Matching Regexp    (EQUIV\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${data_clipboard}
    ${base_fare}    Run Keyword If    "${equiv_base_fare}" == "0"    Get String Matching Regexp    (FARE\\s+.*?\\s+\\w+\\s+\\d+\\.?\\d+)    ${data_clipboard}
    ...    ELSE    Set Variable    ${equiv_base_fare}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    Set Suite Variable    ${base_fare_alt_${fare_tab_index}}    ${base_fare}
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${total_fare_raw}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Set Suite Variable    ${grand_total_fare_alt_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${grand_total_value_alt_${fare_tab_index}}    ${grand_total_fare_alt_${fare_tab_index}}
    Set Suite Variable    ${grand_total_fare_with_currency_alt_${fare_tab_index}}    ${total_fare_raw_splitted[-3]}${SPACE}${total_fare_raw_splitted[-1]}
    Enter GDS Command    RT

Get Grand Total Fare From Fare Quote
    [Arguments]    ${fare_tab}=Fare Quote 1    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT
    Enter GDS Command    ${gds_command}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${total_fare_raw}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${grand_total_fare_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    ...    ELSE    Set Test Variable    ${alt_grand_total_fare_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}

Add FOP From Ticketed PNR
    [Arguments]    ${fop}
    Enter GDS Command    IG    RT${current_pnr}
    Enter GDS Command    FPCC${fop}    RFTESTPNR    ER    ER    IR
    ${rtf_lines}    Get Clipboard Data Amadeus    RTF
    Verify Text Contains Expected Value    ${rtf_lines}    \\d+\\sFP\\s.\*    true

Exchange Ticketed PNR
    [Arguments]    ${segment_number}    ${city_pair}    ${seat_select}    ${month}=7    ${day}=1    ${refresh_needed}=True
    ...    ${is_amend_workflow}=True
    ${number}    Remove All Non-Integer (retain period)    ${segment_number}
    Run Keyword If    '${refresh_needed}' == 'True' and '${is_amend_workflow}' == 'True'    Enter GDS Command    IR    XE${number}
    ...    ELSE IF    '${refresh_needed}' == 'False' and '${is_amend_workflow}' == 'True'    Enter GDS Command    XE${number}
    Book Flight X Months From Now    ${city_pair}    ${seat_select}    \    ${month}    ${day}
    ${number}    Evaluate    ${number} - 2
    ${ticket_number}    Get From List    ${ticket_numbers}    ${number}
    Run Keyword If    "${is_amend_workflow}"=="False"    Enter GDS Command    FHE ${ticket_number}/${segment_number}
    Enter GDS Command    FXQ/${segment_number}/TKT${ticket_number}

Generate Data For Exchange Ticket
    [Arguments]    ${identifier}    ${exch_base_fare_currency}    ${exch_base_fare}    ${exch_equiv_currency}    ${exch_equiv_amount}    ${exch_tax_1}
    ...    ${exch_tax_2}    ${exch_paid_tax}    ${exch_total_amount}
    Set Test Variable    ${exch_base_fare_currency_${identifier}}    ${exch_base_fare_currency}
    Set Test Variable    ${exch_base_fare_${identifier}}    ${exch_base_fare}
    Set Test Variable    ${exch_equiv_currency_${identifier}}    ${exch_equiv_currency}
    Set Test Variable    ${exch_equiv_amount_${identifier}}    ${exch_equiv_amount}
    Set Test Variable    ${exch_tax_1_${identifier}}    ${exch_tax_1}
    Set Test Variable    ${exch_tax_2_${identifier}}    ${exch_tax_2}
    Set Test Variable    ${exch_paid_tax_${identifier}}    ${exch_paid_tax}
    Set Test Variable    ${exch_total_amount${identifier}}    ${exch_total_amount}

Set TST For Manual Reissue
    [Arguments]    ${segment_number}    ${identifier}    ${need_equiv}=False    ${delete_tst}=True    ${remove_old_taxes}=True    ${is_amend_workflow}=True
    ${number}    Remove All Non-Integer (retain period)    ${segment_number}
    ${number}    Evaluate    ${number} - 2
    ${ticket_number}    Get From List    ${ticket_numbers}    ${number}
    Run Keyword If    "${is_amend_workflow}"=="False"    Enter GDS Command    FHE ${ticket_number}/${segment_number}
    ${tax_currency}    Set Variable If    ${need_equiv}    ${exch_equiv_currency_${identifier}}    ${exch_base_fare_currency_${identifier}}
    Enter GDS Command    TTK/EXCH/${segment_number}
    Run Keyword If    ${delete_tst}    Enter GDS Command    TTK/${segment_number}/F
    Run Keyword If    ${remove_old_taxes}    Enter GDS Command    TTK/${segment_number}/O
    Run Keyword If    ${need_equiv}    Enter GDS Command    TTK/${segment_number}/R${exch_base_fare_currency_${identifier}}${exch_base_fare_${identifier}}/E${exch_equiv_currency_${identifier}}${exch_equiv_amount_${identifier}}/X${exch_equiv_currency_${identifier}}${exch_tax_1_${identifier}}/X${exch_equiv_currency_${identifier}}${exch_tax_2_${identifier}}/T${exch_equiv_currency_${identifier}}${exch_total_amount${identifier}}
    ...    ELSE    Enter GDS Command    TTK/${segment_number}/R${exch_base_fare_currency_${identifier}}${exch_base_fare_${identifier}}/X${exch_equiv_currency_${identifier}}${exch_tax_1_${identifier}}/X${exch_equiv_currency_${identifier}}${exch_tax_2_${identifier}}/T${exch_equiv_currency_${identifier}}${exch_total_amount${identifier}}

Create Original/Issued In Exchange For (FO)
    [Arguments]    ${ticket_index}    ${segment_number}
    #${fa_line_number}    Get From List    ${fa_line_number}    ${fa_line_index}
    #Enter GDS Command    RT    FO*L${fa_line_number}
    #${gds_screen_data_raw}    Get Control Text Value    [NAME:txtCRS]
    #${fo_line}    Get Lines Using Regexp    ${gds_screen_data_raw}    FO\\d{3}\-\\d{10}
    #${fo_line}    Fetch From Right    ${fo_line}    >
    ${date}    Generate Date X Months From Now    6    0    %d%b%y
    ${ticket_number}    Get From List    ${ticket_numbers}    ${ticket_index}
    Enter GDS Command    FHA ${ticket_number}
    Enter GDS Command    FO${ticket_number}E1MNL${date}/00002634/${ticket_number}E1/${segment_number}

Get Ticket Number From PNR
    [Arguments]    ${refresh_needed}=True
    Run Keyword if    ${refresh_needed}    Enter GDS Command    IG    RT${current_pnr}
    ...    ELSE    Enter GDS Command    RT${current_pnr}
    ${ticket_numbers}    Create List
    ${rtf_lines}    Get Clipboard Data Amadeus    RTTN
    ${fp_lines}    Get Lines Using Regexp    ${rtf_lines}    FA PAX \\d{3}\-\\d{10}
    ${fp_lines}    Split To Lines    ${fp_lines}
    : FOR    ${fp_line}    IN    @{fp_lines}
    \    ${line}    Fetch From Right    ${fp_line}    FA PAX${SPACE}
    \    ${ticket_number}    Fetch From Left    ${line}    \/
    \    Append To List    ${ticket_numbers}    ${ticket_number}
    Set Suite Variable    ${ticket_numbers}

Remove FP Line From The PNR
    Enter GDS Command    IG    RT${current_pnr}
    ${rtf_lines}    Get Clipboard Data Amadeus    RTF
    ${fp_line}    Get Lines Using Regexp    ${rtf_lines}    \\d+\\sFP\\s.\*
    ${line_number}    Fetch From Left    ${fp_line}    FP
    Enter GDS Command    XE${line_number.strip()}    RFTESTPNR    ER    ER    IR
    ${rtf_lines}    Get Clipboard Data Amadeus    RTF
    Verify Text Does Not Contain Value    ${rtf_lines}    \\d+\\sFP\\s.\*    true

Get Total Tax From TST
    [Arguments]    ${segment_number}    ${country}
    Enter GDS Command    RT    TQT/${segment_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${tx_tax}    Get Lines Containing String    ${data_clipboard}    TX
    ${currency}    Get Currency    ${country}
    @{txs}    Split String    ${tx_tax}    -
    Log List    ${txs}
    ${total_tax}    Set Variable    0
    ${total_unpaid_tax}    Set Variable    0
    : FOR    ${tx}    IN    @{txs}
    \    ${is_tx_present}    Run Keyword And Return Status    Should Contain    ${tx}    TX
    \    Continue For Loop If    ${is_tx_present} == False
    \    ${is_contain_unpaid_tax}    Run Keyword And Return Status    Should Match Regexp    ${tx}    TX\\d{3} X
    \    ${unpaid_tax}    Run Keyword If    ${is_contain_unpaid_tax} == True    Fetch From Right    ${tx}    ${currency}
    \    ${unpaid_tax}    Run Keyword If    ${is_contain_unpaid_tax} == True    Remove All Non-Integer (retain period)    ${unpaid_tax}
    \    ...    ELSE    Set Variable    0
    \    ${tax}    Fetch From Right    ${tx}    ${currency}
    \    Log    ${tax}
    \    ${tax}    Remove All Non-Integer (retain period)    ${tax}
    \    Continue For Loop If    "${tax}" == "${EMPTY}"
    \    ${tax}    Convert To Float    ${tax}
    \    ${unpaid_tax}    Convert To Float    ${unpaid_tax}
    \    ${total_tax}    Evaluate    ${total_tax} + ${tax}
    \    ${total_unpaid_tax}    Evaluate    ${total_unpaid_tax} + ${unpaid_tax}
    Log    ${total_tax}
    Set Suite Variable    ${total_tax}
    Set Suite Variable    ${total_unpaid_tax}
    [Teardown]
    [Return]    ${total_tax}

Cancel PNR Thru GDS Native
    [Arguments]    ${current_pnr}    ${void_ticket}=False    ${click_clear_all}=True
    Take Screenshot On Failure    
    Should Be True    "${current_pnr}" != "${EMPTY}"    Cannot cancel booking due to no PNR record locator
    Run Keyword If    "${current_pnr}" != "${EMPTY}"    Cancel Amadeus PNR    ${current_pnr}    ${void_ticket}
    Run Keyword If    '${click_clear_all}' == 'True'    Click Clear All
    [Teardown]

Change Itinerary Flight Date
    [Arguments]    ${segment_number}    ${number_of_months}    ${number_of_days}    ${end_retrieve_flag}=True
    ${new_date}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    ${number_of_days}
    ${base_date}    Evaluate    ${number_of_days}-1
    ${ticketing_date}    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    ${base_date}
    : FOR    ${INDEX}    IN RANGE    21
    \    Run Keyword If    '${gds_switch}'=='galileo' and ${end_retrieve_flag}==False    Enter Specific Command On Native GDS    @${segment_number}/${new_date}    FQ    T.TAU/${ticketing_date}
    \    Run Keyword If    '${gds_switch}'=='galileo' and ${end_retrieve_flag}==True    Run Keywords    Enter Specific Command On Native GDS    @${segment_number}/${new_date}    FQ
    \    ...    T.TAU/${ticketing_date}
    \    ...    AND    End And Retrieve PNR
    \    Get Clipboard Data
    \    ${is_simultaneous_exist}    Run Keyword And Return Status    Should Contain    """${data_clipboard.upper()}"""    SIMULTANEOUS
    \    Run Keyword If    ${is_simultaneous_exist} == True    Sleep    5
    \    Exit For Loop If    ${is_simultaneous_exist} == False

Determine If Next Fare Exists
    [Arguments]    ${counter}
    ${next_value}    Evaluate    ${counter} + 1
    ${next_fare_exists}    Run Keyword If    ${counter} == ${number_of_fares}    Set Variable    >
    ...    ELSE    Set Variable    FQ${next_value}
    [Return]    ${next_fare_exists}

Determine If Next Quote Exists
    [Arguments]    ${current_fare_number}
    ${next_value}    Evaluate    ${current_fare_number} + 1
    ${contains}    Run Keyword And Return Status    Should Contain    ${pnr_details}    QUOTE NUMBER: ${next_value}
    ${next_fare_exists}    Run Keyword If    "${contains}" == "False"    Set Variable    >
    ...    ELSE    Set Variable    QUOTE NUMBER: ${next_value}
    [Return]    ${next_fare_exists}

Determine Line Start Value
    ${contains_equ}    Run Keyword And Return Status    Should Contain    ${base_fare_value}    EQU
    ${start_value}    Run Keyword If    "${contains_equ}" == "True"    Set Variable    EQU
    ...    ELSE    Set Variable    FARE
    [Return]    ${start_value}

Determine Received From Text
    Set Test Variable    ${received_from}    RFTESTPNR

Edit PNR Remarks
    [Arguments]    ${current_pnr}    ${original_remark}    ${new_remark}    ${galileo_remark_type}=${EMPTY}
    Activate GDS Native
    Determine Received From Text
    ${line_number}    Run Keyword If    "${gds_switch}" != "amadeus"    Get Line Number In PNR Remarks    ${original_remark}
    ...    ELSE    Get Line Number In Amadeus PNR Remarks    ${original_remark}
    ${line_number_and_remark}    Set Variable If    "${gds_switch}" == "sabre"    5${line_number}${new_remark}    "${gds_switch}" == "amadeus"    ${line_number}/${new_remark}    "${gds_switch}" == "galileo"
    ...    ${galileo_remark_type}.${line_number}@${new_remark}
    ${ignore_command}    Set Variable If    "${gds_switch}" != "amadeus"    I{ENTER}    IG{ENTER}
    ${retrieve_pnr_command}    Set Variable If    "${gds_switch}" != "amadeus"    *${current_pnr}{ENTER}    rt${current_pnr}{ENTER}
    : FOR    ${counter}    IN RANGE    1    10
    \    Run Keyword If    "${gds_switch}" == "sabre"    Run Keywords    Send    {CTRLDOWN}{SHIFTDOWN}
    \    ...    AND    Send    {BS}
    \    ...    AND    Send    {CTRLUP}{SHIFTUP}
    \    Send    ${ignore_command}
    \    Sleep    1
    \    Send    ${retrieve_pnr_command}
    \    Sleep    2
    \    Send    ${line_number_and_remark}
    \    Sleep    1
    \    Send    {ENTER}
    \    Sleep    2
    \    Send    ${received_from}{ENTER}
    \    Sleep    2
    \    Send    ER{ENTER}
    \    Sleep    2
    \    Get Clipboard Data
    \    ${is_simultaneous_exist1}    Run Keyword And Return Status    Should Contain    """${data_clipboard.upper()}"""    SIMULTANEOUS
    \    ${is_simultaneous_exist2}    Run Keyword And Return Status    Should Contain    """${data_clipboard.upper()}"""    SIMULTANEOUS CHANGES
    \    Exit For Loop If    "${is_simultaneous_exist1}" == "False" and "${is_simultaneous_exist2}" == "False"
    Send    ER{ENTER}
    Sleep    2
    Send    ${ignore_command}
    Sleep    1

End And Retrieve PNR
    Enter GDS Command    RFCWTPTEST    ER    ER

Enter Command In Native GDS
    [Arguments]    @{gds_commands}
    : FOR    ${gds_command}    IN    @{gds_commands}
    \    Enter GDS Command    ${gds_command}

Enter LCC Remarks For Specific Airline Code
    [Arguments]    ${airline_code}    ${currency}    ${base_fare_amount}    ${tax_1}    ${tax_2}    ${tax_3}
    ...    ${grand_total_amount}    ${ticket_number}    ${cf_code}    ${vendor_code}    ${commission_amount}
    ${write_command}    Set Variable If    "${GDS_switch.upper()}" == "SABRE"    5H-F‡    "${GDS_switch.upper()}" == "APOLLO"    ¤:5H¤F/
    Enter GDS Command    ${write_command}LCC-${airline_code}*BASE FARE ${currency} ${base_fare_amount}
    Enter GDS Command    ${write_command}LCC-${airline_code}*TAX1 C${tax_1}
    Enter GDS Command    ${write_command}LCC-${airline_code}*TAX2 H${tax_2}
    Enter GDS Command    ${write_command}LCC-${airline_code}*TAX3 D${tax_3}
    Enter GDS Command    ${write_command}LCC-${airline_code}*GRAND TOTAL ${currency} ${grand_total_amount}
    Enter GDS Command    ${write_command}LCC-${airline_code}*TK-${ticket_number}
    Enter GDS Command    ${write_command}LCC-${airline_code}*CF-${cf_code}
    Enter GDS Command    ${write_command}LCC-${airline_code}*VN-${vendor_code}
    Enter GDS Command    ${write_command}LCC-${airline_code}*COMM-${commission_amount} ${currency}

Enter Specific Command On Native GDS
    [Arguments]    @{gds_command}
    Activate GDS Native
    Enter Command In Native GDS    @{gds_command}
    Activate Power Express Window

Force Ignore To GDS
    Activate GDS Native
    ${ignore_command}    Set Variable If    "${gds_switch}" != "amadeus"    I{ENTER}    IG{ENTER}
    Send    ${ignore_command}

Get Base Fare And Tax From Galileo For Fare X Tab
    [Arguments]    ${fare_tab}
    ${number_of_fares}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${number_of_fares}
    ${subset}    Get String Between Strings    ${pnr_details}    FQ${number_of_fares}    /S${number_of_fares}
    ${base_fare_value}    Get Lines Containing String    ${subset}    FARE
    Set Test Variable    ${base_fare_value}
    ${line_to_start_from}    Determine Line Start Value
    ${base_fare_value}    Fetch From Right    ${base_fare_value}    ${line_to_start_from}
    ${base_fare_value}    Fetch From Left    ${base_fare_value}    TAX
    ${base_fare_value}    Remove Leading And Ending Spaces    ${base_fare_value}
    ${currency}    Get Substring    ${base_fare_value}    0    3
    ${base_fare_value}    Remove All Non-Integer (retain period)    ${base_fare_value}
    Set Test Variable    ${base_fare_value_${number_of_fares}}    ${base_fare_value}
    ${total_fare}    Get Lines Matching Regexp    ${subset}    .*ADT\ \ .*
    ${total_fare}    Fetch From Right    ${total_fare}    ${currency}
    ${total_fare}    Remove All Non-Integer (retain period)    ${total_fare}
    ${total_tax}    Evaluate    ${total_fare} - ${base_fare_value_${number_of_fares}}
    ${country_code}    Get Country Code Based On Currency    ${currency}
    ${gst_identifier}    Set Variable If    "${country_code.upper()}" == "NZ"    NZ    "${country_code.upper()}" == "AU"    UO    "${country_code.upper()}" == "MY"
    ...    D8
    ${gst_amount}    Get String Matching Regexp    TAX [0-9]+\.[0-9][0-9]${gst_identifier}    ${subset}
    ${gst_amount}    Run Keyword If    "${gst_amount}" != "0"    Remove All Non-Integer (retain period)    ${gst_amount}
    ...    ELSE    Set Variable    ${gst_amount}
    ${gst_amount}    Set Variable If    "${gst_amount}" != "."    ${gst_amount}    0
    ${total_tax_less_gst}    Run Keyword If    "${gst_amount}" > 0 and "${gst_amount}" != "."    Evaluate    ${total_tax} - ${gst_amount}
    Set Test Variable    ${gst_amount_${number_of_fares}}    ${gst_amount}
    Set Test Variable    ${tax_amount_${number_of_fares}}    ${total_tax}
    Set Test Variable    ${total_tax_less_gst_${number_of_fares}}    ${total_tax_less_gst}
    Set Test Variable    ${currency}
    Set Test Variable    ${total_fare_${number_of_fares}}    ${total_fare}

Get Base Fare And Tax From Sabre For Fare X Tab
    [Arguments]    ${fare_tab}    ${currency}    ${store_fare_command}=WPRQ'S    ${use_copy_content_from_sabre}=True
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    ${store_fare_command}${fare_index}    use_copy_content_from_sabre=${use_copy_content_from_sabre}
    ${base_fare}    Get String Matching Regexp    ${currency.upper()}[0-9]+\.[0-9][0-9]    ${pnr_details}
    ${tax_amount}    Get String Matching Regexp    [0-9]+\.[0-9][0-9]XT    ${pnr_details}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    ${tax_amount}    Remove All Non-Integer (retain period)    ${tax_amount}
    Set Suite Variable    ${fare_${fare_index}_base_fare}    ${base_fare}
    Set Suite Variable    ${tax_amount_${fare_index}}    ${tax_amount}

Get Base or Nett Fare Value
    [Arguments]    ${nett_fare}    ${base_fare}
    ${base_or_nett_fare_value}    Run Keyword If    "${nett_fare}" != "${EMPTY}" and "${nett_fare}" != "0"    Set Variable    ${nett_fare}
    ...    ELSE    Set Variable    ${base_fare}
    Set Test Variable    ${base_or_nett_fare_value}

Get Clipboard Data
    ${data_clipboard}    Run Keyword If    "${GDS_switch}" == "amadeus"    Get Clipboard Data Amadeus

Get Discount or Rebate Value
    [Arguments]    ${mark_up_amount}    ${commission_rebate_amount}
    ${mark_up_amount}    Set Variable If    "${mark_up_amount}" == "${EMPTY}"    0    ${mark_up_amount}
    ${mark_up_amount}    Convert To Float    ${mark_up_amount}
    ${commission_rebate_amount}    Set Variable If    "${commission_rebate_amount}" == "${EMPTY}"    0    ${commission_rebate_amount}
    ${commission_rebate_amount}    Convert To Float    ${commission_rebate_amount}
    ${discount_or_rebate_value}    Set Variable If    ${mark_up_amount} > 0    ${mark_up_amount}    -${commission_rebate_amount}
    Set Test Variable    ${discount_or_rebate_value}

Get Discount or Rebate Value For CITI
    [Arguments]    ${mark_up_amount}
    ${mark_up_amount}    Set Variable If    "${mark_up_amount}" == "${EMPTY}"    0    ${mark_up_amount}
    ${mark_up_amount}    Convert To Float    ${mark_up_amount}
    Comment    ${commission_rebate_amount}    Set Variable If    "${commission_rebate_amount}" == "${EMPTY}"    0    ${commission_rebate_amount}
    Comment    ${commission_rebate_amount}    Convert To Float    ${commission_rebate_amount}
    Comment    ${discount_or_rebate_value}    Set Variable If    ${mark_up_amount} > 0    ${mark_up_amount}    -${commission_rebate_amount}
    Set Test Variable    ${discount_or_rebate_value}    ${mark_up_amount}

Get Fare Amount Value For Fare X Tab
    [Arguments]    ${fare_tab}
    [Documentation]    Kindly Run "Get Base Fare Value From Galileo For X Number Of Fares" Prior To This Keyword
    ${fare_tab_index} =    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Click Panel    Air Fare
    Click Fare Tab    ${fare_tab}
    Click Details Tab
    Get High Fare Value    ${fare_tab}
    Get Charged Fare Value    ${fare_tab}
    Get Low Fare Value    ${fare_tab}
    Click Pricing Extras Tab
    Get Nett Fare Value    ${fare_tab}
    Get Mark-Up Amount Value    ${fare_tab}
    Get Commission Rebate Amount Value    ${fare_tab}
    Get Base or Nett Fare Value    ${nett_fare_value_${fare_tab_index}}    ${base_fare_value_${fare_tab_index}}
    Get Discount or Rebate Value    ${mark_up_value_${fare_tab_index}}    ${commission_rebate_value_${fare_tab_index}}
    ${computed_fare_amount}    Evaluate    ${base_or_nett_fare_value} + ${discount_or_rebate_value}
    Set Test Variable    ${fare_amount_${fare_tab_index}}    ${computed_fare_amount}

Get Fare Amount Value For Fare X Tab For CITI
    [Arguments]    ${fare_tab}
    [Documentation]    Kindly Run "Get Base Fare Value From Galileo For X Number Of Fares" Prior To This Keyword
    ${fare_tab_index} =    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Click Panel    Air Fare
    Click Fare Tab    ${fare_tab}
    Click Details Tab
    Get High Fare Value    ${fare_tab}
    Get Charged Fare Value    ${fare_tab}
    Get Low Fare Value    ${fare_tab}
    Click Pricing Extras Tab
    Get Nett Fare Value    ${fare_tab}
    Get Mark-Up Amount Value    ${fare_tab}
    Get Base or Nett Fare Value    ${nett_fare_value_${fare_tab_index}}    ${base_fare_value_${fare_tab_index}}
    Get Discount or Rebate Value For CITI    ${mark_up_value_${fare_tab_index}}
    ${computed_fare_amount}    Evaluate    ${base_or_nett_fare_value} + ${discount_or_rebate_value}
    Set Test Variable    ${fare_amount_${fare_tab_index}}    ${computed_fare_amount}

Get Fare Basis From PQ
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_basis_line}    Get String Matching Regexp    (ADT\\-[0-9]+)\\s+([a-zA-Z0-9]+)    ${pnr_details}
    ${fare_basis}    Fetch From Right    ${fare_basis_line}    ADT-01
    Set Test Variable    ${pq_fare_basis_${fare_tab_index}}    ${fare_basis.strip()}

Get Itinerary Remarks From Galileo For Fare X
    [Arguments]    ${fare_tab}
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_index}
    : FOR    ${counter}    IN RANGE    1    ${fare_index}+1
    \    ${next_fare}    Determine If Next Quote Exists    ${counter}
    \    ${subset}    Get String Between Strings    ${pnr_details}    QUOTE NUMBER: ${counter}    ${next_fare}
    Set Test Variable    ${pnr_details}    ${subset}

Get LCC Remarks
    ${lcc_identifier}    Set Variable If    '${gds_switch}' == 'sabre'    H-F‡    '${gds_switch}' == 'apollo'    F/    '${gds_switch}' == 'amadeus'
    ...    RMF${space}
    ${lcc_remarks}    Get Lines Containing String    ${pnr_details}    ${lcc_identifier}LCC
    ${actual_lcc_remarks}    Split To Lines    ${lcc_remarks}
    ${collection_of_lcc_remarks}    Create List
    : FOR    ${lcc_remark}    IN    @{actual_lcc_remarks}
    \    ${converted_lcc_remark}    Convert To String    ${lcc_remark}
    \    ${converted_lcc_remark}    Fetch From Right    ${converted_lcc_remark}    ${lcc_identifier}
    \    ${converted_lcc_remark}    Replace String    ${converted_lcc_remark}    ‡    ${SPACE}
    \    Append To List    ${collection_of_lcc_remarks}    ${converted_lcc_remark.strip()}
    ${collection_of_lcc_remarks}    Remove Duplicates    ${collection_of_lcc_remarks}
    Log List    ${collection_of_lcc_remarks}
    [Return]    ${collection_of_lcc_remarks}

Get Line Number In PNR Remarks
    [Arguments]    ${string_to_search}
    Set Test Variable    ${line_0001}    ${EMPTY}
    @{lines}=    Split to lines    ${pnr_details}
    : FOR    ${line}    IN    @{lines}
    \    ${eval_line} =    Run Keyword and Return Status    Should Contain    ${line}    ${string_to_search}
    \    Run Keyword If    "${eval_line}" == "True"    Set Test Variable    ${line_0001}    ${line}
    \    #This will only get the last string match; Need to refactor if last string matched is not the expected line number
    ${line_0001}    Fetch from Left    ${line_0001}    .
    ${line_0001}    Remove Leading and Ending Spaces    ${line_0001}
    [Return]    ${line_0001}

Get Lowest Fare Value
    [Arguments]    ${computed_charged_fare}    ${low_fare}    ${mark_up_amount}
    ${low_fare}    Evaluate    ${low_fare} + ${mark_up_amount}
    ${lowest_fare_value}    Run Keyword If    ${computed_charged_fare} < ${low_fare}    Set Variable    ${computed_charged_fare}
    ...    ELSE    Set Variable    ${low_fare}
    Set Test Variable    ${lowest_fare_value}

Get PCC and Team ID from GDS Logs in Sabre Red
    ${team_line}    Get Lines Containing String    ${pnr_details}    TEAM
    ${team_line}    Remove All Spaces    ${team_line}
    ${teamid} =    Fetch From Right    ${team_line}    TEAM
    Set Test Variable    ${teamid}
    ${pcc_line}    Get Lines Containing String    ${pnr_details}    PCC
    ${pcc_line}    Remove All Spaces    ${pcc_line}
    ${pcc}    Fetch From Right    ${pcc_line}    PCC
    Set Test Variable    ${pcc}

Get RF, SF and LF value For Fare X Tab
    [Arguments]    ${fare_tab}
    [Documentation]    Kindly Run "Get Base Fare Value From Galileo For X Number Of Fares" Prior To This Keyword
    ${fare_tab_index} =    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Click Panel    Air Fare
    Click Fare Tab    ${fare_tab}
    Click Details Tab
    Get High Fare Value    ${fare_tab}
    Get Charged Fare Value    ${fare_tab}
    Get Low Fare Value    ${fare_tab}
    Click Pricing Extras Tab
    Get Nett Fare Value    ${fare_tab}
    Get Mark-Up Amount Value    ${fare_tab}
    Get Commission Rebate Amount Value    ${fare_tab}
    Get Base or Nett Fare Value    ${nett_fare_value_${fare_tab_index}}    ${base_fare_value_${fare_tab_index}}
    Get Discount or Rebate Value    ${mark_up_value_${fare_tab_index}}    ${commission_rebate_value_${fare_tab_index}}
    ${computed_charged_fare}    Evaluate    ${base_or_nett_fare_value} + ${tax_amount_${fare_tab_index}} + ${discount_or_rebate_value}
    ${computed_charged_fare}    Run Keyword If    "${currency}" == "HKD"    Convert To String    ${computed_charged_fare}
    ...    ELSE    Set Variable    ${computed_charged_fare}
    ${computed_charged_fare}    Run Keyword If    "${currency}" == "HKD"    Fetch From Left    ${computed_charged_fare}    .
    ...    ELSE    Set Variable    ${computed_charged_fare}
    ${set_mark_up_amount}    Set Variable If    "${mark_up_value_${fare_tab_index}}" == "${EMPTY}"    0    ${mark_up_value_${fare_tab_index}}
    Get Selling Fare Value    ${base_or_nett_fare_value}    ${set_mark_up_amount}
    Get Lowest Fare Value    ${computed_charged_fare}    ${low_fare_value_${fare_tab_index}}    ${set_mark_up_amount}
    Get Ref Fare Value    ${computed_charged_fare}    ${high_fare_value_${fare_tab_index}}
    Comment    Set Test Variable    ${commission_rebate_value_${fare_tab_index}}
    Set Test Variable    ${base_or_nett_fare_value_${fare_tab_index}}    ${base_or_nett_fare_value}
    Set Test Variable    ${lowest_fare_value_${fare_tab_index}}    ${lowest_fare_value}
    Set Test Variable    ${ref_fare_value_${fare_tab_index}}    ${ref_fare_value}
    Set Test Variable    ${selling_fare_value_${fare_tab_index}}    ${selling_fare_value}

Get Ref Fare Value
    [Arguments]    ${computed_charged_fare}    ${high_fare}
    ${high_fare}    Set Variable If    ${computed_charged_fare} > ${high_fare}    ${computed_charged_fare}    ${high_fare}
    ${ref_fare_value}    Run Keyword If    "${currency}" == "HKD"    Fetch From Left    ${high_fare}    .
    ...    ELSE    Set Variable    ${high_fare}
    Set Test Variable    ${ref_fare_value}

Get Selling Fare Value
    [Arguments]    ${fare_value}    ${mark_up_amount}
    ${selling_fare_value}    Evaluate    ${fare_value} + ${mark_up_amount}
    Set Test Variable    ${selling_fare_value}

Get Shell PNR Remark Line
    [Arguments]    ${current_pnr}=${EMPTY}
    Retrieve PNR Details    ${current_pnr}
    ${shell_pnr_line}    Set Variable If    "${gds_switch}" == "galileo" or "${gds_switch}" == "apollo"    T \ ** \ TEXT **    #${EMPTY} #Reserved for other GDS
    ${shell_pnr_line}    Get Lines Containing String    ${pnr_details}    ${shell_pnr_line}
    ${shell_pnr_line}    Remove Line Number    ${shell_pnr_line}
    Set Test Variable    ${shell_pnr_line}

Get TST Number
    [Arguments]    ${segment_number}
    ${tst_line_using_segment}    Get Lines Using Regexp    ${data_clipboard}    ${charged_fare_${fare_tab_index}}+.+${segment_number[1:]}
    ${tst0_line}    Get Lines Containing String    ${data_clipboard}    TST0
    ${tst_line_raw}    Run Keyword If    "${tst0_line}" != "${EMPTY}"    Split String    ${tst0_line}    ${SPACE}
    ...    ELSE    Split String    ${tst_line_using_segment}    ${SPACE}
    ${tst_number}    Run Keyword If    "${tst0_line}" != "${EMPTY}"    Remove String Using Regexp    ${tst_line_raw[0]}    TST.0*
    ...    ELSE    Evaluate    ''.join(${tst_line_raw[:1]})
    Set Test Variable    ${tst_number}    T${tst_number}

Get Tax Amount For Specific Tax Type On Fare X
    [Arguments]    ${tax_type}    ${fare_tab}
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_index}
    ${x_tax_value}    Get String Matching Regexp    [0-9]+\.[0-9]+${tax_type}    ${pnr_details}
    ${x_tax_value}    Remove All Non-Integer (retain period)    ${x_tax_value}
    Set Test Variable    ${x_tax_value_${fare_index}}    ${x_tax_value}

Get Total Fare From Galileo
    [Arguments]    ${fare_tab}    ${segment_number}    ${current_pnr}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Travelport    ${current_pnr}    *FF${segment_number}    \    \    False
    ${total_fare_line} =    Get Lines Using Regexp    ${pnr_details}    ADT.*G
    ${total_fare_raw} =    Fetch From Right    ${total_fare_line}    ${SPACE}
    ${total_fare} =    Remove All Non-Integer (retain period)    ${total_fare_raw}
    @{currency_and_total_fare_raw} =    Split String    ${total_fare_line}
    Set Suite Variable    ${total_fare_${fare_tab_index}}    ${total_fare}
    Set Suite Variable    ${currency_and_total_fare_${fare_tab_index}}    ${currency_and_total_fare_raw[-2:-1]}
    [Return]    ${total_fare_${fare_tab_index}}

Get Total For All Tickets From Galileo For X Number Of Fares
    [Arguments]    ${number_of_fares}=1
    Set Test Variable    ${total_for_all_tickets_value}    0
    Retrieve PNR Details From Travelport    ${current_pnr}    *RI
    : FOR    ${counter}    IN RANGE    1    ${number_of_fares}+1
    \    ${next_fare}    Determine If Next Quote Exists    ${counter}
    \    ${subset}    Get String Between Strings    ${pnr_details}    QUOTE NUMBER: ${counter}    ${next_fare}
    \    ${total_amount_value}    Get Lines Containing String    ${subset}    TOTAL AMOUNT
    \    ${total_amount_value}    Fetch From Right    ${total_amount_value}    TOTAL AMOUNT:
    \    ${total_amount_value}    Remove Leading And Ending Spaces    ${total_amount_value}
    \    ${currency}    Get Substring    ${total_amount_value}    0    3
    \    ${total_amount_value}    Remove All Non-Integer (retain period)    ${total_amount_value}
    \    ${total_for_all_tickets_value}    Evaluate    ${total_amount_value} + ${total_for_all_tickets_value}
    Set Test Variable    ${currency}
    Set Test Variable    ${total_for_all_tickets_value}

Get Validating Carrier From PQ
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${validating_carrier_line}    Get String Matching Regexp    VALIDATING CARRIER(\\s+[a-zA-Z]+)?\\s+\\-\\s+[a-zA-Z]{2}    ${pnr_details}
    ${validating_carrier}    Fetch From Right    ${validating_carrier_line}    -
    Set Test Variable    ${validating_carrier_${fare_tab_index}}    ${validating_carrier.strip()}

Handle Send To PNR Error - Sabre GDS
    Activate Sabre Red Workspace
    Sleep    2
    Send    5/{ENTER}
    Sleep    5
    Activate Power Express Window

Handle Ticketing Information Error - Galileo GDS
    [Arguments]    ${gds_command}
    Sleep    2
    Activate Travelport Window
    Send    {TAB}1{TAB}
    Sleep    1
    Send    {ENTER}
    Sleep    2
    Send    ${gds_command}{ENTER}
    Sleep    2
    Send    R.CWTPTEST{ENTER}
    Sleep    2
    Send    ER{ENTER}
    Sleep    2
    Send    *R{ENTER}
    Sleep    2
    Send    {CTRLDOWN}{HOME}{CTRLUP}
    Sleep    1
    Send    {CTRLDOWN}{SHIFTDOWN}{END}{SHIFTUP}{CTRLUP}
    Sleep    1
    Send    ^c
    Sleep    3

Modify PNR Remark
    [Arguments]    ${original_remark}    ${new_remark}    ${galileo_remark_type}=${EMPTY}
    Activate GDS Native
    : FOR    ${INDEX}    IN RANGE    21
    \    ${line_number}    Run Keyword If    "${gds_switch}" != "amadeus"    Get Line Number In PNR Remarks    ${original_remark}
    \    ...    ELSE    Get Line Number In Amadeus PNR Remarks    ${original_remark}
    \    ${modify_remark_command}    Set Variable If    "${GDS_switch}" == "sabre"    5${line_number}¤${new_remark}    "${GDS_switch}" == "amadeus"    ${line_number}/${new_remark}
    \    ...    "${GDS_switch}" == "galileo"    ${galileo_remark_type}.${line_number}@FT-${new_remark}
    \    Run Keyword If    "${GDS_switch}" == "amadeus" or "${GDS_switch}" == "sabre"    Enter GDS Command    ${modify_remark_command}
    \    ...    ELSE    Send    ${modify_remark_command}{ENTER}
    \    ${data_clipboard}    Get Clipboard Data
    \    ${is_simultaneous_exist}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard.upper()}    SIMULT    PARALLEL
    \    ...    MODIFIFICATIONS
    \    Run Keyword If    "${GDS_switch}" == "amadeus" and ${is_simultaneous_exist} == True    Retrieve PNR Details From Amadeus    ${current_pnr}
    \    Exit For Loop If    ${is_simultaneous_exist} == False

Modify Transaction Codes
    [Arguments]    ${original_code}    ${new_code}    ${galileo_remark_type}=${EMPTY}
    Determine Received From Text
    ${ignore_command}    Set Variable If    "${GDS_switch}" != "amadeus"    I{ENTER}    IG{ENTER}
    ${original_7311}    Set Variable If    "${GDS_switch}" == "amadeus"    \\*7311\\*${original_code}    "${GDS_switch}" == "sabre"    .*7311*${original_code}    "${GDS_switch}" == "galileo"
    ...    *7311*${original_code}
    ${original_6311}    Set Variable If    "${GDS_switch}" == "amadeus"    \\*6311\\*${original_code}    "${GDS_switch}" == "sabre"    .*6311*${original_code}    "${GDS_switch}" == "galileo"
    ...    *6311*${original_code}
    ${original_1311}    Set Variable If    "${GDS_switch}" == "amadeus"    \\*1311\\*${original_code}    "${GDS_switch}" == "sabre"    .*1311*${original_code}    "${GDS_switch}" == "galileo"
    ...    *1311*${original_code}
    ${original_3311}    Set Variable If    "${GDS_switch}" == "amadeus"    \\*3311\\*${original_code}    "${GDS_switch}" == "sabre"    .*3311*${original_code}    "${GDS_switch}" == "galileo"
    ...    *3311*${original_code}
    ${new_7311}    Set Variable If    "${GDS_switch}" == "amadeus"    *7311*${new_code}    "${GDS_switch}" == "sabre"    .*7311*${new_code}    "${GDS_switch}" == "galileo"
    ...    *7311*${new_code}
    ${new_6311}    Set Variable If    "${GDS_switch}" == "amadeus"    *6311*${new_code}    "${GDS_switch}" == "sabre"    .*6311*${new_code}    "${GDS_switch}" == "galileo"
    ...    *6311*${new_code}
    ${new_1311}    Set Variable If    "${GDS_switch}" == "amadeus"    *1311*${new_code}    "${GDS_switch}" == "sabre"    .*1311*${new_code}    "${GDS_switch}" == "galileo"
    ...    *1311*${new_code}
    ${new_3311}    Set Variable If    "${GDS_switch}" == "amadeus"    *3311*${new_code}    "${GDS_switch}" == "sabre"    .*3311*${new_code}    "${GDS_switch}" == "galileo"
    ...    *3311*${new_code}
    : FOR    ${ctr}    IN RANGE    1    11
    \    Run Keyword If    "${GDS_switch}" == "sabre"    Retrieve PNR Details From Sabre Red    ${current_pnr}    *.    2
    \    Run Keyword If    "${GDS_switch}" == "galileo"    Retrieve PNR Details From Travelport    ${current_pnr}    *DI
    \    Run Keyword If    "${GDS_switch}" == "amadeus"    Retrieve PNR Details From Amadeus    ${current_pnr}
    \    Modify PNR Remark    ${original_7311}    ${new_7311}    ${galileo_remark_type}
    \    Modify PNR Remark    ${original_6311}    ${new_6311}    ${galileo_remark_type}
    \    Modify PNR Remark    ${original_1311}    ${new_1311}    ${galileo_remark_type}
    \    Modify PNR Remark    ${original_3311}    ${new_3311}    ${galileo_remark_type}
    \    Run Keyword If    "${GDS_switch}" == "amadeus" or "${GDS_switch}" == "sabre"    Enter GDS Command    ${received_from}{ENTER}
    \    ...    ELSE    Send    ${received_from}{ENTER}
    \    Run Keyword If    "${GDS_switch}" == "amadeus" or "${GDS_switch}" == "sabre"    Enter GDS Command    ER{ENTER}
    \    ...    ELSE    Send    ER{ENTER}
    \    Sleep    2
    \    ${data_clipboard}    Get Clipboard Data
    \    ${is_simultaneous_exist}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    SIMULT    PARALLEL
    \    ...    MODIFIFICATIONS
    \    Run Keyword If    "${GDS_switch}" == "amadeus" or "${GDS_switch}" == "sabre"    Enter GDS Command    ER{ENTER}
    \    ...    ELSE    Send    ER{ENTER}
    \    Sleep    2
    \    ${data_clipboard}    Get Clipboard Data
    \    ${is_simultaneous_exist2}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    SIMULT    PARALLEL
    \    ...    MODIFIFICATIONS
    \    Run Keyword If    "${GDS_switch}" == "amadeus" or "${GDS_switch}" == "sabre"    Enter GDS Command    RT{ENTER}    ${ignore_command}
    \    ...    ELSE    Send    ${ignore_command}
    \    Exit For Loop If    ${is_simultaneous_exist} == False and ${is_simultaneous_exist2} == False

Remove PNR Remark
    [Arguments]    ${remark}    ${remark_type}=${EMPTY}
    ${line_number}    Get Line Number In Amadeus PNR Remarks    ${remark}
    ${remove_command}    Set Variable    XE${line_number}
    Enter GDS Command    ${remove_command}

Remove PNR Remark And End Transaction
    [Arguments]    ${remark}    ${remark_type}=${EMPTY}
    Determine Received From Text
    Retrieve PNR Details From Amadeus    ${current_pnr}
    : FOR    ${INDEX}    IN RANGE    10
    \    Remove PNR Remark    ${remark}    ${remark_type}
    \    Enter Gds Command    ER
    \    ${data_clipboard}    Get Clipboard Data
    \    ${is_simultaneous_exist}    Run Keyword And Return Status    Should Contain Any    ${data_clipboard}    SIMULT    PARALLEL
    \    ...    MODIFIFICATIONS    AVERTISSEMENT : VERIFIER LE CODE D'ETAT OSI/SSR
    \    Exit For Loop If    ${is_simultaneous_exist} == False
    \    Enter GDS Command    RT    IG

Retrieve PNR Details
    [Arguments]    ${current_pnr}
    Retrieve PNR Details From Amadeus    ${current_pnr}

Get FXD Low Value in GDS
    [Arguments]    ${lowestfare_command_with_segment}
    ${pnr_details}    Retrieve PNR Details From Amadeus    ${current_pnr}    ${lowestfare_command_with_segment}
    ${recommendation_lines}    Get Lines Containing String    ${pnr_details}    RECOMMENDATION
    ${low_values}    Get Regexp Matches    ${recommendation_lines}    \\d{2,}
    ${fxd_value}    Get Minimum Value From List    ${low_values}
    ${fxd_value}    Convert To String    ${fxd_value}
    ${fxd_value}    Remove Decimals    ${fxd_value}
    Set Suite Variable    ${fxd_value}
    [Return]    ${fxd_value}

Get Fare Notes From Amadeus
    [Arguments]    ${fare_tab}    ${group_no}    ${origin_destination}
    [Documentation]    Only use this right after booking a flight
    ${is_alt_fare}    Run Keyword And Return Status    Should Contain    ${fare_tab}    Alt
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Enter GDS Command    FQD${origin_destination}/A${carrier_${fare_index}_${group_no}}/D${departure_date_${fare_index}_${group_no}}/R,UP/C${seat_class_${fare_index}_${group_no}}
    # Check for the Fare Basis of the TST
    : FOR    ${i}    IN RANGE    20
    \    ${data_clipboard}    Get Data From GDS Screen    apply_current_screen_only=True
    \    ${fqn_number_list}    Get Regexp Matches    ${data_clipboard}    (\\d\\d)\\s(${fare_basis_${fare_index}_${group_no}})    1
    \    ${fqn_list_length}    Get Length    ${fqn_number_list}
    \    Exit For Loop If    ${fqn_list_length} != 0
    \    Enter GDS Command    MD
    ${fqn_number}    Set Variable    ${fqn_number_list[0]}
    ${data_clipboard}    Get Data From GDS Screen    FQN${fqn_number}    apply_current_screen_only=True
    #Determine number of pages in FQN
    ${pagination}    Get Regexp Matches    ${data_clipboard}    (PAGE\\s+\\d/\\s*)(\\d+)    2
    ${last_page}    Get From List    ${pagination}    -1
    # Log    ${last_page}
    #For Loop to extract Fare Notes
    ${farenote_from_gds}    Create List
    : FOR    ${j}    IN RANGE    0    ${last_page}
    \    ${fqn_response}    Get Data From GDS Screen    apply_current_screen_only=True
    \    ${farenote_list}    Get Regexp Matches    ${fqn_response}    (\\w+\\.\\w+\\s?\\w+\\n\\s{4,}\\w+|\\w+\\.\\w+\\s?\\w+\\/\\w+|\\w+\\.\\w+\\s?\\w+)    1
    \    Log    ${farenote_list}
    \    Remove Values From List    ${farenote_list}    VC.VOLUNTARY CHANGES    VR.VOLUNTARY REFUNDS
    \    ${fare_note_list_length}    Get Length    ${farenote_list}
    \    ${farenote_from_gds}    Run Keyword If    ${fare_note_list_length} != 0    Combine Lists    ${farenote_from_gds}    ${farenote_list}
    \    ...    ELSE    Combine Lists    ${farenote_from_gds}
    \    ${farenote_from_gds}    Replace Value In List Using Regex    \\s{2,}    ${SPACE}    ${farenote_from_gds}
    \    Enter GDS Command    MD
    ${fare_index}    Set Variable If    ${is_alt_fare}    alt_${fare_index}    ${fare_index}
    Set Test Variable    ${farenote_list_${fare_index}_${group_no}}    ${farenote_from_gds}
    Comment    Set Suite Variable    ${farenote_from_gds}
    [Return]    ${farenote_from_gds}

Get Fare Basis From TST
    [Arguments]    ${fare_tab}    ${group_no}    ${tst_number}    ${line_number}=1
    ${is_alt_fare}    Run Keyword And Return Status    Should Contain    ${fare_tab}    Alt
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${gds_command}    Set Variable If    ${is_alt_fare}    TQQ/O    TQT/T
    Enter GDS Command    RT
    ${tst_response}    Get Data From GDS Screen    ${gds_command}${tst_number}    True
    ${fare_basis_list}    Get Regexp Matches    ${tst_response}    \\w+\\s+\\w\\w\\s+\\d+\\s+\\w\\s\\d\\d\\w\\w\\w\\s+\\d+\\s+\\w+\\s+\\w+
    ${index_number}    Evaluate    ${line_number}-1
    ${fare_basis_group}    Split String    ${fare_basis_list[${${index_number}}]}
    Set Test Variable    ${fare_basis_${fare_index}_${group_no}}    ${fare_basis_group[-1]}
    Set test Variable    ${seat_class_${fare_index}_${group_no}}    ${fare_basis_group[3]}
    Set test Variable    ${departure_date_${fare_index}_${group_no}}    ${fare_basis_group[4]}
    Set test Variable    ${carrier_${fare_index}_${group_no}}    ${fare_basis_group[1]}

Get Line Numbers In Amadeus PNR Remarks
    [Arguments]    @{remark_list}
    [Documentation]    Returns list of line numbers
    @{line_numbers}    Create List
    : FOR    ${remark}    IN    @{remark_list}
    \    ${remark}    Regexp Escape    ${remark}
    \    ${remark_line}    Get Lines Matching Regexp    ${pnr_details}    .*${remark}.*
    \    ${line_number}    Get Regexp Matches    ${remark_line}    \\s?(\\d+)\\s\\w+    1
    \    Run Keyword If    len(${line_number}) > ${0}    Append To List    ${line_numbers}    ${line_number[0]}
    [Return]    ${line_numbers}
