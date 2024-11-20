*** Settings ***
Resource          ../../resources/common/global_resources.robot
Resource          ../gds/gds_verification.robot
Resource          other_services_associated_charges_control.robot

*** Keywords ***
Populate Other Services Air Segment Control Details
    Tick Select All Segments
    [Teardown]    Take Screenshot

Populate Other Services Custom Fields Group
    Run Keyword If    "${product.lower()}" == "train- dom"    Populate Other Services Custom Fields Control    ticket_type=ETICKET    id_type=LICENSE    id_issuing_auth=CWT INDIA    id_no=123
    ...    no_of_passengers=2    travel_within_24_hrs=YES    age=16    gender=F    travel_desk_email_id=automation@test.com
    Run Keyword If    "${product.lower()}" == "transaction charges"    Populate Other Services Custom Fields Control    id_type=LICENSE    id_no=123    id_issuing_auth=CWT INDIA    no_of_passengers=2
    ...    id_belong_to_passenger=YES    ticket_type=ETICKET    travel_within_24_hrs=YES
    [Teardown]

Populate Other Services Insurance Control Details
    [Arguments]    ${details_1}    ${details_2}=${EMPTY}    ${details_3}=${EMPTY}    ${internal_remarks}=${EMPTY}    ${employee_number}=20090    ${employee_name}=Baner
    ...    ${passport_number}=K21121    ${assignee_name}=Stark    ${gender}=M    ${dateofbirth}=12-Jun-1992    ${address_of_house}=Address 1    ${street_name}=Street1
    ...    ${area}=Area15    ${sub_area}=91    ${pin_code}=560029    ${state}=GOA    ${country}=India    ${mobile_number}=985645212
    ...    ${marital_status}=Single    ${departure_date_insurance}=15-Jun-2020    ${arrival_date}=17-Jun-2020
    [Documentation]    ${details_1} | ${details_2}=${EMPTY} | ${details_3}=${EMPTY} | ${internal_remarks}=${EMPTY} | ${employee_number}=20090 | ${employee_name}=Baner | ${passport_number}=K21121 | ${assignee_name}=Stark | ${gender}=M | ${dateofbirth}=12-Jun-1992 | ${address_of_house}=Address 1 | ${street_name}=Street1 | ${area}=Area15 | ${sub_area}=91 | ${pin_code}=560029 | ${state}=GOA | ${country}=India | ${mobile_number}=985645212 | ${marital_status}=Single | ${departure_date_insurance}=15-Jun-2020 | ${arrival_date}=17-Jun-2020
    Populate Other Services Request Info    ${details_1}    ${details_2}    ${details_3}    ${internal_remarks}
    Populate Other Services Insurance Custom Fields Control Details    ${employee_number}    ${employee_name}    ${passport_number}    ${assignee_name}    ${gender}    ${dateofbirth}
    ...    ${address_of_house}    ${street_name}    ${area}    ${sub_area}    ${pin_code}    ${state}
    ...    ${country}    ${mobile_number}    ${marital_status}    ${departure_date_insurance}    ${arrival_date}
    [Teardown]    Take Screenshot

Populate Other Services Insurance Custom Fields Control Details
    [Arguments]    ${employee_number}=20090    ${employee_name}=Baner    ${passport_number}=K21121    ${assignee_name}=Stark    ${gender}=M    ${dateofbirth}=12-Jun-1992
    ...    ${address_of_house}=Address 1    ${street_name}=Street1    ${area}=Area15    ${sub_area}=91    ${pin_code}=560029    ${state}=GOA
    ...    ${country}=India    ${mobile_number}=985645212    ${marital_status}=Single    ${departure_date_insurance}=15-Jun-2020    ${arrival_date}=17-Jun-2020
    [Documentation]    ${employee_number}=20090 | ${employee_name}=Baner | ${passport_number}=K21121 | ${assignee_name}=Stark | ${gender}=M | ${dateofbirth}=12-Jun-1992 | ${address_of_house}=Address 1 | ${street_name}=Street1 | ${area}=Area15 | ${sub_area}=91 | ${pin_code}=560029 | ${state}=GOA | ${country}=India | ${mobile_number}=985645212 | ${marital_status}=Single | ${departure_date_insurance}=15-Jun-2020 | ${arrival_date}=17-Jun-2020
    Set Employee Number    ${employee_number}
    Set Employee Name    ${employee_name}
    Set Passport Number    ${passport_number}
    Set Assignee Name    ${assignee_name}
    Set Gender    ${gender}
    Set Date Of Birth Insurance    ${dateofbirth}
    Set Address Of House    ${address_of_house}
    Set Street Name    ${street_name}
    Set Area    ${area}
    Set Sub Area    ${sub_area}
    Set Pin Code    ${pin_code}
    Set State    ${state}
    Set Country    ${country}
    Set Mobile Number When Product Is Insurance    ${mobile_number}
    Set Marital Status    ${marital_status}
    Set Departure Date    ${departure_date_insurance}
    Set Arrival Date    ${arrival_date}

Populate Other Services Meet And Greet Control Details
    [Arguments]    ${city}    ${location}    ${internal_remarks}=${EMPTY}    ${date}=${EMPTY}    ${time}=${EMPTY}
    Set City    ${city}
    Set Locations    ${location}
    Set Internal Remarks    ${internal_remarks}
    #Date
    #Time

Populate Other Services Request Info
    [Arguments]    ${details_1}    ${details_2}=${EMPTY}    ${details_3}=${EMPTY}    ${internal_remarks}=${EMPTY}
    Set Details    ${details_1}
    Set Details    ${details_2}    2
    Set Details    ${details_3}    3
    Set Internal Remarks    ${internal_remarks}

Populate Other Services Train Control Details
    [Arguments]    ${origin}    ${destination}    ${train_number}    ${name}    ${class/cabin}
    Click Add
    Set Origin    ${origin}
    Set Destination    ${destination}
    Set Train Number    ${train_number}
    Set Name    ${name}
    Set Class/Cabin    ${class/cabin}
    Click Save
    [Teardown]    Take Screenshot

Populate Request Fields When Product Is Meet And Greet
    [Arguments]    ${city}    ${location}    ${date}=${EMPTY}    ${time}=${EMPTY}
    #Set Date
    #Set Time
    Set City    ${city}
    Set Locations    ${location}
    [Teardown]    Take Screenshot

Populate Other Services Tour Information Control
    [Arguments]    ${city}    ${package_name}    ${details}=${EMPTY}    ${internal_remarks}=${EMPTY}
    Set City    ${city}
    Set Package Name    ${package_name}
    Set Details    ${details}
    Set Internal Remarks    ${internal_remarks}
    [Teardown]    Take Screenshot

Populate Other Services Visa Standard Control
    [Arguments]    ${country}    ${document}=${EMPTY}    ${doc_type}=${EMPTY}    ${date_of_application}=${EMPTY}    ${internal_remarks}=${EMPTY}    ${validity}=${EMPTY}
    ...    ${processing}=${EMPTY}
    Run Keyword If    "${document}" != "${EMPTY}"    Select Document    ${document}
    Select Country    ${country}
    Set Internal Remarks    ${internal_remarks}
    Set Validity    ${validity}
    Run Keyword If    "${processing}" != "${EMPTY}"    Select Processing Type    ${processing}
    [Teardown]    Take Screenshot

Populate Other Services Visa Custom Control
    [Arguments]    ${demand_draft_required}    ${demand_draft_number}    ${validity}
    Select Demand Draft Required    ${demand_draft_required}
    Set Demand Draft Number    ${demand_draft_number}
    Set Validity Custom Field    ${validity}
    [Teardown]    Take Screenshot

Populate Request Fields When Product Is Visa Group
    Populate Other Services Visa Standard Control    country=Philippines    internal_remarks=Internal Remarks
    Run Keyword If    "${product}"=="visa handling fee"    Populate Other Services Visa Custom Control    Yes    143143    Forever

Get Request Fields When Product Is Visa Group
    [Arguments]    ${identifier}
    Get Other Services Visa Standard Control    ${identifier}

Get Other Services Visa Standard Control
    [Arguments]    ${identifier}
    #Document
    ${document}    Get Control Text Value    [NAME:DocumentComboBox]
    #Country
    ${country}    Get Control Text Value    [NAME:CountryComboBox]
    #Doc Type
    ${doc_type}    Get Control Text Value    [NAME:DocTypeComboBox]
    #Date of Application
    ${date_of_application}    Get Control Text Value    [NAME:DateOfApplicationTextBox]
    #Internal Remarks
    ${internal_remarks}    Get Control Text Value    [NAME:InternalRemarksTextBox]
    #Entries
    ${entries}    Get Control Text Value    [NAME:EntriesComboBox]
    #Validity
    ${validity}    Get Control Text Value    [NAME:ValidityTextBox1]
    #Validity Days
    ${validity_days}    Get Control Text Value    [NAME:ValidityComboBox]
    #Processing
    ${processing}    Get Control Text Value    [NAME:ProcessingTypeComboBox]
    Set Suite Variable    ${document_${identifier}}    ${document}
    Set Suite Variable    ${country_${identifier}}    ${country}
    Set Suite Variable    ${doc_type_${identifier}}    ${doc_type}
    Set Suite Variable    ${date_of_application_${identifier}}    ${date_of_application}
    Set Suite Variable    ${internal_remarks_${identifier}}    ${internal_remarks}
    Set Suite Variable    ${entries_${identifier}}    ${entries}
    Set Suite Variable    ${validity_${identifier}}    ${validity}
    Set Suite Variable    ${validity_days_${identifier}}    ${validity_days}
    Set Suite Variable    ${processing_${identifier}}    ${processing}
    ${date_of_application}    Convert Date To GDS Format    ${date_of_application}    %d/%b/%Y
    Set Suite Variable    ${date_of_application_gds_format_${identifier}}    ${date_of_application}

