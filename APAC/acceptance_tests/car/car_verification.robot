*** Settings ***
Resource          ../../resources/panels/car.robot

*** Keywords ***
Verify Car Tab Fields Are Mandatory
    Verify Control Object Field Is Mandatory    [NAME:cbCommissionable]
    Verify Control Object Field Is Mandatory    [NAME:cbRealisedSaving]
    Verify Control Object Field Is Mandatory    [NAME:cbPaymentType]
    [Teardown]    Take Screenshot

Verify Car Tab Values Are Populated Correctly
    [Arguments]    ${expected_car_high_rate}    ${expected_car_low_rate}    ${expected_car_charged_rate}    ${expected_car_currency}    ${expected_car_rate_type}    ${expected_car_realised_savings}
    ...    ${expected_car_missed_savings}    ${expected_car_payment_type}    ${expected_car_commissionable}    ${expected_car_commission}    ${expected_car_booking_method}    ${expected_car_assoc_remarks}
    Get Car Tab Values
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_high_rate}    ${expected_car_high_rate}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_low_rate}    ${expected_car_low_rate}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_charged_rate}    ${expected_car_charged_rate}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_currency}    ${expected_car_currency}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_rate_type}    ${expected_car_rate_type}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_realised_savings}    ${expected_car_realised_savings}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_missed_savings}    ${expected_car_missed_savings}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_payment_type}    ${expected_car_payment_type}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_commissionable}    ${expected_car_commissionable}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_commission}    ${expected_car_commission}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_booking_method}    ${expected_car_booking_method}
    Run Keyword And Continue On Failure    Should Be Equal    ${actual_car_assoc_remarks}    ${expected_car_assoc_remarks}
    [Teardown]    Take Screenshot

Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy
    [Arguments]    ${policy}    ${expected_car_currency}    ${expected_car_missed_savings}    ${expected_booking_method}
    ${policy}    Convert To Lowercase    ${policy}
    Get Car Tab Values
    Should Be Equal    ${actual_car_charged_rate}    ${expected_car_charged_rate}
    Run Keyword If    '${policy}'=='no policy' or '${policy}'=='in policy'    Should be Equal    ${actual_car_high_rate}    ${actual_car_charged_rate}
    ...    ELSE IF    '${policy}'=='out of policy'    Should be Equal    ${actual_car_high_rate}    ${EMPTY}
    Run Keyword If    '${policy}'=='no policy' or '${policy}'=='in policy'    Should be Equal    ${actual_car_low_rate}    ${actual_car_charged_rate}
    ...    ELSE IF    '${policy}'=='out of policy'    Should be Equal    ${actual_car_low_rate}    ${EMPTY}
    Should Be Equal    ${actual_car_currency}    ${expected_car_currency}
    ${expected_car_rate_type}    Get Car Rate Type In GDS    ${expected_car_currency}    ${expected_car_charged_rate}
    Should Be Equal    ${actual_car_rate_type}    ${expected_car_rate_type}
    Should Be Empty    ${actual_car_realised_savings}
    Should Be Equal    ${actual_car_missed_savings}    ${expected_car_missed_savings}
    Should Be Empty    ${actual_car_payment_type}
    Should Be Empty    ${actual_car_commissionable}
    Should Be Empty    ${actual_car_commission}
    Should Be Equal    ${actual_car_booking_method}    ${expected_booking_method}
    Should Be Empty    ${actual_car_assoc_remarks}
    [Teardown]    Take Screenshot

Verify Commission Field Is Disabled
    Verify Control Object Is Disabled    [NAME:ctxtCommission]
    [Teardown]    Take Screenshot

Verify Commission Field Is Populated Correctly
    [Arguments]    ${expected_car_commission}
    Get Car Commission
    Should Be Equal    ${actual_car_commission}    ${expected_car_commission}

