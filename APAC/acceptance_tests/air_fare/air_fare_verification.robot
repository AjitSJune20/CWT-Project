*** Settings ***
Resource          ../../resources/panels/air_fare.robot
Resource          ../delivery/delivery_verification.robot
Resource          ../client_info/client_info_verification.robot
Resource          ../gds/gds_verification.robot
Resource          ../cust_refs/cust_refs_verification.robot

*** Keywords ***
Book Travel Fusion Air Segment
    [Arguments]    ${airline_name}    ${airline_code}    ${route}    ${month_of_booking}    ${segment_number}    ${booking_reference}
    [Documentation]    Sample Input
    ...    airline_name: CEBUPACIFIC
    ...    airline_codec: 5J
    ...    route: MNLCEB
    ...    segment_number: S2
    ...    booking_reference: A06PJT
    Get Future Dates For LCC Remarks    ${month_of_booking}
    Enter GDS Command    SS${airline_code}548A${departure_date}${route}GK1/00250415/${booking_reference}    #Book Passive Segment
    Enter GDS Command    RM ${airline_name}/${airline_code}/${segment_number}
    Enter GDS Command    RMA/LCC-${airline_code}*${airline_name}/${airline_code}/${segment_number}
    Enter GDS Command    RIRCF-${booking_reference}/${segment_number}

Calculate GST On Air
    [Arguments]    ${fare_tab}    ${country}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    4    6
    ...    ELSE    Set Variable    ${country}
    Comment    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "${EMPTY}" or "${nett_fare_value_${fare_tab_index}}" == "0" or "${nett_fare_value_${fare_tab_index}}" == "0.00"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ${yq_tax}    Get Variable Value    ${yq_tax_${fare_tab_index}}    0
    ${airfare_value_service_dom}    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${yq_tax}) * 0.05
    ${airfare_value_service_intl}    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${yq_tax}) * 0.10
    Comment    ${airfare_value_service_dom}    Round Apac    ${airfare_value_service_dom}    IN
    Comment    ${airfare_value_service_intl}    Round Apac    ${airfare_value_service_intl}    IN
    ${GST_airfare_value_service_dom}    Evaluate    ${airfare_value_service_dom} * 0.18
    ${GST_airfare_value_service_intl}    Evaluate    ${airfare_value_service_intl} * 0.18
    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Set Suite Variable    ${gst_airfare_value_service}    ${GST_airfare_value_service_dom}
    ...    ELSE    Set Suite Variable    ${gst_airfare_value_service}    ${GST_airfare_value_service_intl}
    ${gst_airfare_value_service}    Round Apac    ${gst_airfare_value_service}    ${country}
    Set Suite Variable    ${gst_airfare_value_service_${fare_tab_index}}    ${gst_airfare_value_service}
    [Return]    ${gst_airfare_value_service}

Calculate GST On Merchant Fee
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${merchant_fee_value}    Evaluate    ${merchant_fee_value_${fare_tab_index}} * 0.18
    ${merchant_fee_value}    Round APAC    ${merchant_fee_value}    IN
    Set Suite Variable    ${gst_merchant_fee_value_${fare_tab_index}}    ${merchant_fee_value}
    [Return]    ${merchant_fee_value}

Calculate GST On Merchant Fee For Transaction Fee
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Calculate GST On Transaction Fee    ${fare_tab}    IN
    ${merchant_fee_for_transaction_fee}    Evaluate    (${transaction_fee_value_${fare_tab_index}} + ${computed_gst_transaction_fee${fare_tab_index}}) * ${merchant_fee_percentage_value_${fare_tab_index}}/100
    ${merchant_fee_for_transaction_fee}    Round APAC    ${merchant_fee_for_transaction_fee}    IN
    ${gst_on_merchant_for_transaction}    Evaluate    ${merchant_fee_for_transaction_fee} * 0.18
    ${gst_on_merchant_for_transaction}    Round APAC    ${gst_on_merchant_for_transaction}    IN
    Set Suite Variable    ${merchant_fee_for_transaction_fee_${fare_tab_index}}    ${merchant_fee_for_transaction_fee}
    Set Suite Variable    ${computed_gst_mf_for_tf_amount_${fare_tab_index}}    ${gst_on_merchant_for_transaction}
    [Return]    ${gst_on_merchant_for_transaction}

Calculate GST On Transaction Fee
    [Arguments]    ${fare_tab}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${transaction_fee_value}    Set Variable If    "${transaction_fee_value_${fare_tab_index}}" == "${EMPTY}"    0    ${transaction_fee_value_${fare_tab_index}}
    ${computed_gst_transaction_fee}    Evaluate    ${transaction_fee_value} * 0.18
    ${computed_gst_transaction_fee}    Round Apac    ${computed_gst_transaction_fee}    IN
    Set Suite Variable    ${computed_gst_transaction_fee${fare_tab_index}}    ${computed_gst_transaction_fee}
    [Return]    ${computed_gst_transaction_fee}

Calculate GST Total Amount
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Calculate GST On Air    ${fare_tab}
    Calculate GST On Transaction Fee    ${fare_tab}    IN
    Calculate GST On Merchant Fee    ${fare_tab}
    Calculate GST On Merchant Fee For Transaction Fee    ${fare_tab}
    ${total_gst_amount}    Evaluate    ${gst_airfare_value_service_${fare_tab_index}} + ${computed_gst_transaction_fee${fare_tab_index}} + ${gst_merchant_fee_value_${fare_tab_index}} + ${computed_gst_mf_for_tf_amount_${fare_tab_index}}
    Set Suite Variable    ${computed_total_gst_amount_${fare_tab_index}}    ${total_gst_amount}

Click Using the Given Coordinates
    [Arguments]    ${x}    ${y}
    Win Activate    ${title_power_express}    ${EMPTY}
    Auto It Set Option    MouseCoordMode    2
    Mouse Click    LEFT    ${x}    ${y}
    Auto It Set Option    MouseCoordMode    0
    [Teardown]    Take Screenshot

Commission Route Percentage In Database
    [Arguments]    ${routing_code}    ${routing_city}    ${originating_country}=NONE
    [Documentation]    ${originating_country} - add is a specific country origin - SG, HK, IN, ASIA or GLOBAL - if Origin/Airport code is not SIN, HKG or DEL/BOM
    Set Suite Variable    ${commission_percentage}    0.00
    Set Test Variable    ${commission_percentage_zero}    0.00
    Set Test Variable    ${commission_category_one}    1.00
    Set Test Variable    ${commission_category_one_five}    1.50
    Set Test Variable    ${commission_category_two}    2.00
    Set Test Variable    ${commission_category_two_five}    2.50
    Set Test Variable    ${commission_category_three}    3.00
    Run Keyword If    "${country}" == "SG" and "${routing_city}" == "SIN" and "${routing_code.upper()}" == "INTL"    Set Suite Variable    ${commission_percentage}    ${commission_category_one_five}
    ...    ELSE IF    "${country}" == "SG" and "${routing_city}" != "SIN" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "SG"    Set Suite Variable    ${commission_percentage}    ${commission_category_one}
    ...    ELSE IF    "${country}" == "SG" and "${routing_city}" != "SIN" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "ASIA"    Set Suite Variable    ${commission_percentage}    ${commission_category_two}
    ...    ELSE IF    "${country}" == "SG" and "${routing_city}" != "SIN" and "${originating_country.upper()}" == "GLOBAL"    Set Suite Variable    ${commission_percentage}    ${commission_percentage_zero}
    Run Keyword If    "${country}" == "HK" and "${routing_city}" == "HKG" and "${routing_code.upper()}" == "INTL"    Set Suite Variable    ${commission_percentage}    ${commission_category_three}
    ...    ELSE IF    "${country}" == "HK" and "${routing_city}" != "HKG" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "HK"    Set Suite Variable    ${commission_percentage}    ${commission_category_two}
    ...    ELSE IF    "${country}" == "HK" and "${routing_city}" != "HKG" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "ASIA"    Set Suite Variable    ${commission_percentage}    ${commission_category_one_five}
    ...    ELSE IF    "${country}" == "HK" and "${routing_city}" != "HKG" and "${originating_country.upper()}" == "GLOBAL"    Set Suite Variable    ${commission_percentage}    ${commission_percentage_zero}
    Run Keyword If    "${country}" == "IN" and "${routing_city}" == "BOM" and "${routing_code.upper()}" == "DOM"    Set Suite Variable    ${commission_percentage}    ${commission_category_two_five}
    ...    ELSE IF    "${country}" == "IN" and "${routing_city}" == "DEL" and "${routing_code.upper()}" == "DOM"    Set Suite Variable    ${commission_percentage}    ${commission_category_two}
    ...    ELSE IF    "${country}" == "IN" and ("${routing_city}" != "DEL" and "${routing_city}" != "BOM") and "${routing_code.upper()}" == "DOM" and "${originating_country.upper()}" == "IN"    Set Suite Variable    ${commission_percentage}    ${commission_category_one_five}
    ...    ELSE IF    "${country}" == "IN" and "${routing_city}" == "DEL" and "${routing_code.upper()}" == "INTL"    Set Suite Variable    ${commission_percentage}    ${commission_category_three}
    ...    ELSE IF    "${country}" == "IN" and "${routing_city}" != "DEL" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "IN"    Set Suite Variable    ${commission_percentage}    ${commission_category_two}
    ...    ELSE IF    "${country}" == "IN" and "${routing_city}" != "DEL" and "${routing_code.upper()}" == "INTL" and "${originating_country.upper()}" == "ASIA"    Set Suite Variable    ${commission_percentage}    ${commission_category_one_five}
    ...    ELSE IF    "${country}" == "IN" and "${routing_city}" != "DEL" and "${originating_country.upper()}" == "GLOBAL"    Set Suite Variable    ${commission_percentage}    ${commission_percentage_zero}
    Set Suite Variable    ${country}
    [Return]    ${commission_percentage}

Compute Base Fare Or Net Fare
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${base_fare}    Set Variable    ${base_fare_${fare_tab_index}}
    ${total_tax}    Set Variable    ${total_tax_${fare_tab_index}}
    Comment    ${markup_amount}    Set Variable    ${mark_up_value_${fare_tab_index}}
    ${markup_amount}    Get Variable Value    ${mark_up_value_${fare_tab_index}}    0
    ${base_fare_nett_fare}    Evaluate    ${base_fare} + ${total_tax} + ${markup_amount}
    [Return]    ${base_fare_nett_fare}

Compute Total Tax
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${tax}    Evaluate    ${grand_total_fare_${fare_tab_index}} - ${base_fare_${fare_tab_index}}
    Set Suite Variable    ${total_tax_${fare_tab_index}}

Convert Amount To Local PCC Currency
    [Arguments]    ${amount}    ${foreign_currency}    ${value_identifier}    ${country}
    [Documentation]    ${value_identifier} is AS FARES, AS OTHER CHARGES, TRUNCATED
    Comment    ${data_clipboard}    Enter Convert Currency GDS Command    ${amount}    ${foreign_currency}
    Comment    ${amount}    Run Keyword If    "VERIFY AMOUNT" in """${data_clipboard}"""    Handle Amount Conversion Error    ${amount}
    ...    ELSE    Set Variable    ${amount}
    Comment    ${data_clipboard}    Run Keyword If    "VERIFY AMOUNT" in """${data_clipboard}"""    Enter Convert Currency GDS Command    ${amount}    ${foreign_currency}
    ...    ELSE    Set Variable    ${data_clipboard}
    Comment    ${converted_amt}    Get Lines Containing String    ${data_clipboard}    ${value_identifier.upper()}
    Comment    ${converted_amt}    Remove All Non-Integer (retain period)    ${converted_amt}
    Comment    Set Suite Variable    ${converted_amt}
    ${to_convert}    Evaluate    ${amount} * ${conversion_amount}
    ${converted_amt}    Run Keyword If    '${value_identifier.upper()}' == 'ROUNDING OF FARES'    Round Up Fares    ${to_convert}    ${rounding_as_fares}    ${country}
    ...    ELSE IF    '${value_identifier.upper()}' == 'ROUNDING OF OTHER CHARGES'    Round Up Fares    ${to_convert}    ${rounding_as_other_charges}    ${country}
    Comment    Enter GDS Command    RT
    [Return]    ${converted_amt}

Enter Convert Currency GDS Command
    [Arguments]    ${amount}    ${foreign_currency}
    Enter GDS Command    FQC ${amount} ${foreign_currency}
    ${data_clipboard}    Get Clipboard Data Amadeus
    [Return]    ${data_clipboard}

Enter Tour Code Remark
    [Arguments]    ${tour_code}    ${segment}
    Enter GDS Command    FT PAX *${tour_code}/${segment}

Enter Travel Fusion Fare Remarks
    [Arguments]    ${identifier}    ${airline_code}    ${segment_number}    ${currency}    ${merchant}
    [Documentation]    Note: "Generate Fee Data For Travel Fusion" must run prior to this keyword
    ...    Sample Input
    ...    identifier: LCC 1
    ...    airline_codec: 5J
    ...    segment_number: S2
    ...    merchant: Travel Fusion or Airline (identifier if it travel fusion or airline is the merchant)
    ${identifier}    Fetch From Right    ${identifier}    ${SPACE}
    Enter GDS Command    RMF/LCC-${airline_code}*PAID BY VI4444333322221111/D0927/${segment_number}
    Enter GDS Command    RMF/LCC-${airline_code}*NUMBER OF PAX: 1/${segment_number}
    Enter GDS Command    RMF/LCC-${airline_code}*FARE TOTAL ${currency} ${fare_total_${identifier}}/${segment_number}
    Enter GDS Command    RMF/LCC-${airline_code}*TAXES TOTAL ${currency} ${taxes_total_${identifier}}/${segment_number}
    #Enter GDS Command    RMF/LCC-${airline_code}*SERVICEFEE TOTAL ${currency} ${servicefee_total_${identifier}}/${segment_number}
    Run Keyword If    "${merchant.lower()}" == "airline"    Enter GDS Command    RMF/LCC-${airline_code}*CREDITCARD CHARGE ${currency} ${charge_${identifier}}/${segment_number}
    ...    ELSE    Enter GDS Command    RMF/LCC-${airline_code}*MERCHANT FEES ${currency} ${charge_${identifier}}/${segment_number}
    Enter GDS Command    RMF/LCC-${airline_code}*GRAND TOTAL ${currency} ${grand_total_${identifier}}/${segment_number}

Enter Travel Fusion Other Remarks
    [Arguments]    ${identifier}    ${currency}    ${segment_number}
    ${identifier}    Fetch From Right    ${identifier}    ${SPACE}
    Enter GDS Command    RM THIS IS A REMARK ENTERED BY THE USER IN THE WEB FRONT END/${segment_number}
    Enter GDS Command    RM TRAVELFUSION FLIGHT BOOKING D1O24A6S1/${segment_number}
    Enter GDS Command    RM ATTN LOWCOST CARRIER BOOKING DO NOT CANCEL/${segment_number}
    Enter GDS Command    RM TOTAL FARE ${fare_total_${identifier}} ${currency}/${segment_number}
    Enter GDS Command    RM TAXES INCLUDED ${taxes_total_${identifier}} ${currency}/${segment_number}
    Enter GDS Command    RM NUMBER OF PAX: 1/${segment_number}
    Enter GDS Command    RMA/SKIP-FARE/${segment_number}
    Enter GDS Command    RMA/LCC AQUA FULFILLMENT/${segment_number}
    Enter GDS Command    RMA/EMAIL ADDRESS USED FOR LCC IS harold.cuellar@carlsonwagonlit.com/${segment_number}
    Enter GDS Command    RM BOOKING COMPLETED 09012019 AT 061901/${segment_number}

Generate Fee Data For Travel Fusion
    [Arguments]    ${identifier}    ${fare_total}    ${taxes_total}    ${servicefee_total}    ${charge}    ${grand_total}
    ...    ${booking_reference}    ${currency}    ${country}=HK
    ${identifier}    Fetch From Right    ${identifier}    ${SPACE}
    ${base_fare}    Evaluate    ${fare_total} + ${charge}
    Get Current Currency Conversion    ${currency}    ${country}
    ${lcc_fare_amount}    Convert Amount To Local PCC Currency    ${base_fare}    ${currency}    ROUNDING OF FARES    ${country}
    ${lcc_taxes}    Convert Amount To Local PCC Currency    ${taxes_total}    ${currency}    ROUNDING OF OTHER CHARGES    ${country}
    ${lcc_total_amount}    Evaluate    ${lcc_fare_amount} + ${lcc_taxes}
    ${lcc_fare_amount}    Round APAC    ${lcc_fare_amount}    ${country}
    ${lcc_taxes}    Round APAC    ${lcc_taxes}    ${country}
    ${lcc_total_amount}    Round APAC    ${lcc_total_amount}    ${country}
    ${lcc_adult_fare}    Round APAC    ${lcc_total_amount}    ${country}
    ${fare_total}    Round APAC    ${fare_total}    ${country}
    ${taxes_total}    Round APAC    ${taxes_total}    ${country}
    ${servicefee_total}    Round APAC    ${servicefee_total}    ${country}
    ${charge}    Round APAC    ${charge}    ${country}
    ${grand_total}    Round APAC    ${grand_total}    ${country}
    Set Test Variable    ${fare_total_${identifier}}    ${fare_total}
    Set Test Variable    ${taxes_total_${identifier}}    ${taxes_total}
    Set Test Variable    ${servicefee_total_${identifier}}    ${servicefee_total}
    Set Test Variable    ${charge_${identifier}}    ${charge}
    Set Test Variable    ${grand_total${identifier}}    ${grand_total}
    Set Test Variable    ${booking_reference_${identifier}}    ${booking_reference}
    Set Suite Variable    ${lcc_fare_total_${identifier}}    ${lcc_fare_amount}
    Set Suite Variable    ${lcc_taxes_total_${identifier}}    ${lcc_taxes}
    Set Suite Variable    ${lcc_total_amount_${identifier}}    ${lcc_total_amount}
    Set Suite Variable    ${lcc_adult_fare_${identifier}}    ${lcc_adult_fare}