Get Other Services Request Info
    [Arguments]    ${identifier}
    #Detail 1
    ${detail_1}    Get Control Text Value    [NAME:Details1TextBox]
    #Detail 2
    ${detail_2}    Get Control Text Value    [NAME:Details2TextBox]
    #Detail 3
    ${detail_3}    Get Control Text Value    [NAME:Details3TextBox]
    Set Suite Variable    ${detail_1_${identifier}}    ${detail_1}
    Set Suite Variable    ${detail_2_${identifier}}    ${detail_2}
    Set Suite Variable    ${detail_3_${identifier}}    ${detail_3}

Get Other Services Meet And Greet Control Details
    [Arguments]    ${identifier}
    #Date
    ${date}    Get Control Text Value    [NAME:DateDatePicker]
    #Time
    ${time}    Get Control Text Value    [NAME:TimePickerControl]
    #City
    ${city}    Get Control Text Value    [NAME:CityComboBox]
    #Locations
    ${locations}    Get Control Text Value    [NAME:LocationsTextBox]
    #Internal Remarks
    ${internal_remarks}    Get Control Text Value    [NAME:InternalRemarksTextBox]
    Set Suite Variable    ${date_${identifier}}    ${date}
    Set Suite Variable    ${time_${identifier}}    ${time}
    Set Suite Variable    ${city_${identifier}}    ${city}
    Set Suite Variable    ${locations_${identifier}}    ${locations}
    Set Suite Variable    ${internal_remarks_${identifier}}    ${internal_remarks}

Set City
    [Arguments]    ${city}
    Set Control Text Value    [NAME:CityComboBox]    ${city}
    [Teardown]    Take Screenshot

Set Class/Cabin
    [Arguments]    ${class_cabin}
    Set Control Text Value    [NAME:ClassCabinTextBox]    ${class_cabin}
    [Teardown]    Take Screenshot

Set Destination
    [Arguments]    ${destination}
    Set Control Text Value    [NAME:DestinationTextBox]    ${destination}
    [Teardown]    Take Screenshot

Set Details
    [Arguments]    ${details}    ${index}=1
    ${object}    Determine Multiple Object Name Based On Active Tab    Details${index}TextBox,DetailsTextBox    False
    Wait Until Control Object Is Visible    ${object}
    Set Control Text Value    ${object}    ${details}
    Send    {TAB}
    [Teardown]    Take Screenshot

Set Fee
    [Arguments]    ${fee}
    Wait Until Control Object Is Visible    [NAME:Charges_FeeTextBox]
    Set Control Text Value    [NAME:Charges_FeeTextBox]    ${fee}
    Send    {TAB}

Set IATA Com Percentage
    [Arguments]    ${iata_com_percentage}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_IataComTextBox    False
    Set Control Text Value    ${object}    ${iata_com_percentage}

Set Internal Remarks
    [Arguments]    ${internal_remarks}
    ${object}    Determine Multiple Object Name Based On Active Tab    Request_InternalRemarksTextBox,InternalRemarksTextBox    False
    Set Control Text Value    ${object}    ${internal_remarks}
    [Teardown]    Take Screenshot

Set Locations
    [Arguments]    ${location}
    Set Control Text Value    [NAME:LocationsTextBox]    ${location}
    [Teardown]    Take Screenshot

Set Merchant Fee %
    [Arguments]    ${merchant_fee_percentage}
    Wait Until Control Object Is Visible    [NAME:Charges_MerchantFee1TextBox]
    Set Control Text Value    [NAME:Charges_MerchantFee1TextBox]    ${merchant_fee_percentage}

Set Name
    [Arguments]    ${name}
    Set Control Text Value    [NAME:TrainNameTextBox]    ${name}
    [Teardown]    Take Screenshot

Set Origin
    [Arguments]    ${origin}
    Set Control Text Value    [NAME:OriginTextBox]    ${origin}
    [Teardown]    Take Screenshot

Set Oth Tax Code
    [Arguments]    ${oth_tax_code}    ${index}=1
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OthTaxCode${index}TextBox    False
    Set Control Text Value    ${object}    ${oth_tax_code}

Set Oth Taxes
    [Arguments]    ${oth_taxes}    ${index}=1
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_OthTax${index}TextBox    False
    Set Control Text Value    ${object}    ${oth_taxes}

Set Train Number
    [Arguments]    ${train_number}
    Set Control Text Value    [NAME:TrainNumberTextBox]    ${train_number}
    [Teardown]    Take Screenshot

Set YQ Tax
    [Arguments]    ${yq_tax}
    ${object}    Determine Multiple Object Name Based On Active Tab    Charges_YqTaxTextBox    False
    Set Control Text Value    ${object}    ${yq_tax}

Tick Override Status
    ${overirde_status}    Determine Multiple Object Name Based On Active Tab    Charges_OverrideFeeCheckBox    False
    Tick Checkbox    ${overirde_status}

Populate Air Segments VMPD Details
    [Arguments]    ${reason_for_issue}    ${fare}    ${headline_currency}    ${taxes}    ${eqivalent_amt_paid}    ${fop}
    ...    ${cc_type}    ${cc_number}    ${exp_month}    ${exp_year}    ${issue_in_exchange_for}=${EMPTY}    ${in_conjunction_with}=${EMPTY}
    ...    ${original_place_of_issue}=${EMPTY}    ${remark}=${EMPTY}
    Tick Request VMPD
    Select Reason For Issue    ${reason_for_issue}
    Set Request VMPD Fare    ${fare}
    Select Headline Currency    ${headline_currency}
    Set Taxes    ${taxes}
    Select Equivalent Amount Paid    ${eqivalent_amt_paid}
    Select FOP    ${fop}    ${cc_type}    ${cc_number}    ${exp_month}    ${exp_year}
    Set Issue In Exchange For    ${issue_in_exchange_for}
    Set In Conjunction With    ${in_conjunction_with}
    Set Original Place Of Issue    ${original_place_of_issue}
    Set Remark    ${remark}

Set Request VMPD Fare
    [Arguments]    ${fare}
    Set Control Text Value    [NAME:FareTextbox]    ${fare}

Set Taxes
    [Arguments]    ${taxes}
    Set Control Text Value    [NAME:TaxesTextbox]    ${taxes}

Select Equivalent Amount Paid
    [Arguments]    ${eqivalent_amt_paid}
    Set Control Text Value    [NAME:EquivalentAmountPaidTextbox]    ${eqivalent_amt_paid}

Select FOP
    [Arguments]    ${fop}    ${cc_type}    ${cc_number}    ${exp_month}    ${exp_year}
    Select Value From Dropdown List    [NAME:FormOfPaymentCombobox]    ${fop}
    Set Suite Variable    ${fop}    ${fop}
    Run Keyword If    "${fop.lower()}"=="credit"    Populate FOP Fields    ${cc_type}    ${cc_number}    ${exp_month}    ${exp_year}

Set Issue In Exchange For
    [Arguments]    ${issue_in_exchange_for}
    ${object}    Determine Multiple Object Name Based On Active Tab    IssueInExchangeForTextbox,Charges_IssueInExchangeForTextBox    False
    Set Control Text Value    ${object}    ${issue_in_exchange_for}

Set In Conjunction With
    [Arguments]    ${in_conjunction_with}
    Set Control Text Value    [NAME:InConjunctionWithTextbox]    ${in_conjunction_with}

Set Original Place Of Issue
    [Arguments]    ${original_place_of_issue}
    Set Control Text Value    [NAME:OriginalPlaceOfIssueTextbox]    ${original_place_of_issue}

Set Remark
    [Arguments]    ${remark}
    Set Control Text Value    [NAME:RemarkTextbox]    ${remark}

Select Reason For Issue
    [Arguments]    ${reason_for_issue}
    Select Value From Dropdown List    [NAME:ReasonForIssueComboBox]    ${reason_for_issue}

Set Package Name
    [Arguments]    ${package_name}
    Set Control Text Value    [NAME:PackageNameTextBox]    ${package_name}

Select Country
    [Arguments]    ${country}
    Select Value From Dropdown List    [NAME:CountryComboBox]    ${country}

Get Request Field Values When Product Is Train Group
    [Arguments]    ${product}    ${identifier}
    ${custom_field_values}=    Create List    ${EMPTY}
    Get Train Trip Grid Data    ${identifier}
    Get Internal Remarks
    Run Keyword If    "${product.lower()}" == "train- dom" or "${product.lower()}"=="transaction charges"    Get Values From Custom Fields Grid    [NAME:CustomFieldGrid]    ${identifier}
    Run Keyword If    "${product.lower()}" == "train"    Set Test Variable    ${custom_field_values${identifier}}    ${EMPTY}
    ${train_request_tab} =    Combine Lists    ${internal_remarks}    ${request_final_list${identifier.lower()}}    ${custom_field_values${identifier}}
    Set Suite Variable    ${train_request_tab_${identifier.lower()}}    ${train_request_tab}
    Log List    ${train_request_tab_${identifier.lower()}}
    Run Keyword And Continue On Failure    Get Earliest Date From The Grid In Request Tab    #    Required for selecting journey start date in passive segment

