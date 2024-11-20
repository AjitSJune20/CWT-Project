*** Settings ***
Resource          ../common/core.robot

*** Keywords ***
Add OBT Remark
    [Arguments]    ${obt_code}
    Enter GDS Command    RT    RM *BT/${obt_code}

Add Touch Level To Car Panel
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    Enter GDS Command    RM *BT/${obt_code}
    Enter GDS Command    RM *VFF34/${touch_level_code}/S${segment}

Book Active Car Segment
    [Arguments]    ${location}    ${pdate_num}=2    ${pdays_num}=0    ${rdate_num}=2    ${rdays_num}=1    ${car_vendor}=${EMPTY}
    ...    ${car_index}=${EMPTY}    ${car_type}=ICAR
    ${pickup_date} =    Set Departure Date X Months From Now In Gds Format    ${pdate_num}    ${pdays_num}
    ${return_date} =    Set Departure Date X Months From Now In Gds Format    ${rdate_num}    ${rdays_num}
    ${car_vendor_with_separator}    Set Variable If    "${car_vendor}" != "${EMPTY}"    /${car_vendor}    ${EMPTY}
    ${car_availability_command} =    Set Variable If    '${GDS_switch}' == 'amadeus'    CA${car_vendor}${location}${pickup_date}-${return_date}/ARR-1000-1200/VT-${car_type}    '${GDS_switch}' == 'apollo' or '${GDS_switch}' == 'galileo'    CAL${pickup_date}-${return_date}${location}/ARR-2P/DT-2P${car_vendor_with_separator}    '${GDS_switch}' == 'sabre'
    ...    CF${location}/${pickup_date}-${return_date}/0900-0900/ICAR
    ${car_sell_command} =    Set Variable If    '${GDS_switch}' == 'amadeus'    CS1    '${GDS_switch}' == 'apollo' or '${GDS_switch}' == 'galileo'    01A1    '${GDS_switch}' == 'sabre'
    ...    0C1
    Enter GDS Command    ${car_availability_command}    ${car_sell_command}
    Run Keyword If    "${car_index}" != "${EMPTY}"    Set Suite Variable    ${pickup_date_${car_index}}    ${pickup_date}

Book Active Car Segment X Month From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${identifier}=${EMPTY}    ${identifier}=${EMPTY}
    [Documentation]    For Amadeus GDS
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    Run Keyword If    "${GDS_switch}"=="amadeus"    Enter GDS Command    CSZL${city}${departure_date}-2/VT-ECMN/RC-B-/ARR-1000-1000
    Set Suite Variable    ${car_departure_date${identifier}}    ${departure_date}
    Set Suite Variable    ${car_city${identifier}}    ${city}

Book Active Hotel X Months From Now
    [Arguments]    ${city}=LON    ${property_code}=423    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    ...    ${checkin_identifier}=${EMPTY}    ${checkout_identifier}=${EMPTY}
    [Documentation]    Note: Property Code '423' is exclusive for LON city. Enter a new value as needed
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Set Suite Variable    ${checkin_date${checkin_identifier}}    ${departure_date}
    Set Suite Variable    ${checkout_date${checkout_identifier}}    ${arrival_date}
    Run Keyword If    "${GDS_switch}"=="amadeus"    Enter GDS Command    11AHSJT${city}${property_code} ${departure_date}-${arrival_date}/CF-123456/RT-A1D/RQ-GBP425.00

Book Amadeus Offer Retain Flight
    [Arguments]    ${optional_segment_number}=${EMPTY}    ${optional_selected_offer_number}=${EMPTY}
    Run Keyword If    '${optional_segment_number}' == '${EMPTY}'    Enter GDS Command    FXD
    ...    ELSE    Enter GDS Command    FXD/${optional_segment_number}
    : FOR    ${index}    IN RANGE    0    5
    \    Enter GDS Command    MD
    Run Keyword If    '${optional_selected_offer_number}' == '${EMPTY}'    Enter GDS Command    OFS/A1
    ...    ELSE    Enter GDS Command    OFS/A${optional_selected_offer_number}

Book Flight X Months From Now
    [Arguments]    ${itinerary}    ${seat_select}    ${store_fare}    ${number_of_months}=6    ${number_of_days}=0
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    ${number_of_days}
    Set Test Variable    ${departure_date}
    GDS Search Availability & Pricing (OW) With Given Departure Date In Months    AN${departure_date}${itinerary}    ${seat_select}    ${store_fare}

Book Flight X Months From Now With Requested Airline Without Pricing
    [Arguments]    ${itinerary}    ${seat_select}    ${number_of_months}=6    ${number_of_days}=0
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    ${number_of_days}
    Set Test Variable    ${departure_date}
    ${itinerary}=    Generate GDS Search Availability & Pricing    ${itinerary}    ${departure_date}
    Enter GDS Command    ${itinerary}    ${seat_select}

