*** Settings ***
Resource          ../common/core.robot

*** Variables ***
@{product_without_merchant_fee}    24 hours emergency svcs    hotel - overseas booking fee    car - overseas booking fee    misc - overseas booking fee    hotel - local booking fee    car - local booking fee    misc - overseas booking fee
...               misc - local booking fee    visa handling fee

*** Keywords ***
Calculate Commission
    [Arguments]    ${is_cash_or_percentage}
    [Documentation]    ${is_cash_or_percentage} should be either cash or percentage from Commission toggle in Non-Air Charges and Associated Charges tab
    ${commission}    Run Keyword If    "${is_cash_or_percentage.lower()}"=="percentage"    Evaluate    ((${cost_amount}*${commission})*0.01)
    ...    ELSE IF    "${is_cash_or_percentage.lower()}"=="cash"    Set Variable    ${commission}
    ${commission}    Run Keyword If    "${is_cash_or_percentage.lower()}"=="percentage"    Round Apac    ${commission}    IN
    ...    ELSE IF    "${is_cash_or_percentage.lower()}"=="cash"    Set Variable    ${commission}
    Log    ${commission}
    Set Suite Variable    ${calculated_commission}    ${commission}

Calculate Discount
    [Arguments]    ${is_cash_or_percentage}
    [Documentation]    ${is_cash_or_percentage} should be either cash or percentage from Discount toggle in Non-Air Charges and Associated Charges tab
    ${discount}    Run Keyword If    "${is_cash_or_percentage.lower()}"=="percentage"    Evaluate    ((${cost_amount}+${commission})*${discount}*0.01)
    ...    ELSE IF    "${is_cash_or_percentage.lower()}"=="cash"    Set Variable    ${discount}
    ${discount}    Run Keyword If    "${is_cash_or_percentage.lower()}"=="percentage"    Round Apac    ${discount}    IN
    ...    ELSE IF    "${is_cash_or_percentage.lower()}"=="cash"    Set Variable    ${discount}
    Log    ${discount}
    Set Suite Variable    ${calculated_discount}    ${discount}

Calculate Merchant Fee In Associated Charges For Remarks
    [Documentation]    By Using this Keyword , we can calculate Merchant Fee amount in Associated Charges,
    ...    In this script we Merchant fee and Ot1,Ot2 are hard coded as per the requirement.
    ...    If we want to change take that set variables as arguments.....
    ${assoc_charges_merchant_gst}    Set Variable    14
    ${assoc_charges_merchant_ot1}    Set Variable    0.5
    ${assoc_charges_merchant_ot2}    Set Variable    0.5
    ${assoc_charges_merchant_gst_value}    Set Variable
    ${assoc_charges_merchant_gst_value}    Evaluate    ${assoc_charges_merchant_gst}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_merchant_gst_value}    Round Apac    ${assoc_charges_merchant_gst_value}    IN
    ${assoc_charges_merchant_ot1_calvalue}    Set Variable
    ${assoc_charges_merchant_ot1_calvalue}    Evaluate    ${assoc_charges_merchant_ot1}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_merchant_ot1_calvalue}    Round Apac    ${assoc_charges_merchant_ot1_calvalue}    IN
    ${assoc_charges_merchant_ot2_calvalue}    Set Variable
    ${assoc_charges_merchant_ot2_calvalue}    Evaluate    ${assoc_charges_merchant_ot2}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_merchant_ot2_calvalue}    Round Apac    ${assoc_charges_merchant_ot2_calvalue}    IN
    Set Suite Variable    ${assoc_charges_merchant_gst}
    Set Suite Variable    ${assoc_charges_merchant_ot1}
    Set Suite Variable    ${assoc_charges_merchant_ot2}
    Set Suite Variable    ${assoc_charges_merchant_gst_value}
    Set Suite Variable    ${assoc_charges_merchant_ot1_calvalue}
    Set Suite Variable    ${assoc_charges_merchant_ot2_calvalue}

Calculate Merchant Fee In Charges For Remarks
    ${charges_merchant_gst}    Set Variable    14
    ${charges_merchant_ot1}    Set Variable    0.5
    ${charges_merchant_ot2}    Set Variable    0.5
    ${charges_merchant_gst_value}    Set Variable
    ${charges_merchant_gst_value}    Evaluate    ${charges_merchant_gst}*0.01*${charges_merchant_fee}
    ${charges_merchant_gst_value}    Round Apac    ${charges_merchant_gst_value}    IN
    ${charges_merchant_ot1_calvalue}    Set Variable
    ${charges_merchant_ot1_calvalue}    Evaluate    ${charges_merchant_ot1}*0.01*${charges_merchant_fee}
    ${charges_merchant_ot1_calvalue}    Round Apac    ${charges_merchant_ot1_calvalue}    IN
    ${charges_merchant_ot2_calvalue}    Set Variable
    ${charges_merchant_ot2_calvalue}    Evaluate    ${charges_merchant_ot2}*0.01*${charges_merchant_fee}
    ${charges_merchant_ot2_calvalue}    Round Apac    ${charges_merchant_ot2_calvalue}    IN
    Set Suite Variable    ${charges_merchant_gst}
    Set Suite Variable    ${charges_merchant_ot1}
    Set Suite Variable    ${charges_merchant_ot2}
    Set Suite Variable    ${charges_merchant_gst_value}
    Set Suite Variable    ${charges_merchant_ot1_calvalue}
    Set Suite Variable    ${charges_merchant_ot2_calvalue}

Calculate VAT For Merchant Fee In Associated Charges For Remarks
    ${assoc_charges_vat_gst}    Set Variable    14
    ${assoc_charges_vat_ot1}    Set Variable    0.5
    ${assoc_charges_vat_ot2}    Set Variable    0.5
    ${assoc_charges_vat_gst_value}    Evaluate    ${assoc_charges_vat_gst}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_ot1_calvalue}    Evaluate    ${assoc_charges_vat_ot1}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_ot2_calvalue}    Evaluate    ${assoc_charges_vat_ot2}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_for_merchfee_calvalue}    Evaluate    ${assoc_charges_vat_gst_value}+${assoc_charges_vat_ot1_calvalue}+${assoc_charges_vat_ot2_calvalue}
    ${assoc_charges_vat_for_merchfee_calvalue}    Round Apac    ${assoc_charges_vat_for_merchfee_calvalue}    IN
    Set Suite Variable    ${assoc_charges_vat_for_merchfee_calvalue}

Calculate VAT For Merchant Fee In Charges For Remarks
    ${charges_vat_gst}    Set Variable    14
    ${charges_vat_ot1}    Set Variable    0.5
    ${charges_vat_ot2}    Set Variable    0.5
    ${charges_vat_gst_value}    Evaluate    ${charges_vat_gst}*0.01*${charges_merchant_fee}
    ${charges_vat_ot1_calvalue}    Evaluate    ${charges_vat_ot1}*0.01*${charges_merchant_fee}
    ${charges_vat_ot2_calvalue}    Evaluate    ${charges_vat_ot2}*0.01*${charges_merchant_fee}
    ${charges_vat_for_merchfee_calvalue}    Evaluate    ${charges_vat_gst_value}+${charges_vat_ot1_calvalue}+${charges_vat_ot2_calvalue}
    ${charges_vat_for_merchfee_calvalue}    Round Apac    ${charges_vat_for_merchfee_calvalue}    IN
    Set Suite Variable    ${charges_vat_for_merchfee_calvalue}

Calculate VAT In Associated Charges For Remarks
    ${assoc_charges_vat_gst}    Set Variable    14
    ${assoc_charges_vat_ot1}    Set Variable    0.5
    ${assoc_charges_vat_ot2}    Set Variable    0.5
    ${assoc_charges_vat_gst_value}    Set Variable
    ${assoc_charges_vat_gst_value}    Evaluate    ${assoc_charges_vat_gst}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_gst_value}    Round Apac    ${assoc_charges_vat_gst_value}    IN
    ${assoc_charges_vat_ot1_calvalue}    Set Variable
    ${assoc_charges_vat_ot1_calvalue}    Evaluate    ${assoc_charges_vat_ot1}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_ot1_calvalue}    Round Apac    ${assoc_charges_vat_ot1_calvalue}    IN
    ${assoc_charges_vat_ot2_calvalue}    Set Variable
    ${assoc_charges_vat_ot2_calvalue}    Evaluate    ${assoc_charges_vat_ot2}*0.01*${assoc_charges_merchant_fee}
    ${assoc_charges_vat_ot2_calvalue}    Round Apac    ${assoc_charges_vat_ot2_calvalue}    IN
    ${assoc_charges_vat_total_calvalue}    Evaluate    ${assoc_charges_merchant_gst}+${assoc_charges_vat_ot1_calvalue}+${assoc_charges_vat_ot2_calvalue}
    ${assoc_charges_vat_total_calvalue}    Round Apac    ${assoc_charges_vat_total_calvalue}    IN
    Set Suite Variable    ${assoc_charges_vat_total_calvalue}

Calculate VAT In Charges For Remarks
    ${charges_vat_gst}    Set Variable    14
    ${charges_vat_ot1}    Set Variable    0.5
    ${charges_vat_ot2}    Set Variable    0.5
    ${charges_vat_gst_value}    Set Variable
    ${charges_vat_gst_value}    Evaluate    ${charges_vat_gst}*0.01*${charges_merchant_fee}
    ${charges_vat_gst_value}    Round Apac    ${charges_vat_gst_value}    IN
    ${charges_vat_ot1_calvalue}    Set Variable
    ${charges_vat_ot1_calvalue}    Evaluate    ${charges_vat_ot1}*0.01*${charges_merchant_fee}
    ${charges_vat_ot1_calvalue}    Round Apac    ${charges_vat_ot1_calvalue}    IN
    ${charges_vat_ot2_calvalue}    Set Variable
    ${charges_vat_ot2_calvalue}    Evaluate    ${charges_vat_ot2}*0.01*${charges_merchant_fee}
    ${charges_vat_ot2_calvalue}    Round Apac    ${charges_vat_ot2_calvalue}    IN
    ${charges_vat_total_calvalue}    Evaluate    ${charges_vat_gst_value}+${charges_vat_ot1_calvalue}+${charges_vat_ot2_calvalue}
    ${charges_vat_total_calvalue}    Round Apac    ${charges_vat_total_calvalue}    IN
    Set Suite Variable    ${charges_vat_total_calvalue}

Click Add All Button In Exchange Order Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:EoAddAllButton]

Click Add All Button In Itinerary Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:IoAddAllButton]

Click Add Button In Exchange Order Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:EoAddButton]

Click Add Button In Itinerary Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:IoAddButton]

Click Add In Associated Charges
    Activate Power Express Window
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_AddButton]
    Click Control Button    [NAME:AssociatedCharges_AddButton]

Click Add In Vendor Info Tab
    Click Control    [NAME:AddButton]

Click Calculate
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:CalculateSellingPriceButton]
    Wait Until Control Object Is Disabled    [NAME:CalculateSellingPriceButton]

Click Cancel For IN
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_CancelButton,AssociatedCharges_CancelButton    False
    Click Control Button    ${object}
    Wait Until Other Service Loader Is Not Visible

Click Cancel In Associated Charges
    Activate Power Express Window
    Click Control Button    [NAME:AssociatedCharges_CancelButton]

Click Clear In Associated Charges
    Activate Power Express Window
    Click Control Button    [NAME:AssociatedCharges_ClearButton]
    [Teardown]    TakeScreenshot

Click Commission
    [Arguments]    ${selection}
    [Documentation]    Input either "Cash" or "Percentage"
    ${is_cash_or_percentage}    Set Variable If    "${selection.upper()}" == "CASH"    c    p
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_CommissionToggleButton_PaymentButton,AssociatedCharges_CommissionToggleButton_PaymentButton,CommissionToggleButton_PaymentButton    False
    Click Control Button    ${object}
    Send    {${is_cash_or_percentage}}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Click Continue In Other Svcs
    Activate Power Express Window
    Click Control Button    [NAME:btnContinue]
    Wait Until Other Service Loader Is Not Visible
    Wait Until Control Object Is Not Visible    [NAME:btnContinue]
    Comment    Wait Until Control Object Is Visible    [NAME:otherServicesContainer]
    ${current_datetime}    DateTime.Get Current Date    result_format=%m/%d/%Y %I:%M
    Set Suite Variable    ${current_datetime}

Click Delete All Button In Exchange Order Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:EoDeleteButton]

Click Delete All Button In Itinerary Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:linkLabel1]

Click Delete Button On An Item In Exchange Order Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    ${deleted_eo_remark}=    Get Cell Value In Data Grid Pane    [NAME:ToEoDataGridView]    Row ${count}    2
    Set Test Variable    ${deleted_eo_remark}
    Click Cell In Data Grid Pane    [NAME:ToEoDataGridView]    Row ${count}    3

Click Delete Button On An Item In Itinerary Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    ${deleted_io_remark}=    Get Cell Value In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${count}    2
    Set Test Variable    ${deleted_io_remark}
    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${count}    3

Click Delete Button On Multiple Items In Exchange Order Remarks Grid View By Index Range
    [Arguments]    @{index_list}
    Activate Power Express Window
    @{deleted_eo_remark_list}    Create List
    : FOR    ${i}    IN    @{index_list}
    \    ${get_cell_value}=    Get Cell Value In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${i}    2
    \    Append To List    @{deleted_eo_remark_list}    ${get_cell_value}
    \    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${i}    3
    Log List    @{deleted_eo_remark_list}
    Set Test Variable    @{deleted_eo_remark_list}

Click Delete Button On Multiple Items In Itinerary Remarks Grid View By Index Range
    [Arguments]    @{index_list}
    Activate Power Express Window
    @{deleted_io_remark_list}    Create List
    : FOR    ${i}    IN    @{index_list}
    \    ${get_cell_value}=    Get Cell Value In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${i}    2
    \    Append To List    @{deleted_io_remark_list}    ${get_cell_value}
    \    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${i}    3
    Log List    @{deleted_io_remark_list}
    Set Test Variable    @{deleted_io_remark_list}

Click Discount
    [Arguments]    ${selection}
    [Documentation]    Input either "Cash" or "Percentage"
    ${is_cash_or_percentage}    Set Variable If    "${selection.upper()}" == "CASH"    c    p
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiscountPriceToggleButton_PaymentButton,AssociatedCharges_DiscountPriceToggleButton_PaymentButton,DiscountToggleButton,DiscountToggleButton_PaymentButton    False
    Click Control Button    ${object}
    Send    {${is_cash_or_percentage}}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Click Left Exchange Order Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:FromEoDataGridView]

Click Left Itinerary Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:FromIoDataGridView]

Click Ok In Error Message
    Win Activate    Error    ${EMPTY}
    Verify Window Is Active    Error
    Send    {ENTER}
    Wait Until Window Does Not Exists    Error

Click Ok On No Car Segment Found
    Win Activate    Error    ${EMPTY}
    Verify Window Is Active    Error
    Send    {ENTER}
    Wait Until Window Does Not Exists    Error

Click Percent Button
    Wait Until Control Object Is Visible    [NAME:btnOtherServicePercentage]
    Click Button    [NAME:btnOtherServicePercentage]

Click Percent Button In Commission Field
    Wait Until Control Object Is Visible    [NAME:PaymentButton]
    Click Control    [NAME:PaymentButton]    0

Click Percent Button In Discount Field
    Wait Until Control Object Is Visible    [NAME:PaymentButton]
    Click Control    [NAME:PaymentButton]    1

Click Remarks Tab
    Click Tab In Other Services Panel    Remarks

Click Right Exchange Order Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:ToEoDataGridView]

Click Right Itinerary Remarks Grid View
    Activate Power Express Window
    Click Control Button    [NAME:ToIoDataGridView]

Click Save In Associated Charges
    Activate Power Express Window
    Click Control Button    [NAME:AssociatedCharges_SaveButton]
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_AssociatedInfoGrid]

Click Service Info Tab
    [Documentation]    PLS READ: Please use "Click Tab In Other Services Panel" keyword instead to click a specific tab in the Other Svcs Panel.
    ...
    ...    Sample usage of "Click Tab In Other Services Panel" keyword:
    ...
    ...    To select a tab named "Service Info" .....
    ...    \ \ \ \ \ \ \ \ Click Tab In Other Services Panel \ \ \ Service Info
    Comment    Activate Power Express Window
    Comment    Click Control Button    [placeholder - Service Info tab]
    Comment    Click Control Button    [NAME:TabControl1]
    Comment    Verify Fare Tab Is Visible    ${fare_tab_value}
    Comment    Select Tab Control    ${fare_tab_value}
    Comment    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Comment    Set Test Variable    ${fare_tab_index}
    Comment    Sleep    2
    Click Tab In Other Services Panel    Service Info

Click Sort Down Button On A Specific Item In Exchange Order Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Click Cell In Data Grid Pane    [NAME:ToEoDataGridView]    Row ${count}    1

Click Sort Down Button On An Item In Itinerary Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${count}    1

Click Sort Up Button On A Specific Item In Exchange Order Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Click Cell In Data Grid Pane    [NAME:ToEoDataGridView]    Row ${count}    0

Click Sort Up Button On An Item In Itinerary Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${count}    0

Click Tab In Other Services Panel
    [Arguments]    ${tab_name}
    Wait Until Control Object Is Visible    [NAME:otherServicesContainer]
    Click Control Button    [NAME:otherServicesContainer]
    Select Tab Control    ${tab_name}

Click Vendor Info Tab
    [Documentation]    PLS READ: Please use "Click Tab In Other Services Panel" keyword instead to click a specific tab in the Other Svcs Panel.
    ...
    ...    Sample usage of "Click Tab In Other Services Panel" keyword:
    ...
    ...    To select a tab named "Service Info" .....
    ...    \ \ \ \ \ \ \ \ Click Tab In Other Services Panel \ \ \ Service Info
    Comment    Activate Power Express Window
    Comment    Click Control Button    [placeholder - vendor info]
    Click Tab In Other Services Panel    Vendor Info

Click Visa Info Tab
    [Documentation]    PLS READ: Please use "Click Tab In Other Services Panel" keyword instead to click a specific tab in the Other Svcs Panel.
    ...
    ...    Sample usage of "Click Tab In Other Services Panel" keyword:
    ...
    ...    To select a tab named "Visa Info" .....
    ...    \ \ \ \ \ \ \ \ Click Tab In Other Services Panel \ \ \Visa Info
    Comment    Activate Power Express Window
    Comment    Click Control Button    [placeholder - vendor info]
    Click Tab In Other Services Panel    Visa Info

Compute Commission
    [Arguments]    ${selling_price_in_di}    ${nett_cost}
    [Documentation]    Commission
    ...
    ...    IF \ \ \ \ Selling Price in DI > Nett Cost THEN Commission \ = Selling Price in DI - Nett Cost
    ...    ELSE Commission = 0
    ${commission}=    Set Variable    0
    ${commission}=    Run Keyword If    ${selling_price_in_di} > ${nett_cost}    Evaluate    ${selling_price_in_di}- ${nett_cost}
    Set Suite Variable    ${commission}
    [Return]    ${commission}

Compute Commission For India
    ${computed_commission_amount}=    Run Keyword If    ${commission_percent_status}    Evaluate    ${nett_cost}*${commission_input}*0.01
    ...    ELSE    Set Variable    ${commission}
    ${computed_commission_amount}=    Round Off    ${computed_commission_amount}    0
    Set Test Variable    ${computed_commission_amount}

Compute Discount
    ${computed_discount_amount}=    Run Keyword If    ${discount_percent_status}    Evaluate    (${nett_cost}+${computed_commission_amount})*${discount_input}*0.01
    ...    ELSE    Set Variable    ${discount}
    ${computed_discount_amount}=    Round Off    ${discount_amount}    0
    Set Test Variable    ${computed_discount_amount}

Compute Fees for Visa Processing
    [Documentation]    If Checked Nett Merchant
    ...
    ...    MF NettCost = Round UP (Nett Cost * (Merchant Fee Percent * 0.01))
    ...
    ...    Else
    ...
    ...    MF NettCost = 0
    ...
    ...    If Checked CWT Handling Merchant
    ...
    ...    MF CWT Handling = Round UP((CWT Handling + Vendor Handling) * (Merchant Fee Percent * 0.01))
    ...
    ...    Else
    ...
    ...    MF CWT Handling = 0
    ...
    ...    Selling Price = Nett Cost + Vendor Handling + CWT Handling + MF NettCost + MF CWT Handling
    ...
    ...    If Selling Price in DI > Nett Cost
    ...
    ...    Commission \ = Selling Price in DI - Nett Cost - Vendor Handling
    ...
    ...    Else
    ...
    ...    Commission = 0
    Compute Merchant Fee - Nett Cost
    Compute Merchant Fee - CWT Handling
    Compute Visa Processing Selling Price
    Compute Visa Processing Total Selling Price
    Compute Visa Processing Commission

Compute GST Amount
    [Arguments]    ${selling_price}    ${gst_percentage}    ${cwt_absorbs_gst_amount}=False
    [Documentation]    GST Amount (if applicable)
    ...
    ...    a) If CWT Absorb ticked:
    ...
    ...    \ \ \ GST = 0
    ...
    ...    b) If CWT Absorb unticked:
    ...
    ...    GST = Selling Price * GST Percent * 0.01
    ${gst_amount} =    Evaluate    ${selling_price} * ${gst_percentage}
    ${gst_amount} =    Run Keyword If    '${cwt_absorbs_gst_amount.lower()}'=='true'    Set Variable    0
    [Return]    ${gst_amount}

Compute Gross Sell
    [Documentation]    This keyword computes the Gross Sell in India Workflow
    ${computed_gross_sell}=    Evaluate    ${computed_nett_cost}+${computed_commission}-${computed_discount}
    ${computed_gross_sell}=    Round Off    ${computed_gross_sell}    0
    Log    Computed Gross Sell Value is ${computed_gross_sell}
    Set Test Variable    ${computed_gross_sell}

Compute Merchant Fee
    [Arguments]    ${country_code}    ${cwt_absorbs_merchant_fee}
    [Documentation]    Merchant Fee Computation (US743):
    ...
    ...    a) Check Box Merchant Fee Absorb = Unchecked And cmbFOPType = "CX"
    ...
    ...    \ \ Merchant Fee = Round Up(Selling Price * (1 + GST Percent * 0.01) * Merchant Fee Percent * 0.01)
    ...
    ...    b) CWT Absorb ticked:
    ...
    ...    Merchant Fee = 0
    ${computed_merchant_fee}    Set Variable If    '${cwt_absorbs_merchant_fee.lower()}'=='true'    0    '${form_of_payment.lower()}'=='credit card (cc)'    0    '${form_of_payment.lower()}'=='cash or invoice'
    ...    0
    Set Test Variable    ${computed_merchant_fee}
    Run Keyword If    '${country_code.lower()}'=='hk' and '${form_of_payment.lower()}'=='credit card (cx)' and '${cwt_absorbs_merchant_fee.lower()}'=='false'    Compute Merchant Fee For Hongkong
    Run Keyword If    '${country_code.lower()}'=='sg' and '${form_of_payment.lower()}'=='credit card (cx)' and '${cwt_absorbs_merchant_fee.lower()}'=='false'    Compute Merchant Fee For Singapore
    Run Keyword If    ('${cwt_absorbs_merchant_fee.lower()}'=='true' or '${form_of_payment.lower()}'=='credit card (cc)' or '${form_of_payment.lower()}'=='cash or invoice') and '${country_code.lower()}'=='sg'    Convert Computed Merchant Fee To Float
    Run Keyword If    ('${cwt_absorbs_merchant_fee.lower()}'=='true' or '${form_of_payment.lower()}'=='credit card (cc)' or '${form_of_payment.lower()}'=='cash or invoice') and '${country_code.lower()}'=='hk'    Round Off Computed Merchant Fee To Whole Number
    Log    Computed merchant fee for ${country_code} is ${computed_merchant_fee} when CWT absorb is ${cwt_absorbs_merchant_fee}.

Compute Merchant Fee - CWT Handling
    ${merchant_fee_cwt_handling_checkbox_status} =    Get Checkbox Status    [NAME:CwtHandlingMerchantCheckBox]
    Log    ${merchant_fee_cwt_handling_checkbox_status}
    ${computed}    Evaluate    (${cwt_handling}+${vendor_handling})*(${merchant_percentage}*0.01)
    ${computed}    Set Variable If    ${merchant_fee_cwt_handling_checkbox_status} == False    ${0}    ${computed}
    ${computed}    Round Apac    ${computed}    hk
    Get MF CWT Handling
    Should Be Equal As Integers    ${computed}    ${mf_cwt_handling}
    Log    "Computed MF CWT Handling is EQUAL to Retrieved Value"
    Set Test Variable    ${mf_cwt_handling}

Compute Merchant Fee - Nett Cost
    ${merchant_fee_nett_cost_checkbox_status} =    Get Checkbox Status    [NAME:NetCostMerchantCheckBox]
    Log    ${merchant_fee_nett_cost_checkbox_status}
    ${computed}    Evaluate    ${nett_cost}*(${merchant_percentage}*0.01)
    ${computed}    Set Variable if    "${merchant_fee_nett_cost_checkbox_status}" == "False"    ${0}    ${computed}
    ${computed}    Round Apac    ${computed}    hk
    Get MF Nett Cost
    Should Be Equal As Numbers    ${computed}    ${mf_nett_cost}
    Log    "Computed MF Nett Cost is EQUAL to Retrieved Value"
    Set Test Variable    ${mf_nett_cost}

Compute Merchant Fee For Hongkong
    [Documentation]    This keyword is used by Compute Merchant Fee. This is not intended to be used in test case level.
    ${computed_merchant_fee}    Evaluate    ${selling_price}*(1+${gst_percent}*0.01)*${merchant_percentage}*0.01
    ${computed_merchant_fee}    Evaluate    int(${computed_merchant_fee})
    Set Suite Variable    ${computed_merchant_fee}

Compute Merchant Fee For India
    ${computed_merchant_fee_amount}=    Evaluate    (${computed_gross_sell}+${computed_vat_gst_amount})*${merchant_fee_percent}*0.01
    ${computed_merchant_fee_amount}=    Round Off    ${computed_merchant_fee_amount}    0
    Log    Computed Merchant Fee Amount is ${computed_merchant_fee_amount}
    Set Test Variable    ${computed_merchant_fee_amount}

Compute Merchant Fee For Singapore
    [Documentation]    This keyword is used by Compute Merchant Fee. This is not intended to be used in test case level.
    ${computed_merchant_fee}    Evaluate    ${selling_price}*(1+${gst_percent}*0.01)*${merchant_percentage}*0.01
    ${computed_merchant_fee}    Round Off    ${computed_merchant_fee}
    Set Suite Variable    ${computed_merchant_fee}
    [Teardown]

Compute Nett Cost Value
    [Arguments]    ${plan_commission}    ${country}=SG
    ${computed_nett_cost}    Evaluate    ${selling_price}* (1 - (${plan_commission}*0.01))
    ${computed_nett_cost}    Round Apac    ${computed_nett_cost}    ${country}
    Set Test Variable    ${computed_nett_cost}