Get Train Trip Grid Data
    [Arguments]    ${identifier}
    ${request_data}    Get All Cell Values In Data Grid Table    [NAME:TrainTripsGrid]
    Log List    ${request_data}
    ${request_collection}    Create List
    : FOR    ${row_data}    IN    @{request_data}
    \    ${row_data}    Split String    ${row_data}    ;
    \    Append To List    ${request_collection}    ${row_data[1:]}
    Set Suite Variable    ${request_final_list${identifier.lower()}}    ${request_collection[1]}
    Comment    Set Suite Variable    ${train_date_${identifier}}    ${request_collection[0]}
    Comment    Set Suite Variable    ${train_time_${identifier}}    ${request_collection[1]}
    Comment    Set Suite Variable    ${train_origin_${identifier}}    ${request_collection[2]}
    Comment    Set Suite Variable    ${train_dest_${identifier}}    ${request_collection[3]}
    Comment    Set Suite Variable    ${train_no_${identifier}}    ${request_collection[4]}
    Comment    Set Suite Variable    ${train_name_${identifier}}    ${request_collection[5]}
    Comment    Set Suite Variable    ${train_class_${identifier}}    ${request_collection[6]}

Get Values From Custom Fields Grid
    [Arguments]    ${control_id}    ${identifier}
    ${grid_list} =    Get All Cell Values In Data Grid Table    ${control_id}
    : FOR    ${item}    IN    @{grid_list}
    \    ${matches}=    Get Matches    ${item}    *;*
    \    ${count}=    Get Index From List    ${grid_list}    ${item}
    \    Log    ${matches}
    \    Exit For Loop If    "${matches}"!="[]"
    ${custom_field_values}    Create List
    : FOR    ${item}    IN    @{grid_list[${count}:]}
    \    ${item_val}    Split String    ${item}    ;
    \    ${item_val}    Evaluate    str("${item_val[1]}")
    \    Append To List    ${custom_field_values}    ${item_val}
    Set Suite Variable    ${custom_field_values${identifier}}    ${custom_field_values}

Get Earliest Date From The Grid In Request Tab
    ${grid_list} =    Get All Cell Values In Data Grid Table    [NAME:TrainTripsGrid]
    ${actual_list}    Create List
    : FOR    ${item}    IN    @{grid_list[1:]}
    \    ${item_val_list}    Split String    ${item}    ;
    \    ${item_date}    Set Variable    ${item_val_list[1]}
    \    Append To List    ${actual_list}    ${item_date}
    ${sorted_date_list}    Sort Date List    ${actual_list}    %d/%m/%Y
    Log    ${sorted_date_list[0]}
    ${date_passive_segment}    Convert Date To Gds Format    ${sorted_date_list[0]}    %d/%m/%Y
    Set Suite Variable    ${date_passive_segment}
    Log    ${date_passive_segment}
    [Teardown]    Take Screenshot

Populate Other Services Custom Fields Control
    [Arguments]    ${ticket_type}    ${id_type}    ${id_issuing_auth}    ${id_no}    ${no_of_passengers}    ${travel_within_24_hrs}
    ...    ${id_belong_to_passenger}=${EMPTY}    ${age}=${EMPTY}    ${gender}=${EMPTY}    ${travel_desk_email_id}=${EMPTY}
    [Documentation]    Do not change the positioning of the Set Row Object as it helps in scrolling respective list for Train-Dom and Transaction Charges.
    Run Keyword If    '${product.lower()}'=='train- dom'    Set Row Object In Datagrid    Ticket Type    ${ticket_type}    CustomFieldGrid
    Set Row Object In Datagrid    ID Type    ${id_type}    CustomFieldGrid
    Set Row Object In Datagrid    ID Issuing Authority    ${id_issuing_auth}    CustomFieldGrid
    Set Row Object In Datagrid    ID Number    ${id_no}    CustomFieldGrid
    Set Row Object In Datagrid    Number Of Passengers    ${no_of_passengers}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='train- dom'    Set Row Object In Datagrid    Travel Within 24 Hours    ${travel_within_24_hrs}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='train- dom'    Set Row Object In Datagrid    Age    ${age}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='train- dom'    Set Row Object In Datagrid    Gender    ${gender}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='transaction charges'    Set Row Object In Datagrid    ID Belong To Passenger    ${id_belong_to_passenger}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='train- dom'    Set Row Object In Datagrid    Travel Desk Email ID    ${travel_desk_email_id}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='transaction charges'    Set Row Object In Datagrid    Ticket Type    ${ticket_type}    CustomFieldGrid
    Run Keyword If    '${product.lower()}'=='transaction charges'    Set Row Object In Datagrid    Travel Within 24 Hours    ${travel_within_24_hrs}    CustomFieldGrid

Set Date Of Birth Insurance
    [Arguments]    ${dateofbirth}
    Set Control Text Value    [NAME:DateOfBirthTextBox]    ${dateofbirth}

Set Country
    [Arguments]    ${country}
    Set Control Text Value    [NAME:CountryTextBox]    ${country}

Verify Other Services Request Info Details
    [Arguments]    ${identifier}    ${detail_1}=Detail 1    ${detail_2}=Detail 2    ${detail_3}=Detail 3    ${internal_remarks}=Internal Remarks
    Get Other Services Request Info    ${identifier}
    Verify Actual Value Matches Expected Value    ${detail_1_${identifier}}    ${detail_1}
    Verify Actual Value Matches Expected Value    ${detail_2_${identifier}}    ${detail_2}
    Verify Actual Value Matches Expected Value    ${detail_3_${identifier}}    ${detail_3}

Populate Other Services Car Segment Control Details
    [Arguments]    ${car_segment}=${EMPTY}    ${pickup_date}=02/07/2020    ${pickup_time}=10:00:20 AM    ${dropoff_date}=02/08/2020    ${dropoff_time}=10:00:20 PM    ${daily_rate_currency}=INR \ \ \ Indian Rupee
    ...    ${daily_rate_amount}=5000    ${pickup_location}=Airport    ${pickup_location_text}=HONG KONG    ${dropoff_location}=Office    ${dropoff_location_text}=CWT OFFICE    ${guarantee_by}=Travel Agent
    ...    ${companies}=Avis Rent A Car System, Inc.    ${confirmation_number}=FAKE    ${name_text}=AVIS    ${car_type}=SEDAN    ${internal_remarks}=Internal Remarks    ${cancellation_policy}=others
    #Car Segment
    Run Keyword If    "${car_segment}" != "${EMPTY}"    Select Car Segment    ${car_segment}
    ...    ELSE    Select Car Segment    1    True
    #Pickup Date
    Run Keyword If    "${pickup_date}" != "${EMPTY}"    Populate Date    ${pickup_date}    [NAME:PickupDateDatePicker]
    #Time
    Run Keyword If    "${pickup_time}" != "${EMPTY}"    Populate Time    ${pickup_time}    [NAME:TimePickerControl]
    #Drop off Date
    Run Keyword If    "${dropoff_date}" != "${EMPTY}"    Populate Date    ${dropoff_date}    [NAME:DropOffDateDatePicker]
    #Time
    Run Keyword If    "${dropoff_time}" != "${EMPTY}"    Populate Time    ${dropoff_time}    [NAME:DropOffTimePicker]
    #Daily Rate Currency
    Select Value From Dropdown List    [NAME:DailyRateCurrencyComboBox]    ${daily_rate_currency}
    #Daily Rate Amount
    Set Control Text Value    [NAME:DailyRateAmountTextBox]    ${daily_rate_amount}
    #Pickup Location
    Select Value From Dropdown List    [NAME:PickUpLocationsComboBox]    ${pickup_location}
    #Picktup Location Description
    Set Control Text Value    [NAME:PickupLocationTextTextBox]    ${pickup_location_text}
    #Drop Off Location
    Select Value From Dropdown List    [NAME:DropOffLocationsComboBox]    ${dropoff_location}
    #Drop Off Location Description
    Set Control Text Value    [NAME:DropOffLocationTextTextBox]    ${dropoff_location_text}
    #Guarantee By -- Revisit
    Populate Guarantee Type With Default Values    ${guarantee_by}
    #Company
    Select Value From Dropdown List    [NAME:CompaniesComboBox]    ${companies}
    #Confirmation Number
    Set Control Text Value    [NAME:ConfirmationNumberTextBox]    ${confirmation_number}
    #Name
    Set Control Text Value    [NAME:NameTextBox]    ${name_text}
    #Car Type
    Set Control Text Value    [NAME:CarTypeTextBox]    ${car_type}
    #Internal Remarks
    Set Control Text Value    [NAME:DescriptionTextBox]    ${internal_remarks}
    #Cancellation Policy
    Populate Cancellation Policy With Default Values    ${cancellation_policy}
    [Teardown]    Take Screenshot

Populate Cancellation Policy With Default Values
    [Arguments]    ${cancellation_policy}=others
    [Documentation]    Cancellation Policy
    ...    - Cancel By
    ...    - Special Rate
    ...    - Others
    ...
    ...    It will populate default value.
    ${cancellation_policy}    Convert To Lowercase    ${cancellation_policy}
    Run Keyword If    "${cancellation_policy}" == "cancel by"    Run Keywords    Select Cancel By
    ...    AND    Set Control Text Value    [NAME:CancelByAmountTextBox]    24
    Run Keyword If    "${cancellation_policy}" == "special rate"    Select Special Rate, No Cancellation
    Run Keyword If    "${cancellation_policy}" == "others"    Run Keywords    Select Others
    ...    AND    Set Control Text Value    [NAME:CancelByOthersDescriptionTextBox]    Not Applicable
    [Teardown]    Take Screenshot