Book Flight X Months From Now Without Pricing
    [Arguments]    ${itinerary}    ${seat_select}    ${number_of_months}=6    ${number_of_days}=0
    Activate Power Express Window
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${number_of_months}    ${number_of_days}
    Set Test Variable    ${departure_date}
    ${itinerary}=    Generate GDS Search Availability & Pricing    ${itinerary}    ${departure_date}
    Enter GDS Command    ${itinerary}    ${seat_select}

Book Hotel Segment
    [Arguments]    ${hotel_itinerary}    ${select_hotel}    ${select_rate}    ${store_hotel_rate}
    ${checkin_date} =    Set Departure Date X Months From Now In Gds Format    3    1
    ${checkout_date} =    Set Departure Date X Months From Now In Gds Format    3    2
    ${checkout_date}    Get Substring    ${checkout_date}    0    2
    Enter GDS Command    HA${hotel_itinerary}${checkin_date}-${checkout_date}
    Sleep    5
    Enter GDS Command    ${select_hotel}
    Sleep    2
    Enter GDS Command    ${select_rate}
    Sleep    2
    Enter GDS Command    ${store_hotel_rate}

Book One Way Flight X Months From Now
    [Arguments]    ${city_pair}    ${number_of_month}
    ${seat_select_command}    Set Variable If    '${gds_switch}' != 'amadeus'    01Y1    SS1Y1
    ${store_fare_command}    Set Variable If    '${gds_switch}' == 'sabre'    WPRQ    '${gds_switch}' == 'amadeus'    FXP    '${gds_switch}' == 'apollo'
    ...    T:$B    '${gds_switch}' == 'galileo'    FQ
    Book Flight X Months From Now    ${city_pair}    ${seat_select_command}    ${store_fare_command}    ${number_of_month}

Book Passive Car Segment X Months From Now
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10    ${car_index}=${EMPTY}
    ...    ${car_charged_rate}=100.00    ${car_currency}=USD    ${car_vendor_code}=EP    ${car_vendor_name}=EUROPCAR    ${car_type}=CCMR    ${car_rate_type}=DAILY
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Run Keyword If    "${GDS_switch}"=="amadeus"    Enter GDS Command    CU1AHK1${city}${departure_date}-${arrival_date}${car_type}/SUC-${car_vendor_code}/SUN-${car_vendor_name}/SD-23NOV/ST-1700/ED-24nov/ET-1700/TTL-${car_charged_rate}${car_currency}/DUR-${car_rate_type}/MI-50KM FREE/CF-FAKE
    ...    ELSE    Enter GDS Command    0CARZIGK1${city}${departure_date}-${arrival_date}/ICAR/RG-USD35.99/CF-ABC123
    Run Keyword If    "${car_index}" != "${EMPTY}"    Set Suite Variable    ${pickup_date_${car_index}}    ${departure_date}

Book Passive Car Segment X Months From Now With RG/RQ And TTL Block
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10    ${car_index}=${EMPTY}
    ...    ${car_charged_rate}=100.00    ${car_currency}=USD    ${car_vendor_code}=EP    ${car_vendor_name}=EUROPCAR    ${car_type}=CCMR    ${car_rate_type}=DAILY
    ...    ${identifier}=RG    ${car_rate_type_code}=DY    ${are_all_blocks_included}=0
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Run Keyword If    "${GDS_switch}"=="amadeus" and '${are_all_blocks_included}'=='0'    Enter GDS Command    CU1AHK1${city}${departure_date}-${arrival_date}${car_type}/SUC-${car_vendor_code}/SUN-${car_vendor_name}/SD-23NOV/ST-1700/ED-24nov/ET-1700/TTL-${car_charged_rate}${car_currency}/DUR-${car_rate_type}/${identifier}-${car_currency}${car_charged_rate}-${car_rate_type_code}/MI-50KM FREE/CF-FAKE
    ...    ELSE IF    "${GDS_switch}"=="amadeus" and '${are_all_blocks_included}'=='1'    Enter GDS Command    CU1AHK1${city}${departure_date}-${arrival_date}${car_type}/SUC-${car_vendor_code}/SUN-${car_vendor_name}/SD-23NOV/ST-1700/ED-24nov/ET-1700/TTL-${car_charged_rate}${car_currency}/DUR-${car_rate_type}/RG-${car_currency}${car_charged_rate}-${car_rate_type_code}/RQ-${car_currency}${car_charged_rate}-${car_rate_type_code}/MI-50KM FREE/CF-FAKE
    ...    ELSE    Enter GDS Command    0CARZIGK1${city}${departure_date}-${arrival_date}/ICAR/RG-USD35.99/CF-ABC123
    Run Keyword If    "${car_index}" != "${EMPTY}"    Set Suite Variable    ${pickup_date_${car_index}}    ${departure_date}

