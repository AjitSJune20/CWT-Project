*** Settings ***
Documentation     This resource file covers all reusable actions for Air Fare Related test cases
Variables         ../variables/air_fare.py
Resource          ../common/core.robot

*** Keywords ***
Add Days On Current Date
    [Arguments]    ${x_days}
    ${yyyy}    ${mm}    ${dd}    Get Time    year,month,day    NOW + ${x_days} Days
    ${yy}    Get Substring    ${yyyy}    -2
    Set Suite Variable    ${yyyy}
    Set Suite Variable    ${yy}
    Set Suite Variable    ${mm}
    Set Suite Variable    ${dd}

Calculate Transaction Fee
    [Arguments]    ${fare_tab}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Comment    Run Keyword If    "${country}" == "IN" and "${route_code}" == "DOM"    Set Test Variable    ${transaction_fee_percentage}    ${transaction_fee_percentage_dom}
    ...    ELSE    ${transaction_fee_percentage}    ${transaction_fee_percentage_int}
    Run Keyword If    "${transaction_fee_type.upper()}" == "RANGE"    Set Test Variable    ${transaction_fee_percentage}    ${transaction_fee_amount_int}
    ...    ELSE    Set Test Variable    ${transaction_fee_percentage}    ${transaction_fee_percentage_int}
    ${transaction_fee_amount}    Evaluate    ${base_fare_${fare_tab_index}} * ${transaction_fee_percentage}
    ${transaction_fee_amount}    Convert To Number    ${transaction_fee_amount}
    ${transaction_fee_amount}    Round Apac    ${transaction_fee_amount}    ${country}
    Comment    ${transaction_fee_amount}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${transaction_fee_amount}    2
    ...    ELSE    Convert To Float    ${transaction_fee_amount}    0
    ${transaction_fee_amount}    Run Keyword If    "${fee_amount_percent_cap.upper()}" == "CAP" and ${transaction_fee_amount} > ${cap}    Set Variable    ${cap}
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    ${transaction_fee_amount}    Convert To String    ${transaction_fee_amount}
    Set Suite Variable    ${expected_transaction_fee_amount_${fare_tab_index}}    ${transaction_fee_amount}
    [Return]    ${transaction_fee_amount}

Click Add Alternate Fare
    Comment    Auto It Set Option    MouseCoordMode    2
    Comment    Mouse Click    LEFT    921    460    1
    Comment    Auto It Set Option    MouseCoordMode    0
    Comment    Sleep    5
    Click Control    btnAddAlternateFare
    Sleep    5

Click Add Cancellation Button
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    btnAddCancellations_${fare_tab_index},btnAddCancellations_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Click Control Button    ${object_name}

Click Add Changes Button
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    btnAddChanges_${fare_tab_index},btnAddChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Click Control Button    ${object_name}

Click Add Manual Fare
    [Arguments]    ${current_active_tab}
    Comment    Click Button In Air Fare    ${current_active_tab}    Add Manual Fare
    Click Control    btnAddManualFare

Click Clear Form Of Payment Icon On Fare Quote Tab
    ${clear_fop_field}    Determine Multiple Object Name Based On Active Tab    cmdClearFOP
    Click Control Button    ${clear_fop_field}

Click Copy Air Fare
    ${copy_offers}    Determine Multiple Object Name Based On Active Tab    btnCopyOffers
    Comment    ${fare_routing}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting
    Click Control Button    ${copy_offers}
    Comment    Wait Until Control Object Is Visible    ${fare_routing}

Click Copy Alternate Fare
    ${copy_offers}    Determine Multiple Object Name Based On Active Tab    btnCopyOffers_alt
    ${alternate_routing}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt
    Click Control Button    ${copy_offers}
    Wait Until Control Object Is Visible    ${alternate_routing}

Click Details Tab
    Auto It Set Option    MouseCoordMode    2
    Mouse Click    LEFT    488    488    1
    Auto It Set Option    MouseCoordMode    0
    Sleep    5

Click Fare Tab
    [Arguments]    ${fare_tab_value}
    Verify Fare Tab Is Visible    ${fare_tab_value}
    Select Tab Control    ${fare_tab_value}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    Set Test Variable    ${fare_tab_index}

Click Mask Icon To Unmask Card On Fare Quote Tab
    ${mask_icon_field}    Determine Multiple Object Name Based On Active Tab    cmdMaskCard
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value_unmasked}    Get Control Text Value    ${fop_field}
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value_unmasked}    *
    Run Keyword If    "${status}" == "True"    Click Control Button    ${mask_icon_field}
    Set Suite Variable    ${fop_value_unmasked}

Click Mask Icon to Mask Card On Fare Quote Tab
    ${mask_icon_field}    Determine Multiple Object Name Based On Active Tab    cmdMaskCard
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value_masked}    Get Control Text Value    ${fop_field}
    ${status}    Run Keyword And Return Status    Should Contain    ${fop_value_masked}    *
    Run Keyword If    "${status}" == "False"    Click Control Button    ${mask_icon_field}

Click Pricing Extras Tab
    Auto It Set Option    MouseCoordMode    2
    Mouse Click    LEFT    488    583    1
    Auto It Set Option    MouseCoordMode    0
    Sleep    5

Click Remove Cancellation Button
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    btnRemoveCancellations_${fare_tab_index},btnRemoveCancellations_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Click Control Button    ${object_name}

Click Remove Changes Button
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    btnRemoveChanges_${fare_tab_index},btnRemoveChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Click Control Button    ${object_name}

Click Remove Fare
    Click Control    btnRemoveFare
    Sleep    5

Compute High Fare And Low Fare For Ticketing Remarks
    ${index}    Set Variable If    '${fare_tab_index}' != '${EMPTY}'    ${fare_tab_index}    1
    Get High Fare Value
    Get Low Fare Value
    ${rounded_high_fare}    Evaluate    round(${converted_high_fare})
    ${rounded_low_fare}    Evaluate    round(${converted_low_fare})
    ${rounded_high_fare}    Convert To String    ${rounded_high_fare}
    ${rounded_low_fare}    Convert To String    ${rounded_low_fare}
    ${rounded_high_fare}    Fetch From Left    ${rounded_high_fare}    .
    ${rounded_low_fare}    Fetch From Left    ${rounded_low_fare}    .
    Set Test Variable    ${high_fare_${index}}    ${rounded_high_fare}
    Set Test Variable    ${low_fare_${index}}    ${rounded_low_fare}

Compute Transaction Fee
    [Arguments]    ${fare_number}    ${transaction_fee_percentage}
    Get Base Fare And Tax From Galileo For Fare X Tab    ${fare_number}
    ${transaction_fee_percentage}    Get Percentage Value    ${transaction_fee_percentage}
    Get Commission Rebate Amount Value    ${fare_number}
    ${base_fare_less_commission_amount}    Evaluate    ${base_fare_value_${fare_number}} - ${commission_rebate_value_${fare_number}}
    ${transaction_fee_amount}    Evaluate    ${base_fare_less_commission_amount} * ${transaction_fee_percentage}
    ${transaction_fee_amount}    Convert To Float    ${transaction_fee_amount}    2
    [Return]    ${transaction_fee_amount}

Create New Booking For Traveldoo With One Way Flight Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair}    ${client_account}=${EMPTY}    @{exclude_panels}
    Create New Booking With One Way Flight Using Default Values    ${client}    ${surname}    ${firstname}    ${city_pair}    ${client_account}=${EMPTY}    @{exclude_panels}
    Click Finish PNR
    Should Be True    '${current_pnr}' != '${EMPTY}'

Create New Booking With Circle Trip Air Flight Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}
    ...    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    ${city_pair_3}    ${seat_select_3}    ${store_fare_3}
    ...    ${car_itinerary}    ${hotel_itinerary}    ${select_hotel}    ${select_rate}    ${store_hotel_rate}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}    6
    Book Flight X Months From Now    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    6    2
    Book Flight X Months From Now    ${city_pair_3}    ${seat_select_3}    ${store_fare_3}    6    4
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create New Booking With Circle Trip Flight Cars And Hotel
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}
    ...    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    ${city_pair_3}    ${seat_select_3}    ${store_fare_3}
    ...    ${car_itinerary}    ${hotel_itinerary}    ${select_hotel}    ${select_rate}    ${store_hotel_rate}    @{exclude_panels}
    Set Test Variable    ${client_account}    ${EMPTY}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}    6
    Book Flight X Months From Now    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    6    2
    Book Flight X Months From Now    ${city_pair_3}    ${seat_select_3}    ${store_fare_3}    6    4
    Book Active Car Segment    ${car_itinerary}    6    0    6    8
    Book Hotel Segment    ${hotel_itinerary}    ${select_hotel}    ${select_rate}    ${store_hotel_rate}
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create New Booking With One Way Flight And One Alternate Offer Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair}    ${seat_select}    ${store_fare}
    ...    ${client_account}=${EMPTY}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Update PNR With Default Values
    Create Amadeus Offer    ${city_pair}    ${seat_select}    ${store_fare}
    Get Data From GDS Screen
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create New Booking With Round Trip Flight And One Alternate Offer Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}
    ...    ${store_offer_1}    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    ${client_account}=${EMPTY}    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Update PNR With Default Values
    Create Amadeus Offer    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}    6    0    ${store_offer_1}
    Book Flight X Months From Now    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    6    2
    Get Data From GDS Screen
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create New Booking With Round Trip Flight And Two Alternate Offers Using Default Values
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}
    ...    ${store_offer_1}    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    ${store_offer_2}    ${client_account}=${EMPTY}
    ...    @{exclude_panels}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Update PNR With Default Values
    Create Amadeus Offer    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}    5    0    ${store_offer_1}
    Comment    Create Amadeus Offer    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    6    5
    ...    ${store_offer_2}
    Comment    Enter GDS Command    ${store_offer_2}    OFS/A1
    Enter GDS Command    ACR5    ${seat_select_2}    ${store_fare_2}
    Create Amadeus Offer Retain Flight    ${store_offer_2}
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Create New Booking With Round Trip Flight Rail Cars And Hotel
    [Arguments]    ${client}    ${surname}    ${firstname}    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}
    ...    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    ${car_itinerary}    ${hotel_itinerary}    ${select_hotel}
    ...    ${select_rate}    ${store_hotel_rate}    @{exclude_panels}
    Set Test Variable    ${client_account}    ${EMPTY}
    Set Client And Traveler    ${client}    ${surname}    ${firstname}
    Click New Booking
    Click Create Shell
    Create One Way Rail Booking Using Amadeus Rail Display Thru Web    PARWL210G    FRPLY    FRLPD    E-ticket    SNCF
    Book Flight X Months From Now    ${city_pair_1}    ${seat_select_1}    ${store_fare_1}    6
    Book Flight X Months From Now    ${city_pair_2}    ${seat_select_2}    ${store_fare_2}    6    10
    #Book Flight X Months From Now    ${city_pair_3}    ${seat_select_3}    ${store_fare_3}    6    4
    #Click Read Booking
    Book Active Car Segment    ${car_itinerary}    6    0    6    8
    Book Hotel Segment    ${hotel_itinerary}    ${select_hotel}    ${select_rate}    ${store_hotel_rate}
    #Update PNR With Default Values
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    @{exclude_panels}

Delete Alternate Fare Tab
    [Arguments]    ${tab_number}
    Click Fare Tab    ${tab_number}
    Click Remove Fare

Get Air Fare Restrictions
    [Arguments]    ${fare_tab}
    Get Changes Value    ${fare_tab}
    Get Cancellation Value    ${fare_tab}
    Get Valid On Value    ${fare_tab}
    Get Re-Route Value    ${fare_tab}
    Get Mininum Stay Value    ${fare_tab}
    Get Maximum Stay Value    ${fare_tab}

Get Airline Commission Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${airline_commission_amount_field}    Determine Multiple Object Name Based On Active Tab    txtAirCommissionAmount
    ${airline_commission_amount}    Get Control Text Value    ${airline_commission_amount_field}
    Set Test Variable    ${airline_commission_percentage_${fare_tab_index}}    ${airline_commission_amount}
    [Return]    ${airline_commission_amount}

Get Airline Commission Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${airline_commission_percentage_field}    Determine Multiple Object Name Based On Active Tab    cmbAirCommissionPercentage,ctxtAirlineCommissionPercent,ctxtAirlineCommissionPercent_alt
    ${airline_commission_percentage}    Get Control Text Value    ${airline_commission_percentage_field}
    Set Suite Variable    ${airline_commission_percentage}
    Set Suite Variable    ${airline_commission_percentage_${fare_tab_index}}    ${airline_commission_percentage}

Get Airline Offer
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${airline_offer_field}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineOffer_alt
    ${airline_offer} =    Get Control Text Value    ${airline_offer_field}
    Run Keyword If    "${retain_new_booking_value}" == "True"    Set Suite Variable    ${airline_offer_alt_${fare_tab_index}}    ${airline_offer}
    ...    ELSE    Set Suite Variable    ${amend_airline_offer_alt_${fare_tab_index}}    ${airline_offer}
    [Return]    ${airline_offer}

Get Airline Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${airline_field}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineOffer_alt
    ${airline_value}    Get Control Text Value    ${airline_field}
    Set Test Variable    ${airline_value_${fare_tab_index}}    ${airline_value}

