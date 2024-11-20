*** Settings ***
Resource          other_services_associated_charges_control.robot
Resource          other_services_charges_control.robot
Resource          other_services_remarks_verification.robot
Resource          other_services_request_info_control.robot
Resource          other_services_mi_control.robot
Resource          ../air_fare/air_fare_verification.robot
Resource          ../../resources/common/global_resources.robot
Resource          ../../resources/common/common_library.robot

*** Keywords ***
Verify Other Services Air Charges Values Are Correct
    [Arguments]    ${identifier}
    Get Other Services Air Charges    ${identifier}
    Verify Other Services Pricing Parameters Values Are Correct    ${identifier}
    Verify Other Services Related Details Values Are Correct    ${identifier}
    Verify Other Services Fare Calculation    ${identifier}
    Verify Other Services Fare Calculated Values    ${identifier}

Verify Other Services Fare Calculated Values
    [Arguments]    ${identifier}    ${base_amount}=890    ${total_iata_com}=27    ${total_returnable_or}=35    ${total_discount}=62    ${total_sell_fare}=890
    ...    ${total_vat_gst}=14    ${total_merchant_fee}=3    ${total_selling_fare}=845    ${total_taxes}=150    ${merchant_fee_tf}=1    ${total_charge}=1146
    #Base Amount
    Verify Actual Value Matches Expected Value    ${base_amount_${identifier}}    ${base_amount}
    #Total IATA Com
    Verify Actual Value Matches Expected Value    ${total_iata_com_${identifier}}    ${total_iata_com}
    #Total Returnable OR
    Verify Actual Value Matches Expected Value    ${total_returnable_or_${identifier}}    ${total_returnable_or}
    #Total Discount
    Verify Actual Value Matches Expected Value    ${total_discount_${identifier}}    ${total_discount}
    #Total Sell Fare
    Verify Actual Value Matches Expected Value    ${total_sell_fare_${identifier}}    ${total_sell_fare}
    #Total VAT/GST
    Verify Actual Value Matches Expected Value    ${total_vat_gst_${identifier}}    ${total_vat_gst}
    #Total Merchant Fee
    Verify Actual Value Matches Expected Value    ${total_merchant_fee_${identifier}}    ${total_merchant_fee}
    #Total Selling Fare
    Verify Actual Value Matches Expected Value    ${total_selling_fare_${identifier}}    ${total_selling_fare}
    #Total Tax(es)
    Verify Actual Value Matches Expected Value    ${total_taxes_${identifier}}    ${total_taxes}
    #Merchant Fee (TF)
    Verify Actual Value Matches Expected Value    ${merchant_fee_tf_${identifier}}    ${merchant_fee_tf}
    #Total Charge
    Verify Actual Value Matches Expected Value    ${total_charge_${identifier}}    ${total_charge}


Verify Other Services Fare Calculation
    [Arguments]    ${identifier}    ${base_fare}=890    ${iata_com}=3    ${airline_or_com_dollar}=4    ${client_discount_percentage}=100    ${yq_tax}=90
    ...    ${returnable_or_percentage}=100    ${oth_tax1}=15    ${oth_tax_code1}=XT    ${oth_tax2}=20    ${oth_tax_code2}=YR    ${oth_tax3}=25
    ...    ${oth_tax_code3}=HK    ${vat_gst}=1.4    ${merchant_fee_ot_percentage_vat}=0.3    ${ot_percentage1}=0.05    ${ot_percentage2}=0.05    ${fee}=150
    ...    ${merchant_fee_ot_percentage_fee}=0.3
    #Base Fare
    Verify Actual Value Matches Expected Value    ${base_fare_${identifier}}    ${base_fare}
    #IATA Com %
    Verify Actual Value Matches Expected Value    ${iata_com_${identifier}}    ${iata_com}
    #Airline OR Com $
    Verify Actual Value Matches Expected Value    ${airline_or_com_dollar_${identifier}}    ${airline_or_com_dollar}
    #Client Discount %
    Verify Actual Value Matches Expected Value    ${client_discount_percentage_${identifier}}    ${client_discount_percentage}
    #YQ Tax
    Verify Actual Value Matches Expected Value    ${yq_tax_${identifier}}    ${yq_tax}
    #Returnable OR%
    Verify Actual Value Matches Expected Value    ${returnable_or_percentage_${identifier}}    ${returnable_or_percentage}
    #Oth Tax(es) 1
    Verify Actual Value Matches Expected Value    ${oth_tax1_${identifier}}    ${oth_tax1}
    Verify Actual Value Matches Expected Value    ${oth_tax_code1_${identifier}}    ${oth_tax_code1}
    #Oth Tax(es) 2
    Verify Actual Value Matches Expected Value    ${oth_tax2_${identifier}}    ${oth_tax2}
    Verify Actual Value Matches Expected Value    ${oth_tax_code2_${identifier}}    ${oth_tax_code2}
    #Oth Tax(es) 3
    Verify Actual Value Matches Expected Value    ${oth_tax3_${identifier}}    ${oth_tax3}
    Verify Actual Value Matches Expected Value    ${oth_tax_code3_${identifier}}    ${oth_tax_code3}
    #VAT/GST %
    Verify Actual Value Matches Expected Value    ${vat_gst_${identifier}}    ${vat_gst}
    #Merchant Fee %
    Verify Actual Value Matches Expected Value    ${merchant_fee_ot_percentage_vat_${identifier}}    ${merchant_fee_ot_percentage_vat}
    #OT1 %
    Verify Actual Value Matches Expected Value    ${ot1_percentage_${identifier}}    ${ot_percentage1}
    #OT2 %
    Verify Actual Value Matches Expected Value    ${ot2_percentage_${identifier}}    ${ot_percentage2}
    #Fee
    Verify Actual Value Matches Expected Value    ${fee_${identifier}}    ${fee}
    #Merchant Fee %
    Verify Actual Value Matches Expected Value    ${merchant_fee_ot_percentage_fee_${identifier}}    ${merchant_fee_ot_percentage_fee}