Book Passive Car Segment X Months From Now With RG/RQ Block
    [Arguments]    ${city}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10    ${car_index}=${EMPTY}
    ...    ${car_charged_rate}=100.00    ${car_currency}=USD    ${car_vendor_code}=EP    ${car_vendor_name}=EUROPCAR    ${car_type}=CCMR    ${car_rate_type}=DAILY
    ...    ${identifier}=RG    ${car_rate_type_code}=DY
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Run Keyword If    "${GDS_switch}"=="amadeus"    Enter GDS Command    CU1AHK1${city}${departure_date}-${arrival_date}${car_type}/SUC-${car_vendor_code}/SUN-${car_vendor_name}/SD-23NOV/ST-1700/ED-24nov/ET-1700/DUR-${car_rate_type}/${identifier}-${car_currency}${car_charged_rate}-${car_rate_type_code}/MI-50KM FREE/CF-FAKE
    ...    ELSE    Enter GDS Command    0CARZIGK1${city}${departure_date}-${arrival_date}/ICAR/RG-USD35.99/CF-ABC123
    Run Keyword If    "${car_index}" != "${EMPTY}"    Set Suite Variable    ${pickup_date_${car_index}}    ${departure_date}

Book Passive Flight X Months From Now
    [Arguments]    ${city_pair}    ${airline_code}=QR    ${departure_months}=6    ${departure_days}=0
    [Documentation]    For Amadeus
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    Run Keyword If    "${GDS_switch}"=="amadeus"    Enter GDS Command    SS ${airline_code}1074 Y ${departure_date} ${city_pair} GK5 / 11551440 / ABCDEFG

Book Passive Hotel Segment X Months From Now
    [Arguments]    ${city}    ${hotel_details}    ${departure_months}=6    ${departure_days}=0    ${arrival_months}=6    ${arrival_days}=10
    ...    ${checkin_identifier}=${EMPTY}    ${checkout_identifier}=${EMPTY}
    Wait Until Keyword Succeeds    60    2    Verify Progress Info Window is Not Active
    ${departure_date} =    Set Departure Date X Months From Now In Gds Format    ${departure_months}    ${departure_days}
    ${arrival_date} =    Set Departure Date X Months From Now In Gds Format    ${arrival_months}    ${arrival_days}
    Set Test Variable    ${departure_date}
    Set Test Variable    ${arrival_date}
    Set Suite Variable    ${checkin_date${checkin_identifier}}    ${departure_date}
    Set Suite Variable    ${checkout_date${checkout_identifier}}    ${arrival_date}
    Run Keyword If    "${gds_switch}"=="amadeus"    Enter GDS Command    HU1AHK1${city}${departure_date}-${arrival_date}/${hotel_details}
    ...    ELSE    Enter GDS Command    0HTLMXMK1${city}${departure_date}-OUT${arrival_date}/P-59240/R-SGLB/W-MOTEL 6 MINNEAPOLIS-BROO¤2741 FREEWAY BLVD¤BROOKLYN CENTER MN¤US¤55430¤763-560-9789/**ITB-SGLB/RT-79.00/PC59240**/CF-ABC123

Book Segmented One Way Flight X Months From Now
    [Arguments]    ${city_pair}    ${segment_number}=${EMPTY}    ${number_of_month}=6
    Run Keyword If    '${GDS_switch}' == 'sabre' and '${segment_number}' != '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    WP${segment_number}'RQ    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'sabre' and '${segment_number}' == '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    WPRQ    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'amadeus' and '${segment_number}' != '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    SS1Y1    FXP/${segment_number}    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'amadeus' and '${segment_number}' == '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    SS1Y1    FXP    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'apollo' and '${segment_number}' != '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    T:$B${segment_number}    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'apollo' and '${segment_number}' == '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    T:$B    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'galileo' and '${segment_number}' != '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    FQ${segment_number}    ${number_of_month}
    Run Keyword If    '${GDS_switch}' == 'galileo' and '${segment_number}' == '${EMPTY}'    Book Flight X Months From Now    ${city_pair}    01Y1    FQ    ${number_of_month}

Cancel Stored Fare and Segment
    [Arguments]    ${segment_line_number}=${EMPTY}
    Run Keyword If    '${GDS_switch}' == 'apollo'    Enter GDS Command    XT    XI
    ...    ELSE IF    '${GDS_switch}' == 'amadeus'    Enter GDS Command    TTE/ALL    XE${segment_line_number}

Click GDS Screen Tab
    Activate Power Express Window
    Select Gds Screen Tab

