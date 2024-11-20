*** Settings ***
Resource          ../../resources/common/global_resources.robot
Resource          other_services.robot

*** Keywords ***
Populate Other Services Pricing Paramerters Details
    [Arguments]    ${trip_type}=International    ${final_destination}=${EMPTY}
    Select Trip Type    ${trip_type}
    Run Keyword If    "${final_destination}" != "${EMPTY}"    Select Final Destination    ${final_destination}
    [Teardown]    Take Screenshot

Populate Other Services Related Details
    [Arguments]    ${cwt_ref_no1}=123    ${cwt_ref_no2}=4567890123    ${cwt_ref_no3}=12    ${issue_in_exchange_for}=1122334455    ${other_related_po_no}=ABC    ${vendor_ref_no_gsa}=123GSA
    ${product}    Convert To Lower Case    ${product}
    Run Keyword if    "${product}"=="air bsp" or "${product}"=="air domestic"    Set CWT Reference No    ${cwt_ref_no1}
    Run Keyword if    "${product}"=="air bsp" or "${product}"=="air domestic"    Set CWT Reference No    ${cwt_ref_no2}    2
    Run Keyword if    "${product}"=="air bsp" or "${product}"=="air domestic"    Set CWT Reference No    ${cwt_ref_no3}    3
    Run Keyword if    "${product}"=="air bsp" or "${product}"=="air domestic"    Populate Issue In Exchange For    ${issue_in_exchange_for}
    Set Other Related No (PO)    ${other_related_po_no}
    Run Keyword if    "${product}"=="air conso-dom" or "${product}"=="air sales-non bsp int"    Set Vendor Reference No (GSA)    ${vendor_ref_no_gsa}
    [Teardown]    Take Screenshot

Populate Other Services Fare Calculation
    [Arguments]    ${base_fare}=890    ${iata_com}=3    ${airline_or_com}=4    ${merchant_fee}=.3    ${yq_tax}=90    ${oth_tax1}=15
    ...    ${oth_tax2}=20    ${oth_tax3}=25    ${fee}=150
    Set Base Fare    ${base_fare}
    Set IATA Com Percentage    ${iata_com}
    Set Airline Or Com    ${airline_or_com}
    Set Merchant Fee %    ${merchant_fee}
    Set YQ Tax    ${yq_tax}
    Set Oth Taxes    ${oth_tax1}
    Set Oth Tax Code    XT
    Set Oth Taxes    ${oth_tax2}    2
    Set Oth Tax Code    YR    2
    Set Oth Taxes    ${oth_tax3}    3
    Set Oth Tax Code    HK    3
    Tick Override Status
    Set Fee    ${fee}

Select Final Destination
    [Arguments]    ${destination}
    Wait Until Control Object Is Visible    [NAME:Charges_FinalDestinationComboBox]
    Select Value From Dropdown List    [NAME:Charges_FinalDestinationComboBox]    ${destination}

Select Trip Type
    [Arguments]    ${trip_type}
    Wait Until Control Object Is Visible    [NAME:Charges_TripTypeComboBox]
    Select Value From Dropdown List    [NAME:Charges_TripTypeComboBox]    ${trip_type}

Select UATP
    [Arguments]    ${uatp}
    Wait Until Control Object Is Visible    [NAME:Charges_UatpComboBox]
    Select Value From Dropdown List    [NAME:Charges_UatpComboBox]    ${uatp}

Set Airline Or Com
    [Arguments]    ${airline_or_com_dollar}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_AirLineOrComTextBox    False
    Set Control Text Value    ${object}    ${airline_or_com_dollar}

Set Base Fare
    [Arguments]    ${base_fare}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_BaseFareTextBox    False
    Set Control Text Value    ${object}    ${base_fare}

