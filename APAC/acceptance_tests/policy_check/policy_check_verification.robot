*** Settings ***
Resource          ../../resources/panels/policy_check.robot

*** Keywords ***
Verify Air Cabin Policy Remarks Are Not Written
    [Arguments]    ${air_cabin_item_id}    ${cabin_policy_status}
    ${policy_status_code}    Get Substring    ${cabin_policy_status}    0    2
    Verify Specific Line Is Not Written In The PNR    RMJ PCHK:ACP${air_cabin_item_id}-${policy_status_code}-AIR CABIN

Verify Air Cabin Policy Remarks Are Written
    [Arguments]    ${air_cabin_item_id}    ${cabin_policy_status}
    ${policy_status_code}    Get Substring    ${cabin_policy_status}    0    2
    Verify Specific Line Is Written In The PNR    RMJ PCHK:ACP${air_cabin_item_id}-${policy_status_code}-AIR CABIN

Verify Air Vendor Policy Remarks Are Not Written
    [Arguments]    ${vendor_item_id}    ${policy_reason}    ${policy_status}
    Verify Specific Line Is Not Written In The PNR    RMM ONHOLD:AWAITING APPROVAL
    Verify Specific Line Is Not Written In The PNR    RMJ PCHK:AVP${vendor_item_id}-AA-AIR VENDOR
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: RESTRICTED LIST B CARRIER(S) BELOW HAS BEEN
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: BOOKED. PLEASE ADVISE CALLER TO USE DISCRETION
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: WHEN USING THIS CARRIER. APPROVAL FROM
    Verify Specific Line Is Not Written In The PNR    MANAGEMENT
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: IS REQUIRED PRIOR TO TRAVEL.
    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status}

Verify Air Vendor Policy Remarks Are Written
    [Arguments]    ${vendor_item_id}    ${policy_reason}    ${policy_status}    ${country}
    Verify Specific Line Is Written In The PNR    RMM ONHOLD:AWAITING APPROVAL
    ${air_vendor_policy_status}    Get Substring    ${policy_status}    0    2
    Verify Specific Line Is Written In The PNR    RMJ PCHK:AVP${vendor_item_id}-${air_vendor_policy_status}-AIR VENDOR
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR REASON: ${policy_reason}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: RESTRICTED LIST B CARRIER(S) BELOW HAS BEEN
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: RESTRICTED LIST B CARRIER(S) BELOW HAS BEEN
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: BOOKED. PLEASE ADVISE CALLER TO USE DISCRETION
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: BOOKED. PLEASE ADVISE CALLER TO USE DISCRETION
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: WHEN USING THIS CARRIER. APPROVAL FROM
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: WHEN USING THIS CARRIER. APPROVAL FROM
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: IS REQUIRED PRIOR TO TRAVEL.
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: IS REQUIRED PRIOR TO TRAVEL.
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR STATUS: ${policy_status}

Verify City Policy Remarks Are Not Written
    [Arguments]    ${city_item_id}    ${policy_reason}    ${policy_advice}    ${policy_status_city}
    ${policy_status_code}    Get Substring    ${policy_status_city}    0    2
    Verify Specific Line Is Not Written In The PNR    RMJ PCHK:PTP${city_item_id}-${policy_status_code}-CITY
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: ${policy_advice}
    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status_city}

Verify City Policy Remarks Are Written
    [Arguments]    ${city_item_id}    ${policy_reason}    ${policy_advice}    ${policy_status_city}    ${country}
    ${policy_status_code}    Get Substring    ${policy_status_city}    0    2
    Verify Specific Line Is Written In The PNR    RMJ PCHK:PTP${city_item_id}-${policy_status_code}-CITY
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR REASON: ${policy_reason}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: ${policy_advice}
    ...    ELSE IF    "${policy_advice}" != "${EMPTY}"    Verify Specific Line Is Written In The PNR    RIR ADVICE: ${policy_advice}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status_city}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR STATUS: ${policy_status_city}

Verify Country Policy Remarks Are Not Written
    [Arguments]    ${country_item_id}    ${policy_reason}    ${policy_advice}    ${policy_status_country}
    ${policy_status_code}    Get Substring    ${policy_status_country}    0    2
    Verify Specific Line Is Not Written In The PNR    RMJ PCHK:PCP${country_item_id}-${policy_status_code}-COUNTRY
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    Run Keyword If    "${policy_advice}"<> "${EMPTY}"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: ${policy_advice}
    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status_country}

Verify Country Policy Remarks Are Written
    [Arguments]    ${country_item_id}    ${policy_reason}    ${policy_advice}    ${policy_status_country}    ${country}
    ${policy_status_code}    Get Substring    ${policy_status_country}    0    2
    Verify Specific Line Is Written In The PNR    RMJ PCHK:PCP${country_item_id}-${policy_status_code}-COUNTRY
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR REASON: ${policy_reason}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: ${policy_advice}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: ${policy_advice}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status_country}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR STATUS: ${policy_status_country}

Verify Malaria Policy Remark Is Not Written
    [Arguments]    ${policy_reason}
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}

Verify Malaria Policy Remarks Are Not Written
    [Arguments]    ${policy_reason}    ${policy_status}
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: A COUNTRY ON MALARIA NOTIFICATION LIST BELOW HAS
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: BEEN BOOKED. PLEASE ADVISE CALLER THAT CWT WILL
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: SEND LETTER REGARDING ACTION PRIOR TO TRAVELLING
    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status}