Get Alternate Base Fare, Total Taxes And Fare Basis
    [Arguments]    ${fare_tab}    ${gds_command}=TQQ
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    RTOF    Enter GDS Command    ${gds_command}/O${fare_tab_index}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${equiv_base_fare}    Get String Matching Regexp    (EQUIV\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${data_clipboard}
    ${base_fare}    Run Keyword If    "${equiv_base_fare}" == "0"    Get String Matching Regexp    (FARE\\s+.*?\\s+\\w+\\s+\\d+\\.?\\d+)    ${data_clipboard}
    ...    ELSE    Set Variable    ${equiv_base_fare}
    ${base_fare}    Remove All Non-Integer (retain period)    ${base_fare}
    Set Suite Variable    ${base_fare_alt_${fare_tab_index}}    ${base_fare}
    ###TOTAL TAX
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${total_fare_raw_splitted}    Split String    ${total_fare_raw}    ${SPACE}
    ${total_fare_raw_splitted}    Remove Duplicate From List    ${total_fare_raw_splitted}
    Set Suite Variable    ${grand_total_fare_alt_${fare_tab_index}}    ${total_fare_raw_splitted[-1]}
    Set Suite Variable    ${grand_total_fare_with_currency_alt_${fare_tab_index}}    ${total_fare_raw_splitted[-3]}${SPACE}${total_fare_raw_splitted[-1]}
    ##TAX
    ${tax}    Evaluate    ${grand_total_fare_alt_${fare_tab_index}} - ${base_fare_alt_${fare_tab_index}}
    ${tax}    Round Apac    ${tax}    ${country}
    Set Suite Variable    ${total_tax_alt_${fare_tab_index}}    ${tax}
    ##Fare Basis
    ${fare_basis_raw}    Get Lines Containing String    ${data_clipboard}    ${SPACE}OO${SPACE}
    @{split_lines}    Split To Lines    ${fare_basis_raw}
    @{fare_basis_list}    Create List
    Set Test Variable    ${counter}    0
    : FOR    ${line}    IN    @{split_lines}
    \    ${fare_basis}    Get Substring    ${line}    33    41
    \    ${counter}    Evaluate    ${counter}+1
    \    Set Test Variable    ${fare_basis_${counter}}    ${fare_basis}
    \    Append To List    ${fare_basis_list}    ${fare_basis}
    @{fare_basis_list}    Remove Duplicate From List    ${fare_basis_list}
    Set Test Variable    ${fare_basis_line}    ${fare_basis_1}
    : FOR    ${item}    IN    @{fare_basis_list}
    \    ${fare_basis_line}    Run Keyword If    "${fare_basis_1}" != "${item}"    Set Variable    ${fare_basis_line}+${item}
    \    ...    ELSE    Set Variable    ${fare_basis_line}
    \    Set Test Variable    ${fare_basis_line}
    Set Suite Variable    ${fare_basis_alt_${fare_tab_index}}    ${fare_basis_line}

Get BF Lines
    [Arguments]    ${fare_tab}    ${start}=0    ${end}=6
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${bf_lines}    Get Lines Containing String    ${pnr_details}    F‡BF-
    Should Not Be Empty    ${bf_lines}    BF Lines Is Empty
    ${bf_lines}    Split To Lines    ${bf_lines}
    ${bf_lines_collection}    Create List
    : FOR    ${index}    IN RANGE    ${start}    ${end}
    \    ${bf_line}    Get From List    ${bf_lines}    ${index}
    \    ${bf_line}    Fetch From Right    ${bf_line}    F‡
    \    Append To List    ${bf_lines_collection}    ${bf_line.strip()}
    Set Test Variable    ${bf_lines_collection_fare_${fare_tab_index}}    ${bf_lines_collection}

Get Base Fare Of Charged Fare
    [Arguments]    ${fare_tab}
    Get Base Fare And Tax From Sabre For Fare X Tab    ${fare_tab}    SGD    *PQ    False

Get Charged Fare Value In The Remarks
    [Arguments]    ${fare_tab}    ${currency}    ${command}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    ${command}    use_copy_content_from_sabre=False
    ${charged_fare_remark}    Get String Matching Regexp    ${currency}[0-9]+\.[0-9][0-9]ADT    ${pnr_details}
    ${charged_fare_remark}    Remove All Non-Integer (retain period)    ${charged_fare_remark}
    Set Test Variable    ${charged_fare_remark_${fare_tab_index}}    ${charged_fare_remark}

Get Current Currency Conversion
    [Arguments]    ${foreign_currency}    ${country}
    [Documentation]    ${country} is the OID country used for testing
    ${oid_currency}    Set Variable If    '${country}' == 'HK'    HKD    SGD
    Enter GDS Command    FQC ${foreign_currency}/${oid_currency}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${amount}    Get Lines Containing String    ${data_clipboard}    BSR USED
    ${rounding_as_fares}    Get Lines Containing String    ${data_clipboard}    ROUNDING OF FARES
    ${rounding_as_other_charges}    Get Lines Containing String    ${data_clipboard}    ROUNDING OF OTHER CHARGES
    ${amount}    Fetch From Right    ${amount}    =
    ${amount}    Fetch From Left    ${amount}    ${oid_currency}
    ${rounding_as_fares}    Remove All Non-Integer (retain period)    ${rounding_as_fares}
    ${rounding_as_other_charges}    Remove All Non-Integer (retain period)    ${rounding_as_other_charges}
    ${amount}    Remove All Non-Integer (retain period)    ${amount}
    Set Suite Variable    ${conversion_amount}    ${amount}
    Set Suite Variable    ${rounding_as_fares}
    Set Suite Variable    ${rounding_as_other_charges}
    Enter GDS Command    RT

Get Default Values On Air Fare Panel
    [Arguments]    ${fare_tab_value}
    ${tab_number}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Get Routing Value    ${fare_tab_value}
    Set Suite Variable    ${routing_value_${tab_number}}    ${city_route_${fare_tab_index}}
    Get Point Of Turnaround    ${fare_tab_value}
    Set Suite Variable    ${turnaround_value_${tab_number}}    ${point_of_${fare_tab_index}}
    Get High, Charged And Low Fare In Fare Tab    ${fare_tab_value}
    Set Suite Variable    ${charged_fare_value_${tab_number}}    ${charged_value_${fare_tab_index}}
    Set Suite Variable    ${high_fare_value_${fare_tab_index}}
    Set Suite Variable    ${low_fare_value_${fare_tab_index}}
    Get Savings Code    ${fare_tab_value}
    Set Suite Variable    ${realised_saving_code_value_${tab_number}}    ${realised_text_value_${fare_tab_index}}
    Set Suite Variable    ${missed_saving_code_value_${tab_number}}    ${missed_text_value_${fare_tab_index}}
    Set Suite Variable    ${class_code_value_${tab_number}}    ${class_text_value_${fare_tab_index}}
    Get LFCC Field Value    ${fare_tab_value}
    Set Suite Variable    ${lfcc_value_${fare_tab_index}}
    Get Route Code Value    ${fare_tab_value}
    Set Suite Variable    ${route_code_value_${tab_number}}    ${route_code_${fare_tab_index}}
    Get Transaction Fee Value    ${fare_tab_value}
    Set Suite Variable    ${transaction_fee_value_${tab_number}}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${routing_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${turnaround_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${high_fare_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${charged_fare_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${low_fare_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${realised_saving_code_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${missed_saving_code_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${class_code_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowestFareCC
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${lfcc_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${route_code_value_${tab_number}}    ${actual_field_value}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    Comment    ${actual_field_value}    Get Control Text Value    ${object_name}
    Comment    Set Suite Variable    ${transaction_fee_value_${tab_number}}    ${actual_field_value}

Get Fare Details In BF Remarks
    [Arguments]    ${fare_tab}    ${start}=0    ${end}=6
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get BF Lines    ${fare_tab}    ${start}    ${end}
    ${high_fare_remark}    Get String Matching Regexp    H\-[0-9]+\.[0-9][0-9]    ${bf_lines_collection_fare_${fare_tab_index}[1]}
    ${high_fare_remark}    Fetch From Right    ${high_fare_remark}    H-
    ${low_fare_remark}    Get String Matching Regexp    L\-[0-9]+\.[0-9][0-9]    ${bf_lines_collection_fare_${fare_tab_index}[1]}
    ${low_fare_remark}    Fetch From Right    ${low_fare_remark}    L-
    ${charged_fare_remark}    Get String Matching Regexp    C\-[0-9]+\.[0-9][0-9]    ${bf_lines_collection_fare_${fare_tab_index}[1]}
    ${charged_fare_remark}    Fetch From Right    ${charged_fare_remark}    C-
    ${realise_saving_code_remark}    Get String Matching Regexp    HC\-[a-zA-Z]{2}    ${bf_lines_collection_fare_${fare_tab_index}[2]}
    ${realise_saving_code_remark}    Fetch From Right    ${realise_saving_code_remark}    HC-
    ${missed_saving_code_remark}    Get String Matching Regexp    LC\-[a-zA-Z]{1}    ${bf_lines_collection_fare_${fare_tab_index}[2]}
    ${missed_saving_code_remark}    Fetch From Right    ${missed_saving_code_remark}    LC-
    ${class_code_remark}    Get String Matching Regexp    CL\-[a-zA-Z]{2}    ${bf_lines_collection_fare_${fare_tab_index}[2]}
    ${class_code_remark}    Fetch From Right    ${class_code_remark}    CL-
    ${cancellation_remark}    Get String Matching Regexp    CANX\-[0-9a-zA-Z]+\ [a-zA-Z]+    ${bf_lines_collection_fare_${fare_tab_index}[3]}
    ${cancellation_remark}    Fetch From Right    ${cancellation_remark}    CANX-
    ${changes_remark}    Get String Matching Regexp    CHGS\-[0-9a-zA-Z]+\ [a-zA-Z]+    ${bf_lines_collection_fare_${fare_tab_index}[4]}
    ${changes_remark}    Fetch From Right    ${changes_remark}    CHGS-
    ${min_stay_remark}    Get String Matching Regexp    MIN\-[0-9a-zA-Z]+\ [a-zA-Z]+    ${bf_lines_collection_fare_${fare_tab_index}[5]}
    ${min_stay_remark}    Fetch From Right    ${min_stay_remark}    MIN-
    ${max_stay_remark}    Get String Matching Regexp    MAX\-[0-9a-zA-Z]+\ [a-zA-Z]+    ${bf_lines_collection_fare_${fare_tab_index}[5]}
    ${max_stay_remark}    Fetch From Right    ${max_stay_remark}    MAX-
    Set Suite Variable    ${criteria_line_${fare_tab_index}}    ${bf_lines_collection_fare_${fare_tab_index}[0]}
    Set Suite Variable    ${missed_saving_code_remark_${fare_tab_index}}    ${missed_saving_code_remark}
    Set Suite Variable    ${realised_saving_code_remark_${fare_tab_index}}    ${realise_saving_code_remark}
    Set Suite Variable    ${class_code_remark_${fare_tab_index}}    ${class_code_remark}
    Set Suite Variable    ${cancellation_remark_${fare_tab_index}}    ${cancellation_remark}
    Set Suite Variable    ${changes_remark_${fare_tab_index}}    ${changes_remark}
    Set Suite Variable    ${min_stay_remark_${fare_tab_index}}    ${min_stay_remark}
    Set Suite Variable    ${max_stay_remark_${fare_tab_index}}    ${max_stay_remark}
    Set Suite Variable    ${high_fare_remark_${fare_tab_index}}    ${high_fare_remark}
    Set Suite Variable    ${low_fare_remark_${fare_tab_index}}    ${low_fare_remark}
    Set Suite Variable    ${charged_fare_remark_${fare_tab_index}}    ${charged_fare_remark}

Get GST On Air
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "${EMPTY}" or "${nett_fare_value_${fare_tab_index}}" == "0" or "${nett_fare_value_${fare_tab_index}}" == "0.00"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    ${airfare_value_service_dom}    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${yq_tax_${fare_tab_index}}) * 0.05
    ${airfare_value_service_intl}    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${yq_tax_${fare_tab_index}}) * 0.10
    ${GST_airfare_value_service_dom}    Evaluate    ${airfare_value_service_dom} * 0.18
    ${GST_airfare_value_service_intl}    Evaluate    ${airfare_value_service_intl} * 0.18
    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Set Suite Variable    ${gst_airfare_value_service}    ${GST_airfare_value_service_dom}
    ...    ELSE    Set Suite Variable    ${gst_airfare_value_service}    ${GST_airfare_value_service_intl}
    ${gst_airfare_value_service}    Run Keyword If    "${country}" == "SG"    Round Off    ${gst_airfare_value_service}    2
    ...    ELSE    Round Off    ${gst_airfare_value_service}    0
    ${gst_airfare_value_service}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${gst_airfare_value_service}    2
    ...    ELSE    Round Off    ${gst_airfare_value_service}    0
    Comment    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Set Suite Variable    ${gst_airfare_value_service_${fare_tab_index}}    ${GST_airfare_value_service_dom}
    ...    ELSE    Set Suite Variable    ${gst_airfare_value_service_${fare_tab_index}}    ${GST_airfare_value_service_intl}
    Set Suite Variable    ${gst_airfare_value_service_${fare_tab_index}}    ${gst_airfare_value_service}

Get High Fare, Charged Fare And Low Fare In BF Lines
    [Arguments]    ${fare_tab}    ${currency}=SGD
    [Documentation]    This keyword works with Sabre RED
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    *F‡    use_copy_content_from_sabre=False
    ${line}    Get Lines Containing String    ${pnr_details}    F‡BF-${currency}${fare_${fare_tab_index}_base_fare} H-
    ${low_fare_remark}    Get String Matching Regexp    L\-[0-9]+\.[0-9][0-9]    ${line}
    ${high_fare_remark}    Get String Matching Regexp    H\-[0-9]+\.[0-9][0-9]    ${line}
    ${charged_fare_remark}    Get String Matching Regexp    C\-[0-9]+\.[0-9][0-9]    ${line}
    ${low_fare_remark}    Remove All Non-Integer (retain period)    ${low_fare_remark}
    ${high_fare_remark}    Remove All Non-Integer (retain period)    ${high_fare_remark}
    ${charged_fare_remark}    Remove All Non-Integer (retain period)    ${charged_fare_remark}
    Set Suite Variable    ${low_fare_remark_${fare_tab_index}}    ${low_fare_remark}
    Set Suite Variable    ${high_fare_remark_${fare_tab_index}}    ${high_fare_remark}
    Set Suite Variable    ${charged_fare_remark_${fare_tab_index}}    ${charged_fare_remark}

Get LFCC, Base Fare, and Main Fees
    [Arguments]    ${fare_tab}    ${segment_number}    ${gds_command}=TQT
    Get LFCC From FV Line In TST    ${fare_tab}    ${segment_number}
    Get Base Fare From TST    ${fare_tab}    ${segment_number}
    Get Main Fees On Fare Quote Tab    ${fare_tab}

Get Offer From RTOF
    [Arguments]    ${fare_tab}    ${gds_command}=TQQ
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    RTOF
    ${data_clipboard}    Get Clipboard Data Amadeus
    ##Total
    ${offer_details}    Split String    ${data_clipboard}    ${SPACE}OFFER${SPACE}
    ${total_offer_raw}    Get Lines Containing String    ${offer_details[${fare_tab_index}]}    TOTAL
    ${total_offer_raw_splitted}    Split String    ${total_offer_raw}    ${SPACE}
    ${total_offer_raw_splitted}    Remove Duplicate From List    ${total_offer_raw_splitted}
    Log    ${total_offer_raw_splitted[-1]}
    Log    ${total_offer_raw_splitted[-2]}
    Set Suite Variable    ${total_offer_alt_${fare_tab_index}}    ${total_offer_raw_splitted[-2]}
    ##Details
    ${offer_detail}    Get Lines Containing String    ${offer_details[${fare_tab_index}]}    OO1
    @{split_lines}    Split To Lines    ${offer_detail}
    @{route}    Create List
    @{fare_airline}    Create List
    Set Test Variable    ${counter}    0
    : FOR    ${line}    IN    @{split_lines}
    \    ${airline}    Get Substring    ${line}    7    9
    \    ${offer_details}    Get Substring    ${line}    6
    \    ${offer_details_split}    Split String    ${offer_details}    OO1
    \    ${offer_details_first}    Get Substring    ${offer_details_split[0]}    0    15
    \    ${offer_details_get_route}    Split String    ${offer_details_split[0]}    ${SPACE}
    \    ${route_1}    Get Substring    ${offer_details_get_route[-2]}    0    3
    \    ${route_2}    Get Substring    ${offer_details_get_route[-2]}    3    6
    \    ${offer_details_last}    Get Substring    ${offer_details_split[1].strip()}    0    11
    \    Set Test Variable    ${offer_details_last}    ${offer_details_last.strip()}
    \    ${offer_details_last_stripped}    Set Variable    ${offer_details_last.upper()}
    \    ${alt_details}    Catenate    ${offer_details_first}    ${route_1}    ${route_2}    ${offer_details_last_stripped}
    \    ${counter}    Evaluate    ${counter}+1
    \    Set Test Variable    ${route_value_${counter}}    ${route_1}-${route_2}
    \    Set Test Variable    ${alt_details_${counter}}    ${alt_details.strip()}
    \    Log    ${counter}:: ${alt_details_${counter}}
    \    Set Test Variable    ${airline_value_${counter}}    ${airline}
    \    Append To List    ${fare_airline}    ${airline}
    @{fare_airline}    Remove Duplicate From List    ${fare_airline}
    Set Test Variable    ${details_line}    ${alt_details_1}
    : FOR    ${count}    IN    ${counter}
    \    ${details_line}    Run Keyword If    "${count}" != "1"    Set Variable    ${details_line}\n${alt_details_${counter}}
    \    ...    ELSE    Set Variable    ${details_line}
    Set Suite Variable    ${details_line_alt_${fare_tab_index}}    ${details_line}
    Set Test Variable    ${new_route_value}    ${route_value_1}
    : FOR    ${count}    IN    ${counter}
    \    ${route_line_last_value}    Fetch From Right    ${new_route_value}    -
    \    ${route_line_append}    Split String    ${route_value_${counter}}    -
    \    ${new_route_value}    Run Keyword If    "${count}" == "1"    Set Variable    ${route_value_${counter}}
    \    ...    ELSE IF    "${route_line_last_value}" == "${route_line_append[0]}"    Set Variable    ${new_route_value}-${route_line_append[1]}
    \    ...    ELSE    Set Variable    ${new_route_value}-${route_value_${counter}}
    Set Suite Variable    ${fare_route_alt_${fare_tab_index}}    ${new_route_value}
    Set Test Variable    ${fare_airline_line}    ${airline_value_1}
    : FOR    ${item}    IN    @{fare_airline}
    \    ${fare_airline_line}    Run Keyword If    "${airline_value_1}" != "${item}"    Set Variable    ${fare_airline_line}/${item}
    \    ...    ELSE    Set Variable    ${fare_airline_line}
    \    Set Test Variable    ${fare_airline_line}
    Set Suite Variable    ${fare_airline_alt_${fare_tab_index}}    ${fare_airline_line}

Get Restriction Remarks Line
    ${total_amount_line_remarks}    Get Lines Using Regexp    ${pnr_details}    RIR TRANSACTION FEE
    ${total_count_remarks}    Get Line Count    ${total_amount_line_remarks}
    @{split_lines}    Split To Lines    ${total_amount_line_remarks}
    ${air_fare_count}    Set Variable    0
    Convert To Integer    ${air_fare_count}
    : FOR    ${lines}    IN    @{split_lines}
    \    ${line_no}    Get Substring    ${lines}    0    3
    \    ${line_no}    Remove String Using Regexp    ${line_no}    [^\\d]
    \    ${air_fare_count}    Evaluate    ${air_fare_count} + 1
    \    Log    ${air_fare_count}
    \    Set Test Variable    ${air_fare_${air_fare_count}}    ${line_no}

Get Segment Number For Travcom
    [Arguments]    ${segment_number}
    Set Test Variable    ${segment_number_for_travcom}    ${segment_number}
    ${segment_status}    Run Keyword And Return Status    Should Contain    ${segment_number}    -
    ${segment_number_for_travcom}    Run Keyword If    "${segment_status}" == "True"    Replace String    ${segment_number_for_travcom}    -    0
    ...    ELSE    Set Variable    ${segment_number_for_travcom}
    ${segment_number_for_travcom}    Remove All Non-Integer (retain period)    ${segment_number_for_travcom}
    Set Suite Variable    ${segment_number_for_travcom}
    [Return]    ${segment_number_for_travcom}

Get Tour Code Value From TST
    [Arguments]    ${identifier}
    ${is_by_segment}    ${segment}    Run Keyword And Ignore Error    Should Contain    ${identifier}    S
    ${gds_command}    Set Variable If    '${is_by_segment}'=='PASS'    RTF    TQT/${identifier}
    Retrieve PNR Details From Amadeus    ${current_pnr}    ${gds_command}    False
    ${remark_line}    Run Keyword If    '${is_by_segment}'=='PASS'    Get Regexp Matches    ${pnr_details}    (?:\d*\s*FT PAX \*)(.*)(?:/S2)
    ...    ELSE    Get Regexp Matches    ${pnr_details}    (?:\d*\.FT \*)(.*)
    ${replacement}    Set Variable If    '${is_by_segment}'=='PASS'    FT PAX *    .FT *
    ${tour_code_value}    Replace String    ${remark_line[0]}    ${replacement}    ${EMPTY}
    ${tour_code_value}    Replace String    ${tour_code_value}    /${identifier}    ${EMPTY}
    Set Suite Variable    ${tour_code_value}

Get Transaction Fee Offline Flat Value
    [Arguments]    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}    ${rounding_so}=${EMPTY}    ${query}=${EMPTY}
    &{flat_amount}    Create Dictionary    sg=${120.00}    hk=${45}    in=${10.12}
    &{flat_percentage}    Create Dictionary    sg=${0.0112}    hk=${0.0550}    in=${0.0145}
    ${country}    Convert To Lowercase    ${country}
    Log    ${base_or_nett_fare}
    Log    ${query}
    ${transaction_fee_amount}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${flat_amount}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${transaction_fee_percentage}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${flat_percentage}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${computed_transansaction_fee}    Run Keyword If    "${fee_amount_percent_cap}" == "Percentage"    Evaluate    ${base_or_nett_fare} * ${transaction_fee_percentage}
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    Comment    ${transaction_fee}    Round To Nearest Dollar    ${computed_transansaction_fee}    ${country}    ${rounding_so}
    Set Test Variable    ${transaction_fee}    ${computed_transansaction_fee}
    [Return]    ${transaction_fee}

Get Transaction Fee Offline Range Value
    [Arguments]    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}    ${rounding_so}=${EMPTY}    ${query}=${EMPTY}
    &{range_amount_sg}    Create Dictionary    range_one=${100.67}    range_two=${200.00}    range_three=${300.25}    range_four=${400.00}    range_five=${500.00}
    &{range_amount_hk}    Create Dictionary    range_one=${150}    range_two=${250}    range_three=${350}    range_four=${4505}    range_five=${550}
    &{range_amount_in}    Create Dictionary    range_one=${200}    range_two=${300}    range_three=${400}    range_four=${500}    range_five=${600}
    &{range_percentage_sg}    Create Dictionary    range_one=${0.015}    range_two=${0.020}    range_three=${0.025}    range_four=${0.03}    range_five=${0.35}
    &{range_percentage_hk}    Create Dictionary    range_one=${0.02}    range_two=${0.03}    range_three=${0.04}    range_four=${0.05}    range_five=${0.06}
    &{range_percentage_in}    Create Dictionary    range_one=${0.03}    range_two=${0.06}    range_three=${0.09}    range_four=${0.12}    range_five=${0.14}
    ${country}    Convert To Lowercase    ${country}
    Log    ${base_or_nett_fare}
    ${transaction_range}    Set Variable If    int(${base_or_nett_fare}) in range(1, 501)    range_one    int(${base_or_nett_fare}) in range(501, 10001)    range_two    int(${base_or_nett_fare}) in range(10001, 20001)
    ...    range_three    int(${base_or_nett_fare}) in range(20001, 30001)    range_four    int(${base_or_nett_fare}) in range(30001, 999999)    range_five
    Log    ${query}
    ${transaction_range_amount}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${range_amount_${country}}    ${transaction_range}
    ...    ELSE    Set Variable    ${query}
    ${transaction_range_percentage}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${range_percentage_${country}}    ${transaction_range}
    ...    ELSE    Set Variable    ${query}
    ${cap}    Set Variable If    "${country}" == "SG"    ${50.00}    ${50}
    ${computed_transansaction_fee}    Run Keyword If    "${fee_amount_percent_cap}" == "Percentage" or "${fee_amount_percent_cap}" == "Cap"    Evaluate    ${base_or_nett_fare} * ${transaction_range_percentage}
    ${transaction_fee}    Set Variable If    "${fee_amount_percent_cap}" == "Amount"    ${transaction_range_amount}    "${fee_amount_percent_cap}" == "Cap"    ${cap}    ${computed_transansaction_fee}
    Comment    ${transaction_fee}    Run Keyword If    '${country.upper()}' == 'HK'    Round Off    ${transaction_fee}
    ...    ELSE    Round To Nearest Dollar    ${transaction_fee}    ${country}    ${rounding_so}
    [Return]    ${transaction_fee}

Get Transaction Fee Online Assisted Value
    [Arguments]    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}    ${rounding_so}=${EMPTY}    ${query}=${EMPTY}
    &{online_assist_amount}    Create Dictionary    sg=${25.00}    hk=${35.00}    in=${30.00}
    &{online_assist_percentage}    Create Dictionary    sg=${0.10}    hk=${0.10}    in=${0.10}
    ${country}    Convert To Lowercase    ${country}
    Log    ${base_or_nett_fare}
    Log    ${query}
    ${transaction_fee_amount}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${online_assist_amount}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${transaction_fee_percentage}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${online_assist_percentage}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${computed_transansaction_fee}    Run Keyword If    "${fee_amount_percent_cap}" == "Percentage"    Evaluate    ${base_or_nett_fare} * ${transaction_fee_percentage}
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    Comment    ${transaction_fee}    Round To Nearest Dollar    ${computed_transansaction_fee}    ${country}    ${rounding_so}
    Set Test Variable    ${transaction_fee}    ${computed_transansaction_fee}
    [Return]    ${transaction_fee}

Get Transaction Fee Online Unassisted Value
    [Arguments]    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}    ${rounding_so}=${EMPTY}    ${query}=${EMPTY}
    &{online_unassisted_amount}    Create Dictionary    sg=${45.00}    hk=${30.00}    in=${45.00}
    &{online_unassisted_percentage}    Create Dictionary    sg=${0.12}    hk=${0.15}    in=${0.25}
    ${country}    Convert To Lowercase    ${country}
    Log    ${base_or_nett_fare}
    Log    ${query}
    ${transaction_fee_amount}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${online_unassisted_amount}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${transaction_fee_percentage}    Run Keyword If    "${query}" == "${EMPTY}"    Get From Dictionary    ${online_unassisted_percentage}    ${country}
    ...    ELSE    Set Variable    ${query}
    ${computed_transansaction_fee}    Run Keyword If    "${fee_amount_percent_cap}" == "Percentage"    Evaluate    ${base_or_nett_fare} * ${transaction_fee_percentage}
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    Comment    ${transaction_fee}    Round To Nearest Dollar    ${computed_transansaction_fee}    ${country}    ${rounding_so}
    Set Test Variable    ${transaction_fee}    ${computed_transansaction_fee}
    [Return]    ${transaction_fee}

Get Value on Specific Field
    [Arguments]    ${field_name}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ${field_name}
    ${actual_field_value}    Get Control Text Value    ${object_name}
    [Return]    ${actual_field_value}

Get YQ Tax From TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Activate Power Express Window
    Click GDS Screen Tab
    Enter GDS Command    RT    ${gds_command}/${segment_number}
    ${data_clipboard}    Get Clipboard Data Amadeus
    ${yq_tax}    Get Lines Containing String    ${data_clipboard}    YQ
    ${yq_tax}    Get String Matching Regexp    [0-9]+\-YQ    ${yq_tax}
    ${yq_tax}    Run Keyword If    "${yq_tax}" != "0"    Fetch From Left    ${yq_tax}    -
    Run Keyword If    "${yq_tax}" == "${EMPTY}" or "${yq_tax}" == "None"    Set Test Variable    ${yq_tax}    0
    ${yq_tax}    Remove All Non-Integer (retain period)    ${yq_tax}
    Set Suite Variable    ${yq_tax_${fare_tab_index}}    ${yq_tax}
    Enter GDS Command    RT

Handle Amount Conversion Error
    [Arguments]    ${amount}
    Log    Current Amount: ${amount}
    ${amount}    Convert To String    ${amount}
    ${decimal}    Fetch From Right    ${amount}    .
    ${whole_number}    Fetch From Left    ${amount}    .
    ${rounded_up_value}    Evaluate    str( int(${whole_number}) + 1 )
    ${amount}    Set Variable If    "${decimal}" == "00"    ${whole_number}    ${rounded_up_value}
    Log    New Amount: ${amount}
    [Return]    ${amount}

Merchant Fee Percentage In Database
    [Arguments]    ${str_card_type}
    Set Test Variable    ${merchant_fee_value}    0.00
    Set Test Variable    ${hk_merchant_fee_tp}    1.30
    Set Test Variable    ${hk_merchant_fee_ax}    1.80
    Set Test Variable    ${hk_merchant_fee_ca}    2.30
    Set Test Variable    ${hk_merchant_fee_dc}    2.80
    Set Test Variable    ${hk_merchant_fee_vi}    3.80
    Set Test Variable    ${sg_merchant_fee_ax}    1.50
    Set Test Variable    ${sg_merchant_fee_ca}    2.00
    Set Test Variable    ${sg_merchant_fee_dc}    2.50
    Set Test Variable    ${sg_merchant_fee_tp}    3.50
    Set Test Variable    ${sg_merchant_fee_vi}    4.00
    Set Test Variable    ${in_merchant_fee_ax}    3.00
    Set Test Variable    ${in_merchant_fee_ca}    3.50
    Set Test Variable    ${in_merchant_fee_dc}    4.00
    Set Test Variable    ${in_merchant_fee_tp}    4.50
    Set Test Variable    ${in_merchant_fee_vi}    5.00
    Run Keyword If    "${country}" == "HK" and "${str_card_type}" == "AX"    Set Suite Variable    ${merchant_fee_value}    ${hk_merchant_fee_ax}
    ...    ELSE IF    "${country}" == "HK" and "${str_card_type}" == "CA"    Set Suite Variable    ${merchant_fee_value}    ${hk_merchant_fee_ca}
    ...    ELSE IF    "${country}" == "HK" and "${str_card_type}" == "DC"    Set Suite Variable    ${merchant_fee_value}    ${hk_merchant_fee_dc}
    ...    ELSE IF    "${country}" == "HK" and "${str_card_type}" == "TP"    Set Suite Variable    ${merchant_fee_value}    ${hk_merchant_fee_tp}
    ...    ELSE IF    "${country}" == "HK" and "${str_card_type}" == "VI"    Set Suite Variable    ${merchant_fee_value}    ${hk_merchant_fee_vi}
    Run Keyword If    "${country}" == "SG" and "${str_card_type}" == "AX"    Set Suite Variable    ${merchant_fee_value}    ${sg_merchant_fee_ax}
    ...    ELSE IF    "${country}" == "SG" and "${str_card_type}" == "CA"    Set Suite Variable    ${merchant_fee_value}    ${sg_merchant_fee_ca}
    ...    ELSE IF    "${country}" == "SG" and "${str_card_type}" == "DC"    Set Suite Variable    ${merchant_fee_value}    ${sg_merchant_fee_dc}
    ...    ELSE IF    "${country}" == "SG" and "${str_card_type}" == "TP"    Set Suite Variable    ${merchant_fee_value}    ${sg_merchant_fee_tp}
    ...    ELSE IF    "${country}" == "SG" and "${str_card_type}" == "VI"    Set Suite Variable    ${merchant_fee_value}    ${sg_merchant_fee_vi}
    Run Keyword If    "${country}" == "IN" and "${str_card_type}" == "AX"    Set Suite Variable    ${merchant_fee_value}    ${in_merchant_fee_ax}
    ...    ELSE IF    "${country}" == "IN" and "${str_card_type}" == "CA"    Set Suite Variable    ${merchant_fee_value}    ${in_merchant_fee_ca}
    ...    ELSE IF    "${country}" == "IN" and "${str_card_type}" == "DC"    Set Suite Variable    ${merchant_fee_value}    ${in_merchant_fee_dc}
    ...    ELSE IF    "${country}" == "IN" and "${str_card_type}" == "TP"    Set Suite Variable    ${merchant_fee_value}    ${in_merchant_fee_tp}
    ...    ELSE IF    "${country}" == "IN" and "${str_card_type}" == "VI"    Set Suite Variable    ${merchant_fee_value}    ${in_merchant_fee_vi}
    Set Suite Variable    ${merchant_fee_value}
    [Return]    ${merchant_fee_value}

Populate All Mandatory Fields On Air Fare Panel
    [Arguments]    ${fare_tab_value}    ${international_routing_value}    ${fare_value}    ${lowest_fareCC_value}    ${routing_geography_value}    ${trans_fee_value}
    ${tab_number}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Run Keyword If    "${routing_value_${tab_number}}" != "${EMPTY}"    Set Field Value    cmtxtRouting    ${routing_value_${tab_number}}-___-___
    ...    ELSE    Set Field Value    cmtxtRouting    ${international_routing_value}
    Populate High, Charge and Low Fares on Air Fare Panel    ${tab_number}    ${fare_value}
    Populate Air Fare Savings Code Using Default Values
    Run Keyword If    "${lfcc_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtLowestFareCC    ${lfcc_value_${tab_number}}
    ...    ELSE    Set Field Value    ctxtLowestFareCC    ${lowest_fareCC_value}
    Comment    Run Keyword If    "${route_code_value_${tab_number}}" != "${EMPTY}"    Set Field Value    cbRouteGeographyCode    ${route_code_value_${tab_number}}
    ...    ELSE    Set Field Value    cbRouteGeographyCode    ${routing_geography_value}
    Run Keyword If    "${route_code_value_${tab_number}}" != "${EMPTY}"    Select Route Code Value    ${route_code_value_${tab_number}}
    ...    ELSE    Select Route Code Value    ${routing_geography_value}
    Run Keyword If    "${transaction_fee_value_${tab_number}}" != "${EMPTY}"    Set Field Value    cbTransactionFee    ${transaction_fee_value_${tab_number}}
    ...    ELSE    Set Field Value    cbTransactionFee    ${trans_fee_value}
    Populate Fare Restrictions To Default Value

Populate High, Charge and Low Fares on Air Fare Panel
    [Arguments]    ${tab_number}    ${fare_value}
    Run Keyword If    "${high_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtHighFare    ${high_fare_value_${tab_number}}
    ...    ELSE IF    "${charged_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtHighFare    ${charged_fare_value_${tab_number}}
    ...    ELSE    Set Field Value    ${high_fare_value_${tab_number}}    ${fare_value}
    ${evaluate_charge_vs_high}    Run Keyword And Return Status    Should be True    ${charged_fare_value_${tab_number}} >= ${high_fare_value_${tab_number}}
    Run Keyword If    ${evaluate_charge_vs_high} == True    Set Field Value    ctxtChargedFare    ${high_fare_value_${tab_number}}
    ...    ELSE IF    "${charged_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtChargedFare    ${charged_fare_value_${tab_number}}
    ...    ELSE IF    "${high_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtChargedFare    ${high_fare_value_${tab_number}}
    ...    ELSE    Set Field Value    ctxtChargedFare    ${fare_value}
    ${evaluate_charge_vs_low}    Run Keyword And Return Status    Should be True    ${low_fare_value_${tab_number}} >= ${charged_fare_value_${tab_number}}
    Run Keyword If    ${evaluate_charge_vs_low} == True and ${evaluate_charge_vs_high} == True    Set Field Value    ctxtLowFare    ${high_fare_value_${tab_number}}
    ...    ELSE IF    "${low_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtLowFare    ${low_fare_value_${tab_number}}
    ...    ELSE IF    "${high_fare_value_${tab_number}}" != "${EMPTY}"    Set Field Value    ctxtLowFare    ${high_fare_value_${tab_number}}
    ...    ELSE    Set Field Value    ctxtLowFare    ${fare_value}

Populate Main Fees
    [Arguments]    ${transaction_fee}    ${airline_commission}=${EMPTY}    ${nett_fare}=${EMPTY}    ${commission_return}=${EMPTY}    ${merchant_fee_percent}=${EMPTY}    ${markup_percent}=${EMPTY}
    ...    ${fuel_surcharge}=${EMPTY}
    ${point_of_obj}    Determine Multiple Object Name Based On Active Tab    ctxtTotalAmount
    ${index}    Remove All Non-Integer (retain period)    ${point_of_obj}
    ${isenabled_transactionFee}    Determine Control Object Is Enable On Active Tab    cbTransactionFee
    ${is_enabled_nett}    Determine Control Object Is Enable On Active Tab    txtNetFare
    ${is_enabled_fuelSur}    Determine Control Object Is Enable On Active Tab    ctxtFuelSurcharge
    ${is_enabled_merchantFee}    Determine Control Object Is Enable On Active Tab    ctxtMerchantFeePercent
    ${is_enabled_markUp}    Determine Control Object Is Enable On Active Tab    ctxtMarkUpPercent
    Run Keyword If    '${is_enabled_nett}' == 'True'    Set Nett Fare Field    ${index}    ${nett_fare}
    Run Keyword If    '${isenabled_transactionFee}' == 'True'    Set Transaction Fee    ${transaction_fee}
    Run Keyword If    '${is_enabled_fuelSur}' == 'True'    Set Fuel Surcharge Field    ${fuel_surcharge}
    Run Keyword If    '${is_enabled_merchantFee}' == 'True'    Set Merchant Fee Percentage Field    ${merchant_fee_percent}
    Run Keyword If    '${is_enabled_markUp}' == 'True'    Set MarkUp Percentage    ${index}    ${markup_percent}
    ${isenabled_airlineComm}    Determine Control Object Is Enable On Active Tab    ctxtAirlineCommissionPercent
    ${isenabled_commReturn}    Determine Control Object Is Enable On Active Tab    ctxtCommissionPercent
    Run Keyword If    '${isenabled_airlineComm}' == 'True'    Set Airline Commission Percentage    ${airline_commission}
    Run Keyword If    '${isenabled_commReturn}' == 'True'    Set Commission Rebate Percentage    ${commission_return}

Set Mark Up Amount To Empty
    ${mark_up_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount
    Set Field To Empty    ${mark_up_name}

Set MarkUp Percentage
    [Arguments]    ${fare_tab}    ${mark_up_percentage}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent, ctxtMarkUpPercent_alt
    Set Control Text Value    ${object_name}    ${EMPTY}
    Click Control Button    ${object_name}
    Send    ${mark_up_percentage}
    Send    {TAB}
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${mark_up_percentage_value_${fare_tab_index}}    ${mark_up_percentage}
    Take Screenshot

Set Merchant Fee Amount To Empty
    ${merchant_fee_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount
    Set Field To Empty    ${merchant_fee_name}

Set Merchant Fee Percentage To Empty
    ${merchant_fee_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent
    Set Field To Empty    ${merchant_fee_name}

Set New Variable Names On Alternate Fare
    [Arguments]    ${fare_tab}    ${from_new_booking}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${from_new_booking}    Get Substring    ${TEST NAME}    1    3
    ${identifier}    Set Variable If    '${from_new_booking}' == 'NB'    newbooking    amend
    Get Alternate Fare Details    ${fare_tab}    APAC
    Get Main Fees On Fare Quote Tab    ${fare_tab}
    Comment    Get Main Fees On Fare Quote Tab    ${fare_tab}
    ${fare_basis}    Get Variable Value    ${fare_basis_alt_${fare_tab_index}}    0
    ${airline_offer_alt}    Get Variable Value    ${airline_offer_alt_${fare_tab_index}}    0
    ${fare_class_offer}    Get Variable Value    ${fare_class_offer_${fare_tab_index}}    0
    ${fare_class_offer_text}    Get Variable Value    ${fare_class_offer_text_${fare_tab_index}}    0
    ${fare_class_offer_code}    Get Variable Value    ${fare_class_offer_code_${fare_tab_index}}    0
    ${details_offer_alt}    Get Variable Value    ${details_offer_alt_${fare_tab_index}}    0
    ${alternate_airline_details}    Get Variable Value    ${alternate_airline_details_${fare_tab_index}}    0
    ${total_fare_alt}    Get Variable Value    ${total_fare_alt_${fare_tab_index}}    0
    ${city_names}    Get Variable Value    ${city_names_${fare_tab_index}}    0
    ${city_names_with_dash}    Get Variable Value    ${city_names_with_dash_${fare_tab_index}}    0
    ${city_names_with_slash}    Get Variable Value    ${city_names_with_slash_${fare_tab_index}}    0
    ${routing_value_alt}    Get Variable Value    ${routing_value_alt_${fare_tab_index}}    0
    ${commission_rebate_value_alt}    Get Variable Value    ${commission_rebate_value_alt_${fare_tab_index}}    0
    ${commission_rebate_percentage_value_alt}    Get Variable Value    ${commission_rebate_percentage_value_alt_${fare_tab_index}}    0
    ${fare_including_taxes_alt}    Get Variable Value    ${fare_including_taxes_alt_${fare_tab_index}}    0
    ${fuel_surcharge_value_alt}    Get Variable Value    ${fuel_surcharge_value_alt_${fare_tab_index}}    0
    ${mark_up_value_alt}    Get Variable Value    ${mark_up_value_alt_${fare_tab_index}}    0
    ${mark_up_percentage_value_alt}    Get Variable Value    ${mark_up_percentage_value_alt_${fare_tab_index}}    0
    ${merchant_fee_value_alt}    Get Variable Value    ${merchant_fee_value_alt_${fare_tab_index}}    0
    ${merchant_fee_percentage_value_alt}    Get Variable Value    ${merchant_fee_percentage_value_alt_${fare_tab_index}}    0
    ${nett_fare_value_alt}    Get Variable Value    ${nett_fare_value_alt_${fare_tab_index}}    0
    ${total_amount_alt}    Get Variable Value    ${total_amount_alt_${fare_tab_index}}    0
    ${transaction_fee_value_alt}    Get Variable Value    ${transaction_fee_value_alt_${fare_tab_index}}    0
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fare_basis_${fare_tab_index}}    ${fare_basis}
    ...    ELSE    Set Suite Variable    ${amend_fare_basis_${fare_tab_index}}    ${fare_basis}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_airline_offer_alt_${fare_tab_index}}    ${airline_offer_alt}
    ...    ELSE    Set Suite Variable    ${amend_airline_offer_alt_${fare_tab_index}}    ${airline_offer_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fare_class_offer_${fare_tab_index}}    ${fare_class_offer}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_${fare_tab_index}}    ${fare_class_offer}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fare_class_offer_text_${fare_tab_index}}    ${fare_class_offer_text}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_text_${fare_tab_index}}    ${fare_class_offer_text}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fare_class_offer_code_${fare_tab_index}}    ${fare_class_offer_code}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_code_${fare_tab_index}}    ${fare_class_offer_code}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_details_offer_alt_${fare_tab_index}}    ${details_offer_alt}
    ...    ELSE    Set Suite Variable    ${amend_details_offer_alt_${fare_tab_index}}    ${details_offer_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_alternate_airline_details_${fare_tab_index}}    ${alternate_airline_details}
    ...    ELSE    Set Suite Variable    ${amend_alternate_airline_details_${fare_tab_index}}    ${alternate_airline_details}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_total_fare_alt_${fare_tab_index}}    ${total_fare_alt}
    ...    ELSE    Set Suite Variable    ${amend_total_fare_alt_${fare_tab_index}}    ${total_fare_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_city_names_${fare_tab_index}}    ${city_names}
    ...    ELSE    Set Suite Variable    ${amend_city_names_${fare_tab_index}}    ${city_names}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    ...    ELSE    Set Suite Variable    ${amend_city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    ...    ELSE    Set Suite Variable    ${amend_city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_routing_value_alt_${fare_tab_index}}    ${routing_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_routing_value_alt_${fare_tab_index}}    ${routing_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_commission_rebate_value_alt_${fare_tab_index}}    ${commission_rebate_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_commission_rebate_value_alt_${fare_tab_index}}    ${commission_rebate_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_commission_rebate_percentage_value_alt_${fare_tab_index}}    ${commission_rebate_percentage_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_commission_rebate_percentage_value_alt_${fare_tab_index}}    ${commission_rebate_percentage_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fare_including_taxes_alt_${fare_tab_index}}    ${fare_including_taxes_alt}
    ...    ELSE    Set Suite Variable    ${amend_fare_including_taxes_alt_${fare_tab_index}}    ${fare_including_taxes_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_fuel_surcharge_value_alt_${fare_tab_index}}    ${fuel_surcharge_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_fuel_surcharge_value_alt_${fare_tab_index}}    ${fuel_surcharge_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_mark_up_value_alt_${fare_tab_index}}    ${mark_up_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_mark_up_value_alt_${fare_tab_index}}    ${mark_up_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_mark_up_percentage_value_alt_${fare_tab_index}}    ${mark_up_percentage_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_mark_up_percentage_value_alt_${fare_tab_index}}    ${mark_up_percentage_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_merchant_fee_value_alt_${fare_tab_index}}    ${merchant_fee_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_merchant_fee_value_alt_${fare_tab_index}}    ${merchant_fee_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_merchant_fee_percentage_value_alt_${fare_tab_index}}    ${merchant_fee_percentage_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_merchant_fee_percentage_value_alt_${fare_tab_index}}    ${merchant_fee_percentage_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_nett_fare_value_alt_${fare_tab_index}}    ${nett_fare_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_nett_fare_value_alt_${fare_tab_index}}    ${nett_fare_value_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_total_amount_alt_${fare_tab_index}}    ${total_amount_alt}
    ...    ELSE    Set Suite Variable    ${amend_total_amount_alt_${fare_tab_index}}    ${total_amount_alt}
    Comment    Run Keyword If    "${from_new_booking}" == "True"    Set Suite Variable    ${newbooking_transaction_fee_value_alt_${fare_tab_index}}    ${transaction_fee_value_alt}
    ...    ELSE    Set Suite Variable    ${amend_transaction_fee_value_alt_${fare_tab_index}}    ${transaction_fee_value_alt}
    Set Suite Variable    ${${identifier}_fare_basis_${fare_tab_index}}    ${fare_basis}
    Set Suite Variable    ${${identifier}_airline_offer_alt_${fare_tab_index}}    ${airline_offer_alt}
    Set Suite Variable    ${${identifier}_fare_class_offer_${fare_tab_index}}    ${fare_class_offer}
    Set Suite Variable    ${${identifier}_fare_class_offer_text_${fare_tab_index}}    ${fare_class_offer_text}
    Set Suite Variable    ${${identifier}_fare_class_offer_code_${fare_tab_index}}    ${fare_class_offer_code}
    Set Suite Variable    ${${identifier}_details_offer_alt_${fare_tab_index}}    ${details_offer_alt}
    Set Suite Variable    ${${identifier}_alternate_airline_details_${fare_tab_index}}    ${alternate_airline_details}
    Set Suite Variable    ${${identifier}_total_fare_alt_${fare_tab_index}}    ${total_fare_alt}
    Set Suite Variable    ${${identifier}_city_names_${fare_tab_index}}    ${city_names}
    Set Suite Variable    ${${identifier}_city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    Set Suite Variable    ${${identifier}_city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    Set Suite Variable    ${${identifier}_routing_value_alt_${fare_tab_index}}    ${routing_value_alt}
    Set Suite Variable    ${${identifier}_commission_rebate_value_alt_${fare_tab_index}}    ${commission_rebate_value_alt}
    Set Suite Variable    ${${identifier}_commission_rebate_percentage_value_alt_${fare_tab_index}}    ${commission_rebate_percentage_value_alt}
    Set Suite Variable    ${${identifier}_fare_including_taxes_alt_${fare_tab_index}}    ${fare_including_taxes_alt}
    Set Suite Variable    ${${identifier}_fuel_surcharge_value_alt_${fare_tab_index}}    ${fuel_surcharge_value_alt}
    Set Suite Variable    ${${identifier}_mark_up_value_alt_${fare_tab_index}}    ${mark_up_value_alt}
    Set Suite Variable    ${${identifier}_mark_up_percentage_value_alt_${fare_tab_index}}    ${mark_up_percentage_value_alt}
    Set Suite Variable    ${${identifier}_merchant_fee_value_alt_${fare_tab_index}}    ${merchant_fee_value_alt}
    Set Suite Variable    ${${identifier}_merchant_fee_percentage_value_alt_${fare_tab_index}}    ${merchant_fee_percentage_value_alt}
    Set Suite Variable    ${${identifier}_nett_fare_value_alt_${fare_tab_index}}    ${nett_fare_value_alt}
    Set Suite Variable    ${${identifier}_total_amount_alt_${fare_tab_index}}    ${total_amount_alt}
    Set Suite Variable    ${${identifier}_transaction_fee_value_alt_${fare_tab_index}}    ${transaction_fee_value_alt}

Set Routing International On Air Fare Panel
    [Arguments]    ${routing_value}
    Set Field Value    cmtxtRouting    ${routing_value}
    SEND    {TAB}

Set Transaction Fee On Air Fare Panel
    [Arguments]    ${transaction_value}
    Set Field Value    cbTransactionFee    ${transaction_value}
    SEND    {TAB}

Set Transaction Fee Value Default Value If Empty
    [Arguments]    ${fare_tab}    ${transaction_fee_value}=10
    Get Transaction Fee Amount Value    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Run Keyword If    "${transaction_fee_value_${fare_tab_index}}" == "${EMPTY}"    Set Transaction Fee On Air Fare Panel    ${transaction_fee_value}

Transaction Fee In Database For Offline Fee Amount
    [Arguments]    ${start_substring}=4    ${end_substring}=6
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ${transaction_fee_amount_int}    Set Variable If    "${country}" == "SG"    120.00    "${country}" == "HK"    45    "${country}" == "IN"
    ...    1.12
    Run Keyword If    "${country}" == "IN"    Set Suite Variable    ${transaction_fee_amount_dom}    50.00
    Run Keyword If    "${country}" == "IN"    Log    ${transaction_fee_amount_dom}
    Comment    ${transaction_fee_amount_int}    Run Keyword If    "${country}" == "HK" or "${country}" == "IN"    Round Off    ${transaction_fee_amount_int}    0
    Comment    ${transaction_fee_amount_int}    Run Keyword If    "${country}" == "HK" or "${country}" == "IN"    Convert To Float    ${transaction_fee_amount_int}    0
    Comment    ${transaction_fee_amount_dom}    Run Keyword If    "${country}" == "IN"    Round Off    ${transaction_fee_amount_dom}    0
    Comment    ${transaction_fee_amount_dom}    Run Keyword If    "${country}" == "IN"    Convert To Float    ${transaction_fee_amount_dom}    0
    Set Suite Variable    ${transaction_fee_amount_int}
    Log    ${transaction_fee_amount_int}

Transaction Fee In Database For Offline Fee Percentage
    [Arguments]    ${start_substring}=4    ${end_substring}=6
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Set Suite Variable    ${country}
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${transaction_fee_percentage_int}    .0112
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${transaction_fee_percentage_int}    .0550
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${transaction_fee_percentage_int}    .0145
    Run Keyword If    "${country}" == "IN"    Set Suite Variable    ${transaction_fee_percentage_dom}    .1212

Transaction Fee In Database For Offline Range Fee Amount
    [Arguments]    ${start_substring}=4    ${end_substring}=6    ${country}=${EMPTY}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ...    ELSE    Set Variable    ${country}
    Set Suite Variable    ${country}
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_one}    100.67
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_one}    150
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_one}    200
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_two}    200.00
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_two}    250
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_two}    300
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_three}    300.25
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_three}    350
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_three}    400
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_four}    400.00
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_four}    450
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_four}    500
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_five}    500.00
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_five}    550
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_five}    600
    Comment    Run Keyword If    "${country}" == "IN"    Log    ${transaction_fee_amount_dom}
    Log    ${range_fee_one}
    Log    ${range_fee_two}
    Log    ${range_fee_three}
    Log    ${range_fee_four}
    Log    ${range_fee_five}

Transaction Fee In Database For Offline Range Fee Percentage
    [Arguments]    ${start_substring}=4    ${end_substring}=6    ${country}=${EMPTY}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ...    ELSE    Set Variable    ${country}
    Set Suite Variable    ${country}
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_one}    .015
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_one}    .02
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_one}    .03
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_two}    .02
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_two}    .03
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_two}    .06
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_three}    .025
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_three}    .04
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_three}    .09
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_four}    .03
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_four}    .05
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_four}    .12
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${range_fee_five}    .035
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${range_fee_five}    .06
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${range_fee_five}    .14
    Comment    Run Keyword If    "${country}" == "IN"    Log    ${transaction_fee_amount_dom}
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${cap}    50.00
    ...    ELSE IF    "${country}" == "HK" or "${country}" == "IN"    Set Suite Variable    ${cap}    50
    Log    ${range_fee_one}
    Log    ${range_fee_two}
    Log    ${range_fee_three}
    Log    ${range_fee_four}
    Log    ${range_fee_five}
    Log    ${cap}

Update FT Remark
    [Arguments]    ${agent_tour_code}    ${segment}    ${previous_tour_code}=${EMPTY}
    [Documentation]    ${previous_tour_code}=Previous Tour Code from the PNR
    ...
    ...    ${agent_tour_code}=It will be given by Agent(i.e Agent wants to Modify the existing tour code)
    ...
    ...    ${segment}=Give the Segment Number which Tour Code FT Remark Segment Line \ we need to modify
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTF    False
    ${number}    Run Keyword If    "${previous_tour_code}" != "${EMPTY}"    Get Line Number In Amadeus PNR Remarks    FT PAX *${previous_tour_code}/${segment}
    Log    ${number}
    Run Keyword If    "${previous_tour_code}" != "${EMPTY}"    Enter GDS Command    XE${number}
    Enter GDS Command    FT PAX *${agent_tour_code}/${segment}
    Enter GDS Command    RFCWTPEST
    Enter GDS Command    ER    ER

Update Transaction Fee Value
    [Arguments]    ${transaction_fee_amount}
    Activate Power Express Window
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    Click Control Button    ${object_name}
    Send    ${transaction_fee_amount}
    Send    {TAB}
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${transaction_fee_value_${fare_tab_index}}    ${transaction_fee_amount}
    Take Screenshot

Verfiy Default Restrictions Are Selected In Fare Tab
    [Arguments]    ${fare_tab}
    Click Fare Tab    ${fare_tab}
    Click Restriction Tab
    ${is_selected}    Get Radio Button State    Default
    Run Keyword If    ${is_selected}==True    Log    "Default Air Fare Restrictions selected"
    ...    ELSE    Log    "Default Air Fare Restrictions not selected"
    [Teardown]    Take Screenshot

