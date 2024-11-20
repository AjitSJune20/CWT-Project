*** Settings ***
Resource          ../common/core.robot

*** Keywords ***
Click Car Tab
    [Arguments]    ${car_tab}    ${identifier}=${EMPTY}    ${by_tab_number}=False
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Test Variable    ${car_tab}    ${car_city${identifier}} - ${car_departure_date${identifier}}
    Run Keyword If    "${by_tab_number}" == "True"    Select Tab Control    ${car_tab}    tabCarFares    True    ELSE    Select Tab Control    ${car_tab}
    ${car_index} =    Fetch From Right    ${car_tab}    ${SPACE}
    Set Test Variable    ${car_index}

Get Car Associated Remarks
    ${actual_car_assoc_remarks}    Get Control Text Current Value    [NAME:ctxtRemarks]
    Set Suite Variable    ${actual_car_assoc_remarks}
    Log    ${actual_car_assoc_remarks}

Get Car Booking Method
    ${actual_car_booking_method}    Get Control Text Current Value    [NAME:cbBookingMethod]
    Set Suite Variable    ${actual_car_booking_method}
    Log    ${actual_car_booking_method}

Get Car Charged Rate
    ${actual_car_charged_rate}    Get Control Text Current Value    [NAME:ctxtChargedFare]
    Set Suite Variable    ${actual_car_charged_rate}
    Log    ${actual_car_charged_rate}

Get Car Commission
    ${actual_car_commission}    Get Control Text Current Value    [NAME:ctxtCommission]
    Set Suite Variable    ${actual_car_commission}
    Log    ${actual_car_commission}

Get Car Commissionable
    ${actual_car_commissionable}    Get Control Text Current Value    [NAME:cbCommissionable]
    Set Suite Variable    ${actual_car_commissionable}
    Log    ${actual_car_commissionable}

Get Car Currency
    ${actual_car_currency}    Get Control Text Current Value    [NAME:txtCurrency]
    Set Suite Variable    ${actual_car_currency}
    Log    ${actual_car_currency}

Get Car High Rate
    ${actual_car_high_rate}    Get Control Text Current Value    [NAME:ctxtHighFare]
    Set Suite Variable    ${actual_car_high_rate}
    Log    ${actual_car_high_rate}

Get Car Low Rate
    ${actual_car_low_rate}    Get Control Text Current Value    [NAME:ctxtLowFare]
    Set Suite Variable    ${actual_car_low_rate}
    Log    ${actual_car_low_rate}

Get Car Missed Savings Code
    ${actual_car_missed_savings}    Get Control Text Current Value    [NAME:cbMissedSaving]
    Set Suite Variable    ${actual_car_missed_savings}
    Log    ${actual_car_missed_savings}

Get Car Payment Type
    ${actual_car_payment_type}    Get Control Text Current Value    [NAME:cbPaymentType]
    Set Suite Variable    ${actual_car_payment_type}
    Log    ${actual_car_payment_type}

Get Car Rate Type
    ${actual_car_rate_type}    Get Control Text Current Value    [NAME:cbRateType]
    Set Suite Variable    ${actual_car_rate_type}
    Log    ${actual_car_rate_type}

Get Car Realised Savings Code
    ${actual_car_realised_savings}    Get Control Text Current Value    [NAME:cbRealisedSaving]
    Set Suite Variable    ${actual_car_realised_savings}
    Log    ${actual_car_realised_savings}

Get Car Tab Values
    Activate Power Express Window
    Get Car High Rate
    Get Car Charged Rate
    Get Car Low Rate
    Get Car Currency
    Get Car Rate Type
    Get Car Realised Savings Code
    Get Car Missed Savings Code
    Get Car Payment Type
    Get Car Commissionable
    Get Car Commission
    Get Car Booking Method
    Get Car Associated Remarks