Verify Malaria Policy Remarks Are Written
    [Arguments]    ${policy_reason}    ${policy_status}    ${country}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${policy_reason}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR REASON: ${policy_reason}
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: A COUNTRY ON MALARIA NOTIFICATION LIST BELOW HAS
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: A COUNTRY ON MALARIA NOTIFICATION LIST BELOW HAS
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: BEEN BOOKED. PLEASE ADVISE CALLER THAT CWT WILL
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: BEEN BOOKED. PLEASE ADVISE CALLER THAT CWT WILL
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: SEND LETTER REGARDING ACTION PRIOR TO TRAVELLING
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: SEND LETTER REGARDING ACTION PRIOR TO TRAVELLING.    true    true
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${policy_status}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR STATUS: ${policy_status}

Verify Yellow Fever Policy Remarks Are Not Written
    [Arguments]    ${yellow_country}    ${yellow_policy_status}
    Verify Specific Line Is Not Written In The PNR    RIR ******************* HEALTH RECOMMENDATION
    Verify Specific Line Is Not Written In The PNR    RIR FOR DESTINATIONS: ${yellow_country}
    Verify Specific Line Is Not Written In The PNR    RIR YELLOW FEVER VACCINATION IS REQUIRED 10 DAYS PRIOR TO
    Verify Specific Line Is Not Written In The PNR    RIR A VACCINATION CERTIFICATE IS REQUIRED FOR ALL THE
    Verify Specific Line Is Not Written In The PNR    RIR OVER SIX MONTHS OF AGE
    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${yellow_country} YELLOW FEVER
    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: YELLOW FEVER VACCINATION IS REQUIRED.
    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${yellow_policy_status}

Verify Yellow Fever Policy Remarks Are Written
    [Arguments]    ${yellow_country}    ${yellow_policy_status}    ${country}    ${country_item_id}
    Verify Specific Line Is Written In The PNR    RIR ******************* HEALTH RECOMMENDATION
    Verify Specific Line Is Written In The PNR    \ \ \ \ \ \ *******************
    Verify Specific Line Is Written In The PNR    RIR FOR DESTINATIONS: ${yellow_country}
    Verify Specific Line Is Written In The PNR    RIR YELLOW FEVER VACCINATION IS REQUIRED 10 DAYS PRIOR TO
    Verify Specific Line Is Written In The PNR    \ \ TRAVEL.
    Verify Specific Line Is Written In The PNR    RIR A VACCINATION CERTIFICATE IS REQUIRED FOR ALL THE
    Verify Specific Line Is Written In The PNR    \ \ TRAVELER
    Verify Specific Line Is Written In The PNR    RIR OVER SIX MONTHS OF AGE
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR REASON: ${yellow_country} YELLOW FEVER
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR REASON: ${yellow_country} YELLOW FEVER
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR ADVICE: YELLOW FEVER VACCINATION IS REQUIRED.
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR ADVICE: YELLOW FEVER VACCINATION IS REQUIRED.
    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Verify Specific Line Is Not Written In The PNR    RIR STATUS: ${yellow_policy_status}
    ...    ELSE    Verify Specific Line Is Written In The PNR    RIR STATUS: ${yellow_policy_status}
    ${policy_status_code}    Get Substring    ${yellow_policy_status}    0    2
    Verify Specific Line Is Written In The PNR    RMJ PCHK:PCP${country_item_id}-${policy_status_code}-COUNTRY

Verify Policy Status Is Defaulted To Correct Value
    [Arguments]    ${policy_name}    ${policy_reason}    ${expected_policy_status}
    ${policy_status_row_number}    Get Policy Status Row Number    ${policy_name}    ${policy_reason}
    Control Click    ${title_Express}    ${EMPTY}    [NAME:ccboPolicyStatus${policy_status_row_number}]
    ${actual_policy_status}    Get Control Text Value    [NAME:ccboPolicyStatus${policy_status_row_number}]
    Verify Text Contains Expected Value    ${actual_policy_status}    ${expected_policy_status}

Get Policy Status Row Number
    [Arguments]    ${policy_name}    ${policy_reason}    ${apply_search_pattern}=False
    : FOR    ${policy_row}    IN RANGE    10
    \    ${actual_policy_name}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblPolicySegmentData${policy_row}]
    \    ${actual_policy_reason}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:clblPolicyReason${policy_row}]
    \    ${is_policy_name_equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${policy_name}    ${actual_policy_name}
    \    ${is_policy_reason_equal}    Run Keyword If    "${apply_search_pattern}" == "True"    Run Keyword And Return Status    Should Match Regexp    ${actual_policy_reason}
    \    ...    ${policy_reason}
    \    ...    ELSE IF    "${apply_search_pattern}" == "False"    Run Keyword And Return Status    Should Be Equal As Strings    ${policy_reason}
    \    ...    ${actual_policy_reason}
    \    ${policy_status_row}    Run Keyword And Return If    ${is_policy_reason_equal} == True and ${is_policy_reason_equal} == True    Set Variable    ${policy_row}
    \    Run Keyword If    ${is_policy_reason_equal} == True and ${is_policy_reason_equal} == True    Exit For Loop
    \    ...    ELSE IF    ${is_policy_reason_equal} == False and ${is_policy_reason_equal} == False and ${policy_row} == 9    Fail    Cannot find combintaion of Policy Name: ${policy_name} and of Policy Reason: ${policy_reason}
    [Return]    ${policy_status_row}