Get Other Services Car Segment Control Details
    [Arguments]    ${identifier}
    #Car Segment
    ${car_segment}    Get Control Text Value    [NAME:CarSegmentsComboBox]
    #Pickup Date
    ${pickup_date}    Get Control Text Value    [NAME:PickupDateDatePicker]
    #Time
    ${pickup_time}    Get Control Text Value    [NAME:TimePickerControl]
    #Drop off Date
    ${dropoff_date}    Get Control Text Value    [NAME:DropOffDateDatePicker]
    #Time
    ${dropoff_time}    Get Control Text Value    [NAME:DropOffTimePicker]
    #Daily Rate Currency
    ${daily_rate_currency}    Get Control Text Value    [NAME:DailyRateCurrencyComboBox]
    #Daily Rate Amount
    ${daily_rate_amount}    Get Control Text Value    [NAME:DailyRateAmountTextBox]
    #Pickup Location
    ${pickup_location}    Get Control Text Value    [NAME:PickUpLocationsComboBox]
    #Picktup Location Description
    ${pickup_location_text}    Get Control Text Value    [NAME:PickupLocationTextTextBox]
    #Drop Off Location
    ${dropoff_location}    Get Control Text Value    [NAME:DropOffLocationsComboBox]
    #Drop Off Location Description
    ${dropoff_location_text}    Get Control Text Value    [NAME:DropOffLocationTextTextBox]
    #Guarantee By
    ${guarantee_by}    Get Control Text Value    [NAME:GuaranteedByComboBox]
    #Company
    ${companies}    Get Control Text Value    [NAME:CompaniesComboBox]
    #Confirmation Number
    ${confirmation_number}    Get Control Text Value    [NAME:ConfirmationNumberTextBox]
    #Name
    ${name_text}    Get Control Text Value    [NAME:NameTextBox]
    #Car Type
    ${car_type}    Get Control Text Value    [NAME:CarTypeTextBox]
    #Internal Remarks
    ${internal_remarks}    Get Control Text Value    [NAME:DescriptionTextBox]
    #Cancel By
    ${cancelby_amount}    Get Control Text Value    [NAME:CancelByAmountTextBox]
    ${cancelby_type}    Get Control Text Value    [NAME:SelectedCancelByTypeComboBox]
    #Others
    ${others}    Get Control Text Value    [NAME:CancelByOthersDescriptionTextBox]
    Set Suite Variable    ${car_segment_${identifier}}    ${car_segment}
    Set Suite Variable    ${pickup_date_${identifier}}    ${pickup_date}
    Set Suite Variable    ${pickup_time_${identifier}}    ${pickup_time}
    Set Suite Variable    ${dropoff_date_${identifier}}    ${dropoff_date}
    Set Suite Variable    ${dropoff_time_${identifier}}    ${dropoff_time}
    Set Suite Variable    ${daily_rate_currency_${identifier}}    ${daily_rate_currency}
    Set Suite Variable    ${daily_rate_amount_${identifier}}    ${daily_rate_amount}
    Set Suite Variable    ${pickup_location_${identifier}}    ${pickup_location}
    Set Suite Variable    ${pickup_location_text_${identifier}}    ${pickup_location_text}
    Set Suite Variable    ${dropoff_location_${identifier}}    ${dropoff_location}
    Set Suite Variable    ${dropoff_location_text_${identifier}}    ${dropoff_location_text}
    Set Suite Variable    ${guarantee_by_${identifier}}    ${guarantee_by}
    Set Suite Variable    ${companies_${identifier}}    ${companies}
    Set Suite Variable    ${confirmation_number_${identifier}}    ${confirmation_number}
    Set Suite Variable    ${name_text_${identifier}}    ${name_text}
    Set Suite Variable    ${car_type_${identifier}}    ${car_type}
    Set Suite Variable    ${internal_remarks_${identifier}}    ${internal_remarks}
    Set Suite Variable    ${cancelby_amount_${identifier}}    ${cancelby_amount}
    Set Suite Variable    ${cancelby_type_${identifier}}    ${cancelby_type}
    Set Suite Variable    ${others_${identifier}}    ${others}

Populate Guarantee Type With Default Values
    [Arguments]    ${guarantee_by}=Deposit
    [Documentation]    Cancellation Policy
    ...    - Travel Agent
    ...    - Deposit
    ...    - Credit Card
    ...
    ...    It will populate with default value.
    ${guarantee_by}    Convert To Lowercase    ${guarantee_by}
    Run Keyword If    "${guarantee_by}" == "travel agent"    Select Value From Dropdown List    [NAME:GuaranteedByComboBox]    Travel Agent
    Run Keyword If    "${guarantee_by}" == "deposit"    Select Value From Dropdown List    [NAME:GuaranteedByComboBox]    Deposit
    Run Keyword If    "${guarantee_by}" == "credit card"    Run Keywords    Select Value From Dropdown List    [NAME:GuaranteedByComboBox]    Credit Card
    ...    AND    Set Control Text Value    [NAME:CreditCardNumberTextBox]    4444333322221111
    ...    AND    Select Value From Dropdown List    [NAME:CreditCardPreferenceComboBox]    BTC
    ...    AND    Select Value From Dropdown List    [NAME:CreditCardTypesComboBox]    VI

Set Tour Code
    [Arguments]    ${tour_code}
    Set Control Text Value    [NAME:TourCodeTextBox]    ${tour_code}

Set PoS Remark 1
    [Arguments]    ${pos_remark_1}
    Set Control Text Value    [NAME:PosRemark1TextBox]    ${pos_remark_1}

Set PoS Remark 2
    [Arguments]    ${pos_remark_2}
    Set Control Text Value    [NAME:PosRemark2TextBox]    ${pos_remark_2}

Set PoS Remark 3
    [Arguments]    ${pos_remark_3}
    Set Control Text Value    [NAME:PosRemark3TextBox]    ${pos_remark_3}

Set Threshold Amount
    [Arguments]    ${threshold_amount}
    Set Control Text Value    [NAME:ThresholdAmountTextBox]    ${threshold_amount}

Set Centralized Desk 1
    [Arguments]    ${centralized_desk_1}
    Set Control Text Value    [NAME:CentralizedDesk1TextBox]    ${centralized_desk_1}

Set Centralized Desk 2
    [Arguments]    ${centralized_desk_2}
    Set Control Text Value    [NAME:CentralizedDesk2TextBox]    ${centralized_desk_2}

Select Airlines
    [Arguments]    ${airlines}
    Select Dropdown Value    [NAME:AirLinesComboBox]    ${airlines}

Select Transaction Type
    [Arguments]    ${transaction_type}
    Select Dropdown Value    [NAME:TransactionTypeComboBox]    ${transaction_type}

Set Airlines PNR
    [Arguments]    ${airlines_pnr}
    Set Control Text Value    [NAME:AirlinesPnrTextBox]    ${airlines_pnr}

Set Fare Break Up 1
    [Arguments]    ${fare_break_up_1}
    Set Control Text Value    [NAME:FareBreakUp1TextBox]    ${fare_break_up_1}

Set Fare Break Up 2
    [Arguments]    ${fare_break_up_2}
    Set Control Text Value    [NAME:FareBreakUp2TextBox]    ${fare_break_up_2}

Set GSTIN
    [Arguments]    ${gstin}
    Set Control Text Value    [NAME:GsTinTextBox]    ${gstin}

Set Cancellation Penalty
    [Arguments]    ${cancellation_penalty}
    Set Control Text Value    [NAME:CancellationPenaltyTextBox]    ${cancellation_penalty}

Set LCC Queue Back Remark
    [Arguments]    ${lcc_queue_back_remark}
    Set Control Text Value    [NAME:LccQueueBackRemarkTextBox]    ${lcc_queue_back_remark}

Set Email
    [Arguments]    ${email}
    Set Control Text Value    [NAME:EmailTextBox]    ${email}

Set Entity Name
    [Arguments]    ${entity_name}
    Set Control Text Value    [NAME:EntityNameTextBox]    ${entity_name}

Set Phone No
    [Arguments]    ${phone_no}
    Set Control Text Value    [NAME:PhoneNoTextBox]    ${phone_no}

Select Fare Type In Request Tab
    [Arguments]    ${fare_type}=${EMPTY}
    Select Value From Dropdown List    [NAME:FareTypeComboBox]    ${fare_type}

Get Airlines
    [Arguments]    ${identifier}
    ${airlines}    Get Control Text Value    [NAME:AirLinesComboBox]
    Set Suite Variable    ${airlines_${identifier}}    ${airlines}

Get Airlines PNR
    [Arguments]    ${identifier}
    ${airlines_pnr}    Get Control Text Value    [NAME:AirlinesPnrTextBox]
    Set Suite Variable    ${airlines_pnr_${identifier}}    ${airlines_pnr}

Get Cancellation Penalty
    [Arguments]    ${identifier}
    ${cancellation_penalty}    Get Control Text Value    [NAME:CancellationPenaltyTextBox]
    Set Suite Variable    ${cancellation_penalty_${identifier}}    ${cancellation_penalty}