Delete Air Segment
    [Arguments]    ${segment}
    ${delete_air_segment_command} =    Set Variable If    '${GDS_switch}' == 'sabre'    XI${segment}    '${GDS_switch}' == 'apollo' or '${GDS_switch}' == 'galileo'    X${segment}    '${GDS_switch}' == 'amadeus'
    ...    XE${segment}
    Enter GDS Command    ${delete_air_segment_command}

Delete All Segments
    Enter GDS Command    XI

Delete Amadeus Offer
    [Arguments]    ${offer_number}
    Enter GDS Command    RTOF    ${offer_number}

Delete Fare Quote and Flight Segment
    [Arguments]    ${cancel_fare}    ${cancel_segment}
    Enter GDS Command    ${cancel_fare}    ${cancel_segment}

Delete LCC Remarks
    ${lcc_remarks}    Get Lines Containing String    ${pnr_details}    LCC
    Should Not Be Empty    ${lcc_remarks}    Could Not Find LCC Remark Lines
    ${actual_lcc_remarks}    Split To Lines    ${lcc_remarks}
    ${first_lcc_line}    Get From List    ${actual_lcc_remarks}    0
    ${last_lcc_line}    Get From List    ${actual_lcc_remarks}    -1
    ${first_lcc_line_number}    Fetch From Left    ${first_lcc_line}    .
    ${last_lcc_line_number}    Fetch From Left    ${last_lcc_line}    .
    ${first_lcc_line_number}    Remove All Spaces    ${first_lcc_line_number}
    ${last_lcc_line_number}    Remove All Spaces    ${last_lcc_line_number}
    ${delete_lcc_remarks_command}    Set Variable If    '${gds_switch}' == 'sabre'    5${first_lcc_line_number}-${last_lcc_line_number}¤    '${gds_switch}' == 'apollo'    c:${first_lcc_line_number}-${last_lcc_line_number}¤:5    Invalid
    Run Keyword If    '${delete_lcc_remarks_command}'!= 'Invalid'    Enter GDS Command    ${delete_lcc_remarks_command}
    ...    ELSE    Log    Unsupported GDS    WARN

Delete Remarks For FF And VFF
    [Arguments]    ${vff}    ${segment}
    : FOR    ${INDEX}    IN RANGE    5
    \    Retrieve PNR Details From Amadeus    command=RTY    refresh_needed=False
    \    ${number}    Run Keyword If    "${vff}" == "FF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    \    ...    ELSE IF    "${vff}" == "FF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    \    ...    ELSE IF    "${vff}"== "VFF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    \    ...    ELSE IF    "${vff}"== "VFF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    \    Enter GDS Command    XE${number}
    \    ${data}    Get Data From GDS Screen    RFCWTPTEST    True
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Delete Ticket Remarks in the PNR
    [Arguments]    ${start_remark}    ${end_remark}
    : FOR    ${INDEX}    IN RANGE    20
    \    Retrieve PNR Details From Sabre Red    ${current_pnr}
    \    ${first_number}    Get Line Number In PNR Remarks    ${start_remark}
    \    ${last_number}    Get Line Number In PNR Remarks    ${end_remark}
    \    Enter GDS Command    5${first_number}-${last_number}¤
    \    Enter Specific Command On Native GDS    ER
    \    Get Clipboard Data
    \    ${is_simultaneous_exist}    Run Keyword And Return Status    Should Contain    ${data_clipboard.upper()}    SIMULT
    \    Send    ER
    \    Get Clipboard Data
    \    ${is_simultaneous_exist2}    Run Keyword And Return Status    Should Contain    ${data_clipboard.upper()}    SIMULT
    \    Exit For Loop If    ${is_simultaneous_exist} == False or ${is_simultaneous_exist2} == False
    Send    I

Enter Exchange Command X Fare
    [Arguments]    ${fare_tab}    ${pa_amount}=150.00    ${ea_amount}=150.00    ${nf_amount}=3059.80
    ${fare_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${writting_command}    Set Variable If    "${fare_tab.upper()}" == "FARE 1"    5X/    5T/TKT${fare_index}
    Enter GDS Command    5T‡EXCH${fare_index}
    Enter GDS Command    ${writting_command}-IRP1/PA-${pa_amount}/CA-0.00/EA-${ea_amount}/NF-${nf_amount}

Enter GDS Command
    [Arguments]    @{gds_command_value}
    Activate Power Express Window
    : FOR    ${gds_command}    IN    @{gds_command_value}
    \    ${gds_command}    Replace String    ${gds_command}    {ENTER}    ${EMPTY}
    \    Set Control Text Value    ${cbo_gdscommandline}    ${gds_command}
    \    Control Focus    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}
    \    Control Click    ${title_power_express}    ${EMPTY}    ${btn_GDScommand}    ${EMPTY}
    \    Send    {ENTER}
    \    Wait Until Keyword Succeeds    60    1    Verify Field Is Empty    ${cbo_gdscommandline}