Compute Other Services Fees
    [Arguments]    ${gst_percentage}    ${merchant_fee_percentage}    ${is_gst_absorb}=false    ${is_merchant_fee_absorb}=false    ${country}=SG
    Wait Until Control Object Is Not Visible    [NAME:pictureBox1]
    ${nett_cost}    Get Variable Value    ${net_cost}    ${nett_cost}
    ${computed_gst}    Run Keyword If    "${is_gst_absorb.lower()}" == "false"    Evaluate    ${selling_price} * (${gst_percentage} * 0.01)
    ...    ELSE    Set Variable    0
    ${computed_nett_cost_gst}    Run Keyword If    "${is_gst_absorb.lower()}" == "false"    Evaluate    ${nett_cost} * (${gst_percentage} * 0.01)
    ...    ELSE    Set Variable    0
    ${computed_merchant_fee}    Run Keyword If    "${form_of_payment.lower()}" == "credit card (cx)" and "${is_merchant_fee_absorb.lower()}"=="false"    Evaluate    ${selling_price}*(1+${gst_percentage}*0.01)*(${merchant_fee_percentage}*0.01)
    ...    ELSE    Set Variable    0
    ${computed_merchant_fee}    Round To Nearest Dollar    ${computed_merchant_fee}    ${country.upper()}    up
    Comment    ${computed_total_selling_price}    Set Variable    ${total_selling_price}
    ${computed_total_selling_price}    Evaluate    (${selling_price}+${computed_gst}+${computed_merchant_fee})/(1+${gst_percentage}*0.01)
    Log List    ${product_without_merchant_fee}
    ${computed_total_selling_price}    Run Keyword If    "${product}" not in @{product_without_merchant_fee}    Evaluate    (${selling_price}+${computed_gst}+${computed_merchant_fee})/(1+${gst_percentage}*0.01)
    ...    ELSE    Set Variable    ${total_selling_price}
    ${computed_total_selling_price}    Round Apac    ${computed_total_selling_price}    ${country.upper()}
    ${computed_commission}    Run Keyword If    ${selling_price} > ${nett_cost}    Evaluate    ${computed_total_selling_price} - ${nett_cost}
    ...    ELSE    Set Variable    0
    ${computed_commission}    Round Apac    ${computed_commission}    ${country.upper()}
    ${computed_gst}    Round Apac    ${computed_gst}    ${country.upper()}
    Set Test Variable    ${computed_merchant_fee}
    Set Test Variable    ${computed_commission}
    Set Test Variable    ${computed_total_selling_price}
    Set Test Variable    ${computed_gst}

Compute Service Info Charges For India
    Compute Commission For India
    Compute Discount
    Compute Gross Sell
    Compute VAT GST Amount
    Compute Merchant Fee For India
    Compute Total Selling Price For India

Compute Total Selling Price
    [Arguments]    ${country_code}    ${selling_price}    ${gst_percentage}    ${merchant_fee}
    [Documentation]    Total Selling Price =
    ...    (Selling Price + ( \ Selling_Price* (GST_Percent*0.01) \ ) \ + \ Merchant Fee) / (1 + GST Percent * 0.01)
    Run Keyword If    '${country_code.lower()}' == 'sg'    Compute Total Selling Price For Singapore    ${selling_price}    ${gst_percentage}    ${merchant_fee}
    Run Keyword If    '${country_code.lower()}' == 'hk'    Compute Total Selling Price For Hongkong    ${selling_price}    ${gst_percentage}    ${merchant_fee}
    Log    Computed total selling price for ${country_code} is ${computed_total_selling_price}

Compute Total Selling Price For Hongkong
    [Arguments]    ${selling_price}    ${gst_percentage}    ${merchant_fee}
    [Documentation]    This keyword is used by Compute Total Selling Price. This is not intended to be used in test case level.
    ${total_selling_amount} =    Evaluate    (${selling_price} + ( \ ${selling_price}* (${gst_percentage}*0.01) \ ) \ + \ ${merchant_fee}) / (1 + ${gst_percentage} * 0.01)
    Log    Unrounded total selling amount is ${total_selling_amount}
    ${total_selling_amount} =    Round Off    ${total_selling_amount}    0
    ${total_selling_amount} =    Evaluate    int(${total_selling_amount})
    Log    Rounded up total selling amount is ${total_selling_amount}
    Set Suite Variable    ${computed_total_selling_price}    ${total_selling_amount}
    [Return]    ${total_selling_amount}

Compute Total Selling Price For India
    ${computed_total_selling_price}=    Evaluate    ${computed_gross_sell}+${computed_vat_gst_amount}+${computed_merchant_fee_amount}
    ${computed_total_selling_price}=    Round Off    ${computed_total_selling_price}    0
    Log    Computed Total Selling Price is ${computed_total_selling_price}

Compute Total Selling Price For Singapore
    [Arguments]    ${selling_price}    ${gst_percentage}    ${merchant_fee}
    [Documentation]    This keyword is used by Compute Total Selling Price. This is not intended to be used in test case level.
    ${total_selling_amount} =    Evaluate    (${selling_price} + ( \ ${selling_price}* (${gst_percentage}*0.01) \ ) \ + \ ${merchant_fee}) / (1 + ${gst_percentage} * 0.01)
    Log    Unrounded total selling amount is ${total_selling_amount}
    ${total_selling_amount} =    Evaluate    round((${selling_price} + ( \ ${selling_price}* (${gst_percentage}*0.01) \ ) \ + \ ${merchant_fee}) / (1 + ${gst_percentage} * 0.01) , 2)
    Log    Rounded total selling amount is ${total_selling_amount}
    Set Suite Variable    ${computed_total_selling_price}    ${total_selling_amount}
    [Return]    ${total_selling_amount}

Compute VAT GST Amount
    ${gst_amount}=    Evaluate    ${computed_gross_sell}*${gst}*0.01
    ${ot1_amount}=    Evaluate    ${computed_gross_sell}*${ot1}*0.01
    ${ot2_amount}=    Evaluate    ${computed_gross_sell}*${ot2}*0.01
    ${gst_amount}=    Round Off    ${gst_amount}    0
    ${ot1_amount}=    Round Off    ${ot1_amount}    0
    ${ot2_amount}=    Round Off    ${ot2_amount}    0
    ${computed_vat_gst_amount}=    Evaluate    ${gst_amount}+${ot1_amount}+${ot2_amount}
    ${computed_vat_gst_amount}=    Round Off    ${computed_vat_gst_amount}    0
    Log    Computed VAT/GST Amount is ${computed_vat_gst_amount}
    Set Test Variable    ${computed_vat_gst_amount}

Compute Visa Processing Commission
    ${computed}    Set Variable    0
    Comment    ${computed} =    Run Keyword If    ${total_selling_price} > ${nett_cost}    Evaluate    ${total_selling_price}- ${nett_cost} - ${vendor_handling}
    ${computed} =    Evaluate    ${total_selling_price}- ${nett_cost} - ${vendor_handling}
    Get Commission
    Should Be Equal As Numbers    ${computed}    ${commission}
    Log    "Computed Commission is EQUAL to Retrieved Value"
    Set Test Variable    ${commission}

Compute Visa Processing Selling Price
    ${computed} =    Evaluate    ${nett_cost} + ${vendor_handling} + ${cwt_handling} + ${mf_nett_cost} + ${mf_cwt_handling}
    Get Selling Price
    Should Be Equal As Numbers    ${computed}    ${selling_price}
    Log    "Computed Selling Price is EQUAL to Retrieved Value"
    Set Test Variable    ${selling_price}

Compute Visa Processing Total Selling Price
    ${computed} =    Set Variable    ${selling_price}
    Get Total Selling Price
    Should Be Equal As Numbers    ${computed}    ${total_selling_price}
    Log    "Computed Total Selling Price is EQUAL to Retrieved Value"
    Set Test Variable    ${total_selling_price}

Convert Computed Merchant Fee To Float
    ${computed_merchant_fee}    Convert To Float    ${computed_merchant_fee}
    Set Test Variable    ${computed_merchant_fee}

Convert Computed Other Services Values To Float
    ${computed_commission}    Convert To Float    ${computed_commission}
    Set Test Variable    ${computed_commission}

Convert Date From IN To GDS Format
    [Arguments]    ${date}
    ${date_code}    Split String    ${date}    /
    ${day}    Get From List    ${date_code}    0
    ${month}    Get From List    ${date_code}    1
    Set Suite Variable    ${month}    ${month.upper()}
    ${date_code}    Catenate    ${day}    ${month}
    ${date_code}    Remove All Spaces    ${date_code}
    Set Suite Variable    ${date_code}    ${date_code.strip()}
    [Return]    ${date_code}

Convert Other Services Values To Float
    ${total_selling_price}    Convert To Float    ${total_selling_price}
    Set Test Variable    ${total_selling_price}
    ${commission}    Convert To Float    ${commission}
    Set Test Variable    ${commission}
    ${selling_price}    Convert To Float    ${selling_price}
    Set Test Variable    ${selling_price}
    ${gst}    Run Keyword If    '${is_with_gst.lower()}'=='true'    Convert To Float    ${gst}
    Set Test Variable    ${gst}
    ${gst_amount}    Run Keyword If    '${is_with_gst.lower()}'=='true'    Convert To Float    ${gst_amount}
    Set Test Variable    ${gst_amount}

Convert Time From IN To GDS Format
    [Arguments]    ${time}
    ${time_in}    Convert To String    ${time}
    Log    ${time_in}
    ${time_in}    Split String    ${time}    :
    Log    ${time_in}
    ${hr}    Get From List    ${time_in}    0
    ${min}    Get From List    ${time_in}    1
    ${am_pm}    Get From List    ${time_in}    2
    ${am_pm}    Split String    ${am_pm}
    ${am_pm}    Get From List    ${am_pm}    1
    ${hr}    Convert To Integer    ${hr}
    ${time_in}    Run Keyword And Continue On Failure    Run Keyword If    "${am_pm}"=="PM"    Get Time For PM    ${hr}    ${min}
    ...    ELSE    Get Time For AM    ${hr}    ${min}
    [Return]    ${time_in}

Delete record In Vendor Info Tab
    [Arguments]    ${details_name}
    Log    Deleting Row with Details: "${details_name}"
    Delete Vendor Grid Record    [NAME:ContactTypeDataGridView]    ${details_name}
    Handling Delete pop up For Vendor Info Tab

Display Existing Grid Details In Vendor Info Tab
    ${vendor_collection}    Get All Records From Grid In Vendor Info Tab
    Log    ${vendor_collection}

Generate Data For Any Air BSP Add On Product
    [Arguments]    ${product}    ${identifier}
    Get Request Field Values    ${product}
    Run Keyword If    "${product.lower()}"=="air bsp add on" or "${product.lower()}"=="air dom add on" or "${product.lower()}"=="air sales-non bsp int"    Generate Data When Product Is Air BSP Add On, Air Dom Add On, Air Sales-Non BSP INT    ${identifier}
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Generate Data When Product Is Air Conso Dom    ${identifier}

Generate Data For Specific Product
    [Arguments]    ${is_new_eo}    ${product_id}    ${pc}    ${product}    ${type}    ${vendor_code}
    ...    ${eo_action}    ${status}=${EMPTY}    ${is_raise_cheque}=false    ${country}=${EMPTY}
    [Documentation]    ${product_id} is used for identification to make the variable unique. User defined.
    Run Keyword If    "${is_raise_cheque.lower()}" == "false"    Get Exchange Order Number
    Run Keyword If    '${eo_action.lower()}'=='email'    Click Email Button In EO Grid    ${country}
    Comment    ${expect_eo_status}    Run Keyword If    '${country.lower()}'=='hk'    Verify If HK Vendor Should Default To Complete Status    ${vendor_code}
    Comment    ${status}    Set Variable If    '${country.lower()}'=='hk'    ${expect_eo_status}    ${status}
    ${created_date}    Get Variable Value    ${date_for_eo_${product_id}}    ${date_for_eo}
    ${last_amend_date}    Run Keyword If    '${is_new_eo.lower()}'=='false' and '${eo_action.lower()}'=='email'    Set Variable    ${expected_last_amend_date}
    ...    ELSE IF    '${is_new_eo.lower()}' == 'false'    Set Variable    ${date_for_eo}
    ...    ELSE    Set Variable    ${EMPTY}
    ${completed_date}    Run Keyword If    '${status}'=='Completed'    Set Variable    ${created_date}
    ...    ELSE    Set Variable    ${EMPTY}
    ${eo_number_collection}    Create List    ${eo_number}    ${pc}    ${product}    ${last_amend_date}    ${type}
    ...    ${vendor_code}    ${eo_action}    ${status}    ${created_date}    ${completed_date}
    Set Suite Variable    ${eo_number_collection_${product_id.lower()}}    ${eo_number_collection}
    Set Suite Variable    ${date_for_eo_${product_id}}    ${created_date}

Generate Data For Specific Row In Vendor Info Tab
    [Arguments]    ${row_id}
    ${prefer}    Convert To String    ${prefer}
    Log    ${prefer}
    ${vendor_rows}    Create List    ${contact_type}    ${details}    ${prefer}
    Log List    ${vendor_rows}
    Set Suite Variable    ${vendor_grid_row${row_id.lower()}}    ${vendor_rows}
    Set Suite Variable    ${vendor_rows}

Generate Data When Product Is Air BSP Add On, Air Dom Add On, Air Sales-Non BSP INT
    [Arguments]    ${identifier}
    ${air_add_on_collection}    Create List    ${product}    ${vendor}    ${plating_carrier}    ${fare_type}    ${tour_code}
    ...    ${threshold_amount}
    Set Suite Variable    ${air_add_on_collection_${identifier.lower()}}    ${air_add_on_collection}
    Log    ${air_add_on_collection_${identifier.lower()}}

Generate Data When Product Is Air Conso Dom
    [Arguments]    ${identifier}
    ${air_add_on_collection}    Create List    ${product}    ${vendor}    ${plating_carrier}    ${fare_type}    ${tour_code}
    ...    ${threshold_amount}    ${pos_remark_1}    ${pos_remark_2}    ${pos_remark_3}    ${centralized_desk_1}    ${centralized_desk_2}
    ...    ${airlines}    ${transaction_type}    ${airlines_pnr}    ${fare_break_up_1}    ${fare_break_up_2}    ${cancellation_penalty}
    ...    ${lcc_queue_back_remark}    ${gstin}    ${email_in_request}    ${entity_name}    ${phone_no}
    Set Suite Variable    ${air_add_on_collection_${identifier.lower()}}    ${air_add_on_collection}
    Log    ${air_add_on_collection_${identifier.lower()}}

Generate Data When Product Is Meet & Greet
    [Arguments]    ${product}    ${identifier}
    Get Request Field values    ${product}
    ${meet_&_greet_collection}    Create List    ${date}    ${time}    ${city}    ${locations}    ${internal_remarks}
    Set Suite Variable    ${meet_&_greet_collection${identifier.lower()}}    ${meet_&_greet_collection}
    Log    ${meet_&_greet_collection${identifier.lower()}}

Generate Date For Passive Segment
    ${date_of_application}    Generate Date X Months From Now    0    180    %d/%b/%Y
    ${date}    Convert Date To Gds Format    ${date_of_application}    %d/%b/%Y
    Set Suite Variable    ${date}

Generate Grid Data For Specific Associated Charges Row
    [Arguments]    ${row_id}
    ${assoc_charges_cc_type}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_cc_type}
    ${assoc_charges_card_number}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_card_number}
    ${assoc_charges_expiry_month}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_expiry_month}
    ${assoc_charges_expiry_year}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_expiry_year}
    ${assoc_charges_fop_type}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    S    CC
    @{associated_charges_row}    Create List    ${assoc_charges_product}    ${assoc_charges_vendor}    ${assoc_charges_cost_amount}    ${assoc_charges_commission}    ${assoc_charges_discount}
    ...    ${assoc_charges_vendor_ref_no}    ${assoc_charges_other_related_no}    ${assoc_charges_fop_type}    ${assoc_charges_cc_type}    ${assoc_charges_card_number}    ${assoc_charges_expiry_month}/${assoc_charges_expiry_year}
    ...    ${assoc_charges_vatgst_amount}    ${assoc_charges_merchant_fee}    ${assoc_charges_total_selling_price}
    Set Suite Variable    ${associated_charges_row${row_id.lower()}}    ${associated_charges_row}
    Log List    ${associated_charges_row${row_id.lower()}}

Generate Remarks Data For Specific Associated Charge Row
    [Arguments]    ${row_id}
    ${assoc_charges_commission}    Round Apac    ${assoc_charges_commission}    IN
    ${assoc_charges_gross_sell}    Round Apac    ${assoc_charges_gross_sell}    IN
    Get Associated Charges Product Code And GST And OT1 And OT2    ${assoc_charges_product}
    Get Vendor Code For India    ${assoc_charges_product}    ${assoc_charges_vendor}
    @{assoc_charges_row}    Create List    ${product_code}    ${current_vendor_code}    ${assoc_charges_gross_sell}    ${assoc_charges_commission}    ${gst}
    ...    ${assoc_charges_remarks_gst_value}    ${ot1}    ${assoc_charges_remarks_ff99_ot1_value}    ${ot2}    ${assoc_charges_remarks_ff99_ot2_value}    ${product_name}
    ...    ${assoc_charges_vatgst_amount}    ${assoc_charges_other_related_no}    ${assoc_charges_vendor_ref_no}
    Set Suite Variable    ${assoc_charges_row${row_id.lower()}}    ${assoc_charges_row}
    Log List    ${assoc_charges_row}

Generate Remarks Data For Specific Associated Charge Row For CC
    [Arguments]    ${row_id}
    Calculate Merchant Fee In Associated Charges For Remarks
    Calculate VAT In Associated Charges For Remarks
    Calculate VAT For Merchant Fee In Associated Charges For Remarks
    ${assoc_charges_commission}    Round Off    ${assoc_charges_commission}
    ${assoc_charges_gross_sell}    Round Off    ${assoc_charges_gross_sell}
    Get Vendor Code For India    ${assoc_charges_product}    ${assoc_charges_vendor}
    Get Associated Charges Product Code And GST And OT1 And OT2    ${assoc_charges_product}
    ${year}    Convert To String    ${assoc_charges_expiry_year}
    ${split_year}    Get Substring    ${year}    2    4
    @{assoc_charges_row}    Create List    ${product_code}    ${current_vendor_code}    ${assoc_charges_gross_sell}    ${assoc_charges_commission}    ${gst}
    ...    ${assoc_charges_remarks_gst_value}    ${ot1}    ${assoc_charges_remarks_ff99_ot1_value}    ${ot2}    ${assoc_charges_remarks_ff99_ot2_value}    ${assoc_charges_fop_type}
    ...    ${assoc_charges_cc_type}    ${assoc_charges_card_number}    ${assoc_charges_expiry_month}    ${split_year}    ${assoc_charges_vatgst_amount}    ${assoc_charges_merchant_fee}
    ...    ${assoc_charges_total_selling_price}    ${assoc_charges_merchant_gst}    ${assoc_charges_merchant_ot1}    ${assoc_charges_merchant_gst_value}    ${assoc_charges_merchant_ot1_calvalue}    ${assoc_charges_merchant_ot2_calvalue}
    ...    ${assoc_charges_vat_total_calvalue}    ${assoc_charges_other_related_no}    ${assoc_charges_vendor_ref_no}
    Set Suite Variable    ${assoc_charges_row${row_id.lower()}}    ${assoc_charges_row}
    Set Suite Variable    ${assoc_charges_split_year}    ${split_year}
    Set Suite Variable    ${assoc_charges_row}
    Log List    ${assoc_charges_row}

Generate Remarks Data For Specific Charges Row BTC
    [Arguments]    ${row_id}
    ${charges_commission}    Round Apac    ${charges_commission}    IN
    ${charges_gross_sell}    Round Apac    ${charges_gross_sell}    IN
    Get Charges Product Code And GST And OT1 And OT2    ${product}
    Get Charges Vendor Code    ${product}    ${vendor}
    @{charges_row}    Create List    ${product_code}    ${current_os_vendor_code}    ${charges_gross_sell}    ${charges_commission}    ${gst}
    ...    ${charges_remarks_gst_value}    ${ot1}    ${charges_remarks_ff99_ot1_value}    ${ot2}    ${charges_remarks_ff99_ot2_value}    ${product}
    ...    ${charges_vatgst_amount}    ${charges_other_related_no}    ${charges_vendor_ref_no}
    Set Suite Variable    ${charges_row${row_id.lower()}}    ${charges_row}
    Log List    ${charges_row}

Generate Remarks Data For Specific Charges Row For CC
    [Arguments]    ${row_id}
    Calculate Merchant Fee In Charges For Remarks
    Calculate VAT In Charges For Remarks
    Calculate VAT For Merchant Fee In Charges For Remarks
    ${charges_commission}    Round Off    ${charges_commission}
    ${charges_gross_sell}    Round Off    ${charges_gross_sell}
    Get Charges Product Code And GST And OT1 And OT2    ${product}
    Get Charges Vendor Code    ${product}    ${vendor}
    ${year}    Convert To String    ${charges_expiry_year}
    ${split_year}    Get Substring    ${year}    2    4
    @{charges_row}    Create List    ${product_code}    ${current_os_vendor_code}    ${charges_gross_sell}    ${charges_commission}    ${gst}
    ...    ${charges_remarks_gst_value}    ${ot1}    ${charges_remarks_ff99_ot1_value}    ${ot2}    ${charges_remarks_ff99_ot2_value}    ${charges_fop_type}
    ...    ${charges_cc_type}    ${charges_card_number}    ${charges_expiry_month}    ${split_year}    ${charges_vatgst_amount}    ${charges_merchant_fee}
    ...    ${charges_total_selling_price}    ${charges_merchant_gst}    ${charges_merchant_ot1}    ${charges_merchant_gst_value}    ${charges_merchant_ot1_calvalue}    ${charges_merchant_ot2_calvalue}
    ...    ${charges_vat_total_calvalue}    ${charges_other_related_no}    ${charges_vendor_ref_no}    ${charges_vat_for_merchfee_calvalue}
    Set Suite Variable    ${charges_row${row_id.lower()}}    ${charges_row}
    Set Suite Variable    ${charges_row}
    Set Suite Variable    ${charges_split_year}    ${split_year}
    Log List    ${charges_row}

Get Additional Information Date
    Wait Until Control Object Is Visible    [NAME:mskTextDate]
    ${date}    Get Control Text Value    [NAME:mskTextDate]    ${title_power_express}
    Set Test Variable    ${date}

Get Address From Vendor Info Tab
    ${address}    Get Control Text Value    [NAME:AddressTextBox]
    Set Suite Variable    ${address}

Get Address Of House
    ${object}    Determine Multiple Object Name Based On Active Tab    AddressHouseBldgTextBox    False
    ${address_of_house}    Get Control Text Value    ${object}
    Set Suite Variable    ${address_of_house}

Get Air Segment
    ${air_segment}    Get Control Text Value    [NAME:Request_AirSegmentsComboBox]
    Set Suite Variable    ${air_segment}
    ${air_segment_w/o_seg_no}    Get String Matching Regexp    \\\s\\\w{2}\\\s(\\\d+)\\\D{1}\\\s\\\d{2}\\\D{3}\\\s\\\D{6}\\\s\\\D{2}\\\d{1}    ${air_segment}
    Set Suite Variable    ${air_segment_w/o_seg_no}
    Log    ${air_segment_w/o_seg_no}

Get Air Segment Dropdown Values
    [Arguments]    ${flight_index}=0
    [Documentation]    Pass a ${flight_index} argument to get a specific air segment. Valid flight index starts at 1. '0' is for blank value.
    ${air_segment_list}    Get Dropdown Values    [NAME:Request_AirSegmentsComboBox]
    ${has_segments}    Get Length    ${air_segment_list}
    ${has_segments}    Set Variable If    ${has_segments} > 1    True    False
    Log    KW: Get Air Segment Dropdown Values\nInfo: This PNR has segments is ${has_segments}
    Run Keyword If    ${has_segments}    Remove Values From List    ${air_segment_list}    ${EMPTY}
    Run Keyword If    ${has_segments}    Sort List    ${air_segment_list}
    ${air_segment_list}    Set Variable If    '${has_segments}' == 'False'    ${EMPTY}    ${air_segment_list}
    Set Suite Variable    ${displayed_segment_list}    ${air_segment_list}
    ${specific_air_segment}    Set Variable If    ${has_segments}    ${displayed_segment_list[${flight_index}]}    ${displayed_segment_list}0
    Set Suite Variable    ${specific_air_segment}

Get Air Segments From The PNR
    ${segments}    Get Lines Using Regexp    ${pnr_details}    \\\s{2}\\\d{1,2}\\\s{2}\\\w+(\\\s)?\\\d+
    ${segments}    Split To Lines    ${segments}
    ${segments_list}    Create List
    : FOR    ${segment}    IN    @{segments}
    \    ${detail_1}    Get String Matching Regexp    \\\d{1,2}\\\s+?(\\\w{2}\\\s+?\\\d+|\\\w{2}\\\d+)    ${segment}
    \    ${detail_2}    Get String Matching Regexp    ((\\\s+\\\w\\\s+|\\\s\\\w\\\s)(\\\d+\\\w+))    ${segment}
    \    ${detail_3}    Get String Matching Regexp    (\\\s+\\\w{6}\\\s+)    ${segment}
    \    ${detail_4}    Get String Matching Regexp    (\\\s+[A-Z]{2}\\\d{1}\\\s+)    ${segment}
    \    ${detail_1}=    Evaluate    " ".join(${detail_1.split()})
    \    Append To List    ${segments_list}    ${detail_1}${detail_2.strip()}${detail_3.replace("*", " ")}${detail_4.strip()}
    Set Test Variable    ${segments_list}

Get All Exchange Order Remarks
    ${eo_remarks}    Get All Cell Values In Data Grid Table    [NAME:FromEoDataGridView]
    [Return]    ${eo_remarks}

Get All Itinerary Remarks
    ${list_itinerary_remarks}    Get All Cell Values In Data Grid Table    [NAME:FromIoDataGridView]
    [Return]    ${list_itinerary_remarks}