Set CWT Reference No
    [Arguments]    ${cwt_reference_no}    ${index}=1
    Wait Until Control Object Is Visible    [NAME:Charges_CwtRefNo${index}TextBox]
    Set Control Text Value    [NAME:Charges_CwtRefNo${index}TextBox]    ${cwt_reference_no}

Get CWT Reference No (TK)
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_CWTReferenceNoTextBox,AssociatedCharges_CWTReferenceNoTextBox    False
    ${cwt_reference_no}    Get Control Text Value    ${object}
    Set Suite Variable    ${cwt_reference_no_${identifier}}    ${cwt_reference_no}

Get Cost Amount
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_NetCostTextBox,AssociatedCharges_NetCostTextBox    False
    ${cost_amount}    Get Control Text Value    ${object}
    Set Suite Variable    ${cost_amount_${identifier}}    ${cost_amount}

Get Description
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    AssociatedCharges_DescriptionTextBox,Charges_DescriptionTextBox    False
    ${description}    Get Control Text Value    ${object}
    Set Suite Variable    ${description_${identifier}}    ${description}

Get Discount
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiscountTextBox,AssociatedCharges_DiscountTextBox,DiscountTextBox    False
    ${discount}    Get Control Text Value    ${object}
    Set Suite Variable    ${discount_${identifier}}    ${discount}

Get Merchant Fee
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_MerchantFeeTextBox,AssociatedCharges_MerchantFeeTextBox    False
    ${merchant_fee}    Get Control Text Value    ${object}
    Set Suite Variable    ${merchant_fee_${identifier}}    ${merchant_fee}

Get Other Services Charges Tab Details
    [Arguments]    ${identifier}    ${exclude_cost_details}=False    ${exclude_additional_information}=False    ${exclude_air_charges}=True
    Run Keyword If    ${exclude_cost_details} != True    Get Other Services India Cost Details    ${identifier}
    Run Keyword If    ${exclude_additional_information} != True    Get Other Services India Additional Information Details    ${identifier}
    Run Keyword If    ${exclude_air_charges} != True    Get Other Services Air Charges    ${identifier}

Get Other Services India Additional Information Details
    [Arguments]    ${identifier}
    Get Description    ${identifier}
    Get CWT Reference No (TK)    ${identifier}
    Get Related No (PO)    ${identifier}
    Get Vendor Reference No (GSA)    ${identifier}
    [Teardown]    Take Screenshot

Get Other Services India Cost Details
    [Arguments]    ${identifier}
    Get Cost Amount    ${identifier}
    Get Commission    ${identifier}
    Get Discount    ${identifier}
    Get Merchant Fee    ${identifier}
    Get VAT/GST Amount    ${identifier}
    Get Gross Sell    ${identifier}
    Get Total Selling Price    ${identifier}
    [Teardown]    Take Screenshot

Get Related No (PO)
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OtherRelatedNoTextBox,AssociatedCharges_OtherRelatedNoTextBox,Charges_OtherRelatedNoPoTextBox    False
    ${other_related_no}    Get Control Text Value    ${object}
    Set Suite Variable    ${other_related_no_${identifier}}    ${other_related_no}

Get VAT/GST Amount
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    GSTTextBox,Charges_GSTTextBox,AssociatedCharges_GSTTextBox    False
    ${vat_gst_amount}    Get Control Text Value    ${object}
    Set Suite Variable    ${vat_gst_amount_${identifier}}    ${vat_gst_amount}

Get Vendor Reference No (GSA)
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_VendorReferenceNoTextBox,AssociatedCharges_VendorReferenceNoTextBox,Charges_VendorRefNoGsaTextBox    False
    ${vendor_ref_no}    Get Control Text Value    ${object}
    Set Suite Variable    ${vendor_ref_no_${identifier}}    ${vendor_ref_no}