Verify Correct Car Remarks Per Panel Written to PNR
    [Arguments]    ${carrier}    ${airport}    ${pickup_date}    ${charged_fare}    ${retrieve_pnr}
    Get Car Tab Values
    Run Keyword If    "${retrieve_pnr.lower()}" == "yes"    Retrieve PNR Details from Amadeus    ${current_pnr}    \    false
    ${realised_code}    Get Code From Dropdown Value    ${actual_car_realised_savings}    -
    ${missed_code}    Get Code From Dropdown Value    ${actual_car_missed_savings}    -
    ${payment_code}    Get Code From Dropdown Value    ${actual_car_payment_type}    -
    ${rate_code}    Set Variable If    "${actual_car_rate_type}" == "Weekly"    WY    DY
    ${booking_code}    Set Variable If    "${actual_car_booking_method}" == "GDS"    G    M
    ${expected_remark}    Generate Expected PNR Remark    RM CAR REPTOKEN-REPTOKEN-REPTOKEN-REPTOKEN HR-REPTOKEN/CR-REPTOKEN/LR-REPTOKEN    REPTOKEN    ${carrier}    ${airport}    ${pickup_date}
    ...    ${charged_fare}    ${actual_car_high_rate}    ${actual_car_charged_rate}    ${actual_car_low_rate}
    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}
    ${expected_remark}    Generate Expected PNR Remark    RM CAR REPTOKEN-REPTOKEN-REPTOKEN-REPTOKEN C-REPTOKEN/RT-REPTOKEN/RSC-REPTOKEN/MSC-REPTOKEN    REPTOKEN    ${carrier}    ${airport}    ${pickup_date}
    ...    ${charged_fare}    ${actual_car_currency}    ${rate_code}    ${realised_code}    ${missed_code}
    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}
    ${expected_remark}    Generate Expected PNR Remark    RM CAR REPTOKEN-REPTOKEN-REPTOKEN-REPTOKEN PT-REPTOKEN/    REPTOKEN    ${carrier}    ${airport}    ${pickup_date}
    ...    ${charged_fare}    ${payment_code}
    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}
    ${expected_remark}    Generate Expected PNR Remark    RM CAR REPTOKEN-REPTOKEN-REPTOKEN-REPTOKEN CC-REPTOKEN/CV-PCT-REPTOKEN    REPTOKEN    ${carrier}    ${airport}    ${pickup_date}
    ...    ${charged_fare}    ${actual_car_commissionable.upper()}    ${actual_car_commission}
    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}
    ${expected_remark}    Generate Expected PNR Remark    RM *VFF36/REPTOKEN/    REPTOKEN    ${booking_code}
    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}
    ${expected_remark}    Generate Expected PNR Remark    RIR REPTOKEN/S    REPTOKEN    ${actual_car_assoc_remarks}
    Run Keyword Unless    "${actual_car_assoc_remarks}" == "${EMPTY}"    Run Keyword And Continue On Failure    Verify Specific Line Is Written In The PNR    ${expected_remark}

Verify Correct Car Segment Related Remarks Are Written In The PNR
    [Arguments]    ${segment}    ${get_tab_values}=true
    Run Keyword If    "${get_tab_values}"=="true"    Get Car Tab Values
    Verify Specific Line Is Written In The PNR    RM *VLF/${actual_car_low_rate}/${segment}
    Verify Specific Line Is Written In The PNR    RM *VRF/${actual_car_high_rate}/${segment}
    ${missed_savings_code}    Get Substring    ${actual_car_missed_savings}    0    2
    ${missed_savings_code}    Strip String    ${missed_savings_code}
    Verify Specific Line Is Written In The PNR    RM *VEC/${missed_savings_code}/${segment}
    ${realised_savings_code}    Get Substring    ${actual_car_realised_savings}    0    2
    ${realised_savings_code}    Strip String    ${realised_savings_code}
    Verify Specific Line Is Written In The PNR    RM *VFF30/${realised_savings_code}/${segment}
    Run Keyword If    '${actual_car_commissionable.upper()}'=='YES'    Verify Specific Line Is Written In The PNR    RM *VCM/P${actual_car_commission}/${segment}
    ...    ELSE IF    '${actual_car_commissionable.upper()}'=='NO'    Verify Specific Line Is Not Written In The PNR    RM *VCM/P${actual_car_commission}/${segment}
    Run Keyword If    '${actual_car_commissionable.upper()}'=='NO'    Verify Specific Line Is Written In The PNR    RM *NOCOMM/${segment}
    ...    ELSE IF    '${actual_car_commissionable.upper()}'=='YES'    Verify Specific Line Is Not Written In The PNR    RM *NOCOMM/${segment}
    ${payment_type_code}    Get Substring    ${actual_car_payment_type}    0    1
    Verify Specific Line Is Written In The PNR    RM *VFF33/${payment_type_code}/${segment}
    Verify Specific Line Is Written In The PNR    RM *VFF34/AB/${segment}
    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/${segment}
    ${booking_method_code}    Get Substring    ${actual_car_booking_method}    0    1
    Verify Specific Line Is Written In The PNR    RM *VFF36/${booking_method_code}/${segment}
    ${active_or_passive}    Set Variable If    '${booking_method_code}'=='G'    A    P
    Verify Specific Line Is Written In The PNR    RM *VFF39/${active_or_passive}/${segment}
    Run Keyword If    '${actual_car_assoc_remarks}'!='${EMPTY}'    Verify Specific Line Is Written In The PNR    RIR ${actual_car_assoc_remarks}/${segment}
    ...    ELSE IF    '${actual_car_assoc_remarks}'=='${EMPTY}'    Verify Specific Line Is Not Written In The PNR    RIR ${actual_car_assoc_remarks}/${segment}