Get Centralized Desk 1
    [Arguments]    ${identifier}
    ${centralized_desk_1}    Get Control Text Value    [NAME:CentralizedDesk1TextBox]
    Set Suite Variable    ${centralized_desk_1_${identifier}}    ${centralized_desk_1}

Get Centralized Desk 2
    [Arguments]    ${identifier}
    ${centralized_desk_2}    Get Control Text Value    [NAME:CentralizedDesk2TextBox]
    Set Suite Variable    ${centralized_desk_2_${identifier}}    ${centralized_desk_2}

Get Email In Request
    [Arguments]    ${identifier}
    ${email_in_request}    Get Control Text Value    [NAME:EmailTextBox]
    Set Suite Variable    ${email_in_request_${identifier}}    ${email_in_request}

Get Entity Name
    [Arguments]    ${identifier}
    ${entity_name}    Get Control Text Value    [NAME:EntityNameTextBox]
    Set Suite Variable    ${entity_name_${identifier}}    ${entity_name}

Get Fare Type
    [Arguments]    ${identifier}
    ${fare_type}    Get Control Text Value    [NAME:FareTypeComboBox]
    Set Suite Variable    ${fare_type_${identifier}}    ${fare_type}

Get Fare break up 1
    [Arguments]    ${identifier}
    ${fare_break_up_1}    Get Control Text Value    [NAME:FareBreakUp1TextBox]
    Set Suite Variable    ${fare_break_up_1_${identifier}}    ${fare_break_up_1}

Get Fare break up 2
    [Arguments]    ${identifier}
    ${fare_break_up_2}    Get Control Text Value    [NAME:FareBreakUp2TextBox]
    Set Suite Variable    ${fare_break_up_2_${identifier}}    ${fare_break_up_2}

Get GSTIN
    [Arguments]    ${identifier}
    ${gstin}    Get Control Text Value    [NAME:GsTinTextBox]
    Set Suite Variable    ${gstin_${identifier}}    ${gstin}

Get LCC Queue Back Remark
    [Arguments]    ${identifier}
    ${lcc_queue_back_remark}    Get Control Text Value    [NAME:LccQueueBackRemarkTextBox]
    Set Suite Variable    ${lcc_queue_back_remark_${identifier}}    ${lcc_queue_back_remark}

Get Phone No
    [Arguments]    ${identifier}
    ${phone_no}    Get Control Text Value    [NAME:PhoneNoTextBox]
    Set Suite Variable    ${phone_no_${identifier}}    ${phone_no}

Get Plating Carrier
    [Arguments]    ${identifier}
    ${plating_carrier}    Get Control Text Value    [NAME:PlatingCarrierComboBox]
    Set Suite Variable    ${plating_carrier_${identifier}}    ${plating_carrier}

Get PoS Remark 1
    [Arguments]    ${identifier}
    ${pos_remark_1}    Get Control Text Value    [NAME:PosRemark1TextBox]
    Set Suite Variable    ${pos_remark_1_${identifier}}    ${pos_remark_1}

Get PoS Remark 2
    [Arguments]    ${identifier}
    ${pos_remark_2}    Get Control Text Value    [NAME:PosRemark2TextBox]
    Set Suite Variable    ${pos_remark_2_${identifier}}    ${pos_remark_2}

Get PoS Remark 3
    [Arguments]    ${identifier}
    ${pos_remark_3}    Get Control Text Value    [NAME:PosRemark3TextBox]
    Set Suite Variable    ${pos_remark_3_${identifier}}    ${pos_remark_3}

Get Threshold Amount
    [Arguments]    ${identifier}
    ${threshold_amount}    Get Control Text Value    [NAME:ThresholdAmountTextBox]
    Set Suite Variable    ${threshold_amount_${identifier}}    ${threshold_amount}

Get Transaction Type
    [Arguments]    ${identifier}
    ${transaction_type}    Get Control Text Value    [NAME:TransactionTypeComboBox]
    Set Suite Variable    ${transaction_type_${identifier}}    ${transaction_type}

Get Other Services Conso Control Details
    [Arguments]    ${identifier}
    Get Tour Code    ${identifier}
    Get Threshold Amount    ${identifier}

Get Other Services Custom Fields Control Details
    [Arguments]    ${identifier}
    Get PoS Remark 1    ${identifier}
    Get PoS Remark 2    ${identifier}
    Get PoS Remark 3    ${identifier}
    Get Centralized Desk 1    ${identifier}
    Get Centralized Desk 2    ${identifier}
    Get Airlines    ${identifier}
    Get Transaction Type    ${identifier}
    Get Airlines PNR    ${identifier}
    Get Fare break up 1    ${identifier}
    Get Fare break up 2    ${identifier}
    Get Cancellation Penalty    ${identifier}
    Get LCC Queue back Remark    ${identifier}
    Get GSTIN    ${identifier}
    Get Email In Request    ${identifier}
    Get Entity Name    ${identifier}
    Get Phone No    ${identifier}

Get Other Services Request Details For Air Conso-Dom Or Air Sales-Non Bsp Int
    [Arguments]    ${identifier}    ${product}
    Get Plating Carrier    ${identifier}
    Get Fare Type    ${identifier}
    Get Other Services Conso Control Details    ${identifier}
    Run Keyword If    "${product}"=="air conso-dom"    Get Other Services Custom Fields Control Details    ${identifier}

Populate Request Tab For Air Conso-Dom Or Air Sales-Non Bsp Int
    [Arguments]    ${product}    ${plating_carrier}=${EMPTY}    ${fare_type}=${EMPTY}    ${tour_code}=789XYZ    ${threshold_amount}=8500    ${pos_remark_1}=Pos1
    ...    ${pos_remark_2}=Pos2    ${pos_remark_3}=Pos3    ${centralized_desk_1}=Centralized Desk 1    ${centralized_desk_2}=Centralized Desk 2    ${airlines}=Jet Airways    ${transaction_type}=New Issue
    ...    ${airlines_pnr}=AJSRQW    ${fare_break_up_1}=Fare Break Up 1    ${fare_break_up_2}=Fare Break Up 2    ${cancellation_penalty}=50USD    ${lcc_queue_back_remark}=Lcc Queue    ${gstin}=14
    ...    ${email}=email@cwt.com    ${entity_name}=CWT    ${phone_no}=98730596    ${passenger}=${EMPTY}
    Populate Other Services Air Segment Control Details
    Run Keyword If    "${plating_carrier}"!="${EMPTY}"    Select Plating Carrier    ${plating_carrier}
    Run Keyword If    "${fare_type}"!="${EMPTY}"    Select Fare Type In Request Tab    ${fare_type}
    Populate Other Services Conso Control Details    ${tour_code}    ${threshold_amount}
    Run Keyword If    "${product}"=="air conso-dom"    Populate Other Services Custom Fields Control Details    ${airlines}    ${transaction_type}    ${pos_remark_1}    ${pos_remark_2}
    ...    ${pos_remark_3}    ${centralized_desk_1}    ${centralized_desk_2}    ${airlines_pnr}    ${fare_break_up_1}    ${fare_break_up_2}
    ...    ${cancellation_penalty}    ${lcc_queue_back_remark}    ${gstin}    ${email}    ${entity_name}    ${phone_no}
    Select Passenger    ${passenger}

Populate Other Services Conso Control Details
    [Arguments]    ${tour_code}=${EMPTY}    ${threshold_amount}=${EMPTY}
    Set Tour Code    ${tour_code}
    Set Threshold Amount    ${threshold_amount}

Populate Other Services Custom Fields Control Details
    [Arguments]    ${airlines}    ${transaction_type}    ${pos_remark_1}=${EMPTY}    ${pos_remark_2}=${EMPTY}    ${pos_remark_3}=${EMPTY}    ${centralized_desk_1}=${EMPTY}
    ...    ${centralized_desk_2}=${EMPTY}    ${airlines_pnr}=${EMPTY}    ${fare_break_up_1}=${EMPTY}    ${fare_break_up_2}=${EMPTY}    ${cancellation_penalty}=${EMPTY}    ${lcc_queue_back_remark}=${EMPTY}
    ...    ${gstin}=${EMPTY}    ${email}=${EMPTY}    ${entity_name}=${EMPTY}    ${phone_no}=${EMPTY}
    Set PoS Remark 1    ${pos_remark_1}
    Set PoS Remark 2    ${pos_remark_2}
    Set PoS Remark 3    ${pos_remark_3}
    Set Centralized Desk 1    ${centralized_desk_1}
    Set Centralized Desk 2    ${centralized_desk_2}
    Select Airlines    ${airlines}
    Select Transaction Type    ${transaction_type}
    Set Airlines PNR    ${airlines_pnr}
    Set Fare Break Up 1    ${fare_break_up_1}
    Set Fare Break Up 2    ${fare_break_up_2}
    Set Cancellation Penalty    ${cancellation_penalty}
    Set LCC Queue Back Remark    ${lcc_queue_back_remark}
    Set GSTIN    ${gstin}
    Set Email    ${email}
    Set Entity Name    ${entity_name}
    Set Phone No    ${phone_no}

