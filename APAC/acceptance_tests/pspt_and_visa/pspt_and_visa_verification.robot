*** Settings ***
Resource          ../../resources/panels/pspt_and_visa.robot

*** Keywords ***
Verify Check Visa Requirements Button Is Disabled
    Verify Control Object Is Disabled    [NAME:cmdRefreshTimatic]

Verify Countries Visited
    [Arguments]    @{expected_countries_visited}
    @{countries_visited} =    Get Countries Visited
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${countries_visited}    ${expected_countries_visited}
    [Teardown]    Take Screenshot

Verify Country Of Residence Contains Expected Value
    [Arguments]    ${expected_country_of_residence}
    Verify Control Object Text Value Is Correct    [NAME:ccboCountryResidence]    ${expected_country_of_residence}
    [Teardown]    Take Screenshot

Verify Country Of Residence Is Not Pre-Populated
    Verify Field Is Empty    [NAME:ccboCountryResidence]
    [Teardown]    Take Screenshot

Verify Domestic Trip Checkbox Is Ticked
    ${checkbox_status}    Get Checkbox State    ${check_box_domestic_trip}
    Should Be True    ${checkbox_status} == True    msg=Checkbox status should be TICKED
    [Teardown]    Take Screenshot

Verify Domestic Trip Checkbox Is Unticked
    ${checkbox_status}    Get Checkbox State    ${check_box_domestic_trip}
    Should Be True    ${checkbox_status} == False    msg=Checkbox status should be UNTICKED
    [Teardown]    Take Screenshot

Verify ESTA Header In The Lower Right Section Is Displayed
    [Arguments]    ${header}
    Verify Control Object Text Value Is Correct    [NAME:grpESTA]    ${header}
    [Teardown]    Take Screenshot

Verify ESTA/ETA Warning Message Is Displayed
    [Arguments]    ${warning_message}
    Verify Control Object Text Contains Expected Value    [NAME:rtxtESTA]    ${warning_message}
    [Teardown]    Take Screenshot

Verify Is Doc Valid? Field Contains Expected Value
    [Arguments]    ${expected_is_doc_valid}    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Verify Control Object Text Value Is Correct    [NAME:ccboPassportValid${row_number}]    ${expected_is_doc_valid}
    [Teardown]    Take Screenshot

Verify Is Doc Valid? Field Is Not Pre-Populated
    [Arguments]    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Verify Field Is Empty    [NAME:ccboPassportValid${row_number}]
    [Teardown]    Take Screenshot

Verify Journey Type Contains Expected Value
    [Arguments]    ${country}    ${expected_value}
    Get Journey Type Text Value    ${country}
    Should Be Equal As Strings    ${expected_value}    ${journey_type_value}

Verify Passport & Visa Info Panel Is Displayed
    Verify Control Object Is Visible    [NAME:PassportVisaInfo]
    Verify Control Object Is Visible    [NAME:txtPassportVisaInfo]
    [Teardown]    Take Screenshot

Verify Passport & Visa Info Panel Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:PassportVisaInfo]
    Verify Control Object Is Not Visible    [NAME:txtPassportVisaInfo]
    [Teardown]    Take Screenshot

Verify Passport And Visa Details
    ${pspt_visa_details}    Get Control Text Value    [NAME:txtPassportVisaInfo]
    : FOR    ${i}    IN RANGE    99
    \    ${object_status}    Is Control Visible    [NAME:ctxtCountries${i}]
    \    Exit For Loop If    not ${object_status}
    \    ${country}    Get Control Text Value    [NAME:ctxtCountries${i}]
    \    ${country}    Set Variable If    '${country}'=='United States'    USA    ${country}
    \    ${country}    Set Variable If    '${country}'=='Hong Kong'    Hong Kong (SAR China)    ${country}
    \    ${checkbox_status}    Get Checkbox Status    [NAME:cchkIsTransit${i}]
    \    ${detail_header}    Set Variable If    ${checkbox_status}    Transit    Destination
    \    Run Keyword And Continue On Failure    Should Contain    ${pspt_visa_details}    ${detail_header} ${country}
    [Teardown]    Take Screenshot

Verify Passport And Visa Information Remarks Are Not Written In The PNR
    [Arguments]    ${nationality}    ${passport_held}    ${visa_check}
    Verify Specific Line Is Not Written In The PNR    ********** PASSPORT AND VISA INFORMATION **********
    Verify Specific Line Is Not Written In The PNR    PASSPORT AND VISA INFORMATION
    Verify Specific Line Is Not Written In The PNR    TRAVELLERS NATIONALITY: ${nationality}
    Verify Specific Line Is Not Written In The PNR    VALID PASSPORT HELD: ${passport_held}
    Verify Specific Line Is Not Written In The PNR    VISA CHECK: {visa_check}
    Verify Specific Line Is Not Written In The PNR    FOR INTERNATIONAL TRAVEL PLEASE ENSURE YOUR PASSPORT IS
    Verify Specific Line Is Not Written In The PNR    VALID FOR MINIMUM 6 MONTHS AT TIME OF TRAVEL