Set Commission
    [Arguments]    ${commission}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_CommisionTextBox,AssociatedCharges_CommisionTextBox    False
    Set Control Text Value    ${object}    ${commission}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Cost Amount
    [Arguments]    ${cost_amount}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_NetCostTextBox,AssociatedCharges_NetCostTextBox    False
    Set Control Text Value    ${object}    ${cost_amount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Discount
    [Arguments]    ${discount}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiscountTextBox,AssociatedCharges_DiscountTextBox    False
    Set Control Text Value    ${object}    ${discount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Vendor Reference No (GSA)
    [Arguments]    ${vendor_reference}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_VendorReferenceNoTextBox,AssociatedCharges_VendorReferenceNoTextBox,Charges_VendorRefNoGsaTextBox    False
    Set Control Text Value    ${object}    ${vendor_reference}

Set Other Related No (PO)
    [Arguments]    ${other_related_po_no}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OtherRelatedNoTextBox,AssociatedCharges_OtherRelatedNoTextBox,Charges_OtherRelatedNoPoTextBox    False
    Set Control Text Value    ${object}    ${other_related_po_no}

Get Other Services Air Charges
    [Arguments]    ${identifier}
    Get Other Services Pricing Parameters Details    ${identifier}
    Get Other Services Related Details    ${identifier}
    Get Other Services Fare Calculation    ${identifier}
    Get Other Services Fare Calculated Values    ${identifier}

Get Client Discount Percentage
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ClientDiscountTextBox    FALSE
    ${client_discount_percentage}    Get Control Text Value    ${object}
    Set Suite Variable    ${client_discount_percentage_${identifier}}    ${client_discount_percentage}

Get FOP
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_FormOfPaymentComboBox    False
    ${fop}    Get Control Text Value    ${object}
    Set Suite Variable    ${fop_${identifier}}    ${fop}

Get Fee
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_FeeTextBox    False
    ${fee}    Get Control Text Value    ${object}
    Set Suite Variable    ${fee_${identifier}}    ${fee}

Get Final Destination
    [Arguments]    ${identifier}
    ${final_destination}    Get Control Text Value    [NAME:Charges_FinalDestinationComboBox]
    Set Suite Variable    ${final_destination_${identifier}}    ${final_destination}

Get Final Destination From AirSegments
    [Documentation]    This Keyword Gets the Final Destination of the Air Segment Based up on the Last Air Segment
    Retrieve PNR Details from Amadeus    ${current_pnr}    RTA
    Get Current Segments From The PNR
    ${last_segment}    Get From List    ${segments_list}    -1
    ${final_destination}    Get Substring    ${last_segment}    23    26
    ${final_destination}    Strip String    ${final_destination}
    Set Suite Variable    ${final_destination}

Get IATA Com Percentage
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_IataComTextBox    FALSE
    ${iata_com}    Get Control Text Value    ${object}
    Set Suite Variable    ${iata_com_${identifier}}    ${iata_com}

Get Issue In Exchange For
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_IssueInExchangeForTextBox    False
    ${issue_in_exchange_for}    Get Control Text Value    ${object}
    Set Suite Variable    ${issue_in_exchange_for_${identifier}}    ${issue_in_exchange_for}

Get Merchant Fee %
    [Arguments]    ${identifier}    ${merchant_type}
    [Documentation]    ${merchant_type} = vat or fee
    ${merchant_fee_ot_percentage}    Run Keyword If    "${merchant_type.lower()}"=="vat"    Get Control Text Value    [NAME:Charges_MerchantFee1TextBox]
    ...    ELSE    Get Control Text Value    [NAME:Charges_MerchantFeeText2Box]
    Set Suite Variable    ${merchant_fee_ot_percentage_${merchant_type}_${identifier}}    ${merchant_fee_ot_percentage}

Get Merchant Fee TF
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_MerchantFeeTfLabel    FALSE
    ${merchant_fee_tf}    Get Control Text Value    ${object}
    Set Suite Variable    ${merchant_fee_tf_${identifier}}    ${merchant_fee_tf}

Get OT Percentage
    [Arguments]    ${identifier}    ${index}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_Ot${index}TextBox    FALSE
    ${ot_percentage}    Get Control Text Value    ${object}
    Set Suite Variable    ${ot${index}_percentage_${identifier}}    ${ot_percentage}

Get Oth Tax Code
    [Arguments]    ${identifier}    ${index}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OthTaxCode${index}TextBox    FALSE
    ${oth_tax_code}    Get Control Text Value    ${object}
    Set Suite Variable    ${oth_tax_code${index}_${identifier}}    ${oth_tax_code}

Get Oth Taxes
    [Arguments]    ${identifier}    ${index}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OthTax${index}TextBox    FALSE
    ${oth_tax}    Get Control Text Value    ${object}
    Set Suite Variable    ${oth_tax${index}_${identifier}}    ${oth_tax}

Get Override Status
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OverrideFeeCheckBox    FALSE
    ${override_status}    Get Checkbox Status    ${object}
    Set Suite Variable    ${override_status_${identifier}}    ${override_status}

Get Pricing
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_PricingComboBox    False
    ${pricing}    Get Control Text Value    ${object}
    Set Suite Variable    ${pricing_${identifier}}    ${pricing}

Get Returnable OR
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ReturnableOrTextBox    FALSE
    ${returnable_or_percentage}    Get Control Text Value    ${object}
    Set Suite Variable    ${returnable_or_percentage_${identifier}}    ${returnable_or_percentage}

Get Status Of Reissued Ticket
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ReissuedTicketCheckBox    False
    ${charges_reissued_ticket_status}    Get Checkbox Status    ${object}
    Set Suite Variable    ${charges_reissued_ticket_status_${identifier}}    ${charges_reissued_ticket_status}

Get Total Charge
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalChargeLabel    FALSE
    ${total_charge}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_charge_${identifier}}    ${total_charge}

Get Total Discount
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalDiscountLabel    FALSE
    ${total_discount}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_discount_${identifier}}    ${total_discount}