GDS Search Availability & Pricing (OW) With Given Departure Date In Months
    [Arguments]    ${itinerary}    ${seat_select_value}    ${store_fare_value}=${EMPTY}
    Activate Power Express Window
    ${itinerary}=    Generate GDS Search Availability & Pricing    ${itinerary}    ${departure_date}
    ${gds_screen_data}    Get Data From GDS Screen    ${itinerary}
    Run Keyword If    "${gds_switch}" == "amadeus"    Should Not Contain Any    ${gds_screen_data}    NO FLIGHT    msg=Cannot book due to "NO FLIGHT"
    ${seat_select_result}    Get Data From GDS Screen    ${seat_select_value}    apply_current_screen_only=True
    ${is_seat_select_delayed}    Run Keyword And Return Status    Should Contain    ${seat_select_result}    ${seat_select_value}
    ${seat_select_result}    Run Keyword If    ${is_seat_select_delayed}    Get Data From GDS Screen    ${seat_select_value}
    ...    ELSE    Set Variable    ${seat_select_result}
    ${is_seat_select_valid}    Run Keyword And Return Status    Should Not Contain Any    ${gds_screen_data}    CHECK CLASS OF SERVICE
    Run Keyword If    not ${is_seat_select_valid} and "${gds_switch}" == "amadeus"    Enter GDS Command    SS1J1
    Run Keyword If    "${store_fare_value}" != "${EMPTY}"    Get Data From GDS Screen    ${store_fare_value}    True
    Run Keyword If    "${gds_switch}" == "amadeus"    Should Not Contain Any    ${gds_screen_data}    CHECK SEGMENT NUMBER    BEST BUY REQUEST REJECTED DUE TO MARRIED SEGMENT CONTROL    PRICING REQUEST REJECTED DUE TO MARRIED SEGMENT CONTROL
    Run Keyword If    '${gds_switch}' == 'amadeus' and "${store_fare_value}" != "${EMPTY}" and "${store_fare_value}" != "FXA"    Run Keyword And Ignore Error    Enter GDS Command    FXT01/P1    FXT01/P1
    ...    ELSE IF    '${GDS_switch}' == 'amadeus' and "${store_fare_value}" != "${EMPTY}" and "${store_fare_value}" == "FXA"    Enter GDS Command    FXU1
    ${gds_screen_data}    Get Data From GDS Screen    apply_current_screen_only=True
    Should Not Contain Any    ${gds_screen_data}    NO COMBINABLE FARES FOR CLASS USED    NO FARES/RBD/CARRIER/PASSENGER TYPE    SPECIFY CARRIER /CHECK LIST    VERIFIER LE NMERO DU SEGMENT    ITINERAIRE NECESSAIRE
    ...    ENTREE NON AUTORISEE DANS LES CONDITIONS NHP    NO VALID FARE FOR INPUT CRITERIA    NOMS NECESSAIRES    CHECK LINE NUMBER    NEED ITINERARY    ENTRY NOT ALLOWED IN NHP CONDITIONS
    ...    NO CURRENT FARE IN SYSTEM    msg=Fare quote should be successful to proceed. Change the itinerary date${\n}Response is : ${gds_screen_data}    values=False
    [Teardown]

Generate GDS Search Availability & Pricing
    [Arguments]    ${itinerary}    ${date}
    ${transaction_code}    ${indicator}    Run Keyword If    "${GDS_switch.upper()}" == "AMADEUS"    Set Variable    AN    /A
    ...    ELSE IF    "${GDS_switch.upper()}" == "SABRE"    Set Variable    1    ¥
    ...    ELSE IF    "${GDS_switch.upper()}" == "GALILEO"    Set Variable    A    /
    ...    ELSE IF    "${GDS_switch.upper()}" == "APOLLO"    Set Variable    A    -
    ${handle_churning?} =    Run Keyword And Return Status    Should Contain    ${itinerary}    ${indicator}
    ${apollo_handle_churning?} =    Run Keyword And Return Status    Should Contain    ${itinerary}    +
    ${sabre_handle_churning?} =    Run Keyword And Return Status    Should Contain    ${itinerary}    ‡
    ${sabre_handle_churning2?} =    Run Keyword And Return Status    Should Contain    ${itinerary}    ¤
    ${itinerary} =    Remove String    ${itinerary}    AN${date}
    ${city_pair} =    Get Substring    ${itinerary}    \    6
    Set Test Variable    ${city_pair}
    ${churning_airlines} =    Decode Bytes To String    ${churning_airlines_${GDS_switch}}    UTF-8
    ${itinerary} =    Run Keyword If    ${handle_churning?} == False and ${apollo_handle_churning?} == False and ${sabre_handle_churning?} == False and ${sabre_handle_churning2?} == False    Set Variable    ${transaction_code}${date}${itinerary}${churning_airlines}
    ...    ELSE    Set Variable    ${transaction_code}${date}${itinerary}
    [Return]    ${itinerary}