Verify Passport Details Is Written Only Once In The PNR
    [Arguments]    @{passport_details}
    : FOR    ${exp_passport_detail}    IN    @{passport_details}
    \    ${is_found}    Run Keyword And Return Status    Verify Text Contains Expected Value X Times Only    ${pnr_details}    ${exp_passport_detail}    1
    \    Run Keyword if    "${is_found}" == "True"    Log    ${exp_passport_detail} Is Found In The List Values
    \    ...    ELSE    Fail    ${exp_passport_detail} Is Not Found In The List Values

Verify Pspt & Visa And APIS/SFPD Panels Are Shown For Non-Mindef
    Run Keyword And Continue On Failure    Verify Actual Panel Contains Expected Panel    Pspt and Visa
    Run Keyword And Continue On Failure    Verify Actual Panel Contains Expected Panel    APIS/SFPD

Verify Pspt And Visa Info Panel Contains Text
    [Arguments]    ${expected_text}
    Verify Text Contains Expected Value    ${passport_and_visa_info_text}    ${expected_text}

Verify Pspt And Visa Info Panel Does Not Contain Text
    [Arguments]    ${expected_text}
    Verify Text Does Not Contain Value    ${passport_and_visa_info_text}    ${expected_text}

Verify That Countries Visited And Visa Status Does Not Exist
    [Arguments]    ${country_visited}    ${expected_visa_status}
    Verify Control Object Is Visible    [NAME:grpVisa]
    Verify Control Object Is Visible    [NAME:pnlVisa]
    ${countries_visited_found}    Run Keyword And Return Status    Get Visa Status Row Number    ${country_visited}    ${visa_requirements}
    Should Not Be True    ${countries_visited_found}    ${country_visited} visited country is found.
    Comment    ${actual_visa_requirement_status}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ccboVisa${visa_status_row_number}]
    [Teardown]    Take Screenshot

Verify That Countries Visited And Visa Status Is Correct
    [Arguments]    ${country_visited}    ${expected_visa_status}
    Verify Control Object Is Visible    [NAME:grpVisa]
    Verify Control Object Is Visible    [NAME:pnlVisa]
    ${visa_status_row_number}    Get Visa Status Row Number    ${country_visited}    ${visa_requirements}
    ${actual_visa_requirement_status}    Control Get Text    ${title_power_express}    ${EMPTY}    [NAME:ccboVisa${visa_status_row_number}]
    [Teardown]    Take Screenshot

Verify Transit Checkbox Is Not Ticked
    [Arguments]    @{countries}
    : FOR    ${country}    IN    @{countries}
    \    ${index}    Get Field Index Using Country Name    ${country}
    \    Verify Checkbox Is Unticked    [NAME:cchkIsTransit${index}]

Verify Transit Checkbox Is Ticked
    [Arguments]    @{countries}
    : FOR    ${country}    IN    @{countries}
    \    ${index}    Get Field Index Using Country Name    ${country}
    \    Verify Checkbox Is Ticked    [NAME:cchkIsTransit${index}]

Verify Travel Document Details Are Correct
    [Arguments]    ${expected_document_type}    ${expected_nationality_citizenship}    ${expected_doc_number}    ${expected_expiry_date}    ${expected_doc_validity}    ${row_number}=0
    Verify Control Object Text Value Is Correct    [NAME:ccboDocumentType${row_number}]    ${expected_document_type}
    Verify Control Object Text Value Is Correct    [NAME:ccboNationality${row_number}]    ${expected_nationality_citizenship}
    Verify Control Object Text Value Is Correct    [NAME:ctxtPassportNumber${row_number}]    ${expected_doc_number}
    Verify Control Object Text Value Is Correct    [NAME:cdtpExpiryDate${row_number}]    ${expected_expiry_date}
    Verify Control Object Text Value Is Correct    [NAME:ccboPassportValid${row_number}]    ${expected_doc_validity}
    [Teardown]    Take Screenshot