Verify AF Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RMF AF-

Verify Accounting Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RM *MSX
    Verify Specific Line Is Not Written In The PNR    RM *MS

Verify Accounting Remarks For Commission Rebate
    [Arguments]    ${fare_tab}    ${segment_number}    ${airline_commission_or_client_rebate}=AIRLINE COMMISSION    ${start_substring}=4    ${end_substring}=6
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Set Suite Variable    ${segment_number}
    Set Suite Variable    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Suite Variable    ${fare_tab_index}
    Comment    Identify Form Of Payment Code For APAC    ${str_card_type}
    Run Keyword If    "${country}" == "SG"    Set Suite Variable    ${vendor_code}    V021007
    ...    ELSE IF    "${country}" == "HK"    Set Suite Variable    ${vendor_code}    V00001
    ...    ELSE IF    "${country}" == "IN"    Set Suite Variable    ${vendor_code}    V00800003
    ${segment_number_for_travcom}    Get Segment Number For Travcom    ${segment_number}
    Run Keyword If    "${airline_commission_or_client_rebate.upper()}" == "AIRLINE COMMISSION"    Verify Airline Commission Remarks    ${fare_tab_index}    ${segment_number_for_travcom}
    Run Keyword If    "${airline_commission_or_client_rebate.upper()}" == "CLIENT REBATE"    Verify Client Rebate Remarks    ${fare_tab_index}    ${segment_number_for_travcom}
    Verify FM Remarks For Airline Commission Is Written    ${fare_tab}    M    ${segment_number}
    Comment    Verify Specific Line Is Written In The PNR    FM PAX *M*${commission_rebate_percentage_value_${fare_tab_index}}/${segment_number}

Verify Accounting Remarks For Main Sale
    [Arguments]    ${fare_tab}    ${segment_number}    ${segment_long}    ${form_of_payment}    ${merchant}=${EMPTY}    ${country}=SG
    ...    ${is_exchange}=False
    [Documentation]    ${fare_tab} = Fare 1
    ...    ${segment_number} = S2
    ...    ${segment_long} = 02 --> this fall to travcom segment relate (ie. SG02)
    ...    ${form_of_payment} = AX378282246310005/D1220 or Cash
    ...    ${merchant} = CWT or Airline
    ...    ${country} = SG
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    ${fare_tab}    ${segment_number}    ${country}
    Verify LFCC Accounting Remark Is Written    ${fare_tab}    ${segment_number}
    Verify Routing Accounting Remarks Are Written    ${fare_tab}    ${segment_number}
    Verify FF30, FF8 and EC Account Remarks Are Written    ${fare_tab}    ${segment_number}
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    ${segment_number}
    #Verify PC Accounting Remark Is Written    ${segment_number}
    Verify FOP Remark Per TST Is Written    ${fare_tab}    ${segment_number}    ${form_of_payment}    ${country}    ${merchant}    is_exchange=${is_exchange}
    Verify Transaction Fee Remark Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segment_long}    ${form_of_payment}    ${country}
    Verify Merchant Fee Remarks Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segment_long}    ${form_of_payment}    ${country}    ${merchant}
    Verify Commission Rebate Remarks Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segment_long}    ${form_of_payment}    ${country}    ${is_exchange}
    Run Keyword If    "${country}" == "HK"    Verify Fuel Surcharge Remark Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segment_long}    ${form_of_payment}

Verify Adult Fare And Taxes Itinerary Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RIR ADULT FARE:

Verify Adult Fare And Taxes Itinerary Remarks Are Witten With Currency
    [Arguments]    ${fare_tab}=Fare 1    ${country}=SG    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    Get Grand Total Fare From Fare Quote    fare_tab=${fare_tab}    gds_command=${gds_command}
    ${currency}    Set Variable If    "${country.upper()}"=="SG"    SGD    "${country.upper()}"=="HK"    HKD    INR
    ${base_fare}    Set Variable If    "${fare_tab_type}"=="Fare"    ${base_fare_${fare_tab_index}}    ${alt_base_fare_${fare_tab_index}}
    ${nett_fare}    Set Variable If    "${fare_tab_type}"=="Fare"    ${nett_fare_${fare_tab_index}}    ${alt_nett_fare_${fare_tab_index}}
    ${grand_total}    Set Variable If    "${fare_tab_type}"=="Fare"    ${grand_total_fare_${fare_tab_index}}    ${alt_grand_total_fare_${fare_tab_index}}
    ${mark_up}    Set Variable If    "${fare_tab_type}"=="Fare"    ${mark_up_amount_${fare_tab_index}}    ${alt_mark_up_amount_${fare_tab_index}}
    ${commission_rebate}    Set Variable If    "${fare_tab_type}"=="Fare" and "${country.upper()}"!="IN"    ${commission_rebate_amount_${fare_tab_index}}    "${fare_tab_type}"=="Alternate" and "${country.upper()}"!="IN"    ${alt_commission_rebate_amount_${fare_tab_index}}    0
    ${adult_fare}    Run Keyword If    "${nett_fare}"=="0" and "${country}"!="IN"    Evaluate    (${base_fare}+${mark_up})-${commission_rebate}
    ...    ELSE IF    "${nett_fare}"!="0" and "${country}"!="IN"    Evaluate    (${nett_fare}+${mark_up})-${commission_rebate}
    ...    ELSE IF    "${nett_fare}"=="0" and "${country}"=="IN"    Evaluate    ${base_fare}+${mark_up}
    ...    ELSE IF    "${nett_fare}"!="0" and "${country}"=="IN"    Evaluate    ${nett_fare}+${mark_up}
    ${adult_fare}    Run Keyword If    "${country.upper()}"=="SG"    Convert To Float    ${adult_fare}
    ...    ELSE    Convert To Integer    ${adult_fare}
    ${tax}    Run Keyword If    "${nett_fare}"=="0"    Evaluate    ${grand_total}-${base_fare}
    ...    ELSE    ${grand_total}-${nett_fare}
    ${tax}    Run Keyword If    "${country.upper()}"=="SG"    Convert To Float    ${tax}
    ...    ELSE    Convert To Integer    ${tax}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Verify Specific Line Is Written In The PNR    RIR ADULT FARE: ${currency} ${adult_fare} PLUS ${currency} ${tax} TAXES
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR *OFFER**ADULT FARE: ${currency} ${adult_fare} PLUS ${currency} ${tax} TAXES*

Verify Adult Fare And Taxes Itinerary Remarks Are Written
    [Arguments]    ${fare_tab}    ${airline_commission_or_client_rebate}=Airline Commission    ${start_substring}=4    ${end_substring}=6    ${country}=${EMPTY}    ${is_ob_fee_present}=False
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_tab_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ...    ELSE    Set Variable    ${country}
    ${currency}    Get Currency    ${country}
    ${base_fare}    Set Variable    ${base_fare_${fare_tab_index}}
    ${grand_total}    Set Variable    ${grand_total_fare_${fare_tab_index}}
    ${mark_up}    Get Variable Value    ${mark_up_value_${fare_tab_index}}    0
    ${commission_rebate}    Get Variable Value    ${commission_rebate_value_${fare_tab_index}}    0
    ${adult_fare}    Evaluate    (${base_fare}+${mark_up})
    ${adult_fare}    Run Keyword If    ${commission_rebate} !=${0}    Evaluate    ${adult_fare}-${commission_rebate}
    ...    ELSE    Set Variable    ${adult_fare}
    ${adult_fare}    Round To Nearest Dollar    ${adult_fare}    ${country}
    Comment    ${adult_fare}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${adult_fare}
    ...    ELSE    Convert To Integer    ${adult_fare}
    ${tax}    Evaluate    ${grand_total} - ${base_fare}
    ${tax}    Run Keyword If    '${is_ob_fee_present}'=='True'    Evaluate    ${tax} + ${ob_fee_${fare_tab_index}}
    ...    ELSE    Set Variable    ${tax}
    ${tax}    Round To Nearest Dollar    ${tax}    ${country}
    Comment    ${tax}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${tax}
    ...    ELSE    Convert To Integer    ${tax}
    ${adult_fare_Remarks}    Set Variable If    "${fare_tab_type}" == "Fare"    RIR ADULT FARE: ${currency} ${adult_fare} PLUS ${currency} ${tax} TAXES    RIR *OFFER**ADULT FARE: ${currency} ${adult_fare} PLUS ${currency} ${tax} TAXES*
    Verify Specific Line Is Written In The PNR    ${adult_fare_Remarks}

Verify Adult Fare And Taxes Itinerary Remarks For Alternate Fare Are Not Written
    Verify Specific Line Is Not Written In The PNR    RIR *OFFER**ADULT FARE:

Verify Agent Sign Remark Is Written
    [Arguments]    ${gds_id}
    Verify Specific Line Is Written In The PNR    ${gds_id}

Verify Air Fare Fields Are Disabled
    Verify Routing Field Is Disabled
    Verify Turnaround Field Is Disabled
    Verify High Fare Field Is Disabled
    Verify Charged Fare Field Is Disabled
    Verify Low Fare Field Is Disabled
    Verify Realised Saving Code Field Is Disabled
    Verify Missed Savings Code Field Is Disabled
    Verify Class Code Field Is Disabled
    Verify LFCC Field Is Disabled
    Verify Route Code Field Is Disabled
    Verify Form Of Payment Field Is Disabled
    Verify Pencil Icon Is Disabled
    Verify Mask Icon Is Disabled
    Verify Commission Rebate Amount Field Is Disabled
    Verify Commission Rebate Percentage Field Is Disabled
    Comment    Verify Fare Including Airline Taxes Field Is Disabled    Fare 1
    Verify Nett Fare Field Is Disabled
    Verify Merchant Fee Fields Are Disabled    Fare 1
    Verify Transaction Fee Field Is Disabled
    Verify Total Field Is Disabled

Verify Air Fare Fields Are Enabled
    Verify Routing Field Is Enabled
    Verify Turnaround Field Is Enabled
    Verify High Fare Field Is Enabled
    Verify Charged Fare Field Is Enabled
    Verify Low Fare Field Is Enabled
    Verify Realised Saving Code Field Is Enabled
    Verify Missed Savings Code Field Is Enabled
    Verify Class Code Field Is Enabled
    Verify LFCC Field Is Enabled
    Verify Route Code Field Is Enabled
    Verify Form Of Payment Field Is Enabled
    Verify Nett Fare Field Is Enabled
    Verify Transaction Fee Field Is Enabled

Verify Air Fare Main Panel Is Disabled
    Verify Control Object Is Disabled    ${air_fare_tab}
    [Teardown]    Take Screenshot

Verify Air Fare Main Panel Is Enabled
    Verify Control Object Is Enabled    ${air_fare_tab}
    [Teardown]    Take Screenshot

Verify Air Fare Restriction Fields Are Disabled
    Verify Fully Flexible Fare Restriction Field Is Disabled
    Verify Semi Flexible Fare Restriction Field Is Disabled
    Verify Non Flexible Fare Restriction Field Is Disabled
    Verify Default Fare Restriction Field Is Disabled

Verify Air Fare Restriction Fields Are Enabled
    Verify Fully Flexible Fare Restriction Field Is Enabled
    Verify Semi Flexible Fare Restriction Field Is Enabled
    Verify Non Flexible Fare Restriction Field Is Enabled
    Verify Default Fare Restriction Field Is Enabled