Verify Other Services Car Group Request Values Are Correct
    [Arguments]    ${identifier}    ${car_segment}=${EMPTY}    ${pickup_date}=02/07/2020    ${pickup_time}=10:00:20 AM    ${dropoff_date}=02/08/2020    ${dropoff_time}=10:00:20 PM
    ...    ${daily_rate_currency}=INR \ \ \ Indian Rupee    ${daily_rate_amount}=5000    ${pickup_location}=Airport    ${pickup_location_text}=HONG KONG    ${dropoff_location}=Office    ${dropoff_location_text}=CWT OFFICE
    ...    ${guarantee_by}=Travel Agent    ${companies}=Avis Rent A Car System, Inc.    ${confirmation_number}=FAKE    ${name_text}=AVIS    ${car_type}=SEDAN    ${internal_remarks}=Internal Remarks
    ...    ${cancellation_policy}=others    ${cancelby_amount}=${EMPTY}    ${cancelby_type}=Hrs    ${others}=${EMPTY}
    Get Other Services Car Segment Control Details    ${identifier}
    Verify Text Contains Expected Value    ${car_segment_${identifier}}    ${car_segment}
    Verify Actual Value Matches Expected Value    ${pickup_date_${identifier}}    ${pickup_date}
    Verify Actual Value Matches Expected Value    ${pickup_time_${identifier}}    ${pickup_time}
    Verify Actual Value Matches Expected Value    ${dropoff_date_${identifier}}    ${dropoff_date}
    Verify Actual Value Matches Expected Value    ${dropoff_time_${identifier}}    ${dropoff_time}
    Verify Actual Value Matches Expected Value    ${daily_rate_currency_${identifier}}    ${daily_rate_currency}
    Verify Actual Value Matches Expected Value    ${daily_rate_amount_${identifier}}    ${daily_rate_amount}
    Verify Actual Value Matches Expected Value    ${pickup_location_${identifier}}    ${pickup_location}
    Verify Actual Value Matches Expected Value    ${pickup_location_text_${identifier}}    ${pickup_location_text}
    Verify Actual Value Matches Expected Value    ${dropoff_location_${identifier}}    ${dropoff_location}
    Verify Actual Value Matches Expected Value    ${dropoff_location_text_${identifier}}    ${dropoff_location_text}
    Verify Actual Value Matches Expected Value    ${guarantee_by_${identifier}}    ${guarantee_by}
    Verify Actual Value Matches Expected Value    ${companies_${identifier}}    ${companies}
    Verify Actual Value Matches Expected Value    ${confirmation_number_${identifier}}    ${confirmation_number}
    Verify Actual Value Matches Expected Value    ${name_text_${identifier}}    ${name_text}
    Verify Actual Value Matches Expected Value    ${car_type_${identifier}}    ${car_type}
    Verify Actual Value Matches Expected Value    ${internal_remarks_${identifier}}    ${internal_remarks}
    Verify Actual Value Matches Expected Value    ${cancel_by_amount_${identifier}}    ${cancelby_amount}
    Verify Actual Value Matches Expected Value    ${cancel_by_type_${identifier}}    ${cancelby_type}
    Verify Actual Value Matches Expected Value    ${others_${identifier}}    ${others}

Verify Other Services Visa Group Request Values Are Correct
    [Arguments]    ${identifier}    ${document}=Passport    ${country}=Philippines    ${doc_type}=Fresh    ${date_of_application}=${EMPTY}    ${internal_remarks}=Internal Remarks
    ...    ${entries}=Single    ${validity}=${EMPTY}    ${validity_days}=Days    ${processing}=Normal
    Get Other Services Visa Standard Control    ${identifier}
    Verify Actual Value Matches Expected Value    ${document_${identifier}}    ${document}
    Verify Actual Value Matches Expected Value    ${country_${identifier}}    ${country}
    Verify Actual Value Matches Expected Value    ${doc_type_${identifier}}    ${doc_type}
    Run Keyword If    "${date_of_application}" != "${EMPTY}"    Verify Actual Value Matches Expected Value    ${date_of_application_${identifier}}    ${date_of_application}
    Verify Actual Value Matches Expected Value    ${internal_remarks_${identifier}}    ${internal_remarks}
    Verify Actual Value Matches Expected Value    ${entries_${identifier}}    ${entries}
    Verify Actual Value Matches Expected Value    ${validity_${identifier}}    ${validity}
    Verify Actual Value Matches Expected Value    ${validity_days_${identifier}}    ${validity_days}
    Verify Actual Value Matches Expected Value    ${processing_${identifier}}    ${processing}

Get Other Services Hotel Information Control Details
    [Arguments]    ${identifier}
    #Get Air Segment
    ${air_segment}    Get Control Text Current Value    [NAME:Request_AirSegmentsComboBox]
    #Get Checkin Date
    ${checkin_date}    Get Control Text    [NAME:Request_CheckinDateDatePicker]
    #Get Checkout Date
    ${checkout_date}    Get Control Text    [NAME:Request_CheckoutDateDatePicker]
    #Get Daily Rate
    ${daily_rate}    Get Control Text Current Value    [NAME:Request_DailyRateCurrencyComboBox]
    #Get Rate Amount
    ${daily_rate_amount}    Get Control Text Current Value    [NAME:Request_DailyRateAmountTextBox]
    #Get Hotel Segment
    ${hotel_segment}    Get Control Text Current Value    [NAME:Request_HotelSegmentsCombobox]
    #Get Room Type
    ${room_type}    Get Control Text Current Value    [NAME:Request_RoomTypeCombobox]
    #Get Number Of People
    ${number_of_people}    Get Control Text Current Value    [NAME:Request_NumberOfPeopleTextBox]
    #Get Guarantee By
    ${guarantee_by}    Get Control Text Current Value    [NAME:Request_GuaranteedByComboBox]
    #Get Confirmation Number
    ${confirmation_number}    Get Control Text Current Value    [NAME:Request_ConfirmationNumberTextBox]
    #Get City Code
    ${city_code}    Get Control Text Current Value    [NAME:Request_CityCodeTextBox]
    #Get Hotel Name
    ${hotel_name}    Get Control Text Current Value    [NAME:Request_HotelNameTextBox]
    #Get Hotel Address
    ${hotel_address}    Get Control Text Current Value    [NAME:Request_HotelAddressTextBox]
    #Get City Name
    ${city_name}    Get Control Text Current Value    [NAME:Request_CityNameTextBox]
    #Get Post Code
    ${post_code}    Get Control Text Current Value    [NAME:Request_PostalCodeTextBox]
    #Get State/Province
    ${state_or_province}    Get Control Text Current Value    [NAME:Request_StateOrProvinceTextBox]
    #Get Phone Number
    ${phone_number}    Get Control Text Current Value    [NAME:Request_PhoneNumberTexBox]
    Set Suite Variable    ${air_segment_${identifier}}    ${air_segment}
    Set Suite Variable    ${checkin_date_${identifier}}    ${checkin_date}
    Set Suite Variable    ${checkout_date_${identifier}}    ${checkout_date}
    Set Suite Variable    ${daily_rate_${identifier}}    ${daily_rate}
    Set Suite Variable    ${daily_rate_amount_${identifier}}    ${daily_rate_amount}
    Set Suite Variable    ${hotel_segment_${identifier}}    ${hotel_segment}
    Set Suite Variable    ${room_type_${identifier}}    ${room_type}
    Set Suite Variable    ${number_of_people_${identifier}}    ${number_of_people}
    Set Suite Variable    ${guarantee_by_${identifier}}    ${guarantee_by}
    Set Suite Variable    ${confirmation_number_${identifier}}    ${confirmation_number}
    Set Suite Variable    ${city_code_${identifier}}    ${city_code}
    Set Suite Variable    ${hotel_name_${identifier}}    ${hotel_name}
    Set Suite Variable    ${hotel_address_${identifier}}    ${hotel_address}
    Set Suite Variable    ${city_name_${identifier}}    ${city_name}
    Set Suite Variable    ${post_code_${identifier}}    ${post_code}
    Set Suite Variable    ${state_or_province_${identifier}}    ${state_or_province}
    Set Suite Variable    ${phone_number_${identifier}}    ${phone_number}

Get Other Services Cancellation Policy Control Details
    [Arguments]    ${identifier}
    #Get Selected Cancellation Policy Radio Button State
    ${is_cancel_by}    Get Radio Button State    [NAME:Request_CancelByRadioButton]
    ${is_special_rate}    Get Radio Button State    [NAME:Request_SpecialRateRadioButton]
    ${is_others}    Get Radio Button State    [NAME:Request_OthersRadioButton]
    ${cancellation_policy}    Run Keyword If    ${is_cancel_by}    Get Control Text    [NAME:Request_CancelByRadioButton]
    ...    ELSE    Set Variable
    ${cancellation_policy}    Run Keyword If    ${is_special_rate}    Get Control Text    [NAME:Request_SpecialRateRadioButton]
    ...    ELSE    Set Variable    ${cancellation_policy}
    ${cancellation_policy}    Run Keyword If    ${is_others}    Get Control Text    [NAME:Request_OthersRadioButton]
    ...    ELSE    Set Variable    ${cancellation_policy}
    #Get Cancel By Duration And Unit
    ${cancel_by_duration}    Run Keyword If    ${is_cancel_by}    Get Control Text Current Value    [NAME:Request_CancelByAmountTextBox]
    ${cancel_by_duration_unit}    Run Keyword If    ${is_cancel_by}    Get Control Text Current Value    [NAME:Request_CancelByTypeComboBox]
    #Get Others Description
    ${others_description}    Run Keyword If    ${is_others}    Get Control Text Current Value    [NAME:Request_CancelByOthersDescriptionTextBox]
    Set Suite Variable    ${cancellation_policy_${identifier}}    ${cancellation_policy}
    Set Suite Variable    ${cancel_by_amount_${identifier}}    ${cancel_by_duration}
    Set Suite Variable    ${cancel_by_type_${identifier}}    ${cancel_by_duration_unit}
    Set Suite Variable    ${others_description_${identifier}}    ${others_description}