Populate Car Tab With Values
    [Arguments]    ${hi_rate}    ${lo_rate}    ${charged_rate}    ${realised_savings}    ${missed_savings}    ${payment_type}
    ...    ${commissionable}    ${commission}    ${booking_method}    ${assoc_remarks}    ${rate_type}=${EMPTY}
    Activate Power Express Window
    Run Keyword Unless    '${hi_rate}'=='${EMPTY}'    Set Car High Rate    ${hi_rate}
    Run Keyword Unless    '${lo_rate}'=='${EMPTY}'    Set Car Low Rate    ${lo_rate}
    Run Keyword Unless    '${charged_rate}'=='${EMPTY}'    Set Car Charged Rate    ${charged_rate}
    Select Car Realised Savings Code    ${realised_savings}
    Run Keyword Unless    '${missed_savings}'=='${EMPTY}'    Select Car Missed Savings Code    ${missed_savings}
    Select Payment Type    ${payment_type}
    Select Commissionable    ${commissionable}
    Run Keyword If    '${commissionable.upper()}'=='YES'    Set Car Commission    ${commission}
    Select Booking Method In Car Panel    ${booking_method}
    Comment    Select Car Booking Method    ${booking_method}
    Set Car Associated Remarks    ${assoc_remarks}
    Run Keyword Unless    '${rate_type}'=='${EMPTY}'    Select Car Rate Type    ${rate_type}
    [Teardown]    Take Screenshot

Select Car Booking Method
    [Arguments]    ${booking_method}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    [NAME:cbBookingMethod]
    Run Keyword If    ${is_visible}    Select Value From Dropdown List    [NAME:cbBookingMethod]    ${booking_method}
    ...    ELSE    Log    "[NAME:cbBookingMethod]" is not visible    WARN

Select Car Missed Savings Code
    [Arguments]    ${missed_savings_code}
    Select Value From Dropdown List    [NAME:cbMissedSaving]    ${missed_savings_code}

Select Car Rate Type
    [Arguments]    ${payment_type_value}
    Select Value From Dropdown List    [NAME:cbRateType]    ${payment_type_value}

Select Car Realised Savings Code
    [Arguments]    ${realised_savings_code}
    Select Value From Dropdown List    [NAME:cbRealisedSaving]    ${realised_savings_code}

Select Commissionable
    [Arguments]    ${commissionable_value}
    Select Value From Dropdown List    [NAME:cbCommissionable]    ${commissionable_value}

Select Payment Type
    [Arguments]    ${payment_type_value}
    Select Value From Dropdown List    [NAME:cbPaymentType]    ${payment_type_value}

Select VAT
    [Arguments]    ${vat_value}
    Select Value From Dropdown List    [NAME:cbVat]    ${vat_value}

Set Car Associated Remarks
    [Arguments]    ${commission}
    Set Control Text    [NAME:ctxtRemarks]    ${commission}

Set Car Charged Rate
    [Arguments]    ${charged_rate}
    Set Control Text    [NAME:ctxtChargedFare]    ${charged_rate}

Set Car Commission
    [Arguments]    ${commission}
    Set Control Text    [NAME:ctxtCommission]    ${commission}

Set Car High Fare (If Blank) With Car Charged Fare
    ${obj_charged_fare}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${obj_high_fare}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    ${charged_fare}    Get Control Text Value    ${obj_charged_fare}
    ${high_fare}    Get Control Text Value    ${obj_high_fare}
    Run Keyword If    '${high_fare}' == '${EMPTY}' or '${high_fare}' < '${charged_fare}'    Set Control Text Value    ${obj_high_fare}    ${charged_fare}

Set Car High Rate
    [Arguments]    ${high_rate}
    Set Control Text    [NAME:ctxtHighFare]    ${high_rate}

Set Car Low Fare (If Blank) With Car Charged Fare
    ${obj_charged_fare}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${obj_low_fare}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    ${charged_fare}    Get Control Text Value    ${obj_charged_fare}
    ${low_fare}    Get Control Text Value    ${obj_low_fare}
    Run Keyword If    '${low_fare}' == '${EMPTY}' or '${low_fare}' > '${charged_fare}'    Set Control Text Value    ${obj_low_fare}    ${charged_fare}

Set Car Low Rate
    [Arguments]    ${low_rate}
    Set Control Text    [NAME:ctxtLowFare]    ${low_rate}

Select Booking Method In Car Panel
    [Arguments]    ${expected _booking_method}
    Select Value From Dropdown List    [NAME:cbBookingMethod]    ${expected _booking_method}

Select Touch Level In Car Panel
    [Arguments]    ${touch_level}
    Select Value From Dropdown List    [NAME:cbTouchLevel]    ${touch_level}

