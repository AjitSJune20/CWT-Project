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
Verify Default Fare Type
    [Arguments]    ${expected_fare_type}
    Get Fare Type
    Verify Actual Value Matches Expected Value    ${fare_type}    ${expected_fare_type}

Verify Default Plating Carrier
    [Arguments]    ${expected_plating_carrier}
    Get Plating Carrier
    Verify Actual Value Matches Expected Value    ${plating_carrier}    ${expected_plating_carrier}

Verify Fare Type Values
    ${fare_type_list}    Get Dropdown Values    [NAME:FareTypeComboBox]
    @{expected_fare_type_list}    Create List    ${EMPTY}    P    S
    Run Keyword And Continue On Failure    Should Be Equal    ${fare_type_list}    ${expected_fare_type_list}

Verify Other Services Air Bsp Group Request Values Are Correct
    [Arguments]    ${identifier}    ${plating_carrier}=EY    ${fare_type}=P    ${pnr}=${current_pnr}    ${fare}=5000    ${taxes}=20
    ...    ${reason_for_issue}=LOST TICKET FEE (CHARGE FOR REPLACEMENT)    ${headline_currency}=INR \ \ \ Indian Rupee    ${equivalent_amount_paid}=8000    ${fop_type}=Cash    ${cc_type}=${EMPTY}    ${cc_number}=${EMPTY}
    ...    ${exp_date}=${EMPTY}    ${issue_in_exchange_for}=1111111111    ${in_conjunction_with}=2222222222    ${original_place_of_issue}=INDIA    ${remark}=Air BSP Request Remark
    Get Other Services Request Details For Air Bsp And Air Domestic    ${identifier}
    #Plating Carrier
    Verify Actual Value Matches Expected Value    ${plating_carrier_${identifier}}    ${plating_carrier}
    #Fare Type
    Verify Actual Value Matches Expected Value    ${fare_type_${identifier}}    ${fare_type}
    #PNR
    Verify Actual Value Matches Expected Value    ${pnr_in_request_tab_${identifier}}    ${pnr}
    #Fare
    Verify Actual Value Matches Expected Value    ${fare_${identifier}}    ${fare}
    #Taxes
    Verify Actual Value Matches Expected Value    ${taxes_${identifier}}    ${taxes}
    #Reason For Issue
    Verify Actual Value Matches Expected Value    ${reason_for_issue_${identifier}}    ${reason_for_issue}
    #Headline Currency
    Verify Actual Value Matches Expected Value    ${headline_currency_${identifier}}    ${headline_currency}
    #Equivalent Amt Paid
    Verify Actual Value Matches Expected Value    ${equivalent_amount_paid_${identifier}}    ${equivalent_amount_paid}
    #FOP
    Verify Actual Value Matches Expected Value    ${fop_type_${identifier}}    ${fop_type}
    #FOP Credit Details
    Run Keyword If    "${fop_type_${identifier}}"=="Credit"    Run Keywords    Verify Actual Value Matches Expected Value    ${cc_type_${identifier}}    ${cc_type}
    ...    AND    Verify Actual Value Matches Expected Value    ${cc_number_${identifier}}    ${cc_number}
    ...    AND    Verify Actual Value Matches Expected Value    ${exp_date_${identifier}}    ${exp_date}
    #Issue in Exchange For
    Verify Actual Value Matches Expected Value    ${issue_in_exchange_for_request_${identifier}}    ${issue_in_exchange_for}
    #In Conjunction With
    Verify Actual Value Matches Expected Value    ${in_conjunction_with_${identifier}}    ${in_conjunction_with}
    #Original Place of Issue
    Verify Actual Value Matches Expected Value    ${original_place_of_issue_${identifier}}    ${original_place_of_issue}
    #Remark
    Verify Actual Value Matches Expected Value    ${remark_${identifier}}    ${remark}

Verify Plating Carrier Values
    [Arguments]    @{expected_plating_carrier_list}
    ${plating_carrier_list}    Get Dropdown Values    [NAME:PlatingCarrierComboBox]
    Run Keyword And Continue On Failure    Should Be Equal    ${plating_carrier_list}    ${expected_plating_carrier_list}

Verify Other Services Air Conso-Dom Or Air Sales-Non Bsp Int Request Values Are Correct
    [Arguments]    ${identifier}    ${plating_carrier}=EY    ${fare_type}=P    ${tour_code}=789XYZ    ${threshold_amount}=8500
    #Plating Carrier
    Verify Actual Value Matches Expected Value    ${plating_carrier_${identifier}}    ${plating_carrier}
    #Fare Type
    Verify Actual Value Matches Expected Value    ${fare_type_${identifier}}    ${fare_type}
    #Tour Code
    Verify Actual Value Matches Expected Value    ${tour_code_${identifier}}    ${tour_code}
    #Threshold Amount
    Verify Actual Value Matches Expected Value    ${threshold_amount_${identifier}}    ${threshold_amount}
    Run Keyword If    "${product}"=="air conso-dom"    Verify Other Services Custom Field Values For Air Conso-Dom Are Correct    ${identifier}