Get AT Id
    ${at_id} =    Get Control Text Value    [NAME:txtCRS]
    ${at_id} =    Get Lines Containing String    ${at_id}    IN REMOTE OFFICE
    ${at_id} =    Fetch From Left    ${at_id}    IN REMOTE
    ${at_id} =    Fetch From Right    ${at_id}    -
    ${at_id} =    Set Variable    ${at_id.strip()}
    Set Suite Variable    ${at_id}

Get Data From GDS Screen
    [Arguments]    ${command}=${EMPTY}    ${apply_current_screen_only}=False    ${gds}=${EMPTY}
    Click GDS Screen Tab
    Run Keyword If    "${command}" != "${EMPTY}"    Enter GDS Command    ${command}
    ${gds_screen_data_raw}    Get Control Text Value    [NAME:txtCRS]
    @{splitted_data}    Split To Lines    ${gds_screen_data_raw}
    @{data}    Set Variable    ${splitted_data[-24:]}
    ${gds_screen_data_current}    Run Keyword If    '${gds}' == 'sabre'    Get Latest Command Response    ${splitted_data}    ${gds}
    ...    ELSE    Get Latest Command Response    ${data}    ${gds}
    ${gds_screen_data}    Set Variable If    "${apply_current_screen_only}" == "True" or "${gds}" == "sabre"    ${gds_screen_data_current}    ${gds_screen_data_raw}
    Set Suite Variable    ${gds_screen_data}
    Log    ${gds_screen_data}
    [Return]    ${gds_screen_data}

Get FA Line Number
    [Arguments]    ${current_pnr}
    Enter GDS Command    RT${current_pnr}
    ${fa_line_number}    Create List
    ${clip}    Get Data From GDS Screen    RTTN    True
    ${fa_line}    Get Lines Using Regexp    ${clip}    FA PAX|FHE PAX
    ${fa_lines}    Split To Lines    ${fa_line}
    : FOR    ${fa_line}    IN    @{fa_lines}
    \    ${splitted}    Split String    ${fa_line}    ${SPACE}
    \    Append To List    ${fa_line_number}    ${splitted[0].strip()}
    \    Comment    ${line_number}    Fetch From Left    ${fa_line}    FA
    Set Suite Variable    ${fa_line_number}
    [Return]    ${fa_line_number}

Get FA Ticket Number
    [Arguments]    ${data_clip}
    ${ticket_number_raw}    Get Lines Containing String    ${data_clip}    FA PAX
    ${ticket_number_raw}    Get Lines Containing String    ${data_clip}    FA
    ${ticket_number_raw}    Fetch From Left    ${ticket_number_raw}    /
    ${ticket_number_raw}    Fetch From Right    ${ticket_number_raw}    FA PAX
    ${ticket_number_raw}    Fetch From Right    ${ticket_number_raw}    FA
    ${ticket_number_raw}    Remove String    ${ticket_number_raw}    -
    ${ticket_number_raw}    Remove String    ${ticket_number_raw}
    Set Suite Variable    ${ticket_number}    ${ticket_number_raw.strip()}

Get Line Number For Remark FF VFF
    [Arguments]    ${vff}    ${segment}
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    ${number}    Run Keyword If    "${vff}" == "FF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    ...    ELSE IF    "${vff}" == "FF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    ...    ELSE IF    "${vff}"== "VFF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    ...    ELSE IF    "${vff}"== "VFF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    Comment    ${number2}    Run Keyword If    ${vff} == "FF35"    Get Line Number In Amadeus PNR Remarks    ${ff}/AMA/S${segment}
    Comment    ${number3}    Run Keyword If    ${vff} == "VFF34"    Get Line Number In Amadeus PNR Remarks    ${ff}/AB/S${segment}
    Comment    ${number4}    Run Keyword If    ${vff} == "VFF35"    Get Line Number In Amadeus PNR Remarks    ${ff}/AMA/S${segment}
    Log    ${number}
    [Return]    ${number}