Get Total IATA Com
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalataComLabel    FALSE
    ${total_iata_com}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_iata_com_${identifier}}    ${total_iata_com}

Get Total Merchant Fee
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalMerchantFeeLabel    FALSE
    ${total_merchant_fee}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_merchant_fee_${identifier}}    ${total_merchant_fee}

Get Total Returnable OR
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalReturnableLabel    FALSE
    ${total_returnable_or}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_returnable_or_${identifier}}    ${total_returnable_or}

Get Total Sell Fare
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalSellFareLabel    FALSE
    ${total_sell_fare}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_sell_fare_${identifier}}    ${total_sell_fare}

Get Total Selling Fare In Charges
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalSellingFareLabel    FALSE
    ${total_selling_fare}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_selling_fare_${identifier}}    ${total_selling_fare}

Get Total Taxes
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalTaxesLabel    FALSE
    ${total_taxes}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_taxes_${identifier}}    ${total_taxes}

Get Total VAT/GST
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TotalVatGstLabel    FALSE
    ${total_vat_gst}    Get Control Text Value    ${object}
    Set Suite Variable    ${total_vat_gst_${identifier}}    ${total_vat_gst}

Get Trip Type
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_TripTypeComboBox    False
    ${trip_type}    Get Control Text Value    ${object}
    Set Suite Variable    ${trip_type_${identifier}}    ${trip_type}

Get UATP
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_UatpComboBox    False
    ${uatp}    Get Control Text Value    ${object}
    Set Suite Variable    ${uatp_${identifier}}    ${uatp}

Get VAT/GST Percentage
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_VatGstTextBox    FALSE
    ${vat_gst}    Get Control Text Value    ${object}
    Set Suite Variable    ${vat_gst_${identifier}}    ${vat_gst}

Get YQ Tax
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_YqTaxTextBox    False
    ${yq_tax}    Get Control Text Value    ${object}
    Set Suite Variable    ${yq_tax_${identifier}}    ${yq_tax}