Get All Names In Insured Grid
    ${insured_data}    Get All Cell Values In Data Grid Table    [NAME:InsuredGridView]
    Log List    ${insured_data}
    ${name_collection}    Create List
    : FOR    ${row_data}    IN    @{insured_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${name_collection}    ${row_data[1:2]}
    Log List    ${name_collection}
    ${name_list}    Create List
    : FOR    ${name}    IN    @{name_collection}
    \    ${actual_name}    Run Keyword If    "${name}" != "[]"    Get From List    ${name}    0
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Run Keyword If    "${name}" != "[]" and "${name}" != "${EMPTY}"    Append To List    ${name_list}    ${actual_name}
    Log List    ${name_list}
    Set Suite Variable    ${name_list}

Get All Record In Exchange Order Grid
    ${eo_data}    Get All Cell Values In Data Grid Table    [NAME:EoGrid]
    Log List    ${eo_data}
    ${eo_collection}    Create List
    : FOR    ${row_data}    IN    @{eo_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${eo_collection}    ${row_data[3:]}
    [Return]    ${eo_collection}

Get All Record In Insured Grid
    ${insured_data}    Get All Cell Values In Data Grid Table    [NAME:InsuredGridView]
    Log List    ${insured_data}
    ${insured_collection}    Create List
    : FOR    ${row_data}    IN    @{insured_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${insured_collection}    ${row_data[1:]}
    Set Suite Variable    ${insured_collection}

Get All Record In Vendor Info Grid
    [Arguments]    ${identifier}
    ${vendor_info_collection}    Get All Records From Grid In Vendor Info Tab
    Set Suite Variable    ${vendor_info_collection${identifier.lower()}}    ${vendor_info_collection}
    Log List    ${vendor_info_collection${identifier.lower()}}

Get All Records From Grid In Vendor Info Tab
    ${vendor_data}    Get All Cell Values In Data Grid Table    [NAME:ContactTypeDataGridView]
    Log List    ${vendor_data}
    ${vendor_collection}    Create List
    : FOR    ${row_data}    IN    @{vendor_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${vendor_collection}    ${row_data[1:]}
    Log List    ${vendor_collection}
    [Return]    ${vendor_collection}

Get All Records In Associated Charges Grid
    ${associated_charges_data}    Get All Cell Values In Data Grid Table    [NAME:AssociatedCharges_AssociatedInfoGrid]
    Log List    ${associated_charges_data}
    ${associated_charges_collection}    Create List
    : FOR    ${row_data}    IN    @{associated_charges_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${associated_charges_collection}    ${row_data[1:]}
    Log List    ${associated_charges_collection}
    [Return]    ${associated_charges_collection}

Get Area
    ${object}    Determine Multiple Object Name Based On Active Tab    AreaTextBox    False
    ${area}    Get Control Text Value    ${object}
    Set Suite Variable    ${area}

Get Arrival Date
    ${object}    Determine Multiple Object Name Based On Active Tab    ArrivalDateTextBox    False
    ${arrival_date}    Get Control Text Value    ${object}
    Set Suite Variable    ${arrival_date}

Get Assignee Name
    ${object}    Determine Multiple Object Name Based On Active Tab    AssigneeNameTextBox    False
    ${assignee_name}    Get Control Text Value    ${object}
    Set Suite Variable    ${assignee_name}

Get Associated Charges Field Values
    [Arguments]    ${row_id}
    Get Product In Associated Charges
    Get Vendor In Associated Charges
    Get Cost Amount In Associated Charges
    Get Commission In Associated Charges
    Get Discount In Associated Charges
    Get Gross Sell In Associated Charges
    Get VAT/GST Amount In Associated Charges
    Get Merchant Fee In Associated Charges
    Get Total Selling Price In Associated Charges
    Get Description In Associated Charges
    Get CWT Reference No (TK) In Associated Charges
    Get Vendor Reference No (GSA) In Associated Charges
    Get Other Related No (PO) In Associated Charges
    Get Form Of Payment Type In Associated Charges
    #Generate Data For A Specific Row From Grid
    Run Keyword If    "${assoc_charges_fop_type}"=="Credit Card (CC)"    Get CC Type In Associated Charges
    Run Keyword If    "${assoc_charges_fop_type}"=="Credit Card (CC)"    Get Card Number In Associated Charges
    Run Keyword If    "${assoc_charges_fop_type}"=="Credit Card (CC)"    Get Expiry Month In Associated Charges
    Run Keyword If    "${assoc_charges_fop_type}"=="Credit Card (CC)"    Get Expiry Year In Associated Charges
    ${assoc_charges_cc_type}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_cc_type}
    ${assoc_charges_card_number}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_card_number}
    ${assoc_charges_expiry_month}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_expiry_month}
    ${assoc_charges_expiry_year}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    ${EMPTY}    ${assoc_charges_expiry_year}
    ${assoc_charges_fop_type}    Set Variable If    '${assoc_charges_fop_type.lower()}'=='btc'    S    CC
    ${expiry_date}    Set Variable If    "${assoc_charges_fop_type.lower}" != "btc"    ${assoc_charges_expiry_month}/${assoc_charges_expiry_year}    ${EMPTY}
    @{associated_charges_row}    Create List    ${assoc_charges_product}    ${assoc_charges_vendor}    ${assoc_charges_cost_amount}    ${assoc_charges_commission}    ${assoc_charges_discount}
    ...    ${assoc_charges_vendor_ref_no}    ${assoc_charges_other_related_no}    ${assoc_charges_fop_type}    ${assoc_charges_cc_type}    ${assoc_charges_card_number}    ${expiry_date}
    ...    ${assoc_charges_vatgst_amount}    ${assoc_charges_merchant_fee}    ${assoc_charges_total_selling_price}
    Set Suite Variable    ${associated_charges_row${row_id}}    ${associated_charges_row}
    Set Suite Variable    ${associated_charges_collection${row_id.lower()}}    ${associated_charges_row}

Get Associated Charges Product Code And GST And OT1 And OT2
    [Arguments]    ${product_name}
    Open Excel    ${product_vendor_sg_hk_in}    \    #${product_vendor_sg_hk_in}
    ${row_count}    Get Row Count    Product SGHKIN
    ${product_code}    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    ${row_count}
    \    #verify prod name matches currentrod
    \    ${current_product}    Read Cell Data By Coordinates    Product SGHKIN    2    ${product_pointer}
    \    Run Keyword If    '${product_name.lower()}' == '${current_product.lower()}'    Exit For Loop
    ${current_pcode}    Read Cell Data By Coordinates    Product SGHKIN    1    ${product_pointer}
    ${gst}    Read Cell Data By Coordinates    Product SGHKIN    5    ${product_pointer}
    ${ot1}    Read Cell Data By Coordinates    Product SGHKIN    10    ${product_pointer}
    ${ot2}    Read Cell Data By Coordinates    Product SGHKIN    11    ${product_pointer}
    ${assoc_charges_remarks_gst_value}    Evaluate    ${gst}*0.01*${assoc_charges_gross_sell}
    ${assoc_charges_remarks_gst_value}    Round Apac    ${assoc_charges_remarks_gst_value}    IN
    ${assoc_charges_remarks_ff99_ot1_value}    Evaluate    ${ot1}*0.01*${assoc_charges_gross_sell}
    ${assoc_charges_remarks_ff99_ot1_value}    Round Apac    ${assoc_charges_remarks_ff99_ot1_value}    IN
    ${assoc_charges_remarks_ff99_ot2_value}    Evaluate    ${ot2}*0.01*${assoc_charges_gross_sell}
    ${assoc_charges_remarks_ff99_ot2_value}    Round Apac    ${assoc_charges_remarks_ff99_ot2_value}    IN
    ${product_code}    Set Variable    ${current_pcode}
    Set Suite Variable    ${gst}
    Set Suite Variable    ${ot1}
    Set Suite Variable    ${ot2}
    Set Suite Variable    ${product_name}
    Set Suite Variable    ${product_code}
    Set Suite Variable    ${assoc_charges_remarks_gst_value}
    Set Suite Variable    ${assoc_charges_remarks_ff99_ot1_value}
    Set Suite Variable    ${assoc_charges_remarks_ff99_ot2_value}
    Log    Product Code is ${product_code}

Get Attention From Vendor Info Tab
    ${attention}    Get Control Text Value    [NAME:AttentionTextBox]
    Set Suite Variable    ${attention}

Get BTA Description
    Wait Until Control Object Is Visible    [NAME:BtaDescriptionTextBox]
    ${bta_description}    Get Control Text Value    [NAME:BtaDescriptionTextBox]    ${title_power_express}
    ${bta_description}    Convert To Uppercase    ${bta_description}
    Set Suite Variable    ${bta_description}

Get CC Number
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardNumberTextBox, CreditCardNumberTextBox,CreditCardNumberTextbox    False
    ${cc_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${cc_number_${identifier}}    ${cc_number}

Get CC Preference
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardPreferenceComboBox, CreditCardPreferenceComboBox    False
    ${cc_preference}    Get Control Text Value    ${object}
    Set Suite Variable    ${cc_preference}

Get CC Preference In Request Tab
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardPreferenceComboBox    False
    ${cc_preference}    Get Control Text Value    ${object}    ${title_power_express}
    Set Suite Variable    ${cc_preference}

Get CC Type
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardTypesComboBox, CreditCardTypesComboBox,Charges_FopVendorComboBox,CreditCardTypeCombobox    False
    ${cc_type}    Get Control Text Value    ${object}
    Set Suite Variable    ${cc_type_${identifier}}    ${cc_type}

Get CC Type In Associated Charges
    ${assoc_charges_cc_type}    Get Control Text Value    [NAME:AssociatedCharges_FopVendorComboBox]
    Set Suite Variable    ${assoc_charges_cc_type}

Get CC Type In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_FopVendorComboBox    False
    ${charges_cc_type}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_cc_type}

Get CWT Email From Vendor Info Tab
    ${cwt_email}    Get Control Text Current Value    [NAME:EmailTextBox]
    Set Suite Variable    ${cwt_email}

Get CWT Phone From Vendor Info Tab
    ${cwt_phone}    Get Control Text Current Value    [NAME:ContactNumberTextBox]
    Set Suite Variable    ${cwt_phone}

Get Cancel By
    Get Cancel By Radio Button Status
    Get Cancel By Text
    Get Cancel By UOM
    @{cancel_by}    Create List    ${cancel_by_status}    ${cancel_by_text}    ${cancel_by_uom}
    Set Suite Variable    ${cancel_by}

Get Cancel By Radio Button Status
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByRadioButton, CancelByRadioButton    False
    ${cancel_by_status}    Get Radio Button Status    ${object}
    ${cancel_by_status}    Convert To String    ${cancel_by_status}
    Set Suite Variable    ${cancel_by_status}

Get Cancel By Text
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByAmountTextBox, CancelByAmountTextBox    False
    ${cancel_by_text}    Get Control Text Value    ${object}
    Set Suite Variable    ${cancel_by_text}

Get Cancel By UOM
    ${object}    Determine Multiple Object Name Based On Active Tab    SelectedCancelByTypeComboBox, Request_CancelByTypeComboBox    False
    ${cancel_by_uom}    Get Control Text Value    ${object}
    Set Suite Variable    ${cancel_by_uom}

Get Cancellation Policy
    Get Cancel By
    Get Special Rate, No Cancellation
    Get Others
    @{cancellation_policy_info}    Combine Lists    ${cancel_by}    ${special_rate_no_cancellation}    ${others}
    Set Suite Variable    ${cancellation_policy_info}

Get Car Segment
    ${car_segment}    Get Control Text Value    [NAME:CarSegmentsComboBox]
    Set Suite Variable    ${car_segment}
    Run Keyword If    '${car_segment[1]}'=='${SPACE}'    Set Test Variable    ${car_segment_number}    ${car_segment[0]}
    ...    ELSE    Set Test Variable    ${car_segment_number}    ${car_segment[:2]}
    ${car_segment_number}=    Convert To Integer    ${car_segment_number}
    Run Keyword If    ${car_segment_number} > 0    Set Suite Variable    ${car_segment_flag}    1
    Set Suite Variable    ${car_segment_number}
    Set Suite Variable    ${hotel_segment_flag}    0

Get Car Type
    ${car_type}    Get Control Text Value    [NAME:CarTypeTextBox]
    Set Suite Variable    ${car_type}

Get Card Number
    Wait Until Control Object Is Visible    [NAME:FormsOfPaymentComboBox]
    ${card_number}    Get Control Text Value    [NAME:FormsOfPaymentComboBox]    ${title_power_express}
    Set Test Variable    ${card_number}

Get Card Number In Associated Charges
    ${assoc_charges_card_number}    Get Control Text Value    [NAME:AssociatedCharges_ValueMaskedTextBox]
    Set Suite Variable    ${assoc_charges_card_number}

Get Card Number In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ValueMaskedTextBox,Charges_CardNumberTextBox    False
    ${charges_card_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_card_number}

Get Card Vendor Type
    Wait Until Control Object Is Visible    [NAME:FopVendorComboBox]
    ${card_vendor_type}    Get Control Text Value    [NAME:FopVendorComboBox]    ${title_power_express}
    Set Test Variable    ${card_vendor_type}

Get Charges Field Values For BTC
    Get Product
    Get Vendor
    Get Discount In Charges
    Get Cost Amount In Charges
    Get Commission In Charges
    Get Gross Sell In Charges
    Get VAT/GST Amount In Charges
    Get Merchant Fee In Charges
    Get Total Selling Price In Charges
    Get Form Of Payment Type In Charges
    Get Description In Charges
    Get CWT Reference No (TK) In Charges
    Get Vendor Reference No (GSA) In Charges
    Get Other Related No (PO) In Charges

Get Charges Product Code And GST And OT1 And OT2
    [Arguments]    ${product_name}
    Open Excel    ${product_vendor_sg_hk_in}
    ${row_count}    Get Row Count    Product SGHKIN
    ${product_code}    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    ${row_count}
    \    #verify prod name matches currentrod
    \    ${current_product}    Read Cell Data By Coordinates    Product SGHKIN    2    ${product_pointer}
    \    Run Keyword If    '${product_name.lower()}' == '${current_product.lower()}'    Exit For Loop
    ${current_pcode}    Read Cell Data By Coordinates    Product SGHKIN    1    ${product_pointer}
    ${gst}    Read Cell Data By Coordinates    Product SGHKIN    5    ${product_pointer}
    ${ot1}    Read Cell Data By Coordinates    Product SGHKIN    10    ${product_pointer}
    ${ot2}    Read Cell Data By Coordinates    Product SGHKIN    11    ${product_pointer}
    ${charges_remarks_gst_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Evaluate    ${gst}*0.01*${charges_gross_sell}
    ${charges_remarks_gst_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Round Apac    ${charges_remarks_gst_value}    IN
    ${charges_remarks_ff99_ot1_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Evaluate    ${ot1}*0.01*${charges_gross_sell}
    ${charges_remarks_ff99_ot1_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Round Apac    ${charges_remarks_ff99_ot1_value}    IN
    ${charges_remarks_ff99_ot2_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Evaluate    ${ot2}*0.01*${charges_gross_sell}
    ${charges_remarks_ff99_ot2_value}    Run Keyword If    "${product_name.lower()}"!="air bsp" and "${product_name.lower()}"!="air domestic" and "${product_name.lower()}"!="air bsp add on" and "${product_name.lower()}"!="air dom add on" and "${product_name.lower()}"!="air conso-dom" and "${product_name.lower()}"!="air sales-non bsp int"    Round Apac    ${charges_remarks_ff99_ot2_value}    IN
    ${product_code}    Set Variable    ${current_pcode}
    Get Charges Vendor Code    ${product_name}    ${vendor}
    Set Suite Variable    ${gst}
    Set Suite Variable    ${ot1}
    Set Suite Variable    ${ot2}
    Set Suite Variable    ${product_name}
    Set Suite Variable    ${product_code}
    Set Suite Variable    ${charges_remarks_gst_value}
    Set Suite Variable    ${charges_remarks_ff99_ot1_value}
    Set Suite Variable    ${charges_remarks_ff99_ot2_value}
    Set Suite Variable    ${product_code}
    Log    Product Code is ${product_code}

Get Charges Vendor Code
    [Arguments]    ${product_name}    ${vendor}
    Open Excel    ${product_vendor_sg_hk_in}
    ${row_count1}    Get Row Count    Product SGHKIN
    ${row_count2}    Get Row Count    Vendor IN
    ${product_code}    Set Variable    ${EMPTY}
    ${vendor_code}    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    ${row_count1}
    \    ${current_product}    Read Cell Data By Coordinates    Product SGHKIN    2    ${product_pointer}
    \    Run Keyword If    '${product_name.lower()}' == '${current_product.lower()}'    Exit For Loop
    : FOR    ${vendor_pointer}    IN RANGE    ${row_count2}
    \    ${current_os_vendor_code}    Read Cell Data By Coordinates    Vendor IN    2    ${vendor_pointer}
    \    ${current_vendor}    Read Cell Data By Coordinates    Vendor IN    3    ${vendor_pointer}
    \    Run Keyword If    "${current_product.lower()}" == "${product_name.lower()}" and "${current_vendor.lower()}" == "${vendor.lower()}"    Exit For Loop
    Set Suite Variable    ${current_os_vendor_code}
    Log    Vendor Code is ${current_os_vendor_code}

Get Checkbox Status of CWT Absorb For GST
    ${is_visible}    Is Control Visible    [NAME:GstAbsorbCheckBox]
    ${is_visible_string}    Set Variable If    ${is_visible} == True    True    False
    ${gst_absorb_checkbox_status_bool}=    Run Keyword If    "${is_visible_string.upper()}" == "TRUE"    Get Checkbox State    [NAME:GstAbsorbCheckBox]
    ...    ELSE    Set Variable    False
    ${gst_absorb_checkbox_status}=    Evaluate    str(${gst_absorb_checkbox_status_bool})
    Set Test Variable    ${gst_absorb_checkbox_status}

Get Checkbox Status of CWT Absorb For Mechant Fee
    ${is_visible}    Is Control Visible    [NAME:MerchantFeeAbsorbCheckBox]
    ${is_visible_string}    Evaluate    str(${is_visible})
    ${merchant_fee_absorb_checkbox_status_bool}=    Run Keyword If    "${is_visible_string.upper()}" == "TRUE"    Get Checkbox State    [NAME:MerchantFeeAbsorbCheckBox]
    ...    ELSE    Set Variable    False
    ${merchant_fee_absorb_checkbox_status}=    Evaluate    str(${merchant_fee_absorb_checkbox_status_bool})
    Set Test Variable    ${merchant_fee_absorb_checkbox_status}

Get Checkin Date
    ${checkin_date}    Get Control Text Value    [NAME:Request_CheckinDateDatePicker]
    Set Suite Variable    ${checkin_date}
    Log    ${checkin_date}

Get Checkout Date
    ${checkout_date}    Get Control Text Value    [NAME:Request_CheckoutDateDatePicker]
    Set Suite Variable    ${checkout_date}

Get City
    ${object}    Determine Multiple Object Name Based On Active Tab    CityComboBox, Request_CityNameTextBox,Request_CityCodeTextBox    False
    ${city_code}    Get Control Text Value    ${object}
    Set Suite Variable    ${city_code}
    ${city_name}    Get Equivalent City Name    ${city_codes_and_names}    ${city_code}
    Set Suite Variable    ${city_name}

Get City Code
    ${city_code}    Get Control Text Value    [NAME:Request_CityCodeTextBox]
    Set Suite Variable    ${city_code}

Get City From Vendor Info Tab
    ${city}    Get Control Text Value    [NAME:CityTextBox]
    Set Suite Variable    ${city}

Get City In Request Tab For Meet & Greet Product
    Wait Until Control Object Is Visible    [NAME:CityComboBox]
    ${city}    Get Control Text Value    [NAME:CityComboBox]
    Set Suite Variable    ${city}

Get City Name In Request
    ${city_name}    Get Control Text Value    [NAME:Request_CityNameTextBox]
    Set Suite Variable    ${city_name}

Get Commission
    [Arguments]    ${identifier}=${EMPTY}
    Comment    Wait Until Control Object Is Visible    [NAME:CommisionTextBox]
    ${object}    Determine Multiple Object Name Based On Active Tab    CommisionTextBox,CommissionTextBox,Charges_CommisionTextBox,AssociatedCharges_CommisionTextBox,CommissionTextBox    False
    ${commission}    Get Control Text Value    ${object}    ${title_power_express}
    Set Suite Variable    ${commission}
    Set Suite Variable    ${commission_${identifier}}    ${commission}

Get Company
    ${object}    Determine Multiple Object Name Based On Active Tab    CompaniesComboBox    False
    ${company}    Get Control Text Value    ${object}
    Set Suite Variable    ${company}

Get Confirmation Number
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_ConfirmationNumberTextBox, ConfirmationNumberTextBox    False
    ${confirmation_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${confirmation_number}

Get Contact Type From Vendor Info Tab
    ${contact_type}    Get Control Text Value    [NAME:ContactTypeComboBox]
    Set Suite Variable    ${contact_type}

Get Country From Vendor Info Tab
    ${country}    Get Control Text Current Value    [NAME:CountryTextBox]
    Set Suite Variable    ${country}

Get Country In Request
    ${country_visa}    Get Control Text Value    [NAME:CountryComboBox]
    Set Suite Variable    ${country_visa}

Get Credit Card Details In Request Tab
    Get CC Number
    Get CC Preference
    Get CC Type
    Get Expiry Date In Request
    @{cc_info}    Create List    ${cc_number}    ${cc_preference}    ${cc_type}    ${cc_expiry_date}
    Set Suite Variable    ${cc_info}
    [Return]    @{cc_info}

Get Credit Card Vendor Code
    [Arguments]    ${card_vendor_type}
    Comment    Get Card Vendor Type
    ${credit_vendor_code}    Set Variable If    '${card_vendor_type}' == 'AX'    CX2    '${card_vendor_type}' == 'TP'    CX5    '${card_vendor_type}' == 'DC'
    ...    CX3    '${card_vendor_type}' == 'VI' or '${card_vendor_type}' == 'CA' or '${card_vendor_type}' == 'MC' or '${card_vendor_type}' == 'JC'    CX4    '${card_vendor_type.upper()}' == 'CASH' or '${card_vendor_type.upper()}' == 'INVOICE' or '${card_vendor_type.upper()}' == 'CASH/INVOICE' or '${card_vendor_type.upper()}' == '${EMPTY}'    Set Variable    FS
    ...    ELSE    INVALIDTYPE
    [Return]    ${credit_vendor_code}

Get Current Hotel Segments From The PNR For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}    RTH
    #Retrieve Active and Passive Hotel Segments in GDS Format
    ${segments}    Get Lines Using Regexp    ${pnr_details}    (\\\s+\\\d{1,2}\\\s.*)    #\\\s{2}\\\d{1,6}\\\s{1}\\\w+(\\\s)?.*$
    ${segments}    Split To Lines    ${segments}
    ${segments_nl}    Get Lines Using Regexp    ${pnr_details}    (\\\s{4}.*)
    ${segments_nl}    Split To Lines    ${segments_nl}
    ${segments_nl}=    Set Variable    ${segments_nl[1:]}
    Log    ${segments}
    Log    ${segments_nl}
    ${segments_list_from_pnr}    Create List
    ${index}=    Set Variable    0
    : FOR    ${segment}    IN    @{segments}
    \    Log    ${segment}
    \    Log    ${segments_nl[${index}]}
    \    Append To List    ${segments_list_from_pnr}    ${segment} ${segments_nl[${index}]}
    \    ${index}=    Evaluate    ${index}+1
    Log    ${segments_list_from_pnr}
    # Separated Active and Passive Hotel Segments List In GDS Format
    ${hhl_segments}    Create List
    ${htl_segments}    Create List
    : FOR    ${segment}    IN    @{segments_list_from_pnr}
    \    ${hhl_segment}    Get String Matching Regexp    (\\\d{1}\\\s+HHL\\\s+.*)    ${segment}
    \    Run Keyword If    '${hhl_segment}'!='0'    Append To List    ${hhl_segments}    ${hhl_segment}
    Log    ${hhl_segments}
    : FOR    ${segment}    IN    @{segments_list_from_pnr}
    \    ${htl_segment}    Get String Matching Regexp    (\\\d{1}\\\s+HTL\\\s+.*)    ${segment}
    \    Run Keyword If    '${htl_segment}'!='0'    Append To List    ${htl_segments}    ${htl_segment}
    Log    ${htl_segments}
    # Convert Active Hotel Segments To UI Format
    ${hhl_segments_list}    Create List
    : FOR    ${segment}    IN    @{hhl_segments}
    \    @{hhl_details_1}    Split String    ${segment}    /
    \    ${hhl_1}    Split String    ${hhl_details_1[0]}    ${SPACE}
    \    ${hhl_date}    Get String Matching Regexp    (\\\sIN\\\w{5}\\\s)    ${segment}
    \    ${hhl_date}    Replace String    ${hhl_date}    IN    ${EMPTY}
    \    Append To List    ${hhl_segments_list}    ${hhl_1[0]} ${hhl_1[2]} ${hhl_1[4]} ${hhl_date.strip()} ${hhl_1[11]} ${hhl_1[12]} ${hhl_1[13]}
    Set Suite Variable    ${hhl_segments_list}
    # Convert Passive Hotel Segment To UI Format
    ${htl_segments_list}    Create List
    : FOR    ${segment}    IN    @{htl_segments}
    \    @{htl_details_1}    Split String    ${segment}    /
    \    ${htl_1}    Split String    ${htl_details_1[0]}    ${SPACE}
    \    ${htl_2}    Set Variable    ${htl_details_1[1]}
    \    ${htl_date}    Get String Matching Regexp    (\\\s\\\w{5}-)    ${segment}
    \    ${htl_date}    Replace String    ${htl_date}    -    ${EMPTY}
    \    Append To List    ${htl_segments_list}    ${htl_1[0]} ${htl_1[2]} ${htl_1[4]} ${htl_date.strip()} ${htl_2}
    Set Suite Variable    ${htl_segments_list}
    @{hotel_segment_list}    Combine Lists    ${hhl_segments_list}    ${htl_segments_list}
    Sort List    ${hotel_segment_list}
    Remove Values From List    ${hotel_segment_list}    ${EMPTY}
    Log List    ${hotel_segment_list}
    Set Suite Variable    ${hotel_segment_list}

Get Current Segments From The PNR For IN
    ${segments}    Get Lines Using Regexp    ${pnr_details}    \\\d+\\\s{2}\\\w+(\\\s)?\\\d+
    ${segments}    Split To Lines    ${segments}
    ${segments_list}    Create List
    #Create list for Active Segments
    @{active_segments_list}    Create List
    : FOR    ${segment}    IN    @{segments}
    \    ${flight_detail}    Get String Matching Regexp    (\\\s+\\\w{6}\\\s+\\\w{2}\\\d{1})    ${segment}
    \    ${status_code}    Get String Matching Regexp    \\\w{2}\\\d{1}    ${flight_detail}
    \    Run Keyword If    "${status_code}" == "HK1"    Append To List    ${active_segments_list}    ${segment}
    Log    ${active_segments_list}
    #Create list for Passive Segments
    @{passive_segments_list}    Create List
    : FOR    ${segment}    IN    @{segments}
    \    ${flight_detail}    Get String Matching Regexp    (\\\s+\\\w{6}\\\s+\\\w{2}\\\d{1})    ${segment}
    \    ${status_code}    Get String Matching Regexp    \\\w{2}\\\d{1}    ${flight_detail}
    \    Run Keyword If    "${status_code}" == "GK1"    Append To List    ${passive_segments_list}    ${segment}
    Log    ${passive_segments_list}
    #Convert Active Segments to UI format
    @{converted_active_segments_list}    Create List
    : FOR    ${segment}    IN    @{active_segments_list}
    \    ${detail_1}    Get String Matching Regexp    \\\d{1,2}\\\s+?\\\w{2}\\\s\\\d+    ${segment}
    \    ${detail_2}    Get String Matching Regexp    ((\\\s+\\\w\\\s+|\\\s\\\w\\\s)(\\\d+\\\w+))    ${segment}
    \    ${detail_3}    Get String Matching Regexp    (\\\s+\\\w{6}\\\s+\\\w{2}\\\d{1})    ${segment}
    \    Append To List    ${converted_active_segments_list}    ${detail_1.strip()}${detail_2.strip()} ${detail_3.strip()}
    Log    ${converted_active_segments_list}
    #Convert Passive Segments to UI format
    @{converted_passive_segments_list}    Create List
    : FOR    ${segment}    IN    @{passive_segments_list}
    \    ${detail_1}    Get String Matching Regexp    \\\d{1,2}\\\s+?\\\w{2}\\\d+\\\s[A-Z]    ${segment}
    \    ${detail_2}    Get String Matching Regexp    \\\d+\\\s+\\\w{2}    ${detail_1}
    \    ${detail_3}    Get String Matching Regexp    \\\d{4}\\\s\\\D{1}    ${detail_1}
    \    ${detail_4}    Get String Matching Regexp    \\\d+    ${detail_3}
    \    ${detail_5}    Get String Matching Regexp    ((\\\s+\\\w\\\s+|\\\s\\\w\\\s)(\\\d+\\\w+))    ${segment}
    \    ${detail_6}    Get String Matching Regexp    (\\\s+\\\w{6}\\\s+\\\w{2}\\\d{1})    ${segment}
    \    Append To List    ${converted_passive_segments_list}    ${detail_2.strip()} ${detail_4.strip()}${detail_5.strip()} ${detail_6.strip()}
    Log    ${converted_passive_segments_list}
    @{segments_list}    Combine Lists    ${converted_active_segments_list}    ${converted_passive_segments_list}
    Sort List    ${segments_list}
    Log    ${segments_list}
    Set Suite Variable    ${segments_list}

Get Daily Rate
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_DailyRateCurrencyComboBox, DailyRateCurrencyComboBox    False
    ${daily_rate}    Get Control Text Value    ${object}
    Set Suite Variable    ${daily_rate}

Get Daily Rate Amount
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_DailyRateAmountTextBox, DailyRateAmountTextBox    False
    ${daily_rate_amount}    Get Control Text Value    ${object}
    Set Suite Variable    ${daily_rate_amount}

Get Date And Time
    [Arguments]    ${date_id}=0    ${time_id}=0
    ${date_value}    Get Control Text Value    ${date_id}
    ${time_value}    Get Control Text Value    ${time_id}
    [Return]    ${date_value}    ${time_value}

Get Date In Request Tab For Meet & Greet Product
    Wait Until Control Object Is Visible    [NAME:DateDatePicker]
    ${date}    Get Control Text Value    [NAME:DateDatePicker]
    Set Suite Variable    ${date}

Get Date Of Application
    ${date_of_application}    Get Control Text Value    [NAME:DateOfApplicationTextBox]
    Set Suite Variable    ${date_of_application}

Get Date Of Birth
    ${object}    Determine Multiple Object Name Based On Active Tab    DateOfBirthTextBox    False
    ${date_of_birth}    Get Control Text Value    ${object}
    Set Suite Variable    ${date_of_birth}

Get Demand Draft Number
    ${demand_draft_number}    Get Control Text Value    [NAME:DemandDraftNumberTextBox]
    Set Suite Variable    ${demand_draft_number}

Get Demand Draft Required
    ${demand_draft_required}    Get Control Text Value    [NAME:DemandDraftRequiredComboBox]
    Set Suite Variable    ${demand_draft_required}

Get Departure Date
    ${object}    Determine Multiple Object Name Based On Active Tab    DepartureDateTextBox    False
    ${departure_date_insurance}    Get Control Text Value    ${object}
    Set Suite Variable    ${departure_date_insurance}

Get Details
    Activate Power Express Window
    ${details}    Get Control Text Current Value    [NAME:DetailsTextBox]
    Set Suite Variable    ${details}

Get Details For Non Air Products
    [Documentation]    This Keyword can be used For The Below Non-Air Other Services
    ...    • Despatch
    ...    • Ets Call Charges
    ...    • Ferry
    ...    • Merchant fee
    ...    • Mice Domestic
    ...    • MICE international
    ...    • Oths handling Fee
    ...    • Rebate
    ...    • Tour Domestic
    ...    • Transaction Fee-Air only
    ...    • VAT
    ${object}    Determine Multiple Object Name Based On Active Tab    Details1TextBox    False
    ${details1}    Get Control Text Value    ${object}
    Set Suite Variable    ${details1}
    ${object}    Determine Multiple Object Name Based On Active Tab    Details2TextBox    False
    ${details2}    Get Control Text Value    ${object}
    Set Suite Variable    ${details2}
    ${object}    Determine Multiple Object Name Based On Active Tab    Details3TextBox    False
    ${details3}    Get Control Text Value    ${object}
    Set Suite Variable    ${details3}

Get Doc Type
    ${doc_type}    Get Control Text Value    [NAME:DocTypeComboBox]
    Set Suite Variable    ${doc_type}

Get Document
    ${document}    Get Control Text Value    [NAME:DocumentComboBox]
    Set Suite Variable    ${document}

Get DropOff Location
    ${object}    Determine Multiple Object Name Based On Active Tab    DropOffLocationsComboBox    False
    ${dropoff_location}    Get Control Text Value    ${object}
    Set Suite Variable    ${dropoff_location}

Get Dropoff Location Text
    ${object}    Determine Multiple Object Name Based On Active Tab    PickupLocationTextTextBox, DropOffLocationTextTextBox    False
    ${dropoff_location_text}    Get Control Text Value    ${object}
    Set Suite Variable    ${dropoff_location_text}

Get Employee Name
    ${object}    Determine Multiple Object Name Based On Active Tab    EmployeeNameTextBox    False
    ${employee_name}    Get Control Text Value    ${object}
    Set Suite Variable    ${employee_name}

Get Employee Number
    ${object}    Determine Multiple Object Name Based On Active Tab    EmployeeNumberTextBox    False
    ${employee_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${employee_number}

Get End Date
    ${object}    Determine Multiple Object Name Based On Active Tab    EndDateDatePicker    False
    ${end_date}    Get Control Text Value    ${object}
    Set Suite Variable    ${end_date}

Get Exchange Order
    Wait Until Control Object Is Visible    [NAME:lblEndMessage]
    ${exchange_order}    Get Control Text Value    [NAME:lblEndMessage]    ${title_power_express}
    ${exchange_order_line}    Get Lines Containing String    ${exchange_order}    Exchange Order Number:
    ${exchange_order}    Fetch From Right    ${exchange_order_line}    :${SPACE}
    Set Suite Variable    ${exchange_order}

Get Exchange Order Number
    [Arguments]    ${identifier}=${EMPTY}    ${grid_column}=5
    @{eo_list}    Get Col Data From Eo Grid    ${grid_column}
    ${eo_list_len}    Get Length    ${eo_list}
    ${index_eo}    Set Variable    1
    : FOR    ${each_eo}    IN    @{eo_list}
    \    Set Suite Variable    ${eo_number_${index_eo}}    ${each_eo}
    \    ${index_eo}    Evaluate    ${index_eo}+1
    Set Suite Variable    ${eo_number}    ${eo_number_1}
    Set Suite Variable    ${eo_number_${identifier}}    ${eo_number}

Get Exchange Order Pop Up Message
    [Arguments]    ${click_ok}=True
    Wait Until Window Exists    Confirmation    timeout=8    retry_interval=4
    ${eo_pop_up_message}    Get Control Text Value    [CLASS:Static; INSTANCE:1]    Confirmation
    Run Keyword If    ${click_ok}    Send    {ENTER}
    [Return]    ${eo_pop_up_message}

Get Expected Last Amend Date
    ${date}    DateTime.Get Current Date    UTC    exclude_millis=True
    ${month}    Get Time    month    ${date}
    ${day}    Get Time    day    ${date}
    ${year}    Get Time    year    ${date}
    ${hour}    Get Time    hour    ${date}
    ${minute}    Get Time    minute    ${date}
    Set Suite Variable    ${expected_last_amend_date}    ${month}/${day}/${year} ${hour}:${minute}
    Log    Expected last amend date is: ${expected_last_amend_date}
    [Return]    ${expected_last_amend_date}

Get Expiry Date In Request
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_ExpiryDateDatePicker, ExpiryDateDatePicker    False
    ${cc_expiry_date}    Get Control Text Value    ${object}
    Set Suite Variable    ${cc_expiry_date}

Get Expiry Month In Associated Charges
    ${assoc_charges_expiry_month}    Get Control Text Value    [NAME:AssociatedCharges_ExpiryMonthComboBox]
    Set Suite Variable    ${assoc_charges_expiry_month}

Get Expiry Month In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ExpiryMonthComboBox    False
    ${charges_expiry_month}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_expiry_month}

Get Expiry Month In Other Services
    ${expiry_month}    Get Control Text Value    [NAME:ExpiryMonthComboBox]
    Set Test Variable    ${expiry_month}

Get Expiry Year In Associated Charges
    ${assoc_charges_expiry_year}    Get Control Text Value    [NAME:AssociatedCharges_ExpiryYearComboBox]
    Set Suite Variable    ${assoc_charges_expiry_year}

Get Expiry Year In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_ExpiryYearComboBox    False
    ${charges_expiry_year}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_expiry_year}

Get Expiry Year In Other Services
    ${expiry_year}    Get Control Text Value    [NAME:ExpiryYearComboBox]
    Set Test Variable    ${short_expiry_year}    ${expiry_year[2:4]}
    Set Test Variable    ${expiry_year}

Get Field Values On Visa Processing
    [Arguments]    ${visa_info_tab}
    Get Nett Cost In Other Services
    ${vendor_handling}    Get Control Text Value    [NAME:VendorHandlingTextBox]
    Set Test Variable    ${vendor_handling}
    ${cwt_handling}    Get Control Text Value    [NAME:CwtHandlingTextBox]
    Set Test Variable    ${cwt_handling}
    Log    ${cwt_handling}

Get Fields From Vendor Info Tab
    [Arguments]    ${identifier}
    Get Attention From Vendor Info Tab
    Get Vendor From Vendor Tab
    Get Address From Vendor Info Tab
    Get City From Vendor Info Tab
    Get Country From Vendor Info Tab
    Get CWT Email From Vendor Info Tab
    Get CWT Phone From Vendor Info Tab
    Get Contact Type From Vendor Info Tab
    Get Details
    Get Prefer From Vendor Info Tab
    Get All Record In Vendor Info Grid    ${identifier}
    ${expected_list}    Create List    ${attention}    ${address}    ${city}    ${country}    ${cwt_email}
    ...    ${cwt_phone}
    Set Suite Variable    ${expected_list${identifier.lower()}}    ${expected_list}
    Set Suite Variable    ${expected_list}

Get Form Of Payment
    Wait Until Control Object Is Visible    [NAME:FormsOfPaymentComboBox]
    ${form_of_payment}    Get Control Text Value    [NAME:FormsOfPaymentComboBox]    ${title_power_express}
    Set Suite Variable    ${form_of_payment}

Get Form Of Payment Field Values When FOP Is Cash
    Get Form Of Payment Type In Associated Charges

Get Form Of Payment Field Values When FOP Is Credit Card
    Get Form Of Payment Type In Associated Charges
    Get CC Type In Associated Charges
    Get Card Number In Associated Charges
    Get Expiry Month In Associated Charges
    Get Expiry Year In Associated Charges

Get Form Of Payment Fields Values Based On FOP Type
    [Arguments]    ${fop_type}
    [Documentation]    ${fop_type} = either cash or credit card
    Run Keyword And Continue On Failure    Run Keyword If    '${fop_type.lower()}'=='credit card'    Get Form Of Payment Field Values When FOP Is Credit Card
    ...    ELSE IF    '${fop_type.lower()}'=='cash'    Get Form Of Payment Field Values When FOP Is Cash

Get Form Of Payment In The PNR
    ${pnr_rtf}    Get Clipboard Data Amadeus    RTF
    Log    ${pnr_rtf}
    ${pnr_fp_line}    Get Lines Using Regexp    ${pnr_rtf}    \\\d+\\\sFP\\\s.\\*
    ${fop_type}    Fetch From Right    ${pnr_fp_line}    FP
    ${fop_type}    Remove All Spaces    ${fop_type}
    Log    ${fop_type}
    Set Suite Variable    ${fop_type}

Get Form Of Payment Type In Associated Charges
    ${assoc_charges_fop_type}    Get Control Text Value    [NAME:AssociatedCharges_FormOfPaymentComboBox]
    Set Suite Variable    ${assoc_charges_fop_type}

Get Form Of Payment Type In Charges
    ${charges_fop_type}    Get Control Text Value    [NAME:Charges_FormOfPaymentComboBox]
    Set Suite Variable    ${charges_fop_type}

Get GST
    ${is_visible}    Determine Control Object Is Visible On Active Tab    GSTTextBox    False
    ${gst}    Run Keyword If    "${is_visible.upper()}" == "TRUE"    Get Control Text Value    [NAME:GSTTextBox]
    ...    ELSE    Set Variable    0
    Set Test Variable    ${gst}

Get GST Percentage
    [Arguments]    ${country_code}    ${product_name}
    Open Excel    C:\\Python27\\ExcelRobotTest\\Consolidated ProductVendor_HKSG_UATProd.xls
    ${row_count} =    Get Row Count    Conso
    ${current_gst_percentage} =    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    ${row_count}
    \    ${current_cocode} =    Read Cell Data By Coordinates    Conso    0    ${product_pointer}
    \    ${current_product} =    Read Cell Data By Coordinates    Conso    1    ${product_pointer}
    \    ${current_gst_percentage} =    Read Cell Data By Coordinates    Conso    4    ${product_pointer}
    \    Run Keyword If    '${current_product.lower()}' == '${product_name.lower()}' and '${current_cocode.lower()}' == '${country_code.lower()}'    Exit For Loop
    ${current_gst_percentage} =    Set Variable If    '${current_gst_percentage}' == ''    0
    ${gst_percent}    Set Variable    ${current_gst_percentage}
    Set Test Variable    ${gst_percent}
    Log    GST is ${gst_percent}
    [Return]    ${gst_percent}

Get Gender
    ${object}    Determine Multiple Object Name Based On Active Tab    GenderTextBox    False
    ${gender}    Get Control Text Value    ${object}
    Set Suite Variable    ${gender}

Get Gross Sell
    [Arguments]    ${identifier}
    ${object}    Determine Multiple Object Name Based On Active Tab    GrossSellTextBox,Charges_GrossSellTextBox,AssociatedCharges_GrossSellTextBox    False
    ${gross_sell}    Get Control Text Value    ${object}    ${title_power_express}
    Set Suite Variable    ${gross_sell_${identifier}}    ${gross_sell}

Get Guarantee By
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_GuaranteedByComboBox, GuaranteedByComboBox    False
    ${guarantee_by}    Get Control Text Value    ${object}
    Set Suite Variable    ${guarantee_by}

Get Hotel Address
    ${hotel_address}    Get Control Text Value    [NAME:Request_HotelAddressTextBox]
    Set Suite Variable    ${hotel_address}

Get Hotel Name
    ${hotel_name}    Get Control Text Value    [NAME:Request_HotelNameTextBox]
    Set Suite Variable    ${hotel_name}

Get Hotel Segment
    ${hotel_segment}    Get Control Text Value    [NAME:Request_HotelSegmentsCombobox]
    Set Suite Variable    ${hotel_segment}
    ${hotel_segment_w/o_seg_no}    Get String Matching Regexp    \\\s\\\w+\\\s\\\D{3}\\\s\\\d{2}\\\w{3}\\\s.+    ${hotel_segment}
    Set Suite Variable    ${hotel_segment_w/o_seg_no}
    Log    ${hotel_segment_w/o_seg_no}
    Run Keyword If    '${hotel_segment[1]}'=='${SPACE}'    Set Test Variable    ${hotel_segment_number}    ${hotel_segment[0]}
    ...    ELSE    Set Test Variable    ${hotel_segment_number}    ${hotel_segment[:2]}
    ${hotel_segment_number}=    Convert To Integer    ${hotel_segment_number}
    Run Keyword If    ${hotel_segment_number} > 0    Set Suite Variable    ${hotel_segment_flag}    1
    Set Suite Variable    ${hotel_segment_number}
    Set Suite Variable    ${car_segment_flag}    0

Get Hotel Segment Dropdown Values
    [Arguments]    ${hotel_index}=0
    [Documentation]    Pass a ${hotel_index} argument to get a get a specific hotel segment.
    ${displayed_hotel_segment_list}    Get Dropdown Values    [NAME:Request_HotelSegmentsCombobox]
    Remove Values From List    ${displayed_hotel_segment_list}    ${EMPTY}
    Set Suite Variable    ${displayed_hotel_segment_list}
    Set Suite Variable    ${specific_hotel_segment}    ${displayed_hotel_segment_list[${hotel_index}]}

Get Hotel Segment Value
    ${hotel_segment}    Get Control Text Value    [NAME:Request_HotelSegmentsCombobox]
    Set Suite Variable    ${hotel_segment}

Get Hotel Segments From The PNR
    [Arguments]    ${pnr_hotel}
    Retrieve PNR Details from Amadeus    ${pnr_hotel}    RTH
    Log    Retrieve PNR Done
    Select Hotel Segment    1

Get In Conjunction With In Request Tab When Products Are Air BSp Or Air Domestic
    [Arguments]    ${identifier}
    ${in_conjunction_with}    Get Control Text Value    [NAME:InConjunctionWithTextbox]
    Set Suite Variable    ${in_conjunction_with_${identifier}}    ${in_conjunction_with}

Get India Service Info Field Values
    Get Vendor Contact
    Get Nett Cost In Other Services
    Get Commission
    Get Discount
    Get Gross Sell
    Get Vat GST Amount
    Get Merchant Fee In Other Services
    Get Total Selling Price
    Get Form Of Payment
    Get Card Vendor Type
    Get Card Number
    Get Expiry Month In Other Services
    Get Expiry Year In Other Services

Get Internal Remarks
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_InternalRemarksTextBox,InternalRemarksTextBox, DescriptionTextBox,    False
    ${internal_remarks}    Get Control Text Value    ${object}
    Set Suite Variable    ${internal_remarks}

Get Internal remarks In Request Tab For Meet & Greet Product
    Wait Until Control Object Is Visible    [NAME:InternalRemarksTextBox]
    ${internal_remarks}    Get Control Text Value    [NAME:InternalRemarksTextBox]
    Set Suite Variable    ${internal_remarks}

Get Issue In Exchange For In Request Tab When Products Are Air BSp Or Air Domestic
    [Arguments]    ${identifier}
    ${issue_in_exchange_for}    Get Control Text Value    [NAME:IssueInExchangeForTextbox]
    Set Suite Variable    ${issue_in_exchange_for_request_${identifier}}    ${issue_in_exchange_for}

Get Location
    ${object}    Determine Multiple Object Name Based On Active Tab    PickUpLocationsComboBox, DropOffLocationsComboBox    False
    ${location}    Get Control Text Value    ${object}
    [Return]    ${location}

Get Location Text
    ${object}    Determine Multiple Object Name Based On Active Tab    PickupLocationTextTextBox, DropOffLocationTextTextBox    False
    ${location_text}    Get Control Text Value    ${object}
    [Return]    ${location_text}

Get Locations In Request Tab For Meet & Greet Product
    Wait Until Control Object Is Visible    [NAME:LocationsTextBox]
    ${locations}    Get Control Text Value    [NAME:LocationsTextBox]
    Set Suite Variable    ${locations}

Get MF CWT Handling
    Wait Until Control Object Is Visible    [NAME:CwtHandlingMerchantTextBox]
    ${mf_cwt_handling}    Get Control Text Value    [NAME:CwtHandlingMerchantTextBox]    ${title_power_express}
    Set Test Variable    ${mf_cwt_handling}

Get MF Nett Cost
    Wait Until Control Object Is Visible    [NAME:NetCostMerchantTextBox]
    ${mf_nett_cost}    Get Control Text Value    [NAME:NetCostMerchantTextBox]    ${title_power_express}
    Set Test Variable    ${mf_nett_cost}

Get Marital Status
    ${object}    Determine Multiple Object Name Based On Active Tab    MaritalStatusTextBox    False
    ${marital_status}    Get Control Text Value    ${object}
    Set Suite Variable    ${marital_status}

Get Merchant Fee In Associated Charges
    ${assoc_charges_merchant_fee}    Get Control Text Value    [NAME:AssociatedCharges_MerchantFeeTextBox]
    Set Suite Variable    ${assoc_charges_merchant_fee}

Get Merchant Fee In Charges
    ${charges_merchant_fee}    Get Control Text Value    [NAME:Charges_MerchantFeeTextBox]
    Set Suite Variable    ${charges_merchant_fee}

Get Merchant Fee In Other Services
    [Arguments]    ${identifier}=${EMPTY}
    ${object}    Determine Multiple Object Name Based On Active Tab    MerchantFeeTextBox,MerchantTextBox    False
    ${merchant_fee}    Get Control Text Value    ${object}
    Set Test Variable    ${merchant_fee}
    Set Test Variable    ${merchant_fee_${identifier}}    ${merchant_fee}

Get Mobile Number
    ${object}    Determine Multiple Object Name Based On Active Tab    MobileNumberTextBox    False
    ${mobile_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${mobile_number}

Get Name
    [Arguments]    ${identifier}=${EMPTY}
    ${object}    Determine Multiple Object Name Based On Active Tab    NameTextBox,TrainNameTextBox    False
    ${name}    Get Control Text Value    ${object}
    Set Suite Variable    ${name}
    Set Suite Variable    ${name${identifier.lower()}}    ${name}

Get Nett Cost In Other Services
    ${nett_cost}    Get Control Text Value    [NAME:NetCostTextBox]
    Set Suite Variable    ${nett_cost}

Get Number Of Days
    ${number_of_days}    Get Control Text Value    [NAME:NumberOfDaysTextBox]
    Set Suite Variable    ${number_of_days}

Get Number Of People
    ${number_of_people}    Get Control Text Value    [NAME:Request_NumberOfPeopleTextBox]
    Set Suite Variable    ${number_of_people}

Get Number Of Records In Vendor Info Tab
    ${vendor_grid_value}    Get All Cell Values In Data Grid Table    [NAME:ContactTypeDataGridView]
    Log    ${vendor_grid_value}
    Comment    ${vendor_grid_value}    Get Length    ${vendor_grid_value}
    ${pointer}    Set Variable    0
    : FOR    ${X}    IN    @{vendor_grid_value}
    \    ${pointer}    Evaluate    ${pointer}+1
    \    Exit For Loop If    "${vendor_grid_value}"=="${pointer}"
    Run Keyword If    "${vendor_grid_value}"!="${EMPTY}"    Log    Grid Contains Data
    ${pointer}    Evaluate    ${pointer}-1
    Log    Number of records: ${pointer}

Get Original Place Of Issue In Request Tab When Products Are Air BSp Or Air Domestic
    [Arguments]    ${identifier}
    ${original_place_of_issue}    Get Control Text Value    [NAME:OriginalPlaceOfIssueTextbox]
    Set Suite Variable    ${original_place_of_issue_${identifier}}    ${original_place_of_issue}

Get Others
    ${object}    Determine Multiple Object Name Based On Active Tab    OthersRadioButton, Request_OthersRadioButton    False
    ${others_status}    Get Radio Button Status    ${object}
    ${others_status}    Convert To String    ${others_status}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByOthersDescriptionTextBox, CancelByOthersDescriptionTextBox    False
    ${others_text}    Get Control Text Value    ${object}
    @{others}    Create List    ${others_status}    ${others_text}
    Set Suite Variable    ${others}
    Set Suite Variable    ${others_status}

Get Package Name
    ${object}    Determine Multiple Object Name Based On Active Tab    PackageNameTextBox    False
    ${package_name}    Get Control Text Value    ${object}
    Set Suite Variable    ${package_name}

Get Passive Segment Number
    [Arguments]    ${date_dd_mmm}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    ${all_passive_segments}    Get Lines Using Regexp    ${pnr_details}    \\\d{1,2}\\\sMIS\\\s1A\\\sHK1\\\s\\\D{3}\\\s\\\d{1,2}\\\D{3}-TYP-\\\D{3}/SUC-\\\d+
    ${specific_passive_segments}    Get Lines Containing String    ${all_passive_segments}    ${current_vendor_code}
    ${final_passive_segment}    Get Lines Containing String    ${specific_passive_segments}    ${date_dd_mmm}
    ${split_final_passive_segment}    Split String    ${final_passive_segment}    MIS
    ${segment_number}    Get From List    ${split_final_passive_segment}    0
    Set Suite Variable    ${segment_number}
    Log    ${segment_number}

Get Passport Number
    ${object}    Determine Multiple Object Name Based On Active Tab    PassportNumberTextBox    False
    ${passport_number}    Get Control Text Value    ${object}
    Set Suite Variable    ${passport_number}

Get Phone Number
    ${phone_number}    Get Control Text Value    [NAME:Request_PhoneNumberTexBox]
    Set Suite Variable    ${phone_number}

Get Pickup Location
    ${object}    Determine Multiple Object Name Based On Active Tab    PickUpLocationsComboBox    False
    ${pickup_location}    Get Control Text Value    ${object}
    Set Suite Variable    ${pickup_location}

Get Pickup Location Text
    ${object}    Determine Multiple Object Name Based On Active Tab    PickupLocationTextTextBox    False
    ${pickup_location_text}    Get Control Text Value    ${object}
    Set Suite Variable    ${pickup_location_text}

Get Pin Code
    ${object}    Determine Multiple Object Name Based On Active Tab    PinCodeTextBox    False
    ${pin_code}    Get Control Text Value    ${object}
    Set Suite Variable    ${pin_code}

Get Post Code
    ${post_code}    Get Control Text Value    [NAME:Request_PostalCodeTextBox]
    Set Suite Variable    ${post_code}

Get Prefer From Vendor Info Tab
    ${prefer}    Get Checkbox State    [NAME:PreferCheckBox]
    Set Suite Variable    ${prefer}
    Log    ${prefer}

Get Processing Type
    ${processing_type}    Get Control Text Value    [NAME:ProcessingTypeComboBox]
    Set Suite Variable    ${processing_type}

Get Product
    [Arguments]    ${identifier}
    ${product}    Get Control Text Value    [NAME:cboProduct]
    Set Suite Variable    ${product_${identifier}}    ${product}

Get Product Code
    [Arguments]    ${country_code}    ${product_name}
    Open Excel    ${CURDIR}/../test_data/Consolidated ProductVendor_HKSG_UATProd.xls
    ${row_count}    Get Row Count    Conso
    ${product_code}    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    1    ${row_count}
    \    ${current_cocode} =    Read Cell Data By Coordinates    Conso    0    ${product_pointer}
    \    ${current_product} =    Read Cell Data By Coordinates    Conso    1    ${product_pointer}
    \    ${current_pcode} =    Read Cell Data By Coordinates    Conso    2    ${product_pointer}
    \    Exit For Loop If    '${current_product.lower()}' == '${product_name.lower()}' and '${current_cocode.lower()}' == '${country_code.lower()}'
    Set Test Variable    ${p_code}    ${current_pcode}
    ${product_code}    Convert To Integer    ${current_pcode}
    Set Test Variable    ${product_code}
    Log    Product Code is ${product_code}
    [Return]    ${product_code}

Get Product In Associated Charges
    ${assoc_charges_product}    Get Control Text Value    [NAME:AssociatedCharges_ProductCombobox]
    Set Suite Variable    ${assoc_charges_product}

Get Remark Issue In Request Tab When Products Are Air BSp Or Air Domestic
    [Arguments]    ${identifier}
    ${remark}    Get Control Text Value    [NAME:RemarkTextbox]
    Set Suite Variable    ${remark_${identifier}}    ${remark}

Get Request Field Values
    [Arguments]    ${product}    ${identifier}=${EMPTY}
    [Documentation]    Add an ${identifier} to create a unique list of Request tab values
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Run Keyword If    "${product.lower()}"=="air sales-non bsp int" or "${product.lower()}"=="air conso-dom"    Get Other Services Request Details For Air Conso-Dom Or Air Sales-Non Bsp Int    ${identifier}    ${product}
    Run Keyword If    "${product.lower()}"=="meet & greet"    Get Request Field Values When Product Is Meet & Greet
    Run Keyword If    "${product.lower()}"=="air bsp" or "${product.lower()}"=="air domestic"    Get Other Services Request Details For Air Bsp And Air Domestic    ${identifier}
    Run Keyword If    "${product.lower()}"=="hotel prepaid-intl" or "${product.lower()}"=="hotel prepaid-dom"    Get Request Tab Field Details When Product Is Hotel Prepaid-Intl Or Hotel Prepaid-Dom    ${identifier}
    Run Keyword If    "${product.lower()}"=="despatch" or "${product.lower()}"=="ets call charges" or "${product.lower()}"=="ferry" or "${product.lower()}"=="merchant fee" or "${product.lower()}"=="mice domestic" or "${product.lower()}"=="mice international" or "${product.lower()}"=="oths handling fee" or "${product.lower()}"=="rebate" or "${product.lower()}"=="tour domestic" or "${product.lower()}"=="transaction fee-air only" or "${product.lower()}"=="vat"    Get Request Field Values For Non Air Other Services    ${identifier}
    Run Keyword If    "${product.lower()}"=="tour intl"    Get Request Tab Field Details When Product Is Tour Intl    ${identifier}
    Run Keyword If    "${product.lower()}"=="visa fee" or "${product.lower()}"=="visa dd" or "${product.lower()}"=="visa handling fee"    Get Request Tab Field Values When Product Is Visa    ${product}    ${identifier}
    Run Keyword If    "${product.lower()}"=="car intl" or "${product.lower()}"=="car dom"    Get Request Tab Field Details When Product Is Car Intl Or Car Dom    ${identifier}
    Run Keyword If    "${product.lower()}"=="insurance"    Get Request Tab Field Details When Product Is Insurance    ${identifier}
    Run Keyword If    "${product.lower()}"=="train" or "${product.lower()}"=="train- dom" or "${product.lower()}"=="transaction charges"    Get Request Field Values When Product Is Train Or Train Dom Or Transaction Charges    ${product}    ${identifier}

Get Request Field Values For Non Air Other Services
    [Arguments]    ${identifier}
    [Documentation]    This Keyword can be used For The Below Non-Air Other Services
    ...    • Despatch
    ...    • Ets Call Charges
    ...    • Ferry
    ...    • Merchant fee
    ...    • Mice Domestic
    ...    • MICE international
    ...    • Oths handling Fee
    ...    • Rebate
    ...    • Tour Domestic
    ...    • Transaction Fee-Air only
    ...    • VAT
    Get Product
    Get Vendor
    Get Details For Non Air Products
    Get Internal Remarks
    @{request_list}    Create List    ${internal_remarks}    ${details1}    ${details2}    ${details3}
    ${request_list}    Remove Empty Value From List    ${request_list}
    Set Suite Variable    ${request_list${identifier.lower()}}    ${request_list}

[Obsolete] Get Request Field Values When Product Is Air BSP Add On, Air Dom Add On, Air Sales-Non BSP INT, Air Conso-Dom
    [Arguments]    ${product}    ${identifier}
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Get Product
    Get Vendor
    Get Plating Carrier
    Get Fare Type
    Get Tour Code
    Get Threshold Amount
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get PoS Remark 1
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get PoS Remark 2
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get PoS Remark 3
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Centralized Desk 1
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Centralized Desk 2
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Airlines
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Transaction Type
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Airlines PNR
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Fare break up 1
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Fare break up 2
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Cancellation Penalty
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get LCC Queue back Remark
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get GSTIN
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Email In Request
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Entity Name
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Get Phone No
    @{custom_fields}    Run Keyword If    "${product.lower()}"=="air conso-dom"    Create List    ${pos_remark_1}    ${pos_remark_2}    ${pos_remark_3}
    ...    ${centralized_desk_1}    ${centralized_desk_2}    ${airlines}    ${transaction_type}    ${airlines_pnr}    ${fare_break_up_1}
    ...    ${fare_break_up_2}    ${cancellation_penalty}    ${lcc_queue_back_remark}    ${gstin}    ${email_in_request}    ${entity_name}
    ...    ${phone_no}
    ...    ELSE    Create List    ${EMPTY}
    @{air_add_on}    Create List    ${product}    ${vendor}    ${plating_carrier}    ${fare_type}    ${tour_code}
    ...    ${threshold_amount}
    ${air_add_on_collection}    Combine Lists    ${custom_fields}    ${air_add_on}
    Set Suite Variable    ${air_add_on_collection_${identifier.lower()}}    ${air_add_on_collection}
    Log    ${air_add_on_collection_${identifier.lower()}}

Get Request Field Values When Product Is Air Conso Dom
    Get Product
    Get Vendor
    Get Plating Carrier
    Get Fare Type
    Get Tour Code
    Get Threshold Amount
    Get PoS Remark 1
    Get PoS Remark 2
    Get PoS Remark 3
    Get Centralized Desk 1
    Get Centralized Desk 2
    Get Airlines
    Get Transaction Type
    Get Airlines PNR
    Get Fare break up 1
    Get Fare break up 2
    Get Cancellation Penalty
    Get LCC Queue back Remark
    Get GSTIN
    Get Email In Request
    Get Entity Name
    Get Phone No

Get Request Field Values When Product Is Meet & Greet
    Get Date In Request Tab For Meet & Greet Product
    Get Time In Request Tab For Meet & Greet Product
    Get City In Request Tab For Meet & Greet Product
    Get Locations In Request Tab For Meet & Greet Product
    Get Internal remarks In Request Tab For Meet & Greet Product
    Get Vendor

Get Request Tab Field Details When Product Is Car Intl Or Car Dom
    [Arguments]    ${identifier}=${EMPTY}
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Get Product
    Get Vendor
    Get Car Segment
    ${pickup_date}    ${pickup_time}    Get Date And Time    [NAME:PickupDateDatePicker]    [NAME:TimePickerControl]
    ${dropoff_date}    ${dropoff_time}    Get Date And Time    [NAME:DropOffDateDatePicker]    [NAME:DropOffTimePicker]
    Get Daily Rate
    Get Daily Rate Amount
    Get Pickup Location
    Get Dropoff Location
    Get Pickup Location Text
    Get Dropoff Location Text
    Get Company
    Get Confirmation Number
    Get Name
    Get Car Type
    Get Guarantee By
    Run Keyword If    "${guarantee_by.lower()}"=="credit card"    Get Credit Card Details In Request Tab
    Get Internal Remarks
    Get Cancellation Policy
    @{car_collection}    Create List    ${product}    ${vendor}    ${car_segment}    ${pickup_date}    ${pickup_time}
    ...    ${dropoff_date}    ${dropoff_time}    ${daily_rate}    ${daily_rate_amount}    ${pickup_location}    ${dropoff_location}
    ...    ${pickup_location_text}    ${dropoff_location_text}    ${company}    ${confirmation_number}    ${name}    ${car_type}
    ...    ${guarantee_by}    ${internal_remarks}
    Run Keyword If    "${guarantee_by.lower()}"!="credit card"    Set Test Variable    ${cc_info}    0
    @{car_collection}    Combine Lists    ${car_collection}    ${cc_info}    ${cancellation_policy_info}
    Set Suite Variable    ${car_collection${identifier}}    ${car_collection}
    Log    ${car_collection${identifier}}

Get Request Tab Field Details When Product Is Hotel Prepaid-Intl Or Hotel Prepaid-Dom
    [Arguments]    ${identifier}=${EMPTY}
    [Documentation]    Add an ${identifier} to create a unique list of Request tab values
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Get Product
    Get Vendor
    Get Air Segment
    Get Hotel Segment
    Get City Code
    Get Checkin Date
    Get Checkout Date
    Get Number Of People
    Get Room Type
    Get Hotel Name
    Get Hotel Address
    Get City Name In Request
    Get State/Province
    Get Post Code
    Get Phone Number
    Get Daily Rate
    Get Daily Rate Amount
    Get Confirmation Number
    Get Guarantee By
    Run Keyword If    "${guarantee_by.lower()}"=="credit card"    Get Credit Card Details In Request Tab
    Get Internal Remarks
    Get Cancellation Policy
    Log    Creating list ...
    @{hotel_prepaid_collection}    Create List    ${product}    ${vendor}    ${air_segment_w/o_seg_no}    ${hotel_segment_w/o_seg_no}    ${city_code}
    ...    ${checkin_date}    ${checkout_date}    ${number_of_people}    ${room_type}    ${hotel_name}    ${hotel_address}
    ...    ${city_name}    ${state_province}    ${post_code}    ${phone_number}    ${daily_rate}    ${daily_rate_amount}
    ...    ${confirmation_number}    ${guarantee_by}    ${internal_remarks}
    @{hotel_prepaid_collection}    Combine Lists    ${hotel_prepaid_collection}    ${cc_info}    ${cancellation_policy_info}
    Set Suite Variable    ${hotel_prepaid_collection${identifier}}    ${hotel_prepaid_collection}
    Log    ${hotel_prepaid_collection${identifier}}

Get Request Tab Field Details When Product Is Insurance
    [Arguments]    ${identifier}
    Get Product    ${identifier}
    Get Vendor    ${identifier}
    Get Details For Non Air Products
    Get Internal Remarks
    Get Employee Number
    Get Employee Name
    Get Area
    Get Passport Number
    Get Assignee Name
    Get Gender
    Get Date Of Birth
    Get Address Of House
    Get Street Name
    Get Sub Area
    Get Pin Code
    Get State
    Get Country
    Get Mobile Number
    Get Marital Status
    Get Departure Date
    Get Arrival Date
    ${request_collection}    Create List    ${details1}    ${details2}    ${details3}    ${internal_remarks}    ${employee_number}
    ...    ${employee_name}    ${area}    ${passport_number}    ${assignee_name}    ${gender}    ${date_of_birth}
    ...    ${address_of_house}    ${street_name}    ${sub_area}    ${pin_code}    ${state}    ${country_other_services}
    ...    ${mobile_number}    ${marital_status}    ${departure_date_insurance}    ${arrival_date}
    Set Suite Variable    ${request_collection${identifier.lower()}}    ${request_collection}

Get Request Tab Field Details When Product Is Tour Intl
    [Arguments]    ${identifier}
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Get Start Date
    Get End Date
    Get City
    Get Package Name
    Get Details
    Get Internal Remarks
    Get Product
    Get Vendor
    @{tour_intl_collection}    Create List    ${start_date}    ${end_date}    ${city_code}    ${package_name}    ${details}
    ...    ${internal_remarks}
    Set Suite Variable    ${tour_intl_collection${identifier}}    ${tour_intl_collection}
    Log    ${tour_intl_collection${identifier}}

Get Room Type
    ${room_type}    Get Control Text Value    [NAME:Request_RoomTypeCombobox]
    Set Suite Variable    ${room_type}

Get Select All Segments Checkbox In Request Tab When Products Are Air BSp Or Air Domestic
    ${is_visible}    Determine Control Object Is Visible On Active Tab    [NAME:SelectAllCheckBox]    False
    ${select_all_segments_checkbox_status}    Run Keyword If    "${is_visible.upper()}" == "TRUE" or "${is_visible.upper()}" == "FALSE"    Get Checkbox Status    [NAME:RequestVMPDCheckbox]
    Set Test Variable    ${select_all_segments_checkbox_status}
    [Return]    ${select_all_segments_checkbox_status}

Get Selling Price
    [Arguments]    ${identifier}=${EMPTY}
    Wait Until Control Object Is Visible    [NAME:SellingPriceTextBox]
    ${selling_price}    Get Control Text Value    [NAME:SellingPriceTextBox]    ${title_power_express}
    Set Suite Variable    ${selling_price}
    Set Suite Variable    ${selling_price_${identifier}}    ${selling_price}

Get Service Info Field Values
    Get Nett Cost In Other Services
    Get Selling Price
    Get Commission
    Get GST
    Get Merchant Fee In Other Services
    Get Total Selling Price
    Get Form Of Payment
    Get Card Vendor Type
    Get Card Number
    Get Expiry Month In Other Services
    Get Expiry Year In Other Services
    Get BTA Description
    Get Additional Information Date
    Get Exchange Order
    Get Checkbox Status of CWT Absorb For Mechant Fee
    Get Checkbox Status of CWT Absorb For GST

Get Special Rate, No Cancellation
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_SpecialRateRadioButton, SpecialRateRadioButton    False
    ${special_rate_no_cancellation_status}    Get Radio Button Status    ${object}
    ${special_rate_no_cancellation_status}    Convert To String    ${special_rate_no_cancellation_status}
    @{special_rate_no_cancellation}    Create List    ${special_rate_no_cancellation_status}
    Set Suite Variable    ${special_rate_no_cancellation}
    Set Suite Variable    ${special_rate_no_cancellation_status}

Get Start Date
    ${object}    Determine Multiple Object Name Based On Active Tab    StartDateDatePicker    False
    ${start_date}    Get Control Text Value    ${object}
    Set Suite Variable    ${start_date}

Get State
    ${object}    Determine Multiple Object Name Based On Active Tab    StateTextBox    False
    ${state}    Get Control Text Value    ${object}
    Set Suite Variable    ${state}

Get State/Province
    ${state_province}    Get Control Text Value    [NAME:Request_StateOrProvinceTextBox]
    Set Suite Variable    ${state_province}

Get Status Of Request VMPD Checkbox In Request Tab When Products Are Air BSp Or Air Domestic
    ${is_visible}    Determine Control Object Is Visible On Active Tab    [NAME:RequestVMPDCheckbox]    False
    ${request_vmpd_checkbox_status}    Run Keyword If    "${is_visible.lower()}" == "true" or "${is_visible.lower()}" == "false"    Get Checkbox Status    [NAME:RequestVMPDCheckbox]
    Set Suite Variable    ${request_vmpd_checkbox_status}
    [Return]    ${request_vmpd_checkbox_status}

Get Status of checkbox for Merchant Fee - CWT Handling
    ${is_visible}    Determine Control Object Is Visible On Active Tab    [NAME:CwtHandlingMerchantCheckBox]    False
    ${merchant_fee_cwt_handling_checkbox_status}    Run Keyword If    "${is_visible.upper()}" == "TRUE"    Get Checkbox Status    [NAME:CwtHandlingMerchantCheckBox]
    ...    ELSE    Set Variable    False
    Set Test Variable    ${merchant_fee_cwt_handling_checkbox_status}

Get Status of checkbox for Merchant Fee - Nett Cost
    ${is_visible}    Determine Control Object Is Visible On Active Tab    [NAME:NetCostMerchantCheckBox]    False
    ${merchant_fee_nett_cost_checkbox_status}    Run Keyword If    "${is_visible.upper()}" == "TRUE"    Get Checkbox Status    [NAME:NetCostMerchantCheckBox]
    ...    ELSE    Set Variable    False
    Set Test Variable    ${merchant_fee_nett_cost_checkbox_status}

Get Street Name
    ${object}    Determine Multiple Object Name Based On Active Tab    StreetNameTextBox    False
    ${street_name}    Get Control Text Value    ${object}
    Set Suite Variable    ${street_name}

Get Sub Area
    ${object}    Determine Multiple Object Name Based On Active Tab    SubAreaCityTextBox    False
    ${sub_area}    Get Control Text Value    ${object}
    Set Suite Variable    ${sub_area}

Get Time For AM
    [Arguments]    ${hr}    ${min}
    ${hr}    Convert To String    ${hr}
    ${l}    Get Length    ${hr}
    Log    ${l}
    ${hr}    Run Keyword And Continue On Failure    Run Keyword If    "${l}"=="1"    Catenate    0    ${hr}
    ...    ELSE    Set Variable    ${hr}
    ${time_india}    Catenate    ${hr}    ${min}
    ${time_india}    Remove All Spaces    ${time_india}
    Log    ${time_india}
    [Return]    ${time_india}

Get Time For PM
    [Arguments]    ${hr}    ${min}
    ${hr}    Convert To Integer    ${hr}
    ${hr}    Evaluate    ${hr}+12
    ${hr}    Convert To String    ${hr}
    ${time_india}    Catenate    ${hr}    ${min}
    ${time_india}    Remove All Spaces    ${time_india}
    Log    ${time_india}
    [Return]    ${time_india}

Get Time In Request Tab For Meet & Greet Product
    Wait Until Control Object Is Visible    [NAME:TimePickerControl]
    ${time}    Get Control Text Value    [NAME:TimePickerControl]
    Set Suite Variable    ${time}

Get Total Selling Price
    [Arguments]    ${identifier}=${EMPTY}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiSellingPriceTextBox, DiSellingPriceTextBox,TotalSellingFareTextBox,AssociatedCharges_DiSellingPriceTextBox    False
    ${total_selling_price}    Get Control Text Value    ${object}    ${title_power_express}
    Set Suite Variable    ${total_selling_price}
    Set Suite Variable    ${total_selling_price_${identifier}}    ${total_selling_price}

Get Total Selling Price In Associated Charges
    ${assoc_charges_total_selling_price}    Get Control Text Value    [NAME:AssociatedCharges_DiSellingPriceTextBox]
    Set Suite Variable    ${assoc_charges_total_selling_price}

Get Total Selling Price In Charges
    ${charges_total_selling_price}    Get Control Text Value    [NAME:Charges_DiSellingPriceTextBox]
    Set Suite Variable    ${charges_total_selling_price}

Get Tour Code
    [Arguments]    ${identifier}
    ${tour_code}    Get Control Text Value    [NAME:TourCodeTextBox]
    Set Suite Variable    ${tour_code_${identifier}}    ${tour_code}

Get Validity Custom Field
    ${validity_custom_field}    Get Control Text Value    [NAME:ValidityTextBox2]
    Set Suite Variable    ${validity_custom_field}

Get Validity UOM
    ${validity_uom}    Get Control Text Value    [NAME:ValidityComboBox]
    Set Suite Variable    ${validity_uom}

Get Vendor
    [Arguments]    ${identifier}
    ${vendor}    Get Control Text Value    [NAME:cboVendor]
    Set Suite Variable    ${vendor_${identifier}}    ${vendor}

Get Vendor Code
    [Arguments]    ${country_code}    ${product_name}    ${vendor_name}
    Open Excel    ${CURDIR}/../test_data/Consolidated ProductVendor_HKSG_UATProd.xls
    ${row_count} =    Get Row Count    Conso
    ${vendor_code} =    Set Variable    ${EMPTY}
    : FOR    ${vendor_pointer}    IN RANGE    ${row_count}
    \    ${current_cocode} =    Read Cell Data By Coordinates    Conso    0    ${vendor_pointer}
    \    ${current_product} =    Read Cell Data By Coordinates    Conso    1    ${vendor_pointer}
    \    ${current_vendor} =    Read Cell Data By Coordinates    Conso    5    ${vendor_pointer}
    \    ${current_vendor_code} =    Read Cell Data By Coordinates    Conso    6    ${vendor_pointer}
    \    Exit For Loop If    '${current_product.lower()}' == '${product_name.lower()}' and '${current_cocode.lower()}' == '${country_code.lower()}' and '${current_vendor.lower()}' == '${vendor_name.lower()}'
    ${vendor_code}    Set Variable    ${current_vendor_code}
    Set Test Variable    ${vendor_code}
    Log    Vendor Code is ${vendor_code}
    [Return]    ${vendor_code}

Get Vendor Code For India
    [Arguments]    ${product_name}    ${vendor_name}
    Open Excel    ${product_vendor_sg_hk_in}
    ${row_count1}    Get Row Count    Product SGHKIN
    ${row_count2}    Get Row Count    Vendor IN
    ${product_code}    Set Variable    ${EMPTY}
    ${vendor_code}    Set Variable    ${EMPTY}
    : FOR    ${product_pointer}    IN RANGE    ${row_count1}
    \    ${current_product}    Read Cell Data By Coordinates    Product SGHKIN    2    ${product_pointer}
    \    Run Keyword If    '${product_name.lower()}' == '${current_product.lower()}'    Exit For Loop
    : FOR    ${vendor_pointer}    IN RANGE    ${row_count2}
    \    ${current_vendor_code}    Read Cell Data By Coordinates    Vendor IN    2    ${vendor_pointer}
    \    ${current_vendor}    Read Cell Data By Coordinates    Vendor IN    3    ${vendor_pointer}
    \    Run Keyword If    "${current_product.lower()}" == "${product_name.lower()}" and "${current_vendor.lower()}" == "${vendor_name.lower()}"    Exit For Loop
    Set Suite Variable    ${current_vendor_code}
    Log    Vendor Code is ${current_vendor_code}

Get Vendor Code For Meet & Greet Product
    ${vendor_name}    Get Control Text Value    [NAME:cboVendor]
    Open Excel    ${product_vendor_sg_hk_in}
    ${row_count} =    Get Row Count    Vendor SGHKIN
    ${cel_vendor_name}    Set Variable    ${EMPTY}
    ${vendor_code}    Set Variable    ${EMPTY}
    : FOR    ${vendor_pointer}    IN RANGE    ${row_count}
    \    ${cel_vendor_name}    Read Cell Data By Coordinates    Vendor SGHKIN    2    ${vendor_pointer}
    \    ${current_vendor_code} =    Read Cell Data By Coordinates    Vendor SGHKIN    1    ${vendor_pointer}
    \    Exit For Loop If    "${cel_vendor_name.lower()}"=="${vendor_name.lower()}"
    ${vendor_code}    Set Variable    ${current_vendor_code}
    Set Suite Variable    ${vendor_code}    ${current_vendor_code}
    Log    Vendor Code is ${vendor_code}
    [Return]    ${vendor_code}

Get Vendor From Vendor Tab
    ${vendor_value}    Get Control Text Value    [NAME:VendorComboBox]
    Set Suite Variable    ${vendor_value}

Get Vendor In Associated Charges
    ${assoc_charges_vendor}    Get Control Text Value    [NAME:AssociatedCharges_VendorComboBox]
    Set Suite Variable    ${assoc_charges_vendor}

Handling Delete pop up For Vendor Info Tab
    ${is_window_active} =    Win Active    Confirm Delete    ${EMPTY}
    Run Keyword If    ${is_window_active} == 1    Send    {Y}

Is Exchange Order Cancelled
    [Arguments]    ${click_ok}=True
    ${eo_pop_up_message}    Get Exchange Order Pop Up Message    ${click_ok}
    ${is_eo_cancelled}    Run Keyword And Return Status    Should Be Equal As Strings    ${eo_pop_up_message}    Are you sure you want to cancel this EO?
    Set Test Variable    ${is_eo_cancelled}
    [Return]    ${is_eo_cancelled}

Mask Credit Card Number
    Get Card Number
    ${is_mask}    Run Keyword And Return Status    Should Contain    ${card_number}    *
    Run Keyword If    "${is_mask}" == "False"    Click Control Button    [NAME:MaskContentButton]
    ...    ELSE    Log    Credit card number is already masked.

Masking For Remarks
    [Arguments]    ${ccnum}    ${card_vendor_type}
    ${ccnum}    Convert To String    ${ccnum}
    ${last_4_digit}    Get Substring    ${ccnum}    -4
    ${string_lenght}    Get Length    ${ccnum}
    ${mask} =    Set Variable If    '${card_vendor_type}' == 'DC'    XXXXXXXXXX    '${card_vendor_type}' == 'AX' or '${card_vendor_type}' == 'TP'    XXXXXXXXXXX    '${card_vendor_type}' == 'VI' or '${card_vendor_type}' == 'CA' or '${card_vendor_type}' == 'MC' or '${card_vendor_type}' == 'JC'
    ...    XXXXXXXXXXXX
    Set Test Variable    ${ccnum}    ${mask}${last_4_digit}
    [Return]    ${ccnum}

Populate Associated Charges Fields
    [Arguments]    ${product}    ${vendor}    ${cost_amount}    ${commision_value}    ${discount}    ${description}
    ...    ${vendor_reference_gsa}=${EMPTY}    ${other_related_reference_po}=${EMPTY}
    Set Product In Associated Charges    ${product}
    Set Vendor In Associated Charges    ${vendor}
    Set Cost Amount In Associated Charges    ${cost_amount}
    Set Discount In Associated Charges    ${discount}
    Set Commission In Associated Charges    ${commision_value}
    Set Description In Associated Charges    ${description}
    Set Vendor Reference No (GSA) In Associated Charges    ${vendor_reference_gsa}
    Set Other Related No (PO) In Associated Charges    ${other_related_reference_po}

Populate Cancel By
    [Arguments]    ${cancel_by_text}    ${cancel_by_uom}
    Select Cancel By
    Set Cancel By Text    ${cancel_by_text}
    Select Cancel By UOM    ${cancel_by_uom}

Populate Charges Fields Details
    [Arguments]    ${cost_amount}    ${discount}    ${commision_value}    ${description}    ${vendor_reference_gsa}    ${other_related_reference_po}
    Set Cost Amount    ${cost_amount}
    Set Discount    ${discount}
    Set Commission    ${commision_value}
    Set Description In Charges    ${description}
    Set Vendor Reference No (GSA) In Charges    ${vendor_reference_gsa}
    Set Other Related No (PO) In Charges    ${other_related_reference_po}

Populate Date
    [Arguments]    ${date}    ${control_id}
    [Documentation]    Date Format: dd/mm/yyy
    ...    Example: 12/06/2019
    @{date}    Split String    ${date}    /
    ${day} =    Set Variable    ${date[0]}
    ${month} =    Set Variable    ${date[1]}
    ${year} =    Set Variable    ${date[2]}
    Click Control Button    ${control_id}    ${title_power_express}
    Send    {RIGHT}
    Send    ${day}    1
    Send    {RIGHT}
    Send    ${month}    1
    Send    {RIGHT}
    Send    ${year}    1

Populate FOP Details
    [Arguments]    ${fop_value}    ${fop_cc_type}    ${fop_cc_number}    ${fop_cc_expiry_mmyy}
    ${fop_cc_expiry}    Split String    ${fop_cc_expiry_mmyy}    /
    Select Dropdown Value    [NAME:FormOfPaymentComboBox]    ${fop_value}    #SET UI FOP VALUE
    Wait Until Control Object Is Not Visible    [NAME:pictureBox1]
    Select Dropdown Value    [NAME:FopVendorComboBox]    ${fop_cc_type}    #SET UI CC TYPE
    Wait Until Control Object Is Not Visible    [NAME:pictureBox1]
    ${ui_cc_number} =    Get Control Text Value    [NAME:ValueMaskedTextBox]
    ${ui_cc_number_length} =    Get Length    ${ui_cc_number}
    Run Keyword If    ${ui_cc_number_length} == 0    Click Control Button    [NAME:MaskContentButton]
    Set Control Text Value    [NAME:ValueMaskedTextBox]    ${fop_cc_number}    #SET UI CC NUMBER
    Comment    ${ui_cc_month_length} =    Get Length    @{fop_cc_expiry}[0]
    Comment    ${fop_cc_expiry_mm} =    Set Variable If    '${ui_cc_number_length}' == '1'    0@{fop_cc_expiry}[0]    @{fop_cc_expiry}[0]
    Select Dropdown Value    [NAME:ExpiryMonthComboBox]    @{fop_cc_expiry}[0]    #SET UI CC EXPIRY MM
    Select Dropdown Value    [NAME:ExpiryYearComboBox]    20@{fop_cc_expiry}[1]    #SET UI CC EXPIRY YYYY

Populate Fields For Vendor Info Tab
    [Arguments]    ${attention}    ${address}    ${city}    ${country}    ${cwt_email}    ${cwt_phone}
    Activate Power Express Window
    Set Attention In Vendor Info Tab    ${attention}
    Set Address In Vendor Info Tab    ${address}
    Set City In Vendor Info Tab    ${city}
    Set Country In Vendor Info Tab    ${country}
    Set CWT Email In Vendor Info Tab    ${cwt_email}
    Set CWT Phone In Vendor Info Tab    ${cwt_phone}

Populate Grid Data In Vendor Info Tab
    [Arguments]    ${contact_type}    ${details}    ${prefer}
    Set Contact Type In Vendor Info Tab    ${contact_type}
    Set Details In Vendor Info Tab    ${details}
    Set Prefer In Vendor Info Tab    ${prefer}

Populate Others
    [Arguments]    ${others_text}
    Select Others
    Set Others Text    ${others_text}
    
Populate Request Fields
    [Arguments]    ${internal_remark}    ${detail1}    ${detail2}=${EMPTY}    ${detail3}=${EMPTY}
    Activate Power Express Window
    Set Control Text Value    [NAME:Details1TextBox]    ${detail1}
    Send    {TAB}
    Set Control Text Value    [NAME:Details2TextBox]    ${detail2}
    Set Control Text Value    [NAME:Details3TextBox]    ${detail3}
    Set Control Text Value    [NAME:InternalRemarksTextBox]    ${internal_remark}

Populate Request Fields Except Select Air Segments When Product Is Any Air Add On
    [Arguments]    ${product}    ${plating_carrier}    ${fare_type}    ${tour_code}    ${threshold_amount}    ${pos_remark_1}=${EMPTY}
    ...    ${pos_remark_2}=${EMPTY}    ${pos_remark_3}=${EMPTY}    ${centralized_desk_1}=${EMPTY}    ${centralized_desk_2}=${EMPTY}    ${airlines}=${EMPTY}    ${transaction_type}=${EMPTY}
    ...    ${airlines_pnr}=${EMPTY}    ${fare_break_up_1}=${EMPTY}    ${fare_break_up_2}=${EMPTY}    ${cancellation_penalty}=${EMPTY}    ${lcc_queue_back_remark}=${EMPTY}    ${gstin}=${EMPTY}
    ...    ${email_in_request}=${EMPTY}    ${entity_name}=${EMPTY}    ${phone_no}=${EMPTY}
    Run Keyword If    "${product.lower()}"=="air bsp add on" or "${product.lower()}"=="air dom add on" or "${product.lower()}"=="air sales-non bsp int"    Populate Request Fields When Product Is Air BSP Add On, Air Dom Add On, Air Sales-Non BSP INT    ${plating_carrier}    ${fare_type}    ${tour_code}    ${threshold_amount}
    Run Keyword If    "${product.lower()}"=="air conso-dom"    Populate Request Fields When Product Is Air Conso Dom    ${plating_carrier}    ${fare_type}    ${tour_code}    ${threshold_amount}
    ...    ${pos_remark_1}    ${pos_remark_2}    ${pos_remark_3}    ${centralized_desk_1}    ${centralized_desk_2}    ${airlines}
    ...    ${transaction_type}    ${airlines_pnr}    ${fare_break_up_1}    ${fare_break_up_2}    ${cancellation_penalty}    ${lcc_queue_back_remark}
    ...    ${gstin}    ${email_in_request}    ${entity_name}    ${phone_no}

Populate Request Fields Values When Product Is Insurance
    [Arguments]    ${detail1}    ${detail2}=${EMPTY}    ${detail3}=${EMPTY}    ${internal_remark}=${EMPTY}    ${employee_number}=${EMPTY}    ${employee_name}=${EMPTY}
    ...    ${area}=${EMPTY}    ${passport_number}=${EMPTY}    ${assignee_name}=${EMPTY}    ${gender}=${EMPTY}    ${date_of_birth}=${EMPTY}    ${address_of_house}=${EMPTY}
    ...    ${street_name}=${EMPTY}    ${sub_area}=${EMPTY}    ${pin_code}=${EMPTY}    ${state}=${EMPTY}    ${country}=${EMPTY}    ${mobile_number}=${EMPTY}
    ...    ${marital_status}=${EMPTY}    ${departure_date_insurance}=${EMPTY}    ${arrival_date}=${EMPTY}
    Set Details In Request When Product Is Insurance    ${detail1}    ${detail2}    ${detail3}
    Set Internal Remarks    ${internal_remark}
    Set Employee Number    ${employee_number}
    Set Employee Name    ${employee_name}
    Set Area    ${area}
    Set Passport Number    ${passport_number}
    Set Assignee Name    ${assignee_name}
    Set Gender    ${gender}
    Set Date Of Birth When Product Is Insurance    ${date_of_birth}
    Set Address Of House    ${address_of_house}
    Set Street Name    ${street_name}
    Set Sub Area    ${sub_area}
    Set Pin Code    ${pin_code}
    Set State    ${state}
    Set Country    ${country}
    Set Mobile Number When Product Is Insurance    ${mobile_number}
    Set Marital Status    ${marital_status}
    Set Departure Date    ${departure_date_insurance}
    Set Arrival Date    ${arrival_date}

Populate Request Fields When Product Is Air BSP Add On, Air Dom Add On, Air Sales-Non BSP INT
    [Arguments]    ${plating_carrier}    ${fare_type}    ${tour_code}    ${threshold_amount}
    Set Plating Carrier    ${plating_carrier}
    Set Fare Type    ${fare_type}
    Set Tour Code    ${tour_code}
    Set Threshold Amount    ${threshold_amount}

Populate Request Fields When Product Is Air Conso Dom
    [Arguments]    ${plating_carrier}    ${fare_type}    ${tour_code}    ${threshold_amount}    ${pos_remark_1}    ${pos_remark_2}
    ...    ${pos_remark_3}    ${centralized_desk_1}    ${centralized_desk_2}    ${airlines}    ${transaction_type}    ${airlines_pnr}
    ...    ${fare_break_up_1}    ${fare_break_up_2}    ${cancellation_penalty}    ${lcc_queue_back_remark}    ${gstin}    ${email_in_request}
    ...    ${entity_name}    ${phone_no}
    Set Plating Carrier    ${plating_carrier}
    Set Fare Type    ${fare_type}
    Set Tour Code    ${tour_code}
    Set Threshold Amount    ${threshold_amount}
    Set PoS Remark 1    ${pos_remark_1}
    Set PoS Remark 2    ${pos_remark_2}
    Set PoS Remark 3    ${pos_remark_3}
    Set Centralized Desk 1    ${centralized_desk_1}
    Set Centralized Desk 2    ${centralized_desk_2}
    Select Airlines    ${airlines}
    Select Transaction Type    ${transaction_type}
    Set Airlines PNR    ${airlines_pnr}
    Set Fare break up 1    ${fare_break_up_1}
    Set Fare break up 2    ${fare_break_up_2}
    Set Cancellation Penalty    ${cancellation_penalty}
    Set LCC Queue back Remark    ${lcc_queue_back_remark}
    Set GSTIN    ${gstin}
    Set Email In Request    ${email_in_request}
    Set Entity Name    ${entity_name}
    Set Phone No    ${phone_no}

[Obsolete] Populate Request Fields When Product Is Car DOM
    [Arguments]    ${pickup_date}    ${pickup_time}    ${dropoff_date}    ${dropoff_time}    ${car_segment}    ${daily_rate_currency}
    ...    ${daily_rate_amount}    ${pickup_location}    ${pickup_location_text}    ${dropoff_location}    ${dropoff_location_text}    ${companies}
    ...    ${confirmation_number}    ${name_text}    ${car_type}    ${internal_remarks}    ${guarantee_by}    ${cancellation_policy}
    ...    ${card_number}=0    ${card_pref}=0    ${card_type}=0    ${cancel_by_text}=${EMPTY}    ${cancel_by_uom}=Hrs    ${others_text}=${EMPTY}
    Activate Power Express Window
    Select Value From Dropdown List    [NAME:CarSegmentsComboBox]    ${car_segment}
    @{pickup_date}    Split String    ${pickup_date}    /
    ${day} =    Set Variable    ${pickup_date[0]}
    ${month} =    Set Variable    ${pickup_date[1]}
    ${year} =    Set Variable    ${pickup_date[2]}
    Populate Date    ${day}    ${month}    ${year}    [NAME:PickupDateDatePicker]
    @{pickup_time}    Split String    ${pickup_time}    /
    ${hour} =    Set Variable    ${pickup_time[0]}
    ${minute} =    Set Variable    ${pickup_time[1]}
    ${second} =    Set Variable    ${pickup_time[2]}
    Populate Time Car Info    ${hour}    ${minute}    ${second}    [NAME:TimePickerControl]
    @{dropoff_date}    Split String    ${dropoff_date}    /
    ${day} =    Set Variable    ${dropoff_date[0]}
    ${month} =    Set Variable    ${dropoff_date[1]}
    ${year} =    Set Variable    ${dropoff_date[2]}
    Populate Date    ${day}    ${month}    ${year}    [NAME:DropOffDateDatePicker]
    @{dropoff_time}    Split String    ${dropoff_time}    /
    ${hour} =    Set Variable    ${dropoff_time[0]}
    ${minute} =    Set Variable    ${dropoff_time[1]}
    ${second} =    Set Variable    ${dropoff_time[2]}
    Populate Time Car Info    ${hour}    ${minute}    ${second}    [NAME:DropOffTimePicker]
    Select Value From Dropdown List    [NAME:DailyRateCurrencyComboBox]    ${daily_rate_currency}
    Set Control Text Value    [NAME:DailyRateAmountTextBox]    ${daily_rate_amount}
    Select Value From Dropdown List    [NAME:PickUpLocationsComboBox]    ${pickup_location}
    Set Control Text Value    [NAME:PickupLocationTextTextBox]    ${pickup_location_text}
    Select Value From Dropdown List    [NAME:DropOffLocationsComboBox]    ${dropoff_location}
    Set Control Text Value    [NAME:DropOffLocationTextTextBox]    ${dropoff_location_text}
    Select Value From Dropdown List    [NAME:CompaniesComboBox]    ${companies}
    Set Control Text Value    [NAME:ConfirmationNumberTextBox]    ${confirmation_number}
    Set Control Text Value    [NAME:NameTextBox]    ${name_text}
    Set Control Text Value    [NAME:CarTypeTextBox]    ${car_type}
    Comment    Click Control Button    [NAME:OthersRadioButton]
    Comment    Set Control Text Value    [NAME:CancelByOthersDescriptionTextBox]    ${others_text}
    Comment    Click Control Button    [NAME:SpecialRateRadioButton]
    Comment    Click Control Button    [NAME:CancelByRadioButton]
    Comment    Set Control Text Value    [NAME:CancelByAmountTextBox]    ${cancel_by_amount}
    Comment    Select Value From Dropdown List    [NAME:SelectedCancelByTypeComboBox]    ${cancel_by_uom}
    Select Cancellation Policy    ${cancellation_policy}    ${cancel_by_text}    ${cancel_by_uom}    ${others_text}
    Set Control Text Value    [NAME:DescriptionTextBox]    ${internal_remarks}
    Run Keyword If    '${guarantee_by}'=='Credit Card'    Select Value From Dropdown List    [NAME:CreditCardPreferenceComboBox]    ${card_pref}
    ...    ELSE    Select Value From Dropdown List    [NAME:GuaranteedByComboBox]    ${guarantee_by}

[Obsolete] Populate Request Fields When Product Is Meet And Greet
    [Arguments]    ${select_city}    ${set_location}    ${set_internal_remarks}    ${date_time}
    [Documentation]    Used to populate the Request tab in Other services when the produc is Meet & Greet.
    ...
    ...    select_city - Three character code of the city or full name.
    ...
    ...    set_location - Location of meet and greet, could be alphanumeric
    ...
    ...    set_internal_remarks - Remarks field, contain and additional remarks.
    ...
    ...
    ...    date_time - day/month/year/hour/minute/second
    ...    day - 2 character day of the month
    ...    hour - 2 character hour
    ...    minute - 2 character minute
    ...    second - 2 character seconds
    ...    year - 4 character year
    ...    month - 2 character month
    Activate Power Express Window
    Log    ${date_time}
    @{future_date}    Split String    ${date_time}    /
    ${day} =    Set Variable    ${future_date[0]}
    ${month} =    Set Variable    ${future_date[1]}
    ${year} =    Set Variable    ${future_date[2]}
    Populate Date    ${day}    ${month}    ${year}    [NAME:DateDatePicker]
    ${hour} =    Set Variable    ${future_date[3]}
    ${minute} =    Set Variable    ${future_date[4]}
    ${second} =    Set Variable    ${future_date[5]}
    Populate Time    ${hour}    ${minute}    ${second}    [NAME:TimePickerControl]
    Set Control Text Value    [NAME:CityComboBox]    ${select_city}
    Set Control Text Value    [NAME:LocationsTextBox]    ${set_location}
    Set Control Text Value    [NAME:InternalRemarksTextBox]    ${set_internal_remarks}
    Click Control Button    [NAME:InternalRemarksTextBox]
    Send    {ENTER}

Populate Request Fields When Product Is Tour Intl
    [Arguments]    ${request_city}    ${package_name}    ${request_details}    ${request_internal_remarks}    ${start_date}    ${end_date}
    Set Start Date In Request Tour Intl    ${start_date}
    Set End Date In Request Tour Intl    ${end_date}
    Set City In Request    ${request_city}
    Set Package Name In Request    ${package_name}
    Set Details In Request    ${request_details}
    Set Internal Remarks In Request    ${request_internal_remarks}

Populate Request When Product Is Hotel Prepaid-Intl Or Hotel Prepaid-Dom
    [Arguments]    ${hotel_segment}    ${checkin_date_dd/mm/yyyy}    ${checkout_date_dd/mm/yyyy}    ${daily_rate}    ${amount}    ${air_segment}=${EMPTY}
    ...    ${room_type}=${EMPTY}    ${number_of_people}=${EMPTY}    ${guarantee_by}=${EMPTY}    ${confirmation_number}=${EMPTY}    ${city_code}=${EMPTY}    ${hotel_name}=${EMPTY}
    ...    ${hotel_address}=${EMPTY}    ${is_guarantee_by_credit_card}=${EMPTY}    ${cc_number}=${EMPTY}    ${cc_preference}=${EMPTY}    ${cc_type}=${EMPTY}    ${expiry_month_mm}=${EMPTY}
    ...    ${expiry_year_yyyy}=${EMPTY}    ${city_name}=${EMPTY}    ${post_code}=${EMPTY}    ${state_province}=${EMPTY}    ${phone_number}=${EMPTY}    ${internal_remarks}=${EMPTY}
    ...    ${cancellation_policy}=${EMPTY}    ${cancel_by_text}=${EMPTY}    ${cancel_by_uom}=Hrs    ${others_text}=${EMPTY}
    Select Hotel Segment In Request    ${hotel_segment}
    Set Checkin Date    ${checkin_date_dd/mm/yyyy}
    Set Checkout Date    ${checkout_date_dd/mm/yyyy}
    Select Daily Rate    ${daily_rate}
    Set Amount    ${amount}
    Select Air Segment In Request    ${air_segment}
    Select Room Type    ${room_type}
    Set Number Of People    ${number_of_people}
    Select Guarantee By    ${guarantee_by}
    Set Confirmation Number    ${confirmation_number}
    Set City Code    ${city_code}
    Set Hotel Name    ${hotel_name}
    Set Hotel Address    ${hotel_address}
    Run Keyword If    "${is_guarantee_by_credit_card.lower()}"=="true"    Set CC Number    ${cc_number}
    Run Keyword If    "${is_guarantee_by_credit_card.lower()}"=="true"    Set CC Preference    ${cc_preference}
    Run Keyword If    "${is_guarantee_by_credit_card.lower()}"=="true"    Set CC Type    ${cc_type}
    Run Keyword If    "${is_guarantee_by_credit_card.lower()}"=="true"    Set Expiry Date In Request    ${expiry_month_mm}    ${expiry_year_yyyy}
    Set City Name    ${city_name}
    Set Post Code    ${post_code}
    Set State/Province    ${state_province}
    Set Phone Number In Request    ${phone_number}
    Select Cancellation Policy    ${cancellation_policy}    ${cancel_by_text}    ${cancel_by_uom}    ${others_text}
    Set Internal Remarks    ${internal_remarks}

[Obsolete] Populate Request When Product Is Visa
    [Arguments]    ${product}    ${document}    ${country}    ${doc_type}    ${date_of_application_dd/mmm/yyyy}    ${internal_remarks}
    ...    ${entries}=${EMPTY}    ${validity}=${EMPTY}    ${validity_uom}=${EMPTY}    ${processing_type}=${EMPTY}    ${demand_draft_required}=${EMPTY}    ${demand_draft_number}=${EMPTY}
    ...    ${validity_custom_field}=${EMPTY}
    [Documentation]    Use this keyword to populate Request tab for the following Products: Visa Fee, Visa DD and Visa Handling Fee
    Select Document    ${document}
    Select Country In Request    ${country}
    Select Doc Type    ${doc_type}
    Select Date Of Application    ${date_of_application_dd/mmm/yyyy}
    Set Internal Remarks    ${internal_remarks}
    Run Keyword If    "${document}"=="Visa"    Select Entries    ${entries}
    Run Keyword If    "${document}"=="Visa"    Set Validity    ${validity}
    Run Keyword If    "${document}"=="Visa"    Select Validity UOM    ${validity_uom}
    Run Keyword If    "${document}"=="Visa"    Select Processing Type    ${processing_type}
    Run Keyword If    "${product.lower()}"=="visa handling fee"    Select Demand Draft Required    ${demand_draft_required}
    Run Keyword If    "${product.lower()}"=="visa handling fee"    Set Demand Draft Number    ${demand_draft_number}
    Run Keyword If    "${product.lower()}"=="visa handling fee"    Set Validity Custom Field    ${validity_custom_field}

Populate Service Info With Values
    [Arguments]    ${vendor_contact}    ${nett_cost}    ${selling_price}    ${form_of_payment}    ${card_vendor_type}    ${card_number}
    ...    ${expiry_month}    ${expiry_year}    ${description}    ${bta_description}
    Set Vendor Contact    ${vendor_contact}
    Set Nett Cost    ${nett_cost}
    Set Selling Price    ${selling_price}
    Select Form Of Payment (FOP)    ${form_of_payment}    ${card_vendor_type}    ${card_number}    ${expiry_month}    ${expiry_year}
    Set Description    ${description}
    Set BTA Description    ${bta_description}

Populate Service Info With Values (IN)
    [Arguments]    ${vendor_contact}    ${nett_cost}    ${commision_value}    ${discount_value}    ${description}    ${details}
    Set Vendor Contact    ${vendor_contact}
    Set Nett Cost    ${nett_cost}
    Set Commission Value    ${commision_value}
    Set Discount Value    ${discount_value}
    Set Description    ${description}
    Set Details    ${details}

Populate Time
    [Arguments]    ${time}    ${control_id}
    @{time}    Split String    ${time}    :
    ${hour} =    Set Variable    ${time[0]}
    ${minute} =    Set Variable    ${time[1]}
    @{time}    Split String    ${time[2]}
    ${second} =    Set Variable    ${time[0]}
    ${am_or_pm} =    Set Variable    ${time[1]}
    Click Control Button    ${control_id}    ${title_power_express}
    Send    {RIGHT}
    Comment    Send    {RIGHT}
    Send    ${hour}    1
    Send    {RIGHT}
    Send    ${minute}    1
    Send    {RIGHT}
    Send    ${second}    1
    Send    {RIGHT}
    Run Keyword If    '${am_or_pm}' == 'PM'    Send    P    1
    ...    ELSE    Send    A    1
    Comment    Run Keyword If    '${am_or_pm}' != '${EMPTY}'    Send    {RIGHT}    1
    Comment    Run Keyword If    '${am_or_pm}' != '${EMPTY}'    Send    ${am_or_pm}    1

[Obsolete] Populate Time Car Info
    [Arguments]    ${hour}    ${minute}    ${second}    ${time_combobox}    ${am_or_pm}=${EMPTY}
    Click Control Button    ${time_combobox}    ${title_power_express}
    Send    {RIGHT}
    Send    ${hour}    1
    Send    {RIGHT}
    Send    ${minute}    1
    Send    {RIGHT}
    Send    ${second}    1
    Send    {RIGHT}
    Run Keyword If    '${am_or_pm}' != '${EMPTY}'    Send    {RIGHT}    1
    Run Keyword If    '${am_or_pm}' != '${EMPTY}'    Send    ${am_or_pm}    1

Populate Unused Ticket Number
    [Arguments]    ${ac_no}    ${ticket_number}    ${conjunction_number}=${EMPTY}
    ${is_present1}    Is Control Visible    [NAME:AirlineCodeTextBox]
    Run Keyword If    ${is_present1}    Set Control Text Value    [NAME:AirlineCodeTextBox]    ${ac_no}
    ${is_present2}    Is Control Visible    [NAME:TicketNumberTextBox]
    Run Keyword If    ${is_present2}    Set Control Text Value    [NAME:TicketNumberTextBox]    ${ticket_number}
    ${is_present3}    Is Control Visible    [NAME:ConjunctionNumberTextBox]
    Run Keyword If    ${is_present3}    Set Control Text Value    [NAME:ConjunctionNumberTextBox]    ${conjunction_number}

Populate Visa Cost Tab
    [Arguments]    ${nett_cost}=50    ${selling_price}=100    ${country}=PH    ${type}=Other    ${entries}=Single    ${validity_number}=2
    ...    ${validity_type}=Day(s)    ${processing}=Normal    ${processing_day}=2
    Set Nett Cost    ${nett_cost}
    Set Selling Price    ${selling_price}
    Set Country    ${country}
    Select Type    ${type}
    Select Entries    ${entries}
    Set Validity Number    ${validity_number}
    Select Validity Type    ${validity_type}
    Select Processing    ${processing}
    Set Processing Days    ${processing_day}

Remove Insured Person In The Insured Grid
    [Arguments]    ${actual_number_of_records}    @{person_name}
    : FOR    ${name}    IN    @{person_name}
    \    Delete Record In Table Grid    [NAME:InsuredGridView]    ${name}    ${actual_number_of_records}

Remove Value After Decimal
    [Arguments]    ${value}
    Convert To String    ${value}
    ${value}    Split String    ${value}    .
    ${value}    Get From List    ${value}    0
    ${value}    Convert To Integer    ${value}
    Log    ${value}
    Set Test Variable    ${value}

Retrieve PNR for Air Segment
    [Arguments]    ${pnr_value}
    Comment    Retrieve PNR Details from Amadeus    R9ZD54    RTA
    Retrieve PNR Details from Amadeus    ${pnr_value}    RTA
    Select Air Segment    1
    Get Air Segments From The PNR
    Set Suite Variable    ${air_segment_value}    ${segments_list[0]}

Round Off Computed Merchant Fee To Whole Number
    ${computed_merchant_fee}    Round Off    ${computed_merchant_fee}    0
    ${computed_merchant_fee}    Evaluate    int(${computed_merchant_fee})
    Set Test Variable    ${computed_merchant_fee}

Round Up Hk Computed Other Services Values
    ${computed_commission}    Round Apac    ${computed_commission}    hk
    Set Test Variable    ${computed_commission}

Round Up Hk Other Services Values
    ${total_selling_price}    Round Apac    ${total_selling_price}    hk
    Set Test Variable    ${total_selling_price}
    ${commission}    Round Apac    ${commission}    hk
    Set Test Variable    ${commission}
    ${selling_price}    Round Apac    ${selling_price}    hk
    Set Test Variable    ${selling_price}

Select Air Segment In Request
    [Arguments]    ${air_segment}
    Select Dropdown Value    [NAME:Request_AirSegmentsComboBox]    ${air_segment}

Select An Item in Exchange Order Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Select Cell In Data Grid Table    [NAME:FromEoDataGridView]    Row ${count}
    ${selected_eo_rmk}=    Get Cell Value In Data Grid Table    [NAME:FromEoDataGridView]    Row ${count}
    Set Test Variable    ${selected_eo_rmk}

Select An Item in Itinerary Remarks Grid View By Index
    [Arguments]    ${count}
    Activate Power Express Window
    Select Cell In Data Grid Table    [NAME:FromIoDataGridView]    Row ${count}
    ${selected_io_rmk}=    Get Cell Value In Data Grid Table    [NAME:FromIoDataGridView]    Row ${count}
    Set Test Variable    ${selected_io_rmk}

Select Cancel By
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByRadioButton, CancelByRadioButton    False
    Click Control Button    ${object}

Select Cancel By UOM
    [Arguments]    ${cancel_by_uom}
    ${object}    Determine Multiple Object Name Based On Active Tab    SelectedCancelByTypeComboBox, Request_CancelByTypeComboBox    False
    Select Dropdown Value    ${object}    ${cancel_by_uom}

Select Cancellation Policy
    [Arguments]    ${cancellation_policy}    ${cancel_by_text}=${EMPTY}    ${cancel_by_uom}=Hrs    ${others_text}=${EMPTY}
    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    Run Keyword If    "${cancellation_policy.lower()}"=="cancel by"    Populate Cancel By    ${cancel_by_text}    ${cancel_by_uom}
    Run Keyword If    "${cancellation_policy.lower()}"=="special rate, no cancellation"or"${cancellation_policy.lower()}"=="no cancellation"    Select Special Rate, No Cancellation
    Run Keyword If    "${cancellation_policy.lower()}"=="others"    Populate Others    ${others_text}

Select Card Number
    [Arguments]    ${card_number}
    Wait Until Control Object Is Visible    [NAME:ValueMaskedTextBox]
    Set Control Text Value    [NAME:ValueMaskedTextBox]    ${EMPTY}
    Send Control Text Value    [NAME:ValueMaskedTextBox]    ${card_number}

Select Card Vendor Type
    [Arguments]    ${card_vendor_type}
    Wait Until Control Object Is Visible    [NAME:FopVendorComboBox]
    Select Value From Dropdown List    [NAME:FopVendorComboBox]    ${card_vendor_type}

Select Country In Request
    [Arguments]    ${country}
    Select Dropdown Value    [NAME:CountryComboBox]    ${country}

Select Daily Rate
    [Arguments]    ${daily_rate}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_DailyRateCurrencyComboBox    False
    Select Dropdown Value    ${object}    ${daily_rate}

Select Date Of Application
    [Arguments]    ${date_of_application}
    Set Control Text Value    [NAME:DateOfApplicationTextBox]    ${date_of_application}

Select Demand Draft Required
    [Arguments]    ${demand_draft_required}
    Select Dropdown Value    [NAME:DemandDraftRequiredComboBox]    ${demand_draft_required}

Select Doc Type
    [Arguments]    ${doc_type}
    Select Dropdown Value    [NAME:DocTypeComboBox]    ${doc_type}

Select Document
    [Arguments]    ${document}
    Select Dropdown Value    [NAME:DocumentComboBox]    ${document}

Select Expiry Month
    [Arguments]    ${expiry_month}
    Wait Until Control Object Is Visible    [NAME:ExpiryMonthComboBox]
    Select Value From Dropdown List    [NAME:ExpiryMonthComboBox]    ${expiry_month}

Select Expiry Year
    [Arguments]    ${expiry_year}
    Wait Until Control Object Is Visible    [NAME:ExpiryYearComboBox]
    Select Value From Dropdown List    [NAME:ExpiryYearComboBox]    ${expiry_year}
    Set Test Variable    ${expiry_year}

Select FOP CC And Merchant In Air Fare Panel
    [Arguments]    ${fare_tab}    ${fop_value}    ${merchant}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Click Control Button    ${fop_field}    ${title_power_express}
    Sleep    3
    Select Value From Combobox    ${fop_field}    ${fop_value}
    Select FOP Merchant On Fare Quote Tab    ${fare_tab}    ${merchant}

Select Form Of Payment As Cash On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop_value}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Click Control Button    ${fop_field}    ${title_power_express}
    Sleep    3
    Select Value From Combobox    ${fop_field}    ${fop_value}

Select Form Of Payment Details
    [Arguments]    ${card_vendor_type}    ${card_number}    ${expiry_month}    ${expiry_year}
    Select Card Vendor Type    ${card_vendor_type}
    Select Card Number    ${card_number}
    Select Expiry Month    ${expiry_month}
    Select Expiry Year    ${expiry_year}

Select Guarantee By
    [Arguments]    ${guarantee_by}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_GuaranteedByComboBox    False
    Select Dropdown Value    ${object}    ${guarantee_by}

Select Headline Currency
    [Arguments]    ${headline_currency}
    Select Value From Dropdown List    [NAME:HeadlineCurrencyComboBox]    ${headline_currency}

Select Hotel Segment In Request
    [Arguments]    ${hotel_segment}
    Select Dropdown Value    [NAME:Request_HotelSegmentsCombobox]    ${hotel_segment}

Select Multiple Items in Exchange Order Remarks Left Grid View By Index Range
    [Arguments]    @{index_list}
    Activate Power Express Window
    @{selected_multiple_eo_rmk_list}    Create List
    @{row_list}    Create List
    : FOR    ${i}    IN    @{index_list}
    \    ${get_cell_value}=    Get Cell Value In Data Grid Table    [NAME:FromEoDataGridView]    Row ${i}
    \    Append To List    ${selected_multiple_eo_rmk_list}    ${get_cell_value}
    \    Append To List    ${row_list}    Row ${i}
    Log    ${row_list}
    Select Multiple Cells In Data Grid Table    [NAME:FromEoDataGridView]    ${row_list}
    Log    ${selected_multiple_eo_rmk_list}
    Set Test Variable    ${selected_multiple_eo_rmk_list}

Select Multiple Items in Exchange Order Remarks Right Grid View By Index Range
    [Arguments]    ${index_low}    ${index_high}
    Activate Power Express Window
    ${selected_multiple_io_rmk_list}    Create List
    : FOR    ${i}    IN    @{index_list}
    \    ${get_cell_value}=    Get Cell Value In Data Grid Table    [NAME:FromIoDataGridView]    Row ${i}
    \    Append To List    ${selected_multiple_io_rmk_list}    ${get_cell_value}
    \    Click Cell In Data Grid Pane    [NAME:ToIoDataGridView]    Row ${i}    3
    Select Multiple Cells In Data Grid Table    [NAME:FromEoDataGridView]    Row ${index_list}
    Log    ${selected_multiple_io_rmk_list}
    Set Test Variable    ${selected_multiple_io_rmk_list}

Select Multiple Items in Itinerary Remarks Left Grid View By Index Range
    [Arguments]    @{index_list}
    Activate Power Express Window
    @{selected_multiple_io_rmk_list}    Create List
    @{row_list}    Create List
    : FOR    ${i}    IN    @{index_list}
    \    ${get_cell_value}=    Get Cell Value In Data Grid Table    [NAME:FromIoDataGridView]    Row ${i}
    \    Append To List    ${selected_multiple_io_rmk_list}    ${get_cell_value}
    \    Append To List    ${row_list}    Row ${i}
    Select Multiple Cells In Data Grid Table    [NAME:FromIoDataGridView]    ${row_list}
    Log    ${selected_multiple_io_rmk_list}
    Set Test Variable    ${selected_multiple_io_rmk_list}

Select Multiple Items in Itinerary Remarks Right Grid View By Index Range
    [Arguments]    ${index_low}    ${index_high}
    Activate Power Express Window
    Click Control Button    [NAME:ToIoDataGridView]
    Send    {PGUP}{HOME}{UP}{RIGHT}{RIGHT}{SHIFTDOWN}
    : FOR    ${index_low}    IN RANGE    ${index_high}
    \    Send    {DOWN}
    Log    Exited
    Send    {SHIFTUP}
    Copy
    ${selected_multiple_io_rmk}=    Get Clipboard Content
    @{selected_multiple_right_io_rmk_list}    Split String    ${selected_multiple_io_rmk}    \n
    Set Test Variable    @{selected_multiple_right_io_rmk_list}

Select Ors
    Click Control Button    [NAME:Request_OthersRadioButton]

Select Others
    ${object}    Determine Multiple Object Name Based On Active Tab    OthersRadioButton, Request_OthersRadioButton    False
    Click Control Button    ${object}

Select Plan
    [Arguments]    ${plan}
    Activate Power Express Window
    Select Value From Dropdown List    [NAME:PlanInsuranceComboBox]    ${plan}
    Wait Until Other Service Loader Is Not Visible

Select Processing Type
    [Arguments]    ${processing_type}
    Select Dropdown Value    [NAME:ProcessingTypeComboBox]    ${processing_type}

Select Product
    [Arguments]    ${product}
    Activate Power Express Window
    Wait Until Control Object Is Enabled    [NAME:cboProduct]
    Select Value From Dropdown List    [NAME:cboProduct]    ${product}
    ${product}    Convert To Lowercase    ${product}
    Set Suite Variable    ${product}

Select Product In Associated Charges
    [Arguments]    ${assoc_charges_product}
    Activate Power Express Window
    Wait Until Other Service Loader Is Not Visible
    Select Value From Dropdown List    [NAME:AssociatedCharges_ProductCombobox]    ${assoc_charges_product}
    [Teardown]    TakeScreenshot

Select Room Type
    [Arguments]    ${room_type}
    Select Dropdown Value    [NAME:Request_RoomTypeCombobox]    ${room_type}

Select Special Rate, No Cancellation
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_SpecialRateRadioButton, SpecialRateRadioButton    False
    Click Control Button    ${object}

Select Validity UOM
    [Arguments]    ${validity_uom}
    Select Dropdown Value    [NAME:ValidityComboBox]    ${validity_uom}

Select Vendor
    [Arguments]    ${vendor}
    Activate Power Express Window
    Wait Until Control Object Is Enabled    [NAME:cboVendor]
    Select Value From Dropdown List    [NAME:cboVendor]    ${vendor}
    ${vendor}    Convert To Lowercase    ${vendor}
    Set Suite Variable    ${vendor}

Select Vendor In Associated Charges
    [Arguments]    ${assoc_charges_vendor}
    Activate Power Express Window
    Wait Until Other Service Loader Is Not Visible
    Select Value From Dropdown List    [NAME:AssociatedCharges_VendorComboBox]    ${assoc_charges_vendor}
    ${assoc_charges_vendor}    Convert To Lowercase    ${assoc_charges_vendor}
    Set Test Variable    ${assoc_charges_vendor}

Set Address In Vendor Info Tab
    [Arguments]    ${address}
    Wait Until Control Object Is Visible    [NAME:AddressTextBox]
    Set Control Text Value    [NAME:AddressTextBox]    ${address}

Set Address Of First Name Insured Person
    [Arguments]    ${address}
    Set Control Text Value    [NAME:AddressTextBox]    ${address}
    Send    {TAB}

Set Address Of House
    [Arguments]    ${address_of_house}
    Set Control Text Value    [NAME:AddressHouseBldgTextBox]    ${address_of_house}

Set Amount
    [Arguments]    ${amount}
    Set Control Text Value    [NAME:Request_DailyRateAmountTextBox]    ${amount}

Set Area
    [Arguments]    ${area}
    Set Control Text Value    [NAME:AreaTextBox]    ${area}

Set Arrival Date
    [Arguments]    ${arrival_date}
    Set Control Text Value    [NAME:ArrivalDateTextBox]    ${arrival_date}

Set Assignee Name
    [Arguments]    ${assignee_name}
    Set Control Text Value    [NAME:AssigneeNameTextBox]    ${assignee_name}

Set Attention In Vendor Info Tab
    [Arguments]    ${attention}
    Wait Until Control Object Is Visible    [NAME:AttentionTextBox]
    Set Control Text Value    [NAME:AttentionTextBox]    ${attention}

Set BTA Description
    [Arguments]    ${bta_description}
    Wait Until Control Object Is Visible    [NAME:BtaDescriptionTextBox]
    Set Control Text Value    [NAME:BtaDescriptionTextBox]    ${bta_description}

Set CC Number
    [Arguments]    ${cc_number}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardNumberTextBox    False
    Set Control Text Value    ${object}    ${cc_number}

Set CC Preference
    [Arguments]    ${cc_preference}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardPreferenceComboBox    False
    Select Dropdown Value    ${object}    ${cc_preference}

Set CC Type
    [Arguments]    ${cc_type}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CreditCardTypesComboBox    False
    Select Dropdown Value    [NAME:Request_CreditCardTypesComboBox]    ${cc_type}

Set CWT Email In Vendor Info Tab
    [Arguments]    ${cwt_email}
    Set Control Text    [NAME:EmailTextBox]    ${cwt_email}

Set CWT Handling Fee
    [Arguments]    ${cwt_handling}
    Wait Until Control Object Is Visible    [NAME:CwtHandlingTextBox]
    Set Control Text Value    [NAME:CwtHandlingTextBox]    ${cwt_handling}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set CWT Phone In Vendor Info Tab
    [Arguments]    ${cwt_phone}
    Set Control Text    [NAME:ContactNumberTextBox]    ${cwt_phone}

Set Cancel By Text
    [Arguments]    ${cancel_by_text}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByAmountTextBox, CancelByAmountTextBox    False
    Set Control Text Value    ${object}    ${cancel_by_text}

Set Checkin Date
    [Arguments]    ${checkin_date_dd/mm/yyyy}
    Click Control Button    [NAME:Request_CheckinDateDatePicker]
    ${date}    Split String    ${checkin_date_dd/mm/yyyy}    /
    ${day}    Get Slice From List    ${date}    0    1
    Log    ${day}
    ${month}    Get Slice From List    ${date}    1    2
    Log    ${month}
    ${year}    Get Slice From List    ${date}    2    3
    Log    ${year}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${month}    1
    Send    {LEFT}
    Send    ${day}    1

Set Checkout Date
    [Arguments]    ${checkout_date_dd/mm/yyyy}
    Click Control Button    [NAME:Request_CheckoutDateDatePicker]
    ${date}    Split String    ${checkout_date_dd/mm/yyyy}    /
    ${day}    Get Slice From List    ${date}    0    1
    Log    ${day}
    ${month}    Get Slice From List    ${date}    1    2
    Log    ${month}
    ${year}    Get Slice From List    ${date}    2    3
    Log    ${year}
    Send    ${year}    1
    Send    {LEFT}
    Send    ${month}    1
    Send    {LEFT}
    Send    ${day}    1

Set City Code
    [Arguments]    ${city_code}
    Set Control Text Value    [NAME:Request_CityCodeTextBox]    ${city_code}

Set City In Request
    [Arguments]    ${request_city}
    Set Control Text Value    [NAME:CityComboBox]    ${request_city}

Set City In Vendor Info Tab
    [Arguments]    ${city}
    Wait Until Control Object Is Visible    [NAME:CityTextBox]
    Set Control Text Value    [NAME:CityTextBox]    ${city}

Set City Name
    [Arguments]    ${city_name}
    Set Control Text Value    [NAME:Request_CityNameTextBox]    ${city_name}

Set Commission Value
    [Arguments]    ${commission_input}
    Wait Until Control Object Is Visible    [NAME:CommissionTextBox]
    ${commission_percent_status}    Run Keyword And Return Status    Should Contain    ${commission_input}    %
    ${commission_input}    Replace String    ${commission_input}    %    ${EMPTY}
    Run Keyword If    ${commission_percent_status}    Click Percent Button In Commission Field
    Control Focus    ${title_power_express}    ${EMPTY}    [NAME:CommissionTextBox]
    Wait Until Other Service Loader Is Not Visible
    Set Control Text Value    [NAME:CommissionTextBox]    ${commission_input}
    Set Test Variable    ${commission_percent_status}
    Set Test Variable    ${commission_input}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Confirmation Number
    [Arguments]    ${confirmation_number}
    Set Control Text Value    [NAME:Request_ConfirmationNumberTextBox]    ${confirmation_number}

Set Contact Type In Vendor Info Tab
    [Arguments]    ${contact_type}
    Wait Until Control Object Is Visible    [NAME:ContactTypeComboBox]
    Select Value From Dropdown List    [NAME:ContactTypeComboBox]    ${contact_type}

Set Country In Request Visa Fee
    [Arguments]    ${country}
    Select Value From Dropdown List    [NAME:CountryComboBox]    India
    Set Test Variable    ${country}

Set Country In Vendor Info Tab
    [Arguments]    ${country}
    Set Control Text    [NAME:CountryTextBox]    ${country}

Set Date Of Birth When Product Is Insurance
    [Arguments]    ${date_of_birth}
    Set Control Text Value    [NAME:DateOfBirthTextBox]    ${date_of_birth}

Set Demand Draft Number
    [Arguments]    ${demand_draft_number}
    Set Control Text Value    [NAME:DemandDraftNumberTextBox]    ${demand_draft_number}

Set Departure Date
    [Arguments]    ${departure_date_insurance}
    Set Control Text Value    [NAME:DepartureDateTextBox]    ${departure_date_insurance}

Set Description
    [Arguments]    ${description}
    Wait Until Control Object Is Visible    [NAME:DescriptionTextBox]
    Set Control Text Value    [NAME:DescriptionTextBox]    ${description}

Set Description In Associated Charges
    [Arguments]    ${description}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_DescriptionTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_DescriptionTextBox]    ${description}

Set Description In Charges
    [Arguments]    ${description}
    Wait Until Control Object Is Visible    [NAME:Charges_DescriptionTextBox]
    Set Control Text Value    [NAME:Charges_DescriptionTextBox]    ${description}

Set Details In Request When Product Is Insurance
    [Arguments]    ${detail1}    ${detail2}=${EMPTY}    ${detail3}=${EMPTY}
    Set Control Text Value    [NAME:Details1TextBox]    ${detail1}
    Set Control Text Value    [NAME:Details2TextBox]    ${detail2}
    Set Control Text Value    [NAME:Details3TextBox]    ${detail3}

Set Discount Value
    [Arguments]    ${discount_input}
    Wait Until Control Object Is Visible    [NAME:DiscountTextBox]
    ${discount_percent_status}    Run Keyword And Return Status    Should Contain    ${discount_value}    %
    ${discount_input}    Replace String    ${discount_input}    %    ${EMPTY}
    Run Keyword If    ${discount_percent_status}    Click Percent Button In Discount Field
    Control Focus    ${title_power_express}    ${EMPTY}    [NAME:DiscountTextBox]
    Wait Until Other Service Loader Is Not Visible
    Set Control Text Value    [NAME:DiscountTextBox]    ${discount_input}
    Set Test Variable    ${discount_percent_status}
    Set Test Variable    ${discount_input}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Doc Type In Request Visa Fee
    [Arguments]    ${doc_type}
    Select Value From Dropdown List    [NAME:DocTypeComboBox]    Fresh
    Set Test Variable    ${doc_type}

Set Document In Request Visa Fee
    [Arguments]    ${document}
    Select Value From Dropdown List    [NAME:DocumentComboBox]    Passport
    Set Test Variable    ${document}

Set Employee Name
    [Arguments]    ${employee_name}
    Set Control Text Value    [NAME:EmployeeNameTextBox]    ${employee_name}

Set Employee Number
    [Arguments]    ${employee_number}
    Set Control Text Value    [NAME:EmployeeNumberTextBox]    ${employee_number}
    Set Suite Variable    ${employee_number}

Set End Date In Request Tour Intl
    [Arguments]    ${end_date}
    @{end_date}    Split String    ${end_date}    /
    ${day} =    Set Variable    ${end_date[0]}
    ${month} =    Set Variable    ${end_date[1]}
    ${year} =    Set Variable    ${end_date[2]}
    Populate Date    ${day}    ${month}    ${year}    [NAME:EndDateDatePicker]

Set Expiry Date In Request
    [Arguments]    ${expiry_month_mm}    ${expiry_year_yyyy}
    Click Control Button    [NAME:Request_ExpiryDateDatePicker]
    Send    ${expiry_year_yyyy}    1
    Send    {RIGHT}
    Send    ${expiry_month_mm}    1
    Send    {TAB}

Set Fare Type
    [Arguments]    ${fare_type}
    Select Dropdown Value    [NAME:FareTypeComboBox]    ${fare_type}

Set Gender
    [Arguments]    ${gender}
    Set Control Text Value    [NAME:GenderTextBox]    ${gender}

Set Hotel Address
    [Arguments]    ${hotel_address}
    Set Control Text Value    [NAME:Request_HotelAddressTextBox]    ${hotel_address}

Set Hotel Name
    [Arguments]    ${hotel_name}
    Set Control Text Value    [NAME:Request_HotelNameTextBox]    ${hotel_name}

Set Marital Status
    [Arguments]    ${marital_status}
    Set Control Text Value    [NAME:MaritalStatusTextBox]    ${marital_status}

Set Merchant Fee Percentage
    [Arguments]    ${merchant_percentage}
    Set Test Variable    ${merchant_percentage}

Set Mobile Number When Product Is Insurance
    [Arguments]    ${mobile_number}
    Set Control Text Value    [NAME:MobileNumberTextBox]    ${mobile_number}

Set Nett Cost
    [Arguments]    ${nett_cost}
    Wait Until Control Object Is Visible    [NAME:NetCostTextBox]
    Set Control Text Value    [NAME:NetCostTextBox]    ${nett_cost}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible
    Set Suite Variable    ${nett_cost}

Set Number Of People
    [Arguments]    ${number_of_people}
    Set Control Text Value    [NAME:Request_NumberOfPeopleTextBox]    ${number_of_people}

Set Others Text
    [Arguments]    ${others_text}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_CancelByOthersDescriptionTextBox, CancelByOthersDescriptionTextBox    False
    Set Control Text Value    ${object}    ${others_text}

Set Package Name In Request
    [Arguments]    ${package_name}
    Set Control Text Value    [NAME:PackageNameTextBox]    ${package_name}

Set Passport Number
    [Arguments]    ${passport_number}
    Set Control Text Value    [NAME:PassportNumberTextBox]    ${passport_number}

Set Phone Number In Request
    [Arguments]    ${phone_number}
    Set Control Text Value    [NAME:Request_PhoneNumberTexBox]    ${phone_number}

Set Pin Code
    [Arguments]    ${pin_code}
    Set Control Text Value    [NAME:PinCodeTextBox]    ${pin_code}

Set Plating Carrier
    [Arguments]    ${plating_carrier}
    Select Dropdown Value    [NAME:PlatingCarrierComboBox]    ${plating_carrier}

Set Post Code
    [Arguments]    ${post_code}
    Set Control Text Value    [NAME:Request_PostalCodeTextBox]    ${post_code}

Set Prefer In Vendor Info Tab
    [Arguments]    ${prefer}
    Run Keyword If    "${prefer.lower()}"!="false"    Tick Checkbox    [NAME:PreferCheckBox]
    ...    ELSE IF    "${prefer.lower()}"=="false"    Untick Checkbox    [NAME:PreferCheckBox]
    Comment    Wait Until Control Checkbox Is Ticked    [NAME:PreferCheckBox]

Set Product In Associated Charges
    [Arguments]    ${product}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_ProductCombobox]
    Select Value From Dropdown List    [NAME:AssociatedCharges_ProductCombobox]    ${product}
    Wait Until Other Service Loader Is Not Visible

Set Selling Price
    [Arguments]    ${selling_price}
    Wait Until Control Object Is Visible    [NAME:SellingPriceTextBox]
    Set Control Text Value    [NAME:SellingPriceTextBox]    ${selling_price}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Start Date In Request Tour Intl
    [Arguments]    ${start_date}
    [Documentation]    Start Date Format: <day>/<month/<year>
    @{start_date}    Split String    ${start_date}    /
    ${day} =    Set Variable    ${start_date[0]}
    ${month} =    Set Variable    ${start_date[1]}
    ${year} =    Set Variable    ${start_date[2]}
    Populate Date    ${day}    ${month}    ${year}    [NAME:StartDateDatePicker]

Set State
    [Arguments]    ${state}
    Set Control Text Value    [NAME:StateTextBox]    ${state}

Set State/Province
    [Arguments]    ${state_province}
    Set Control Text Value    [NAME:Request_StateOrProvinceTextBox]    ${state_province}

Set Street Name
    [Arguments]    ${street_name}
    Set Control Text Value    [NAME:StreetNameTextBox]    ${street_name}

Set Sub Area
    [Arguments]    ${sub_area}
    Set Control Text Value    [NAME:SubAreaCityTextBox]    ${sub_area}

Set Validity
    [Arguments]    ${validity}
    ${validity_object}    Determine Multiple Object Name Based On Active Tab    ValidityTextBox1,ValidityTextBox2    False
    Set Control Text Value    ${validity_object}    ${validity}

Set Validity Custom Field
    [Arguments]    ${validity_custom_field}
    Set Control Text Value    [NAME:ValidityTextBox2]    ${validity_custom_field}

Set Validity In Request Tab Document Is Visa
    [Arguments]    ${validity}
    Set Control Text Value    [NAME:ValidityTextBox]    ${validity}

Set Validity Number
    [Arguments]    ${validity_number}
    Click Control Button    [NAME:ValidityNumericUpDown]
    Send    ^a
    Send Control Text Value    [NAME:ValidityNumericUpDown]    ${validity_number}
    Send    {TAB}

Set Vendor Contact
    [Arguments]    ${vendor_contact}
    Set Control Text Value    [NAME:VendorContactTextBox]    ${vendor_contact}

Set Vendor Handling Fee
    [Arguments]    ${vendor_handling}
    Wait Until Control Object Is Visible    [NAME:VendorHandlingTextBox]
    Set Control Text Value    [NAME:VendorHandlingTextBox]    ${vendor_handling}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Set Vendor In Associated Charges
    [Arguments]    ${vendor}
    Wait Until Control Object Is Enabled    [NAME:AssociatedCharges_VendorComboBox]
    Select Value From Dropdown List    [NAME:AssociatedCharges_VendorComboBox]    ${vendor}
    Wait Until Other Service Loader Is Not Visible

Set Vendor Reference No (GSA) In Associated Charges
    [Arguments]    ${vendor_reference_gsa}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_VendorReferenceNoTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_VendorReferenceNoTextBox]    ${vendor_reference_gsa}

Set Vendor Reference No (GSA) In Charges
    [Arguments]    ${vendor_reference_gsa}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_VendorReferenceNoTextBox,Charges_VendorRefNoGsaTextBox    False
    Set Control Text Value    ${object}    ${vendor_reference_gsa}

Tick All Select All Segments Checkbox In Request Tab When Products Are Air BSp Or Air Domestic
    Wait Until Control Object Is Visible    [NAME:SelectAllCheckBox]
    Tick Checkbox    [NAME:SelectAllCheckBox]
    Wait Until Other Service Loader Is Not Visible

Tick CWT Absorb Checkbox For GST
    Activate Power Express Window
    Tick Checkbox    [NAME:GstAbsorbCheckBox]

Tick CWT Absorb Checkbox For Merchant Fee
    ${merchant_fee_checkbox}    Determine Multiple Object Name Based On Active Tab    MerchantFeeAbsorbCheckBox, CwtAbsorbCheckbox    False
    Tick Checkbox    ${merchant_fee_checkbox}

Tick Merchant Fee CWT Absorb
    ${merchant_fee_checkbox}    Determine Multiple Object Name Based On Active Tab    MerchantFeeAbsorbCheckBox,CwtAbsorbCheckbox    False
    Comment    Tick Checkbox    ${merchant_fee_checkbox}
    ${is_checked}    Get Checkbox State    ${merchant_fee_checkbox}
    Run Keyword If    ${is_checked} == False    Click Control Button    ${merchant_fee_checkbox}
    ...    ELSE    Log    CWT Absorb is already ticked by default.
    Run Keyword If    ${is_checked} == False    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

Tick Merchant Fee CheckBox For CWT Handling
    Wait Until Control Object Is Visible    [NAME:CwtHandlingMerchantCheckBox]
    Tick Checkbox    [NAME:CwtHandlingMerchantCheckBox]

Tick Merchant Fee CheckBox for Nett Cost
    Wait Until Control Object Is Visible    [NAME:NetCostMerchantCheckBox]
    Tick Checkbox    [NAME:NetCostMerchantCheckBox]

Tick Request VMPD
    Tick Checkbox    [NAME:RequestVMPDCheckbox]

Tick Select All Segments
    [Arguments]    ${checkbox_action}=TICK
    [Documentation]    Inputs:
    ...
    ...    Tick = To tick Select All Air Segment Checkbox. \ All Air Segments will be selected
    ...
    ...    Untick = To untick Select All Segment Checkbox. \ All Air Segments will be un-selected
    Activate Power Express Window
    ${select_all}    Determine Multiple Object Name Based On Active Tab    SelectAllCheckBox,SelectAllSegmentsCheckBox    False
    ${is_visible}    Is Control Visible    ${select_all}
    ${is_checked}    Run Keyword If    ${is_visible}    Get Checkbox Status    ${select_all}
    Run Keyword If    '${is_checked}' == 'False' and '${checkbox_action.upper()}' == 'TICK' and '${is_visible}' == 'True'    Tick Checkbox    ${select_all}
    Run Keyword If    '${is_checked}' == 'True' and '${checkbox_action.upper()}' == 'UNTICK' and '${is_visible}' == 'True'    Untick Checkbox    ${select_all}

Truncate Decimal Value
    [Arguments]    ${value}
    ${is_float}    Run Keyword And Return Status    Should Contain    ${value}    .
    Run Keyword If    "${is_float}"=="True"    Remove Value After Decimal    ${value}
    ...    ELSE    Set Test Variable    ${value}
    [Return]    ${value}

Unmask Credit Card Number
    Get Card Number
    ${is_mask}    Run Keyword And Return Status    Should Contain    ${card_number}    *
    Run Keyword If    "${is_mask}" == "True"    Click Control    [NAME:MaskContentButton]
    ...    ELSE    Log    Credit card number is already unmasked.

Untick CWT Absorb Checkbox For GST
    Activate Power Express Window
    Untick Checkbox    [NAME:GstAbsorbCheckBox]

Untick CWT Absorb Checkbox For Merchant Fee
    Activate Power Express Window
    ${object}    Determine Multiple Object Name Based On Active Tab    CwtAbsorbCheckbox,MerchantFeeAbsorbCheckBox    False
    Untick Checkbox    ${object}

Untick Merchant Fee CheckBox For CWT Handling
    Wait Until Control Object Is Visible    [NAME:CwtHandlingMerchantCheckBox]
    Untick Checkbox    [NAME:CwtHandlingMerchantCheckBox]

Untick Merchant Fee CheckBox For Nett Cost
    Wait Until Control Object Is Visible    [NAME:NetCostMerchantCheckBox]
    Untick Checkbox    [NAME:NetCostMerchantCheckBox]

Verify If HK Vendor Should Default To Complete Status
    [Arguments]    ${vendor_code}
    ${vendor_auto_complete}=    Create Dictionary
    Set Test Variable    ${vendor_auto_complete}    000245    ADAT SALES LTD
    Set Test Variable    ${vendor_auto_complete}    000202    Air Canada
    Set Test Variable    ${vendor_auto_complete}    000271    Air Express Ltd
    Set Test Variable    ${vendor_auto_complete}    000247    AIR FRANCE
    Set Test Variable    ${vendor_auto_complete}    000231    AIR MAURITIUS LTD
    Set Test Variable    ${vendor_auto_complete}    000220    AIR NEW ZEALAND
    Set Test Variable    ${vendor_auto_complete}    000031    AIRLINE MERCHANT
    Set Test Variable    ${vendor_auto_complete}    000233    ALITALIA
    Set Test Variable    ${vendor_auto_complete}    000234    ALL NIPPON AIRWAYS CO LTD
    Set Test Variable    ${vendor_auto_complete}    000256    AMERICAN AIRLINES
    Set Test Variable    ${vendor_auto_complete}    003122    American Express - Amy Leung
    Set Test Variable    ${vendor_auto_complete}    003040    American Express - Sheila Chan
    Set Test Variable    ${vendor_auto_complete}    000612    AOS CONVENTIONS & EVENTS SDN BHD
    Set Test Variable    ${vendor_auto_complete}    000507    ARESS TRAVEL LIMITED
    Set Test Variable    ${vendor_auto_complete}    000409    BAO SHINN EXPRESS LTD
    Set Test Variable    ${vendor_auto_complete}    000291    BEST HOLIDAYS LTD
    Set Test Variable    ${vendor_auto_complete}    000802    BLUE CROSS (ASIA PACIFIC) INSURANCE LIMITED
    Set Test Variable    ${vendor_auto_complete}    000224    BRITISH AIRWAYS
    Set Test Variable    ${vendor_auto_complete}    000030    BSP
    Set Test Variable    ${vendor_auto_complete}    000201    CAAC HOLIDAYS LIMITED
    Set Test Variable    ${vendor_auto_complete}    002074    CARLSON WAGONLIT SYDNEY
    Set Test Variable    ${vendor_auto_complete}    002056    CARLSON WAGONLIT TRAVEL PERTH
    Set Test Variable    ${vendor_auto_complete}    002052    CARLSON WAGONLIT TRAVEL SEOUL
    Set Test Variable    ${vendor_auto_complete}    000407    CENTRAL HOTEL SHANGHAI
    Set Test Variable    ${vendor_auto_complete}    000262    CENTRAL SKY TRAVEL LIMITED
    Set Test Variable    ${vendor_auto_complete}    000309    CHARMING HOLIDAYS LTD
    Set Test Variable    ${vendor_auto_complete}    000326    CHENGDU OVERSEAS TRAVEL SERVICES CO LTD
    Set Test Variable    ${vendor_auto_complete}    000263    CHINA EASTERN
    Set Test Variable    ${vendor_auto_complete}    000258    CHINA SOUTHERN AIRLINES HONGKONG OFFICE
    Set Test Variable    ${vendor_auto_complete}    000279    CHINA TRAVEL MGT SVCS CO LTD Guangzhou
    Set Test Variable    ${vendor_auto_complete}    000208    CHINA TRAVEL SERVICE (HK) LTD
    Set Test Variable    ${vendor_auto_complete}    000331    CHU KONG HIGH-SPEED FERRY COMPANY LIMITED
    Set Test Variable    ${vendor_auto_complete}    000298    CHU KONG PASSENGER TRANSPORT CO LTD
    Set Test Variable    ${vendor_auto_complete}    000222    CITIZEN THUNDERBIRD TRAVEL LTD
    Set Test Variable    ${vendor_auto_complete}    000248    CONTINENTAL AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000453    CROWN PLAZA MUTIARA KUALA LUMPUR
    Set Test Variable    ${vendor_auto_complete}    000001    CWT
    Set Test Variable    ${vendor_auto_complete}    002064    CWT ARNHEM NETHERLAND
    Set Test Variable    ${vendor_auto_complete}    002003    CWT BANGALORE
    Set Test Variable    ${vendor_auto_complete}    000296    CWT CHINA JV-BEIJING
    Set Test Variable    ${vendor_auto_complete}    000297    CWT CHINA JV-GUANGZHOU
    Set Test Variable    ${vendor_auto_complete}    000281    CWT CHINA JV-SHANGHAI
    Set Test Variable    ${vendor_auto_complete}    000295    CWT DALIAN
    Set Test Variable    ${vendor_auto_complete}    002069    CWT DELHI
    Set Test Variable    ${vendor_auto_complete}    002067    CWT LONDON
    Set Test Variable    ${vendor_auto_complete}    002073    CWT MUMBAI
    Set Test Variable    ${vendor_auto_complete}    002071    CWT PORTUGAL
    Set Test Variable    ${vendor_auto_complete}    002072    CWT STOCKHOLM
    Set Test Variable    ${vendor_auto_complete}    002062    CWT SWITZERLAND
    Set Test Variable    ${vendor_auto_complete}    002057    CWT TRAVEL (THAILAND) LTD
    Set Test Variable    ${vendor_auto_complete}    002055    CWT TRAVEL SINGAPORE PTE LTD
    Set Test Variable    ${vendor_auto_complete}    000811    CWT VISA
    Set Test Variable    ${vendor_auto_complete}    000287    DEKS AIR (HK) LTD
    Set Test Variable    ${vendor_auto_complete}    000218    DELTA PACIFIC COMPANY LTD
    Set Test Variable    ${vendor_auto_complete}    000502    DELUXE COMPANY
    Set Test Variable    ${vendor_auto_complete}    000613    DIETHELM EVENTS
    Set Test Variable    ${vendor_auto_complete}    000251    EAST ASIA AIRLINES LTD
    Set Test Variable    ${vendor_auto_complete}    000299    EMIRATE AIRLINE
    Set Test Variable    ${vendor_auto_complete}    000327    ESTORIL TRAVEL INTERNATIONAL
    Set Test Variable    ${vendor_auto_complete}    000513    ETERNAL EAST CROSS BORDER COAC
    Set Test Variable    ${vendor_auto_complete}    000239    EVA AIRWAYS CORPORATION
    Set Test Variable    ${vendor_auto_complete}    000812    F.S. DEVELOPMENT CO
    Set Test Variable    ${vendor_auto_complete}    000603    FAE TRAVEL
    Set Test Variable    ${vendor_auto_complete}    000255    FALCON MARKETING LTD
    Set Test Variable    ${vendor_auto_complete}    000505    FAR EAST RENT A CAR LTD
    Set Test Variable    ${vendor_auto_complete}    003075    FEDERAL INSURANCE COMPANY
    Set Test Variable    ${vendor_auto_complete}    000101    Finnair
    Set Test Variable    ${vendor_auto_complete}    000288    FIRST MARKETING
    Set Test Variable    ${vendor_auto_complete}    000268    G.C Nanda and Sons (HK) Ltd
    Set Test Variable    ${vendor_auto_complete}    000223    GLOBAIR LIMITED
    Set Test Variable    ${vendor_auto_complete}    000259    GLOBALRES DIGITAL TRAVEL SERVICES LTD
    Set Test Variable    ${vendor_auto_complete}    000410    GOLD CHOICE HOLIDAYS LTD
    Set Test Variable    ${vendor_auto_complete}    000216    GOLDJOY TRAVEL LIMITED
    Set Test Variable    ${vendor_auto_complete}    002068    GRAND TRAVEL INC
    Set Test Variable    ${vendor_auto_complete}    000293    GREAT EASTERN TOURIST LTD
    Set Test Variable    ${vendor_auto_complete}    000514    HOLIDAY TOURS & TRAVEL LTD
    Set Test Variable    ${vendor_auto_complete}    002053    HOLIDAY TOURS AND TRAVEL
    Set Test Variable    ${vendor_auto_complete}    000267    HONG KONG AIRLINES LIMITED
    Set Test Variable    ${vendor_auto_complete}    000266    Hong Kong Express Airways Ltd
    Set Test Variable    ${vendor_auto_complete}    000816    I.V.S. (HK) COMPANY LTD
    Set Test Variable    ${vendor_auto_complete}    000253    INCOLA AIR SERVICES LTD
    Set Test Variable    ${vendor_auto_complete}    000521    INTERCONTINENTAL HIRE CARS LTD
    Set Test Variable    ${vendor_auto_complete}    000236    JAPAN AIRLINES INTERNATIONAL CO LTD
    Set Test Variable    ${vendor_auto_complete}    000314    JBC TRAVEL CO LTD
    Set Test Variable    ${vendor_auto_complete}    000324    JEBSEN TRAVEL LTD
    Set Test Variable    ${vendor_auto_complete}    000301    JET AIRWAYS (INDIA) LTD
    Set Test Variable    ${vendor_auto_complete}    000522    Jin Jiang Car Rent Ltd
    Set Test Variable    ${vendor_auto_complete}    000813    JTB (HK) LTD
    Set Test Variable    ${vendor_auto_complete}    000329    JTB Asia Toursit Corp
    Set Test Variable    ${vendor_auto_complete}    000702    JUBILEE INTERNATIONAL TOUR CENTRE LIMITED
    Set Test Variable    ${vendor_auto_complete}    000510    KINGS CAR HIRING SERVICES LTD
    Set Test Variable    ${vendor_auto_complete}    000232    KLM ROYAL DUTCH
    Set Test Variable    ${vendor_auto_complete}    000238    KOREAN AIR
    Set Test Variable    ${vendor_auto_complete}    000455    LAGUNA HOLIDAY CLUB LTD
    Set Test Variable    ${vendor_auto_complete}    000452    LANGHAM HOTEL HONG KONG
    Set Test Variable    ${vendor_auto_complete}    000524    Leadtime International Limousine Service Co. Ltd
    Set Test Variable    ${vendor_auto_complete}    000213    LOTUS TOURS LTD
    Set Test Variable    ${vendor_auto_complete}    000333    Low Cost Carrier
    Set Test Variable    ${vendor_auto_complete}    000241    Lufthansa German Airlines
    Set Test Variable    ${vendor_auto_complete}    000991    M&E - Handling Fee
    Set Test Variable    ${vendor_auto_complete}    000992    M&E- Staff Referral
    Set Test Variable    ${vendor_auto_complete}    000242    MALAYSIA AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000254    MARVEL TOURS LTD
    Set Test Variable    ${vendor_auto_complete}    000981    MATAMANOA ISLAND RESORT
    Set Test Variable    ${vendor_auto_complete}    000286    MAYNILA HOLIDAYS LTD
    Set Test Variable    ${vendor_auto_complete}    000610    MEET AND GREET SERVICES
    Set Test Variable    ${vendor_auto_complete}    000457    MICE Hotel
    Set Test Variable    ${vendor_auto_complete}    003103    MICE Others
    Set Test Variable    ${vendor_auto_complete}    000519    MIRAMAR HOTEL AND INVESTMENT
    Set Test Variable    ${vendor_auto_complete}    000325    MODERN CHINA TRAVEL AGENCY LTD
    Set Test Variable    ${vendor_auto_complete}    000703    MTR CORPORATION LIMITED
    Set Test Variable    ${vendor_auto_complete}    000332    N.K. TOURS
    Set Test Variable    ${vendor_auto_complete}    000203    NAN HWA (EXPRESS) TVL SERVICE
    Set Test Variable    ${vendor_auto_complete}    000701    NEW WORLD FIRST TRAVEL SERVICES LIMITED
    Set Test Variable    ${vendor_auto_complete}    000252    NORTHWEST AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000509    PACIFIC DELIGHT TOURS OF HK LTD
    Set Test Variable    ${vendor_auto_complete}    000246    PAKISTAN INTL AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000817    PEGASUS SOLUTIONS LTD
    Set Test Variable    ${vendor_auto_complete}    000243    PHILIPPINE AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000456    PT Bintan Hotels
    Set Test Variable    ${vendor_auto_complete}    000244    QANTAS AIRWAYS LIMITED
    Set Test Variable    ${vendor_auto_complete}    000300    QATAR AIRWAYS
    Set Test Variable    ${vendor_auto_complete}    002054    RAJAH TRAVEL CORPORATION
    Set Test Variable    ${vendor_auto_complete}    000454    RIO HOTEL
    Set Test Variable    ${vendor_auto_complete}    000803    SCANDINAVIAN AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000257    SCHENKER INTERNATIONAL LUFTHANSA CITY CENTER
    Set Test Variable    ${vendor_auto_complete}    000516    SHANGHAI TOURISM CO (HK) LTD
    Set Test Variable    ${vendor_auto_complete}    000450    SHANGRI LA HOTEL (KOWLOON) LIMITED
    Set Test Variable    ${vendor_auto_complete}    000265    Shenzhen Airlines Co. Ltd
    Set Test Variable    ${vendor_auto_complete}    000819    Shoestring Travel Ltd
    Set Test Variable    ${vendor_auto_complete}    000451    SICHUAN WANDA HOTEL CO LTD
    Set Test Variable    ${vendor_auto_complete}    002028    SIGNATURE TRAVEL LTD
    Set Test Variable    ${vendor_auto_complete}    000804    SIN MA TOURS LIMITED
    Set Test Variable    ${vendor_auto_complete}    000226    SINGAPORE AIRLINES
    Set Test Variable    ${vendor_auto_complete}    000700    STYLE HOLIDAYS
    Set Test Variable    ${vendor_auto_complete}    000321    SUN SERIES CO LTD
    Set Test Variable    ${vendor_auto_complete}    000307    SUNFLOWER TRAVEL SERVICE LTD
    Set Test Variable    ${vendor_auto_complete}    000249    SWISS INTERNATIONAL AIRLINES LTD
    Set Test Variable    ${vendor_auto_complete}    002070    T & T CO LTD
    Set Test Variable    ${vendor_auto_complete}    000002    TESTING VENDOR 1
    Set Test Variable    ${vendor_auto_complete}    000003    TESTING VENDOR 2
    Set Test Variable    ${vendor_auto_complete}    000032    TESTING VENDOR 3
    Set Test Variable    ${vendor_auto_complete}    000227    THAI AIRWAYS INTERNATIONAL PUBLIC COMPANY LIMITED
    Set Test Variable    ${vendor_auto_complete}    000205    THE MARCO POLO PRINCE
    Set Test Variable    ${vendor_auto_complete}    000458    The Venetian Macao Resort Hotel
    Set Test Variable    ${vendor_auto_complete}    000815    TIN FOOK HONG TRAVEL SERVICES
    Set Test Variable    ${vendor_auto_complete}    000523    Tong Li Da Car Rent Ltd
    Set Test Variable    ${vendor_auto_complete}    000459    Tour and Incentive Travel SDN BHD
    Set Test Variable    ${vendor_auto_complete}    000215    TOUREX ASIA TRAVEL SERVICE LIMITED
    Set Test Variable    ${vendor_auto_complete}    000330    Travel Asia (HK) Ltd
    Set Test Variable    ${vendor_auto_complete}    000214    TRAVEL OPTIONS CO LTD
    Set Test Variable    ${vendor_auto_complete}    000217    TRAVEL RESOURCES LTD
    Set Test Variable    ${vendor_auto_complete}    000525    Tristar Worldwide Chauffeur Services
    Set Test Variable    ${vendor_auto_complete}    000319    UNICORN TRAVEL MANAGEMENT LIMITED
    Set Test Variable    ${vendor_auto_complete}    000225    UNITED AIRLINES
    Set Test Variable    ${vendor_auto_complete}    003123    UOB - Serene Lim
    Set Test Variable    ${vendor_auto_complete}    003118    UOB-SHEILA CHAN
    Set Test Variable    ${vendor_auto_complete}    003117    UOB-SNOWDEN CHAN
    Set Test Variable    ${vendor_auto_complete}    000512    VH AVIATION    LTD
    Set Test Variable    ${vendor_auto_complete}    000805    VIETLINK INTERNATIONAL HK LTD
    Set Test Variable    ${vendor_auto_complete}    000526    Vigor Limousines Services Ltd
    Set Test Variable    ${vendor_auto_complete}    000822    VN HK CO
    Set Test Variable    ${vendor_auto_complete}    000611    WELL SOUND INTL LTD
    Set Test Variable    ${vendor_auto_complete}    000401    WHARNEY GUANGDONG HOTEL
    Set Test Variable    ${vendor_auto_complete}    000411    WORLD AIR TRANSPORTATION LTD
    Set Test Variable    ${vendor_auto_complete}    000323    WORLD TRAVEL SERVICE LIMITED
    Set Test Variable    ${vendor_auto_complete}    000821    WORLDWIDE FLIGHT SERVICES HOLDING SA-HONG KONG BRANCH
    Set Test Variable    ${vendor_auto_complete}
    ${row_count}=    Get Length    ${vendor_auto_complete}
    ${vendor_key_auto_complete} =    Get Dictionary Keys    ${vendor_auto_complete}
    : FOR    ${each_product}    IN RANGE    ${row_count}
    \    ${auto_complete}    Set Variable If    '${vendor_code}'=='@{vendor_key_auto_complete}[${each_product}]'    True    False
    \    Exit For Loop If    '${vendor_code}'=='@{vendor_key_auto_complete}[${each_product}]'
    ${default_eo_status}    Set Variable If    '${auto_complete}'=='True'    Complete    New
    Set Suite Variable    ${default_eo_status}
    [Return]    ${auto_complete}

Wait Until Other Service Loader Is Not Visible
    Wait Until Control Object Is Not Visible    [NAME:pictureBox1]

[Obsolete] Get CWT Reference No (TK) In Associated Charges
    ${assoc_charges_cwt_ref_no}    Get Control Text Value    [NAME:AssociatedCharges_CWTReferenceNoTextBox]
    Set Suite Variable    ${assoc_charges_cwt_ref_no}

[Obsolete] Get CWT Reference No (TK) In Charges
    ${charges_cwt_ref_no}    Get Control Text Value    [NAME:Charges_CWTReferenceNoTextBox]
    Set Suite Variable    ${charges_cwt_ref_no}

[Obsolete] Get Commission In Associated Charges
    ${assoc_charges_commission}    Get Control Text Value    [NAME:AssociatedCharges_CommisionTextBox]
    Set Suite Variable    ${assoc_charges_commission}

[Obsolete] Get Commission In Charges
    ${charges_commission}    Get Control Text Value    [NAME:Charges_CommisionTextBox]
    Set Suite Variable    ${charges_commission}

[Obsolete] Get Cost Amount
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_NetCostTextBox,AssociatedCharges_NetCostTextBox    False
    ${cost_amount}    Get Control Text Value    ${object}    ${title_power_express}
    Set Suite Variable    ${cost_amount}

[Obsolete] Get Cost Amount In Associated Charges
    ${assoc_charges_cost_amount}    Get Control Text Value    [NAME:AssociatedCharges_NetCostTextBox]
    Set Suite Variable    ${assoc_charges_cost_amount}

[Obsolete] Get Cost Amount In Charges
    ${charges_cost_amount}    Get Control Text Value    [NAME:Charges_NetCostTextBox]
    Set Suite Variable    ${charges_cost_amount}

[Obsolete] Get Description In Associated Charges
    ${assoc_charges_description}    Get Control Text Value    [NAME:AssociatedCharges_DescriptionTextBox]
    Set Suite Variable    ${assoc_charges_description}

[Obsolete] Get Description In Charges
    ${charges_description}    Get Control Text Value    [NAME:Charges_DescriptionTextBox]
    Set Suite Variable    ${charges_description}

[Obsolete] Get Discount
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiscountTextBox,AssociatedCharges_DiscountTextBox,DiscountTextBox    False
    ${discount}    Get Control Text Value    ${object}    ${title_power_express}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible
    Set Suite Variable    ${discount}

[Obsolete] Get Discount In Associated Charges
    ${assoc_charges_discount}    Get Control Text Value    [NAME:AssociatedCharges_DiscountTextBox]
    Set Suite Variable    ${assoc_charges_discount}

[Obsolete] Get Discount In Charges
    ${charges_discount}    Get Control Text Value    [NAME:Charges_DiscountTextBox]
    Set Suite Variable    ${charges_discount}

[Obsolete] Get Gross Sell In Associated Charges
    ${assoc_charges_gross_sell}    Get Control Text Value    [NAME:AssociatedCharges_GrossSellTextBox]
    Set Suite Variable    ${assoc_charges_gross_sell}

[Obsolete] Get Gross Sell In Charges
    ${charges_gross_sell}    Get Control Text Value    [NAME:Charges_GrossSellTextBox]
    Set Suite Variable    ${charges_gross_sell}

[Obsolete] Get VAT/GST Amount In Associated Charges
    ${assoc_charges_vatgst_amount}    Get Control Text Value    [NAME:AssociatedCharges_GSTTextBox]
    Set Suite Variable    ${assoc_charges_vatgst_amount}

[Obsolete] Get VAT/GST Amount In Charges
    ${charges_vatgst_amount}    Get Control Text Value    [NAME:Charges_GSTTextBox]
    Set Suite Variable    ${charges_vatgst_amount}

[Obsolete] Get Vat GST Amount
    ${object}    Determine Multiple Object Name Based On Active Tab    GSTTextBox,Charges_GSTTextBox,AssociatedCharges_GSTTextBox    False
    ${vat_gst_amount}    Get Control Text Value    ${object}
    Set Test Variable    ${vat_gst_amount}

[Obsolete] Set Commission
    [Arguments]    ${commission}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_CommisionTextBox,AssociatedCharges_CommisionTextBox    False
    Set Control Text Value    ${object}    ${commission}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Commission In Associated Charges
    [Arguments]    ${commision_value}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_CommisionTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_CommisionTextBox]    ${commision_value}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Commission In Charges
    [Arguments]    ${commision_value}
    Wait Until Control Object Is Visible    [NAME:Charges_CommisionTextBox]
    Set Control Text Value    [NAME:Charges_CommisionTextBox]    ${commision_value}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Cost Amount
    [Arguments]    ${cost_amount}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_NetCostTextBox,AssociatedCharges_NetCostTextBox    False
    Set Control Text Value    ${object}    ${cost_amount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Cost Amount In Associated Charges
    [Arguments]    ${cost_amount}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_NetCostTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_NetCostTextBox]    ${cost_amount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Cost Amount In Charges
    [Arguments]    ${cost_amount}
    Wait Until Control Object Is Visible    [NAME:Charges_NetCostTextBox]
    Set Control Text Value    [NAME:Charges_NetCostTextBox]    ${cost_amount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Details
    [Arguments]    ${details}
    [Documentation]    Obsolete
    Wait Until Control Object Is Visible    [NAME:DescriptionTextBox]
    Set Control Text Value    [NAME:DescriptionTextBox]    ${details}

[Obsolete] Set Details In Request
    [Arguments]    ${request_details}
    Set Control Text Value    [NAME:DetailsTextBox]    ${request_details}

[Obsolete] Set Details In Vendor Info Tab
    [Arguments]    ${details}
    Set Control Text    [NAME:DetailsTextBox]    ${details}

[Obsolete] Set Discount
    [Arguments]    ${discount}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_DiscountTextBox,AssociatedCharges_DiscountTextBox    False
    Set Control Text Value    ${object}    ${discount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Discount In Associated Charges
    [Arguments]    ${discount}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_DiscountTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_DiscountTextBox]    ${discount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Discount In Charges
    [Arguments]    ${discount}
    Wait Until Control Object Is Visible    [NAME:Charges_DiscountTextBox]
    Set Control Text Value    [NAME:Charges_DiscountTextBox]    ${discount}
    Send    {TAB}
    Wait Until Other Service Loader Is Not Visible

[Obsolete] Set Other Related No (PO) In Associated Charges
    [Arguments]    ${other_related_reference_po}
    Wait Until Control Object Is Visible    [NAME:AssociatedCharges_OtherRelatedNoTextBox]
    Set Control Text Value    [NAME:AssociatedCharges_OtherRelatedNoTextBox]    ${other_related_reference_po}

[Obsolete] Set Other Related No (PO) In Charges
    [Arguments]    ${other_related_reference_po}
    Wait Until Control Object Is Visible    [NAME:Charges_OtherRelatedNoTextBox]
    Set Control Text Value    [NAME:Charges_OtherRelatedNoTextBox]    ${other_related_reference_po}

[Obsolote] Get Other Related No (PO) In Associated Charges
    ${assoc_charges_other_related_no}    Get Control Text Value    [NAME:AssociatedCharges_OtherRelatedNoTextBox]
    Set Suite Variable    ${assoc_charges_other_related_no}

[Obsolote] Get Other Related No (PO) In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OtherRelatedNoTextBox,Charges_OtherRelatedNoPoTextBox    False
    ${charges_other_related_no}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_other_related_no}

[Obsolote] Get Vendor Reference No (GSA) In Associated Charges
    ${assoc_charges_vendor_ref_no}    Get Control Text Value    [NAME:AssociatedCharges_VendorReferenceNoTextBox]
    Set Suite Variable    ${assoc_charges_vendor_ref_no}

[Obsolote] Get Vendor Reference No (GSA) In Charges
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_VendorReferenceNoTextBox,Charges_VendorRefNoGsaTextBox    False
    ${charges_vendor_ref_no}    Get Control Text Value    ${object}
    Set Suite Variable    ${charges_vendor_ref_no}

Get Country
    ${object}    Determine Multiple Object Name Based On Active Tab    CountryTextBox    False
    ${country_other_services}    Get Control Text Value    ${object}
    Set Suite Variable    ${country_other_services}

Populate Other Svcs Panel With Default Values
    Click Panel    Other Svcs