Verify Other Services Pricing Parameters Values Are Correct
    [Arguments]    ${identifier}    ${pricing}=Transaction Fee    ${trip_type}=International    ${final_destination}=DEL    ${fop}=PORTRAIT-A/AX***********0002/D1235-TEST-AX
    #Pricing
    Verify Actual Value Matches Expected Value    ${pricing_${identifier}}    ${pricing}
    #Trip Type
    Verify Actual Value Matches Expected Value    ${trip_type_${identifier}}    ${trip_type}
    #Final Destination
    Verify Actual Value Matches Expected Value    ${final_destination_${identifier}}    ${final_destination}
    #FOP
    Verify Actual Value Matches Expected Value    ${fop_${identifier}}    ${fop}

Verify Other Services Related Details Values Are Correct
    [Arguments]    ${identifier}    ${cwtrno1}=123    ${cwtrno2}=4567890123    ${cwtrno3}=12    ${charges_vendor_ref_no}=${EMPTY}    ${other_related_no}=ABC
    ...    ${issue_in_exchange_for}=1122334455
    #CWT Reference No (TK) 3-digit Airline Code
    Run Keyword If    "${product}"=="air bsp" or "${product}"=="air domestic"    Verify Actual Value Matches Expected Value    ${cwtrno1_${identifier}}    ${cwtrno1}
    #CWT Reference No (TK) 10-digit Ticket Number
    Run Keyword If    "${product}"=="air bsp" or "${product}"=="air domestic"    Verify Actual Value Matches Expected Value    ${cwtrno2_${identifier}}    ${cwtrno2}
    #CWT Reference No (TK) 2-digit Conjunction Number
    Run Keyword If    "${product}"=="air bsp" or "${product}"=="air domestic"    Verify Actual Value Matches Expected Value    ${cwtrno3_${identifier}}    ${cwtrno3}
    #Vendor Reference No (GSA)
    Run Keyword If    "${product}" != "air bsp" and "${product}" != "air domestic"    Verify Actual Value Matches Expected Value    ${charges_vendor_ref_no_${identifier}}    ${charges_vendor_ref_no}
    #Other Related No (PO)
    Verify Actual Value Matches Expected Value    ${other_related_no_${identifier}}    ${other_related_no}
    #Issue in Exchange For
    Run Keyword If    "${product}"=="air bsp" or "${product}"=="air domestic"    Verify Actual Value Matches Expected Value    ${issue_in_exchange_for_${identifier}}    ${issue_in_exchange_for}

Verify Merchant Fee Is Correct
    [Arguments]    ${expected_merchant_fee_percentage}
    ${actual_merchant_fee_percentage}    Get Control Text Value    [NAME:Charges_MerchantFee1TextBox]
    Verify Actual Value Matches Expected Value    ${expected_merchant_fee_percentage}    ${actual_merchant_fee_percentage}

Verify Uatp Value Is Correct
    [Arguments]    ${expected_uatp}
    ${actual_uatp}    Get Control Text Value    [NAME:Charges_UatpComboBox]
    Verify Actual Value Matches Expected Value    ${expected_uatp}    ${actual_uatp}
    [Teardown]