Get Airline OR Com Dollar
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_AirLineOrComTextBox    FALSE
    ${airline_or_com_dollar}    Get Control Text Value    ${object}
    Set Suite Variable    ${airline_or_com_dollar_${identifier}}    ${airline_or_com_dollar}

Get Base Amount
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_BaseAmountLabel    FALSE
    ${base_amount}    Get Control Text Value    ${object}
    Set Suite Variable    ${base_amount_${identifier}}    ${base_amount}

Get Base Fare
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_BaseFareTextBox    False
    ${base_fare}    Get Control Text Value    ${object}
    Set Suite Variable    ${base_fare_${identifier}}    ${base_fare}

Get CWT Reference (TK) No In Charges
    [Arguments]    ${identifier}    ${index}
    ${cwtrno}    Get Control Text Value    [NAME:Charges_CwtRefNo${index}TextBox]
    Set Suite Variable    ${cwtrno${index}_${identifier}}    ${cwtrno}

Get Other Services Pricing Parameters Details
    [Arguments]    ${identifier}
    Get Pricing    ${identifier}
    Get Trip Type    ${identifier}
    Get Final Destination    ${identifier}
    Get FOP    ${identifier}

Get Other Services Related Details
    [Arguments]    ${identifier}
    Run Keyword If    "${product.lower()}"=="air bsp" or "${product.lower()}"=="air domestic"    Run Keywords    Get CWT Reference (TK) No In Charges    ${identifier}    1
    ...    AND    Get CWT Reference (TK) No In Charges    ${identifier}    2
    ...    AND    Get CWT Reference (TK) No In Charges    ${identifier}    3
    Run Keyword If    "${product.lower()}" != "air bsp" and "${product.lower()}" != "air domestic"    Get Vendor Reference No (GSA)    ${identifier}
    Get Related No (PO)    ${identifier}
    Run Keyword If    "${product.lower()}"=="air bsp" or "${product.lower()}"=="air domestic"    Get Status Of Reissued Ticket    ${identifier}
    Run Keyword If    "${product.lower()}"=="air bsp" or "${product.lower()}"=="air domestic"    Get Issue In Exchange For    ${identifier}

Get Other Services Fare Calculation
    [Arguments]    ${identifier}
    Get Base Fare    ${identifier}
    Get IATA Com Percentage    ${identifier}
    Get Airline OR Com Dollar    ${identifier}
    Get Client Discount Percentage    ${identifier}
    Get YQ Tax    ${identifier}
    Get Oth Taxes    ${identifier}    1
    Get Oth Tax Code    ${identifier}    1
    Get Oth Taxes    ${identifier}    2
    Get Oth Tax Code    ${identifier}    2
    Get Oth Taxes    ${identifier}    3
    Get Oth Tax Code    ${identifier}    3
    Get Returnable OR    ${identifier}
    #VAT/GST Fields
    Get VAT/GST Percentage    ${identifier}
    Get Merchant Fee %    ${identifier}    vat
    Get OT Percentage    ${identifier}    1
    Get OT Percentage    ${identifier}    2
    #TF Fields
    Get Fee    ${identifier}
    Get Override Status    ${identifier}
    Get Merchant Fee %    ${identifier}    fee

Get Other Services Fare Calculated Values
    [Arguments]    ${identifier}
    Get Base Amount    ${identifier}
    Get Total IATA Com    ${identifier}
    Get Total Returnable OR    ${identifier}
    Get Total Discount    ${identifier}
    Get Total Sell Fare    ${identifier}
    Get Total VAT/GST    ${identifier}
    Get Total Merchant Fee    ${identifier}
    Get Total Selling Fare In Charges    ${identifier}
    Get Total Taxes    ${identifier}
    Get Merchant Fee TF    ${identifier}
    Get Total Charge    ${identifier}