Get Total Fare From Amadeus
    [Arguments]    ${segment_number}    ${fare_tab}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Clear Data From Clipboard
    Activate Amadeus Selling Platform
    Enter GDS Command    RT    TQT/${segment_number}
    Get Clipboard Data Amadeus
    ${total_fare_raw}    Get Lines Containing String    ${data_clipboard}    GRAND TOTAL
    ${currency}    Get Substring    ${total_fare_raw}    12    16
    ${grand_total_fare}    Remove All Non-Integer (retain period)    ${total_fare_raw}
    ${contains_period}    Run Keyword And Return Status    Should Contain    ${grand_total_fare}    .
    ${grand_total_fare}    Convert To Float    ${grand_total_fare}
    Set Test Variable    ${currency_${fare_tab_index}}    ${currency}
    Set Test Variable    ${grand_total_fare_${fare_tab_index}}    ${grand_total_fare}
    Send    RT{ENTER}
    Send    {SHIFTDOWN}{PAUSE}{SHIFTUP}

Issue Ticket In Amadeus Training
    Enter GDS Command    RT${pt_pnr}
    ${data_clip}    Get Data From GDS Screen
    Should Contain    ${data_clip}    *TRN*
    Enter GDS Command    TTP/ET/RT
    ${data_clip}    Get Data From GDS Screen
    Should Not Contain Any    ${data_clip}    FOP RJT: INVALID CVV NUMBER - CHECK THE NUMBER AND TRY AGAIN
    Should Contain    ${data_clip}    OK ETICKET
    Enter GDS Command    RTF
    ${data_clip}    Get Data From GDS Screen
    Get FA Ticket Number    ${data_clip}
    End And Retrieve PNR    False
    Enter GDS Command    IG

Search Low Fare Calculation
    [Arguments]    ${search_low_fare_command}    ${select_low_fare_segment}    ${store_low_fare}    ${cancel_uneccessary_segment}=X1-2
    Enter GDS Command    ${search_low_fare_command}
    Enter GDS Command    ${select_low_fare_segment}
    Enter GDS Command    ${store_low_fare}
    Enter GDS Command    ${cancel_uneccessary_segment}

Update Remark FF VFF And Delete Segment Relate
    [Arguments]    ${vff}    ${segment}    ${touch_level_code}=${EMPTY}    ${obt_code}=${EMPTY}
    : FOR    ${INDEX}    IN RANGE    5
    \    Retrieve PNR Details From Amadeus    command=RTY    refresh_needed=False
    \    ${number}    Run Keyword If    "${vff}" == "FF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    \    ...    ELSE IF    "${vff}" == "FF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    \    ...    ELSE IF    "${vff}"== "VFF34"    Get Line Number In Amadeus PNR Remarks    ${vff}/AB/S${segment}
    \    ...    ELSE IF    "${vff}"== "VFF35"    Get Line Number In Amadeus PNR Remarks    ${vff}/AMA/S${segment}
    \    Enter GDS Command    XE${number}
    \    Run Keyword If    "${vff}" == "FF34"    Enter GDS Command    RM *${vff}/${touch_level_code}/${segment}
    \    ...    ELSE IF    "${vff}" == "FF35"    Enter GDS Command    RM *${vff}/${obt_code}
    \    ...    ELSE IF    "${vff}"== "VFF34"    Enter GDS Command    RM *${vff}/${touch_level_code}
    \    ...    ELSE IF    "${vff}"== "VFF35"    Enter GDS Command    RM *${vff}/${obt_code}
    \    ${data}    Get Data From GDS Screen    RFCWTPTEST    True
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR

Void Ticket Number For Amadeus
    [Arguments]    ${current_pnr}
    ${fa_line_number}    Get FA Line Number    ${current_pnr}
    : FOR    ${line_number}    IN    @{fa_line_number}
    \    ${clip}    Get Data From GDS Screen    TRDC/L${line_number}
    \    Should Contain Any    ${clip}    OK - DOCUMENT    REJECTED - DOCUMENT ALREADY CANCELLED
    #${clip}    Get Data From GDS Screen    RTTN    True
    #Should Contain Any    ${clip}    AUCUN ELEMENT TROUVE    NO ELEMENT FOUND    ES WURDE KEIN ELEMENT GEFUNDEN

Book Car Segment Using Default Vaues
    Book Passive Car Segment X Months From Now    HKG    4    4    4    5
    Book Active Car Segment    JFK    car_vendor=ZE    pdays_num=3    rdays_num=4

Book Hotel Segment Using Default Values
    Book Active Hotel    JT    LON    423    7    3    123456
    ...    A1D    GBP425.00    hotel 1
    Book Passive Hotel    LON    8    3    PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED    hotel 2

Book Air Segment Using Default Values
    [Arguments]    ${country}
    Run Keyword If    "${country}" == "HK"    Book One Way Flight X Months From Now    HKGMNL/APR    6
    Run Keyword If    "${country}" == "SG"    Book One Way Flight X Months From Now    SINMNL/ASQ    6
    Run Keyword If    "${country}" == "IN"    Book One Way Flight X Months From Now    DELAUH/AEY    6