Verify Air Fare Restriction Objects Are Hidden
    [Arguments]    ${fare_tab}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${index}    Set Variable If    ${is_fare_tab_alternate} == True    _alt_${fare_tab_index}    _${fare_tab_index}
    Verify Control Object Is Not Visible    [NAME:cradFullyFlex${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:cradSemiFlex${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:cradNonFlex${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboChanges0${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboCancellations0${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:btnAddChanges0${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:btnAddCancellations0${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboValidOn${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboReRoute${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboMinStay${index}]    ${title_power_express}
    Verify Control Object Is Not Visible    [NAME:ccboMaxStay${index}]    ${title_power_express}

Verify Air Fare Restriction Objects Are Visible
    [Arguments]    ${fare_tab}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${index}    Set Variable If    ${is_fare_tab_alternate} == True    _alt_${fare_tab_index}    _${fare_tab_index}
    Verify Control Object Is Visible    [NAME:cradFullyFlex${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:cradSemiFlex${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:cradNonFlex${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboChanges${index}_${fare_tab_index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboCancellations${index}_${fare_tab_index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:btnAddChanges${index}_${fare_tab_index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:btnAddCancellations${index}_${fare_tab_index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboValidOn${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboReRoute${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboMinStay${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboMaxStay${index}]    ${title_power_express}

Verify Air Fare Restriction Objects for OBT Are Visible
    [Arguments]    ${fare_tab}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${index}    Set Variable If    ${is_fare_tab_alternate} == True    _alt_${fare_tab_index}    _${fare_tab_index}
    Verify Control Object Is Visible    [NAME:cradFullFlexOBT${index}]    ${title_power_express}    #in non-OBT the name is cradFullyFlex (has Y)
    Verify Control Object Is Visible    [NAME:cradSemiFlexOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:cradNonFlexOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboChangesOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboCancellationsOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboValidOnOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboReRouteOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboValidOnOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboReRouteOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboMinStayOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboMaxStayOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ccboCompliantOBT${index}]    ${title_power_express}
    Verify Control Object Is Visible    [NAME:ctxtCommentsOBT${index}]    ${title_power_express}

Verify Air Fare Restriction Option Is Selected By Default
    [Arguments]    ${str_fare_restriction}
    ${air_fare_restriction_field}    Run Keyword If    "${str_fare_restriction.upper()}" == "FULLY FLEXIBLE"    Determine Multiple Object Name Based On Active Tab    cradFullyFlex, cradFullyFlex_alt, cradFullFlexOBT, cradFullFlexOBT_alt
    ...    ELSE IF    "${str_fare_restriction.upper()}" == "SEMI FLEXIBLE"    Determine Multiple Object Name Based On Active Tab    cradSemiFlexOBT, cradSemiFlex, cradSemiFlex_alt, cradSemiFlexOBT_alt
    ...    ELSE IF    "${str_fare_restriction.upper()}" == "NON FLEXIBLE"    Determine Multiple Object Name Based On Active Tab    cradNonFlex, cradNonFlexOBT, cradNonFlex_alt, cradNonFlexOBT_alt
    ...    ELSE IF    "${str_fare_restriction.upper()}" == "DEFAULT"    Determine Multiple Object Name Based On Active Tab    cradDefault, cradDefaultOBT, cradDefault_alt, cradDefaultOBT_alt
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Invalid Fare Restriction: ${str_fare_restriction}
    ${is_radiobutton_selected}    Get Radio Button Status    ${air_fare_restriction_field}
    Run Keyword And Continue On Failure    Should Be True    ${is_radiobutton_selected} == True    "${str_fare_restriction}" restriction should be selected by default.
    [Teardown]    Take Screenshot

Verify Air Fare Restriction Remarks on Amadeus
    [Arguments]    ${fare_tab}    @{restrictions}
    ${alternate_fare}    Run Keyword And Return Status    Should Contain    ${fare_tab}    Alt
    Run Keyword If    ${alternate_fare} == True    Verify Alternate Fare Restriction Remarks In PNR    @{restrictions}
    ...    ELSE    Verify Fare Restriction Remarks In PNR    @{restrictions}

Verify Air Fare Restrictions Dropdown Values
    [Arguments]    ${fare_tab}    @{expected_restrictions}
    ${tab_number}    Remove All Non Numeric    ${fare_tab}
    Wait Until Mouse Cursor Wait Is Completed
    Wait Until Control Object Is Ready    [NAME:AirRestrictionItems_${tab_number}]
    ${actual_restriction_dropdown_values}    Get Dropdown Values    [NAME:AirRestrictionItems_${tab_number}]
    Lists Should Be Equal    ${actual_restriction_dropdown_values}    ${expected_restrictions}
    [Teardown]    Take Screenshot

Verify Air Fare Restrictions Present In Itinerary Remarks Panel
    [Arguments]    ${fare_tab}    @{restrictions}
    ${tab_number}    Remove All Non Numeric    ${fare_tab}
    Wait Until Control Object Is Enabled    [NAME:AirRestrictionRemarks_${tab_number}]
    ${actual_restrictions}    Get All Cell Values In Data Grid Pane    [NAME:AirRestrictionRemarks_${tab_number}]
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${restrictions}    ${actual_restrictions}
    [Teardown]    Run Keywords    Take Screenshot
    ...    AND    Select Tab Control    Air Fare    FareDetailsAndFeesTab

Verify Airline Commission Percentage And Commission Rebate Percentage Are Equal
    [Arguments]    ${fare_tab}=Fare 1
    Get Airline Commisison Percentage Value    fare_tab=${fare_tab}
    Get Commission Rebate Percentage Value    fare_tab=${fare_tab}
    Verify Actual Value Matches Expected Value    ${airline_commission_percentage_${fare_tab_index}}    ${commission_rebate_percentage_value_${fare_tab_index}}

Verify Airline Commission Remarks
    [Arguments]    ${fare_tab_index}    ${segment_number_for_travcom}
    Verify Specific Line Is Not Written In The PNR    RM *MS/PC50/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    RM *MSX/S-${commission_rebate_value_${fare_tab_index}}/SF-${commission_rebate_value_${fare_tab_index}}/C-${commission_rebate_value_${fare_tab_index}}/SG0${segment_number_for_travcom}/${segment_number}    multi_line_search_flag=true
    Comment    Verify Specific Line Is Not Written In The PNR    RM *MSX/FS/${segment_number}    multi_line_search_flag=true
    Comment    Run Keyword If    "${country}" != "IN"    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF REBATE/S${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true

Verify All Mandatory Fields On Air Fare Panel
    Verify Mandatory Field    cmtxtRouting    True
    Send    {TAB}
    Verify Mandatory Field    ccboPOT
    Send    {TAB}
    Verify Mandatory Field    ctxtHighFare    True
    Verify Mandatory Field    ctxtChargedFare    True
    Verify Mandatory Field    ctxtLowFare    True
    Verify Mandatory Field    ccboMissed
    Verify Mandatory Field    ccboClass
    Verify Mandatory Field    ctxtLowestFareCC    True
    Comment    Verify Mandatory Field For Dropdown List    cbRouteGeographyCode    True
    Verify Mandatory Field    cbTransactionFee    True

Verify Alternate Fare Details Are Disabled
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${index}    Set Variable    _alt_${fare_tab_index}
    Verify Control Object Is Disabled    [NAME:cradFullyFlex${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:cradSemiFlex${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:cradNonFlex${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboChanges0${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboCancellations0${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:btnAddChanges0${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:btnAddCancellations0${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboValidOn${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboReRoute${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboMinStay${index}]    ${title_power_express}
    Verify Control Object Is Disabled    [NAME:ccboMaxStay${index}]    ${title_power_express}

Verify Alternate Fare Details Are Written In Remarks
    [Arguments]    ${fare_details_offer}
    Set Test Variable    ${str_data}    ${fare_details_offer}
    @{fare_details_offer}    Split To Lines    ${str_data}
    : FOR    ${element}    IN    @{fare_details_offer}
    \    Verify Text Contains Expected Value    ${pnr_details}    *OFFER**MORE INFO: ${element}

Verify Alternate Fare Details Field
    [Arguments]    ${fare_tab_value}
    ${fare_tab_index}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    ${actual_alt_fare_details}    Get Control Text Value    [NAME:ctxtDetailsOffer_alt_${fare_tab_index}]
    ${flight_number_length} =    Get Length    ${flight_number}
    ${flight_number} =    Set Variable If    '${flight_number_length}' == '2' and '${GDS_switch}' != 'sabre'    ${SPACE}${SPACE}${flight_number}    '${flight_number_length}' == '3' and '${GDS_switch}' != 'sabre'    ${SPACE}${flight_number}    ${flight_number}
    ${flight_number} =    Set Variable If    '${flight_number_length}' == '2' and '${GDS_switch}' == 'sabre'    00${flight_number}    '${flight_number_length}' == '3' and '${GDS_switch}' == 'sabre'    0${flight_number}    ${flight_number}
    ${converted_actual_alt_fare_details}    Remove All Spaces    ${actual_alt_fare_details}
    ${converted_expected_alt_fare_details}    Remove All Spaces    ${airline_code}${flight_number}${SPACE}${fare_class}${SPACE}${flight_date}${SPACE}${flight_origin}${SPACE}${flight_destination}
    Run Keyword If    '${GDS_switch}' != 'galileo'    Verify Text Contains Expected Value    ${actual_alt_fare_details}    ${airline_code}${flight_number}${SPACE}${fare_class}${SPACE}${flight_date}${SPACE}${flight_origin}${SPACE}${flight_destination}
    ...    ELSE    Verify Text Contains Expected Value    ${converted_actual_alt_fare_details}    ${converted_expected_alt_fare_details}
    [Teardown]    Take Screenshot

Verify Alternate Fare Itinerary Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RIR *OFFER*

Verify Alternate Fare Itinerary Remarks Are Written
    [Arguments]    ${alt_fare_tab}
    ${fare_tab_index}    Fetch From Right    ${alt_fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${new_or_amend}    Get Substring    ${TEST NAME}    1    3
    ${currency}    Run Keyword If    "${country}" == "SG"    Set Variable    SGD
    ...    ELSE IF    "${country}" == "HK"    Set Variable    HKD
    ...    ELSE IF    "${country}" == "IN"    Set Variable    INR
    ${mark_up_value}    Get Variable Value    ${mark_up_value_alt_${fare_tab_index}}    0
    ${base_fare}    Evaluate    ${base_fare_alt_${fare_tab_index}} + ${mark_up_value} - ${commission_rebate_value_alt_${fare_tab_index}}
    ${base_fare}    Round Apac    ${base_fare}    ${country}
    Get Remarks Leading And Succeeding Line Numbers    FARE OPTION 0${fare_tab_index}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RIR *OFFER**<B>FARE OPTION 0${fare_tab_index}</B>*
    Verify Specific Line Is Written In The PNR    ${remarks_2} RIR *OFFER**ROUTING: ${city_names_with_slash_alt_${fare_tab_index}}*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_3} RIR *OFFER**AIRLINE: ${airline_offer_alt_${fare_tab_index}}*
    Verify Specific Line Is Written In The PNR    ${remarks_4} RIR *OFFER**FARE BASIS: ${fare_basis_value_${fare_tab_index}}*
    Verify Specific Line Is Written In The PNR    ${remarks_5} RIR *OFFER**ADULT FARE: ${currency} ${base_fare} PLUS ${currency} ${total_tax_alt_${fare_tab_index}} TAXES*
    Get Remarks Leading And Succeeding Line Numbers    TOTAL FARE OPTION: ${currency} ${total_amount_alt_${fare_tab_index}}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RIR *OFFER**TOTAL FARE OPTION: ${currency} ${total_amount_alt_${fare_tab_index}}*
    Comment    Run Keyword If    "${new_or_amend}" == "NB"    \    \    multi_line_search_flag=true
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_2} RIR *OFFER**ROUTING: ${amend_city_names_with_slash_${fare_tab_index}}*    ${multi_line_search_flag}=true
    Comment    Run Keyword If    "${new_or_amend}" == "NB"    Verify Specific Line Is Written In The PNR    ${remarks_3} RIR *OFFER**AIRLINE: ${airline_offer_alt_${fare_tab_index}}*
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_3} RIR *OFFER**AIRLINE: ${amend_airline_offer_alt_${fare_tab_index}}*
    Comment    Run Keyword If    "${new_or_amend}" == "NB"    Verify Specific Line Is Written In The PNR    ${remarks_4} RIR *OFFER**FARE BASIS: ${fare_basis_${fare_tab_index}}*
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_4} RIR *OFFER**FARE BASIS: ${amend_fare_basis_${fare_tab_index}}*
    Comment    Run Keyword If    "${new_or_amend}" == "NB"    Verify Specific Line Is Written In The PNR    ${remarks_5} RIR *OFFER**ADULT FARE: ${currency} ${grand_total_fare_alt_${fare_tab_index}} PLUS 0 TAXES*
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_5} RIR *OFFER**ADULT FARE: ${currency} ${grand_total_fare_alt_${fare_tab_index}} PLUS 0 TAXES*
    Comment    Run Keyword If    "${new_or_amend}" == "NB"    Verify Specific Line Is Written In The PNR    ${remarks_6} RIR *OFFER**TOTAL LOWER FARE OPTION: ${grand_total_fare_alt_${fare_tab_index}}*
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_6} RIR *OFFER**TOTAL LOWER FARE OPTION: ${amend_grand_total_fare_alt_${fare_tab_index}}*
    Comment    @{split_lines}    Run Keyword If    "${new_or_amend}" == "NB"    Split To Lines    ${airline_details_alt_${fare_tab_index}}
    ...    ELSE    Split To Lines    ${amend_airline_details_alt_${fare_tab_index}}
    @{split_lines}    Split To Lines    ${details_offer_alt_${fare_tab_index}}
    Set Test Variable    ${new_remarks}    ${remarks_1}
    : FOR    ${line}    IN    @{split_lines}
    \    ${new_remarks}    Evaluate    ${new_remarks}+1
    \    Verify Specific Line Is Written In The PNR    ${new_remarks} RIR *OFFER**DETAILS: ${line}*    multi_line_search_flag=true
    Comment    ${remarks_count}    Set Variable    0
    Comment    ${counter}    Set Variable    0
    Comment    :FOR    ${remarks_count}    IN RANGE    0    10
    Comment    \    ${remarks_count}    Evaluate    ${new_remarks} + ${remarks_count}
    Comment    \    ${counter}    Evaluate    ${counter} + 1
    Comment    \    Set Suite Variable    ${remarks_${counter}}    ${remarks_count}
    Comment    \    Log    TEST::::- ${remarks_count} -and- ${remarks_${counter}}
    Get Remarks Leading And Succeeding Line Numbers    ${new_remarks} RIR
    Verify Specific Line Is Written In The PNR    ${remarks_2} RIR *OFFER**THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_3} RIR *OFFER**INCREASE. CHANGES/CANCELLATION MAY BE SUBJECT TO*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_4} RIR *OFFER**A PENALTY OR FARE INCREASE UP TO AND INCLUDING THE*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_5} RIR *OFFER**TOTAL COST OF THE TICKET. NO REFUND FOR UNUSED*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_6} RIR *OFFER**PORTION ON CERTAIN FARES. TO RETAIN VALUE OF YOUR*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_7} RIR *OFFER**TICKET,YOU MUST CANCEL THE RESERVATION ON OR*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_8} RIR *OFFER**BEFORE YOUR TICKETED DEPARTURE TIME*    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_9} RIR *OFFER**ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE*    multi_line_search_flag=true

Verify Alternate Fare Remarks Are Written In The PNR
    [Arguments]    ${fare_number}    ${airline}    ${routing}    ${region}=APAC
    Verify Specific Line Is Written In The PNR    *OFFER**ALTERNATE FARE: ${fare_number}*
    Verify Specific Line Is Written In The PNR    *OFFER**AIRLINE: ${airline.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**ROUTING: ${routing.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**FARE BASIS: ${fare_basis_value_alt_${fare_number}.upper()}*
    Verify Alternate Fare Details Are Written In Remarks    ${details_offer_alt_${fare_number}.upper()}
    Verify Specific Line Is Written In The PNR    *OFFER**CHANGES: ${changes_value_alt_${fare_number}.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**CANCELLATION: ${cancellation_value_alt_${fare_number}.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**VALID ON: ${valid_on_value_alt_${fare_number}.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**REROUTE: ${reroute_value_alt_${fare_number}.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**MINIMUM STAY: ${min_stay_value_alt_${fare_number}.upper()}*
    Verify Specific Line Is Written In The PNR    *OFFER**MAXIMUM STAY: ${max_stay_value_alt_${fare_number}.upper()}*
    Run Keyword If    "${region.upper()}" == "APAC"    Run Keywords    Verify Specific Line Is Written In The PNR    *OFFER**QUOTE PROVIDED EXCLUDES ALL APPLICABLE FEES AND CHARGES*
    ...    AND    Verify Specific Line Is Written In The PNR    *OFFER**ALL PRICES SUBJECT TO CHANGE WITHOUT NOTICE*
    ...    AND    Verify Specific Line Is Written In The PNR    *OFFER**.............................................*

Verify Alternate Fare Restriction Remarks In PNR
    [Arguments]    @{restrictions}
    : FOR    ${restriction}    IN    @{restrictions}
    \    ${restriction_upper}    Convert To Uppercase    ${restriction}
    \    Verify Specific Line Is Written In The PNR    RIR *OFFER**RESTRICTION: ${restriction_upper}*    multi_line_search_flag=true

Verify Alternate Fare Routing Field Value
    [Arguments]    ${expected_alternate_fare_routing_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt
    ${actual_routing_value}    Get Control Text Value    ${object_name}
    ${actual_routing_value}    Replace String    ${actual_routing_value}    -___    ${EMPTY}
    Verify Text Contains Expected Value    ${actual_routing_value}    ${expected_alternate_fare_routing_value}
    [Teardown]    Take Screenshot

Verify Alternate Fare Routing and Airline Text Box
    [Arguments]    ${route_details}    ${airline}
    ${actual_route} =    Get Control Text Value    [NAME:cmtxtRouting_alt_1]
    ${actual_airline} =    Get Control Text Value    [NAME:ctxtAirlineOffer_alt_1]
    ${actual_route} =    Replace String    ${actual_route}    -___-___    ${EMPTY}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${actual_route}    ${route_details}    Route Details should match ${actual_route}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${actual_airline}    ${airline}    Route Details should match ${actual_airline}
    [Teardown]    Take Screenshot

Verify Alternate Fare Values Are Retained
    [Arguments]    ${fare_tab}    ${fare_tab_to_compare}=True    ${second_amend}=False
    [Documentation]    If ${fare_tab_to_compare} is True, it will get the same fare tab, else, it will compare on the indicated fare tab
    ...    Example: If on amend, ${fare tab} is not the same as ${fare_tab_to_compare} from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${identifier}    Set Variable If    '${second_amend.upper()}' == 'FALSE'    newbooking    amend
    ${fare_tab_to_compare}    Run Keyword If    "${fare_tab_to_compare}" == "True" or "${fare_tab_to_compare}" == "${fare_tab}"    Set Variable    ${fare_tab_index}
    ...    ELSE    Fetch From Right    ${fare_tab_to_compare}    ${SPACE}
    Get Alternate Fare Details    ${fare_tab}    APAC
    Comment    Get Main Fees On Fare Quote Tab    ${fare_tab}
    ${new_alternate_airline_details}    Flatten String    ${${identifier}_alternate_airline_details_${fare_tab_to_compare}}
    ${alternate_airline_details}    Flatten String    ${alternate_airline_details_${fare_tab_index}}
    Run Keyword If    "${${identifier}_fare_basis_${fare_tab_to_compare}}" == "${fare_basis_alt_${fare_tab_index}}"    Log    Fare Basis value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Fare Basis value: ${${identifier}_fare_basis_${fare_tab_to_compare}} is not equals to the value on Amend: ${fare_basis_alt_${fare_tab_index}}
    Run Keyword If    "${${identifier}_airline_offer_alt_${fare_tab_to_compare}}" == "${airline_offer_alt_${fare_tab_index}}"    Log    Airline Offer is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Airline Offer value: ${${identifier}_airline_offer_alt_${fare_tab_to_compare}} not equals to the value on Amend: ${airline_offer_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_fare_class_offer_${newbooking_fare_tab_index}}" == "${fare_class_offer_alt_${fare_tab_index}}"    Log    Transaction Fee value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Fare Class Offer value: ${newbooking_fare_class_offer_${newbooking_fare_tab_index}} not equals to the value on Amend: ${fare_class_offer_alt_${fare_tab_index}}
    Run Keyword If    "${new_alternate_airline_details}" == "${alternate_airline_details}"    Log    Alternate Fare Details $ is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Alternate Airline value : ${new_alternate_airline_details} not equals to the value on Amend: ${alternate_airline_details}
    Run Keyword If    "${${identifier}_total_fare_alt_${fare_tab_to_compare}}" == "${total_fare_alt_${fare_tab_index}}"    Log    Fare Total is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Total Fare : ${${identifier}_total_fare_alt_${fare_tab_to_compare}} not equals to the value on Amend: ${total_fare_alt_${fare_tab_index}}
    Run Keyword If    "${${identifier}_routing_value_alt_${fare_tab_to_compare}}" == "${routing_value_alt_${fare_tab_index}}"    Log    Routing is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Routing Value : ${${identifier}_routing_value_alt_${fare_tab_to_compare}} not equals to the value on Amend: ${routing_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_commission_rebate_value_alt_${fare_tab_index}}" == "${commission_rebate_value_alt_${fare_tab_index}}"    Log    Commission Rebase $ value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Commission Rebase $ value: ${newbooking_commission_rebate_value_alt_${fare_tab_index}} not equals to the value on Amend: ${commission_rebate_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_commission_rebate_percentage_value_alt_${fare_tab_index}}" == "${commission_rebate_percentage_value_alt_${fare_tab_index}}"    Log    Commission Rebase % value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Commission Rebase % value: ${newbooking_commission_rebate_percentage_value_alt_${fare_tab_index}} not equals to the value on Amend: ${commission_rebate_percentage_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_fare_including_taxes_alt_${fare_tab_index}}" == "${fare_including_taxes_alt_${fare_tab_index}}"    Log    Fare Including Airline Taxes value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Fare Including Airline Taxes value: ${newbooking_fare_including_taxes_alt_${fare_tab_index}} not equals to the value on Amend: ${fare_including_taxes_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_fuel_surcharge_value_alt_${fare_tab_index}}" == "${fuel_surcharge_value_alt_${fare_tab_index}}"    Log    Fuel Surcharge value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Fuel Surcharge value: ${newbooking_fuel_surcharge_value_alt_${fare_tab_index}} not equals to the value on Amend: ${fuel_surcharge_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_mark_up_value_alt_${fare_tab_index}}" == "${mark_up_value_alt_${fare_tab_index}}"    Log    Mark-Up $ value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Mark-Up $ value: ${newbooking_mark_up_value_alt_${fare_tab_index}} not equals to the value on Amend: ${mark_up_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_mark_up_percentage_value_alt_${fare_tab_index}}" == "${mark_up_percentage_value_alt_${fare_tab_index}}"    Log    Mark-Up % value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Mark-Up % value: ${newbooking_mark_up_percentage_value_alt_${fare_tab_index}} not equals to the value on Amend: ${mark_up_percentage_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_merchant_fee_value_alt_${fare_tab_index}}" == "${merchant_fee_value_alt_${fare_tab_index}}"    Log    Merchant $ value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Merchant $ value: ${newbooking_merchant_fee_value_alt_${fare_tab_index}} not equals to the value on Amend: ${merchant_fee_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_merchant_fee_percentage_value_alt_${fare_tab_index}}" == "${merchant_fee_percentage_value_alt_${fare_tab_index}}"    Log    Merchant % value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Merchant % value: ${newbooking_merchant_fee_percentage_value_alt_${fare_tab_index}} not equals to the value on Amend: ${merchant_fee_percentage_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_nett_fare_value_alt_${fare_tab_index}}" == "${nett_fare_value_alt_${fare_tab_index}}"    Log    Nett Fare value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Nett Fare value: ${newbooking_nett_fare_value_alt_${fare_tab_index}} not equals to the value on Amend: ${nett_fare_value_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_total_amount_alt_${fare_tab_index}}" == "${total_amount_alt_${fare_tab_index}}"    Log    Total Amount value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Total Amount value: ${newbooking_total_amount_alt_${fare_tab_index}} not equals to the value on Amend: ${total_amount_alt_${fare_tab_index}}
    Comment    Run Keyword If    "${newbooking_transaction_fee_value_alt_${fare_tab_index}}" == "${transaction_fee_value_alt_${fare_tab_index}}"    Log    Transaction Fee value is retained.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Transaction Fee value: ${newbooking_transaction_fee_value_alt_${fare_tab_index}} not equals to the value on Amend: ${transaction_fee_value_alt_${fare_tab_index}}

Verify Alternate Flight Details Is Correct
    [Arguments]    ${alternate_fare_tab}    ${route_details}
    ${pnr_details}    Get Clipboard Data Amadeus    RTA
    ${route_line} =    Get Lines Containing String    ${pnr_details}    ${airline_code}${flight_number}
    Click Fare Tab    ${alternate_fare_tab}
    ${actual_text} =    Get Control Text Value    [NAME:ctxtDetailsOffer_alt_${fare_tab_index}]
    ${actual_value} =    Remove String    ${actual_text}    ${SPACE}
    Verify Text Contains Expected Value    ${actual_value}    ${route_details}
    Verify Text Contains Expected Value    ${route_line}    ${route_details}
    [Teardown]    Take Screenshot

Verify Amount In Fare Tab
    [Arguments]    ${fare_tab}    ${air_tst_segment}
    Click Fare Tab    ${fare_tab}
    Get Charged Fare Value    ${fare_tab}
    Get Grand Total Fare From Amadeus    ${air_tst_segment}    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${grand_total_fare_${fare_tab_index}}    ${converted_charged_fare}    TQT fare ${grand_total_fare_${fare_tab_index}} should be equal to Charged fare ${converted_charged_fare} displayed in Power Express
    Activate Power Express Window

Verify And Store Comm Pct Data In PQ
    [Arguments]    ${fare_tab}    ${is_comm_pct_expected}    ${display_fare_command}=*PQ    ${use_copy_content_from_sabre}=True
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    ${display_fare_command}${fare_index}    use_copy_content_from_sabre=False
    ${comm_pct}    Get String Matching Regexp    COMM PCT(${SPACE})+([a-zA-Z])?(${SPACE})+([0-9])+(\.[0-9][0-9])?    ${pnr_details}
    ${is_comm_pct_exists}    Set Variable If    "${comm_pct}" != "0"    True    False
    Run Keyword And Continue On Failure    Should Be Equal    ${is_comm_pct_expected}    ${is_comm_pct_exists}
    ${comm_pct}    Run Keyword If    "${is_comm_pct_exists}" == "True"    Remove All Non-Integer (retain period)    ${comm_pct}
    ...    ELSE    Set Variable    0.00
    ${comm_pct}    Convert To Float    ${comm_pct}
    Set Suite Variable    ${fare_${fare_index}_comm_pct}    ${comm_pct}

Verify And Store KP Data In PQ
    [Arguments]    ${fare_tab}    ${is_kp_exists_expected}    ${display_fare_command}=*PQ    ${use_copy_content_from_sabre}=True
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    ${display_fare_command}${fare_index}    use_copy_content_from_sabre=False
    ${kp}    Get String Matching Regexp    KP([0-9])+(\.[0-9][0-9])?    ${pnr_details}
    ${is_kp_exists}    Set Variable If    "${kp}" != "0"    True    False
    Run Keyword And Continue On Failure    Should Be Equal    ${is_kp_exists_expected}    ${is_kp_exists}
    ${kp}    Run Keyword If    ${is_kp_exists}    Remove All Non-Integer (retain period)    ${kp}
    ...    ELSE    Set Variable    0
    ${kp}    Convert To Float    ${kp}
    Set Suite Variable    ${fare_${fare_index}_kp}    ${kp}

Verify Auto Invoice Is Ticked
    Verify Checkbox Is Ticked    [NAME:cchkAutoInvoice]

Verify BF Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RMF BF-

Verify BF Remarks Are Written In The PNR
    [Arguments]    ${fare_tab}    ${start}=0    ${end}=6
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Fare Details In BF Remarks    ${fare_tab}    ${start}    ${end}
    Verify Text Contains Expected Value    ${bf_lines_collection_fare_${fare_tab_index}[1]}    H-${high_fare_value_${fare_tab_index}} C-${charged_value_${fare_tab_index}} L-${low_fare_value_${fare_tab_index}}
    Verify Text Contains Expected Value    ${bf_lines_collection_fare_${fare_tab_index}[2]}    HC-${realised_code_value_${fare_tab_index}} LC-${missed_code_value_${fare_tab_index}} CL-${class_code_value_${fare_tab_index}}
    Verify Text Contains Expected Value    ${bf_lines_collection_fare_${fare_tab_index}[3]}    CANX-${cancellation_value_${fare_tab_index}.upper()}
    Verify Text Contains Expected Value    ${bf_lines_collection_fare_${fare_tab_index}[4]}    CHGS-${changes_value_${fare_tab_index}.upper()}
    Verify Text Contains Expected Value    ${bf_lines_collection_fare_${fare_tab_index}[5]}    MIN-${min_stay_${fare_tab_index}.upper()} MAX-${max_stay_${fare_tab_index}.upper()}

Verify BF/ AF Remarks For Mark-Up Amount And Percentage Are Not Written
    [Arguments]    ${fare_tab}=Fare 1    ${country}=SG
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${currency}    Set Variable If    "${country.upper()}"=="SG"    SGD    "${country.upper()}"=="HK"    HKD    INR
    Verify Specific Line Is Not Written In The PNR    RMF BF-${currency}${base_fare_${fare_tab_index}}:MA
    Verify Specific Line Is Not Written In The PNR    RMF BF-${currency}${base_fare_${fare_tab_index}}:MP

Verify BF/AF Remarks For Mark-Up Amount And Percentage Are Written
    [Arguments]    ${fare_tab}=Fare 1    ${country}=SG
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${currency}    Set Variable If    "${country.upper()}"=="SG"    SGD    "${country.upper()}"=="HK"    HKD    INR
    Verify Specific Line Is Written In The PNR    RMF BF-${currency}${base_fare_${fare_tab_index}}:MA: ${mark_up_value_${fare_tab_index}}/${tst_number_${fare_tab_index}}
    Verify Specific Line Is Written In The PNR    RMF BF-${currency}${base_fare_${fare_tab_index}}:MP: ${mark_up_percentage_${fare_tab_index}}/${tst_number_${fare_tab_index}}

Verify CM Remark Is Not Written
    Verify Specific Line Is Not Written In The PNR    RM *CM

Verify CM Remark Is Written
    [Arguments]    ${fare_tab}=Fare 1    ${segment_number}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}"=="Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Verify Specific Line Is Written In The PNR    RM *CM/${commission_rebate_value_${fare_tab_index}}/${segment_number}

Verify Cancellation Dropdown Values
    [Arguments]    @{cancellation_values}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboCancellations,ccboCancellationsOBT,ccboCancellations_alt,ccboCancellationsOBT_alt
    ${actual_cancellation_value} =    Get Value From Dropdown List    ${object_name}
    : FOR    ${cancellation_value}    IN    @{cancellation_values}
    \    ${is_found}    Run Keyword And Return Status    List Should Contain Value    ${actual_cancellation_value}    ${cancellation_value}
    \    Run Keyword if    '${is_found}' == 'True'    Log    ${cancellation_value} is found in the List Values
    \    ...    ELSE    Fail    ${cancellation_value} is Not found in the List Values

Verify Cancellations Field Actual Value
    [Arguments]    ${expected_changes_value}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboCancellationsOBT,ccboCancellations0,ccboCancellationsOBT_alt,ccboCancellations_alt,ccboCancellations_${fare_tab_index},ccboCancellations_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_changes_value}
    [Teardown]    Take Screenshot

Verify Changes Dropdown Values
    [Arguments]    @{changes_values}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboChanges,ccboChangesOBT,ccboChanges_alt,ccboChangesOBT_alt
    ${actual_changes_value} =    Get Value From Dropdown List    ${object_name}
    : FOR    ${changes_value}    IN    @{changes_values}
    \    ${is_found}    Run Keyword And Return Status    List Should Contain Value    ${actual_changes_value}    ${changes_value}
    \    Run Keyword if    '${is_found}' == 'True'    Log    ${changes_value} is found in the List Values
    \    ...    ELSE    Fail    ${changes_value} is Not found in the List Values

Verify Changes Field Actual Value
    [Arguments]    ${expected_changes_value}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboChangesOBT,ccboChanges0,ccboChangesOBT_alt,ccboChanges_alt,ccboChanges_${fare_tab_index},ccboChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_changes_value}
    [Teardown]    Take Screenshot

Verify Charge Fare Field Is Pre-Populated
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${actual_charge_fare}    Get Control Text Value    ${object_name}
    Run Keyword If    "${actual_charge_fare}" != "${EMPTY}"    Log    Charge Fare is: ${actual_charge_fare}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Charge Fare must be pre-populated.
    [Teardown]    Take Screenshot

Verify Charged Fare And Low Fare Are Equal
    [Arguments]    ${fare_tab_value}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Verify Actual Value Matches Expected Value    ${charged_fare_${fare_tab_index}}    ${low_fare_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Charged Fare Field Is Disabled
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    Verify Control Object Is Disabled    ${charged_fare_field}

Verify Charged Fare Field Is Enabled
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    Verify Control Object Is Enabled    ${charged_fare_field}

Verify Charged Fare Field Value
    [Arguments]    ${expected_charged_fare_value}    ${fare_tab}=Fare 1    ${with_decimal}=true
    Get Charged Fare Value    ${fare_tab}
    ${actual_charged_fare}    Set Variable If    "${with_decimal.lower()}" == "true"    ${converted_charged_fare}    ${without_decimal_charged_fare}
    Verify Actual Value Matches Expected Value    ${actual_charged_fare}    ${expected_charged_fare_value}
    [Teardown]    Take Screenshot

Verify Charged Fare Value Is Retrieved From TST
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Charged Fare From TST    ${fare_tab}    ${segment_number}
    Verify Charged Fare Field Value    ${grand_total_fare_${fare_tab_index}}    ${fare_tab}
    Set Suite Variable    ${grand_total_value_${fare_tab_index}}    ${grand_total_fare_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Charged Fare Value Is Same From Exchange TST
    [Arguments]    ${fare_tab}
    [Documentation]    Execute Get Base Fare, Taxes And Total Fare From Exchange Ticket Prior To This Keyword
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Charged Fare Field Value    ${total_add_coll_${fare_tab_index}}    ${fare_tab}
    [Teardown]    Take Screenshot

Verify Charged Fare Value Is Same From New Booking
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Charged Fare Field Value    ${charged_value_${fare_tab_index}}    ${fare_tab}

Verify Charged, High And Low Fare Amount Are Equal
    [Arguments]    ${fare_tab_value}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Run Keyword And Continue On Failure    Should Match    ${charged_value_${fare_tab_index}}    ${high_fare_value_${fare_tab_index}}
    Run Keyword And Continue On Failure    Should Match    ${high_fare_value_${fare_tab_index}}    ${low_fare_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Class Code Default Value Is Correct
    [Arguments]    ${expected_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_value}

Verify Class Code Dropdown Values Are Correct
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${expected_class_code}    Create List    FF - First Class Full Fare    FD - First Class Discounted Fare    FC - First Class Corporate Fare    FW - First Class CWT Negotiated Fare    CF - Business Class Full Fare
    ...    CD - Business Class Discounted Fare    CC - Business Class Corporate Fare    CW - Business Class CWT Negotiated Fare    YF - Economy Class Full Fare    YD - Economy Class Discounted Fare    YC - Economy Class Corporate Fare
    ...    YW - Economy Class CWT Negotiated Fare
    Log List    ${expected_class_code}
    Get Class Code Values    ${fare_tab}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${class_code_values_${fare_tab_index}}    ${expected_class_code}
    [Teardown]    Take Screenshot

Verify Class Code Field Is Disabled
    ${class_code_field}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Verify Control Object Is Disabled    ${class_code_field}

Verify Class Code Field Is Enabled
    ${class_code_field}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Verify Control Object Is Enabled    ${class_code_field}

Verify Class Code Is Mandatory And Has No Value
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Verify Field Is Empty    ${object_name}
    Verify Control Object Background Color    ${object_name}    FFD700
    [Teardown]    Take Screenshot

Verify Client Rebate Amount Where Commission Amount Is Not Zero
    [Arguments]    ${fare_tab_index}    ${segment_number_for_travcom}
    Get Remarks Leading And Succeeding Line Numbers    MS/PC50/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RM *MS/PC50/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/S-${commission_rebate_value_${fare_tab_index}}/SF-${commission_rebate_value_${fare_tab_index}}/C-${commission_rebate_value_${fare_tab_index}}/SG0${segment_number_for_travcom}/${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_3} RM *MSX/FS/${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_4} RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}    multi_line_search_flag=true
    Comment    Run Keyword If    "${country}" != "IN"    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF REBATE/S${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true

Verify Client Rebate Amount Where Commission Amount Is Zero
    [Arguments]    ${fare_tab_index}    ${segment_number_for_travcom}
    Verify Specific Line Is Not Written In The PNR    RM *MS/PC50/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    RM *MSX/S-${commission_rebate_value_${fare_tab_index}}/SF-${commission_rebate_value_${fare_tab_index}}/C-${commission_rebate_value_${fare_tab_index}}/SG0${segment_number_for_travcom}/${segment_number}    multi_line_search_flag=true
    Comment    Verify Specific Line Is Not Written In The PNR    RM *MSX/FS/${segment_number}    multi_line_search_flag=true
    Comment    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}    multi_line_search_flag=true
    Comment    Run Keyword If    "${country}" != "IN"    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF REBATE/S${segment_number}    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF AIR COMM RETURN/${segment_number}    multi_line_search_flag=true

Verify Client Rebate Remarks
    [Arguments]    ${fare_tab_index}    ${segment_number_for_travcom}
    Comment    Set Suite Variable    ${fare_tab_index}
    Comment    Set Suite Variable    ${segment_number_for_travcom}
    Run Keyword If    "${commission_rebate_value_${fare_tab_index}}" == "0" or "${commission_rebate_value_${fare_tab_index}}" == "0.00"    Verify Client Rebate Amount Where Commission Amount Is Zero    ${fare_tab_index}    ${segment_number_for_travcom}
    ...    ELSE    Verify Client Rebate Amount Where Commission Amount Is Not Zero    ${fare_tab_index}    ${segment_number_for_travcom}

Verify Comment Value
    [Arguments]    ${expected_comment}
    ${comment_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommentsOBT, ctxtComments, ctxtCommentsOBT_alt, ctxtComments_alt
    Verify Control Object Text Value Is Correct    ${comment_field}    ${expected_comment}

Verify Commission Rebate Amount And Percentage Is Displayed And Has No Value
    [Arguments]    ${fare_tab}=Fare 1
    ${tab_number}    Get Tab Number    ${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${commission_percent_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtCommissionPercent_${tab_number}]    [NAME:ctxtCommissionPercent_alt_${tab_number}]
    ${commission_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtCommissionRebateAmount_${tab_number}]    [NAME:ctxtCommissionRebateAmount_alt_${tab_number}]
    Verify Control Object Text Contains Expected Value    ${commission_percent_obj}    ${EMPTY}
    Verify Control Object Text Contains Expected Value    ${commission_amount_obj}    ${EMPTY}

Verify Commission Rebate Amount Field Is Disabled
    ${commission_rebate_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionRebateAmount
    Verify Control Object Is Disabled    ${commission_rebate_amount_field}
    [Teardown]    Take Screenshot

Verify Commission Rebate Amount Field Is Mandatory
    ${commission_rebate_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionRebateAmount
    Set Field To Empty    ${commission_rebate_amount_field}
    ${commission_rebate_percentage}    Get Control Text Value    ${commission_rebate_amount_field}
    Verify Mandatory Field    ctxtCommissionRebateAmount
    [Teardown]    Take Screenshot

Verify Commission Rebate Amount Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}    ${start_substring}=4    ${end_substring}=6    ${rounding_so}=${EMPTY}
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${yq_tax}    Get Variable Value    ${yq_tax_${fare_tab_index}}    0
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ${city_route}    Fetch From Left    ${city_route_${fare_tab_index}}    -
    Log    ${base_or_nett_fare_${fare_tab_index}}
    Log    ${yq_tax}
    ${base_or_nett_fare}    Run Keyword If    "${country}" == "IN"    Evaluate    ${base_or_nett_fare_${fare_tab_index}} + ${yq_tax}
    ...    ELSE    Evaluate    ${base_or_nett_fare_${fare_tab_index}} + 0
    Set Test Variable    ${commission_percentage}    ${commission_rebate_percentage_value_${fare_tab_index}}
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_or_nett_fare}
    ${commission_amount_eval}    Evaluate    (${base_or_nett_fare_${fare_tab_index}}) * ${commission_percentage}/100
    ${commission_amount_eval}    Round To Nearest Dollar    ${commission_amount_eval}    ${country}    ${rounding_so}
    Run Keyword If    "${commission_amount_eval}" == "${commission_rebate_value_${fare_tab_index}}"    Log    ${commission_rebate_value_${fare_tab_index}} is set on Commission Rebate ($) field.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual Commission Rebate ($): ${commission_rebate_value_${fare_tab_index}} is not equal to the computed: ${commission_amount_eval}.
    Set Suite Variable    ${commission_rebate_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Commission Rebate Amount Value
    [Arguments]    ${fare_tab}    ${expected_commission_rebate_amount_value}
    Get Commission Rebate Amount Value    ${fare_tab}
    Run Keyword If    "${commission_rebate_value_${fare_tab_index}}" == "${expected_commission_rebate_amount_value}"    Log    Commission Rebate Amount Value is: ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Commission Rebate Amount Value is: ${commission_rebate_value_${fare_tab_index}} not equal to expected value of: ${expected_commission_rebate_amount_value}
    [Teardown]    Take Screenshot

Verify Commission Rebate Percentage Field Is Disabled
    ${commission_rebate_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent
    Verify Control Object Is Disabled    ${commission_rebate_percentage_field}
    [Teardown]    Take Screenshot

Verify Commission Rebate Percentage Field Is Enabled
    ${commission_rebate_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent
    Verify Control Object Is Enabled    ${commission_rebate_percentage_field}
    [Teardown]    Take Screenshot

Verify Commission Rebate Percentage Field Is Mandatory
    ${commission_rebate_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent
    Set Field To Empty    ${commission_rebate_percentage_field}
    ${commission_rebate_percentage}    Get Control Text Value    ${commission_rebate_percentage_field}
    Verify Mandatory Field    ctxtCommissionPercent
    [Teardown]    Take Screenshot

Verify Commission Rebate Percentage Value
    [Arguments]    ${fare_tab}    ${expected_commission_rebate_percentage_value}
    Get Commission Rebate Percentage Value    ${fare_tab}
    Run Keyword If    "${commission_rebate_percentage_value_${fare_tab_index}}" == "${expected_commission_rebate_percentage_value}"    Log    Commission Rebate Percentage Value is: ${commission_rebate_percentage_value_${fare_tab_index}}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Commission Rebate Percentage Value is: ${commission_rebate_percentage_value_${fare_tab_index}} not equal to expected value of: ${expected_commission_rebate_percentage_value}
    [Teardown]    Take Screenshot

Verify Commission Rebate Remarks Per TST Are Correct
    [Arguments]    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${is_exchange}=False
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${commission_rebate_value}    Set Variable    ${commission_rebate_value_${fare_tab_index}}
    ${is_commision_rebate}    Evaluate    ${commission_rebate_value} > ${0}
    &{vendor_code_merchant_dict}    Create Dictionary    SG=V027000    HK=V00001    IN=V00800003
    ${vendor_code}    Get From Dictionary    ${vendor_code_merchant_dict}    ${country}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    Run Keyword If    "${is_commision_rebate}" == "True" and "${is_exchange}" == "False"    Verify Specific Line Is Written In The PNR    RM \\*MS/PC50/${vendor_code}/TK/PX1/${segment_number}    true
    ...    ELSE IF    "${is_commision_rebate}" == "False" and "${is_exchange}" == "False"    Verify Specific Line Is Not Written In The PNR    RM \\*MS/PC50/${vendor_code}/TK/PX1/${segment_number}    true
    Run Keyword If    "${is_commision_rebate}" == "True" and "${is_exchange}" == "False"    Verify Specific Line Is Written In The PNR    RM *MSX/S-${commission_rebate_value}/SF-${commission_rebate_value}/C-${commission_rebate_value}/SG${segments_in_tst}/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/S-${commission_rebate_value}/SF-${commission_rebate_value}/C-${commission_rebate_value}/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${is_credit_card}"=="True" and "${country}"!="SG" and "${is_commision_rebate}" == "True"    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D-${commission_rebate_value}/${segment_number}    true
    ...    ELSE IF    "${country}"=="SG" and "${is_commision_rebate}" == "True"    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    Run Keyword If    "${is_commision_rebate}" == "True" and "${is_exchange}" == "False"    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    "${is_commision_rebate}" == "True" and "${is_exchange}" == "False" and "${country}" != "IN"    Verify Specific Line Is Written In The PNR    RM *MSX/FF AIR COMM RETURN/${segment_number}
    ...    ELSE IF    "${is_commision_rebate}" == "True" and "${is_exchange}" == "False" and "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM *MSX/FF REBATE/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF AIR COMM RETURN/${segment_number}
    Verify Specific Line Is Written In The PNR    FM \\PAX *P|M*${airline_commission_percentage_${fare_tab_index}}/${segment_number}    true

Verify Compliant Value
    [Arguments]    ${expected_compliant}
    ${complaint_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboCompliantOBT, ccboCompliantOBT_alt, ccboCompliant, ccboCompliant_alt
    Verify Control Object Text Value Is Correct    ${complaint_dropdown}    ${expected_compliant}

Verify Computed Value Of Mark-Up Amount Is Correct
    [Arguments]    ${fare_tab}=Fare 1    ${segment_number}=2    ${country}=SG    ${gds_command}=TQT    ${mark_up_percentage}=1    ${round_type}=${EMPTY}
    Calculate Mark- Up Amount And Percentage    fare_tab=${fare_tab}    segment_number=${segment_number}    country=${country}    gds_command=${gds_command}    mark_up_percentage=${mark_up_percentage}    round_type=${round_type}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${mark_up_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpAmount_${tab_number}]    [NAME:ctxtMarkUpAmount_alt_${tab_number}]
    ${mark_up_amount}    Set Variable If    "${fare_tab_type}"=="Fare"    ${mark_up_value_${fare_tab_index}}    ${alt_mark_up_value_${fare_tab_index}}
    Verify Control Object Text Value Is Correct    ${mark_up_amount_obj}    ${mark_up_amount}

Verify Correct Fare Type Is Written In The PNR
    [Arguments]    ${fare_tab}    ${fare_type}    ${route_code}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    &{fare_type_dict}    Create Dictionary    Published Fare=PUB    Nett Remit Fare=APF    Corporate Fare=SQC    CAT 35 Fare=Y
    ${fare_type_identifier}    Get From Dictionary    ${fare_type_dict}    ${fare_type}
    ${route_code_identifier}    Set Variable If    '${route_code}'=='DOM' and '${fare_type}'!='CAT 35 Fare'    -DOM    ${EMPTY}
    ${fare_type_remark}    Set Variable If    '${fare_type}'=='CAT 35 Fare'    RMT TK*NETTTKT-    RMT TK*FARETYPE-
    ${fare_type_remark}    Set Variable    ${fare_type_remark}${fare_tab_index}:${fare_type_identifier}${route_code_identifier}
    Verify Specific Line Is Written In The PNR    ${fare_type_remark}

Verify Credit Card Is Expired ToolTip Is Displayed On Fare Quote Tab
    Comment    Verify Tooltip Text Is Correct Using Coords    583    591    Credit Card is expired
    ${actual_tooltip}    Get Tooltip From Error Icon    tlbFormOfPayment
    Should Be Equal As Strings    ${actual_tooltip}    Credit Card is expired
    [Teardown]    Take Screenshot

Verify Default Alternate Restrictions Are Written In PNR
    Verify Specific Line Is Written In The PNR    RIR *OFFER**THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**INCREASE. CHANGES/CANCELLATION MAY BE SUBJECT TO*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**A PENALTY OR FARE INCREASE UP TO AND INCLUDING THE*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**TOTAL COST OF THE TICKET. NO REFUND FOR UNUSED*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**PORTION ON CERTAIN FARES. TO RETAIN VALUE OF YOUR*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**TICKET,YOU MUST CANCEL THE RESERVATION ON OR*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**BEFORE YOUR TICKETED DEPARTURE TIME*    multi_line_search_flag = true
    Verify Specific Line Is Written In The PNR    RIR *OFFER**ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE*    multi_line_search_flag = true

Verify Default Commission Rebate Percentage and Amount Are Correct
    [Arguments]    ${fare_tab}    ${originating_country_flight}=NONE    ${start_substring}=4    ${end_substring}=6
    [Documentation]    ${originating_country_flight} - add is a specific country origin - SG, HK, IN, ASIA or GLOBAL - if Origin is not SIN, HKG or DEL/BOM
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Set Suite Variable    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${yq_tax}    Get Variable Value    ${yq_tax_${fare_tab_index}}    0
    ${city_route}    Fetch From Left    ${city_route_${fare_tab_index}}    -
    Comment    Get Commission Rebate Percentage Value    ${fare_tab}
    Comment    Get Commission Rebate Amount Value    ${fare_tab}
    Commission Route Percentage In Database    ${route_code_${fare_tab_index}}    ${city_route}    ${originating_country_flight}
    Run Keyword If    "${commission_rebate_percentage_value_${fare_tab_index}}" == "${commission_percentage}"    Log    ${commission_percentage} is set on Commission Rebate (%) field.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual Commission Rebate (%): ${commission_rebate_percentage_value_${fare_tab_index}} is not equal to the value: ${commission_percentage} from the database.
    ${commission_amount_eval}    Evaluate    (${base_fare_${fare_tab_index}}+${yq_tax}) * ${commission_percentage}/100
    Comment    ${commission_amount_eval}    Run Keyword If    "${country}" == "SG"    Round Off    ${commission_amount_eval}    2
    ...    ELSE    Round Off    ${commission_amount_eval}    0
    Comment    ${commission_amount_eval}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${commission_amount_eval}    2
    ...    ELSE    Convert To Float    ${commission_amount_eval}    0
    ${commission_amount_eval}    Round Apac    ${commission_amount_eval}    ${country}
    Run Keyword If    "${commission_amount_eval}" == "${commission_rebate_value_${fare_tab_index}}"    Log    ${commission_rebate_value_${fare_tab_index}} is set on Commission Rebate ($) field.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual Commission Rebate ($): ${commission_rebate_value_${fare_tab_index}} is not equal to the computed: ${commission_amount_eval}.
    Set Suite Variable    ${commission_rebate_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Default Fare Class
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboFareClassOffer_alt, ccboFareClassOffer
    ${actual_default_fare_class}    Get Control Text Value    ${object_name}
    Verify Control Object Text Value Is Correct    ${object_name}    ${EMPTY}
    [Teardown]    Take Screenshot

Verify Default Fare Restriction Field Is Disabled
    ${default_field}    Determine Multiple Object Name Based On Active Tab    cradDefault
    Verify Control Object Is Disabled    ${default_field}
    [Teardown]    Take Screenshot

Verify Default Fare Restriction Field Is Enabled
    ${default_field}    Determine Multiple Object Name Based On Active Tab    cradDefault
    Verify Control Object Is Enabled    ${default_field}

Verify Default Merchant Fee Percentage and Amount Are Correct
    [Arguments]    ${fare_tab}    ${airline_commission_or_client_rebate}=Airline Commission    ${has_client_cwt_comm_agreement}=No    ${start_substring}=4    ${end_substring}=6
    [Documentation]    ${has_client_cwt_comm_agreement}
    ...    - Yes or No, setup for SO "Has Client & CWT Comm Agreement for Merchant Fee"
    ...
    ...    ${airline_commission_or_client_rebate}=Airline Commission
    ...    - Airline Commission or Client Rebate values
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Set Suite Variable    ${country}
    Set Test Variable    ${gst_airfare_value_service_${fare_tab_index}}    0
    ${fop_merchant_fee_type}    Get Variable Value    ${fop_merchant_fee_type_${fare_tab_index}}    0
    Comment    Get Main Fees On Fare Quote Tab    ${fare_tab}
    Merchant Fee Percentage In Database    ${str_card_type_${fare_tab_index}}
    Run Keyword If    "${country}" == "IN"    Calculate GST On Air    ${fare_tab}
    ${computed_merchant_amount}    Run Keyword If    "${airline_commission_or_client_rebate.upper()}" == "CLIENT REBATE" and "${fop_merchant_fee_type}" == "CWT"    Evaluate    (${base_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value_${fare_tab_index}} + ${gst_airfare_value_service_${fare_tab_index}} - ${commission_rebate_value_${fare_tab_index}}) * ${merchant_fee_value}/100
    ...    ELSE IF    "${airline_commission_or_client_rebate.upper()}" == "AIRLINE COMMISSION" and "${fop_merchant_fee_type}" == "CWT"    Evaluate    (${base_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value_${fare_tab_index}} + ${gst_airfare_value_service_${fare_tab_index}}) * ${merchant_fee_value}/100
    ...    ELSE IF    "${country}" == "IN" and "${fop_merchant_fee_type.upper()}" == "AIRLINE" and "${has_client_cwt_comm_agreement.upper()}" == "YES"    Evaluate    ${gst_airfare_value_service_${fare_tab_index}} * ${merchant_fee_value}/100
    ${computed_merchant_amount}    Round Apac    ${computed_merchant_amount}    ${country}
    Run Keyword If    "${merchant_fee_percentage_value_${fare_tab_index}}" == "${merchant_fee_value}"    Log    Default merchant fee percentage: ${merchant_fee_percentage_value_${fare_tab_index}} is correctly displayed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Default merchant fee percentage: ${merchant_fee_percentage_value_${fare_tab_index}} is not equal to the value from database.
    Run Keyword If    "${merchant_fee_value_${fare_tab_index}}" == "${computed_merchant_amount}"    Log    Default merchant fee amount: ${merchant_fee_value_${fare_tab_index}} is correctly displayed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Default merchant fee amount: ${merchant_fee_value_${fare_tab_index}} displayed is not equal to computed merchant amount fee: ${computed_merchant_amount}.
    [Teardown]    Take Screenshot

Verify Default Restriction Remarks Are Written
    [Arguments]    ${occurence}    ${country}=${EMPTY}    ${is_flatten}=False
    Run Keyword If    "${country}"=="IN"    Verify Specific Line Is Written In The PNR X Times    RIR CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OF UP TO    ${occurence}    True
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE INCREASE.    ${occurence}    True
    Run Keyword If    "${country}"=="IN"    Verify Specific Line Is Written In The PNR X Times    RIR THE TOTAL COST OF THE TICKET. PARTIALLY UTILIZED TICKETS    ${occurence}    True
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OR FARE    ${occurence}    True
    Run Keyword If    "${country}"=="IN"    Verify Specific Line Is Written In The PNR X Times    RIR MAY NOT HAVE A REFUND VALUE PLEASE CANCEL BEFORE THE    ${occurence}    True
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR INCREASE UP TO AND INCLUDING THE TOTAL COST OF THE TICKET.    ${occurence}    True
    Run Keyword If    "${country}"=="IN"    Verify Specific Line Is Written In The PNR X Times    RIR PRESCRIBED CANCELLATION TIME TO AVOID ANY NOSHOW OR FULL    ${occurence}    True
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR NO REFUND FOR UNUSED PORTION ON CERTAIN FARES. TO RETAIN    ${occurence}    True
    Run Keyword If    "${country}"=="IN"    Verify Specific Line Is Written In The PNR X Times    RIR CANCELLATION CHARGE FOR FLIGHT OR HOTEL.    ${occurence}    True
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR VALUE OF YOUR TICKET, YOU MUST CANCEL THE RESERVATION    ${occurence}    True
    Run Keyword If    "${country}"!="IN"    Verify Specific Line Is Written In The PNR X Times    RIR ON OR BEFORE YOUR TICKETED DEPARTURE TIME.    ${occurence}    True
    Run Keyword If    "${country}"!="IN"    Verify Specific Line Is Written In The PNR X Times    RIR ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE    multi_line_search_flag = true

Verify Default Restrictions Field Is Disabled
    ${default_field}    Determine Multiple Object Name Based On Active Tab    cradDefault
    Verify Control Object Is Disabled    ${default_field}

Verify Default UI Display In The Restrictions Tab
    [Arguments]    ${fare_tab}    ${country}=${EMPTY}
    Comment    : FOR    ${fare_tab}    IN    @{fare_tabs}
    Click Fare Tab    ${fare_tab}
    Click Restriction Tab
    ${is_selected}    Get Radio Button Status    [NAME:cradDefault_]
    Run Keyword And Continue On Failure    Should Be True    ${is_selected} == True    Default option was selected and displayed in the Restrictions tab.
    ${default_air_fare_restriction}    Get Control Text Current Value    [NAME:ctxtAirRestrictionText]
    Comment    Run Keyword If    "${country}"!="IN"    Verify Text Contains Expected Value    ${default_air_fare_restriction}    THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE INCREASE.${\n}${\n}CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OR FARE INCREASE UP TO AND INCLUDING THE TOTAL COST OF THE TICKET.${\n}${\n}NO REFUND FOR UNUSED PORTION ON CERTAIN FARES. ${\n}${\n}TO RETAIN VALUE OF YOUR TICKET, YOU MUST CANCEL THE RESERVATION ON OR BEFORE YOUR TICKETED DEPARTURE TIME.    else
    Run Keyword If    "${country}"=="IN"    Verify Text Contains Expected Value    ${default_air_fare_restriction}    CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OF ${\n}UP TO THE TOTAL COST OF THE TICKET. ${\n}${\n}PARTIALLY UTILIZED TICKETS MAY NOT HAVE A REFUND VALUE.${\n}${\n}PLEASE CANCEL BEFORE THE PRESCRIBED CANCELLATION TIME ${\n}TO AVOID ANY NO SHOW OR ${\n}FULL CANCELLATION CHARGE FOR FLIGHT OR HOTEL.
    ...    ELSE    Verify Text Contains Expected Value    ${default_air_fare_restriction}    THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE INCREASE.${\n}${\n}CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OR FARE INCREASE UP TO AND INCLUDING THE TOTAL COST OF THE TICKET.${\n}${\n}NO REFUND FOR UNUSED PORTION ON CERTAIN FARES. ${\n}${\n}TO RETAIN VALUE OF YOUR TICKET, YOU MUST CANCEL THE RESERVATION ON OR BEFORE YOUR TICKETED DEPARTURE TIME.

Verify Destination Field Is Enabled
    ${point_of_obj}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    Verify Control Object Is Enabled    ${point_of_obj}

Verify Error In Status Strip Text Is Displayed
    [Arguments]    ${status_strip_text}
    Activate Power Express Window
    Set Test Variable    ${status}    ${EMPTY}
    ${status}    Get Status Strip Text
    Run Keyword And Continue On Failure    Should Be True    "${status.upper()}" == "${status_strip_text.upper()}"    Strip Status must be the same as expected.
    [Teardown]    Take Screenshot

Verify Exchange Pop-up Window Is Displayed
    [Arguments]    ${message}=Fare 1 is an exchange ticket transaction.The additional collection amount will pre-populate into thecharged fare box.    ${verification_mode}=${EMPTY}    ${multi_line_search_flag}=false
    Wait Until Window Exists    Power Express
    Wait Until Control Object Is Visible    [NAME:txtMessageTextBox]
    Verify Control Object Text Value Is Correct    [NAME:txtMessageTextBox]    ${message}    verification_mode=${verification_mode}    multi_line_search_flag=${multi_line_search_flag}
    Click Control Button    [NAME:OKBtn]    Power Express
    Wait Until Progress Info is Completed
    [Teardown]    Take Screenshot

Verify FE Line Is Not Written In The PNR Per TST
    [Arguments]    ${fe_line}    ${segments}=${EMPTY}
    Run Keyword If    '${segments}' != '${EMPTY}'    Verify Specific Line Is Written In The PNR X Times    ${fe_line}/${segments}    0
    ...    ELSE IF    '${segments}' == '${EMPTY}'    Verify Specific Line Is Written In The PNR X Times    ${fe_line}    0

Verify FE Line Is Written In The PNR Per TST
    [Arguments]    ${fe_line}    ${segments}=${EMPTY}
    Run Keyword If    '${segments}' != '${EMPTY}'    Verify Specific Line Is Written In The PNR X Times    FE PAX *M*${fe_line}/${segments}    1
    ...    ELSE IF    '${segments}' == '${EMPTY}'    Verify Specific Line Is Written In The PNR X Times    FE PAX *M*${fe_line}    1

Verify FF30, FF8 and EC Account Remarks Are Written
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    RM *FF30/${realised_code_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *EC/${missed_code_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *FF8/${class_code_value_${fare_tab_index}}/${segment_number}

Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written
    [Arguments]    ${segment_number}    ${booking_action}=AB    ${booking_indicator}=AMA    ${booking_method}=G
    Verify Specific Line Is Written In The PNR    RM *FF34/${booking_action}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *FF35/${booking_indicator}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *FF36/${booking_method}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *FF38/E/${segment_number}

Verify FM Remark Is Not Written
    Verify Specific Line Is Not Written In The PNR    RM *FOP

Verify FM Remarks For Airline Commission Is Written
    [Arguments]    ${fare_tab}    ${qualifier}    ${segment_number}
    [Documentation]    This keyword should be renamed to FM Remarks For Commission Rebate since the FM line is now based from Air Commission Value.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    FM PAX *${qualifier}*${airline_commission_percentage_${fare_tab_index}}/${segment_number}

Verify FOP Credit Card Is Masked On Fare Quote Tab
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value_masked}    Get Control Text Value    ${fop_field}
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value_masked}    *
    Run Keyword If    "${status}" == "True"    Log    Actual FOP: ${fop_value_masked} is masked.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual FOP: ${fop_value_masked} is unmasked.
    [Teardown]    Take Screenshot

Verify FOP Credit Card Is UnMasked On Fare Quote Tab
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value_unmasked}    Get Control Text Value    ${fop_field}
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value_unmasked}    *
    ${status2}    Run Keyword And Return Status    Should Contain    ${fop_value_unmasked}    XXX
    Run Keyword If    "${status}" == "False" or "${status2}" == "False"    Log    Actual FOP: ${fop_value_unmasked} is unmasked.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual FOP: ${fop_value_unmasked} is still masked.
    [Teardown]    Take Screenshot

Verify FOP Merchant Field Is Mandatory And Blank On Fare Quote Tab
    ${fop_merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    Verify Control Object Is Visible    ${fop_merchant_field}
    Verify Control Object Text Value Is Correct    ${fop_merchant_field}    ${EMPTY}
    Verify Control Object Background Color    ${fop_merchant_field}    FFD700
    [Teardown]    Take Screenshot

Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    ${fop_merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    Verify Control Object Is Not Visible    ${fop_merchant_field}
    [Teardown]    Take Screenshot

Verify FOP Merchant Selected Is Displayed On Fare Quote Tab
    [Arguments]    ${expected_fop_merchant}
    Get FOP Merchant Field Value On Fare Quote Tab
    Run Keyword If    "${fop_merchant_value}" == "${expected_fop_merchant}"    Log    FOP Merchant: ${fop_merchant_value} selected during new booking is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Expected FOP: ${expected_fop_merchant} is not the same FOP: ${fop_merchant_value} displayed.
    [Teardown]    Take Screenshot

Verify FOP Remark Is Written In The Accounting Lines
    [Arguments]    ${fare_tab}    ${x_times}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${card_code}    Identify Form Of Payment Code    ${str_card_type}    ${country}
    ${fop_amount}    Evaluate    ${charged_value_${fare_tab_index}} +${merchant_fee_value_${fare_tab_index}}
    ${fop_amount}    Convert To Float    ${fop_amount}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    *PQ${fare_tab_index}    use_copy_content_from_sabre=False
    ${fop_in_pq}    Get String Matching Regexp    AGTINV|INVAGT    ${pnr_details}
    Retrieve PNR Details From Sabre Red    ${current_pnr}    *X/    use_copy_content_from_sabre=False
    Run Keyword If    "${fop_in_pq}"=="AGTINV" or "${fop_in_pq}"=="INVAGT"    Verify Specific Remark Is Written X Times In The PNR    X/-FOP/*${fare_tab_index}/${card_code}/${str_card_type}${str_card_number}EXP${str_exp_date}/${fop_amount}    ${x_times}
    ...    ELSE    Verify Specific Remark Is Written X Times In The PNR    X/-FOP/*${fare_tab_index}/CC/${str_card_type}${str_card_number}EXP${str_exp_date}/${fop_amount}    ${x_times}

Verify FOP Remark Per TST Is Written
    [Arguments]    ${fare_tab}    ${segment_number}    ${fop}    ${country}    ${fop_merchant_type}=${EMPTY}    ${is_exchange}=False
    ...    ${is_ob_fee_present}=False
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    #
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${commission_rebate}    Get Variable Value    ${commission_rebate_value_${fare_tab_index}}    0
    ${base_fare_nett_fare}    Compute Base Fare Or Net Fare    ${fare_tab}
    ${is_commision_rebate}    Evaluate    ${commission_rebate} > ${0}
    ${base_fare_nett_fare}    Run Keyword If    '${is_ob_fee_present}'=='True' and "${fop_merchant_type}" == "Airline"    Evaluate    ${base_fare_nett_fare} + ${ob_fee_${fare_tab_index}}
    ...    ELSE    Set Variable    ${base_fare_nett_fare}
    ${fop_amount}    Run Keyword If    "${is_commision_rebate}" == "True"    Evaluate    ${base_fare_nett_fare} - ${commission_rebate}
    ...    ELSE    Set Variable    ${base_fare_nett_fare}
    ${fop_amount}    Round APAC    ${fop_amount}    ${country}
    ${is_tmp_card}    Run Keyword And Return Status    Should Contain Any    ${fop}    DC364403    VI44848860
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    Run Keyword If    not ${is_credit_card}    Verify Specific Line Is Written In The PNR    RM *FOP/CASH/${segment_number}
    Run Keyword If    "${country}" != "SG" and ${is_credit_card} and "${fop_merchant_type}" == "CWT"    Verify Specific Line Is Written In The PNR    RM \\*FOP/${cc_vendor}/*.*EXP${credit_card_expiry_date}/${fop_amount}/${segment_number}    true
    ...    ELSE IF    "${country}" != "SG" and ${is_credit_card} and "${fop_merchant_type}" == "Airline"    Verify Specific Line Is Written In The PNR    RM \\*FOP/CC/*.*EXP${credit_card_expiry_date}/${fop_amount}/${segment_number}    true
    Run Keyword If    "${country}" == "SG" and not ${is_tmp_card} and ${is_credit_card} and "${fop_merchant_type}" == "CWT"    Verify Specific Line Is Written In The PNR    RM \\*FOP/${cc_vendor}/*.*EXP${credit_card_expiry_date}/${fop_amount}/${segment_number}    true
    ...    ELSE IF    "${country}" == "SG" and not ${is_tmp_card} and ${is_credit_card} and "${fop_merchant_type}" == "Airline"    Verify Specific Line Is Written In The PNR    RM \\*FOP/CC/*.*EXP${credit_card_expiry_date}/${fop_amount}/${segment_number}    true

Verify FOP, Transaction, Merchant And Commission Rebate Remarks
    [Arguments]    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${fop_merchant_type}=${EMPTY}
    ...    ${is_exchange}=False    ${is_obt}=False
    Verify FOP Remark Per TST Is Written    ${fare_tab}    ${segment_number}    ${fop}    ${country}    ${fop_merchant_type}    ${is_exchange}
    Verify Merchant Fee Remarks Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${fop_merchant_type}
    Verify Commission Rebate Remarks Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${is_exchange}
    Verify Transaction Fee Remark Per TST Are Correct    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${is_obt}

Verify FP Line Is Written In The PNR Per TST
    [Arguments]    ${fare_tab}    ${fop}    ${segments}=${EMPTY}    ${merchant_type}=${EMPTY}    ${bcode}=${EMPTY}    ${country}=${EMPTY}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Suite Variable    ${fare_tab_index}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${bcode}    Run Keyword If    '${bcode}' != '${EMPTY}'    Convert To Uppercase    ${bcode}
    ...    ELSE    Set Variable    ${EMPTY}
    Run Keyword If    '${bcode}' != '${EMPTY}' and not ${is_credit_card} and '${fop}' == 'Cash'    Verify Specific Line Is Written In The PNR X Times    FP PAX MSINV${bcode}/${segments}    1
    ...    ELSE IF    '${bcode}' != '${EMPTY}' and not ${is_credit_card} and '${fop}' == 'Invoice'    Verify Specific Line Is Written In The PNR X Times    FP PAX MSINV${bcode}/${segments}    1
    ...    ELSE IF    '${bcode}' != '${EMPTY}' and ${is_credit_card} and '${merchant_type}' == 'CWT'    Verify Specific Line Is Written In The PNR X Times    FP PAX MSINV${bcode}/${segments}    1
    ...    ELSE IF    '${bcode}' != '${EMPTY}' and ${is_credit_card} and '${merchant_type}' == 'Airline'    Verify Specific Line Is Written In The PNR X Times    FP PAX ${credit_card_value}/${segments}    1
    Run Keyword If    '${bcode}' == '${EMPTY}' and not ${is_credit_card} and '${fop}' == 'Cash'    Verify Specific Line Is Written In The PNR X Times    FP PAX CASH/${segments}    1
    ...    ELSE IF    '${bcode}' == '${EMPTY}' and not ${is_credit_card} and '${fop}' == 'Invoice'    Verify Specific Line Is Written In The PNR X Times    FP PAX INVAGT/${segments}    1
    ...    ELSE IF    '${bcode}' == '${EMPTY}' and ${is_credit_card} and '${merchant_type}' == 'CWT' and '${country}' != 'IN'    Verify Specific Line Is Written In The PNR X Times    FP PAX CASH+${fop}/${exp_date}/${segments}    1
    ...    ELSE IF    '${bcode}' == '${EMPTY}' and ${is_credit_card} and '${merchant_type}' == 'CWT' and '${country}' == 'IN'    Verify Specific Line Is Written In The PNR X Times    FP PAX INVAGT/${segments}    1
    ...    ELSE IF    '${bcode}' == '${EMPTY}' and ${is_credit_card} and '${merchant_type}' == 'Airline'    Verify Specific Line Is Written In The PNR X Times    FP PAX CC${str_card_type}.*/${str_exp_date}/${segments}    1    reg_exp_flag=True

Verify Fare Accounting Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RM *RF
    Verify Specific Line Is Not Written In The PNR    RM *SF
    Verify Specific Line Is Not Written In The PNR    RM *LF
    Verify Specific Line Is Not Written In The PNR    RM *FF81
    Verify Specific Line Is Not Written In The PNR    RM *FF7
    Verify Specific Line Is Not Written In The PNR    RM *FF8
    Verify Specific Line Is Not Written In The PNR    RM *FF30
    Verify Specific Line Is Not Written In The PNR    RM *FF34
    Verify Specific Line Is Not Written In The PNR    RM *FF35
    Verify Specific Line Is Not Written In The PNR    RM *FF36
    Verify Specific Line Is Not Written In The PNR    RM *FF38
    Verify Specific Line Is Not Written In The PNR    RM *EC
    Verify Specific Line Is Not Written In The PNR    RM *FOP
    Verify Specific Line Is Not Written In The PNR    RM *MS
    Verify Specific Line Is Not Written In The PNR    RM *MSX
    Verify Specific Line Is Not Written In The PNR    RM *FF99

Verify Fare Amount For ${country} Is Written In The PNR For ${fare_tab}
    ${currency}    Get Currency    ${country}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Set Test Variable    ${fare_amount_value}    ${fare_amount_${fare_tab_index}}
    Verify Specific Line Is Written In The PNR    FARE: ${currency} ${fare_amount_value}

Verify Fare Class Is Mandatory And Has No Value
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboFareClassOffer_alt
    Verify Control Object Background Color    ${object_name}    FFD700
    [Teardown]    Take Screenshot

Verify Fare Condition Fields Are Disabled
    ${valid_on_obj}    Determine Multiple Object Name Based On Active Tab    ccboValidOnOBT, ccboValidOnOBT_alt, ccboValidOn_alt, ccboValidOn
    ${changes_field}    Determine Multiple Object Name Based On Active Tab    ccboChanges0,ccboChanges0_alt,ccboChangesOBT_alt,ccboChangesOBT
    ${min_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMinStay,ccboMinStay_alt,ccboMinStayOBT_alt,ccboMinStayOBT
    ${max_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMaxStay,ccboMaxStay_alt,ccboMaxStayOBT_alt,ccboMaxStayOBT
    ${re_route_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboReRoute,ccboReRoute_alt, ccboReRouteOBT_alt, ccboReRouteOBT
    ${comments_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommentsOBT, ctxtCommentsOBT_alt, ctxtComments_alt, ctxtComments
    Verify Control Object Is Disabled    ${valid_on_obj}
    Verify Control Object Is Disabled    ${changes_field}
    Verify Control Object Is Disabled    ${min_stay_dropdown}
    Verify Control Object Is Disabled    ${max_stay_dropdown}
    Verify Control Object Is Disabled    ${re_route_dropdown}
    Verify Control Object Is Disabled    ${comments_field}

Verify Fare Condition Fields Are Enabled
    ${valid_on_obj}    Determine Multiple Object Name Based On Active Tab    ccboValidOnOBT, ccboValidOnOBT_alt, ccboValidOn_alt, ccboValidOn
    ${changes_field}    Determine Multiple Object Name Based On Active Tab    ccboChanges0,ccboChanges0_alt,ccboChangesOBT_alt,ccboChangesOBT
    ${min_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMinStay,ccboMinStay_alt,ccboMinStayOBT_alt,ccboMinStayOBT
    ${max_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMaxStay,ccboMaxStay_alt,ccboMaxStayOBT_alt,ccboMaxStayOBT
    ${re_route_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboReRoute,ccboReRoute_alt, ccboReRouteOBT_alt, ccboReRouteOBT
    ${comments_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommentsOBT, ctxtCommentsOBT_alt, ctxtComments_alt, ctxtComments
    Verify Control Object Is Enabled    ${valid_on_obj}
    Verify Control Object Is Enabled    ${changes_field}
    Verify Control Object Is Enabled    ${min_stay_dropdown}
    Verify Control Object Is Enabled    ${max_stay_dropdown}
    Verify Control Object Is Enabled    ${re_route_dropdown}
    Verify Control Object Is Enabled    ${comments_field}

Verify Fare Fields Are Disabled
    Verify High Fare Field Is Disabled
    Verify Charged Fare Field Is Disabled
    Verify Low Fare Field Is Disabled
    Verify Realised Saving Code Field Is Disabled
    Verify Missed Savings Code Field Is Disabled
    Verify Route Code Field Is Disabled

Verify Fare Fields Are Enabled
    [Arguments]    ${route_code_required}=True    ${destination_required}==False
    Verify High Fare Field Is Enabled
    Verify Charged Fare Field Is Enabled
    Verify Low Fare Field Is Enabled
    Verify Realised Saving Code Field Is Enabled
    Verify Missed Savings Code Field Is Enabled
    Run Keyword If    "${route_code_required}" == "True"    Verify Route Code Field Is Enabled
    Run Keyword If    "${destination_required}" == "True"    Verify Destination Field Is Enabled

Verify Fare Fields On Air Fare Panel behaves Correctly
    Set Charged Fare Field    83xx
    SEND    {TAB}
    ${actual_tooltip_CF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_CF}    Invalid Amount
    Verify Panel Status    RED    Air Fare
    ###Set CF
    Set Charged Fare Field    100
    ###Set Invalid LF
    Set Low Fare Field    335
    ${actual_tooltip_RF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_RF}    Validate Low Fare
    Verify Error In Status Strip Text Is Displayed    Low Fare cannot be greater than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set Valid LF
    Set Low Fare Field    35
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Should Be True    ${is_tooltip_present} == ${False}
    ###Set Invalid HF
    Set High Fare Field    83
    ${actual_tooltip_LF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_LF}    Validate High Fare
    Verify Error In Status Strip Text Is Displayed    High Fare cannot be lower than Charged Fare
    ###Set Valid HF
    Set High Fare Field    100
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Should Be True    ${is_tooltip_present} == ${False}
    ###Set CF
    Set Charged Fare Field    10
    SEND    {TAB}
    ${actual_tooltip_LF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_LF}    Validate Low Fare
    Verify Error In Status Strip Text Is Displayed    Low Fare cannot be greater than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set CF
    Set Charged Fare Field    83
    SEND    {TAB}
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Should Be True    ${is_tooltip_present} == ${False}
    Verify Panel Status    GREEN    Air Fare
    ###Set Valid LF
    Set Low Fare Field    83
    Verify Panel Status    GREEN    Air Fare
    ###Set CF
    Set Charged Fare Field    -83
    SEND    {TAB}
    ${actual_tooltip_RF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_RF}    Validate Low Fare
    Verify Error In Status Strip Text Is Displayed    Low Fare cannot be greater than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set CF
    Set Charged Fare Field    84
    SEND    {TAB}
    ###Set LF
    Set Low Fare Field    85
    ${actual_tooltip_RF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_RF}    Validate Low Fare
    Verify Error In Status Strip Text Is Displayed    Low Fare cannot be greater than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set LF
    Set Low Fare Field    -85
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Should Be True    ${is_tooltip_present} == ${False}
    ###Set HF
    Set High Fare Field    -83
    ${actual_tooltip_RF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_RF}    Validate High Fare
    Verify Error In Status Strip Text Is Displayed    High Fare cannot be lower than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set HF to Blank
    Set Charged Fare Field    -84
    SEND    {TAB}
    Verify Mandatory Field    ctxtHighFare    True
    ###Set CF to Blank
    Verify Mandatory Field    ctxtChargedFare    True
    Verify Mandatory Field    ctxtHighFare
    Verify Mandatory Field    ctxtLowFare    True
    Verify Panel Status    RED    Air Fare
    ###Set LF
    Set Low Fare Field    500
    Verify Mandatory Field    ctxtHighFare
    Verify Mandatory Field    ctxtChargedFare
    Verify Panel Status    RED    Air Fare
    ###Set HF
    Set High Fare Field    500
    Verify Mandatory Field    ctxtChargedFare
    Verify Panel Status    RED    Air Fare
    ###Set CF
    Set Charged Fare Field    0
    SEND    {TAB}
    ${actual_tooltip_RF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_RF}    Validate Low Fare
    Verify Error In Status Strip Text Is Displayed    Low Fare cannot be greater than Charged Fare
    Verify Panel Status    RED    Air Fare
    ###Set CF
    Set Charged Fare Field    500
    SEND    {TAB}
    Verify Panel Status    GREEN    Air Fare

Verify Fare Including Airline Taxes Field Is Disabled
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFareIncludingTaxes, ctxtFareIncludingTaxes_alt
    Comment    ${fare_including_taxes}    Get Control Text Value    ${object_name}
    Verify Control Object Is Disabled    ${object_name}
    Comment    Verify Control Object Is Disabled    [NAME:ctxtFareIncludingTaxes_${fare_tab_index}]

Verify Fare Including Airline Taxes Field Is Disabled X
    ${fares_with_taxes_field}    Determine Multiple Object Name Based On Active Tab    ctxtFareIncludingTaxes
    Verify Control Object Is Disabled    ${fares_with_taxes_field}

Verify Fare Including Airline Taxes Value Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}    ${airline_commision_or_client_rebate}=Airline Commission    ${start_substring}=4    ${end_substring}=6    ${is_exchange}=false
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Verify Fare Including Airline Taxes Field Is Disabled    ${fare_tab}
    ## Value on tax includes the OB FEE
    ${tax_and_ob_fee}    Run Keyword If    "${is_exchange.lower()}" == "false"    Evaluate    ${grand_total_value_${fare_tab_index}} - ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Variable    ${total_tax_${fare_tab_index}}
    Comment    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "0" or "${nett_fare_value_${fare_tab_index}}" == "0.00"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ${fare_including_taxes}    Run Keyword If    "${airline_commision_or_client_rebate}" == "Client Rebate"    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${tax_and_ob_fee} + ${mark_up_value_${fare_tab_index}}) - ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE IF    "${airline_commision_or_client_rebate}" == "Airline Commission"    Evaluate    ${base_or_nett_fare_${fare_tab_index}} + ${tax_and_ob_fee} + ${mark_up_value_${fare_tab_index}}
    ${fare_including_taxes}    Round Apac    ${fare_including_taxes}    ${country}
    Set Suite Variable    ${computed_fare_including_taxes_${fare_tab_index}}    ${fare_including_taxes}
    Run Keyword If    "${computed_fare_including_taxes_${fare_tab_index}}" == "${fare_including_taxes_${fare_tab_index}}"    Log    Fare Including Airline Taxes: ${fare_including_taxes_${fare_tab_index}} is correctly displayed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Fare Including Airline Taxes: ${fare_including_taxes_${fare_tab_index}} displayed is not equal to the computed amount: ${computed_fare_including_taxes_${fare_tab_index}}

Verify Fare Including Taxes Value Is Correct
    [Arguments]    ${identifier}
    Comment    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFareIncludingTaxes, ctxtFareIncludingTaxes_alt
    Comment    ${actual_fare_incl_taxes}    Get Control Text Value    ${object_name}
    ${fare_type}    Fetch From Left    ${identifier}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${identifier}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${identifier.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    Get Fare Including Airline Taxes Value    ${identifier}
    Verify Actual Value Matches Expected Value    ${fare_including_taxes_${fare_tab_index}}    ${lcc_total_amount_${identifier}}

Verify Fare Itinerary Remarks Are Not Written
    Verify Specific Line Is Not Written In The PNR    RIR ************* ITINERARY QUOTE PER PASSENGER
    Verify Specific Line Is Not Written In The PNR    RIR QUOTE NUMBER:
    Verify Specific Line Is Not Written In The PNR    RIR ROUTING:
    Verify Specific Line Is Not Written In The PNR    RIR ADULT FARE:
    Verify Specific Line Is Not Written In The PNR    RIR TRANSACTION FEE:
    Verify Specific Line Is Not Written In The PNR    RIR CC CONVENIENCE FEE:
    Verify Specific Line Is Not Written In The PNR    RIR SVC FEE FOR SURCHARGE:
    Verify Specific Line Is Not Written In The PNR    RIR THIS TICKET MAY BE SUBJECT TO PENALTIES OR FARE
    Verify Specific Line Is Not Written In The PNR    \ \ \ \ \ \ INCREASE.
    Verify Specific Line Is Not Written In The PNR    RIR CHANGES/CANCELLATION MAY BE SUBJECT TO A PENALTY OR FARE
    Verify Specific Line Is Not Written In The PNR    RIR INCREASE UP TO AND INCLUDING THE TOTAL COST OF THE
    Verify Specific Line Is Not Written In The PNR    \ \ \ \ \ \ TICKET.
    Verify Specific Line Is Not Written In The PNR    RIR NO REFUND FOR UNUSED PORTION ON CERTAIN FARES. TO RETAIN
    Verify Specific Line Is Not Written In The PNR    RIR VALUE OF YOUR TICKET, YOU MUST CANCEL THE RESERVATION
    Verify Specific Line Is Not Written In The PNR    RIR ON OR BEFORE YOUR TICKETED DEPARTURE TIME.
    Verify Specific Line Is Not Written In The PNR    RIR ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE

Verify Fare Not Finalised Is Disabled
    Verify Control Object Is Disabled    ${chk_not_finalised}

Verify Fare Not Finalised Is Enabled
    Verify Control Object Is Enabled    ${chk_not_finalised}

Verify Fare Not Finalised Is Ticked
    Verify Checkbox Is Ticked    [NAME:cchkNotFinalised]
    [Teardown]    Take Screenshot

Verify Fare Not Finalised Is Unticked
    Verify Checkbox Is Unticked    [NAME:cchkNotFinalised]
    [Teardown]    Take Screenshot

Verify Fare Quote Remarks Are Written In The PNR
    [Arguments]    ${quote_number}    ${airline}    ${routing}    ${country}
    ${itinerary_quote_header}    Set Variable If    "${country.upper()}" == "NZ" or "${country.upper()}" == "AU"    ************* ITINERARY QUOTE ***************    ************* ITINERARY QUOTE PER PASSENGER ***********
    Verify Specific Line Is Written In The PNR    ${itinerary_quote_header}
    Verify Specific Line Is Written In The PNR    QUOTE NUMBER: ${quote_number}
    Verify Specific Line Is Written In The PNR    AIRLINE: ${airline}
    Verify Specific Line Is Written In The PNR    ROUTING: ${routing}
    Run Keyword If    "${country.upper()}" == "NZ" or "${country.upper()}" == "AU"    Verify Specific Line Is Written In The PNR    FARE: *.    True
    Run Keyword If    "${country.upper()}" == "NZ" or "${country.upper()}" == "AU"    Verify Specific Line Is Written In The PNR    TAX: *.    True
    Run Keyword If    "${country.upper()}" == "SG" or "${country.upper()}" == "HK"    Verify Specific Line Is Written In The PNR    FARE INCLUDING AIRLINE TAXES: *.    True
    Verify Specific Line Is Not Written In The PNR    TOTAL AMOUNT: *.    True
    Verify Specific Line Is Written In The PNR    NO LOWER FARE OPTION AVAILABLE
    Run Keyword If    "${country.upper()}" != "SG"    Verify Specific Line Is Written In The PNR    FARE CONDITIONS

Verify Fare Restriction Default Text Value
    [Arguments]    ${expected_text}
    Comment    Verify Control Object Text Value Is Correct    [NAME:lblDefault]    ${expected_text}
    ${actual_text}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:lblDefault]
    Log    ${expected_text}
    Log    ${actual_text}
    Should Be Equal As Strings    ${expected_text}    ${actual_text.strip()}

Verify Fare Restriction Remarks In PNR
    [Arguments]    @{restrictions}
    : FOR    ${restriction}    IN    @{restrictions}
    \    ${restriction_upper}    Convert To Uppercase    ${restriction}
    \    Verify Specific Line Is Written In The PNR    RIR RESTRICTION: ${restriction_upper}    multi_line_search_flag=true

Verify Fare Restrictions Fields Are Disabled
    Verify Fully Flexible Fare Restriction Field Is Disabled
    Verify Semi Flexible Fare Restriction Field Is Disabled
    Verify Non Flexible Fare Restriction Field Is Disabled
    Verify Fare Condition Fields Are Disabled

Verify Fare Restrictions Fields Are Enabled
    Verify Fully Flexible Fare Restriction Field Is Enabled
    Verify Semi Flexible Fare Restriction Field Is Enabled
    Verify Non Flexible Fare Restriction Field Is Enabled
    Verify Fare Condition Fields Are Enabled

Verify Fare Tab Details
    [Arguments]    ${routing}    ${high_fare}    ${charged_fare}    ${low_fare}    ${realised_saving_code}    ${missed_saving_code}
    ...    ${route_code}
    Verify Routing Field Value    ${routing}
    Verify High Fare Field Value    ${high_fare}
    Verify Charged Fare Field Value    ${charged_fare}
    Verify Low Fare Field Value    ${low_fare}
    Verify Realised Savings Code Default Value    ${realised_saving_code}
    Verify Missed Savings Code Default Value    ${missed_saving_code}
    Verify Route Code Field Value    ${route_code}

Verify Fare Tab Is Visible In Sequence
    [Arguments]    @{fare_tab_name}
    Wait Until Control Object Is Visible    [NAME:TabControl1]
    ${visible_tab}    Get Visible Tab
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${visible_tab}    ${fare_tab_name}
    [Teardown]    Take Screenshot

Verify Fare Type Default Value
    [Arguments]    ${expected_default_value}    ${fare_tab_value}=${EMPTY}
    ${index}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    ${index}    Set Variable If    '${index}' != '${EMPTY}'    ${index}    ${fare_tab_index}
    Verify Control Object Text Value Is Correct    [NAME:ccboFaretype_${index}]    ${expected_default_value}

Verify Fees Value Is Correct
    [Arguments]    ${fare_tab}    ${expected_fees}
    Select Tab Control    ${fare_tab}
    ${actual_fees_value}    Get Fees Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${actual_fees_value}    ${expected_fees}
    [Teardown]    Take Screenshot

Verify Field Is Not Mandatory
    [Arguments]    ${field_name}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ${field_name}
    Verify Object Field Is Not Mandatory    ${object_name}

Verify Form Of Payment Field Is Disabled
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Verify Control Object Is Disabled    ${fop_field}

Verify Form Of Payment Field Is Enabled
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Verify Control Object Is Enabled    ${fop_field}

Verify Form Of Payment Field Is Mandatory And Blank On Fare Quote Tab
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Verify Control Object Is Visible    ${fop_field}
    Verify Control Object Text Value Is Correct    ${fop_field}    ${EMPTY}
    Verify Control Object Field Is Mandatory    ${fop_field}
    [Teardown]    Take Screenshot

Verify Form Of Payment Selected Is Displayed
    [Arguments]    ${expected_fop}    ${default_control_counter}=True
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment,Charges_FormsOfPaymentComboBox,AssociatedCharges_FormsOfPaymentComboBox,Charges_FormOfPaymentComboBox    ${default_control_counter}
    Verify Control Object Text Value Is Correct    ${fop_field}    ${expected_fop}
    [Teardown]    Take Screenshot

Verify Fuel Surcharge Is Not Displayed
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Control Object Is Not Visible    [NAME:ctxtFuelSurcharge_${fare_tab_index}]
    Verify Control Object Is Not Visible    [NAME:ctxtFuelSurcharge_${fare_tab_index}]

Verify Fuel Surcharge Per TST Are Not Written
    [Arguments]    ${fare_tab}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${is_tmp_card}    False
    Identify Form Of Payment Code For APAC    ${str_card_type}
    Set Test Variable    ${product_code}    PC41
    Set Test Variable    ${vendor_code}    V00001
    Set Test Variable    ${currency}    HKD
    Verify Specific Line Is Not Written In The PNR    RM *MS/PC41/${vendor_code}/TKFF02/PX1/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${fuel_surcharge_value_${fare_tab_index}}/SF${fuel_surcharge_value_${fare_tab_index}}/C${fuel_surcharge_value_${fare_tab_index}}/SG${segments_in_tst}/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RIR SVC FEE FOR SURCHARGE: ${CURRENCY} ${fuel_surcharge_value_${fare_tab_index}}

Verify Fuel Surcharge Per TST Are Written
    [Arguments]    ${fare_tab}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Set Test Variable    ${is_tmp_card}    False
    Identify Form Of Payment Code For APAC    ${str_card_type}
    Set Test Variable    ${product_code}    PC41
    Set Test Variable    ${vendor_code}    V00001
    Set Test Variable    ${currency}    HKD
    Run Keyword If    ("${tmp_card}" == "364403" and "${str_card_type_${fare_tab_index}}" == "DC") or ("${ctcl_card}" == "44848860" and "${str_card_type_${fare_tab_index}}" == "VI")    Set Test Variable    ${is_tmp_card}    True
    Verify Specific Line Is Written In The PNR    RM *MS/PC41/${vendor_code}/TKFF02/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${fuel_surcharge_value_${fare_tab_index}}/SF${fuel_surcharge_value_${fare_tab_index}}/C${fuel_surcharge_value_${fare_tab_index}}/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${str_card_type.upper()}" == "CASH" or "${str_card_type.upper()}" == "INVOICE" or "${is_tmp_card}" == "True"    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type}${str_card_number}EXP${str_exp_date}/D${fuel_surcharge_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}
    Verify Specific Line Is Written In The PNR    RIR SVC FEE FOR SURCHARGE: ${CURRENCY} ${fuel_surcharge_value_${fare_tab_index}}

Verify Fuel Surcharge Remark Per TST Are Correct
    [Arguments]    ${fare_tab}    ${segment_number}    ${segment_in_tst}    ${fop}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${ff_number}    Set Variable    0${fare_tab_index}
    ${fuel_surcharge}    Set Variable    ${fuel_surcharge_value_${fare_tab_index}}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    Comment    ${is_cc_tmp_card_or_ctlc}    Run Keyword And Return Status    Should Contain Any    ${fop}    DC364403    VI44848860
    ...    CTLC
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    Run Keyword If    ${fuel_surcharge} == 0    Verify Specific Line Is Not Written In The PNR    RM *MS/PC41/V00001/TKFF${segment_in_tst}/PX1/${segment_number}    Verify Specific Line Is Written In The PNR    RM *MS/PC41/V00001/TKFF${segment_in_tst}/PX1/${segment_number}
    Run Keyword If    ${fuel_surcharge} == 0    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${fuel_surcharge}/SF${fuel_surcharge}/C${fuel_surcharge}/SG${segment_in_tst}/${segment_number}    Verify Specific Line Is Written In The PNR    RM *MSX/S${fuel_surcharge}/SF${fuel_surcharge}/C${fuel_surcharge}/SG${segment_in_tst}/${segment_number}
    Run Keyword If    ${fuel_surcharge} == 0    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${cc_vendor}/CCN${masked_credit_card_number}EXP${credit_card_expiry_date}/D${fuel_surcharge}/${segment_number}
    ...    ELSE IF    ${fuel_surcharge} > 0 and ${is_credit_card}    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D${fuel_surcharge}/${segment_number}    true
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    Run Keyword If    ${fuel_surcharge} == 0    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    ${fuel_surcharge} == 0    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}    Verify Specific Line Is Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}

Verify Fuel Surcharge Remarks Per TST For Travel Fusion
    [Arguments]    ${fare_tab}    ${vendor_code}    ${airline_number}    ${booking_reference}    ${fop}    ${segment_number_long}
    ...    ${segment_number}
    ${identifier}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${credit_card_number_group}    Get Regexp Matches    ${fop}    (\\D{2})(\\*+\\d{4}|\\d+)\/D(\\d{4})    1    2    3
    ${fop_type}    Set Variable    ${credit_card_number_group[0][0]}
    ${fop_number}    Set Variable    ${credit_card_number_group[0][1]}
    ${fop_expiry_date}    Set Variable    ${credit_card_number_group[0][2]}
    ${cc_vendor}    Get CC Vendor From Credit Card    ${fop}
    Run keyword If    '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RM *MS/PC41/V${vendor_code}/AC${airline_number}/TK0000${booking_reference}/PX1/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MS/PC41/V${vendor_code}/AC${airline_number}/TK0000${booking_reference}/PX1/${segment_number}
    Run keyword If    '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RM *MSX/S${fuel_surcharge_value_${identifier}}/SF${fuel_surcharge_value_${identifier}}/C${fuel_surcharge_value_${identifier}}/${segment_number_long}/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${fuel_surcharge_value_${identifier}}/SF${fuel_surcharge_value_${identifier}}/C${fuel_surcharge_value_${identifier}}/${segment_number_long}/${segment_number}
    Run keyword If    '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN${fop_type}.*EXP${fop_expiry_date}/D${fuel_surcharge_value_${identifier}}/${segment_number}    true
    Run keyword If    '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-M/FF47-CWT/${segment_number}
    Run keyword If    '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}    ${EMPTY}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/${segment_number}

Verify Fuel Surcharge Value In Air Fare
    [Arguments]    ${fare_tab}    ${expected_fuel_surcharge}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${actual_surcharge}    Get Fuel Surcharge Value    ${fare_tab}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${actual_surcharge}    ${expected_fuel_surcharge}    msg=Expected fuel surcharge: ${expected_fuel_surcharge} should match actual value: ${actual_surcharge}    values=False
    [Teardown]    Take Screenshot

Verify Fully Flexible Fare Restriction Field Is Disabled
    ${fully_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradFullyFlex,cradFullFlex,cradFullyFlexOBT,cradFullFlexOBT,cradFullFlexOBT_alt,cradFullyFlexOBT_alt, cradFullFlex_alt,cradFullyFlex_alt
    Verify Control Object Is Disabled    ${fully_flexible_field}
    [Teardown]    Take Screenshot

Verify Fully Flexible Fare Restriction Field Is Enabled
    ${fully_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradFullyFlex,cradFullFlex,cradFullyFlexOBT,cradFullFlexOBT,cradFullFlexOBT_alt,cradFullyFlexOBT_alt, cradFullFlex_alt,cradFullyFlex_alt
    Verify Control Object Is Enabled    ${fully_flexible_field}

Verify GST On Air Accounting Remarks Is Written
    [Arguments]    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}=in
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${is_cc_tmp_card_or_ctlc}    Run Keyword If    '${country}' != 'in'    Run Keyword And Return Status    Should Contain Any    ${fop}    DC364403
    ...    VI44848860    CTLC
    ...    ELSE    Set Variable    False
    ${is_normal_cc}    Set Variable If    ${is_credit_card} and not ${is_cc_tmp_card_or_ctlc}    ${True}    ${False}
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    Calculate GST On Air    ${fare_tab}
    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Verify Specific Line Is Written In The PNR    RM *FF99-18P${gst_airfare_value_service_${fare_tab_index}}*0P0*0P0/${segment_number}
    Run Keyword If    "${lfcc_in_tst_${fare_tab_index}}" != "AI" and "${lfcc_in_tst_${fare_tab_index}}" != "9W"    Verify Specific Line Is Not Written In The PNR    RM *FF96/YQ${yq_tax_${fare_tab_index}}*K3${k3_tax_${fare_tab_index}}/S${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM *FF96/YQ${yq_tax_${fare_tab_index}}*K3${k3_tax_${fare_tab_index}}/S${segment_number}
    Comment    Verify Specific Line Is Written In The PNR    RM *MS/PC87/V00800011/TK/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    RM \\*MS/PC87/V00800011/TK/PX1/${segment_number}    true
    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Verify Specific Line Is Written In The PNR    RM *MSX/S${gst_airfare_value_service_${fare_tab_index}}/SF${gst_airfare_value_service_${fare_tab_index}}/C0/SG${segments_in_tst}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    "${fop.upper()}" == "CASH" or "${fop.upper()}" == "INVOICE" or "${is_normal_cc}" == "False"    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D\\d+/${segment_number}    reg_exp_flag=true
    Verify Specific Line Is Written In The PNR    RM *MSX/FF VAT/${segment_number}

Verify GST On Merchant Fee For Transaction Fee Accounting Remarks
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${segments_in_tst}    Get Segment Number For Travcom    ${segment_number}
    Identify Form Of Payment Code For APAC    ${str_card_type_${fare_tab_index}}
    Set Suite Variable    ${product_code}    PC40
    Set Suite Variable    ${vendor_code}    V00800004
    Set Suite Variable    ${product_code_2}    PC87
    Set Suite Variable    ${vendor_code_2}    V00800011
    Run Keyword If    "${mf_for_tf_amount_${fare_tab_index}}" != "0"    Log    GST On MF fo TF remarks must be written. Merchant Fee % value is: ${merchant_fee_value_${fare_tab_index}}" and Transaction Fee amount is: ${transaction_fee_value_${fare_tab_index}}
    ...    ELSE    Log    GST On MF fo TF remarks must not be written. Merchant Fee % value is: ${merchant_fee_value_${fare_tab_index}}" and Transaction Fee amount is: ${transaction_fee_value_${fare_tab_index}}
    Run Keyword If    "${mf_for_tf_amount_${fare_tab_index}}" != "0"    Verify GST On Merchant Fee For Transaction Fee Per TST Are Written    ${fare_tab}    ${segments_in_tst}    ${segment_number}
    ...    ELSE    Verify GST On Merchant Fee For Transaction Fee Per TST Not Written    ${fare_tab}    ${segments_in_tst}    ${segment_number}

Verify GST On Merchant Fee For Transaction Fee Per TST Are Written
    [Arguments]    ${fare_tab}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Remarks Leading And Succeeding Line Numbers    MSX/FF99-18P${computed_gst_mf_for_tf_amount_${fare_tab_index}}*0P0*0P0/${segment_number}
    Get Remarks Line And Descending Numbers    MSX/FF99-18P${computed_gst_mf_for_tf_amount_${fare_tab_index}}*0P0*0P0/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1-5} RM *MS/${product_code}/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1-4} RM *MSX/S${mf_for_tf_amount_${fare_tab_index}}/SF${mf_for_tf_amount_${fare_tab_index}}/C${mf_for_tf_amount_${fare_tab_index}}/SG0${segments_in_tst}/${segment_number}
    Verify Remarks Line Contains Masked Card    ${remarks_1-3} RM
    Run Keyword If    "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    ${remarks_1-3} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_1-3} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1-2} RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RM *MSX/FF99-18P${computed_gst_mf_for_tf_amount_${fare_tab_index}}*0P0*0P0/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/FF MERCHANT FEE/${segment_number}
    ###PC87
    Get Remarks Leading And Succeeding Line Numbers    MSX/S${computed_gst_mf_for_tf_amount_${fare_tab_index}}/SF${computed_gst_mf_for_tf_amount_${fare_tab_index}}/C0/SG0${segments_in_tst}/${segment_number}
    ${remarks_0}    Evaluate    ${remarks_1} - 1
    Verify Specific Line Is Written In The PNR    ${remarks_0} RM *MS/${product_code_2}/${vendor_code_2}/TKFF0${fare_tab_index}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RM *MSX/S${computed_gst_mf_for_tf_amount_${fare_tab_index}}/SF${computed_gst_mf_for_tf_amount_${fare_tab_index}}/C0/SG0${segments_in_tst}/${segment_number}
    Verify Remarks Line Contains Masked Card    ${remarks_2} RM
    Run Keyword If    "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${computed_gst_mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${computed_gst_mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_3} RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_4} RM *MSX/FF VAT/${segment_number}

Verify GST On Merchant Fee For Transaction Fee Per TST Not Written
    [Arguments]    ${fare_tab}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Comment    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${mf_for_tf_amount_${fare_tab_index}}/SF${mf_for_tf_amount_${fare_tab_index}}/C${mf_for_tf_amount_${fare_tab_index}}/SG0${segments_in_tst}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF99-18P${computed_gst_mf_for_tf_amount_${fare_tab_index}}*0P0*0P0/${segment_number}
    ###PC87
    Comment    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${computed_gst_mf_for_tf_amount_${fare_tab_index}}/SF${computed_gst_mf_for_tf_amount_${fare_tab_index}}/C0/SG0${segments_in_tst}${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${computed_gst_mf_for_tf_amount_${fare_tab_index}}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${computed_gst_mf_for_tf_amount_${fare_tab_index}}/${segment_number}

Verify GST On Merchant Fee TF Field Is Disabled
    ${merchant_tf_field}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOnTransactionFee
    Verify Control Object Is Disabled    ${merchant_tf_field}

Verify GST On Merchant Fee TF Field Is Disabled And Empty
    ${merchant_tf_field}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOnTransactionFee
    Verify Control Object Is Disabled    ${merchant_tf_field}
    ${gst_merchant_fee_transaction_fee_fare_amount}    Get Control Text Value    ${merchant_tf_field}
    Run Keyword If    "${gst_merchant_fee_transaction_fee_fare_amount}" == "${EMPTY}"    Log    GST Merchant Fee (TF) amount field is empty.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    GST Merchant Fee (TF) amount field is not empty.

Verify GST Remarks Per TST Are Correct
    [Arguments]    ${fare_tab}    ${gst_type}    ${segment_number}    ${segments_in_tst}    ${fop}    ${occurence}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${ff_number}    Set Variable    0${fare_tab_index}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${gst_type}    Convert To Lowercase    ${gst_type}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    ${gst_amount}    Run Keyword If    "${gst_type}" == "merchant fee"    Calculate GST On Merchant Fee    ${fare_tab}
    ...    ELSE IF    "${gst_type}" == "transaction fee"    Calculate GST On Transaction Fee    ${fare_tab}    IN
    ...    ELSE IF    "${gst_type}" == "air"    Calculate GST On Air    ${fare_tab}    IN
    ...    ELSE IF    "${gst_type}" == "merchant fee on tf"    Calculate GST On Merchant Fee For Transaction Fee    ${fare_tab}
    ${line1}    Set Variable    RM \\*MS/PC87/V00800011/TK/PX1/${segment_number}
    ${line2}    Set Variable    RM \\*MSX/S${gst_amount}/SF${gst_amount}/C0/SG${segments_in_tst}/${segment_number}
    ${line3}    Set Variable If    ${is_credit_card}    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D${gst_amount}/${segment_number}    RM \\*MSX/FS
    ${line4}    Set Variable    RM \\*MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    ${line5}    Set Variable    RM \\*MSX/FF VAT/${segment_number}
    Log    Expected: ${line1} ${line2} ${line3} ${line4} ${line5}
    Verify Specific Line Is Written In The PNR X Times    ${line1} ${line2} ${line3} ${line4} ${line5}    ${occurence}    reg_exp_flag=True

Verify GST Total Amount Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Calculate GST Total Amount    ${fare_tab}
    Get GST Total Value    ${fare_tab}
    Run Keyword If    "${computed_total_gst_amount_${fare_tab_index}}" == "${gst_total_amount_${fare_tab_index}}"    Log    Displayed GST Total Amount: ${gst_total_amount_${fare_tab_index}} is the same as the computed GST total amount.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Displayed GST Total Amount: ${gst_total_amount_${fare_tab_index}} is not the same as the computed GST total amount: ${computed_total_gst_amount_${fare_tab_index}}.

Verify GST Total Field Is Disabled
    ${gst_field}    Determine Multiple Object Name Based On Active Tab    ctxtGSTAmount
    Verify Control Object Is Disabled    ${gst_field}

Verify High Fare Accepts Input
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    ${actual_high_fare_field_color}    Determine Control Object Background Color    ${high_fare_field}
    Run Keyword And Continue On Failure    Should Be True    "${actual_high_fare_field_color}" != "FFD700"

Verify High Fare Field Is Disabled
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Is Disabled    ${high_fare_field}

Verify High Fare Field Is Enabled
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Is Enabled    ${high_fare_field}

Verify High Fare Field Is Mandatory
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Background Color    ${high_fare_field}    FFD700
    [Teardown]    Take Screenshot

Verify High Fare Field Is Not Visible
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Is Not Visible    ${high_fare_field}
    [Teardown]    Take Screenshot

Verify High Fare Field Is Visible
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Is Visible    ${high_fare_field}

Verify High Fare Field Value
    [Arguments]    ${expected_high_fare_value}    ${fare_tab}=Fare 1
    Get High Fare Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${converted_high_fare}    ${expected_high_fare_value}
    [Teardown]    Take Screenshot

Verify High Fare Is Blank
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Verify Control Object Text Value Is Correct    ${object_name}    ${EMPTY}    High fare should be blank

Verify High Fare Limits To Two Decimals Only
    Get High Fare Value
    Set High Fare Field    ${converted_high_fare}999
    Get High Fare Value
    ${decimals}    Fetch From Right    ${converted_high_fare}    .
    ${decimal_length}    Get Length    ${decimals}
    Run Keyword And Continue On Failure    Should Be True    "${decimal_length}"=="2"

Verify High Fare Value Is Retrieved From TST
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get High Fare From TST    ${fare_tab}    ${segment_number}
    Verify High Fare Field Value    ${high_fare_${fare_tab_index}}    ${fare_tab}
    [Teardown]    Take Screenshot

Verify High Fare Value Is Same From Exchange TST
    [Arguments]    ${fare_tab}
    [Documentation]    Execute Get Base Fare, Taxes And Total Fare From Exchange Ticket Prior To This Keyword
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify High Fare Field Value    ${total_add_coll_${fare_tab_index}}    ${fare_tab}
    [Teardown]    Take Screenshot

Verify High Fare Value Is Same From New Booking
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify High Fare Field Value    ${high_fare_value_${fare_tab_index}}    ${fare_tab}

Verify High/Charged/Low Fare Fields Has Correct Values
    [Arguments]    ${fare_tab_value}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Get High, Charged And Low Fare In Fare Tab    ${fare_tab_value}
    Verify Actual Value Matches Expected Value    ${high_fare_${fare_tab_index}}    ${high_fare_value_${fare_tab_index}}
    Verify Actual Value Matches Expected Value    ${charged_fare_${fare_tab_index}}    ${charged_fare_value_${fare_tab_index}}
    Verify Actual Value Matches Expected Value    ${low_fare_${fare_tab_index}}    ${low_fare_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify High/Charged/Low Fare, Realised Saving Code, Route Code Fields Are Enabled For Exchange
    Verify High Fare Field Is Enabled
    Verify Low Fare Field Is Enabled
    Verify Charged Fare Field Is Enabled
    Verify Realised Saving Code Field Is Enabled
    Verify Route Code Field Is Enabled

Verify High/Charged/Low Fare, Realised/Missed Saving Code, Route Code Fields Are Disabled
    Verify High Fare Field Is Disabled
    Verify Low Fare Field Is Disabled
    Verify Charged Fare Field Is Disabled
    Verify Realised Saving Code Field Is Disabled
    Verify Missed Savings Code Field Is Disabled
    Verify Route Code Field Is Disabled

Verify High/Charged/Low Fare, Realised/Missed Saving Code, Route Code Fields Are Enabled
    Verify High Fare Field Is Enabled
    Verify Low Fare Field Is Enabled
    Verify Charged Fare Field Is Enabled
    Verify Realised Saving Code Field Is Enabled
    Verify Missed Savings Code Field Is Enabled
    Verify Route Code Field Is Enabled

Verify High/Charged/Low Fare, Realised/Missed Saving Code, Route Code Filed Values Are Correct
    [Arguments]    ${expected_high_fare}    ${expected_charged_fare}    ${expected_low_fare}    ${expected_realised_savings_code}    ${expected_missed_savings_code}    ${expected_route_code}
    Verify High Fare Field Value    ${expected_high_fare}
    Verify Low Fare Field Value    ${expected_low_fare}
    Verify Charged Fare Field Value    ${expected_charged_fare}
    Verify Realised Savings Code Default Value    ${expected_realised_savings_code}
    Verify Missed Savings Code Default Value    ${expected_missed_savings_code}
    Verify Route Code Field Value    ${expected_route_code}

Verify If High Fare Is Less Than Charged Fare Then High Fare Field Is Blank, Otherwise Contains High Fare Value
    Log    ${high_fare_value_${fare_tab_index}}
    Log    ${charged_fare_value_${fare_tab_index}}
    Run Keyword And Continue On Failure    Run Keyword If    ${high_fare_value_${fare_tab_index}} < ${charged_fare_value_${fare_tab_index}}    Verify High Fare Is Blank
    ...    ELSE    Verify High Fare Field Value    ${high_fare_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify If Low Fare Is Greater Than Charged Fare Then Low Fare Field Is Blank, Otherwise Contains Low Fare Value
    Run Keyword And Continue On Failure    Run Keyword If    ${low_fare_value_${fare_tab_index}} > ${charged_fare_value_${fare_tab_index}}    Verify Low Fare Is Blank
    ...    ELSE    Verify Low Fare Field Value    ${low_fare_value_${fare_tab_index}}
    [Teardown]    Take Screenshot

Verify Invalid Icon And Invalid Amount Message Is Displayed
    ${invalid_icon_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${invalid_icon_exists}    Invalid icon is NOT displayed
    Run Keyword If    ${invalid_icon_exists} == True    Hover Object    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    ${invalid_amount_tool_tip_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\invalid_amount_tool_tip.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${invalid_amount_tool_tip_exists}    Invalid amount message tooltip is NOT displayed
    [Teardown]    Take Screenshot

Verify Invalid Icon And Validate High Fare Message Is Displayed
    ${invalid_icon_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${invalid_icon_exists}
    Run Keyword If    ${invalid_icon_exists} == True    Hover Object    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    ${validate_high_fare_tool_tip_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\validate_high_fare_tool_tip.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${validate_high_fare_tool_tip_exists}
    [Teardown]    Take Screenshot

Verify Invalid Icon And Validate Low Fare Message Is Displayed
    ${invalid_icon_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${invalid_icon_exists}
    Run Keyword If    ${invalid_icon_exists} == True    Hover Object    ${sikuli_image_path}\\invalid_input_icon.png    0.80    ${timeout}
    ${validate_low_fare_tool_tip_exists}    Run Keyword And Return Status    Object Exists    ${sikuli_image_path}\\validate_low_fare_tool_tip.png    0.80    ${timeout}
    Run Keyword And Continue On Failure    Should Be True    ${validate_low_fare_tool_tip_exists}
    [Teardown]    Take Screenshot

Verify Invalid Missed Saving Code Error Message Is Displayed
    [Arguments]    ${expected_tooltip_text}
    Comment    Verify Tooltip Text Is Correct Using Coords    502    609    ${expected_tooltip_text}
    ${aactual_tooltip_text}    Get Tooltip From Error Icon    [NAME:detailsTableLayoutPanel]
    Should Be Equal    ${aactual_tooltip_text}    ${expected_tooltip_text}
    [Teardown]    Take Screenshot

Verify Invalid Missed Saving Code Error Message Is Not Displayed
    ${tooltip_presence}    Is Tooltip Present    502    609
    Should Be True    ${tooltip_presence} == False    msg=Invalid Missed Saving Code Error Message should not be displayed
    [Teardown]    Take Screenshot

Verify Invalid Number ToolTip Is Displayed On Fare Quote Tab
    Comment    Verify Tooltip Text Is Correct Using Coords    693    552    Invalid Number
    ${actual_tooltip}    Get Tooltip From Error Icon    tlbFormOfPayment
    Should Be Equal As Strings    Invalid Number    ${actual_tooltip}
    [Teardown]    Take Screenshot

Verify Itinerary Remarks Are Written For LCC
    [Arguments]    ${identifier}    ${currency}    ${country}    ${is_currency_converted}=false
    ${identifier}    Fetch From Right    ${identifier}    ${SPACE}
    ${transaction_fee_value}    Round Apac    ${transaction_fee_value_${identifier}}    ${country}
    Verify Routing Itinerary Remarks Are Written    ${identifier}
    Verify Specific Line Is Written In The PNR    RIR ADULT FARE: ${currency} ${lcc_fare_total_${identifier}} PLUS ${currency} ${lcc_taxes_total_${identifier}} TAXES
    Run Keyword If    '${country}' == 'SG'    Set Test Variable    ${fuel_surcharge_value_${identifier}}    0
    Run Keyword If    '${country}' == 'HK' and '${fuel_surcharge_value_${identifier}}' != '0'    Verify Specific Line Is Written In The PNR    RIR FF SVC FEE FOR SURCHARGE: HKD ${fuel_surcharge_value_${identifier}}
    Verify Specific Line Is Written In The PNR    RIR TRANSACTION FEE: ${currency} ${transaction_fee_value}
    Verify Specific Line Is Written In The PNR    RIR TOTAL AMOUNT: ${currency} ${total_amount_${identifier}}
    Run Keyword If    "${is_currency_converted.lower()}" == "true"    Verify Specific Line Is Written In The PNR    ALL FARES & TAXES ARE SUBJECTED TO CHANGES &FLUCTUATION    false    true    true

Verify LCC Fare Tab Details
    [Arguments]    ${routing}    ${high_fare}    ${charged_fare}    ${low_fare}    ${realised_saving_code}    ${missed_saving_code}
    ...    ${travel_fusion_booking}=false    ${identifier}=${EMPTY}    ${reset_class_code}=false
    ${high_fare}    Set Variable If    '${travel_fusion_booking.lower()}' == 'true' and "${high_fare}" == "${EMPTY}"    ${lcc_total_amount_${identifier}}    ${high_fare}
    ${charged_fare}    Set Variable If    '${travel_fusion_booking.lower()}' == 'true' and "${charged_fare}" == "${EMPTY}"    ${lcc_total_amount_${identifier}}    ${charged_fare}
    ${low_fare}    Set Variable If    '${travel_fusion_booking.lower()}' == 'true' and "${low_fare}" == "${EMPTY}"    ${lcc_total_amount_${identifier}}    ${low_fare}
    ${class_code}    Get Variable Value    ${class_text_value_${identifier}}    ${EMPTY}
    ${class_code}    Set Variable If    '${travel_fusion_booking.lower()}' == 'true' and '${reset_class_code.lower()}' == 'false'    ${class_code}    ${EMPTY}
    ${fare_tab}    Set Variable If    "${identifier}" == "${EMPTY}"    Fare 1    ${identifier}
    Verify Routing Field Value    ${routing}
    Verify High Fare Field Value    ${high_fare}    ${fare_tab}
    Verify Charged Fare Field Value    ${charged_fare}    ${fare_tab}
    Verify Low Fare Field Value    ${low_fare}    ${fare_tab}
    Verify Realised Savings Code Default Value    ${realised_saving_code}
    Verify Missed Savings Code Default Value    ${missed_saving_code}
    Run Keyword If    '${locale}' == 'fr-FR'    Run Keywords    Verify Class Code Is Mandatory And Has No Value
    ...    ELSE IF    '${travel_fusion_booking.lower()}' == 'true' and "${class_code}"!="${EMPTY}"    Verify Class Code Default Value Is Correct    ${class_code}
    ...    ELSE IF    '${travel_fusion_booking.lower()}' == 'true'    Verify Class Code Is Mandatory And Has No Value

Verify LCC Remarks Are Written In The PNR In Correct Order
    [Arguments]    @{expected_collection_of_lcc_remarks}
    ${actual_collection_of_lcc_remarks}    Get LCC Remarks
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${actual_collection_of_lcc_remarks}    ${expected_collection_of_lcc_remarks}

Verify LFCC Accounting Remark Is Written
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    RM *FF81/${lfcc_value_${fare_tab_index}}/${segment_number}

Verify LFCC Field Is Disabled
    ${class_code_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowestFareCC
    Verify Control Object Is Disabled    ${class_code_field}

Verify LFCC Field Is Enabled
    ${class_code_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowestFareCC
    Verify Control Object Is Enabled    ${class_code_field}

Verify LFCC Field Is Mandatory
    Verify Control Object Background Color    text_LFCC1    FCFCFC
    [Teardown]    Take Screenshot

Verify LFCC Field On Air Fare Panel behaves Correctly
    Set LFCC Field    X.
    ${actual_tooltip_CF}    Get Tooltip From Error Icon    detailsTableLayoutPanel
    Verify Actual Value Matches Expected Value    ${actual_tooltip_CF}    Please enter a valid Lowest Fare Carrier Code (2 character codes).
    Verify Panel Status    RED    Air Fare
    #Set LFCC as Blank
    Verify Mandatory Field    ctxtLowestFareCC    True
    Verify Panel Status    RED    Air Fare
    #Set Valid LFCC
    Set LFCC Field    CD
    Verify Panel Status    GREEN    Air Fare

Verify LFCC Field Value
    [Arguments]    ${expected_lfcc_value}    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get LFCC Field Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${lfcc_value_${fare_tab_index}}    ${expected_lfcc_value}

Verify LFCC Value Is Retrieved From FV Line In TST
    [Arguments]    ${fare_tab}    ${segment_number}=S2    ${gds_command}=TQT
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get LFCC From FV Line In TST    ${fare_tab}    ${segment_number}
    Get LFCC Field Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${lfcc_in_tst_${fare_tab_index}}    ${lfcc_value_${fare_tab_index}}

Verify LFCC Value Is Same From New Booking
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify LFCC Field Value    ${lfcc_value_${fare_tab_index}}    ${fare_tab}

Verify Low Fare Accepts Input
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    ${actual_low_fare_field_color}    Determine Control Object Background Color    ${low_fare_field}
    Run Keyword And Continue On Failure    Should Be True    "${actual_low_fare_field_color}" != "FFD700"
    [Teardown]    Take Screenshot

Verify Low Fare Field Is Disabled
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    Verify Control Object Is Disabled    ${low_fare_field}

Verify Low Fare Field Is Enabled
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    Verify Control Object Is Enabled    ${low_fare_field}

Verify Low Fare Field Is Mandatory
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    Verify Control Object Background Color    ${low_fare_field}    FFD700

Verify Low Fare Field Value
    [Arguments]    ${expected_low_fare_value}    ${fare_tab}=Fare 1
    Verify Actual Value Matches Expected Value    ${actual_value}    ${expected_low_fare_value}
    [Teardown]    Take Screenshot

Verify Low Fare Is Blank
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    Verify Control Object Text Value Is Correct    ${object_name}    ${EMPTY}

Verify Low Fare Limits To Two Decimals Only
    Get Low Fare Value
    Set Low Fare Field    ${converted_low_fare}888
    Get Low Fare Value
    ${decimals}    Fetch From Right    ${converted_low_fare}    .
    ${decimal_length}    Get Length    ${decimals}
    Run Keyword And Continue On Failure    Should Be True    "${decimal_length}"=="2"

Verify Low Fare Value Is Retrieved From TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${currency}    ${country}=IN    ${identifier}=${EMPTY}    ${command}=${EMPTY}
    [Documentation]    By default ${command} = ${EMPTY}
    ...    If we pass ${command}=FXD, it will use FXD/{segment}/w2 and get the low fare value.
    ...    If we pass ${command}=${EMPTY}, it will get low fare value by using FXL/{Segment}.
    Activate Power Express Window
    Click Panel    Air Fare
    Click Fare Tab    ${fare_tab}
    Get Low Fare Value    ${fare_tab}    identifier=${identifier}    country=${country}
    ${expected_low_fare_value}    Set Variable If    "${country}"=="IN"    ${low_fare_value_${fare_tab_index}}    ${low_fare_${fare_tab_index}}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    #Fetching using FXD/TST command
    Run Keyword If    "${country}" == "IN" and "${command}" == "FXD"    Get FXD Low Value in GDS    FXD/${segment_number}/W2
    ...    ELSE    Get Low Fare From TST    ${fare_tab}    ${segment_number}    ${currency}
    ${actual_value}    Set Variable If    "${country}" == "IN" and "${command}" == "FXD"    ${fxd_value}    ${low_fare}
    Set Suite Variable    ${actual_value}
    Verify Low Fare Field Value    ${expected_low_fare_value}    ${fare_tab}
    [Teardown]    Take Screenshot

Verify Low Fare Value Is Same From Exchange TST
    [Arguments]    ${fare_tab}
    [Documentation]    Execute Get Base Fare, Taxes And Total Fare From Exchange Ticket Prior To This Keyword
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Low Fare Field Value    ${total_add_coll_${fare_tab_index}}    ${fare_tab}
    [Teardown]    Take Screenshot

Verify Low Fare Value Is Same From New Booking
    [Arguments]    ${fare_tab}    ${identifier1}=${EMPTY}    ${identifier2}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Low Fare Value    ${fare_tab}    identifier=${identifier2}
    Verify Value Of Low Fare Match    ${identifier1}    ${identifier2}
    Comment    Verify Low Fare Field Value    ${low_fare_value_${fare_tab_index}}    ${fare_tab}

Verify Lowest Carrier Code Is Written In The PNR
    [Arguments]    ${lfcc_remark}
    Verify Text Contains Expected Value    ${pnr_details}    ${lfcc_remark}

Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)
    [Arguments]    @{exclude_field}
    &{dict}    Create Dictionary    Fare Incl Taxes=ctxtFareIncludingTaxes    Airline Comm=ctxtAirlineCommissionPercent    Commission Return Amount=ctxtCommissionRebateAmount    Commission Return Percent=ctxtCommissionPercent    Nett Fare=txtNetFare
    ...    Merchant Fee Amount=ctxtMerchantFeeAmount    Merchant Fee Percent=ctxtMerchantFeePercent    Transaction Fee=cbTransactionFee    MarkUp Amount=ctxtMarkUpAmount    MarkUp Percent=ctxtMarkUpPercent    Total=ctxtTotalAmount
    Remove From Dictionary    ${dict}    @{exclude_field}
    ${values}    Get Dictionary Values    ${dict}
    : FOR    ${field}    IN    @{values}
    \    ${obj_name}    Determine Multiple Object Name Based On Active Tab    ${field}
    \    Verify Control Object Is Disabled    ${obj_name}

Verify Main Fees Values Are Correct
    [Arguments]    ${identifier1}    ${identifier2}
    [Documentation]    This Keyword is to Verify The Existing Main Fee Values with the Current Main Fee Values,
    ...    ${identifer1} = By using this Keyword we can able to get the Previous Fare Values(Fare or Alternate Fare)
    ...
    ...    ${identifier2}= By using this Keyword we can able to get the Current Fare Values(Fare or Alternate Fare)
    ...
    ...    Input:
    ...    ${main_fees_collection_Prev Alt 1} ${main_fees_collection_New Alt 1}
    ...
    ...
    ...    Output:
    ...    ${identifer1}==${identifer2}==> True
    ...    ${identifer1}!=${identifer2}==> False
    Run Keyword And Continue On Failure    Should Be Equal    ${main_fees_collection_${identifier1}}    ${main_fees_collection_${identifier2}}

Verify Mandatory Field
    [Arguments]    ${field_name}    ${set_field_to_empty}=false
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ${field_name}
    Run Keyword If    "${set_field_to_empty}" == "True"    Set Field To Empty    ${object_name}
    Verify Control Object Background Color    ${object_name}    FFD700
    [Teardown]    Take Screenshot

Verify Mandatory Field For Dropdown List
    [Arguments]    ${field_name}    ${set_field_to_empty}=false
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ${field_name}
    Control Focus    ${title_power_express}    ${EMPTY}    ${object_name}
    Send    {DOWN}
    Send    {DELETE}
    Send    {TAB}
    Verify Control Object Background Color    ${object_name}    FFD700
    [Teardown]    Take Screenshot

Verify Manually Created Credit Card Expiration Date
    [Arguments]    ${fare_tab}
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    ${fare_tab}    VI    4012888888881881    1200
    Verify Credit Card Is Expired ToolTip Is Displayed On Fare Quote Tab

Verify Manually Created Credit Card Invalid Number
    [Arguments]    ${fare_tab}
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    ${fare_tab}    AX    4012888888881881    1231
    Verify Invalid Number ToolTip Is Displayed On Fare Quote Tab
    Click Clear Form Of Payment Icon On Fare Quote Tab

Verify Manually Created Credit Card Near Expiration Date
    [Arguments]    ${fare_tab}
    Set Credit Card Using Near Expiration Date    ${fare_tab}
    Verify That Warning For Card Expiration Is Displayed On Fare Quote Tab    True

Verify Mark-Up Amount And Percentage Are Empty Or Blank
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Mark-Up Amount Is Empty    ${fare_tab_index}
    Verify Mark-Up Percentage Is Empty    ${fare_tab_index}

Verify Mark-Up Amount Field Is Displayed And Enabled
    [Arguments]    ${fare_tab}=Fare 1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${mark_up_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpAmount_${tab_number}]    "${fare_tab_type}"=="Alt"    [NAME:ctxtMarkUpAmount_alt_${tab_number}]
    Verify Control Object Is Enabled    ${mark_up_amount_obj}
    [Teardown]    Take Screenshot

Verify Mark-Up Amount Field Is Not Displayed
    [Arguments]    ${fare_tab}=Fare 1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${mark_up_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpAmount_${tab_number}]    "${fare_tab_type}"=="Alternate"    [NAME:ctxtMarkUpAmount_alt_${tab_number}]
    Verify Control Object Is Not Visible    ${mark_up_amount_obj}
    Set Test Variable    ${mark_up_amount_${fare_tab_index}}    0
    [Teardown]    Take Screenshot

Verify Mark-Up Amount Is Empty
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${markup_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount, txtMarkupAmount
    ${markup_amount_field}    Get Control Text Value    ${markup_amount_field}
    Run Keyword If    "${markup_amount_field}" == "${EMPTY}"    Log    Mark Up Amount is set to Empty.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Mark Up Amount is not Empty. Actual Value is ${markup_amount_field}.
    ${markup_amount_field}    Set Variable If    "${markup_amount_field}" == "${EMPTY}"    0    ${markup_amount_field}
    Set Suite Variable    ${mark_up_value_${fare_tab_index}}    ${markup_amount_field}

Verify Mark-Up Amount Percentage Field Is Not Displayed
    [Arguments]    ${fare_tab}=Fare 1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${mark_up_percentage_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpPercent_${tab_number}]    "${fare_tab_type}"=="Alternate"    [NAME:ctxtMarkUpPercent_alt_${tab_number}]
    Verify Control Object Is Not Visible    ${mark_up_percentage_obj}
    Set Test Variable    ${mark_up_percentage_${fare_tab_index}}    0
    [Teardown]    Take Screenshot

Verify Mark-Up Percentage Field Is Displayed And Enabled
    [Arguments]    ${fare_tab}=Fare 1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${mark_up_percentage_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpPercent_${tab_number}]    [NAME:ctxtMarkUpPercent_alt_${tab_number}]
    Verify Control Object Is Enabled    ${mark_up_percentage_obj}
    [Teardown]    Take Screenshot

Verify Mark-Up Percentage Is Empty
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${markup_percent_field}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent
    ${markup_percent_field}    Get Control Text Value    ${markup_percent_field}
    Run Keyword If    "${markup_percent_field}" == "${EMPTY}"    Log    Mark Up percentage is set to Empty.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Mark Up percentage is not Empty. Actual Value is ${markup_percent_field}.
    ${markup_percent_field}    Set Variable If    "${markup_percent_field}" == "${EMPTY}"    0    ${markup_percent_field}
    Set Suite Variable    ${markup_percent_field_${fare_tab_index}}    ${markup_percent_field}

Verify Mark-up Amount Value Is Correct
    [Arguments]    ${fare_tab}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Mark-Up Amount Value    ${fare_tab}
    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "${EMPTY}" or "${nett_fare_value_${fare_tab_index}}" == "0"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    ${mark_up_amount}    Evaluate    ${base_or_nett_fare_${fare_tab_index}} * ${mark_up_percentage_value_${fare_tab_index}}
    Run Keyword If    "${country}" == "SG"    Round Apac    ${mark_up_amount}    ${country}
    ...    ELSE IF    "${country}" == "HK" or "${country}" == "IN"    Round Apac    ${mark_up_amount}    ${country}
    Run Keyword If    "${country}" == "SG"    Convert To Float    ${mark_up_amount}    ${country}
    ...    ELSE IF    "${country}" == "HK" or "${country}" == "IN"    Convert To Float    ${mark_up_amount}    ${country}
    Set Suite Variable    ${expected_mark_up_amount_${fare_tab_index}}    ${mark_up_amount}
    Verify Text Contains Expected Value    ${merchant_fee_value_${fare_tab_index}}    ${expected_mark_up_amount_${fare_tab_index}}

Verify MarkUp Amount Field Is Disabled
    ${markup_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount
    Verify Control Object Is Disabled    ${markup_amount_field}

Verify MarkUp Amount Value Is Correct
    [Arguments]    ${fare_tab}    ${country}    ${rounding_so}=${EMPTY}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Get MarkUp Amount Value    ${fare_tab}
    Comment    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "${EMPTY}" or "${nett_fare_value_${fare_tab_index}}" == "0"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ${mark_up_amount}    Evaluate    ${base_or_nett_fare_${fare_tab_index}} * ${mark_up_percentage_value_${fare_tab_index}} / 100
    ${mark_up_amount}    Round To Nearest Dollar    ${mark_up_amount}    ${country}    ${rounding_so}
    Set Suite Variable    ${expected_mark_up_amount_${fare_tab_index}}    ${mark_up_amount}
    Verify Actual Value Matches Expected Value    ${mark_up_value_${fare_tab_index}}    ${expected_mark_up_amount_${fare_tab_index}}

Verify MarkUp Percentage Field Is Disabled
    ${markup_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtMarkupPercentage
    Verify Control Object Is Disabled    ${markup_percentage_field}

Verify Mask Icon Is Disabled
    ${mask_icon}    Determine Multiple Object Name Based On Active Tab    cmdMaskCard
    Verify Control Object Is Disabled    ${mask_icon}

Verify Merchant Fee Amount And Percentage Are Empty Or Blank
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Merchant Fee Amount Is Empty    ${fare_tab_index}
    Verify Merchant Fee Percentage Is Empty    ${fare_tab_index}

Verify Merchant Fee Amount Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}    ${airline_commission_or_client_rebate}=Airline Commission    ${has_client_cwt_comm_agreement}=No    ${start_substring}=4    ${end_substring}=6    ${rounding_so}=${EMPTY}
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Set Suite Variable    ${country}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Set Test Variable    ${gst_airfare_value_service_${fare_tab_index}}    0
    ${fop_merchant_fee_type}    Get Variable Value    ${fop_merchant_fee_type_${fare_tab_index}}    0
    Comment    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "0" or "${nett_fare_value_${fare_tab_index}}" == "0.00"    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    Set Suite Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    Run Keyword If    "${country}" == "IN"    Calculate GST On Air    ${fare_tab}
    Run Keyword If    "${airline_commission_or_client_rebate.upper()}" == "CLIENT REBATE" and "${fop_merchant_fee_type}" == "CWT"    Log    Client Rebate is applied and FOP is CWT
    ...    ELSE IF    "${airline_commission_or_client_rebate.upper()}" == "AIRLINE COMMISSION" and "${fop_merchant_fee_type}" == "CWT"    Log    Airline Commission is applied and FOP is CWT
    ...    ELSE IF    "${country}" == "IN" and "${fop_merchant_fee_type.upper()}" == "AIRLINE" and "${has_client_cwt_comm_agreement.upper()}" == "YES"    Log    Country is India, FOP is Airline and Has Client CWT Comm Agreement.
    ...    ELSE    Log    No Setup was added.
    ${computed_merchant_amount}    Run Keyword If    "${airline_commission_or_client_rebate.upper()}" == "CLIENT REBATE" and "${fop_merchant_fee_type}" == "CWT"    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value_${fare_tab_index}} + ${gst_airfare_value_service_${fare_tab_index}} - ${commission_rebate_value_${fare_tab_index}}) * ${merchant_fee_percentage_value_${fare_tab_index}}/100
    ...    ELSE IF    "${airline_commission_or_client_rebate.upper()}" == "AIRLINE COMMISSION" and "${fop_merchant_fee_type}" == "CWT"    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value_${fare_tab_index}} + ${gst_airfare_value_service_${fare_tab_index}}) * ${merchant_fee_percentage_value_${fare_tab_index}}/100
    ...    ELSE IF    "${country}" == "IN" and "${fop_merchant_fee_type.upper()}" == "AIRLINE" and "${has_client_cwt_comm_agreement.upper()}" == "YES"    Evaluate    ${gst_airfare_value_service_${fare_tab_index}} * ${merchant_fee_percentage_value_${fare_tab_index}}/100
    ...    ELSE    Set Variable    ${EMPTY}
    Comment    ${computed_merchant_amount}    Round Apac    ${computed_merchant_amount}    ${country}
    ${computed_merchant_amount}    Round To Nearest Dollar    ${computed_merchant_amount}    ${country}    ${rounding_so}
    Should Be Equal As Strings    ${merchant_fee_value_${fare_tab_index}}    ${computed_merchant_amount}    msg=Actual merchant fee amount: ${merchant_fee_value_${fare_tab_index}} displayed is not equal to computed merchant amount fee: ${computed_merchant_amount}.
    Log    BaseFare: ${base_or_nett_fare_${fare_tab_index}} Tax: ${total_tax_${fare_tab_index}} Markup: ${mark_up_value_${fare_tab_index}} GST: ${gst_airfare_value_service_${fare_tab_index}} Merchant: ${merchant_fee_percentage_value_${fare_tab_index}}/100
    [Teardown]    Take Screenshot

Verify Merchant Fee Amount Is Empty
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${merchant_fee_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount
    ${merchant_fee_amount}    Get Control Text Value    ${merchant_fee_amount_field}
    Run Keyword If    "${merchant_fee_amount}" == "${EMPTY}"    Log    Merchant Fee amount is set to Empty.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Merchant Fee amount is not Empty. Actual Value is ${merchant_fee_amount}.
    ${merchant_fee_amount}    Set Variable If    "${merchant_fee_amount}" == "${EMPTY}"    0    ${merchant_fee_amount}
    Set Suite Variable    ${merchant_fee_value_${fare_tab_index}}    ${merchant_fee_amount}

Verify Merchant Fee Fields Are Disabled
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Control Object Is Disabled    [NAME:ctxtMerchantFeeAmount_${fare_tab_index}]
    Verify Control Object Is Disabled    [NAME:ctxtMerchantFeePercent_${fare_tab_index}]

Verify Merchant Fee Fields Are Displayed
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Control Object Is Visible    [NAME:txtMerchantFeeAmount_${fare_tab_index}]
    Verify Control Object Is Visible    [NAME:txtMerchantFeePercentage_${fare_tab_index}]

Verify Merchant Fee Fields Are Enabled
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Control Object Is Enabled    [NAME:ctxtMerchantFeeAmount_${fare_tab_index}]
    Verify Control Object Is Enabled    [NAME:ctxtMerchantFeePercent_${fare_tab_index}]

Verify Merchant Fee Fields Are Not Displayed
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Control Object Is Not Visible    [NAME:txtMerchantFeeAmount_${fare_tab_index}]
    Verify Control Object Is Not Visible    [NAME:txtMerchantFeePercentage_${fare_tab_index}]

Verify Merchant Fee For Transaction Fee Amount Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Calculate GST On Transaction Fee    ${fare_tab}    IN
    Calculate GST On Merchant Fee For Transaction Fee    ${fare_tab}
    Get Merchant Fee For Transaction Fee Value    ${fare_tab}
    Run Keyword If    "${merchant_fee_for_transaction_fee_${fare_tab_index}}" == "${mf_for_tf_amount_${fare_tab_index}}"    Log    Displayed Merchant Fee For Transaction Fee Amount: ${mf_for_tf_amount_${fare_tab_index}} is the same as the computed amount.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Displayed Merchant Fee For Transaction Fee Amount: ${mf_for_tf_amount_${fare_tab_index}} is not the same as the computed amount: ${merchant_fee_for_transaction_fee_${fare_tab_index}}.

Verify Merchant Fee Per TST Are Written
    [Arguments]    ${fare_tab}    ${country}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Remarks Leading And Succeeding Line Numbers    MSX/S${merchant_fee_value_${fare_tab_index}}/SF${merchant_fee_value_${fare_tab_index}}/C${merchant_fee_value_${fare_tab_index}}/SG0${segments_in_tst}/${segment_number}
    ${remarks_0}    Evaluate    ${remarks_1} - 1
    Verify Specific Line Is Written In The PNR    ${remarks_0} RM *MS/${product_code}/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_1} RM *MSX/S${merchant_fee_value_${fare_tab_index}}/SF${merchant_fee_value_${fare_tab_index}}/C${merchant_fee_value_${fare_tab_index}}/SG0${segments_in_tst}/${segment_number}
    Verify Remarks Line Contains Masked Card    ${remarks_2} RM
    Run Keyword If    "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${merchant_fee_value_${fare_tab_index}}/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_2} RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${merchant_fee_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    ${remarks_3} RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Written In The PNR    ${remarks_4} RM *MSX/FF99-18P${gst_merchant_fee_value_${fare_tab_index}}*0P0*0P0/${segment_number}
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Written In The PNR    ${remarks_4} RM *MSX/FF CC CONVENIENCE FEE/${segment_number}
    ...    ELSE IF    "${country}" == "SG"    Verify Specific Line Is Written In The PNR    ${remarks_4} RM *MSX/FF MERCHANT FEE/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    ${remarks_5} RM *MSX/FF MERCHANT FEE/${segment_number}
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Written In The PNR    RIR CC CONVENIENCE FEE: ${CURRENCY} ${merchant_fee_value_${fare_tab_index}}
    ...    ELSE IF    "${country}" == "SG"    Verify Specific Line Is Written In The PNR    RIR MERCHANT FEE: ${CURRENCY} ${merchant_fee_value_${fare_tab_index}}

Verify Merchant Fee Per TST Not Written
    [Arguments]    ${fare_tab}    ${country}    ${segments_in_tst}    ${segment_number}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Not Written In The PNR    RM *MS/${product_code}/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF0${fare_tab_index}/PX1/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${merchant_fee_value_${fare_tab_index}}/SF${merchant_fee_value_${fare_tab_index}}/C${merchant_fee_value_${fare_tab_index}}/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${merchant_fee_value_${fare_tab_index}}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Verify Specific Line Is Not Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${merchant_fee_value_${fare_tab_index}}/${segment_number}
    Comment    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF CC CONVENIENCE FEE/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF MERCHANT FEE/${segment_number}
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR CC CONVENIENCE FEE: ${CURRENCY} ${merchant_fee_value_${fare_tab_index}}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RIR MERCHANT FEE: ${CURRENCY} ${merchant_fee_value_${fare_tab_index}}

Verify Merchant Fee Per TST Remarks
    [Arguments]    ${fare_tab}    ${segment_number}    ${has_client_cwt_comm_agreement}=No
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    Calculate GST On Merchant Fee    ${fare_tab}
    Run Keyword If    "${merchant_fee_value_${fare_tab_index}}" == "0.00"    Set Test Variable    ${merchant_fee_value_${fare_tab_index}}    0
    ${fop_merchant_fee_type}    Get Variable Value    ${fop_merchant_fee_type_${fare_tab_index}}    0
    ${segments_in_tst}    Get Segment Number For Travcom    ${segment_number}
    Identify Form Of Payment Code For APAC    ${str_card_type_${fare_tab_index}}
    ${product_code}    Run Keyword If    "${country}" == "SG"    Set Variable    PC41
    ...    ELSE IF    "${country}" == "HK"    Set Variable    PC42
    ...    ELSE IF    "${country}" == "IN"    Set Variable    PC40
    ${vendor_code}    Run Keyword If    "${country}" == "SG"    Set Variable    V021007
    ...    ELSE IF    "${country}" == "HK"    Set Variable    V00001
    ...    ELSE IF    "${country}" == "IN"    Set Variable    V00800004
    ${currency}    Run Keyword If    "${country}" == "SG"    Set Variable    SGD
    ...    ELSE IF    "${country}" == "HK"    Set Variable    HKD
    ...    ELSE IF    "${country}" == "IN"    Set Variable    INR
    Set Suite Variable    ${product_code}
    Set Suite Variable    ${vendor_code}
    Set Suite Variable    ${currency}
    Run Keyword If    ("${fop_merchant_fee_type}" == "CWT" and "${merchant_fee_value_${fare_tab_index}}" != "0") or ("${country}" == "IN" and "${fop_merchant_fee_type.upper()}" == "AIRLINE" and "${has_client_cwt_comm_agreement.upper()}" == "YES" and "${merchant_fee_value_${fare_tab_index}}" != "0")    Verify Merchant Fee Per TST Are Written    ${fare_tab}    ${country}    ${segments_in_tst}    ${segment_number}
    ...    ELSE    Verify Merchant Fee Per TST Not Written    ${fare_tab}    ${country}    ${segments_in_tst}    ${segment_number}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Not Written In The PNR    RIR MERCHANT FEE: ${CURRENCY} ${merchant_fee_value_${fare_tab_index}}

Verify Merchant Fee Percentage Is Empty
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${merchant_fee_percent_field}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent
    ${merchant_fee_percent}    Get Control Text Value    ${merchant_fee_percent_field}
    Run Keyword If    "${merchant_fee_percent}" == "${EMPTY}"    Log    Merchant Fee percentage is set to Empty.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Merchant Fee percentage is not Empty. Actual Value is ${merchant_fee_percent}.
    ${merchant_fee_percent}    Set Variable If    "${merchant_fee_percent}" == "${EMPTY}"    0    ${merchant_fee_percent}
    Set Suite Variable    ${merchant_fee_percentage_value_${fare_tab_index}}    ${merchant_fee_percent}

Verify Merchant Fee Remarks Per TST Are Correct
    [Arguments]    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${type_of_merchant_fee}=merchant fee
    [Documentation]    ${type_of_merchant_fee} = Merchant Fee or Merchant Fee On TF
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    &{product_code_merchant_dict}    Create Dictionary    SG=PC41    HK=PC42    IN=PC40
    &{vendor_code_merchant_dict}    Create Dictionary    SG=V021007    HK=V00001    IN=V00800004
    ${product_code_merchant}    Get From Dictionary    ${product_code_merchant_dict}    ${country}
    ${vendor_code_merchant}    Get From Dictionary    ${vendor_code_merchant_dict}    ${country}
    ${ff_number}    Set Variable    0${fare_tab_index}
    ${merchant_fee_value}    Run Keyword If    "${type_of_merchant_fee.lower()}" == "merchant fee" or "${type_of_merchant_fee.lower()}" == "airline" or "${type_of_merchant_fee.lower()}" == "cwt"    Set Variable    ${merchant_fee_value_${fare_tab_index}}
    ...    ELSE    Set Variable    ${mf_for_tf_amount_${fare_tab_index}}
    ${is_merchant_fee_value_not_empty}    Evaluate    ${merchant_fee_value} > ${0}
    ${carrier}    Set Variable    ${lfcc_in_tst_${fare_tab_index}}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${is_cc_tmp_card_or_ctlc}    Run Keyword And Return Status    Should Contain Any    ${fop}    DC364403    VI44848860    CTLC
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    ${is_merchant_fee_applicable}    Set Variable If    "${country}" == "SG" and ${is_merchant_fee_value_not_empty} and ${is_credit_card} and not ${is_cc_tmp_card_or_ctlc}    ${True}    "${country}" != "SG" and ${is_merchant_fee_value_not_empty} and ${is_credit_card}    ${True}    ${False}
    ${remark_line_1}    Set Variable If    "${type_of_merchant_fee.lower()}" == "merchant fee on tf"    RM \\*MS/${product_code_merchant}/${vendor_code_merchant}/TK/PX1/${segment_number}    RM \\*MS/${product_code_merchant}/${vendor_code_merchant}/TK/PX1/${segment_number}
    Run Keyword If    ${is_merchant_fee_applicable}    Verify Specific Line Is Written In The PNR    ${remark_line_1}    true
    ...    ELSE IF    not ${is_merchant_fee_applicable}    Verify Specific Line Is Not Written In The PNR    ${remark_line_1}    true
    Run Keyword If    ${is_merchant_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/S${merchant_fee_value}/SF${merchant_fee_value}/C${merchant_fee_value}/SG${segments_in_tst}/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${merchant_fee_value}/SF${merchant_fee_value}/C${merchant_fee_value}/SG${segments_in_tst}/${segment_number}
    Run Keyword If    ${is_merchant_fee_applicable}    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D${merchant_fee_value}/${segment_number}    true
    Run Keyword If    ${is_merchant_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    ${is_merchant_fee_applicable} and "${country}" != "HK"    Verify Specific Line Is Written In The PNR    RM *MSX/FF MERCHANT FEE/${segment_number}
    ...    ELSE IF    ${is_merchant_fee_applicable} and "${country}" == "HK"    Verify Specific Line Is Written In The PNR    RM *MSX/FF CC CONVENIENCE FEE/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF MERCHANT FEE/${segment_number}
    ${gst_merchant_fee_value}    Run Keyword If    ${is_merchant_fee_applicable} and "${country}" == "IN"    Calculate GST On Merchant Fee    ${fare_tab}
    Run Keyword If    ${is_merchant_fee_applicable} and "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM *MSX/FF99-18P${gst_merchant_fee_value}*0P0*0P0/${segment_number}

Verify Missed Saving Code Dropdown Values Are Correct
    [Arguments]    ${fare_tab}    ${country}=HK
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${expected_missed_saving_code}    Run Keyword If    "${country.lower()}" == "hk"    Create List    B - PASSENGER REQUESTED SPECIFIC AIRLINE    C - LOW COST CARRIER FARE DECLINED    E - EXCHANGE
    ...    F - PASSENGER REQUESTED SPECIFIC CLASS    H - PASSENGER REQUESTED SPECIFIC SCHEDULE OR DATE    I - PASSENGER BOOKED TOO LATE    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    K - CLIENT NEGOTIATED FARE DECLINED    L - NO MISSED SAVING
    ...    N - CLIENT SPECIFIC    O - TRAVELLING WITH ANOTHER PERSON    P - PASSENGER DECLINED RESTRICTED FARE    Q - CLIENT NEGOTIATED RATE ACCEPTED    X - POLICY WAIVED - EMERGENCY CONDITIONS
    ...    ELSE IF    "${country.lower()}" == "sg"    Create List    B - PASSENGER REQUESTED SPECIFIC AIRLINE    C - LOW COST CARRIER FARE DECLINED    F - PASSENGER REQUESTED SPECIFIC CLASS
    ...    I - PASSENGER BOOKED TOO LATE    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    K - CLIENT NEGOTIATED FARE DECLINED    L - NO MISSED SAVING    M - MISCELLANEOUS    N - CLIENT SPECIFIC
    ...    O - TRAVELLING WITH ANOTHER PERSON    P - PASSENGER DECLINED RESTRICTED FARE    T - CONTRACTED AIRLINE NON CONVENIENT    Z - CWT ALTERNATIVE DECLINED
    ...    ELSE IF    "${country.lower()}" == "in"    Create List    A - PARTIAL MISSED SAVING    B - PASSENGER REQUESTED SPECIFIC AIRLINE    C - LOW COST CARRIER FARE DECLINED
    ...    E - EXCHANGE    F - PASSENGER REQUESTED SPECIFIC CLASS    H - PASSENGER REQUESTED SPECIFIC SCHEDULE OR DATE    I - PASSENGER BOOKED TOO LATE    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    K - CLIENT NEGOTIATED FARE DECLINED
    ...    L - NO MISSED SAVING    M - MISCELLANEOUS    N - CLIENT SPECIFIC    O - TRAVELLING WITH ANOTHER PERSON    P - PASSENGER DECLINED RESTRICTED FARE    Q - CLIENT NEGOTIATED RATE ACCEPTED
    ...    T - CONTRACTED AIRLINE NON CONVENIENT    X - POLICY WAIVED - EMERGENCY CONDITIONS    Z - CWT ALTERNATIVE DECLINED
    Log List    ${expected_missed_saving_code}
    Get Missed Saving Code Values    ${fare_tab}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${missed_saving_code_values_${fare_tab_index}}    ${expected_missed_saving_code}

Verify Missed Savings Code Default Value
    [Arguments]    ${expected_missed_saving_code_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_missed_saving_code_value}
    [Teardown]    Take Screenshot

Verify Missed Savings Code Field Is Disabled
    ${missed_saving_code_field}    Determine Multiple Object Name Based On Active Tab    pnlMissed
    Verify Control Object Is Disabled    ${missed_saving_code_field}

Verify Missed Savings Code Field Is Enabled
    ${missed_saving_code_field}    Determine Multiple Object Name Based On Active Tab    pnlMissed
    Verify Control Object Is Enabled    ${missed_saving_code_field}

Verify Missed Savings Code Is Mandatory And Has No Value
    ${missed_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    Verify Field Is Empty    ${missed_saving_code_dropdown}
    Verify Control Object Background Color    ${missed_saving_code_dropdown}    FFD700

Verify Nett Fare Field Is Disabled
    ${nett_field}    Determine Multiple Object Name Based On Active Tab    txtNetFare
    Verify Control Object Is Disabled    ${nett_field}

Verify Nett Fare Field Is Enabled
    ${nett_field}    Determine Multiple Object Name Based On Active Tab    txtNetFare
    Verify Control Object Is Enabled    ${nett_field}

Verify Nett Fare Value
    [Arguments]    ${fare_tab}    ${expected_nett_fare_value}
    Get Nett Fare Value    ${fare_tab}
    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "${expected_nett_fare_value}"    Log    Nett Fare Value is: ${nett_fare_value_${fare_tab_index}}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Nett Fare Value is: ${nett_fare_value_${fare_tab_index}} not equal to expected value of: ${expected_nett_fare_value}

Verify No Fares Found Message Is Not Present
    ${is_warning_message_present} =    Control Command    ${title_power_express}    ${EMPTY}    [NAME:lblWarning]    IsVisible    ${EMPTY}
    ${warning_message_text} =    Run Keyword If    ${is_warning_message_present} == 1    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:lblWarning]
    ${no_fares_error}    Set Variable If    "${locale}" == "fr-FR"    Attention : aucun tarif trouvé dans le PNR. Merci de tarifer et relire le PNR ou continuer avec l'option " tarif non finalisé"    Warning - No fares found in PNR. Please fare quote and read the PNR again or continue with the ‘Fare Not Finalised’ option to complete this PNR
    Should Not Contain    ${warning_message_text}    ${no_fares_error}
    [Teardown]    Take Screenshot

Verify Non Flexible Fare Restriction Field Is Disabled
    ${non_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradNonFlex_alt, cradNonFlexOBT_alt, cradNonFlex, cradNonFlex_alt, cradNonFlexOBT
    Verify Control Object Is Disabled    ${non_flexible_field}
    [Teardown]    Take Screenshot

Verify Non Flexible Fare Restriction Field Is Enabled
    ${non_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradNonFlex_alt, cradNonFlexOBT_alt, cradNonFlex, cradNonFlex_alt, cradNonFlexOBT
    Verify Control Object Is Enabled    ${non_flexible_field}

Verify Object Field Is Not Mandatory
    [Arguments]    ${object_name}
    ${actual_hex_color}    Get Pixel Color    control_id=${object_name}
    Run Keyword And Continue On Failure    Should Be True    "${actual_hex_color}" != "FFD700"    msg=Control should be NOT MANDATORY. Color found is "${actual_hex_color}"
    [Teardown]    Take Screenshot

Verify Offer Amount
    [Arguments]    ${fare_tab}=Alternate Fare 1
    ${total_offer_amount}    Get Amadeus Offer Amount    ${fare_tab}
    ${amadeus_offer_amount}    Get Total Fare Offer    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${amadeus_offer_amount}    ${total_offer_amount}
    [Teardown]    Take Screenshot

Verify Offer Details Are Displayed On Alternate Fare Tab
    [Arguments]    ${fare_tab}    ${fare_tab_on_new_booking}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${new_or_amend}    Get Substring    ${TEST NAME}    1    3
    Verify Text Contains Expected Value    ${routing_value_alt_${fare_tab_index}}    ${fare_route_alt_${fare_tab_index}}
    Verify Text Contains Expected Value    ${airline_offer_alt_${fare_tab_index}}    ${fare_airline_alt_${fare_tab_index}}
    Verify Text Contains Expected Value    ${total_fare_alt_${fare_tab_index}}    ${base_fare_alt_${fare_tab_index}}
    ${details_line_alt}    Flatten String    ${details_line_alt_${fare_tab_index}}
    ${alternate_airline_details}    Flatten String    ${alternate_airline_details_${fare_tab_index}}
    Verify Text Contains Expected Value    ${alternate_airline_details}    ${details_line_alt}
    Run Keyword If    "${new_or_amend}" == "NB"    Verify Default Fare Class
    Verify Text Contains Expected Value    ${fare_basis_value_${fare_tab_index.strip()}}    ${fare_basis_alt_${fare_tab_index.strip()}.replace(" ","")}    multi_line_search_flag=false    reg_exp_flag=false    remove_spaces=true
    Log    ${fare_basis_value_${fare_tab_index.strip()}}
    Log    ${fare_basis_alt_${fare_tab_index.strip()}.replace(" ","")}
    [Teardown]    Take Screenshot

Verify Only Expected Fee Is Displayed In Transaction Fee Dropdown
    [Arguments]    @{transaction_fee_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee
    ${actual_content_list}    Get Value From Dropdown List    ${object_name}
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${transaction_fee_value}    ${actual_content_list}
    [Teardown]    Take Screenshot

Verify PC Accounting Remark For Route Code Domestic Is Not Written
    [Arguments]    ${segment_number}
    Verify Specific Line Is Not Written In The PNR    RM \\*PC/4/00000031/AC\\d{3}/TK/${segment_number}    reg_exp_flag=True

Verify PC Accounting Remark For Route Code Domestic Is Written
    [Arguments]    ${segment_number}
    Verify Specific Line Is Written In The PNR X Times    RM \\*PC/4/00000031/AC\\d{3}/TK/${segment_number}    1    reg_exp_flag=True

Verify PC Accounting Remark For Route Code International Is Not Written
    [Arguments]    ${segment_number}    ${country}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Not Written In The PNR    ${pnr_details}    RM \\*PC/0/00000030/AC\\d{3}/TK/${segment_number}    reg_exp_flag=True
    Run Keyword If    "${country}" == "SG"    Verify Specific Line Is Not Written In The PNR    ${pnr_details}    RM *PC/0/022000/${segment_number}
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    ${pnr_details}    RM *PC/0/000030/${segment_number}

Verify PC Accounting Remark For Route Code International Is Written
    [Arguments]    ${segment_number}    ${country}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Written In The PNR X Times    RM \\*PC/0/00000030/AC\\d{3}/TK/${segment_number}    1    reg_exp_flag=True
    Run Keyword If    "${country}" == "SG"    Verify Specific Line Is Written In The PNR    RM \\*PC/0/022000/AC\\d{3}/TK/${segment_number}    true
    Run Keyword If    "${country}" == "HK"    Verify Specific Line Is Written In The PNR    RM \\*PC/0/000030/AC\\d{3}/TK/${segment_number}    true

Verify Panel Status
    [Arguments]    ${expected_panel_status}    @{panel}
    Determine Current Panels
    : FOR    ${each_panel}    IN    @{panel}
    \    Dictionary Should Contain Key    ${panel_coordinates}    ${each_panel.upper()}    ${each_panel.upper()} panel should be visible
    \    ${y}    Get From Dictionary    ${panel_coordinates}    ${each_panel.upper()}
    \    ${panel_status}    Get Panel Status    13    ${y}
    \    Run Keyword And Continue On Failure    Should Be True    "${panel_status}" == "${expected_panel_status}"    ${each_panel.upper()} panel should be ${expected_panel_status}
    [Teardown]    Take Screenshot

Verify Pencil Icon Is Disabled
    ${pencil_icon}    Determine Multiple Object Name Based On Active Tab    cmdEditFormOfPayment
    Verify Control Object Is Disabled    ${pencil_icon}

Verify Populated Fields on Amend Booking on Air Fare Panel
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Routing Field Value    ${routing_value_${fare_tab_index}}
    Verify Field Is Not Mandatory    ctxtChargedFare
    Verify Realised Savings Code Default Value    ${realised_saving_code_value_${fare_tab_index}}
    ${high_fare_amend}    Run Keyword    Get Value on Specific Field    ctxtHighFare
    ${low_fare_amend}    Run Keyword    Get Value on Specific Field    ctxtLowFare
    ${turnaround_amend}    Run Keyword    Get Value on Specific Field    ccboPOT
    ${missed_code_amend}    Run Keyword    Get Value on Specific Field    ccboMissed
    ${class_code_amend}    Run Keyword    Get Value on Specific Field    ccboClass
    ${transaction_fee_amend}    Run Keyword    Get Value on Specific Field    cbTransactionFee
    Run Keyword If    "${high_fare_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    ctxtHighFare
    ...    ELSE    Verify Mandatory Field    ctxtHighFare
    Run Keyword If    "${low_fare_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    ctxtLowFare
    ...    ELSE    Verify Mandatory Field    ctxtLowFare
    Run Keyword If    "${turnaround_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    ccboPOT
    ...    ELSE    Verify Mandatory Field    ccboPOT
    Run Keyword If    "${missed_code_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    ccboMissed
    ...    ELSE    Verify Mandatory Field    ccboMissed
    Run Keyword If    "${class_code_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    ccboClass
    ...    ELSE    Verify Mandatory Field    ccboClass
    Run Keyword If    "${transaction_fee_amend}" != "${EMPTY}"    Verify Field Is Not Mandatory    cbTransactionFee
    ...    ELSE    Verify Mandatory Field    cbTransactionFee

Verify Pre-Selected Option On Restrictions Tab
    [Arguments]    ${restrictions_option}=None
    ${template_radio}    Determine Multiple Object Name Based On Active Tab    cradTemplate_alt, cradTemplate
    ${no_restriction_radio}    Determine Multiple Object Name Based On Active Tab    cradNone_alt, cradNone
    ${is_selected_template}    Get Radio Button Status    ${template_radio}
    ${is_selected_default}    Get Radio Button Status    [NAME:cradDefault_]
    ${is_selected_no_restrictions}    Get Radio Button Status    ${no_restriction_radio}
    ${is_selected_option}    Set Variable If    ${is_selected_template} == True or ${is_selected_default} == True or ${is_selected_no_restrictions} == True    True    False
    Comment    Run Keyword If    '${restrictions_option}' == 'None' and ${is_selected_option} == False    Log    There is no option selected on the restrictions tab.
    ...    ELSE IF    ('${restrictions_option}' == 'Template' and ${is_selected_template} == False) or ('${restrictions_option}' == 'Default' and ${is_selected_default} == False) or ('${restrictions_option}' == 'No Restrictions' and ${is_selected_no_restrictions} == False) or ('${restrictions_option}' == 'None' and ${is_selected_option} == True)    Run Keyword And Continue On Failure    FAIL    '${restrictions_option}' was not defaulted/selected option on the restrictions tab.
    ...    ELSE    Log    '${restrictions_option}' was defaulted/selected on the restrictions tab.
    Run Keyword If    ('${restrictions_option}' == 'Template' and ${is_selected_template} == False) or ('${restrictions_option}' == 'Default' and ${is_selected_default} == False) or ('${restrictions_option}' == 'No Restrictions' and ${is_selected_no_restrictions} == False) or ('${restrictions_option}' == 'None' and ${is_selected_option} == True)    Run Keyword And Continue On Failure    FAIL    '${restrictions_option}' was not defaulted/selected option on the restrictions tab.
    ...    ELSE    Log    '${restrictions_option}' was defaulted/selected on the restrictions tab.
    [Teardown]    Take Screenshot

Verify RF, LF And SF Accounting Remarks Per TST Are Written
    [Arguments]    ${fare_tab}    ${segment_number}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Comment    ${nett_or_base_fare}    Get Variable Value    ${nett_fare_value_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    Comment    ${nett_or_base_fare}    Set Variable If    ${nett_or_base_fare} == 0    ${base_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    ${sf_value}    Run Keyword If    "${mark_up_value_${fare_tab_index}}" == "${EMPTY}"    ${base_fare_${fare_tab_index}}
    ...    ELSE    Evaluate    ${base_fare_${fare_tab_index}} + ${mark_up_value_${fare_tab_index}}
    ${sf_value}    Round Apac    ${sf_value}    ${country}
    Verify Specific Line Is Written In The PNR    RM *RF/${high_fare_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *SF/${sf_value}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *LF/${low_fare_value_${fare_tab_index}}/${segment_number}

Verify RF, SF And LF Are Written In The PNR For Fare Tab
    [Arguments]    ${fare_tab_value}
    Get RF, SF and LF Value For Fare X Tab    ${fare_tab_value}
    Verify Specific Line Is Written In The PNR    FREE TEXT-RF/*${fare_tab_index}/${ref_fare_value}
    Verify Specific Line Is Written In The PNR    FREE TEXT-SF/*${fare_tab_index}/${selling_fare_value}
    Verify Specific Line Is Written In The PNR    FREE TEXT-LF/*${fare_tab_index}/${lowest_fare_value}

Verify RMO CP0 Line Include Amadeus Rail Display Amount
    [Arguments]    ${rail_tst_number}
    Get High, Charged and Low Fare in Fare Tab
    Get Amadeus Rail TST Amount    ${rail_tst_number}
    ${rmo_amount}    Evaluate    ${charge_fare}+${rail_tst_amount}
    Verify Text Contains Expected Value    ${pnr_details}    RMO CP0 COMMENT/${rmo_amount}

Verify Realised Saving Code Dropdown Values Are Correct
    [Arguments]    ${fare_tab}    ${country}=HK
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${hk_realised_code}    Create List    CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED    CR - INTELLIGENT TICKETING    EX - EXCHANGE    LC - LOW COST CARRIER FARE ACCEPTED    MC - MISCELLANEOUS
    ...    RF - RESTRICTED FARE ACCEPTED    SC - SUBSCRIPTION    UC - VALUE ADDED OFFER    WF - CWT NEGOTIATED FARE SAVING ACCEPTED    XX - NO SAVING
    ${sg_realised_code}    Create List    CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED    CR - INTELLIGENT TICKETING    LC - LOW COST CARRIER FARE ACCEPTED    MC - MISCELLANEOUS    RF - RESTRICTED FARE ACCEPTED
    ...    SD - SPECIAL SUPPLIER DISCOUNT    SF - MULTI TRAVELLERS FARE SAVING ACCEPTED    TP - TRAVEL POLICY APPLIANCE    UC - VALUE ADDED OFFER    WF - CWT NEGOTIATED FARE SAVING ACCEPTED    XI - ROUTE DEAL ACCEPTED
    ...    XX - NO SAVING    EX - EXCHANGE
    ${in_realised_code}    Create List    CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED    CR - INTELLIGENT TICKETING    EX - EXCHANGE    LC - LOW COST CARRIER FARE ACCEPTED    MC - MISCELLANEOUS
    ...    RF - RESTRICTED FARE ACCEPTED    SC - SUBSCRIPTION    SD - SPECIAL SUPPLIER DISCOUNT    SF - MULTI TRAVELLERS FARE SAVING ACCEPTED    TP - TRAVEL POLICY APPLIANCE    UC - VALUE ADDED OFFER
    ...    WF - CWT NEGOTIATED FARE SAVING ACCEPTED    XI - ROUTE DEAL ACCEPTED    XX - NO SAVING
    ${country}    Convert To Lowercase    ${country}
    ${expected_realised_saving_code}    Set Variable If    "${country}" == "hk"    ${hk_realised_code}    "${country}" == "sg"    ${sg_realised_code}    "${country}" == "in"
    ...    ${in_realised_code}
    Log List    ${expected_realised_saving_code}
    Get Realised Saving Code Values    ${fare_tab}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${realised_saving_code_values_${fare_tab_index}}    ${expected_realised_saving_code}

Verify Realised Saving Code Field Is Disabled
    ${realised_saving_code_field}    Determine Multiple Object Name Based On Active Tab    pnlRealised
    Verify Control Object Is Disabled    ${realised_saving_code_field}

Verify Realised Saving Code Field Is Enabled
    ${realised_saving_code_field}    Determine Multiple Object Name Based On Active Tab    pnlRealised
    Verify Control Object Is Enabled    ${realised_saving_code_field}

Verify Realised Saving Code Field Is Hidden
    ${index}    Set Variable If    '${fare_tab_index}' != '${EMPTY}'    ${fare_tab_index}    1
    Verify Control Object Is Not Visible    [NAME:pnlRealised _${index}]

Verify Realised Savings Code Default Value
    [Arguments]    ${expected_realized_saving_code_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_realized_saving_code_value}
    [Teardown]    Take Screenshot

Verify Realised Savings Code Is Mandatory And Has No Value
    ${realised_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    Verify Field Is Empty    ${realised_saving_code_dropdown}
    Verify Control Object Background Color    ${realised_saving_code_dropdown}    FFD700

Verify Remarks Line Contains Masked Card
    [Arguments]    ${remarks_line}
    ${full_line_remarks}    Get Lines Using Regexp    ${pnr_details}    ${remarks_line}
    ${status_masked}    Run Keyword And Return Status    Should Contain Any    ${full_line_remarks}    XXXXXXXX    ******
    Set Suite Variable    ${status_masked}

Verify Restriction Field Is Disabled
    [Arguments]    ${restriction}
    Verify Control Object Is Disabled    ${restriction}

Verify Route Code Default Value
    [Arguments]    ${expected_default_value}    ${fare_tab_value}=${EMPTY}
    ${index}    Fetch From Right    ${fare_tab_value}    ${SPACE}
    ${index}    Set Variable If    '${index}' != '${EMPTY}'    ${index}    ${fare_tab_index}
    ${point_of_obj}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Verify Control Object Text Value Is Correct    ${point_of_obj}    ${expected_default_value}
    [Teardown]    Take Screenshot

Verify Route Code Field Is Disabled
    ${route_code_field}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Verify Control Object Is Disabled    ${route_code_field}

Verify Route Code Field Is Enabled
    ${route_code_field}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Verify Control Object Is Enabled    ${route_code_field}

Verify Route Code Field Value
    [Arguments]    ${expected_route_code_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Run Keyword And Continue On Failure    Verify Control Object Text Value Is Correct    ${object_name}    ${expected_route_code_value}

Verify Routing Accounting Remarks Are Written
    [Arguments]    ${fare_tab}    ${segment_number}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Verify Specific Line Is Written In The PNR    RM *FF7/${point_of_${fare_tab_index}}/${segment_number}

Verify Routing Field Is Disabled
    ${routing_field}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting
    Verify Control Object Is Disabled    ${routing_field}

Verify Routing Field Is Enabled
    ${routing_field}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting
    Verify Control Object Is Enabled    ${routing_field}

Verify Routing Field On Air Fare Panel behaves Correctly
    [Arguments]    ${routing_value1}    ${routing_value2}    ${routing_value3}
    #Set Invalid i.e. SIN-MNL-323
    Set Routing International On Air Fare Panel    ${routing_value1}
    ${actual_tooltip}    Get Tooltip From Error Icon    flpRouting
    Verify Actual Value Matches Expected Value    ${actual_tooltip}    Invalid Route
    Verify Panel Status    RED    Air Fare
    #Set Valid Value i.e. MNL-SIN
    Set Routing International On Air Fare Panel    ${routing_value2}
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    flpRouting
    Should Be True    ${is_tooltip_present} == ${False}
    Verify Panel Status    GREEN    Air Fare
    #Set Routing As Blank
    Verify Mandatory Field    cmtxtRouting    True
    Send    {TAB}
    Verify Mandatory Field    ccboPOT
    Verify Panel Status    RED    Air Fare
    #Set Valid Value i.e. MNL-SIN-LAX-JFK
    Set Routing International On Air Fare Panel    ${routing_value3}
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    flpRouting
    Should Be True    ${is_tooltip_present} == ${False}
    Verify Field Is Not Mandatory    cmtxtRouting
    Send    {TAB}
    Verify Mandatory Field    ccboPOT
    Verify Panel Status    RED    Air Fare
    Select Turnaround
    Send    {TAB}
    Verify Field Is Not Mandatory    ccboPOT
    Verify Panel Status    GREEN    Air Fare
    Set Routing International On Air Fare Panel    ${routing_value2}
    Verify Panel Status    GREEN    Air Fare

Verify Routing Field Value
    [Arguments]    ${expected_routing_value}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting
    ${actual_routing_value}    Get Control Text Value    ${object_name}
    ${actual_routing_value}    Replace String    ${actual_routing_value}    -___    ${EMPTY}
    Verify Text Contains Expected Value    ${actual_routing_value}    ${expected_routing_value}
    [Teardown]    Take Screenshot

Verify Routing Itinerary Remarks Are Written
    [Arguments]    ${fare_tab}    ${routing_itin_remark}=${EMPTY}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${city_names_in_one_line}    Get Substring    ${city_names_with_slash_${fare_tab_index}}    0    46
    Set Test Variable    ${city_names_with_slash_${fare_tab_index}}    ${city_names_in_one_line}
    Run Keyword If    "${routing_itin_remark}" != "${EMPTY}"    Verify Specific Line Is Written In The PNR    ${routing_itin_remark}    reg_exp_flag=false    multi_line_search_flag=true    remove_spaces=true
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ROUTING: ${city_names_with_slash_${fare_tab_index}}    reg_exp_flag=true    multi_line_search_flag=true    remove_spaces=false

Verify Sabre Is Logged In CERT
    Activate Sabre Red Workspace
    Sleep    1
    Send    *M{ENTER}
    Sleep    1
    Send    SI{ENTER}
    Sleep    1
    Send    {ALTDOWN}EA{ALTUP}
    Sleep    1
    Send    {ALTDOWN}EC{ALTUP}
    ${content}    Get Data from Clipboard
    ${isCERT}    Run Keyword and Return Status    Should Contain    ${content}    CERT
    ${notSignedOut}    Run Keyword and Return Status    Should Contain    ${content}    NOT SIGNED OUT
    Run Keyword If    "${isCERT}" == "True" and "${notSignedOut}" == "True"    Log    Passed: Sabre is signed in and logged in CERT
    ...    ELSE    FAIL    Failed: Ensure Sabre is signed in and logged in CERT
    Sleep    2

Verify Selected Credit Card Expiration Date
    [Arguments]    ${fare_tab}    ${credit_card}
    Select Form Of Payment Value On Fare Quote Tab    Fare 2    KMBSAMPLE/VI***********2111/D0808
    Verify That Error Icon For Expired Card Is Displayed On Fare Quote Tab    True
    Verify FOP Merchant Field Is Mandatory And Blank On Fare Quote Tab
    Click Mask Icon To Unmask Card On Fare Quote Tab
    Verify FOP Credit Card Is UnMasked On Fare Quote Tab
    Click Clear Form Of Payment Icon On Fare Quote Tab

Verify Semi Flexible Fare Restriction Field Is Disabled
    ${semi_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradSemiFlex_alt, cradSemiFlexOBT_alt, cradSemiFlex, cradSemiFlex_alt, cradSemiFlexOBT
    Verify Control Object Is Disabled    ${semi_flexible_field}
    [Teardown]    Take Screenshot

Verify Semi Flexible Fare Restriction Field Is Enabled
    ${semi_flexible_field}    Determine Multiple Object Name Based On Active Tab    cradSemiFlex_alt, cradSemiFlexOBT_alt, cradSemiFlex, cradSemiFlex_alt, cradSemiFlexOBT
    Verify Control Object Is Enabled    ${semi_flexible_field}

Verify Specific Warning In Air Fare Is Shown
    [Arguments]    ${expected_message}
    Verify Control Object Is Visible    ${lbl_warning_msg}
    ${actual_text} =    Control Get Text    ${title_power_express}    ${EMPTY}    ${lbl_warning_msg}
    Should Be Equal    ${actual_text}    ${expected_message}
    [Teardown]    Take Screenshot

Verify Static Remarks For BSP Fares Are Displayed
    [Arguments]    ${occurence}
    Verify Specific Line Is Written In The PNR X Times    RIR ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE    ${occurence}    True

Verify Static Remarks On LCC Is Not Displayed
    Verify Specific Line Is Not Written In The PNR    RIR ALL PRICES SUBJECT TO CHANGE AT ANYTIME WITHOUT NOTICE    multi_line_search_flag=true

Verify That Accounting Remarks Are Written In The PNR
    [Arguments]    ${fare_tab}    ${x_times}    ${country}=SG
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Remark Is Written X Times In The PNR    X/-SF/*${fare_tab_index}/${fare_${fare_tab_index}_base_fare}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-RF/*${fare_tab_index}/${high_fare_value_${fare_tab_index}}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-LF/*${fare_tab_index}/${low_fare_value_${fare_tab_index}}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-EC/*${fare_tab_index}/${missed_code_value_${fare_tab_index}}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-RC/*${fare_tab_index}/R    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-FF8/*${fare_tab_index}/${class_code_value_${fare_tab_index}}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-FF30/*${fare_tab_index}/${realised_code_value_${fare_tab_index}}    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-FF38/*${fare_tab_index}/E    ${x_times}
    Verify Specific Remark Is Written X Times In The PNR    X/-FF47/*${fare_tab_index}/***    ${x_times}    #static

Verify That Error Icon For Expired Card Is Displayed On Fare Quote Tab
    [Arguments]    ${portrait}=False
    Comment    Run Keyword If    "${portrait}" == "False"    Verify Tooltip Text Is Correct Using Coords    582    591    Credit Card is expired
    ...    ELSE    Verify Tooltip Text Is Correct Using Coords    720    461    Credit Card is expired
    ${actual_tooltip}    Get Tooltip From Error Icon    TableLayoutPanel3
    Should Be Equal As Strings    ${actual_tooltip}    Credit Card is expired

Verify That Warning For Card Expiration Is Displayed On Fare Quote Tab
    [Arguments]    ${portrait}=False
    Comment    Run Keyword If    "${portrait}" == "False"    Verify Tooltip Text Is Correct Using Coords    582    591    Card near expiration
    ...    ELSE    Verify Tooltip Text Is Correct Using Coords    720    461    Card near expiration
    Run Keyword If    "${portrait}" == "False"    Verify Tooltip Text Is Correct Using Coords    582    591    Card near expiration
    ...    ELSE    Verify Tooltip Text Is Correct Using Coords    712    467    Card near expiration

Verify Tickets Are Successfully Issued
    [Arguments]    ${segment_number}
    Enter GDS Command    IG    RT${current_pnr}
    Enter GDS Command    TTP/${segment_number}
    Sleep    4
    ${message}    Get Clipboard Data Amadeus
    Verify Text Contains Expected Value    ${message}    OK ETICKET
    [Teardown]    Take Screenshot

Verify ToolTip Is Not Displayed
    [Arguments]    ${xpos}    ${ypos}
    Mouse Move    0    0
    Activate Power Express Window
    Comment    Set Test Variable    ${actual_tooltip_text}    ${EMPTY}
    ${actual_tooltip_text}    Run Keyword And Ignore Error    Get Tooltip Text    ${xpos}    ${ypos}
    Comment    Run Keyword If    \    "${actual_tooltip_text}" == "${EMPTY}" or "${actual_tooltip_text}" == "Tooltip text is not found"    Log    No Error Message is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Error Icon is displayed with tooltip message: ${actual_tooltip_text}
    Comment    Run Keyword And Continue On Failure    Should Contain    ${actual_tooltip_text}    Tooltip text is not found    Error Icon is displayed with tooltip message: ${actual_tooltip_text}
    Comment    Run Keyword If    "${actual_tooltip_text}" == "None"    Log    No Error Message is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Error Icon is displayed with tooltip message: ${actual_tooltip_text}
    Run Keyword And Continue On Failure    Should Contain    ${actual_tooltip_text}    Tooltip is not visible    Error Icon is displayed with tooltip message: ${actual_tooltip_text}
    [Teardown]    Take Screenshot

Verify Total Alternate Fare
    [Arguments]    ${expected_fare_value}
    Verify Control Object Text Value Is Correct    [NAME:ctxtTotalFareOffer_alt_1]    ${expected_fare_value}
    [Teardown]

Verify Total Amount Field Is Disabled
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Comment    Verify Control Object Is Disabled    [NAME:ctxtTotalAmount_${fare_tab_index}]
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalAmount, ctxtTotalAmount_alt
    ${fare_including_taxes}    Get Control Text Value    ${object_name}
    Verify Control Object Is Disabled    ${object_name}

Verify Total Amount Itinerary Remarks Is Written
    [Arguments]    ${fare_tab}    ${start_substring}=4    ${end_substring}=6    ${country}=${EMPTY}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ...    ELSE    Set Variable    ${country}
    ${currency}    Run Keyword If    "${country}" == "SG"    Set Variable    SGD
    ...    ELSE IF    "${country}" == "HK"    Set Variable    HKD
    ...    ELSE    Set Variable    INR
    Verify Specific Line Is Written In The PNR    RIR TOTAL AMOUNT: ${currency} ${total_amount_${fare_tab_index}}

Verify Total Amount Value Is Correct Based On Computed Value
    [Arguments]    ${fare_tab}    ${start_substring}=4    ${end_substring}=6
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    Verify Total Amount Field Is Disabled    ${fare_tab}
    ${fuel_surcharge_value}    Get Variable Value    ${fuel_surcharge_value_${fare_tab_index}}    0
    Run Keyword If    "${country}" == "IN"    Calculate GST Total Amount    ${fare_tab}
    Run Keyword If    "${country}" == "IN"    Get Merchant Fee For Transaction Fee Value    ${fare_tab}
    ${gst_tax}    Get Variable Value    ${computed_total_gst_amount_${fare_tab_index}}    0
    ${merchant_fee_on_transaction_fee}    Get Variable Value    ${mf_for_tf_amount_${fare_tab_index}}    0
    ${merchant_fee_value}    Get Variable Value    ${merchant_fee_value_${fare_tab_index}}    0
    Log    Values are: FIT: ${fare_including_taxes_${fare_tab_index}}, TF: ${transaction_fee_value_${fare_tab_index}}, MF: ${merchant_fee_value} and FS: ${fuel_surcharge_value}, GST: ${gst_tax}
    ${total_amount}    Evaluate    ${fare_including_taxes_${fare_tab_index}} + ${transaction_fee_value_${fare_tab_index}} + ${merchant_fee_value} + ${fuel_surcharge_value} + ${merchant_fee_on_transaction_fee} + ${gst_tax}
    ${total_amount}    Round Apac    ${total_amount}    ${country}
    Set Suite Variable    ${computed_total_amount_${fare_tab_index}}    ${total_amount}
    Run Keyword If    "${computed_total_amount_${fare_tab_index}}" == "${total_amount_${fare_tab_index}}"    Log    TOTAL amount: ${total_amount_${fare_tab_index}} is correctly displayed.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    TOTAL amount: ${total_amount_${fare_tab_index}} displayed is not equal to the computed amount: ${computed_total_amount_${fare_tab_index}}.

Verify Total Field Is Disabled
    ${total_field}    Determine Multiple Object Name Based On Active Tab    ctxtTotalAmount
    Verify Control Object Is Disabled    ${total_field}

Verify Tour Code Remark Per TST Is Not Written
    [Arguments]    ${identifier}    ${segment}
    Verify Specific Line Is Not Written In The PNR    FT PAX *${identifier}/${segment}    1

Verify Tour Code Remark Per TST Is Written
    [Arguments]    ${identifier}    ${segment}
    Verify Specific Line Is Written In The PNR X Times    FT PAX *${identifier}/${segment}    1

Verify Transaction Fee Field Is Disabled
    ${transaction_fee_field}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    Verify Control Object Is Disabled    ${transaction_fee_field}

Verify Transaction Fee Field Is Enabled
    ${transaction_fee_field}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    Verify Control Object Is Enabled    ${transaction_fee_field}

Verify Transaction Fee Field On Air Fare Panel behaves Correctly
    Set Transaction Fee On Air Fare Panel    xxxx
    ${actual_tooltip}    Get Tooltip From Error Icon    tblMainFees_leftPart
    Verify Actual Value Matches Expected Value    ${actual_tooltip}    Invalid Transaction Fee
    Verify Panel Status    RED    Air Fare
    Set Transaction Fee On Air Fare Panel    10
    ${is_tooltip_present}    Run Keyword And Return Status    Get Tooltip From Error Icon    tblMainFees_leftPart
    Should Be True    ${is_tooltip_present} == ${False}
    Verify Panel Status    GREEN    Air Fare

Verify Transaction Fee For VAT Per TST Are Written
    [Arguments]    ${fare_tab}    ${country}    ${segments_in_tst}    ${segment_number}    ${is_tmp_card}=FALSE
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${vendor_code}    Set Variable If    "${country}" == "IN"    V00800001
    Set Suite Variable    ${vendor_code}
    ${currency}    Set Variable If    "${country}" == "IN"    INR
    Set Suite Variable    ${currency}
    Identify Form Of Payment Code For APAC    ${str_card_type_${fare_tab_index}}
    Verify Specific Line Is Written In The PNR    RM *MS/PC87/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF${segments_in_tst}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${computed_gst_transaction_fee${fare_tab_index}}/SF${computed_gst_transaction_fee${fare_tab_index}}/C0/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}}.upper()}" == "CASH" or "${str_card_type_${fare_tab_index}}.upper()}" == "INVOICE"    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM *MSX/F${credit_card_code}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${computed_gst_transaction_fee${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF VAT/${segment_number}

Verify Transaction Fee Is Selected By Default
    [Arguments]    ${transaction_fee}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee
    Verify Control Object Text Value Is Correct    ${object_name}    ${transaction_fee}
    [Teardown]    Take Screenshot

Verify Transaction Fee Per TST Are Written
    [Arguments]    ${fare_tab}    ${country}    ${segments_in_tst}    ${ff_number}    ${segment_number}    ${is_tmp_card}=FALSE
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${vendor_code}    Set Variable If    "${country}" == "SG"    V021007    "${country}" == "HK"    V00001    "${country}" == "IN"
    ...    V00800001
    Set Suite Variable    ${vendor_code}
    ${currency}    Set Variable If    "${country}" == "SG"    SGD    "${country}" == "HK"    HKD    "${country}" == "IN"
    ...    INR
    Set Suite Variable    ${currency}
    Identify Form Of Payment Code For APAC    ${str_card_type_${fare_tab_index}}
    ${tmp_card}    Get Substring    ${str_card_number_${fare_tab_index}}    \    6
    ${ctcl_card}    Get Substring    ${str_card_number_${fare_tab_index}}    \    8
    Run Keyword If    ("${tmp_card}" == "364403" and "${str_card_type_${fare_tab_index}}" == "DC") or ("${ctcl_card}" == "44848860" and "${str_card_type_${fare_tab_index}}" == "VI")    Set Test Variable    ${is_tmp_card}    True
    Verify Specific Line Is Written In The PNR    RM *MS/PC35/${vendor_code}/AC${lfcc_in_tst_${fare_tab_index}}/TKFF${ff_number}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${transaction_fee_value_${fare_tab_index}}/SF${transaction_fee_value_${fare_tab_index}}/C${transaction_fee_value_${fare_tab_index}}/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${str_card_type_${fare_tab_index}}.upper()}" == "CASH" or "${str_card_type_${fare_tab_index}}.upper()}" == "INVOICE" or "${is_tmp_card.upper()}" == "TRUE"    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RM *MSX/F${credit_card_code${fare_tab_index}}/CCN${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date_${fare_tab_index}}/D${transaction_fee_value_${fare_tab_index}}/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF TRANSACTION FEE/${segment_number}
    Verify Specific Line Is Not Written In The PNR    RIR TRANSACTION FEE: ${CURRENCY} ${transaction_fee_value_${fare_tab_index}}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM*MSX/FF99-18P${computed_gst_transaction_fee}*0P0*0P0/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM*MSX/FF99-18P${computed_gst_transaction_fee}*0P0*0P0/${segment_number}

Verify Transaction Fee Per TST Not Written
    [Arguments]    ${fare_tab}    ${segments_in_tst}    ${fop}
    ${fop}    Convert To Lowercase    ${fop}
    ${line1}    Set Variable    RM \\*MS/PC35.+?/${segments_in_tst}
    ${line2}    Set Variable    RM \\*MSX/S.+?/${segments_in_tst}
    ${line3}    Set Variable If    '${fop}' == 'Cash' or '${fop}' == 'Invoice'    RM \\*MSX/FS/${segments_in_tst}    RM \\*MSX/FCX.+?/${segments_in_tst}
    ${line4}    Set Variable    RM \\*MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segments_in_tst}
    ${line5}    Set Variable    RM \\*MSX/FF99.*/${segments_in_tst}
    ${line6}    Set Variable    RM \\*MSX/FF TRANSACTION FEE/${segments_in_tst}
    ${expected_remark_group}    Set Variable    ${line1}${line2}${line3}${line4}${line5}${line6}
    Verify Specific Line Is Not Written In The PNR    ${expected_remark_group}    True    True    \    True

Verify Transaction Fee Remark Per TST Are Correct
    [Arguments]    ${fare_tab}    ${segment_number}    ${segments_in_tst}    ${fop}    ${country}    ${is_obt}=False
    [Documentation]    This Keyword will verify remarks of Transaction Fee and GST on Transaction Fee.
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${transaction_fee_value}    Set Variable If    "${transaction_fee_value_${fare_tab_index}}" == "${EMPTY}"    0    ${transaction_fee_value_${fare_tab_index}}
    ${is_transaction_fee_applicable}    Evaluate    ${transaction_fee_value} > ${0}
    ${transaction_fee_value}    Round APAC    ${transaction_fee_value}    ${country}
    &{vendor_code_merchant_dict}    Create Dictionary    SG=V021007    HK=V00001    IN=V00800001
    ${vendor_code}    Get From Dictionary    ${vendor_code_merchant_dict}    ${country}
    ${currency}    Get Currency    ${country}
    ${is_credit_card}    Run Keyword And Return Status    Should Not Contain Any    ${fop}    Cash    Invoice
    ${is_cc_tmp_card_or_ctlc}    Run Keyword And Return Status    Should Contain Any    ${fop}    DC364403    VI44848860    CTLC
    ${is_normal_cc}    Set Variable If    "${country}" != "SG" and ${is_credit_card}    ${True}    "${country}" == "SG" and ${is_credit_card} and not ${is_cc_tmp_card_or_ctlc}    ${True}    ${False}
    ${cc_vendor}    Run Keyword If    ${is_credit_card}    Get CC Vendor From Credit Card    ${fop}
    ${masked_credit_card_number}    ${credit_card_expiry_date}    Run Keyword If    ${is_credit_card}    Get Masked Credit Card And Expiry Date    ${fop}
    Run Keyword If    "${country}" == "IN"    Calculate GST On Transaction Fee    ${fare_tab}    ${country}
    Run Keyword If    ${is_transaction_fee_applicable}    Verify Specific Line Is Written In The PNR    RM \\*MS/PC35/${vendor_code}/TK/PX1/${segment_number}    true
    ...    ELSE IF    not ${is_transaction_fee_applicable} and "${country}" != "IN"    Verify Specific Line Is Not Written In The PNR    RM \\*MS/PC35/${vendor_code}/AC\\d{3}/TK/PX1/${segment_number}    true
    Run Keyword If    ${is_transaction_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/S${transaction_fee_value}/SF${transaction_fee_value}/C${transaction_fee_value}/SG${segments_in_tst}/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${transaction_fee_value}/SF${transaction_fee_value}/C${transaction_fee_value}/SG${segments_in_tst}/${segment_number}    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable} and ${is_obt} == False    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable} and ${is_normal_cc}    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D${transaction_fee_value}/${segment_number}    reg_exp_flag=true
    ...    ELSE IF    ${is_transaction_fee_applicable} and not ${is_normal_cc}    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/FF TRANSACTION FEE/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF TRANSACTION FEE/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable} and "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM *MSX/FF99-18P${computed_gst_transaction_fee${fare_tab_index}}*0P0*0P0/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable}    Verify Specific Line Is Not Written In The PNR    RIR TRANSACTION FEE: ${currency} ${transaction_fee_value}
    #GST on Transaction Fee verification
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM \\*MS/PC87/V00800011/AC\\d{3}/TK/PX1/${segment_number}    true
    Comment    Run Keyword If    "${route_code_${fare_tab_index}}" == "DOM"    Verify Specific Line Is Written In The PNR    RM *MSX/S${gst_airfare_value_service_${fare_tab_index}}/SF${gst_airfare_value_service_${fare_tab_index}}/C0/SG${segments_in_tst}/S${segment_number}
    Run Keyword If    "${country}" == "IN" and ${is_transaction_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/S${computed_gst_transaction_fee${fare_tab_index}}/SF${computed_gst_transaction_fee${fare_tab_index}}/C0/SG${segments_in_tst}/${segment_number}
    Run Keyword If    "${country}" == "IN"    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-G/FF47-CWT/${segment_number}
    Run Keyword If    ${is_transaction_fee_applicable} and ${is_normal_cc}    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN.*EXP${credit_card_expiry_date}/D${transaction_fee_value}/${segment_number}    reg_exp_flag=true
    ...    ELSE IF    ${is_transaction_fee_applicable} and not ${is_normal_cc}    Verify Specific Line Is Written In The PNR    RM *MSX/FS/${segment_number}
    Run Keyword If    "${country}" == "IN" and ${is_transaction_fee_applicable}    Verify Specific Line Is Written In The PNR    RM *MSX/FF VAT/${segment_number}

Verify Transaction Fee Remarks Are Written In The PNR
    [Arguments]    ${fare_tab}    ${transaction_type}    ${validating_carrier}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${card_code}    Identify Form Of Payment Code    ${str_card_type}    SG
    ${ff34}    Set Variable If    "${transaction_type.upper()}" == "ONLINE"    AA    AB
    ${ff35}    Set Variable If    "${transaction_type.upper()}" == "ONLINE"    AMI    SAB
    ${ff36}    Set Variable If    "${transaction_type.upper()}" == "ONLINE"    S    G
    Verify Specific Line Is Written In The PNR    X/-MS/*${fare_tab_index}/PC35/V021007/AC${validating_carrier}/TK/PX1
    Verify Specific Line Is Written In The PNR    X/-MSX/*${fare_tab_index}/C${transaction_fee_value_${fare_tab_index}}/A${transaction_fee_value_${fare_tab_index}}/SF${transaction_fee_value_${fare_tab_index}}/TK
    Verify Specific Line Is Written In The PNR    X/-MSX/*${fare_tab_index}/FF34-${ff34}/FF35-${ff35}/FF36-${ff36}/FF47-***
    Verify Specific Line Is Written In The PNR    X/-MSX/*${fare_tab_index}/F${card_code}/CCN${str_card_type}${str_card_number}EXP${str_exp_date}/D${transaction_fee_value_${fare_tab_index}}
    Verify Specific Line Is Written In The PNR    X/-MSX/*${fare_tab_index}/FF TRANSACTION FEE

Verify Transaction Fee Value And Description Are Correct
    [Arguments]    ${fare_tab}    ${expected_trans_fee_with_description}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee, cbTransactionFee_alt
    ${actual_transaction_fee_amount}    Get Control Text Value    ${object_name}
    Verify Actual Value Matches Expected Value    ${actual_transaction_fee_amount}    ${expected_trans_fee_with_description}
    Comment    Set Test Variable    ${transaction_fee_value_${fare_tab_index}}    45.00

Verify Transaction Fee Value Is Correct
    [Arguments]    ${fare_tab}    ${country}    ${booking_origination}    ${transaction_fee_type}    ${fee_amount_percent_cap}=Amount    ${rounding_so}=${EMPTY}
    ...    ${query_result}=${EMPTY}
    [Documentation]    ${booking_origination} values: Offline, Online
    ...
    ...    ${transaction_fee_type} values: \ Flat, Range, Destination Assited, Unassisted
    ...
    ...    ${fee_amount_percent_cap} values: Amount, Percentage, Cap
    ...
    ...    ${rounding_so} values: up, down, blank
    ...
    ...    ${query}_result description: Values are fetch from the powerbase depending on the configuration
    ...    e.g. 0.12 {%} or 12.00
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${base_fare}    Set Variable    ${base_fare_${fare_tab_index}}
    ${nett_fare}    Set Variable    ${nett_fare_value_${fare_tab_index}}
    Log    ${query_result}
    Log    ${transaction_fee_type}
    Comment    ${base_or_nett_fare}    Set Variable If    ${nett_fare} > ${0}    ${nett_fare}    ${base_fare}
    ${base_or_nett_fare}    Set Variable    ${base_fare}
    ${transaction_fee_range}    Run Keyword If    "${booking_origination}" == "Offline" and "${transaction_fee_type}" == "Range"    Get Transaction Fee Offline Range Value    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}
    ...    ${rounding_so}    ${query_result}
    ${transaction_fee_flat}    Run Keyword If    "${booking_origination}" == "Offline" and "${transaction_fee_type}" == "Flat"    Get Transaction Fee Offline Flat Value    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}
    ...    ${rounding_so}    ${query_result}
    ${transaction_fee_assist}    Run Keyword If    "${booking_origination}" == "Online" and "${transaction_fee_type}" == "Assisted"    Get Transaction Fee Online Assisted Value    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}
    ...    ${rounding_so}    ${query_result}
    ${transaction_fee_unassisted}    Run Keyword If    "${booking_origination}" == "Online" and "${transaction_fee_type}" == "Unassisted"    Get Transaction Fee Online Unassisted Value    ${country}    ${base_or_nett_fare}    ${fee_amount_percent_cap}
    ...    ${rounding_so}    ${query_result}
    ${expected_transaction_fee_value}    Set Variable If    "${transaction_fee_type}" == "Range"    ${transaction_fee_range}    "${transaction_fee_type}" == "Flat"    ${transaction_fee_flat}    "${transaction_fee_type}" == "Assisted"
    ...    ${transaction_fee_assist}    ${transaction_fee_unassisted}
    Log Many    Transaction Fee Type: ${transaction_fee_type}    Booking origination: ${booking_origination}    Fee Amount/Range/Percent/Cap: ${fee_amount_percent_cap}    Rounding SO: ${rounding_so}
    ${expected_transaction_fee_value}    Run Keyword If    '${country.upper()}' == 'SG'    Round Off    ${expected_transaction_fee_value}
    ...    ELSE    Round To Nearest Dollar    ${expected_transaction_fee_value}    ${country}    ${rounding_so}
    ${expected_transaction_fee_value}    Round Apac    ${expected_transaction_fee_value}    ${country}
    ${actual_transaction_fee_amount}    Get Transaction Fee Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${actual_transaction_fee_amount}    ${expected_transaction_fee_value}
    [Teardown]    Take Screenshot

Verify Transaction Fee Value Is Zero And Field Is Disabled
    [Arguments]    ${fare_tab}    ${country}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${actual_transaction_fee_amount}    Get Transaction Fee Value    ${fare_tab}
    Run Keyword If    "${country}" == "HK" or "${country}" == "IN"    Verify Actual Value Matches Expected Value    ${actual_transaction_fee_amount}    0
    ...    ELSE IF    "${country}" == "SG"    Verify Actual Value Matches Expected Value    ${actual_transaction_fee_amount}    0.00
    Verify Control Object Is Disabled    cbTransactionFee, cbTransactionFee_alt

Verify Transaction Remarks Per TST For Travel Fusion
    [Arguments]    ${fare_tab}    ${vendor_code}    ${airline_number}    ${booking_reference}    ${fop}    ${segment_number_long}
    ...    ${segment_number}
    ${identifier}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${credit_card_number_group}    Get Regexp Matches    ${fop}    (\\D{2})(\\*+\\d{4}|\\d+)\/D(\\d{4})    1    2    3
    ${fop_type}    Set Variable    ${credit_card_number_group[0][0]}
    ${fop_number}    Set Variable    ${credit_card_number_group[0][1]}
    ${fop_expiry_date}    Set Variable    ${credit_card_number_group[0][2]}
    ${cc_vendor}    Get CC Vendor From Credit Card    ${fop}
    Run keyword If    '${transaction_fee_value_${identifier}}' != '0' and '${transaction_fee_value_${identifier}}' != '0.00'    Verify Specific Line Is Written In The PNR    RM *MS/PC35/V${vendor_code}/AC${airline_number}/TK0000${booking_reference}/PX1/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MS/PC35/V${vendor_code}/AC${airline_number}/TK0000${booking_reference}/PX1/${segment_number}
    Run keyword If    '${transaction_fee_value_${identifier}}' != '0' and '${transaction_fee_value_${identifier}}' != '0.00'    Verify Specific Line Is Written In The PNR    RM *MSX/S${transaction_fee_value_${identifier}}/SF${transaction_fee_value_${identifier}}/C${transaction_fee_value_${identifier}}/${segment_number_long}/${segment_number}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/S${transaction_fee_value_${identifier}}/SF${transaction_fee_value_${identifier}}/C${transaction_fee_value_${identifier}}/${segment_number_long}/${segment_number}
    Run keyword If    '${transaction_fee_value_${identifier}}' != '0' and '${transaction_fee_value_${identifier}}' != '0.00'    Verify Specific Line Is Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN${fop_type}.*EXP${fop_expiry_date}/D${transaction_fee_value_${identifier}}/${segment_number}    true
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM \\*MSX/F${cc_vendor}/CCN${fop_type}.*EXP${fop_expiry_date}/D${transaction_fee_value_${identifier}}/${segment_number}    true
    Run keyword If    '${transaction_fee_value_${identifier}}' != '0' and '${transaction_fee_value_${identifier}}' != '0.00'    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-AB/FF35-AMA/FF36-M/FF47-CWT/${segment_number}
    Run keyword If    '${transaction_fee_value_${identifier}}' != '0' and '${transaction_fee_value_${identifier}}' != '0.00'    Verify Specific Line Is Written In The PNR    RM *MSX/FF TRANSACTION FEE/${segment_number}    ${EMPTY}
    ...    ELSE    Verify Specific Line Is Not Written In The PNR    RM *MSX/FF TRANSACTION FEE/${segment_number}

Verify Travel Fusion Remarks Are Written In The Accounting Lines
    [Arguments]    ${fare_tab}    ${vendor_code}    ${airline_number}    ${booking_reference}    ${fop}    ${segment_number_long}
    ...    ${segment_number}    ${tmp_card}=false
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${credit_card_number_group}    Get Regexp Matches    ${fop}    (\\D{2})(\\*+\\d{4}|\\d+)\/D(\\d{4})    1    2    3
    ${fop_type}    Set Variable    ${credit_card_number_group[0][0]}
    ${fop_number}    Set Variable    ${credit_card_number_group[0][1]}
    ${fop_expiry_date}    Set Variable    ${credit_card_number_group[0][2]}
    Verify Specific Line Is Written In The PNR    RM *MS/PC91/V${vendor_code}/AC${airline_number}/TK0000${booking_reference}/PX1/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${lcc_fare_total_${fare_tab_index}}/SF${lcc_fare_total_${fare_tab_index}}/C0/${segment_number_long}/${segment_number}
    ${invoice_format}    Run Keyword If    "${tmp_card.lower()}" == "true"    Set Variable    FS
    ...    ELSE    Set Variable    FCC
    Verify Specific Line Is Written In The PNR    RM *MSX/TX${lcc_taxes_total_${fare_tab_index}}XT/${invoice_format}/R${high_fare_${fare_tab_index}}/L${low_fare_${fare_tab_index}}/${segment_number}
    Run Keyword Unless    "${tmp_card.lower()}" == "true"    Verify Specific Line Is Written In The PNR    RM \\*MSX/CCN${fop_type}.*EXP${fop_expiry_date}/D${lcc_total_amount_${fare_tab_index}}/${segment_number}    true
    Verify Specific Line Is Written In The PNR    RM *MSX/E${missed_code_value_${fare_tab_index}}/FF7-${point_of_${fare_tab_index}}/FF8-${class_code_value_${fare_tab_index}}/FF81-${lfcc_value_${fare_tab_index}}/FF38-E/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF30-${realised_code_value_${fare_tab_index}}/FF31-N/FF34-AB/FF35-AMA/FF36-M/${segment_number}
    Verify Specific Line Is Written In The PNR    RM *MSX/FF LOW COST CARRIER/${segment_number}

Verify Turnaround Field Is Disabled
    ${pot_field}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    Verify Control Object Is Disabled    ${pot_field}

Verify Turnaround Field Is Enabled
    ${pot_field}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    Verify Control Object Is Enabled    ${pot_field}

Verify Turnaround Value Is Correct
    [Arguments]    ${fare_tab}    ${expected_turnaround}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Point Of Turnaround    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${point_of_${fare_tab_index}}    ${expected_turnaround}
    [Teardown]    Take Screenshot

Verify ViewTrip Itinerary Remarks Are Not Displayed
    Verify Specific Line Is Not Written In The PNR    ONCE YOUR TICKETS HAVE BEEN ISSUED PLEASE PRINT AN E TICKET    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    ONCE YOUR TICKETS HAVE BEEN ISSUED PLEASE PRINT AN E TICKET    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    RECEIPT VIA THE LINK ON WWW.VIEWTRIP.COM    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    THIS CAN BE USED AS PROOF OF TICKET ISSUE IF REQUESTED    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    USE YOUR FQTV OR CREDIT CARD TO IDENTIFY YOUR BOOKING    multi_line_search_flag=true
    Verify Specific Line Is Not Written In The PNR    TO THE E TKT MACHINE OR C HECK IN AGENT AT THE AIRPORT    multi_line_search_flag=true

Verify Wings Remark Is Not Written
    Verify Specific Line Is Not Written In The PNR    RM *0653*MU

Verify Fare Tab Is Not Visible
    [Arguments]    @{fare_tab_name}
    ${visible_tab}    Get Visible Tab
    : FOR    ${element}    IN    @{fare_tab_name}
    \    List Should Not Contain Value    ${visible_tab}    ${element}
    [Teardown]    Take Screenshot

Verify Fare Tab Is Visible
    [Arguments]    @{fare_tab_name}
    Wait Until Control Object Is Visible    [NAME:TabControl1]
    ${visible_tab}    Get Visible Tab
    : FOR    ${fare_tab}    IN    @{fare_tab_name}
    \    List Should Contain Value    ${visible_tab}    ${fare_tab}    ${fare_tab} should be visible
    [Teardown]    Take Screenshot

Verify Route Code Value Is Correct
    [Arguments]    ${fare_tab}    ${expected_route_code}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Route Code Value    ${fare_tab}
    Verify Text Contains Expected Value    ${route_code_${fare_tab_index}}    ${expected_route_code}

Verify Airline Commission Percentage Value Is Correct
    [Arguments]    ${fare_tab}    ${expected_airline_commission}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Get Airline Commission Percentage Value    ${fare_tab}
    Verify Actual Value Matches Expected Value    ${airline_commission_percentage_${fare_tab_index}}    ${expected_airline_commission}

Verify Value Of Low Fare Match
    [Arguments]    ${identifier1}=${EMPTY}    ${identifier2}=${EMPTY}
    Verify Actual Value Matches Expected Value    ${ui_value_${identifier1}}    ${ui_value_${identifier2}}

Verify SSR GST Remars Are Written Per Airline
    [Arguments]    @{ssr_gst_remarks}
    : FOR    ${ssr_gst_remark}    IN    @{ssr_gst_remarks}
    \    Verify Specific Line Is Written In The PNR X Times    ${ssr_gst_remark}    1    true

Verify Exchange Itinerary Remark
    [Arguments]    ${fare_tab}    ${x_times}=${EMPTY}    ${is_apac}=False
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${total}    Get Variable Value    ${total_amount_with_currency_${fare_tab_index}}    ${grand_total_fare_with_currency_${fare_tab_index}}
    ${verbiage}    Set Variable If    "${locale}" == "fr-FR"    FRAIS DE MODIFICATION TARIFAIRE    "${locale}" == "de-DE"    GESAMTBETRAG DER AUFZAHLUNG    "${locale}" == "en-GB"
    ...    TOTAL ADDITIONAL FARE PAYMENT    "${locale}" == "sv-SE"    PRISSKILLNAD    "${locale}" == "fi-FI"    LISAMAKSU, HINTOJEN VABINEN EROTUS    "${locale}" == "es-ES"
    ...    DIFERENCIA DE TARIFA    "${locale}" == "da-DK"    PRISDIFFERENCE
    ${verbiage}    Set Variable If    ${is_apac}    TOTAL ADDITIONAL FARE COLLECTION    ${verbiage}
    Run Keyword If    "${x_times}" == "${EMPTY}"    Verify Specific Line Is Written In The PNR    RIR ${verbiage}: ${total}
    ...    ELSE    Verify Specific Line Is Written In The PNR X Times    RIR ${verbiage}: ${total}    ${x_times}