Get Other Services Internal Remarks Control Details
    [Arguments]    ${identifier}
    #Get Internal Remarks
    ${internal_remarks}    Get Control Text Current Value    [NAME:Request_InternalRemarksTextBox]
    Set Suite Variable    ${internal_remarks_${identifier}}    ${internal_remarks}

Get Other Services Request Details For Hotel Group
    [Arguments]    ${identifier}
    Get Other Services Hotel Information Control Details    ${identifier}
    Get Other Services Cancellation Policy Control Details    ${identifier}
    Get Other Services Internal Remarks Control Details    ${identifier}
    ${is_guaranteed_by_credit_card}    Set Variable If    "${guarantee_by_${identifier}}" == "Credit Card"    True    False
    Run Keyword If    ${is_guaranteed_by_credit_card}    Get Other Services Request Credit Card Group Details    ${identifier}

Get Other Services Request Credit Card Group Details
    [Arguments]    ${identifier}
    #Get Credit Card Number
    ${credit_card_number}    Get Control Text Current Value    [NAME:Request_CreditCardNumberTextBox]
    #Get Credit Card Preference
    ${credit_card_preference}    Get Control Text Current Value    [NAME:Request_CreditCardPreferenceComboBox]
    #Get Credit Card Type
    ${credit_card_type}    Get Control Text Current Value    [NAME:Request_CreditCardTypesComboBox]
    #Get Credit Card Expiry Date
    ${credit_card_expiry_date}    Get Control Text    [NAME:Request_ExpiryDateDatePicker]
    Set Suite Variable    ${credit_card_number_${identifier}}    ${credit_card_number}
    Set Suite Variable    ${credit_card_preference_${identifier}}    ${credit_card_preference}
    Set Suite Variable    ${credit_card_type_${identifier}}    ${credit_card_type}
    Set Suite Variable    ${credit_card_expiry_date_${identifier}}    ${credit_card_expiry_date}

Populate Other Services Hotel Information Control Details
    [Arguments]    ${hotel_segment_index}    ${daily_rate}    ${daily_rate_amount}    ${room_type}    ${number_of_people}    ${guarantee_by}
    ...    ${confirmation_number}    ${air_segment_index}=1    ${hotel_address}=TEST HOTEL ADRRESS    ${post_code}=9999    ${state_or_province}=GREAT BRITAIN    ${phone_number}=6325999999
    #Set Hotel Segment
    Select Value From Dropdown List    [NAME:Request_HotelSegmentsCombobox]    ${hotel_segment_index}    by_index=True
    #Set Air Segment
    Select Value From Dropdown List    [NAME:Request_AirSegmentsComboBox]    ${air_segment_index}    by_index=True
    #Set Daily Rate
    Select Value From Dropdown List    [NAME:Request_DailyRateCurrencyComboBox]    ${daily_rate}
    #Set Rate Amount
    Set Control Text Value    [NAME:Request_DailyRateAmountTextBox]    ${daily_rate_amount}
    #Set Room Type
    Select Value From Dropdown List    [NAME:Request_RoomTypeCombobox]    ${room_type}
    #Set Number Of People
    Set Control Text Value    [NAME:Request_NumberOfPeopleTextBox]    ${number_of_people}
    #Set Guarantee By
    Select Value From Dropdown List    [NAME:Request_GuaranteedByComboBox]    ${guarantee_by}
    #Set Confirmation Number
    Set Control Text Value    [NAME:Request_ConfirmationNumberTextBox]    ${confirmation_number}
    #Set Hotel Address
    Set Control Text Value    [NAME:Request_HotelAddressTextBox]    ${hotel_address}
    #Set Post Code
    Set Control Text Value    [NAME:Request_PostalCodeTextBox]    ${post_code}
    #Set State/Province
    Set Control Text Value    [NAME:Request_StateOrProvinceTextBox]    ${state_or_province}
    #Set Phone Number
    Set Control Text Value    [NAME:Request_PhoneNumberTexBox]    ${phone_number}

Populate Other Services Cancellation Policy Control Details
    [Arguments]    ${cancellation_policy}    ${cancel_duration}=${EMPTY}    ${others_description}=${EMPTY}    ${cancel_duration_unit}=Days
    ${cancellation_policy}    Convert To Lowercase    ${cancellation_policy}
    #Select Cancellation Policy Radio Button
    ${cancel_policy_object}    Set Variable If    "${cancellation_policy}" == "cancel by"    [NAME:Request_CancelByRadioButton]    "${cancellation_policy}" == "special rate, no cancellation"    [NAME:Request_SpecialRateRadioButton]    "${cancellation_policy}" == "others"
    ...    [NAME:Request_OthersRadioButton]
    Select Radio Button Value    ${cancel_policy_object}
    #Set Cancel By
    Run Keyword If    "${cancellation_policy}" == "cancel by"    Set Control Text Value    [NAME:Request_CancelByAmountTextBox]    ${cancel_duration}
    Run Keyword If    "${cancellation_policy}" == "cancel by"    Select Value From Dropdown List    [NAME:Request_CancelByTypeComboBox]    ${cancel_duration_unit}
    #Set Others Description
    Run Keyword If    "${cancellation_policy}" == "others"    Set Control Text Value    [NAME:Request_CancelByOthersDescriptionTextBox]    ${others_description}

Populate Other Services Internal Remarks Control Details
    [Arguments]    ${internal_remarks}=TEST INTERNAL REMARKS
    #Set Internal Remarks
    Set Control Text Value    [NAME:Request_InternalRemarksTextBox]    ${internal_remarks}

Populate Other Services Request Credit Card Group Details
    [Arguments]    ${credit_card_number}    ${credit_card_preference}    ${credit_card_type}    ${expiry_months_from_now}=0    ${expiry_years_from_now}=2
    Wait Until Control Object Is Visible    [NAME:Request_CreditCardGroup]
    #Populate Credit Card Number
    Set Control Text Value    [NAME:Request_CreditCardNumberTextBox]    ${credit_card_number}
    #Populate Credit Card Preference
    Select Value From Dropdown List    [NAME:Request_CreditCardPreferenceComboBox]    ${credit_card_preference}
    #Populate Credit Card Type
    Select Value From Dropdown List    [NAME:Request_CreditCardTypesComboBox]    ${credit_card_type}
    #Populate Credit Card Expiry Date
    ${credit_card_expiry_date}    Get Control Text    [NAME:Request_ExpiryDateDatePicker]
    @{splitted_expiry_date}    Split String    ${credit_card_expiry_date[0]}    /
    ${expiry_month}    Evaluate    ${splitted_expiry_date[0]}+${expiry_months_from_now}
    ${expiry_year}    Evaluate    ${splitted_expiry_date[1]}+${expiry_years_from_now}
    Click Control Button    [NAME:Request_ExpiryDateDatePicker]    ${title_power_express}
    Send    ${expiry_year}    1
    Send    {LEFT}
    Send    ${expiry_month}    1

Populate Other Services Request Tab For Hotel Group
    [Arguments]    ${hotel_segment_index}    ${daily_rate}    ${daily_rate_amount}    ${room_type}    ${number_of_people}    ${guarantee_by}
    ...    ${confirmation_number}    ${cancellation_policy}    ${cancel_duration}    ${others_description}    ${credit_card_number}    ${credit_card_preference}
    ...    ${credit_card_type}    ${air_segment_index}=1    ${hotel_address}=TEST HOTEL ADRRESS    ${post_code}=9999    ${state_or_province}=GREAT BRITAIN    ${phone_number}=6325999999
    ...    ${cancel_duration_unit}=Days    ${internal_remarks}=TEST INTERNAL REMARKS    ${expiry_months_from_now}=0    ${expiry_years_from_now}=2
    Populate Other Services Hotel Information Control Details    ${hotel_segment_index}    ${daily_rate}    ${daily_rate_amount}    ${room_type}    ${number_of_people}    ${guarantee_by}
    ...    ${confirmation_number}    ${air_segment_index}    ${hotel_address}    ${post_code}    ${state_or_province}    ${phone_number}
    Populate Other Services Cancellation Policy Control Details    ${cancellation_policy}    ${cancel_duration}    ${others_description}    ${cancel_duration_unit}
    Populate Other Services Internal Remarks Control Details    ${internal_remarks}
    Run Keyword If    '${guarantee_by.lower()}'=='credit card'    Populate Other Services Request Credit Card Group Details    ${credit_card_number}    ${credit_card_preference}    ${credit_card_type}    ${expiry_months_from_now}
    ...    ${expiry_years_from_now}