Get Alternate Fare - Commission Rebate Amount Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtCommissionRebateAmount,txtClientCommissionRebateAmount
    Comment    ${commission_rebate_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount
    Comment    ${commission_rebate_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${commission_rebate_amount_field}
    ...    ELSE    Set Variable    0
    ${commission_rebate_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionRebateAmount,txtClientCommissionRebateAmount
    ${commission_rebate_amount}    Get Control Text Value    ${commission_rebate_amount_field}
    ${commission_rebate_amount}    Set Variable If    "${commission_rebate_amount}" == "${EMPTY}"    0    ${commission_rebate_amount}
    Set Suite Variable    ${commission_rebate_value_alt_${fare_tab_index}}    ${commission_rebate_amount}

Get Alternate Fare - Commission Rebate Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${commission_rebate_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent,txtClientCommissionRebatePercentage
    ${commission_rebate_percentage}    Get Control Text Value    ${commission_rebate_percentage_field}
    ${commission_rebate_percentage}    Set Variable If    "${commission_rebate_percentage}" == "${EMPTY}"    0    ${commission_rebate_percentage}
    Set Suite Variable    ${commission_rebate_percentage_value_alt_${fare_tab_index}}    ${commission_rebate_percentage}

Get Alternate Fare - Fare Including Airline Taxes Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFareIncludingTaxes
    ${fare_including_taxes}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${fare_including_taxes_alt_${fare_tab_index}}    ${fare_including_taxes}

Get Alternate Fare - Fuel Surcharge Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fuel_surcharge_field}    Determine Multiple Object Name Based On Active Tab    txtFuelSurcharge,ctxtFuelSurcharge
    ${fuel_surcharge}    Get Control Text Value    ${fuel_surcharge_field}
    ${fuel_surcharge}    Set Variable If    "${fuel_surcharge}" == "${EMPTY}"    0    ${fuel_surcharge}
    Set Suite Variable    ${fuel_surcharge_value_alt_${fare_tab_index}}    ${fuel_surcharge}
    [Return]    ${fuel_surcharge}

Get Alternate Fare - GST Total Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtGSTAmount
    ${gst_total_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtGSTAmount
    ${gst_total_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${gst_total_field}
    ...    ELSE    Set Variable    0
    ${gst_total_amount}    Set Variable If    "${gst_total_amount}" == "${EMPTY}"    0    ${gst_total_amount}
    Set Suite Variable    ${gst_total_amount_alt_${fare_tab_index}}    ${gst_total_amount}

Get Alternate Fare - Main Fees
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    Set Test Variable    ${fuel_surcharge_value_alt_${fare_tab_index}}    0
    Get Alternate Fare - Nett Fare Value    ${fare_tab}
    Run Keyword If    "${country}" == "HK"    Get Alternate Fare - Fuel Surcharge Value    ${fare_tab}
    Get Alternate Fare - Transaction Fee Amount Value    ${fare_tab}
    Get Alternate Fare - Commission Rebate Amount Value    ${fare_tab}
    Get Alternate Fare - Commission Rebate Percentage Value    ${fare_tab}
    Get Alternate Fare - Merchant Fee Amount Value    ${fare_tab}
    Get Alternate Fare - Merchant Fee Percentage Value    ${fare_tab}
    Get Alternate Fare - Mark-Up Amount Value    ${fare_tab}
    Get Alternate Fare - Mark-Up Percentage Value    ${fare_tab}
    Get Alternate Fare - Merchant Fee For Transaction Fee Value    ${fare_tab}
    Get Alternate Fare - GST Total Value    ${fare_tab}
    Get Alternate Fare - Fare Including Airline Taxes Value    ${fare_tab}
    Get Alternate Fare - Total Amount    ${fare_tab}

Get Alternate Fare - Mark-Up Amount Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMarkUpAmount, txtMarkupAmount
    ${mark_up_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount, txtMarkupAmount
    ${mark_up_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${mark_up_amount_field}
    ...    ELSE    Set Variable    0
    ${mark_up_amount}    Set Variable If    "${mark_up_amount}" == "${EMPTY}"    0    ${mark_up_amount}
    Set Suite Variable    ${mark_up_value_alt_${fare_tab_index}}    ${mark_up_amount}
    [Return]    ${mark_up_amount}

Get Alternate Fare - Mark-Up Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent,txtMarkupPercentage
    ${mark_up_percentage}    Get Control Text Value    ${object_name}
    ${mark_up_percentage}    Set Variable If    "${mark_up_percentage}" == "${EMPTY}"    0    ${mark_up_percentage}
    Set Suite Variable    ${mark_up_percentage_value_alt_${fare_tab_index}}    ${mark_up_percentage}
    [Return]    ${mark_up_percentage}

Get Alternate Fare - Merchant Fee Amount Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMerchantFeeAmount
    ${merchant_fee_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount
    ${merchant_fee_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${merchant_fee_amount_field}
    ...    ELSE    Set Variable    0
    ${merchant_fee_amount}    Set Variable If    "${merchant_fee_amount}" == "${EMPTY}"    0    ${merchant_fee_amount}
    Set Suite Variable    ${merchant_fee_value_alt_${fare_tab_index}}    ${merchant_fee_amount}
    [Return]    ${merchant_fee_amount}

Get Alternate Fare - Merchant Fee For Transaction Fee Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMerchantFeeOnTransactionFee
    ${merchant_fee_transaction_fee_fare_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOnTransactionFee
    ${merchant_fee_transaction_fee_fare_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${merchant_fee_transaction_fee_fare_field}
    ...    ELSE    Set Variable    0
    ${merchant_fee_transaction_fee_fare_amount}    Set Variable If    "${merchant_fee_transaction_fee_fare_amount}" == "${EMPTY}"    0    ${merchant_fee_transaction_fee_fare_amount}
    Set Suite Variable    ${mf_for_tf_amount_alt_${fare_tab_index}}    ${merchant_fee_transaction_fee_fare_amount}

Get Alternate Fare - Merchant Fee Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent
    ${merchant_fee_percentage}    Get Control Text Value    ${object_name}
    ${merchant_fee_percentage}    Set Variable If    "${merchant_fee_percentage}" == "${EMPTY}"    0    ${merchant_fee_percentage}
    Set Suite Variable    ${merchant_fee_percentage_value_alt_${fare_tab_index}}    ${merchant_fee_percentage}
    [Return]    ${merchant_fee_percentage}

Get Alternate Fare - Nett Fare Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    txtNetFare
    ${nett_fare_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    txtNetFare
    ${nett_fare_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${nett_fare_field}
    ...    ELSE    Set Variable    0
    ${nett_fare_amount}    Set Variable If    "${nett_fare_amount}" == "${EMPTY}"    0    ${nett_fare_amount}
    Set Suite Variable    ${nett_fare_value_alt_${fare_tab_index}}    ${nett_fare_amount}
    [Return]    ${nett_fare_amount}

Get Alternate Fare - Total Amount
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalAmount
    ${total_amount}    Get Control Text Value    ${object_name}
    Set Test Variable    ${total_amount_alt_${fare_tab_index}}    ${total_amount}

Get Alternate Fare - Transaction Fee Amount Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    ${status}    Run Keyword And Return Status    Should Contain    ${transaction_fee_amount}    -
    Comment    ${transaction_fee_amount}    Fetch From Left    ${transaction_fee_amount}    -
    ${trans_fee_amount}    Run Keyword If    "${status}" == "True"    Fetch From Left    ${transaction_fee_amount}    -
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    Set Suite Variable    ${transaction_fee_value_alt_${fare_tab_index}}    ${trans_fee_amount}
    [Return]    ${transaction_fee_amount}

Get Alternate Fare Details
    [Arguments]    ${fare_tab}    ${region}=${EMPTY}
    Click Fare Tab    ${fare_tab}
    Get Fare Basis Offer    ${fare_tab}
    Get Airline Offer    ${fare_tab}
    Run Keyword If    "${region}" == "${EMPTY}"    Get Air Fare Restrictions    ${fare_tab}
    Get Fare Class Value    ${fare_tab}
    Get Details Offer    ${fare_tab}
    Get Total Fare Offer    ${fare_tab}
    Get Routing Name    ${fare_tab}
    Get Alternate Fare Routing Value    ${fare_tab}
    Get Total Amount    ${fare_tab}

Get Alternate Fare Fuel Surcharge Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtFuelSurchargeOffer_alt
    ${alternate_fare_fuel_surcharge_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtFuelSurchargeOffer_alt
    ${alternate_fare_fuel_surcharge_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${alternate_fare_fuel_surcharge_field}
    ...    ELSE    Set Variable    0
    Set Test Variable    ${alternate_fare_fuel_surcharge_amount}
    Set Test Variable    ${alternate_fare_fuel_surcharge_value_${fare_tab_index}}    ${alternate_fare_fuel_surcharge_amount}
    [Return]    ${alternate_fare_fuel_surcharge_amount}

Get Alternate Fare Merchant Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOffer_alt
    ${alternate_fare_merchant_value}    Get Control Text Value    ${object_name}
    Set Test Variable    ${merchant_value_alt_${fare_tab_index}}    ${alternate_fare_merchant_value}
    [Return]    ${alternate_fare_merchant_value}

Get Alternate Fare Routing Value
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt
    ${alternate_fare_routing_value}    Get Control Text Value    ${object_name}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${routing_value_alt_${fare_tab_index}}    ${alternate_fare_routing_value}
    ...    ELSE    Set Suite Variable    ${amend_routing_value_alt_${fare_tab_index}}    ${alternate_fare_routing_value}
    [Return]    ${alternate_fare_routing_value}

Get Alternate Fare Total Fare Value
    [Arguments]    ${fare_tab}=Alternate Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalFareOffer_alt
    ${alternate_fare_total_fare_amount}    Get Control Text Value    ${object_name}
    ${converted_alternate_fare_total_fare_amount}    Replace String    ${alternate_fare_total_fare_amount}    ,    .
    Set Test Variable    ${alternate_fare_total_fare_amount}
    Set Test Variable    ${converted_alternate_fare_total_fare_amount}
    Set Test Variable    ${total_fare_value_alt_${fare_tab_index}}    ${alternate_fare_total_fare_amount}
    Set Test Variable    ${converted_total_fare_value_alt_${fare_tab_index}}    ${converted_alternate_fare_total_fare_amount}
    [Return]    ${total_fare_value_alt_${fare_tab_index}}

Get Alternate Fare Transaction Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTransactionFeeOffer_alt
    ${alternate_fare_transaction_amount}    Get Control Text Value    ${object_name}
    Set Test Variable    ${alternate_fare_transaction_amount}
    Set Test Variable    ${transaction_value_alt_${fare_tab_index}}    ${alternate_fare_transaction_amount}

Get Base Fare, Nett Fare, and LFCC Values
    [Arguments]    ${fare_tab}    ${segment_number}
    Get Base Fare From TST    ${fare_tab}    ${segment_number}
    Get Nett Fare Value    ${fare_tab}
    Get LFCC From FV Line In TST    ${fare_tab}    ${segment_number}

Get Cancellation Value
    [Arguments]    ${fare_tab}    ${default_control_counter}=True    ${field_instance}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${cancellation_control}    Determine Multiple Object Name Based On Active Tab    ccboCancellations0,ccboCancellations0_alt,ccboCancellationsOBT,ccboCancellationsOBT_alt,ccboCancellations_alt,ccboCancellations_${fare_tab_index},ccboCancellations_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    ${cancellation_value}    Get Control Text Value    ${cancellation_control}
    Set Suite Variable    ${cancellation_value_${fare_tab_index}}    ${cancellation_value.upper()}
    [Return]    ${cancellation_value}

Get Changes Value
    [Arguments]    ${fare_tab}    ${default_control_counter}=True    ${field_instance}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${changes_control}    Determine Multiple Object Name Based On Active Tab    ccboChanges0,ccboChanges0_alt,ccboChangesOBT_alt,ccboChangesOBT,ccboChanges_${fare_tab_index},ccboChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    ${changes_value}    Get Control Text Value    ${changes_control}
    Set Suite Variable    ${changes_value_${fare_tab_index}}    ${changes_value.upper()}
    [Return]    ${changes_value}

Get Charged Fare Value
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${charged_fare_amount}    Get Control Text Value    ${object_name}
    ${converted_charged_fare}    Replace String    ${charged_fare_amount}    ,    .
    Set Test Variable    ${charged_fare_amount}
    Set Test Variable    ${converted_charged_fare}
    Set Suite Variable    ${charge_fare}    ${converted_charged_fare}
    Set Suite Variable    ${charged_fare_${fare_tab_index}}    ${converted_charged_fare}
    Set Suite Variable    ${charged_value_${fare_tab_index}}    ${charged_fare_amount}
    ${without_decimal_charged_fare}    Remove Decimals    ${charged_fare_${fare_tab_index}}
    Set Suite Variable    ${without_decimal_charged_fare_${fare_tab_index}}    ${without_decimal_charged_fare}
    [Return]    ${charged_fare_amount}

Get Class Code Value
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${class_field}    Determine Multiple Object Name Based On Active Tab    ccboClass
    ${class_value}    Get Control Text Value    ${class_field}
    ${class_code_value}    Fetch From Left    ${class_value}    ${SPACE}-
    #Sets only savings code
    Set Suite Variable    ${class_code_value_${fare_tab_index}}    ${class_code_value}
    #Sets only savings code and description
    Set Suite Variable    ${class_text_value_${fare_tab_index}}    ${class_value}
    [Return]    ${class_text_value_${fare_tab_index}}

Get Class Code Values
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${class_code_values_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboClass
    ${class_code_values}    Get Dropdown Values    ${class_code_values_dropdown}
    Log List    ${class_code_values}
    Set Suite Variable    ${class_code_values_${fare_tab_index}}    ${class_code_values}

Get Commission Rebate Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtCommissionRebateAmount,txtClientCommissionRebateAmount, ctxtCommissionRebateAmount_alt
    Comment    ${commission_rebate_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount
    Comment    ${commission_rebate_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${commission_rebate_amount_field}
    ...    ELSE    Set Variable    0
    ${commission_rebate_amount_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionRebateAmount,txtClientCommissionRebateAmount, ctxtCommissionRebateAmount_alt
    ${commission_rebate_amount}    Get Control Text Value    ${commission_rebate_amount_field}
    ${commission_rebate_amount}    Set Variable If    "${commission_rebate_amount}" == "${EMPTY}"    0    ${commission_rebate_amount}
    Set Suite Variable    ${commission_rebate_value_${fare_tab_index}}    ${commission_rebate_amount}

Get Commission Rebate Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${commission_rebate_percentage_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent,txtClientCommissionRebatePercentage, ctxtCommissionPercent_alt
    ${commission_rebate_percentage}    Get Control Text Value    ${commission_rebate_percentage_field}
    ${commission_rebate_percentage}    Set Variable If    "${commission_rebate_percentage}" == "${EMPTY}"    0    ${commission_rebate_percentage}
    Set Suite Variable    ${commission_rebate_percentage_value_${fare_tab_index}}    ${commission_rebate_percentage}

Get Details Offer
    [Arguments]    ${fare_tab}=Alternate Fare 1    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${details_offer_field}    Determine Multiple Object Name Based On Active Tab    ctxtDetailsOffer_alt, ctxtDetailsOffer
    ${details_offer} =    Get Control Text Value    ${details_offer_field}
    ${details_offer} =    Replace String    ${details_offer}    É    E
    ${details_offer} =    Replace String    ${details_offer}    Û    U
    ${details_offer} =    Run Keyword If    "${GDS_switch}" == "galileo"    Replace String    ${details_offer}    +    /
    ...    ELSE    Set Variable    ${details_offer}
    ${details_offer} =    Run Keyword If    "${GDS_switch}" == "galileo"    Replace String    ${details_offer}    ${SPACE}${SPACE}    ${SPACE}
    ...    ELSE    Set Variable    ${details_offer}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${details_offer_alt_${fare_tab_index}}    ${details_offer}
    ...    ELSE    Set Suite Variable    ${amend_details_offer_alt_${fare_tab_index}}    ${details_offer}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${alternate_airline_details_${fare_tab_index}}    ${details_offer}
    ...    ELSE    Set Suite Variable    ${amend_alternate_airline_details_${fare_tab_index}}    ${details_offer}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${alternate_airline_details}    ${details_offer}
    ...    ELSE    Set Suite Variable    ${amend_alternate_airline_details}    ${details_offer}

Get FOP Merchant Field Value On Fare Quote Tab
    ${fop_merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    ${fop_merchant_value}    Get Control Text Value    ${fop_merchant_field}
    Set Suite Variable    ${fop_merchant_value}
    Set Suite Variable    ${fop_merchant_fee_type_${fare_tab_index}}    ${fop_merchant_value}

Get Fare Basis Offer
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${fare_basis_field}    Determine Multiple Object Name Based On Active Tab    ctxtFareBasisOffer_alt, ctxtFareBasisOffer
    ${fare_basis}    Get Control Text Value    ${fare_basis_field}
    Set Test Variable    ${fare_basis_value_${fare_tab_index}}    ${fare_basis}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${fare_basis_${fare_tab_index}}    ${fare_basis}
    ...    ELSE    Set Suite Variable    ${amend_fare_basis_${fare_tab_index}}    ${fare_basis}

Get Fare Class Value
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${fare_class_offer_field}    Determine Multiple Object Name Based On Active Tab    ccboFareClassOffer_alt, ccboFareClassOffer
    ${fare_class_offer}    Get Control Text Value    ${fare_class_offer_field}
    ${fare_class_offer_text}    Fetch From Right    ${fare_class_offer}    -${SPACE}
    ${fare_class_offer_code}    Fetch From Left    ${fare_class_offer}    -${SPACE}
    ${class_code_sub}    Get Substring    ${fare_class_offer}    0    1
    ${class_code_sub}    Set Variable If    '${class_code_sub}'=='W'    P    '${class_code_sub}'=='A' or '${class_code_sub}'=='D' or '${class_code_sub}'=='F'    P    '${class_code_sub}'=='N' or '${class_code_sub}'=='M'
    ...    ${EMPTY}    ${class_code_sub}
    Set Test Variable    ${alternate_class_code}    ${class_code_sub}
    Set Test Variable    ${fare_class_offer_value_${fare_tab_index}}    ${fare_class_offer_text.upper()}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${fare_class_offer_${fare_tab_index}}    ${fare_class_offer.upper()}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_${fare_tab_index}}    ${fare_class_offer.upper()}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${fare_class_offer_text_${fare_tab_index}}    ${fare_class_offer_text.upper()}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_text_${fare_tab_index}}    ${fare_class_offer_text.upper()}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${fare_class_offer_code_${fare_tab_index}}    ${fare_class_offer_code}
    ...    ELSE    Set Suite Variable    ${amend_fare_class_offer_code_${fare_tab_index}}    ${fare_class_offer_code}
    [Teardown]

Get Fare Details
    [Arguments]    ${fare_tab}    ${include_fare_amount}=True    ${include_fare_restriction}=True    ${include_turnaround}=True
    Click Fare Tab    ${fare_tab}
    Run Keyword If    "${include_fare_amount}" == "True"    Get High, Charged And Low Fare In Fare Tab    ${fare_tab}
    Run Keyword If    "${include_fare_restriction}" == "True"    Get Air Fare Restrictions    ${fare_tab}
    Get Routing Name    ${fare_tab}
    Run Keyword If    "${include_turnaround}" == "True"    Get Point Of Turnaround    ${fare_tab}
    Get Savings Code    ${fare_tab}

Get Fare Including Airline Taxes Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    Comment    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFareIncludingTaxes, ctxtFareIncludingTaxes_alt
    ${fare_including_taxes}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${fare_including_taxes_${fare_tab_index}}    ${fare_including_taxes}

Get Fare Restriction Currently Selected Value
    [Arguments]    ${fare_tab}    ${translate_to_english}=True
    Click Fare Tab    ${fare_tab}
    ${currently_selected}    Get Fare Restiction Selected Radio Button    ${translate_to_english}
    Set Test Variable    ${currently_selected}
    [Return]    ${currently_selected}

Get Fees Fare Value
    [Arguments]    ${fare_tab_name}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab_name}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFees
    ${object_visibility}    Control Command    ${title_power_express}    ${EMPTY}    ${object_name}    IsVisible    ${EMPTY}
    ${fees_fare_amount}    Run Keyword If    ${object_visibility} == 1    Get Control Text Value    ${object_name}
    ...    ELSE    Set Variable    0
    ${converted_fees_fare}    Replace String    ${fees_fare_amount}    ,    .
    Set Test Variable    ${converted_fees_fare}
    Set Test Variable    ${fees_fare_${fare_tab_index}}    ${fees_fare_amount}
    [Return]    ${fees_fare_amount}

Get Fees Value
    [Arguments]    ${fare_tab}    ${region}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFees
    Run Keyword If    "${region}" != "${EMPTY}"    Verify Control Object Is Disabled    ${object_name}
    ${fees_value}    Get Control Text Value    ${object_name}
    Set Test Variable    ${fees_value_${fare_tab_index}}    ${fees_value}
    [Return]    ${fees_value_${fare_tab_index}}

Get Fuel Surcharge Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate}    alt_${fare_tab_index}    ${fare_tab_index}
    Comment    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${fuel_surcharge_field}    Determine Multiple Object Name Based On Active Tab    txtFuelSurcharge,ctxtFuelSurcharge,ctxtFuelSurcharge_alt
    ${fuel_surcharge}    Get Control Text Value    ${fuel_surcharge_field}
    ${fuel_surcharge}    Set Variable If    "${fuel_surcharge}" == "${EMPTY}"    0    ${fuel_surcharge}
    Set Suite Variable    ${fuel_surcharge_value_${fare_tab_index}}    ${fuel_surcharge}
    [Return]    ${fuel_surcharge}

Get GST Total Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtGSTAmount
    ${gst_total_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtGSTAmount
    ${gst_total_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${gst_total_field}
    ...    ELSE    Set Variable    0
    ${gst_total_amount}    Set Variable If    "${gst_total_amount}" == "${EMPTY}"    0    ${gst_total_amount}
    Set Suite Variable    ${gst_total_amount_${fare_tab_index}}    ${gst_total_amount}

Get High Fare Value
    [Arguments]    ${fare_tab}=Fare 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    ${high_fare_amount}    Get Control Text Value    ${object_name}
    ${converted_high_fare}    Replace String    ${high_fare_amount}    ,    .
    Set Test Variable    ${converted_high_fare}
    Set Test Variable    ${high_fare_amount}
    Set Suite Variable    ${high_fare}    ${converted_high_fare}
    Set Suite Variable    ${high_fare_${fare_tab_index}}    ${converted_high_fare}
    Set Suite Variable    ${high_fare_value_${fare_tab_index}}    ${high_fare_amount}
    ${without_decimal_high_fare}    Remove Decimals    ${high_fare_${fare_tab_index}}
    Set Suite Variable    ${without_decimal_high_fare_${fare_tab_index}}    ${without_decimal_high_fare}
    [Return]    ${high_fare_amount}

Get High, Charged And Low Fare In Fare Tab
    [Arguments]    ${fare_tab_value}=Fare 1
    Activate Power Express Window
    Click Fare Tab    ${fare_tab_value}
    Get Charged Fare Value    ${fare_tab_value}
    Get High Fare Value    ${fare_tab_value}
    Get Low Fare Value    ${fare_tab_value}

Get LFCC Field Value
    [Arguments]    ${fare_tab}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowestFareCC    ${default_control_counter}
    ${lfcc}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${lfcc_value_${fare_tab_index}}    ${lfcc}
    [Return]    ${lfcc}

Get Low Fare Value
    [Arguments]    ${fare_tab}=Fare 1    ${default_control_counter}=True    ${identifier}=${EMPTY}    ${country}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare,LowFareTextBox    ${default_control_counter}
    ${low_fare_amount}    Get Control Text Value    ${object_name}
    ${converted_low_fare}    Replace String    ${low_fare_amount}    ,    .
    Set Test Variable    ${converted_low_fare}
    Set Test Variable    ${low_fare_amount}
    Set Suite Variable    ${low_fare}    ${converted_low_fare}
    Set Suite Variable    ${low_fare_${fare_tab_index}}    ${converted_low_fare}
    Set Suite Variable    ${low_fare_value_${fare_tab_index}}    ${low_fare_amount}
    ${without_decimal_low_fare}    Remove Decimals    ${low_fare_${fare_tab_index}}
    Set Suite Variable    ${without_decimal_low_fare_${fare_tab_index}}    ${without_decimal_low_fare}
    ${ui_value}    Set Variable If    "${country}"=="IN"    ${low_fare_value_${fare_tab_index}}    ${low_fare_${fare_tab_index}}
    Set Suite Variable    ${ui_value_${identifier}}    ${ui_value}
    Set Suite Variable    ${low_fare_${identifier}}    ${low_fare}
    [Return]    ${low_fare_amount}

Get Main Fees On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${country}=${EMPTY}    ${identifier}=${EMPTY}
    [Documentation]    ${main_fees_collection_${identifier.lower()}}= This List Contains the Below Vaues, In Future you may add extra Values or you may delete the existing Values.....    ###    ###
    ...
    ...    ${fare_including_taxes_${fare_tab_index}}==Fare Inclusive Value
    ...    ${airline_commission_percentage}== AirLine Comm. Value
    ...    ${commission_rebate_value_${fare_tab_index}}= Commission Return Value
    ...    ${commission_rebate_percentage_value_${fare_tab_index}}= Commission Return Percentage Value
    ...    ${nett_fare_${fare_tab_index}}= Nett Fare Value
    ...    ${merchant_fee_value_${fare_tab_index}}= Merchant Fee Value
    ...    ${merchant_fee_percentage_value_${fare_tab_index}}= Merchant Fee Percentage Value
    ...    ${mark_up_value_${fare_tab_index}}= MarkUp Amount Value
    ...    ${mark_up_percentage_value_${fare_tab_index}}= MarkUp Percentage Value
    ...    ${transaction_fee_value_${fare_tab_index}}= Transaction Fee Value
    ...
    ...
    ...
    ...    ${main_fees_collection_${identifier.lower()}}===This Variable Gives you the Colletion Of all Main Fee Fields.
    ...
    ...
    ...    ${identifier}== By using this variable we can identify the Air Fare Tab Individually
    ...    New Booking Input : Ex: ${identifier}=Previous Alternate Fare 1
    ...    Amend Booking Input : Ex: ${identifier}=New Alternate Fare 1
    ...    The Above Identifier is usefull for Comparision of New and Amned Fare or Alternate Fare Tab Main Fee Values
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${country}    Run Keyword If    "${country}" == "${EMPTY}"    Get Substring    ${TEST NAME}    4    6
    ...    ELSE    Set Variable    ${country}
    ${currency}    Get Currency    ${country}
    Set Suite Variable    ${fuel_surcharge_value_${fare_tab_index}}    0
    Get Nett Fare Value    ${fare_tab}
    Run Keyword If    "${country}" == "HK"    Get Fuel Surcharge Value    ${fare_tab}
    Run Keyword If    "${country}"!="IN"    Get Mark-Up Amount Value    ${fare_tab}
    Run Keyword If    "${country}"!="IN"    Get Mark-Up Percentage Value    ${fare_tab}
    Get Transaction Fee Amount Value    ${fare_tab}
    Get Commission Rebate Amount Value    ${fare_tab}
    Get Commission Rebate Percentage Value    ${fare_tab}
    Get Airline Commission Percentage Value    ${fare_tab}
    Get Merchant Fee Amount Value    ${fare_tab}
    Get Merchant Fee Percentage Value    ${fare_tab}
    Get Merchant Fee For Transaction Fee Value    ${fare_tab}
    Get GST Total Value    ${fare_tab}
    Get Fare Including Airline Taxes Value    ${fare_tab}
    Get Total Amount    ${fare_tab}
    Get Transaction Fee Value    ${fare_tab}
    Set Suite Variable    ${total_amount_with_currency_${fare_tab_index}}    ${currency} ${total_amount_${fare_tab_index}}
    Run Keyword If    "${country}"!="IN"    Set Test Variable    ${mark_up_value_${fare_tab_index}}
    ...    ELSE    Set Test Variable    ${mark_up_value_${fare_tab_index}}    0
    #Collection Of Main Fees
    ${mark_up_value}    Get Variable Value    ${mark_up_value_${fare_tab_index}}    0
    ${mark_up_percentage_value}    Get Variable Value    ${mark_up_percentage_value_${fare_tab_index}}    0
    ${main_fees_collection}    Create List    ${fare_including_taxes_${fare_tab_index}}    ${airline_commission_percentage}    ${commission_rebate_value_${fare_tab_index}}    ${commission_rebate_percentage_value_${fare_tab_index}}    ${nett_fare_${fare_tab_index}}
    ...    ${merchant_fee_value_${fare_tab_index}}    ${merchant_fee_percentage_value_${fare_tab_index}}    ${mark_up_value}    ${mark_up_percentage_value}    ${transaction_fee_value_${fare_tab_index}}
    Run Keyword If    "${country.upper()}" == "HK"    Append To List    ${main_fees_collection}    ${fuel_surcharge_value_${fare_tab_index}}
    Set Suite Variable    ${main_fees_collection_${identifier.lower()}}    ${main_fees_collection}

Get Mark-Up Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_true}    Run Keyword And Return Status    Should Contain Any    ${fare_type}    LCC    BSP
    ${fare_tab_index}    Set Variable If    ${is_true}    ${fare_type}    ${fare_tab_index}
    Set Suite Variable    ${mark_up_value_${fare_tab_index}}    ${EMPTY}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMarkUpAmount, txtMarkupAmount, ctxtMarkUpAmount_alt
    ${mark_up_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount, txtMarkupAmount, ctxtMarkUpAmount_alt
    ${mark_up_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${mark_up_amount_field}
    ...    ELSE    Set Variable    0
    ${mark_up_amount}    Set Variable If    "${mark_up_amount}" == "${EMPTY}"    0    ${mark_up_amount}
    Set Suite Variable    ${mark_up_value_${fare_tab_index}}    ${mark_up_amount}
    [Return]    ${mark_up_amount}

Get Mark-Up Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent,txtMarkupPercentage,ctxtMarkUpPercent_alt
    ${mark_up_percentage}    Get Control Text Value    ${object_name}
    ${mark_up_percentage}    Set Variable If    "${mark_up_percentage}" == "${EMPTY}"    0    ${mark_up_percentage}
    Set Test Variable    ${mark_up_percentage_value_${fare_tab_index}}    ${mark_up_percentage}
    [Return]    ${mark_up_percentage}

Get MarkUp Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMarkUpAmount, ctxtMarkUpAmount_alt
    ${mark_up_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount, ctxtMarkUpAmount_alt
    ${mark_up_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${mark_up_amount_field}
    ...    ELSE    Set Variable    0
    Set Test Variable    ${mark_up_value_${fare_tab_index}}    ${mark_up_amount}
    [Return]    ${mark_up_amount}

Get Maximum Stay Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${max_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMaxStay,ccboMaxStay_alt,ccboMaxStayOBT,ccboMaxStayOBT_alt
    ${max_stay}    Get Control Text Value    ${max_stay_dropdown}
    Set Suite Variable    ${max_stay_value_${fare_tab_index}}    ${max_stay}
    Set Suite Variable    ${max_stay_${fare_tab_index}}    ${max_stay}
    [Return]    ${max_stay}

Get Merchant Fee Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMerchantFeeAmount, ctxtMerchantFeeAmount_alt
    ${merchant_fee_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount, ctxtMerchantFeeAmount_alt
    ${merchant_fee_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${merchant_fee_amount_field}
    ...    ELSE    Set Variable    0
    ${merchant_fee_amount}    Set Variable If    "${merchant_fee_amount}" == "${EMPTY}"    0    ${merchant_fee_amount}
    Set Suite Variable    ${merchant_fee_value_${fare_tab_index}}    ${merchant_fee_amount}
    [Return]    ${merchant_fee_amount}

Get Merchant Fee For Transaction Fee Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMerchantFeeOnTransactionFee
    ${merchant_fee_transaction_fee_fare_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOnTransactionFee
    ${merchant_fee_transaction_fee_fare_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${merchant_fee_transaction_fee_fare_field}
    ...    ELSE    Set Variable    0
    ${merchant_fee_transaction_fee_fare_amount}    Set Variable If    "${merchant_fee_transaction_fee_fare_amount}" == "${EMPTY}"    0    ${merchant_fee_transaction_fee_fare_amount}
    Set Suite Variable    ${mf_for_tf_amount_${fare_tab_index}}    ${merchant_fee_transaction_fee_fare_amount}

Get Merchant Fee Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent, ctxtMerchantFeePercent_alt
    ${merchant_fee_percentage}    Get Control Text Value    ${object_name}
    ${merchant_fee_percentage}    Set Variable If    "${merchant_fee_percentage}" == "${EMPTY}"    0    ${merchant_fee_percentage}
    Set Suite Variable    ${merchant_fee_percentage_value_${fare_tab_index}}    ${merchant_fee_percentage}
    [Return]    ${merchant_fee_percentage}

Get Mininum Stay Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${min_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMinStay,ccboMinStayOBT,ccboMinStay_alt, ccboMinStayOBT_alt
    ${min_stay}    Get Control Text Value    ${min_stay_dropdown}
    Set Suite Variable    ${min_stay_value_${fare_tab_index}}    ${min_stay}
    Set Suite Variable    ${min_stay_${fare_tab_index}}    ${min_stay}
    [Return]    ${min_stay}

Get Missed Saving Code Values
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${missed_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    ${missed_saving_code_values}    Get Dropdown Values    ${missed_saving_code_dropdown}
    Log List    ${missed_saving_code_values}
    Set Suite Variable    ${missed_saving_code_values_${fare_tab_index}}    ${missed_saving_code_values}
    [Return]    ${missed_saving_code_values}

Get Nett Fare Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    txtNetFare, txtNetFare_alt
    ${nett_fare_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    txtNetFare, txtNetFare_alt
    ${nett_fare_amount}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${nett_fare_field}
    ...    ELSE    Set Variable    0
    ${nett_fare_amount}    Set Variable If    "${nett_fare_amount}" == "${EMPTY}"    0    ${nett_fare_amount}
    Set Suite Variable    ${nett_fare_value_${fare_tab_index}}    ${nett_fare_amount}
    Set Suite Variable    ${nett_fare_${fare_tab_index}}    ${nett_fare_amount}
    [Return]    ${nett_fare_amount}

Get Overall Total Fares
    [Arguments]    @{fares}
    @{high_fare_list}    Create List
    @{charged_fare_list}    Create List
    @{low_fare_list}    Create List
    @{fees_fare_list}    Create List
    : FOR    ${fare}    IN    @{fares}
    \    ${fare_tab_index}    Fetch From Right    ${fare}    ${SPACE}
    \    Append To List    ${high_fare_list}    ${high_fare_${fare_tab_index}}
    \    Append To List    ${charged_fare_list}    ${charged_fare_${fare_tab_index}}
    \    Append To List    ${low_fare_list}    ${low_fare_${fare_tab_index}}
    \    Append To List    ${fees_fare_list}    ${fees_fare_${fare_tab_index}}
    ${high_fare_total_fares}    Get Total Fares    @{high_fare_list}    @{fees_fare_list}
    ${charged_fare_total_fares}    Get Total Fares    @{charged_fare_list}    @{fees_fare_list}
    ${low_fare_total_fares}    Get Total Fares    @{low_fare_list}    @{fees_fare_list}
    Set Test Variable    ${high_fare_total_fares}
    Set Test Variable    ${charged_fare_total_fares}
    Set Test Variable    ${low_fare_total_fares}

Get Point Of Turnaround
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${point_of_obj}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    ${actual_point_of}    Get Control Text Value    ${point_of_obj}
    Set Suite Variable    ${point_of_${fare_tab_index}}    ${actual_point_of}
    [Return]    ${actual_point_of}

Get Re-Route Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${reroute_control}    Determine Multiple Object Name Based On Active Tab    ccboReRoute, ccboReRouteOBT, ccboReRouteOBT_alt, ccboReRoute_alt
    ${reroute_value}    Get Control Text Value    ${reroute_control}
    Set Suite Variable    ${reroute_value_${fare_tab_index}}    ${reroute_value.upper()}
    [Return]    ${reroute_value_${fare_tab_index}}

Get Realised Saving Code Values
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${realised_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    ${realised_saving_code_values}    Get Dropdown Values    ${realised_saving_code_dropdown}
    Log List    ${realised_saving_code_values}
    Set Suite Variable    ${realised_saving_code_values_${fare_tab_index}}    ${realised_saving_code_values}
    [Return]    ${realised_saving_code_values}

Get Route Code Value
    [Arguments]    ${fare_tab}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode,RouteCodeComboBox    ${default_control_counter}
    ${route_code}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${route_code_${fare_tab_index}}    ${route_code}
    [Return]    ${route_code}

Get Routing Name
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${actual_city_route}    Get Routing Value    ${fare_tab}
    @{city_route}    Split String    ${actual_city_route}    -
    ${city_names}    ${city_names_with_dash}    ${city_names_with_slash}    Get City Name    @{city_route}
    Set Suite Variable    ${city_names_${fare_tab_index}}    ${city_names}
    Set Suite Variable    ${city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    ${city_names_with_slash}    Get Substring    ${city_names_with_slash}    1
    Set Suite Variable    ${city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${city_names_${fare_tab_index}}    ${city_names}
    ...    ELSE    Set Suite Variable    ${amend_city_names_${fare_tab_index}}    ${city_names}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    ...    ELSE    Set Suite Variable    ${amend_city_names_with_dash_${fare_tab_index}}    ${city_names_with_dash}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    ...    ELSE    Set Suite Variable    ${amend_city_names_with_slash_${fare_tab_index}}    ${city_names_with_slash}
    [Teardown]
    [Return]    ${city_names}

Get Routing Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${routing_obj}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt,cmtxtRouting
    ${actual_city_route}    Get Control Text Value    ${routing_obj}
    Set Suite Variable    ${city_route_${fare_tab_index}}    ${actual_city_route}
    [Teardown]
    [Return]    ${actual_city_route}

Get Routing, Turnaround and Route Code
    [Arguments]    ${fare_tab}
    Get Route Code Value    ${fare_tab}
    Comment    Get Routing Name    ${fare_tab}
    Get Point Of Turnaround    ${fare_tab}
    Get Routing Value    ${fare_tab}

Get Savings Code
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${missed_field}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    ${realised_field}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    ${class_field}    Determine Multiple Object Name Based On Active Tab    ccboClass
    ${missed_value}    Get Control Text Value    ${missed_field}
    ${realised_value}    Get Control Text Value    ${realised_field}
    ${class_value}    Get Control Text Value    ${class_field}
    ${missed_code_value}    Fetch From Left    ${missed_value}    ${SPACE}-
    ${realised_code_value}    Fetch From Left    ${realised_value}    ${SPACE}-
    ${class_code_value}    Fetch From Left    ${class_value}    ${SPACE}-
    #Sets only savings code
    Set Suite Variable    ${missed_code_value_${fare_tab_index}}    ${missed_code_value}
    Set Suite Variable    ${realised_code_value_${fare_tab_index}}    ${realised_code_value}
    Set Suite Variable    ${class_code_value_${fare_tab_index}}    ${class_code_value}
    #Sets only savings code and description
    Set Suite Variable    ${missed_text_value_${fare_tab_index}}    ${missed_value}
    Set Suite Variable    ${realised_text_value_${fare_tab_index}}    ${realised_value}
    Set Suite Variable    ${class_text_value_${fare_tab_index}}    ${class_value}

Get Single Flight Details
    [Arguments]    ${pair}=${EMPTY}
    Get Data From GDS Screen
    Set Test Variable    ${city_pair}    ${pair}
    ${flight_detail_line}    Get Lines Containing String    ${gds_screen_data}    ${city_pair}
    ${flight_details}    Get Required Flight Details    ${flight_detail_line}    ${city_pair}
    ${segment_number}    Run Keyword If    '${GDS_switch}' == 'amadeus'    Get Substring    ${flight_detail_line}    2    3
    ...    ELSE IF    '${GDS_switch}' == 'sabre'    Get Substring    ${flight_detail_line}    1    2
    ${first_index_length}    Get Length    ${flight_details[0]}
    ${airline_code}    Run Keyword If    ${first_index_length} < 3    Set Variable    ${flight_details[0]}
    ...    ELSE    Get Substring    ${flight_details[0]}    0    2
    ${flight_number}    Run Keyword If    '${GDS_switch}' != 'sabre' and ${first_index_length} < 3    Set Variable    ${flight_details[1]}
    ...    ELSE IF    '${GDS_switch}' == 'sabre' and ${first_index_length} < 3    Get Substring    ${flight_details[1]}    \    -1
    ...    ELSE    Get Substring    ${flight_details[0]}    2    6
    ${fare_class}    Run Keyword If    '${GDS_switch}' != 'sabre' and ${first_index_length} < 3    Set Variable    ${flight_details[2]}
    ...    ELSE IF    '${GDS_switch}' == 'sabre' and ${first_index_length} < 3    Get Substring    ${flight_details[1]}    -1
    ...    ELSE IF    '${GDS_switch}' == 'sabre' and ${first_index_length} > 3    Get Substring    ${flight_details[0]}    -1
    ...    ELSE    Set Variable    ${flight_details[1]}
    ${flight_date}    Run Keyword If    '${GDS_switch}' != 'sabre' and ${first_index_length} < 3    Set Variable    ${flight_details[3]}
    ...    ELSE IF    '${GDS_switch}' == 'sabre' and ${first_index_length} < 3    Set Variable    ${flight_details[2]}
    ...    ELSE IF    '${GDS_switch}' == 'sabre' and ${first_index_length} > 3    Set Variable    ${flight_details[1]}
    ...    ELSE    Set Variable    ${flight_details[2]}
    ${flight_origin}    Run Keyword If    ${first_index_length} < 3 and '${GDS_switch}' != 'amadeus'    Get Substring    ${flight_details[4]}    0    3
    ...    ELSE IF    ${first_index_length} < 3 and '${GDS_switch}' == 'amadeus'    Get Substring    ${flight_details[5]}    0    3
    ...    ELSE IF    '${GDS_switch}' == 'amadeus' and ${first_index_length} > 3    Get Substring    ${flight_details[4]}    0    3
    ...    ELSE    Get Substring    ${flight_details[3]}    0    3
    ${flight_destination}    Run Keyword If    ${first_index_length} < 3 and '${GDS_switch}' != 'amadeus'    Get Substring    ${flight_details[4]}    3    6
    ...    ELSE IF    ${first_index_length} < 3 and '${GDS_switch}' == 'amadeus'    Get Substring    ${flight_details[5]}    3    6
    ...    ELSE IF    '${GDS_switch}' == 'amadeus' and ${first_index_length} > 3    Get Substring    ${flight_details[4]}    3    6
    ...    ELSE    Get Substring    ${flight_details[3]}    3    6
    Run Keyword If    '${GDS_switch}' == 'amadeus' and '${locale}' == 'fr-FR'    Convert English Date To French    ${flight_date}
    Run Keyword If    '${GDS_switch}' == 'amadeus'    Set Suite Variable    ${segment_number}    ${segment_number.strip()}
    Set Suite Variable    ${airline_code}
    Set Suite Variable    ${flight_number}
    Set Suite Variable    ${fare_class}
    Set Suite Variable    ${flight_date}
    Set Suite Variable    ${flight_origin}
    Set Suite Variable    ${flight_destination}

Get Sum Of X Number Of Alternate Fares
    [Arguments]    ${number_of_fares}
    Set Test Variable    ${alternate_fare_total}    0
    Activate Power Express Window
    Click Panel    Air Fare
    : FOR    ${counter}    IN RANGE    1    ${number_of_fares}+1
    \    Click Fare Tab    Alternate Fare ${counter}
    \    ${total_fare_value}    Get Alternate Fare Total Fare Value
    \    ${alternate_fare_total}    Evaluate    ${alternate_fare_total} + ${total_fare_value}
    Set Test Variable    ${alternate_fare_total}
    [Return]    ${alternate_fare_total}

Get Sum Of X Number Of Fares
    [Arguments]    ${number_of_fares}
    Set Test Variable    ${fare_total}    0
    Activate Power Express Window
    Click Panel    Air Fare
    : FOR    ${counter}    IN RANGE    1    ${number_of_fares}+1
    \    Click Fare Tab    Fare ${counter}
    \    Get Charged Fare Value
    \    ${fare_total}    Evaluate    ${fare_total} + ${charged_fare_amount}
    Set Test Variable    ${fare_total}
    [Return]    ${fare_total}

Get Total Alternate Fare Amount X Tab
    [Arguments]    ${alternate_fare_tab}    ${country}
    ${fare_tab_index}    Fetch From Right    ${alternate_fare_tab}    ${SPACE}
    Get Alternate Fare Transaction Value    ${alternate_fare_tab}
    Get Alternate Fare Merchant Value    ${alternate_fare_tab}
    Get Alternate Fare Fuel Surcharge Value    ${alternate_fare_tab}
    Get Alternate Fare Total Fare Value    ${alternate_fare_tab}
    ${total_alternate_fare}    Evaluate    ${merchant_value_alt_${fare_tab_index}} + ${transaction_value_alt_${fare_tab_index}} + ${alternate_fare_fuel_surcharge_value_${fare_tab_index}} + ${total_fare_value_alt_${fare_tab_index}}
    ${total_alternate_fare}    Convert To String    ${total_alternate_fare}
    ${total_alternate_fare}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${total_alternate_fare}
    ...    ELSE IF    "${country}" == "HK"    Fetch From Left    ${total_alternate_fare}    .
    ...    ELSE    Set Variable    ${total_alternate_fare}
    Set Test Variable    ${total_alternate_fare_amount_${fare_tab_index}}    ${total_alternate_fare}
    [Return]    ${total_alternate_fare}

Get Total Amount
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${is_true}    Run Keyword And Return Status    Should Contain Any    ${fare_type}    LCC    BSP
    ${fare_tab_index}    Set Variable If    ${is_true}    ${fare_type}    ${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalAmount, ctxtTotalAmount_alt
    ${total_amount}    Get Control Text Value    ${object_name}
    Set Suite Variable    ${total_amount_${fare_tab_index}}    ${total_amount}

Get Total Fare Offer
    [Arguments]    ${fare_tab}    ${retain_new_booking_value}=True
    [Documentation]    If ${retain_new_booking_value} is:
    ...    True, storing of variable is set on new booking default; else:
    ...    False, storing of variable will be different from the new booking.
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${total_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtTotalFareOffer_alt, ctxtTotalFareOffer
    ${total_fare} =    Get Control Text Value    ${total_fare_field}
    ${total_fare} =    Run Keyword If    "${GDS_switch}" == "amadeus"    Replace String    ${total_fare}    ,    .
    ...    ELSE    Set Variable    ${total_fare}
    ${total_fare} =    Run Keyword If    "${GDS_switch}" == "amadeus"    Convert To Float    ${total_fare}
    ...    ELSE    Set Variable    ${total_fare}
    Run Keyword If    "${retain_new_booking_value.upper()}" == "TRUE"    Set Suite Variable    ${total_fare_alt_${fare_tab_index}}    ${total_fare}
    ...    ELSE    Set Suite Variable    ${amend_total_fare_alt_${fare_tab_index}}    ${total_fare}
    [Return]    ${total_fare_alt_${fare_tab_index}}

Get Total Fares
    [Arguments]    @{fares}
    ${total_fare_list}    Evaluate    map(float, @{fares})
    ${total_fare}    Evaluate    math.fsum(${total_fare_list})    math
    [Return]    ${total_fare}

Get Total For All Tickets Value With Alternate Fare Total Fare
    [Arguments]    ${alternate_fare_number}
    Get Sum Of X Number Of Alternate Fares    ${alternate_fare_number}
    ${fare_total_with_alternate}    Convert To String    ${alternate_fare_total}
    ${fare_total_with_alternate}    Run Keyword If    "${currency}" == "HKD"    Fetch From Left    ${fare_total_with_alternate}    .
    ...    ELSE    Set Variable    ${fare_total_with_alternate}
    ${fare_total_with_alternate}    Evaluate    ${total_for_all_tickets_value} + ${alternate_fare_total}
    Set Test Variable    ${fare_total_with_alternate}
    [Return]    ${fare_total_with_alternate}

Get Total Of High Fare, Charged Fare And Low Fare For ${number_of_fares} Fare Tabs
    Set Test Variable    ${total_high_fare}    0
    Set Test Variable    ${total_charged_fare}    0
    Set Test Variable    ${total_low_fare}    0
    : FOR    ${index}    IN RANGE    1    ${number_of_fares}+1
    \    Click Fare Tab    Fare ${index}
    \    Get Charged Fare Value    Fare ${index}
    \    Get High Fare Value    Fare ${index}
    \    Get Low Fare Value    Fare ${index}
    \    Get Fees Fare Value    Fare ${index}
    \    ${total_high_fare}    Evaluate    ${total_high_fare} + ${high_fare_value_${index}} + ${fees_fare_${index}}
    \    ${total_charged_fare}    Evaluate    ${total_charged_fare} + ${charged_value_${index}} + ${fees_fare_${index}}
    \    ${total_low_fare}    Evaluate    ${total_low_fare} + ${low_fare_value_${index}} + ${fees_fare_${index}}
    Set Test Variable    ${total_high_fare}
    Set Test Variable    ${total_charged_fare}
    Set Test Variable    ${total_low_fare}

Get Transaction Fee Amount Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    Comment    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee, cbTransactionFee_alt
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    ${is_contain}    Run Keyword And Return Status    Should Contain    ${transaction_fee_amount}    +
    ${transaction_fee_splitted}    Run Keyword If    ${is_contain}    Split String    ${transaction_fee_amount}    +
    ...    ELSE    Split String    ${transaction_fee_amount}    ${SPACE}
    ${lcc_amount}    Run Keyword If    ${is_contain}    Get From List    ${transaction_fee_splitted}    1
    ${lcc_amount}    Run Keyword If    ${is_contain}    Remove All Non-Integer (retain period)    ${lcc_amount}
    ${transaction_fee_amount}    Get From List    ${transaction_fee_splitted}    0
    ${transaction_fee_amount}    Remove All Non-Integer (retain period)    ${transaction_fee_amount}
    ${transaction_fee_amount}    Run Keyword If    ${is_contain}    Evaluate    ${transaction_fee_amount} + ${lcc_amount}
    ...    ELSE    Set Variable    ${transaction_fee_amount}
    Set Suite Variable    ${transaction_fee_value_${fare_tab_index}}    ${transaction_fee_amount}
    [Return]    ${transaction_fee_amount}

Get Transaction Fee Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    Comment    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee, cbTransactionFee_alt
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    ${transaction_fee_amount}    Fetch From Left    ${transaction_fee_amount}    -
    ${transaction_fee_amount}    Remove All Non-Integer (retain period)    ${transaction_fee_amount}
    Set Suite Variable    ${transaction_fee_value_${fare_tab_index}}    ${transaction_fee_amount}
    [Return]    ${transaction_fee_amount}

Get Transaction Fee List
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    @{transaction_fee_list}    Get Dropdown Values    ${object_name}
    Set Suite Variable    @{transaction_fee_list_${fare_tab_index}}    ${transaction_fee_list}
    [Return]    @{transaction_fee_list_${fare_tab_index}}

Get Valid On Value
    [Arguments]    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alternate
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${valid_on_obj}    Determine Multiple Object Name Based On Active Tab    ccboValidOnOBT, ccboValidOnOBT_alt, ccboValidOn_alt, ccboValidOn
    ${actual_valid_on}    Get Control Text Value    ${valid_on_obj}
    Set Suite Variable    ${valid_on_${fare_tab_index}}    ${actual_valid_on}
    Set Suite Variable    ${valid_on_value_${fare_tab_index}}    ${actual_valid_on}
    [Return]    ${actual_valid_on}

Manually Set Form Of Payment - Card Details On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${str_card_type}    ${str_card_number}    ${str_exp_date}    ${x_days}=0
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${edit_fop_field}    Determine Multiple Object Name Based On Active Tab    cmdEditFormOfPayment
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ccboCardType
    Run Keyword If    "${is_visible}" == "False"    Click Control Button    ${edit_fop_field}
    ${card_type_field}    Determine Multiple Object Name Based On Active Tab    ccboCardType
    ${card_number_field}    Determine Multiple Object Name Based On Active Tab    ctxtCardNumber
    ${exp_date_field}    Determine Multiple Object Name Based On Active Tab    cmtxtExpDate
    ${clear_fop}    Determine Multiple Object Name Based On Active Tab    cmdClearFOP
    ${add_fop}    Determine Multiple Object Name Based On Active Tab    cmdAddFOP
    Click Control Button    ${clear_fop}
    Click Control Button    ${card_type_field}
    Send    ${str_card_type}{TAB}
    Set Control Text Value    ${card_number_field}    ${str_card_number}
    Add Days On Current Date    ${x_days}
    Click Control Button    ${exp_date_field}
    Send    {LEFT 5}
    Run Keyword If    "${x_days}" == "0"    Send    ${str_exp_date}
    ...    ELSE    Send    ${mm}${yy}
    Click Control Button    ${add_fop}
    Set Suite Variable    ${str_card_type_${fare_tab_index}}    ${str_card_type}
    Set Suite Variable    ${str_card_number_${fare_tab_index}}    ${str_card_number}
    Run Keyword If    "${x_days}" == "0"    Set Suite Variable    ${str_exp_date_${fare_tab_index}}    ${str_exp_date}
    ...    ELSE    Set Suite Variable    ${str_exp_date_${fare_tab_index}}    ${mm}${yy}
    Set Test Variable    ${card_length}    0
    ${card_number}    Get Substring    ${str_card_number}    \    -4
    ${card_digits}    Get Substring    ${str_card_number}    -4
    ${card_length}    Get Length    ${card_number}
    Run Keyword If    "${card_length}" == "11"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "12"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "10"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXX${card_digits}

Populate Air Fare Panel Using Default Values For APAC
    [Arguments]    ${command}=SEND
    Set High Fare Field (If blank) with Charged Fare
    Set Low Fare Field (If blank) with Charged Fare
    Populate Air Fare Savings Code Using Default Values
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value}    Get Control Text Value    ${fop_field}
    Run Keyword If    "${command}" == "SEND" and "${fop_value}" == "${EMPTY}"    Run Keywords    Click Control Button    ${fop_field}    ${title_power_express}
    ...    AND    Set Control Text Value    ${fop_field}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${fop_value}
    ...    ELSE IF    "${command}" != "SEND" and "${fop_value}" == "${EMPTY}"    Set Control Text Value    ${fop_field}    ${fop_value}    ${title_power_express}
    Set Airline Commission Percentage    0
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee
    ${transaction_fee_amount}    Get Control Text Value    ${object_name}
    Run Keyword If    "${transaction_fee_amount}" == "${EMPTY}"    Set Control Text Value    ${object_name}    10
    Select Form Of Payment On Fare Quote Tab (If Blank)

Populate Air Fare Panel With Default Values
    @{tab_items}    Get Tab Items    TabControl1
    ${is_fare_quote}    Run Keyword And Return Status    List Should Contain Value    ${tab_items}    Fare 1
    Run Keyword If    ${is_fare_quote}    Populate Fare Details And Fees Tab With Default Values
    ...    ELSE    Tick Fare Not Finalised

Populate Air Fare Restrictions
    [Arguments]    ${air_fare_restriction}    ${changes_value}    ${cancellation_value}    ${valid_on_value}    ${re_route_value}    ${min_stay_value}
    ...    ${max_stay_value}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Select Fare Restriction    ${air_fare_restriction}
    Set Changes Value    ${changes_value}    ${fare_tab}    ${field_instance}
    Set Cancellation Value    ${cancellation_value}    ${fare_tab}    ${field_instance}
    Select Valid On Dropdown Value    ${valid_on_value}
    Select Re-Route Dropdown Value    ${re_route_value}
    Select Min Stay Dropdown Value    ${min_stay_value}
    Select Max Stay Dropdown Value    ${max_stay_value}

Populate Air Fare Restrictions Using Default Values
    Select Fare Restriction    Fully Flexible
    ${is_cancellation_obt_field_present} =    Control Command    ${title_power_express}    ${EMPTY}    ${cbo_CancellationsOBT_${fare_tab_index}}    IsVisible    ${EMPTY}
    ${is_cancellation_obt_field1_present} =    Control Command    ${title_power_express}    ${EMPTY}    [NAME:ccboCancellationsOBT_${fare_tab_index}]    IsVisible    ${EMPTY}
    Run Keyword If    ${is_cancellation_obt_field_present} == 1    Run Keywords    Control Click    ${title_power_express}    ${EMPTY}    ${cbo_CancellationsOBT_${fare_tab_index}}
    ...    AND    Send    {DOWN}
    ...    AND    Send    {TAB}
    Run Keyword If    ${is_cancellation_obt_field1_present} == 1    Run Keywords    Control Click    ${title_power_express}    ${EMPTY}    [NAME:ccboCancellationsOBT_${fare_tab_index}]
    ...    AND    Send    {DOWN}
    ...    AND    Send    {TAB}

Populate Air Fare Savings Code
    [Arguments]    ${realised_saving}    ${missed_saving}    ${class_code}
    Activate Power Express Window
    Select Realised Saving Code Value    ${realised_saving}
    Select Missed Saving Code Value    ${missed_saving}
    Select Class Code Value    ${class_code}

Populate Air Fare Savings Code Using Default Values
    Activate Power Express Window
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    ${realised_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    ${missed_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    ${class_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Control Focus    ${title_power_express}    ${EMPTY}    ${low_fare_field}
    Send    {TAB}{TAB}
    Sleep    0.5
    Control Focus    ${title_power_express}    ${EMPTY}    ${missed_saving_code_dropdown}
    Send    {DOWN}
    Sleep    0.5
    Send    {TAB}
    Sleep    0.5
    Control Focus    ${title_power_express}    ${EMPTY}    ${class_code_dropdown}
    Send    {DOWN}
    Sleep    0.5
    Send    {TAB}
    Sleep    0.5
    Control Focus    ${title_power_express}    ${EMPTY}    ${realised_saving_code_dropdown}
    Send    {DOWN}
    Sleep    0.5
    Send    {TAB}
    Sleep    0.5

Populate Air Savings Code
    [Arguments]    ${realised}    ${missed}    ${class}
    Select Realised Saving Code Value    ${realised}
    Select Missed Saving Code Value    ${missed}
    Select Class Code Value    ${class}

Populate Alternate Fare Details
    [Arguments]    ${routing}    ${airline}    ${total_fare}    ${fare_basis}    ${details}
    Set Alternate Fare Routing    ${routing}
    Set Alternate Fare Airline    ${airline}
    Set Alternate Fare Amount    ${total_fare}
    Set Alternate Fare Fare Basis    ${fare_basis}
    Set Alternate Fare Details    ${details}
    Select Alternate Fare Class Code
    Select Fare Restriction    Fully Flexible

Populate Alternate Fare Details Using Copy Air Button
    [Arguments]    ${fare_basis_details}    ${total_fare}    ${class_code}
    Click Copy Alternate Fare
    Set Alternate Fare Fare Basis    ${fare_basis_details}
    Set Alternate Fare Amount    ${total_fare}
    Select Alternate Fare Class Code    \    ${class_code}
    Select Fare Restriction    Fully Flexible

Populate Alternate Fare With Default Values
    [Arguments]    ${fare_tab_value}
    Click Panel    Air Fare
    Click Fare Tab    ${fare_tab_value}
    Select Fare Restriction    Fully Flexible
    Select Alternate Fare Class Code    ${fare_tab_value}

Populate Fare Details And Fees Tab With Default Values
    [Arguments]    @{tab_items}
    ${is_tab_items_empty}    Run Keyword And Return Status    Should Be Empty    ${tab_items}
    @{tab_items}    Run Keyword If    ${is_tab_items_empty} == True    Get Tab Items    TabControl1
    ...    ELSE    Set Variable    ${tab_items}
    : FOR    ${tab}    IN    @{tab_items}
    \    Click Fare Tab    ${tab}
    \    ${alternate_tab}    Run Keyword And Return Status    Should Contain    ${tab}    Alt
    \    Run Keyword If    ${alternate_tab} == True    Populate Alternate Fare Quote Tabs With Default Values
    \    ...    ELSE    Populate Fare Quote Tabs with Default Values

Populate Fare Quote Tabs with Default Values
    [Documentation]    Currently applicable to APAC only
    Select Tab Control    Air Fare    FareDetailsAndFeesTab
    Verify No Fares Found Message Is Not Present
    Set High Fare Field (If blank) with Charged Fare
    Set Low Fare Field (If blank) with Charged Fare
    Populate Air Fare Savings Code Using Default Values (If Blank)
    ${merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${commission_rebate}    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount, ctxtCommissionRebateAmount
    ${commission_rebate_percentage}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent
    ${airline_commission_percentage}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineCommissionPercent
    ${transaction_fee}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee,cbTransactionFee
    ${fare_type}    Determine Multiple Object Name Based On Active Tab    ccboFaretype
    ${fop_field_empty}    Run Keyword If    ${fop_field.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${fop_field}
    ${commission_rebate_empty}    Run Keyword If    ${commission_rebate.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${commission_rebate}
    ${commission_rebate_percentage_empty}    Run Keyword If    ${commission_rebate_percentage.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${commission_rebate_percentage}
    ${airline_commission_percentage_empty}    Run Keyword If    ${airline_commission_percentage.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${airline_commission_percentage}
    ${transaction_fee_empty}    Run Keyword If    ${transaction_fee.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${transaction_fee}
    ${is_fare_type_empty}    Run Keyword If    ${fare_type.endswith("_10]")}    Set Variable    ${False}
    ...    ELSE    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${fare_type}
    ${is_merchant_field_visible}    Control Command    ${title_power_express}    ${EMPTY}    ${merchant_field}    IsVisible    ${EMPTY}
    Activate Power Express Window
    ${is_merchant_mandatory}    Run Keyword If    ${is_merchant_field_visible} == 1    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${merchant_field}
    ...    ELSE    Set Variable    ${False}
    ${is_commission_rebate_mandatory}    Run Keyword If    ${commission_rebate_empty}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${commission_rebate}
    ...    ELSE    Set Variable    ${False}
    ${is_commission_rebate_percentage_mandatory}    Run Keyword If    ${commission_rebate_percentage_empty}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${commission_rebate_percentage}
    ...    ELSE    Set Variable    ${False}
    ${is_airline_commission_percentage_mandatory}    Run Keyword If    ${airline_commission_percentage_empty}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${airline_commission_percentage}
    ...    ELSE    Set Variable    ${False}
    ${is_transaction_fee_mandatory}    Run Keyword If    ${transaction_fee_empty}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${transaction_fee}
    ...    ELSE    Set Variable    ${False}
    ${is_fop_enabled}    Run Keyword And Return Status    Verify Control Object Is Enabled    ${fop_field}
    Run Keyword If    ${is_merchant_field_visible} == 1 and ${is_merchant_mandatory}    Select Merchant On Fare Quote Tab    Airline
    Run Keyword If    ${fop_field_empty} and ${is_fop_enabled}    Select Cash As Form Of Payment In Fare Quote Tab
    Run Keyword If    ${is_commission_rebate_mandatory}    Set Commission Rebate Amount    10
    Run Keyword If    ${is_commission_rebate_percentage_mandatory}    Set Commission Rebate Percentage    10
    Run Keyword If    ${is_airline_commission_percentage_mandatory}    Set Airline Commission Percentage    10
    Run Keyword If    ${is_transaction_fee_mandatory}    Set Transaction Fee    0
    Run Keyword If    ${is_fare_type_empty}    Select Fare Type    Published Fare
    Populate Fare Restrictions To Default Value
    Click Control Button    [NAME:cboNativeEntry]        

Populate Fare Tab With Default Values
    [Arguments]    ${tab_number}    ${savings_default}=false    ${fare_restriction_default}=false    ${turnaround}=${EMPTY}
    Click Panel    Air Fare
    Click Fare Tab    ${tab_number}
    Verify No Fares Found Message Is Not Present
    Set High Fare Field (If blank) with Charged Fare
    Set Low Fare Field (If blank) with Charged Fare
    Run Keyword If    '${savings_default}' != 'true'    Populate Air Fare Savings Code Using Default Values (If Blank)
    Run Keyword If    '${fare_restriction_default}' != 'true'    Populate Air Fare Restrictions Using Default Values
    Select Turnaround    ${turnaround}

Populate Missed Saving Code If Enabled
    [Arguments]    ${fare_tab_value}    ${missed_savings_selection}=${EMPTY}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    ${is_enabled} =    Control Command    ${title_power_express}    ${EMPTY}    ${object_name}    IsEnabled    ${EMPTY}
    ${fare_code_value}    Get Sub String    ${missed_savings_selection}    0    1
    Run Keyword If    '${is_enabled}' == '1'    Select Value From Dropdown List    ${object_name}    ${missed_savings_selection}
    Run Keyword If    '${is_enabled}' == '0'    Log    Missed saving field code is disabled
    Run Keyword If    '${is_enabled}' == '1'    Set test Variable    ${fare_code_value${fare_tab_index}}    ${fare_code_value}
    Run Keyword If    '${is_enabled}' == '0'    Set test Variable    ${fare_code_value${fare_tab_index}}    L

Populate Pricing Extras Fields
    [Arguments]    ${airline_commission_percentage}    ${commission_rebate_percentage}    ${nett_fare}    ${transaction_fee}    ${mark_up_percentage}    ${merchant_fee_percentage}
    Select Airline Commission Percentage    ${airline_commission_percentage}
    Set Commission Rebate Percentage    ${commission_rebate_percentage}
    Set Transaction Fee    ${transaction_fee}
    Set Nett Fare Field    ${nett_fare}
    Set Mark-up Percentage Field    ${mark_up_percentage}
    Set Merchant Fee Percentage Field    ${merchant_fee_percentage}

Populate Realised Saving Code If Enabled
    [Arguments]    ${fare_tab_value}    ${realised_savings_selection}=${EMPTY}
    ${fare_tab_index} =    Fetch From Right    ${fare_tab_value}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    ${is_enabled} =    Control Command    ${title_power_express}    ${EMPTY}    ${object_name}    IsEnabled    ${EMPTY}
    ${fare_code_value}    Get Sub String    ${realised_savings_selection}    0    1
    Run Keyword If    '${is_enabled}' == '1'    Select Value From Dropdown List    ${object_name}    ${realised_savings_selection}
    Run Keyword If    '${is_enabled}' == '0'    Log    Realised saving field code is disabled
    Run Keyword If    '${is_enabled}' == '1'    Set test Variable    ${fare_code_value${fare_tab_index}}    ${fare_code_value}
    Run Keyword If    '${is_enabled}' == '0'    Set test Variable    ${fare_code_value${fare_tab_index}}    L

Remove Fare Tab
    [Arguments]    ${tab_number}
    Click Panel    Air Fare
    Click Fare Tab    ${tab_number}
    Click Remove Fare
    Verify Fare Tab Is Not Visible    ${tab_number}

Select Airline Commission Percentage
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbCommissionRebatePercent
    ${bg_color}    Determine Control Object Background Color    ${object_name}
    Run Keyword If    "${command}" == "SEND" and "${bg_color}" != "D3D3D3"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    AND    Send    {TAB}
    ...    AND    Verify Control Object Text Value Is Correct    ${object_name}    ${str_valuetoset}    Airline Commission Percentage is successfully set to ${str_valuetoset}
    ...    ELSE IF    "${command}" == "SELECT" and "${bg_color}" != "D3D3D3"    Run Keyword    Select Value From Dropdown List    ${object_name}    ${str_valuetoset}
    ...    ELSE IF    "${command}" != "SEND" and "${bg_color}" != "D3D3D3"    Run Keywords    Set Control Text Value    ${object_name}    ${str_valuetoset}
    ...    ${title_power_express}
    ...    AND    Send    {TAB}
    ...    AND    Verify Control Object Text Value Is Correct    ${object_name}    ${str_valuetoset}
    ...    ELSE IF    "${bg_color}" == "D3D3D3"    Log    Airline Commission Percentage is disabled.    WARN

Select Alternate Fare Class Code
    [Arguments]    ${fare_tab}=${EMPTY}    ${str_valuetoset}=${EMPTY}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${alternate_fare_class_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboFareClassOffer_alt, ccboFareClassOffer
    Control Focus    ${title_power_express}    ${EMPTY}    ${alternate_fare_class_code_dropdown}
    Run Keyword If    "${str_valuetoset}" <> "${EMPTY}"    Select Value From Dropdown List    ${alternate_fare_class_code_dropdown}    ${str_valuetoset}
    Run Keyword If    "${str_valuetoset}" == "${EMPTY}"    Send    {DOWN}
    Run Keyword If    "${str_valuetoset}" == "${EMPTY}"    Send    {ENTER}
    Send    {TAB}
    Set Suite Variable    ${fare_class_code_alt_${fare_tab_index}}    ${str_valuetoset}

Select Alternate Fully Flex
    ${alternate_fullyflex}    Determine Multiple Object Name Based On Active Tab    cradFullyFlex_alt, cradFullFlexOBT_alt, cradFullyFlex, cradFullyFlex_alt, cradFullFlexOBT
    Click Control Button    ${alternate_fullyflex}

Select Cancellation Dropdown Value
    [Arguments]    ${cancellation_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboCancellationsOBT,ccboCancellations0,ccboCancellationsOBT_alt,ccboCancellations_alt,ccboCancellations_${fare_tab_index},ccboCancellations_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Select Value From Dropdown List    ${object_name}    ${cancellation_code}

Select Cash As Form Of Payment In Fare Quote Tab
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Select Value From Combobox    ${fop_field}    Cash

Select Changes Dropdown Value
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboChangesOBT,ccboChanges0,ccboChangesOBT_alt,ccboChanges_alt,ccboChanges_${fare_tab_index},ccboChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Select Value From Dropdown List    ${object_name}    ${changes_code}

Select Class Code Value
    [Arguments]    ${class_code}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboClass
    Select Value From Dropdown List    ${object_name}    ${class_code}

Select Compliant Dropdown Value
    [Arguments]    ${complaint_dropdown_value}
    ${complaint_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboCompliantOBT, ccboCompliantOBT_alt
    Select Value From Dropdown List    ${complaint_dropdown}    ${complaint_dropdown_value}

Select FOP Merchant On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop_merchant_type}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    Wait Until Control Object Is Enabled    ${object_name}    ${title_power_express}
    Select Value From Dropdown List    ${object_name}    ${fop_merchant_type}
    Control Click    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}    ${EMPTY}
    Set Suite Variable    ${fop_merchant_fee_type_${fare_tab_index}}    ${fop_merchant_type}

Select Fare Restriction
    [Arguments]    ${fare_restriction}
    ${object_name}    Run Keyword If    "${fare_restriction.upper()}" == "FULLY FLEXIBLE" or "${fare_restriction}" == "1"    Determine Multiple Object Name Based On Active Tab    cradFullyFlex,cradFullFlex,cradFullyFlexOBT,cradFullFlexOBT,cradFullFlexOBT_alt,cradFullyFlexOBT_alt, cradFullFlex_alt,cradFullyFlex_alt
    ...    ELSE IF    "${fare_restriction.upper()}" == "SEMI FLEXIBLE" or "${fare_restriction}" == "2"    Determine Multiple Object Name Based On Active Tab    cradSemiFlex_alt, cradSemiFlexOBT_alt, cradSemiFlex, cradSemiFlex_alt, cradSemiFlexOBT
    ...    ELSE IF    "${fare_restriction.upper()}" == "NON FLEXIBLE" or "${fare_restriction}" == "3"    Determine Multiple Object Name Based On Active Tab    cradNonFlex_alt, cradNonFlexOBT_alt, cradNonFlex, cradNonFlex_alt, cradNonFlexOBT
    ...    ELSE IF    "${fare_restriction.upper()}" == "DEFAULT"    Determine Multiple Object Name Based On Active Tab    cradDefault,cradDefaultOBT,cradDefault_alt,cradDefaultOBT_alt
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Invalid Fare Restriction: ${fare_restriction}
    Run Keyword If    "${object_name}" != "${EMPTY}" and "${fare_restriction}" != "${EMPTY}"    Click Control Button    ${object_name}

Select Fare Type
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboFaretype
    Select Value From Dropdown List    ${object_name}    ${str_valuetoset}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Select Form Of Payment On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop_value}    ${tab}={TAB}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_status}    Run Keyword And Return Status    Should Contain    ${fare_tab}    Alternate Fare
    ${fare_tab_index}    Run Keyword If    "${fare_tab_status}" == "False"    Set Variable    ${fare_tab_index}
    ...    ELSE    Set Variable    alt_${fare_tab_index}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Verify Control Object Is Enabled    ${fop_field}    message=FOP field should be enabled before you can select. Check SO config.
    Select Value From Dropdown List    ${fop_field}    ${fop_value}
    Run Keyword If    "${tab}" != "${EMPTY}"    Send    ${tab}
    Click Mask Icon To Unmask Card On Fare Quote Tab
    ${fop_value}    Get Control Text Value    ${fop_field}
    ${separator_count}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Count Values In List    ${fop_value}    /
    ${fop_index}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Split String    ${fop_value}    /
    ${new_fop}    Run Keyword If    ${separator_count} > 1    Catenate    ${fop_index[1]}    ${fop_index[2]}
    ...    ELSE IF    ${separator_count} == 1    Catenate    ${fop_index[0]}    ${fop_index[1]}
    ${str_card_type}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[1]}    0    2
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[0]}    0    2
    ${str_card_number}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[1]}    2
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[0]}    2
    ${str_exp_date}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[2]}    1    5
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[1]}    1    5
    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Set Suite Variable    ${str_card_type_${fare_tab_index}}    ${str_card_type}
    ...    ELSE    Set Suite Variable    ${str_card_type_${fare_tab_index}}    ${fop_value}
    Set Suite Variable    ${str_card_number_${fare_tab_index}}    ${str_card_number}
    Set Suite Variable    ${str_exp_date_${fare_tab_index}}    ${str_exp_date}
    Set Test Variable    ${card_length}    0
    ${card_number}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Substring    ${str_card_number}    \    -4
    ${card_digits}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Substring    ${str_card_number}    -4
    ${card_length}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Length    ${card_number}
    Run Keyword If    "${card_length}" == "11"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "12"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "10"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXX${card_digits}

Select Form Of Payment On Fare Quote Tab (If Blank)
    [Arguments]    ${fop_select}=Cash    ${tab}={TAB}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value}    Get Control Text Value    ${fop_field}
    Run Keyword If    "${fop_value}" == "${EMPTY}"    Click Control Button    ${fop_field}    ${title_power_express}
    Run Keyword If    "${fop_value}" == "${EMPTY}"    Select Value From Combobox    ${fop_field}    ${fop_select}
    Run Keyword If    "${tab}" != "${EMPTY}" and "${fop_value}" == "${EMPTY}"    Send    ${tab}

Select Fully Flexible
    ${fully_flex_control}    Determine Multiple Object Name Based On Active Tab    cradFullyFlex,cradFullFlex,cradFullyFlexOBT,cradFullFlexOBT,cradFullFlexOBT_alt,cradFullyFlexOBT_alt, cradFullFlex_alt,cradFullyFlex_alt
    Click Control Button    ${fully_flex_control}

Select Max Stay Dropdown Value
    [Arguments]    ${max_stay_value}
    ${max_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMaxStay, ccboMaxStayOBT, ccboMaxStayOBT_alt, ccboMaxStay_alt
    Select Value From Dropdown List    ${max_stay_dropdown}    ${max_stay_value}

Select Merchant On Fare Quote Tab
    [Arguments]    ${merchant_value}
    ${merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    Wait Until Control Object Is Visible    ${merchant_field}
    Select Value From Combobox    ${merchant_field}    ${merchant_value}
    Control Focus    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}

Select Min Stay Dropdown Value
    [Arguments]    ${min_stay_value}
    ${min_stay_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMinStay, ccboMinStayOBT, ccboMinStayOBT_alt, ccboMinStay_alt
    Select Value From Dropdown List    ${min_stay_dropdown}    ${min_stay_value}

Select Missed Saving Code Value
    [Arguments]    ${missed_saving}    ${default_control_counter}=True
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboMissed,MissedSavingCodeComboBox    ${default_control_counter}
    Select Value From Dropdown List    ${object_name}    ${missed_saving}

Select Non Flexible
    ${non_flex_control}    Determine Multiple Object Name Based On Active Tab    cradNonFlex_alt, cradNonFlexOBT_alt, cradNonFlex, cradNonFlex_alt, cradNonFlexOBT
    Click Control Button    ${non_flex_control}

Select Re-Route Dropdown Value
    [Arguments]    ${re_route_value}
    ${re_route_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboReRoute, ccboReRouteOBT, ccboReRouteOBT_alt, ccboReRoute_alt
    Select Value From Dropdown List    ${re_route_dropdown}    ${re_route_value}

Select Realised Saving Code Value
    [Arguments]    ${realised_saving}    ${default_control_counter}=True
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboRealised,RealisedSavingCodeComboBox    ${default_control_counter}
    Select Value From Dropdown List    ${object_name}    ${realised_saving}

Select Route Code Value
    [Arguments]    ${route_code}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cbRouteGeographyCode
    Select Value From Dropdown List    ${object_name}    ${route_code}

Select Semi Flexible
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cradSemiFlex_alt, cradSemiFlexOBT_alt, cradSemiFlex, cradSemiFlex_alt, cradSemiFlexOBT
    Click Control Button    ${object_name}

Select Transaction Fee
    [Arguments]    ${transaction_fee_or_index}    ${use_index}=False
    [Documentation]    Set ${use_index} to True if you want to use index value
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee,cbTransactionFee
    Select Value From Dropdown List    ${object_name}    ${transaction_fee_or_index}    by_index=${use_index}

Select Turnaround
    [Arguments]    ${turnaround}=${EMPTY}
    ${turnaround_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboPOT
    ${isVisible}    Control Command    ${title_power_express}    ${EMPTY}    ${turnaround_dropdown}    IsVisible    ${EMPTY}
    Run Keyword If    "${turnaround}" != "${EMPTY}"    Select Value From Dropdown List    ${turnaround_dropdown}    ${turnaround}
    ${default_value}    Run Keyword If    "${turnaround}" == "${EMPTY}"    Control Get Text    ${title_power_express}    ${EMPTY}    ${turnaround_dropdown}
    Run Keyword If    "${turnaround}" == "${EMPTY}" and "${default_value}" == "${EMPTY}" and ${isVisible} == 1    Control Click    ${title_power_express}    ${EMPTY}    ${turnaround_dropdown}
    Run Keyword If    "${turnaround}" == "${EMPTY}" and "${default_value}" == "${EMPTY}" and ${isVisible} == 1    Send    {DOWN}{ENTER}

Select Valid On
    [Arguments]    ${valid_on}=${EMPTY}
    ${valid_on_obj}    Determine Multiple Object Name Based On Active Tab    ccboValidOnOBT, ccboValidOnOBT_alt, ccboValidOn_alt, ccboValidOn
    ${actual_valid_on}    Get Control Text Value    ${valid_on_obj}
    Run Keyword If    "${valid_on}" != "${EMPTY}"    Select Value From Dropdown List    ${valid_on_obj}    ${valid_on}
    Run Keyword If    "${valid_on}" == "${EMPTY}"    Run Keywords    Click Control Button    ${valid_on_obj}
    ...    AND    Send    {DOWN}{ENTER}

Set Alternate Fare - Commission Rebate Percentage
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount, ctxtCommissionPercent
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Off    ${str_valuetoset}    2
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    2
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${commission_rebate_percentage_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Fuel Surcharge Field
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtFuelSurcharge,ctxtFuelSurcharge
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    ${country}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${fuel_surcharge_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Mark-Up Amount Field
    [Arguments]    ${fare_tab}    ${mark_up_amount}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount,txtMarkupAmount
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${mark_up_amount}
    ...    ELSE    Set Control Text Value    ${object_name}    ${mark_up_amount}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${mark_up_amount}    Round Apac    ${mark_up_amount}    ${country}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${mark_up_amount}"    ${object_name} should be successfully set to ${mark_up_amount}
    Set Suite Variable    ${mark_up_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Mark-up Percentage Field
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent,txtMarkupPercentage,ctxtMarkUpPercent_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Off    ${str_valuetoset}    2
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    2
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${mark_up_percentage_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Merchant Fee Amount
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    ${country}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${merchant_fee_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Merchant Fee Percentage Field
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Off    ${str_valuetoset}    2
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    2
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${merchant_fee_percentage_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Nett Fare Field
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtNetFare
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE IF    "${str_valuetoset}" == "${EMPTY}"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    ${country}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${nett_fare_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare - Transaction Fee
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${country}    Get Substring    ${TEST NAME}    4    6
    Log    Setting ${str_valuetoset} in the Transaction Fee Field.
    Sleep    1
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee,cbTransactionFee
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE IF    "${command}" == "DEL"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {DELETE}
    ...    ELSE IF    "${command}" == "SELECT"    Run Keywords    Select Value From Dropdown List    ${object_name}    ${str_valuetoset}
    ...    AND    Send    {TAB}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    ${country}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}" or "${value}" == "${str_valuetoset}.00"    ${object_name} should be successfully set to ${str_valuetoset}
    Set Suite Variable    ${transaction_fee_value_alt_${fare_tab_index}}    ${value}

Set Alternate Fare Airline
    [Arguments]    ${airline}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineOffer_alt
    Set Control Text Value    ${object_name}    ${airline}

Set Alternate Fare Amount
    [Arguments]    ${total_fare}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalFareOffer_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${total_fare}
    ...    ELSE    Set Control Text Value    ${object_name}    ${total_fare}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Run Keyword If    "${value}" == "${total_fare}"    Log    ${object_name} is successfully set to ${total_fare}
    ...    ELSE    Run keyword and Continue On Failure    FAIL    ${object_name} is NOT successfully set to ${total_fare}

Set Alternate Fare Details
    [Arguments]    ${details}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtDetailsOffer_alt
    Set Control Text Value    ${object_name}    ${details}

Set Alternate Fare Details With New Line Details
    [Arguments]    ${added_text}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtDetailsOffer_alt
    Click Control Button    ${object_name}
    Send    {END}{ENTER}
    Send    ${added_text}
    Send    {ENTER}
    Sleep    1
    Send    {TAB}

Set Alternate Fare Fare Basis
    [Arguments]    ${fare_basis}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFareBasisOffer_alt, ctxtFareBasisOffer_alt
    Control Click    ${title_power_express}    ${EMPTY}    ${object_name}
    Control Set Text    ${title_power_express}    ${EMPTY}    ${object_name}    ${fare_basis}

Set Alternate Fare Fuel Surcharge
    [Arguments]    ${fuel_surcharge}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtFuelSurchargeOffer_alt
    Set Control Text Value    ${object_name}    ${fuel_surcharge}

Set Alternate Fare Merchant Fee
    [Arguments]    ${merchant_fee}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeOffer_alt
    Set Control Text Value    ${object_name}    ${merchant_fee}

Set Alternate Fare Routing
    [Arguments]    ${routing}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt
    Click Control Button    ${object_name}    ${title_power_express}
    Set Control Text Value    ${object_name}    ${EMPTY}
    Send    ${routing}

Set Alternate Fare Transaction Fee
    [Arguments]    ${transaction_fee}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTransactionFeeOffer_alt
    Set Control Text Value    ${object_name}    ${transaction_fee}

Set Cancellation Value
    [Arguments]    ${cancellation_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboCancellationsOBT,ccboCancellations0,ccboCancellationsOBT_alt,ccboCancellations_alt,ccboCancellations_${fare_tab_index},ccboCancellations_alt_${fare_tab_index},ccboCancellations_${fare_tab_index}_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Set Control Text Value    ${object_name}    ${cancellation_code}
    Send    {TAB}

Set Changes Value
    [Arguments]    ${changes_code}    ${fare_tab}=Fare 1    ${field_instance}=${EMPTY}    ${default_control_counter}=True
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ccboChangesOBT,ccboChanges0,ccboChangesOBT_alt,ccboChanges_alt,ccboChanges_${fare_tab_index},ccboChanges_alt_${fare_tab_index}    ${default_control_counter}    ${field_instance}
    Set Control Text Value    ${object_name}    ${changes_code}
    Send    {TAB}

Set Charged Fare Field
    [Arguments]    ${charged_fare_value}
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    Set Control Text Value    ${charged_fare_field}    ${charged_fare_value}

Set Comment Value
    [Arguments]    ${comment_value}
    ${comment_field}    Determine Multiple Object Name Based On Active Tab    ctxtCommentsOBT, ctxtCommentsOBT_alt
    Set Control Text Value    ${comment_field}    ${comment_value}

Set Commission Rebate Amount
    [Arguments]    ${commission_rebate_amount}    ${command}=SEND    ${start_substring}=4    ${end_substring}=6
    ${country}    Get Substring    ${TEST NAME}    ${start_substring}    ${end_substring}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount, ctxtCommissionRebateAmount
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${commission_rebate_amount}
    ...    ELSE    Set Control Text Value    ${object_name}    ${commission_rebate_amount}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${commission_rebate_amount}    Run Keyword If    "${country}" == "SG"    Round Off    ${commission_rebate_amount}    2
    ...    ELSE    Round Off    ${commission_rebate_amount}    0
    ${commission_rebate_amount}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${commission_rebate_amount}    2
    ...    ELSE    Convert To Float    ${commission_rebate_amount}    0
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${commission_rebate_amount}"    ${object_name} should be successfully set to ${commission_rebate_amount}

Set Commission Rebate Percentage
    [Arguments]    ${str_valuetoset}    ${command}=SEND    ${start_substring}=4    ${end_substring}=6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount, ctxtCommissionPercent, ctxtCommissionPercent_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Off    ${str_valuetoset}    2
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    2
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Commission Rebate Percentage Value To Empty
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtClientCommissionRebateAmount, ctxtCommissionPercent
    Set Field To Empty    ${object_name}

Set Fees Field
    [Arguments]    ${fees_value}
    ${fees_field}    Determine Multiple Object Name Based On Active Tab    ctxtFees
    ${current_fees_value}    Set Control Text Value    ${fees_field}    ${fees_value}

Set Fees Field (If Zero)
    [Arguments]    ${fees_value}
    ${fees_field}    Determine Multiple Object Name Based On Active Tab    ctxtFees
    ${current_fees_value}    Get Control Text Value    ${fees_field}
    Run Keyword If    "${current_fees_value}" == "${EMPTY}" or "${current_fees_value}" == "0.00" or "${current_fees_value}" == "0.0" or "${current_fees_value}" == "0"    Set Control Text Value    ${fees_field}    ${fees_value}

Set Form Of Payment On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop_value}    ${command}=SEND
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Comment    Run Keyword If    "${action_needed}" == "SEND"    Send Control Text Value    ${fop_field}    ${fop_value}
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${fop_field}    ${title_power_express}
    ...    AND    Set Control Text Value    ${fop_field}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${fop_value}
    ...    ELSE    Set Control Text Value    ${fop_field}    ${fop_value}    ${title_power_express}
    SEND    {TAB}
    ${separator_count}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Count Values In List    ${fop_value}    /
    ${fop_index}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Split String    ${fop_value}    /
    ${new_fop}    Run Keyword If    ${separator_count} > 1    Catenate    ${fop_index[1]}    ${fop_index[2]}
    ...    ELSE IF    ${separator_count} == 1    Catenate    ${fop_index[0]}    ${fop_index[1]}
    ${str_card_type}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[1]}    0    2
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[0]}    0    2
    ${str_card_number}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[1]}    2
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[0]}    2
    ${str_exp_date}    Run Keyword If    ${separator_count} > 1    Get Substring    ${fop_index[2]}    1    5
    ...    ELSE IF    ${separator_count} == 1    Get Substring    ${fop_index[1]}    1    5
    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Set Suite Variable    ${str_card_type_${fare_tab_index}}    ${str_card_type}
    ...    ELSE    Set Suite Variable    ${str_card_type_${fare_tab_index}}    ${fop_value}
    Set Suite Variable    ${str_card_number_${fare_tab_index}}    ${str_card_number}
    Set Suite Variable    ${str_exp_date_${fare_tab_index}}    ${str_exp_date}
    Set Test Variable    ${card_length}    0
    ${card_number}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Substring    ${str_card_number}    \    -4
    ${card_digits}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Substring    ${str_card_number}    -4
    ${card_length}    Run Keyword If    "${fop_value.upper()}" != "CASH" and "${fop_value.upper()}" != "INVOICE"    Get Length    ${card_number}
    Run Keyword If    "${card_length}" == "11"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "12"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXXXX${card_digits}
    ...    ELSE IF    "${card_length}" == "10"    Set Suite Variable    ${str_card_number2_${fare_tab_index}}    XXXXXXXXXX${card_digits}

Set Fuel Surcharge Field
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    Activate Power Express Window
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtFuelSurcharge,ctxtFuelSurcharge
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Off    ${str_valuetoset}    0
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    0
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Fuel Surcharge Value To Empty
    ${fuel_surcharge_field_name}    Determine Multiple Object Name Based On Active Tab    txtFuelSurcharge,ctxtFuelSurcharge
    Set Field To Empty    ${fuel_surcharge_field_name}

Set High Fare Field
    [Arguments]    ${high_fare_value}    ${action_needed}=SEND
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    Run Keyword If    "${action_needed.upper()}" == "SEND"    Send Control Text Value    ${high_fare_field}    ${high_fare_value}
    ...    ELSE    Set Control Text Value    ${high_fare_field}    ${high_fare_value}
    Send    {TAB}

Set High Fare Field (If blank) with Charged Fare
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${high_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtHighFare
    ${charged_fare}    Get Control Text Value    ${charged_fare_field}
    ${high_fare}    Get Control Text Value    ${high_fare_field}
    ${converted_charged_fare}    Replace String    ${charged_fare}    ,    .
    ${converted_high_fare}    Replace String    ${high_fare}    ,    .
    Run Keyword If    '${high_fare}' == '${EMPTY}'    Set Control Text Value    ${high_fare_field}    ${charged_fare}
    ...    ELSE IF    ${converted_high_fare} < ${converted_charged_fare}    Set Control Text Value    ${high_fare_field}    ${charged_fare}

Set High Fare Field With Charged Fare
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${charged_fare}    Get Control Text Value    ${charged_fare_field}
    Set High Fare Field    ${charged_fare}

Set LFCC Field
    [Arguments]    ${str_valuetoset}=QF    ${command}=SEND
    Log    Setting ${str_valuetoset} in the LFCC textbox.
    Sleep    1
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtLowestFareCC
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Low Fare Field
    [Arguments]    ${low_fare_value}    ${default_control_counter}=True
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare,LowFareTextBox    ${default_control_counter}
    Send Control Text Value    ${low_fare_field}    ${low_fare_value}
    Send    {TAB}

Set Low Fare Field (If blank) with Charged Fare
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${low_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtLowFare
    ${charged_fare}    Get Control Text Value    ${charged_fare_field}
    ${low_fare}    Get Control Text Value    ${low_fare_field}
    ${converted_charged_fare}    Replace String    ${charged_fare}    ,    .
    ${converted_low_fare}    Replace String    ${low_fare}    ,    .
    Run Keyword If    '${low_fare}' == '${EMPTY}'    Set Control Text Value    ${low_fare_field}    ${charged_fare}
    ...    ELSE IF    ${converted_low_fare} > ${converted_charged_fare}    Set Control Text Value    ${low_fare_field}    ${charged_fare}

Set Low Fare Field With Charged Fare
    ${charged_fare_field}    Determine Multiple Object Name Based On Active Tab    ctxtChargedFare
    ${charged_fare}    Get Control Text Value    ${charged_fare_field}
    Set Low Fare Field    ${charged_fare}

Set Mark-Up Amount Field
    [Arguments]    ${mark_up_amount}    ${command}=SEND
    ${country}    Get Substring    ${TEST NAME}    4    6
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpAmount,txtMarkupAmount
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${mark_up_amount}
    ...    ELSE    Set Control Text Value    ${object_name}    ${mark_up_amount}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Comment    ${mark_up_amount}    Run Keyword If    "${country}" == "SG"    Round Off    ${mark_up_amount}    2
    ...    ELSE    Round Off    ${mark_up_amount}    0
    Comment    ${mark_up_amount}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${mark_up_amount}    2
    ...    ELSE    Convert To Float    ${mark_up_amount}    0
    ${mark_up_amount}    Run Keyword If    "${country}" == "SG" or "${country}" == "HK"    Round To Nearest Dollar    ${mark_up_amount}    ${country}    up
    ...    ELSE    ${mark_up_amount}    ${country}
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${mark_up_amount}"    ${object_name} should be successfully set to ${mark_up_amount}

Set Mark-up Percentage Field
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent,txtMarkupPercentage,ctxtMarkUpPercent_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Convert To Float    ${str_valuetoset}    2
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Merchant Fee Amount
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeeAmount
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Run Keyword If    "${country}" == "SG"    Round Off    ${str_valuetoset}    2
    ...    ELSE    Round Off    ${str_valuetoset}    0
    ${str_valuetoset}    Run Keyword If    "${country}" == "SG"    Convert To Float    ${str_valuetoset}    2
    ...    ELSE    Convert To Float    ${str_valuetoset}    0
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Merchant Fee Percentage Field
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtMerchantFeePercent, ctxtMerchantFeePercent_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    SG
    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}"    ${object_name} should be successfully set to ${str_valuetoset}

Set Nett Fare Field
    [Arguments]    ${fare_tab}    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    txtNetFare
    Set Control Text    ${object_name}    ${str_valuetoset}
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:cboNativeEntry]
    Get Nett Fare Value    ${fare_tab}

Set Transaction Fee
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${country}    Get Substring    ${TEST NAME}    4    6
    Log    Setting ${str_valuetoset} in the Transaction Fee Field.
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmbTransactionFee,cbTransactionFee,cbTransactionFee_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Set Control Text Value    ${object_name}    ${EMPTY}    ${title_power_express}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE IF    "${command}" == "DEL"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {DELETE}
    ...    ELSE IF    "${command}" == "SELECT"    Run Keywords    Select Value From Dropdown List    ${object_name}    ${str_valuetoset}
    ...    AND    Send    {TAB}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Control Focus    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}
    ${str_valuetoset}    Round Apac    ${str_valuetoset}    ${country}
    Comment    ${value}    Get Control Text Value    ${object_name}    ${title_power_express}
    Comment    Run Keyword And Continue On Failure    Should Be True    "${value}" == "${str_valuetoset}" or "${value}" == "${str_valuetoset}.00" or ${str_valuetoset} == None    ${object_name} should be successfully set to ${str_valuetoset}

Tick Fare Not Finalised
    @{tab_items}    Get Tab Items    TabControl1
    Click Fare Tab    ${tab_items[0]}
    Tick Checkbox    ${chk_not_finalised}

Untick Fare Not Finalised
    Click Fare Tab    Fare 1
    Untick Checkbox    ${chk_not_finalised}

Get Masked Credit Card And Expiry Date
    [Arguments]    ${credit_card}
    ${credit_card_number_group}    Get Regexp Matches    ${credit_card}    (\\D{2}\\*+\\d{4}|\\D{2}\\d+)\/D(\\d{4})    1    2
    ${credit_card_number}    Set Variable    ${credit_card_number_group[0][0]}
    ${credit_card_expiry_date}    Set Variable    ${credit_card_number_group[0][1]}
    ${is_already_masked}    Run Keyword And Return Status    Should Contain    ${credit_card_number}    *
    ${masked_characters_excluding_last_four}    Run Keyword If    ${is_already_masked} == False    Evaluate    "".join([s.replace(s, "X") for s in str(${credit_card_number[2:-4]})])
    ${masked_credit_card_number}    Run Keyword If    ${is_already_masked} == False    Replace String    ${credit_card_number}    ${credit_card_number[2:-4]}    ${masked_characters_excluding_last_four}
    ...    ELSE    Set Variable    ${credit_card_number}
    [Return]    ${masked_credit_card_number}    ${credit_card_expiry_date}

Get CC Vendor From Credit Card
    [Arguments]    ${credit_card}
    ${credit_card_number_group}    Get Regexp Matches    ${credit_card}    (\\D{2}\\*+\\d{4}|\\D{2}\\d+)\/D(\\d{4})    1
    ${cc_match}    Set Variable    ${credit_card_number_group[0]}
    ${cc_vendor}    Get Substring    ${cc_match}    0    2
    ${cc_vendor}    Set Variable If    "${cc_vendor}" == "VI" or "${cc_vendor}" == "CA" or "${cc_vendor}" == "MC" or "${cc_vendor}" == "JC"    CX4    "${cc_vendor}" == "AX"    CX2    "${cc_vendor}" == "TP"
    ...    CX5    "${cc_vendor}" == "DC"    CX3    ${cc_vendor}
    [Return]    ${cc_vendor}

Select Form Of Payment Value On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop_value}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    Select Value From Dropdown List    ${fop_field}    ${fop_value}
    Comment    @{fare_tab_split}    Split String    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Get Tab Number    ${fare_tab}
    Set Suite Variable    ${fop_${fare_tab_index}}    ${fop_value}
    Set Suite Variable    ${merchant_${fare_tab_index}}    ${EMPTY}

Get Form Of Payment Value On Fare Quote Tab
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Set Variable If    "${fare_type}" == "Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${fop_value}    Get Control Text Value    ${fop_field}
    Set Suite Variable    ${fop_value_${fare_tab_index}}    ${fop_value}
    [Return]    ${fop_value}

Populate Fare Restrictions To Default Value
    Click Restriction Tab
    ${is_template_selected}    Get Radio Button State    Template
    ${is_default_selected}    Get Radio Button State    Default
    ${is_visible_no_restriction}    Determine Control Object Is Visible On Active Tab    cradNone_alt, cradNone
    ${is_no_restrictions_selected}    Run Keyword If    ${is_visible_no_restriction} == True    Get Radio Button State    No Restrictions
    ...    ELSE    Set Variable    False
    Control Focus    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}
    Run Keyword If    ${is_default_selected} == False and ${is_template_selected} == False and ${is_no_restrictions_selected} == False    Select Radio Button Value    Default
    ...    ELSE    Log    Restrictions Are selected
    [Teardown]    Select Tab Control    Air Fare    FareDetailsAndFeesTab

Populate Alternate Fare Quote Tabs With Default Values
    Select Tab Control    Air Fare    FareDetailsAndFeesTab
    ${merchant_field}    Determine Multiple Object Name Based On Active Tab    cbMerchant
    ${is_merchant_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${merchant_field}
    Run Keyword If    ${is_merchant_mandatory} == True    Select Merchant On Fare Quote Tab    Airline
    ${fop_field}    Determine Multiple Object Name Based On Active Tab    cbFormOfPayment
    ${is_fop_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${fop_field}
    Run Keyword If    ${is_fop_mandatory} == True    Select Cash As Form Of Payment In Fare Quote Tab
    ${commission_rebate_percentage}    Determine Multiple Object Name Based On Active Tab    ctxtCommissionPercent_alt
    ${is_commission_rebate_percentage_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${commission_rebate_percentage}
    Run Keyword If    ${is_commission_rebate_percentage_mandatory} == True    Set Commission Rebate Percentage    10
    ${airline_commission_percentage}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineCommissionPercent_alt
    ${is_airline_commission_percentage_mandatory}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${airline_commission_percentage}
    Run Keyword If    ${is_airline_commission_percentage_mandatory} == True    Set Airline Commission Percentage    10
    ${transaction_fee}    Determine Multiple Object Name Based On Active Tab    cbTransactionFee_alt
    ${is_transaction_fee_present}    Run Keyword And Return Status    Verify Control Object Field Is Mandatory    ${transaction_fee}
    Run Keyword If    ${is_transaction_fee_present} == True    Set Transaction Fee    0
    Populate Fare Restrictions To Default Value

Get Tab Number
    [Arguments]    ${tab_name}
    [Documentation]    Use this when tabs are incremental
    ${tab_number}    Set Variable    0
    ${tab_index}    Set Variable    0
    @{tab_items}    Get Tab Items    TabControl1
    ${tab_index}    Get Index From List    ${tab_items}    ${tab_name}
    ${tab_number}    Evaluate    ${tab_index} + 1
    [Return]    ${tab_number}

Set Airline Commission Percentage
    [Arguments]    ${airline_commission_percentage}
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineCommissionPercent, ctxtAirlineCommissionPercent_alt
    Set Control Text Value    ${object_name}    ${airline_commission_percentage}
    Send    {TAB}

Select Default Restricions in Fare Tab
    [Arguments]    ${fare_tab}
    Click Fare Tab    ${fare_tab}
    Click Restriction Tab
    Select Radio Button Value    Default

Add Customized Templates In Fare Quote Restriction Panel
    [Arguments]    ${fare_tab}    @{customized_rerstrictions}
    ${air_fare_restriction_dropdown}    Determine Multiple Object Name Based On Active Tab    AirRestrictionItems
    ${add_button}    Determine Multiple Object Name Based On Active Tab    AirRestrictionAdd
    Wait Until Mouse Cursor Wait Is Completed
    Wait Until Control Object Is Ready    ${air_fare_restriction_dropdown}
    Set Control Text Value    ${air_fare_restriction_dropdown}    ${EMPTY}
    : FOR    ${customized_restriction}    IN    @{customized_rerstrictions}
    \    Send Control Text Value    ${air_fare_restriction_dropdown}    ${customized_restriction}
    \    Click Control Button    ${add_button}

Delete Air Fare Restrictions In Fare Quote Restriction Panel
    [Arguments]    ${fare_tab}    @{rerstrictions_tobe_deleted}
    ${tab_number}    Get Tab Number    ${fare_tab}
    Wait Until Control Object Is Enabled    [NAME:AirRestrictionRemarks_${tab_number}]
    ${actual_restriction}    Get All Cell Values In Data Grid Pane    [NAME:AirRestrictionRemarks_${tab_number}]
    : FOR    ${restriction}    IN    @{rerstrictions_tobe_deleted}
    \    ${value_present}    Run Keyword And Return Status    Should Contain    ${actual_restriction}    ${restriction}
    \    Run Keyword If    ${value_present} == True    Delete Itinerary Remarks In Air Restrictions    [NAME:AirRestrictionRemarks_${tab_number}]    ${restriction}

Select Air Fare Restrictions In Fare Quote
    [Arguments]    ${fare_tab}    @{restrictions}
    ${air_fare_restriction_dropdown}    Determine Multiple Object Name Based On Active Tab    AirRestrictionItems
    ${add_button}    Determine Multiple Object Name Based On Active Tab    AirRestrictionAdd
    Wait Until Mouse Cursor Wait Is Completed
    Wait Until Control Object Is Ready    ${air_fare_restriction_dropdown}
    : FOR    ${restriction}    IN    @{restrictions}
    \    Select Value From Dropdown List    ${air_fare_restriction_dropdown}    ${restriction}
    \    Click Control Button    ${add_button}

Select Air Fare Restrictions Radio Button
    [Arguments]    ${fare_tab}    ${restriction_option}=Template
    Click Fare Tab    ${fare_tab}
    Click Restriction Tab
    ${fare_tab}    Remove All Non Numeric    ${fare_tab}
    Comment    ${tab_number}    Get Tab Number    ${fare_tab}
    Comment    ${alternate_tab}    Run Keyword And Return Status    Should Contain    ${fare_tab}    Alt
    Comment    ${template_radio}    Run Keyword If    ${alternate_tab} == True    Set Variable    [NAME:cradTemplate_alt_${tab_number}]
    ...    ELSE    Set Variable    [NAME:cradTemplate_${tab_number}]
    ${template_radio}    Determine Multiple Object Name Based On Active Tab    cradTemplate_alt, cradTemplate
    ${no_restriction_radio}    Determine Multiple Object Name Based On Active Tab    cradNone_alt, cradNone
    ${is_selected}    Get Radio Button Status    ${template_radio}
    ${is_selected_default}    Get Radio Button Status    [NAME:cradDefault_]
    ${is_selected_no_restriction}    Get Radio Button Status    ${no_restriction_radio}
    Comment    Run Keyword If    ${is_selected} == True and '${restriction_option}' == 'Template'    Log    "Template option Air Fare Restrictions selected"
    ...    ELSE    Select Radio Button Value    Template
    Run Keyword If    ${is_selected} == False and '${restriction_option}' == 'Template'    Select Radio Button Value    Template
    ...    ELSE IF    ${is_selected_default} == False and '${restriction_option}' == 'Default'    Select Radio Button Value    Default
    ...    ELSE IF    ${is_selected_no_restriction} == False and '${restriction_option}' == 'No Restrictions'    Select Radio Button Value    No Restrictions
    ...    ELSE    Log    "${restriction_option} option for Air Fare Restrictions is selected"

Click Restriction Tab
    Select Tab Control    Restrictions

Set Credit Card Using Near Expiration Date
    [Arguments]    ${fare_tab}
    ${date}    DateTime.Get Current Date    UTC    result_format=datetime
    ${month}    Evaluate    "{:02d}".format(${date.month})
    ${year}    Evaluate    str(${date.year})[2:]
    Set Test Variable    ${near_expiration_year}    ${month}${year}
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    ${fare_tab}    DC    3644031458720369    ${near_expiration_year}

Populate Air Fare Savings Code Using Default Values (If Blank)
    Activate Power Express Window
    ${realised_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboRealised
    ${missed_saving_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboMissed
    ${class_code_dropdown}    Determine Multiple Object Name Based On Active Tab    ccboClass
    ${is_realised_savings_visible}    Control Command    ${title_power_express}    ${EMPTY}    ${realised_saving_code_dropdown}    IsVisible    ${EMPTY}
    ${is_missed_savings_visible}    Control Command    ${title_power_express}    ${EMPTY}    ${missed_saving_code_dropdown}    IsVisible    ${EMPTY}
    ${is_class_code_visible}    Control Command    ${title_power_express}    ${EMPTY}    ${class_code_dropdown}    IsVisible    ${EMPTY}
    ${is_realised_savings_mandatory}    Run Keyword If    ${is_realised_savings_visible} == 1    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${realised_saving_code_dropdown}
    ...    ELSE    Set Variable    ${False}
    ${is_missed_savings_mandatory}    Run Keyword If    ${is_missed_savings_visible} == 1    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${missed_saving_code_dropdown}
    ...    ELSE    Set Variable    ${False}
    ${is_class_code_mandatory}    Run Keyword If    ${is_class_code_visible} == 1    Run Keyword And Return Status    Verify Control Object Value Is Empty    ${class_code_dropdown}
    ...    ELSE    Set Variable    ${False}
    Run Keyword If    ${is_realised_savings_mandatory}    Select Value From Dropdown List    ${realised_saving_code_dropdown}    0    by_index=True
    Run Keyword If    ${is_missed_savings_mandatory}    Select Value From Dropdown List    ${missed_saving_code_dropdown}    0    by_index=True
    Run Keyword If    ${is_class_code_mandatory}    Select Value From Dropdown List    ${class_code_dropdown}    0    by_index=True
    Click Control Button    [NAME:cboNativeEntry]

Select Form Of Payment And Merchant On Fare Quote Tab
    [Arguments]    ${fare_tab}    ${fop}    ${merchant}
    Select Form Of Payment Value On Fare Quote Tab    ${fare_tab}    ${fop}
    Select FOP Merchant On Fare Quote Tab    ${fare_tab}    ${merchant}
    Comment    @{fare_tab_split}    Split String    ${fare_tab}    ${SPACE}
    Comment    Set Suite Variable    ${fop_${fare_tab_split[2]}}    ${fop}
    Comment    Set Suite Variable    ${merchant_${fare_tab_split[2]}}    ${merchant}
    ${fare_tab_index}    Get Tab Number    ${fare_tab}
    Set Suite Variable    ${fop_${fare_tab_index}}    ${fop}
    Set Suite Variable    ${merchant_${fare_tab_index}}    ${EMPTY}

Calculate Mark-Up Amount
    [Arguments]    ${fare_tab}=Fare Quote 1    ${mark_up_percentage}=1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${base_fare}    Set Variable If    "${fare_tab_type}"=="Fare"    ${base_fare_${fare_tab_index}}    ${base_fare_alt_${fare_tab_index}}
    ${fare_tab_index}    Set Variable If    "${fare_tab_type}"=="Fare"    ${fare_tab_index}    alt_${fare_tab_index}
    Comment    ${fare}    Set Variable If    "${nett_fare_value_${fare_tab_index}}"=="0"    ${base_fare}    ${nett_fare_value_${fare_tab_index}}
    ${fare}    Set Variable    ${base_fare}
    ${mark_up_percentage}    Convert To Float    ${mark_up_percentage}
    ${mark_up_amount}    Evaluate    ${fare}*(${mark_up_percentage}/100)
    Set Test Variable    ${mark_up_amount}
    [Return]    ${mark_up_amount}

Get Commission Rebate Amount
    [Arguments]    ${fare_tab}=Fare Quote 1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${commission_rebate_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtCommissionRebateAmount_${tab_number}]    "${fare_tab_type}"=="Alternate"    [NAME:ctxtCommissionRebateAmount_alt_${tab_number}]
    ${commission_rebate}    Get Control Text Value    ${commission_rebate_amount_obj}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${commission_rebate_amount_${fare_tab_index}}    ${commission_rebate}
    ...    ELSE    Set Test Variable    ${alt_commission_rebate_amount_${fare_tab_index}}    ${commission_rebate}

Populate Airline Commission Amount
    [Arguments]    ${fare_tab}=Fare Quote 1    ${airline_commission_amount}=1
    ${tab_number}    Get Tab Number    tab_name=${fare_tab}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${mark_up_amount_obj}    Set Variable If    "${fare_tab_type}"=="Fare"    [NAME:ctxtMarkUpAmount_${tab_number}]    "${fare_tab_type}"=="Alternate"    [NAME:ctxtMarkUpAmount_alt_${tab_number}]

Calculate Mark- Up Amount And Percentage
    [Arguments]    ${fare_tab}=Fare 1    ${segment_number}=2    ${country}=SG    ${gds_command}=TQT    ${mark_up_percentage}=1    ${round_type}=${EMPTY}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${fare_tab_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    fare_tab=${fare_tab}    segment_number=${segment_number}    gds_command=${gds_command}
    ...    ELSE    Get Base Fare From Amadeus Offer    fare_tab=${fare_tab}    gds_command=${gds_command}
    Get Nett Fare Value    fare_tab=${fare_tab}
    Calculate Mark-Up Amount    fare_tab=${fare_tab}    mark_up_percentage=${mark_up_percentage}
    ${mark_up_amount}    Round To Nearest Dollar    amount=${mark_up_amount}    country=${country}    round_type=${round_type}
    ${mark_up_percentage}    Convert To Float    ${mark_up_percentage}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${mark_up_percentage_${fare_tab_index}}    ${mark_up_percentage}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${mark_up_value_${fare_tab_index}}    ${mark_up_amount}
    ...    ELSE    Set Test Variable    ${mark_up_value_alt_${fare_tab_index}}    ${mark_up_amount}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${base_fare_${fare_tab_index}}
    ...    ELSE    Set Test Variable    ${base_fare_alt_${fare_tab_index}}
    Run Keyword If    "${fare_tab_type}"=="Fare"    Set Test Variable    ${nett_fare_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}
    ...    ELSE    Set Test Variable    ${nett_fare_alt_${fare_tab_index}}    ${nett_fare_value_${fare_tab_index}}

Get Airline Commisison Percentage Value
    [Arguments]    ${fare_tab}=Fare Quote 1
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${airline_comm_percentage}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineCommissionPercent,ctxtAirlineCommissionPercent_alt
    ${airline_comm_percentage}    Get Control Text Value    ${airline_comm_percentage}
    ${airline_comm_percentage}    Set Variable If    "${airline_comm_percentage}" == "${EMPTY}"    0    ${airline_comm_percentage}
    Set Suite Variable    ${airline_commission_percentage_${fare_tab_index}}    ${airline_comm_percentage}

Get MarkUP Percentage Value
    [Arguments]    ${fare_tab}
    ${fare_type}    Fetch From Left    ${fare_tab}    ${SPACE}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${is_fare_tab_alternate}    Run Keyword And Return Status    Should Contain    ${fare_tab.lower()}    alt
    ${fare_tab_index}    Set Variable If    ${is_fare_tab_alternate} == True    alt_${fare_tab_index}    ${fare_tab_index}
    ${is_visible}    Determine Control Object Is Visible On Active Tab    ctxtMarkUpPercent
    ${mark_up_amount_field}    Run Keyword If    "${is_visible}" == "True"    Determine Multiple Object Name Based On Active Tab    ctxtMarkUpPercent
    ${mark_up_percentage}    Run Keyword If    "${is_visible}" == "True"    Get Control Text Value    ${mark_up_amount_field}
    ...    ELSE    Set Variable    0
    Set Test Variable    ${mark_up_value_${fare_tab_index}}    ${mark_up_percentage}
    [Return]    ${mark_up_percentage}

Set Routing
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    cmtxtRouting_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}

Set Airline Code
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtAirlineOffer_alt
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}

Set Fare
    [Arguments]    ${str_valuetoset}    ${command}=SEND
    ${object_name}    Determine Multiple Object Name Based On Active Tab    ctxtTotalFareOffer
    Run Keyword If    "${command}" == "SEND"    Run Keywords    Click Control Button    ${object_name}    ${title_power_express}
    ...    AND    Send    {CTRLDOWN}A{CTRLUP}
    ...    AND    Sleep    1
    ...    AND    Send    {BACKSPACE}
    ...    AND    Send    ${str_valuetoset}
    ...    ELSE    Set Control Text Value    ${object_name}    ${str_valuetoset}    ${title_power_express}
    Send    {TAB}