Populate Issue In Exchange For
    [Arguments]    ${issue_in_exchange_for}
    Tick Reissued Ticket
    Set Issue In Exchange For    ${issue_in_exchange_for}

Tick Reissued Ticket
    Tick Checkbox    [NAME:Charges_ReissuedTicketCheckBox]

Verify Other Services Meet & Greet Request Tab Values Are Correct
    [Arguments]    ${merchant_fee}    ${vat_gst_amount}    ${gross_sell}    ${total_selling_price}    ${form_of_payment}    ${description}=Meet & Greet
    ...    ${other_related_no_po}=PONUMBA    ${vendor_reference_no}=VENDOR

Verify Other Services India Cost Details
    [Arguments]    ${identifier}    ${cost_amount}=2500    ${discount}=12.5    ${commission}=500    ${merchant_fee}=77    ${vat_gst_amount}=448
    ...    ${gross_sell}=2988    ${total_selling_price}=3513
    Get Other Services India Cost Details    ${identifier}
    Verify Actual Value Matches Expected Value    ${cost_amount_${identifier}}    ${cost_amount}
    Verify Actual Value Matches Expected Value    ${commission_${identifier}}    ${commission}
    Verify Actual Value Matches Expected Value    ${discount_${identifier}}    ${discount}
    Run Keyword If    "${product}" != "rebate"    Verify Actual Value Matches Expected Value    ${merchant_fee_${identifier}}    ${merchant_fee}
    ...    ELSE    Verify Actual Value Matches Expected Value    ${merchant_fee_${identifier}}    0
    Run Keyword If    "${product}" != "rebate"    Verify Actual Value Matches Expected Value    ${vat_gst_amount_${identifier}}    ${vat_gst_amount}
    ...    ELSE    Verify Actual Value Matches Expected Value    ${vat_gst_amount_${identifier}}    0
    Verify Actual Value Matches Expected Value    ${gross_sell_${identifier}}    ${gross_sell}
    Verify Actual Value Matches Expected Value    ${total_selling_price_${identifier}}    ${total_selling_price}

Verify Other Services India Additional Information Details
    [Arguments]    ${identifier}    ${description}    ${cwt_reference_no}=${EMPTY}    ${other_related_no}=PONUMBA    ${vendor_ref_no}=VENDOR
    Get Other Services India Additional Information Details    ${identifier}
    Verify Actual Value Matches Expected Value    ${description_${identifier}}    ${description}
    Verify Actual Value Matches Expected Value    ${cwt_reference_no_${identifier}}    ${cwt_reference_no}
    Verify Actual Value Matches Expected Value    ${other_related_no_${identifier}}    ${other_related_no}
    Verify Actual Value Matches Expected Value    ${vendor_ref_no_${identifier}}    ${vendor_ref_no}

Cancel Exchange Order
    [Arguments]    ${eo_number}    ${country}=IN    ${is_last_amend_date}=False
    Click Button In Eo Grid    ${eo_number}    ${country}    Amend
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Click Charges Tab
    Click Cancel Or Remove
    Wait Until Window Exists    Confirmation    timeout=8    retry_interval=4
    Send    {ENTER}
    Wait Until Control Object Is Visible    [NAME:EoGrid]
    Run Keyword If    "${is_last_amend_date}"=="True"    Get Expected Last Amend Date
    [Teardown]    Take Screenshot

Cancel Draft Exchange Order
    [Arguments]    ${product_name}    ${country}=IN    ${is_last_amend_date}=False
    Click Button In Eo Grid By Product Name    Amend    ${product_name}    IN
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Click Charges Tab
    Click Cancel Or Remove
    Wait Until Window Exists    Confirmation    timeout=8    retry_interval=4
    Send    {ENTER}
    Wait Until Control Object Is Visible    [NAME:EoGrid]
    Run Keyword If    "${is_last_amend_date}"=="True"    Get Expected Last Amend Date