Verify Visa Check Itinerary Remarks Are Written
    [Arguments]    ${check_ESTA_website}=True
    Click Panel    Pspt and Visa
    ${countries_visited}    Get Countries Visited
    ${selected_travel_doc}    Get Selected Use Document
    Get Travel Document Details    ${selected_travel_doc}
    ${list_length}    Get Length    ${countries_visited}
    ${list_length}    Evaluate    ${list_length} - 1
    Verify Specific Line Is Written In The PNR    RIR ********** PASSPORT AND VISA INFORMATION **********
    Verify Specific Line Is Written In The PNR    RIR PASSPORT AND VISA INFORMATION
    Verify Specific Line Is Written In The PNR    RIR TRAVELLERS NATIONALITY: ${nationality_${selected_travel_doc}.upper()}
    Verify Specific Line Is Written In The PNR    RIR VALID PASSPORT HELD: ${passport_valid_${selected_travel_doc}.upper()}
    : FOR    ${i}    IN RANGE    ${list_length}
    \    Get Visa Requirements    ${i}
    \    Get Transit Checkbox Status    ${i}
    \    Verify Specific Line Is Written In The PNR    RIR ${transit_status.upper()} VISA CHECK: ${visa_required_${i}.upper()}
    \    Verify Specific Line Is Written In The PNR    RIR COUNTRY: ${country_visited_${i}.upper()}
    \    Run Keyword If    '${country_visited_${i}.upper()}' =='UNITED STATES' and '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR UNITED STATES HTTPS://ESTA.CBP.DHS.GOV
    \    Run Keyword If    '${country_visited_${i}.upper()}' =='AUSTRALIA' and '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR AUSTRALIA HTTPS://WWW.ETA.IMMI.GOV.AU/ETAS3/ETAS
    \    Run Keyword If    '${country_visited_${i}.upper()}' =='CANADA' and '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR CANADA HTTP://WWW.CIC.GC.CA/ENGLISH/VISIT/ETA.ASP
    \    Run Keyword If    '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR IF YOU ARE TRAVELLING UNDER THE VISA WAIVER PROGRAM
    \    Run Keyword If    '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR YOU MUST SUBMIT AND RECEIVE
    \    Run Keyword If    '${check_esta_website.upper()}' == 'TRUE'    Verify Specific Line Is Written In The PNR    RIR AN ELECTRONIC AUTHORIZATION TO TRAVEL
    Verify Specific Line Is Written In The PNR    RIR FOR INTERNATIONAL TRAVEL PLEASE ENSURE YOUR PASSPORT IS
    Verify Specific Line Is Written In The PNR    RIR VALID FOR MINIMUM 6 MONTHS AT TIME OF TRAVEL
    Click GDS Screen Tab

Verify Visa Details Fields Are Displayed
    Verify Control Object Is Visible    [NAME:grpVisaDetails]
    Verify Control Object Is Visible    [NAME:ccboCountryResidence]

Verify Visa Details Section Is Not Displayed
    Run Keyword And Continue On Failure    Verify Control Object Is Not Visible    [NAME:grpVisaDetails]

Verify Visa Required Contains Expected Value
    [Arguments]    ${row_number}    ${expected_value}
    ${actual_value}    Get Visa Required    ${row_number}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${expected_value}    ${actual_value}
    [Teardown]    Take Screenshot

Verify Visa Required? Field Contains Expected Value
    [Arguments]    ${expected_visa_requirement}    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Verify Control Object Text Value Is Correct    [NAME:ccboVisa${row_number}]    ${expected_visa_requirement}
    [Teardown]    Take Screenshot

Verify Visa Required? Field Is Not Pre-Populated
    [Arguments]    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Verify Field Is Empty    [NAME:ccboVisa${row_number}]
    [Teardown]    Take Screenshot

Verify Visa Requirement Per Country
    [Arguments]    ${country}    ${visa_required}    ${journey_type}    ${transit_tick}    # ${transit_ticked} Tick or Untick
    [Documentation]    ${transit_ticked} Tick or Untick
    ${row_number}    Get Field Index Using Country Name    ${country}
    Run Keyword If    "${transit_tick.lower()}" == "tick"    Verify Checkbox Is Ticked    [NAME:cchkIsTransit${row_number}]
    ...    ELSE    Verify Checkbox Is Unticked    [NAME:cchkIsTransit${row_number}]
    Verify Control Object Text Value Is Correct    [NAME:ctxtCountries${row_number}]    ${country}
    Run Keyword If    "${visa_required}" != "${EMPTY}"    Verify Control Object Text Value Is Correct    [NAME:ccboVisa${row_number}]    ${visa_required}
    Run Keyword If    "${journey_type}" != "${EMPTY}"    Verify Control Object Text Value Is Correct    [NAME:ccboJourneyType${row_number}]    ${journey_type}

Verify Visa Requirements Fields Are Displayed
    Verify Control Object Is Visible    [NAME:grpVisa]
    Verify Control Object Is Visible    [NAME:ctxtCountries0]
    Verify Control Object Is Visible    [NAME:ccboVisa0]
    Verify Control Object Is Visible    [NAME:ccboJourneyType0]

Verify Visa Requirements Section Is Not Displayed
    Run Keyword And Continue On Failure    Verify Control Object Is Not Visible    [NAME:grpVisa]

Verify ESTA Section Is Not Displayed
    Run Keyword And Continue On Failure    Verify Control Object Is Not Visible    [NAME:grpESTA]