Book Active Hotel
    [Arguments]    ${hotel_code}    ${city_code}    ${last_three_chars_property_code}    ${checkin_date_in_month}    ${checkout_date_in_days}    ${confirmation_number}
    ...    ${room_type}    ${rate_code}    ${identifier}=${EMPTY}
    [Documentation]    Sample Usage:
    ...    \ \ 11AHSJTLON423 04MAR-06MAR/CF-123456/RT-A1D/RQ-GBP425.00
    ...
    ...    Where:
    ...
    ...    JT \ = <hotel_code> of JUMEIRAH CARLTON TOWER
    ...
    ...    LON \ = <city_code> of London
    ...
    ...    423 \ = \ last 3 chars of property code
    ...
    ...    04MAR \ = checkin in date
    ...
    ...    06MAR \ = check out date
    ...
    ...    CF-123456 = CF-<confirmation_number>
    ...
    ...    RT-A1D \ \ = RT-<room_type>
    ...
    ...    RQ-GBP425.00 \ = RQ-<rate_quote>
    ...
    ...
    ...    Implementation Reference: http://www.amadeus.com/web/binaries/blobs/762/623/Training_Manual_1A_PK.pdf
    ${checkin_date_ddmmm}    Set Departure Date X Months From Now In Gds Format    ${checkin_date_in_month}
    ${checkout_date_ddmmm}    Set Departure Date X Months From Now In Gds Format    ${checkin_date_in_month}    ${checkout_date_in_days}
    ${checkin_date_syex}    Generate Date X Months From Now    ${checkin_date_in_month}    0    %d/%m/%Y
    ${checkout_date_syex}    Generate Date X Months From Now    ${checkin_date_in_month}    ${checkout_date_in_days}    %d/%m/%Y
    Enter GDS Command    11AHS${hotel_code}${city_code} ${last_three_chars_property_code} ${checkin_date_ddmmm}-${checkout_date_ddmmm} /CF-${confirmation_number}/RT-${room_type}/RQ-${rate_code}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkin_date_ddmmm_${identifier}}    ${checkin_date_ddmmm}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkout_date_ddmmm_${identifier}}    ${checkout_date_ddmmm}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkin_date_syex_${identifier}}    ${checkin_date_syex}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkout_date_syex_${identifier}}    ${checkout_date_syex}

Book Passive Hotel
    [Arguments]    ${city_code}    ${checkin_date_in_month}    ${checkout_date_in_days}    ${free_text}    ${identifier}=${EMPTY}
    [Documentation]    HU1AHK1LON06MAR-06MAR/PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED
    ${checkin_date_ddmmm}    Set Departure Date X Months From Now In Gds Format    ${checkin_date_in_month}
    ${checkout_date_ddmmm}    Set Departure Date X Months From Now In Gds Format    ${checkin_date_in_month}    ${checkout_date_in_days}
    ${checkin_date_syex}    Generate Date X Months From Now    ${checkin_date_in_month}    0    %d/%m/%Y
    ${checkout_date_syex}    Generate Date X Months From Now    ${checkin_date_in_month}    ${checkout_date_in_days}    %d/%m/%Y
    Enter GDS Command    HU1AHK1${city_code} ${checkin_date_ddmmm} -${checkout_date_ddmmm}/${free_text}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkin_date_ddmmm_${identifier}}    ${checkin_date_ddmmm}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkout_date_ddmmm_${identifier}}    ${checkout_date_ddmmm}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkin_date_syex_${identifier}}    ${checkin_date_syex}
    Run Keyword If    "${identifier}"!="${EMPTY}"    Set Suite Variable    ${checkout_date_syex_${identifier}}    ${checkout_date_syex}

Delete Segment Relate Remarks For ${type}
    @{car_remarks_list}    Create List    *VLF    *VRF    *VEC    *VFF30    *VCM
    @{air_remarks_list}    Create List    SF/    LF/    RF/    FOP/    FF7/
    ...    FF8/    FF30/    FF36/    FF38/    FF81/    EC/
    ...    PC/4    PC/0
    ${remark_type}    Set Variable If    "${type}" == "Air"    ${air_remarks_list}    ${car_remarks_list}
    : FOR    ${INDEX}    IN RANGE    5
    \    Retrieve PNR Details From Amadeus    command=RTY    refresh_needed=False
    \    @{line_numbers}    Get Line Numbers In Amadeus PNR Remarks    @{remark_type}
    \    ${line_numbers}    Evaluate    ",".join(${line_numbers})
    \    Enter GDS Command    XE${line_numbers}
    \    ${data}    Get Data From GDS Screen    RFCWTPTEST    True
    \    ${is_not_simult_parallel}    Run Keyword And Return Status    Should Not Contain Any    SIMULT    PARALLEL
    \    Exit For Loop If    ${is_not_simult_parallel}
    Enter GDS Command    ER    ER    IR