Get Active Car Segments
    ${active_segment}    Get Lines Using Regexp    ${pnr_details}    (\\\s+\\\d\\\sCCR.*)
    ${active_segment}    Split To Lines    ${active_segment}
    ${active_segments}    Create List
    : FOR    ${segment}    IN    @{active_segment}
    \    @{before_slash}    Split String    ${segment}    /
    \    Comment    Append To List    ${active_segments}    ${before_slash[0].replace("CCR","CAR")}    #${active_1[0]} ${active_1[1].replace("CCR","CAR")} ${active_1[2]}
    \    @{segment_items}    Split String    ${before_slash[0].replace("CCR","CAR")}    ${SPACE}
    \    ${part1} =    Set Variable    ${segment_items[0]} ${segment_items[1]} ${segment_items[2]} ${segment_items[3]} ${segment_items[4]}
    \    ${pick_date} =    Set Variable If    "${segment_items[5][0]}"!="0"    ${segment_items[5]}    ${segment_items[5][1:]}
    \    ${drop_date} =    Set Variable If    "${segment_items[6][0]}"!="0"    ${segment_items[6]}    ${segment_items[6][1:]}
    \    ${part2} =    Set Variable    ${segment_items[7]}
    \    Append To List    ${active_segments}    ${part1} ${pick_date} ${drop_date} ${part2}
    Set Test Variable    ${active_segments}

Get Current Car Segments
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTC    False
    Log    ${pnr_details}
    Get Active Car Segments
    Get Passive Car Segments

Get Passive Car Segments
    ${passive_segment}    Get Lines Using Regexp    ${pnr_details}    (\\\s+\\\d\\\sCAR.*)
    ${passive_segment}    Split To Lines    ${passive_segment}
    ${passive_segments}    Create List
    : FOR    ${segment}    IN    @{passive_segment}
    \    @{before_slash}    Split String    ${segment}    /
    \    Comment    Append To List    ${passive_segments}    ${before_slash[0]}
    \    @{segment_items}    Split String    ${before_slash[0]}    ${SPACE}
    \    ${part1} =    Set Variable    ${segment_items[0]} ${segment_items[1]} ${segment_items[2]} ${segment_items[3]} ${segment_items[4]}
    \    ${pick_date} =    Set Variable If    "${segment_items[5][0]}"!="0"    ${segment_items[5][:5]}    ${segment_items[5][1:5]}
    \    ${drop_date} =    Set Variable If    "${segment_items[5][6]}"!="0"    ${segment_items[5][6:]}    ${segment_items[5][7:]}
    \    ${part2} =    Set Variable    ${segment_items[6]}
    \    Append To List    ${passive_segments}    ${part1} ${pick_date}-${drop_date} ${part2}
    Set Test Variable    ${passive_segments}

Populate Car Panel With Default Values
    [Documentation]    Populates the Car Panel with some default values mentioned below. This keyword gets executed as a part of Populate All Panels With Default Panels, to exclude the execution pass 'Car' to Populate All Panels With Default Values Keyword.
    ...
    ...    Limitation: Tab names need to be unique. (CityCode - BookingDate, Either of CityCode or BookingDate has to be unique so that the tab names generated are unique to be determined by Get Tabs/Click Tab)
    ...
    ...    Default Values:
    ...    | 500 - High Rate
    ...    | 100 - Low Rate
    ...    | 200 - Charged Rate
    ...    | RF - RESTRICTED RATE ACCEPTED - Realised Saving
    ...    | L - Lowest rate accepted - Missed Saving
    ...    | 0 - Referral - Payment Type
    ...    | No - Commisionable
    ...    | ${EMPTY} - Commission
    ...    | Manual - Booking Type
    ...    | Associated Remarks - Associated Remarks
    ...    | Daily - Rate Type
    Comment    Retrieve PNR Details From Amadeus    ${current_pnr}    RTC    False
    Comment    Get Current Car Segments
    Click Panel    Car
    @{car_tab_items}    Get Tab Items    tabCarFares    #[NAME:tabCarFares]
    : FOR    ${tab}    IN    @{car_tab_items}
    \    Select Tab Control    ${tab}
    \    Populate Car Tab With Default Values    500    100    200    RF - RESTRICTED RATE ACCEPTED    L - Lowest rate accepted
    \    ...    0 - Referral    No    ${EMPTY}    Manual    Associated Remarks
    \    ...    Daily

Click Car Fare Tab
    [Arguments]    ${fare_tab_value}
    Verify Car Fare Tab Is Visible    ${fare_tab_value}
    Select Tab Control    ${fare_tab_value}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Set Test Variable    ${fare_tab_index}
    Sleep    1

