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
Verify Other Services MI Values Are Correct
    [Arguments]    ${identifier}    ${reference_fare}=5000    ${low_fare}=1000    ${class_service}=FD - First Class Discounted Fare    ${low_fare_carrier}=3K    ${booking_action}=Agent Booked
    ...    ${realise_saving_code}=CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED    ${missed_saving_code}=A - PARTIAL MISSED SAVING    ${declined_airline1}=AI    ${declined_fare1}=8000    ${declined_airline2}=9W    ${declined_fare2}=9000
    Get Client Mi Control Details    airbsp
    #Reference Fare
    Verify Actual Value Matches Expected Value    ${reference_fare${identifier}}    ${reference_fare}
    #Low Fare
    Verify Actual Value Matches Expected Value    ${low_fare_${identifier}}    ${low_fare}
    #Class of Service
    Verify Actual Value Matches Expected Value    ${class_service_full_${identifier}}    ${class_service}
    #Low Fare Carrier
    Verify Actual Value Matches Expected Value    ${low_fare_carrier_${identifier}}    ${low_fare_carrier}
    #Booking Action
    Verify Actual Value Matches Expected Value    ${booking_action_${identifier}}    ${booking_action}
    #Realised Saving Code
    Verify Actual Value Matches Expected Value    ${realise_saving_code_full_${identifier}}    ${realise_saving_code}
    #Missed Saving Code
    Verify Actual Value Matches Expected Value    ${missed_saving_code_full_${identifier}}    ${missed_saving_code}
    #Declined Airline 1
    Verify Actual Value Matches Expected Value    ${declined_airline_1_${identifier}}    ${declined_airline1}
    #Declined Fare 1
    Verify Actual Value Matches Expected Value    ${declined_fare_1_${identifier}}    ${declined_fare1}
    #Declined Airline 2
    Verify Actual Value Matches Expected Value    ${declined_airline_2_${identifier}}    ${declined_airline2}
    #Declined Fare 2
    Verify Actual Value Matches Expected Value    ${declined_fare_2_${identifier}}    ${declined_fare2}
    #Client MI Grid

Verify Reference Fare Value Is Correct
    [Arguments]    ${expected_ref_fare}
    [Documentation]    Reference Fare = Total Sell Fare + Total Taxes
    ${actual_ref_fare}    Get Control Text Value    [NAME:ReferenceFareTextbox]
    Verify Actual Value Matches Expected Value    ${expected_ref_fare}    ${actual_ref_fare}