Verify Other Services Custom Field Values For Air Conso-Dom Are Correct
    [Arguments]    ${identifier}    ${pos_remark_1}=Pos1    ${pos_remark_2}=Pos2    ${pos_remark_3}=Pos3    ${centralized_desk_1}=Centralized Desk 1    ${centralized_desk_2}=Centralized Desk 2
    ...    ${airlines}=Jet Airways    ${transaction_type}=New Issue    ${airlines_pnr}=AJSRQW    ${fare_break_up_1}=Fare Break Up 1    ${fare_break_up_2}=Fare Break Up 2    ${cancellation_penalty}=50USD
    ...    ${lcc_queue_back_remark}=Lcc Queue    ${gstin}=14    ${email_in_request}=email@cwt.com    ${entity_name}=CWT    ${phone_no}=98730596
    #PoS Remark 1
    Verify Actual Value Matches Expected Value    ${pos_remark_1_${identifier}}    ${pos_remark_1}
    #PoS Remark 2
    Verify Actual Value Matches Expected Value    ${pos_remark_2_${identifier}}    ${pos_remark_2}
    #PoS Remark 3
    Verify Actual Value Matches Expected Value    ${pos_remark_3_${identifier}}    ${pos_remark_3}
    #Centralized Desk 1
    Verify Actual Value Matches Expected Value    ${centralized_desk_1_${identifier}}    ${centralized_desk_1}
    #Centralized Desk 2
    Verify Actual Value Matches Expected Value    ${centralized_desk_2_${identifier}}    ${centralized_desk_2}
    #Airlines
    Verify Actual Value Matches Expected Value    ${airlines_${identifier}}    ${airlines}
    #Transaction Type
    Verify Actual Value Matches Expected Value    ${transaction_type_${identifier}}    ${transaction_type}
    #Airlines PNR
    Verify Actual Value Matches Expected Value    ${airlines_pnr_${identifier}}    ${airlines_pnr}
    #Fare Break Up 1
    Verify Actual Value Matches Expected Value    ${fare_break_up_1_${identifier}}    ${fare_break_up_1}
    #Fare Break Up 2
    Verify Actual Value Matches Expected Value    ${fare_break_up_2_${identifier}}    ${fare_break_up_2}
    #Cancellation Penalty
    Verify Actual Value Matches Expected Value    ${cancellation_penalty_${identifier}}    ${cancellation_penalty}
    #LCC Queue Back Remark
    Verify Actual Value Matches Expected Value    ${lcc_queue_back_remark_${identifier}}    ${lcc_queue_back_remark}
    #GSTIN
    Verify Actual Value Matches Expected Value    ${gstin_${identifier}}    ${gstin}
    #Email
    Verify Actual Value Matches Expected Value    ${email_in_request_${identifier}}    ${email_in_request}
    #Entity Name
    Verify Actual Value Matches Expected Value    ${entity_name_${identifier}}    ${entity_name}
    #Phone No
    Verify Actual Value Matches Expected Value    ${phone_no_${identifier}}    ${phone_no}

Verify Other Services Insurance Request Values Are Correct
    [Arguments]    ${identifier}    ${details_1}    ${details_2}    ${details_3}    ${internal_remarks}    ${employee_number}
    ...    ${employee_name}    ${passport_number}    ${assignee_name}    ${gender}    ${dateofbirth}    ${address_of_house}
    ...    ${street_name}    ${area}    ${sub_area}    ${pin_code}    ${state}    ${country_other_services}
    ...    ${mobile_number}    ${marital_status}    ${departure_date_insurance}    ${arrival_date}
    Log List    ${request_collection${identifier.lower()}}
    ${new_insurance_list}    Create List    ${details_1}    ${details_2}    ${details_3}    ${internal_remarks}    ${employee_number}
    ...    ${employee_name}    ${area}    ${passport_number}    ${assignee_name}    ${gender}    ${dateofbirth}
    ...    ${address_of_house}    ${street_name}    ${sub_area}    ${pin_code}    ${state}    ${country_other_services}
    ...    ${mobile_number}    ${marital_status}    ${departure_date_insurance}    ${arrival_date}
    Lists Should Be Equal    ${request_collection${identifier.lower()}}    ${new_insurance_list}

Verify Other Services Train Group Request Values Are Correct
    [Arguments]    ${product_name}    ${identifier}    ${train_origin}    ${train_dest}    ${train_no}    ${train_name}
    ...    ${train_class}
    Log List    ${train_request_tab_${identifier.lower()}}
    @{train_request_tab}    Set Variable    ${train_request_tab_${identifier.lower()}}
    Verify Actual Value Matches Expected Value    ${train_request_tab[2]}    ${train_origin}
    Verify Actual Value Matches Expected Value    ${train_request_tab[3]}    ${train_dest}
    Verify Actual Value Matches Expected Value    ${train_request_tab[4]}    ${train_no}
    Verify Actual Value Matches Expected Value    ${train_request_tab[5]}    ${train_name}
    Verify Actual Value Matches Expected Value    ${train_request_tab[6]}    ${train_class}
    Run Keyword If    "${product_name}"=="train- dom" or "${product_name}"=="transaction charges"    Get Values From Custom Fields Grid    [NAME:CustomFieldGrid]    amend_${identifier}
    Run Keyword If    "${product_name}"=="train- dom" or "${product_name}"=="transaction charges"    Lists Should Be Equal    ${custom_field_values${identifier}}    ${custom_field_valuesamend_${identifier}}

Verify Passenger Names Are Correct
    [Arguments]    @{passenger_names}
    Get Passenger Names
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${passenger_names}    ${passenger_list}