Verify Car Fare Tab Is Visible
    [Arguments]    @{fare_tab_name}
    [Documentation]    Active and Passive Car segments retrieved by Get Car Segments Keyword.
    Wait Until Control Object Is Visible    [NAME:tabCarFares]
    ${car_tabs_pnr}    Create List
    : FOR    ${each}    IN    @{active_segments}
    \    ${tab_value}    Split String    ${each}    ${SPACE}
    \    Append To List    ${car_tabs_pnr}    ${tab_value[4]} - ${tab_value[5]}
    : FOR    ${each}    IN    @{passive_segments}
    \    ${tab_value}    Split String    ${each}    ${SPACE}
    \    ${seg_date}    Get String Matching Regexp    (\\\w{5}-)    ${tab_value[5]}
    \    ${seg_date}    Replace String    ${seg_date}    -    ${EMPTY}
    \    Append To List    ${car_tabs_pnr}    ${tab_value[4]} - ${seg_date}    #${tab_value[5[:5]]}
    : FOR    ${fare_tab}    IN    @{fare_tab_name}
    \    List Should Contain Value    ${car_tabs_pnr}    ${fare_tab}    ${fare_tab} should be visible

Populate Car Tab With Default Values
    [Arguments]    ${hi_rate}    ${lo_rate}    ${charged_rate}    ${realised_savings}    ${missed_savings}    ${payment_type}
    ...    ${commissionable}    ${commission}    ${booking_method}    ${assoc_remarks}    ${rate_type}=${EMPTY}
    [Documentation]    Used by Populate Car Panel With Default Values Keyword
    Activate Power Express Window
    ${is_high_rate_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ctxtHighFare
    ${is_low_rate_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ctxtLowFare
    ${is_charged_rate_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ctxtChargedFare
    ${is_realised_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    cbRealisedSaving
    ${is_missed_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    cbMissedSaving
    ${is_payment_type_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    cbPaymentType
    ${is_commissionable_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    cbCommissionable
    ${is_commission_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ctxtCommission
    ${is_booking_method_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    cbBookingMethod
    ${is_remarks_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ctxtRemarks
    Run Keyword If    '${hi_rate}' != '${EMPTY}' and ${is_high_rate_mandatory}    Set Car High Rate    ${hi_rate}
    Run Keyword If    '${lo_rate}' != '${EMPTY}' and ${is_low_rate_mandatory}    Set Car Low Rate    ${lo_rate}
    Run Keyword If    '${charged_rate}' != '${EMPTY}' and ${is_charged_rate_mandatory}    Set Car Charged Rate    ${charged_rate}
    Run Keyword If    ${is_realised_mandatory}    Select Car Realised Savings Code    ${realised_savings}
    Run Keyword If    '${missed_savings}' != '${EMPTY}' and ${is_missed_mandatory}    Select Car Missed Savings Code    ${missed_savings}
    Run Keyword If    ${is_payment_type_mandatory}    Select Payment Type    ${payment_type}
    Run Keyword If    ${is_commissionable_mandatory}    Select Commissionable    ${commissionable}
    Run Keyword If    '${commissionable.upper()}'=='YES' and ${is_commission_mandatory}    Set Car Commission    ${commission}
    Run Keyword If    ${is_booking_method_mandatory}    Select Car Booking Method    ${booking_method}
    Run Keyword If    ${is_remarks_mandatory}    Set Car Associated Remarks    ${assoc_remarks}
    Get Car Rate Type
    Run Keyword If    '${actual_car_rate_type}'=='${EMPTY}'    Select Value From Dropdown List    [NAME:cbRateType]    ${rate_type}

Get Car Rate Type In GDS
    [Arguments]    ${expected_car_currency}    ${expected_car_charged_rate}=${EMPTY}
    ${car_charged_rate}    Get Variable Value    ${expected_car_charged_rate}    ${actual_car_charged_rate}
    ${data}    Get Data From GDS Screen    RT    True
    ${car_rate_type_raw}    Get Regexp Matches    ${data}    ${expected_car_currency}${car_charged_rate}\\s?(\\D{2})    1
    ${car_rate_type}    Set Variable    ${car_rate_type_raw[-1]}
    ${car_rate_type}    Set Variable If    "${car_rate_type}" in ["DY", "D"]    Daily    "${car_rate_type}" in ["WD", "E"]    Weekend    "${car_rate_type}" in ["WY", "WK", "W"]
    ...    Weekly    "${car_rate_type}" in ["MY", "MO"]    Monthly    "${car_rate_type}" in ["PK", "BR"]    Package    ${EMPTY}
    [Return]    ${car_rate_type}

Populate Car Tab Mandatory Fields
    [Arguments]    ${realised_savings}    ${payment_type}    ${commissionable}
    Select Car Realised Savings Code    ${realised_savings}
    Select Payment Type    ${payment_type}    
    Select Commissionable    ${commissionable}    