Verify Other Services Request Details For Hotel Group
    [Arguments]    ${identifier}    ${hotel_identifier}    ${hotel_segment}    ${hotel_name}    ${daily_rate}    ${daily_rate_amount}
    ...    ${city_code}
    [Documentation]    For ${checkin_date_ddmm} and ${checkout_date_ddmm} please check Book Passive Hotel / Book Active Hotel Keywords
    Get Other Services Request Details For Hotel Group    ${identifier}
    ${current_date}    Generate Date X Months From Now    0    0    %m/%Y
    ${current_date_splitted}    Split String    ${current_date}    /
    ${current_date_year}    Set Variable    ${current_date_splitted[-1]}
    ${current_date}    Set Variable    ${current_date_splitted[0]}/${current_date_year[2:]}
    ${checkin_date_ddmm}    Set Variable    ${checkin_date_ddmmm_${hotel_identifier}}
    ${checkout_date_ddmm}    Set Variable    ${checkout_date_ddmmm_${hotel_identifier}}
    ${checkin_date_syex}    Set Variable    ${checkin_date_syex_${hotel_identifier}}
    ${checkout_date_syex}    Set Variable    ${checkout_date_syex_${hotel_identifier}}
    Run Keyword If    "${identifier}" == "Default"    Verify Other Services Hotel Information Control Details    ${identifier}    ${EMPTY}    ${hotel_segment} ${checkin_date_ddmm} ${hotel_name}    ${checkin_date_syex}
    ...    ${checkout_date_syex}    ${daily_rate}    ${daily_rate_amount}    ${EMPTY}    1    ${EMPTY}
    ...    ${EMPTY}    ${city_code}    ${hotel_name}    ${EMPTY}    ${city_code}    ${EMPTY}
    ...    ${EMPTY}    ${EMPTY}
    ...    ELSE    Verify Other Services Hotel Information Control Details    ${identifier}    2 \\w{2} .+? .+? DELAUH HK1    ${hotel_segment} ${checkin_date_ddmm} ${hotel_name}    ${checkin_date_syex}
    ...    ${checkout_date_syex}    GBP \ \ \ Great British Pound    1200    Deluxe    1    Credit Card
    ...    12345678    ${city_code}    ${hotel_name}    TEST HOTEL ADRRESS    ${city_code}    9999
    ...    GREAT BRITAIN    6325999999
    Run Keyword If    "${identifier}" == "Default"    Verify Other Services Cancellation Policy Control Details    ${identifier}    Cancel By    ${EMPTY}    Hrs
    ...    ${EMPTY}
    ...    ELSE    Verify Other Services Cancellation Policy Control Details    ${identifier}    Cancel By    12    Days
    ...    ${EMPTY}
    ${is_guaranteed_by_credit_card}    Set Variable If    "${guarantee_by_${identifier}}" == "Credit Card"    True    False
    Run Keyword If    ${is_guaranteed_by_credit_card}    Verify Other Services Credit Card Group Details    ${identifier}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    ${current_date}
    [Teardown]    Take Screenshot

Verify Other Services Hotel Information Control Details
    [Arguments]    ${identifier}    ${air_segment}    ${hotel_segment}    ${checkin_date}    ${checkout_date}    ${daily_rate}
    ...    ${daily_rate_amount}    ${room_type}    ${number_of_people}    ${guarantee_by}    ${confirmation_number}    ${city_code}
    ...    ${hotel_name}    ${hotel_address}    ${city_name}    ${post_code}    ${state_or_province}    ${phone_number}
    Comment    Verify Actual Value Matches Expected Value    ${air_segment_${identifier}}    ${air_segment}
    Verify Text Contains Expected Value    ${air_segment_${identifier}}    ${air_segment}    reg_exp_flag=true
    Verify Actual Value Matches Expected Value    ${checkin_date_${identifier}[0]}    ${checkin_date}
    Verify Actual Value Matches Expected Value    ${checkout_date_${identifier}[0]}    ${checkout_date}
    Verify Actual Value Matches Expected Value    ${daily_rate_${identifier}}    ${daily_rate}
    Verify Actual Value Matches Expected Value    ${daily_rate_amount_${identifier}}    ${daily_rate_amount}
    Verify Actual Value Matches Expected Value    ${hotel_segment_${identifier}}    ${hotel_segment}
    Verify Actual Value Matches Expected Value    ${room_type_${identifier}}    ${room_type}
    Verify Actual Value Matches Expected Value    ${number_of_people_${identifier}}    ${number_of_people}
    Verify Actual Value Matches Expected Value    ${guarantee_by_${identifier}}    ${guarantee_by}
    Verify Actual Value Matches Expected Value    ${confirmation_number_${identifier}}    ${confirmation_number}
    Verify Actual Value Matches Expected Value    ${city_code_${identifier}}    ${city_code}
    Verify Actual Value Matches Expected Value    ${hotel_name_${identifier}}    ${hotel_name}
    Verify Actual Value Matches Expected Value    ${hotel_address_${identifier}}    ${hotel_address}
    Verify Actual Value Matches Expected Value    ${city_name_${identifier}}    ${city_name}
    Verify Actual Value Matches Expected Value    ${post_code_${identifier}}    ${post_code}
    Verify Actual Value Matches Expected Value    ${state_or_province_${identifier}}    ${state_or_province}
    Verify Actual Value Matches Expected Value    ${phone_number_${identifier}}    ${phone_number}

Verify Other Services Cancellation Policy Control Details
    [Arguments]    ${identifier}    ${cancellation_policy}    ${cancel_by_duration}    ${cancel_by_duration_unit}    ${others_description}
    ${cancellation_policy_final}    Set Variable    ${cancellation_policy_${identifier}[0]}
    Should Be Equal    ${cancellation_policy_final}    ${cancellation_policy}
    Run Keyword If    "${cancellation_policy_final}" == "Cancel By"    Verify Actual Value Matches Expected Value    ${cancel_by_amount_${identifier}}    ${cancel_by_duration}
    Run Keyword If    "${cancellation_policy_final}" == "Cancel By"    Verify Actual Value Matches Expected Value    ${cancel_by_type_${identifier}}    ${cancel_by_duration_unit}
    Run Keyword If    "${cancellation_policy_final}" == "Others"    Verify Actual Value Matches Expected Value    ${others_description_${identifier}}    ${others_description}

Verify Other Services Credit Card Group Details
    [Arguments]    ${identifier}    ${credit_card_number}    ${credit_card_preference}    ${credit_card_type}    ${credit_card_expiry_date}
    Verify Actual Value Matches Expected Value    ${credit_card_number_${identifier}}    ${credit_card_number}
    Verify Actual Value Matches Expected Value    ${credit_card_preference_${identifier}}    ${credit_card_preference}
    Verify Actual Value Matches Expected Value    ${credit_card_type_${identifier}}    ${credit_card_type}
    Verify Actual Value Matches Expected Value    ${credit_card_expiry_date_${identifier}[0]}    ${credit_card_expiry_date}

Select Hotel Segment
    [Arguments]    ${segment}
    Select Segment    ${segment}    [NAME:Request_HotelSegmentsCombobox]
    [Teardown]    Take Screenshot

Add Passenger Name
    [Arguments]    ${passenger_name}    ${age_group}    ${birth_date}=09SEP18    ${infant_name}=KATIE
    [Documentation]    Passenger Name: <Title> <First name> <Last Name>
    ...    Arguments: Passenger Name | Age Group = Adult
    ...
    ...    If Adult
    ...    List has 1 Passenger
    ...    Example: NM1CHARLES/LUKE MR
    ...
    ...    If Child
    ...    NM1PYM/HANK MSTR(CHD/28JUN08)
    ...
    ...    If Infant (needs accompanying Adult)
    ...    NM1MAXIMOFF/WANDA MRS(INF/SARA/09SEP18)
    @{passenger_name_list}    Split String    ${passenger_name}    ${SPACE}
    ${initial}=    Set Variable    ${passenger_name_list[0]}
    ${first_name}=    Set Variable    ${passenger_name_list[1]}
    ${last_name}=    Set Variable    ${passenger_name_list[2]}
    Run Keyword If    "${age_group.lower()}"=="adult"    Enter GDS Command    NM1${last_name.upper()}/${first_name.upper()} ${initial.upper()}(ADT)
    Run Keyword If    "${age_group.lower()}"=="child"    Enter GDS Command    NM1${last_name.upper()}/${first_name.upper()} ${initial.upper()}(CHD/${birth_date})
    Run Keyword If    "${age_group.lower()}"=="infant"    Enter GDS Command    NM1${last_name}/${first_name} ${initial}(INF/${infant_name}/${birth_date})

Add Multiple Passengers With Default Values
    Add Passenger Name    Mr Luke Charles    Adult
    Add Passenger Name    Mr Tony Stark    Adult
    Add Passenger Name    Mr Hank Pym    Child    26JUN12
    Add Passenger Name    Mrs Wanda Maximoff    Infant    09SEP18

Get Passenger Names
    ${passenger_list}=    Get Dropdown Values    [NAME:PassengerComboBox]
    Set Suite Variable    ${passenger_list}

Select Passenger
    [Arguments]    ${passenger_name}=${EMPTY}
    ${object}    Determine Multiple Object Name Based On Active Tab    PassengerComboBox    False
    Select Value From Dropdown List    ${object}    ${passenger_name}

Tick Air Segment
    [Arguments]    @{air_segments}
    ${is_checked}    Get Checkbox Status    [NAME:SelectAllCheckBox]
    Run Keyword If    '${is_checked}' == 'True'    Untick Checkbox    [NAME:SelectAllCheckBox]
    ${segment_num}    Create List
    : FOR    ${segment}    IN    @{air_segments}
    \    Click List Item    ${segment}    True
    \    ${segments}    Set Variable    0${segment}
    \    Append To List    ${segment_num}    ${segments}
    ${segment_number}    Evaluate    ''.join(${segment_num})
