*** Settings ***
Resource          ../../resources/panels/client_info.robot

*** Keywords ***
Identify Form Of Payment Code For APAC
    [Arguments]    ${card_type}
    ${credit_card_code}    Run Keyword If    "${card_type}" == "AX"    Set Variable    CX2
    ...    ELSE IF    "${card_type}" == "DC"    Set Variable    CX3
    ...    ELSE IF    "${card_type}" == "VI" or "${card_type}" == "CA"    Set Variable    CX4
    ...    ELSE IF    "${card_type}" == "TP"    Set Variable    CX5
    ...    ELSE IF    "${card_type.upper()}" == "CASH" or "${card_type.upper()}" == "INVOICE"    Set Variable    CASH
    ...    ELSE    Set Variable    INVALIDTYPE
    Set Suite Variable    ${credit_card_code}
    [Return]    ${credit_card_code}

Select Merchant Fee Type
    [Arguments]    ${fop_merchant_fee_type}
    Wait Until Control Object Is Visible    [NAME:FopMerchantComboBox]    ${title_power_express}
    Select Value From Dropdown List    [NAME:FopMerchantComboBox]    ${fop_merchant_fee_type}
    Set Suite Variable    ${fop_merchant_fee_type}

Verify FOP And FP Line Is Written Per TST
    [Arguments]    ${fare_tab}    ${segment_number}    ${airline_commission_or_rebate}=Airline Commission    ${tmp_card}=False    ${is_decimal_applicable}=true
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Comment    Set Test Variable    ${is_tmp_card}    false
    ${fop_merchant_type}    Get Variable Value    ${fop_merchant_fee_type_${fare_tab_index}}    None
    ${mark_up_value}    Get Variable Value    ${mark_up_value_${fare_tab_index}}    0
    ${ob_fee}    Get Variable Value    ${ob_fee_${fare_tab_index}}    0
    ${credit_card_code}    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" == "INVOICE"    Set Variable    INVOICE
    ...    ELSE    Identify Form Of Payment Code For APAC    ${str_card_type_${fare_tab_index}}
    Run Keyword If    "${nett_fare_value_${fare_tab_index}}" == "0" or "${nett_fare_value_${fare_tab_index}}" == "0.00"    Set Test Variable    ${base_or_nett_fare_${fare_tab_index}}    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Test Variable    ${base_or_nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    ${tmp_card}    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Get Substring    ${str_card_number_${fare_tab_index}}    \    6
    ${ctcl_card}    Run Keyword If    "${str_card_type_${fare_tab_index}.upper()}" != "CASH" and "${str_card_type_${fare_tab_index}.upper()}" != "INVOICE"    Get Substring    ${str_card_number_${fare_tab_index}}    \    8
    Run Keyword If    ("${tmp_card}" == "364403" and "${str_card_type_${fare_tab_index}}" == "DC") or ("${ctcl_card}" == "44848860" and "${str_card_type_${fare_tab_index}}" == "VI")    Set Test Variable    ${is_tmp_card}    True
    ${is_tmp_card}    Set Variable If    ("${tmp_card}" == "364403" and "${str_card_type_${fare_tab_index}}" == "DC" and "${country}" == "SG") or ("${ctcl_card}" == "44848860" and "${str_card_type_${fare_tab_index}}" == "VI" and "${country}" == "SG")    True    False
    Comment    ${fop_amount}    Run Keyword If    "${airline_commission_or_rebate.upper()}" == "CLIENT REBATE"    EVALUATE    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value}) - ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE IF    "${airline_commission_or_rebate.upper()}" == "AIRLINE COMMISSION"    EVALUATE    ${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${mark_up_value}
    Comment    ${fop_amount}    Run Keyword If    "${airline_commission_or_rebate.upper()}" == "CLIENT REBATE"    EVALUATE    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee} + ${mark_up_value}) - ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE IF    "${airline_commission_or_rebate.upper()}" == "AIRLINE COMMISSION"    EVALUATE    ${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee} + ${mark_up_value}
    ${fop_amount}    Run Keyword If    "${airline_commission_or_rebate.upper()}" == "CLIENT REBATE" and "${country}" != "IN"    EVALUATE    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee} + ${mark_up_value}) - ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE IF    ("${airline_commission_or_rebate.upper()}" == "AIRLINE COMMISSION") or ("${airline_commission_or_rebate.upper()}" == "CLIENT REBATE" and "${country}" == "IN")    EVALUATE    ${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee} + ${mark_up_value}
    Comment    ${fop_amount}    Run Keyword If    "${country}" != "IN"    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee} + ${mark_up_value}) - ${commission_rebate_value_${fare_tab_index}}
    ...    ELSE    Evaluate    (${base_or_nett_fare_${fare_tab_index}} + ${total_tax_${fare_tab_index}} + ${ob_fee}
    Comment    ${fop_amount}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${fop_amount}    2
    ...    ELSE    Convert To Float    ${fop_amount}    0
    ${fop_amount}    Round Apac    ${fop_amount}    ${country}
    Run Keyword If    "${credit_card_code.upper()}" != "CASH" or "${credit_card_code.upper()}" != "INVOICE"    Verify Remarks Line Contains Masked Card    EXP${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    Run Keyword If    "${credit_card_code.upper()}" == "CASH" or "${credit_card_code.upper()}" == "INVOICE" or ("${is_tmp_card}" == "True")    Verify Specific Line Is Written In The PNR    RM *FOP/CASH/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "Airline" and "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    RM *FOP/CC/${str_card_type${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "CWT" and "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    RM *FOP/${credit_card_code}/${str_card_type_${fare_tab_index}}${str_card_number_${fare_tab_index}}EXP${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "Airline" and "${status_masked}" == "True"    Verify Specific Line Is Written In The PNR    RM *FOP/CC/${str_card_type${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "CWT" and "${status_masked}" == "True"    Verify Specific Line Is Written In The PNR    RM *FOP/${credit_card_code}/${str_card_type_${fare_tab_index}}${str_card_number2_${fare_tab_index}}EXP${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    Run Keyword If    "${credit_card_code.upper()}" == "CASH"    Verify Specific Line Is Written In The PNR    FP PAX CASH/${segment_number}
    ...    ELSE IF    ("${credit_card_code.upper()}" == "INVOICE" or "${fop_merchant_type}" == "CWT") and "${country}" == "SG"    Verify Specific Line Is Written In The PNR    FP PAX MSINVAGT/${segment_number}
    ...    ELSE IF    "${credit_card_code.upper()}" == "INVOICE" or "${fop_merchant_type}" == "CWT"    Verify Specific Line Is Written In The PNR    FP PAX INVAGT/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "Airline" and "${status_masked}" == "False"    Verify Specific Line Is Written In The PNR    FP PAX CC${str_card_type${fare_tab_index}}${str_card_number_${fare_tab_index}}/${str_exp_date${fare_tab_index}}/${fop_amount}/${segment_number}
    ...    ELSE IF    "${fop_merchant_type.upper()}" == "Airline" and "${status_masked}" == "True"    Verify Specific Line Is Written In The PNR    FP PAX CC${str_card_type${fare_tab_index}}${str_card_number2_${fare_tab_index}}/${str_exp_date${fare_tab_index}}/${segment_number}

Verify Merchant Fee Type Is Blank And Mandatory
    Wait Until Control Object Is Visible    [NAME:FopMerchantComboBox]    ${title_power_express}
    Verify Control Object Text Value Is Correct    [NAME:FopMerchantComboBox]    ${EMPTY}
    Verify Control Object Background Color    [NAME:FopMerchantComboBox]    FFD700
    [Teardown]    Take Screenshot

Verify Merchant Fee Type Is Not Visible
    Verify Control Object Is Not Visible    [NAME:MerchantFeeTypeComboBox]
    [Teardown]    Take Screenshot

Verify That FOP Remark Is Written In The RM Lines
    [Arguments]    ${fop_type}    ${str_card_type}=${EMPTY}    ${str_exp_date}=${EMPTY}    ${country}=${EMPTY}
    Run Keyword If    "${fop_type}" == "Cash"    Verify Specific Line Is Written In The PNR    RMK FP CASH
    ...    ELSE IF    '${fop_type}' == 'Invoice' and '${country}' == 'SG'    Verify Specific Line Is Written In The PNR    RMK FP MSINVAGT
    ...    ELSE IF    '${fop_type}' == 'Invoice'    Verify Specific Line Is Written In The PNR    RMK FP INVAGT
    ...    ELSE IF    '${fop_type}' == 'Credit Card'    Verify Specific Line Is Written In The PNR    RMK FP CC${str_card_type}.*/${str_exp_date}    True
    [Teardown]    Take Screenshot

Compute Tax From TST
    [Arguments]    ${fare_tab}    ${is_decimal_applicable}=true
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${tax}    Evaluate    ${grand_total_fare_${fare_tab_index}} - ${base_fare_${fare_tab_index}}
    ${tax}    Run Keyword If    "${is_decimal_applicable.lower()}" == "true"    Convert To Float    ${tax}
    ...    ELSE    Set Variable
    [Return]    ${tax}

Verify Form Of Payment Card Is Masked On Client Info
    Wait Until Control Object Is Visible    ${combo_form_of_payment}
    ${fop_value}    Get Form Of Payment Value
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value}    *
    Run Keyword If    "${status}" == "True"    Log    Actual FOP: ${fop_value} is masked.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual FOP: ${fop_value} is unmasked.

Verify Form Of Payment Card Is UnMasked On Client Info
    ${fop_value}    Get Form Of Payment Value
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value}    *
    Run Keyword If    "${status}" == "False"    Log    Actual FOP: ${fop_value} is unmasked.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Actual FOP: ${fop_value} is masked.

Verify FOP Merchant Field Is Not Visible On Client Info Panel
    Verify Control Object Is Not Visible    [NAME:FopMerchantComboBox]
