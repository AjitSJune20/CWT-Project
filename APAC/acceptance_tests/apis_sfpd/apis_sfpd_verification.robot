*** Settings ***
Resource          ../../resources/panels/apis_sfpd.robot

*** Keywords ***
Verify APIS/SFPD Not Known Checkbox Is Unticked And Disabled
    Verify Checkbox Is Unticked    ${check_box_notknown}
    Verify Control Object Is Disabled    ${check_box_notknown}

Verify Apis Address Fields Are Displayed
    Verify Control Object Is Visible    [NAME:grpAPISAddress]
    Verify Control Object Is Visible    [NAME:chkAddress]
    Verify Control Object Is Visible    [NAME:cradHome]
    Verify Control Object Is Visible    [NAME:cradDestination]
    Verify Control Object Is Visible    [NAME:ctxtAddressStreet]
    Verify Control Object Is Visible    [NAME:ctxtAddressCity]
    Verify Control Object Is Visible    [NAME:ccboAddressCountry]
    Verify Control Object Is Visible    [NAME:ccboAddressStateCode]
    Verify Control Object Is Visible    [NAME:ctxtAddressZipCode]

Verify APIS/SFPD Address Remarks Is Not Written
    [Arguments]    ${segment_airline_code}    ${status_code}    ${address_type}    ${country}    ${street}    ${city}
    ...    ${state_code}    ${zip_code}    ${segment_relate}
    Verify Specific Line Is Not Written In The PNR    SSR DOCA ${segment_airline_code} ${status_code} ${address_type}/${country}/${street}/${city}/${state_code}/${zip_code}/${segment_relate}

Verify APIS/SFPD Address Remarks
    [Arguments]    ${segment_airline_code}    ${status_code}    ${address_type}    ${country}    ${street}    ${city}
    ...    ${state_code}    ${zip_code}    ${segment_relate}
    Verify Specific Line Is Written In The PNR    SSR DOCA ${segment_airline_code} ${status_code} ${address_type}/${country}/${street}/${city}/${state_code}/${zip_code}/${segment_relate}

Verify APIS Other Information And Visa Details Remarks Is Not Written
    [Arguments]    ${segment_airline_code}    ${status_code}    ${place_of_birth}    ${document_number}    ${place_of_issue}    ${issue_date}
    ...    ${country of visa}    ${country_of_residence}    ${city_of_residence}    ${segment_relate}
    Verify Specific Line Is Not Written In The PNR    SSR DOCO ${segment_airline_code} ${status_code} ${place_of_birth}/V/${document_number}/${place_of_issue}/${issue_date}/${country_of_visa}/${segment_relate}
    Verify Specific Line Is Not Written In The PNR    SSR DOCA ${segment_airline_code} ${status_code} R/${country_of_residence}/${city_of_residence}/${segment_relate}

Verify APIS Other Information And Visa Details Remarks
    [Arguments]    ${segment_airline_code}    ${status_code}    ${place_of_birth}    ${document_number}    ${place_of_issue}    ${issue_date}
    ...    ${country_of_visa}    ${country_of_residence}    ${city_of_residence}    ${segment_relate}
    Verify Specific Line Is Written In The PNR    SSR DOCO ${segment_airline_code} ${status_code} ${place_of_birth}/V/${document_number}/${place_of_issue}/${issue_date}/${country_of_visa}/${segment_relate}
    Verify Specific Line Is Written In The PNR    SSR DOCA ${segment_airline_code} ${status_code} R/${country_of_residence}/${city_of_residence}/${segment_relate}

Verify APIS Passenger And Travel Documents Details Remarks Is Not Written
    [Arguments]    ${segment_airline_code}    ${status_code}    ${document_type}    ${country_of_issue}    ${document_number}    ${nationality}
    ...    ${birth_date}    ${gender}    ${expiry_date}    ${last_name}    ${first_name}    ${middle_name}
    ...    ${segment_relate}
    Verify Specific Line Is Not Written In The PNR    SSR DOCS ${segment_airline_code} ${status_code} ${document_type}/${country_of_issue}/${document_number}/${nationality}/${birth_date}/${gender}/${expiry_date}/${last_name}/${first_name}/${middle_name}/${segment_relate}

Verify APIS Passenger And Travel Document Details Remarks
    [Arguments]    ${segment_airline_code}    ${status_code}    ${document_type}    ${country_of_issue}    ${document_number}    ${nationality}
    ...    ${birth_date}    ${gender}    ${expiry_date}    ${last_name}    ${first_name}    ${middle_name}
    ...    ${segment_relate}
    Verify Specific Line Is Written In The PNR    SSR DOCS ${segment_airline_code} ${status_code} ${document_type}/${country_of_issue}/${document_number}/${nationality}/${birth_date}/${gender}/${expiry_date}/${last_name}/${first_name}/${middle_name}/${segment_relate}

Verify SFPD Remarks Is Not Written
    [Arguments]    ${first_name}    ${middle_name}    ${last_name}    ${birth_date}    ${gender}    ${redress_number}
    ...    ${known_traveller}
    Verify Specific Line Is Not Written In The PNR    RMP NAME-${first_name}/${middle_name}/${last_name}
    Verify Specific Line Is Not Written In The PNR    RMP DOB-${birth_date}/GENDER-${gender}
    Verify Specific Line Is Not Written In The PNR    RMP REDRESS NUMBER-${redress_number}
    Verify Specific Line Is Not Written In The PNR    RMP KNOWN TRAVELER NUMBER-${known_traveller}
    Verify Specific Line Is Not Written In The PNR    RMT DHS GENDER:${gender}
    Verify Specific Line Is Not Written In The PNR    RMT DHS BIRTHDATE:${birth_date}
    Verify Specific Line Is Not Written In The PNR    RMT DHS LAST NAME:${last_name}
    Verify Specific Line Is Not Written In The PNR    RMT DHS FIRST NAME:${first_name}
    Verify Specific Line Is Not Written In The PNR    RMT DHS MIDDLE NAME:${middle_name}
    Verify Specific Line Is Not Written In The PNR    RMT DHS REDRESS:${redress_number}

Verify SFPD Remarks
    [Arguments]    ${first_name}    ${middle_name}    ${last_name}    ${birth_date}    ${gender}    ${redress_number}
    ...    ${known_traveller}
    Verify Specific Line Is Written In The PNR    RMP NAME-${first_name}/${middle_name}/${last_name}
    Verify Specific Line Is Written In The PNR    RMP DOB-${birth_date}/GENDER-${gender}
    Verify Specific Line Is Written In The PNR    RMP REDRESS NUMBER-${redress_number}
    Verify Specific Line Is Written In The PNR    RMP KNOWN TRAVELER NUMBER-${known_traveller}
    Verify Specific Line Is Written In The PNR    RMT DHS GENDER:${gender}
    Verify Specific Line Is Written In The PNR    RMT DHS BIRTHDATE:${birth_date}
    Verify Specific Line Is Written In The PNR    RMT DHS LAST NAME:${last_name}
    Verify Specific Line Is Written In The PNR    RMT DHS FIRST NAME:${first_name}
    Verify Specific Line Is Written In The PNR    RMT DHS MIDDLE NAME:${middle_name}
    Verify Specific Line Is Written In The PNR    RMT DHS REDRESS:${redress_number}

Verify SFPD Section
    [Arguments]    ${header}
    Verify Control Object Text Value Is Correct    [NAME:grpSFPD]    ${header}
    Verify Control Object Is Visible    [NAME:lblFirstNameSFPD]
    Verify Control Object Is Visible    [NAME:lblMiddleNameSFPD]
    Verify Control Object Is Visible    [NAME:lblLastNameSFPD]
    Verify Control Object Is Visible    [NAME:lblDateOfBirthSFPD]
    Verify Control Object Is Visible    [NAME:lblGenderSFPD]
    Verify Control Object Is Visible    [NAME:lblRedressNumberSFPD]
    Verify Control Object Is Visible    [NAME:lblKnowTravelerNumber]
    Verify Control Object Is Visible    [NAME:chkSFPD]

Verify APIS/SFPD Address Section
    [Arguments]    ${header}
    Verify Control Object Text Value Is Correct    [NAME:grpAPISAddress]    ${header}
    Verify Control Object Is Visible    [NAME:lblAddressType]
    Verify Control Object Is Visible    [NAME:lblAddressStreet]
    Verify Control Object Is Visible    [NAME:lblAddressCity]
    Verify Control Object Is Visible    [NAME:lblAddressCountry]
    Verify Control Object Is Visible    [NAME:lblStateCode]
    Verify Control Object Is Visible    [NAME:lblAddressZipCode]
    Verify Control Object Is Visible    [NAME:chkAddress]

Verify APIS Other Information And Visa Details Section
    [Arguments]    ${header}
    Verify Control Object Text Value Is Correct    [NAME:grpAPISOtherInfo]    ${header}
    Verify Control Object Is Visible    [NAME:lblPlaceOfBirth]
    Verify Control Object Is Visible    [NAME:lblCountryOfResidence]
    Verify Control Object Is Visible    [NAME:lblCityOfResidence]
    Verify Control Object Is Visible    [NAME:lblVisaCountry]
    Verify Control Object Is Visible    [NAME:lblVisaPlaceOfIssue]
    Verify Control Object Is Visible    [NAME:lblVisaDocumentNumber]
    Verify Control Object Is Visible    [NAME:chkOtherDetails]

Verify APIS Passenger And Travel Document Details Section
    [Arguments]    ${header}
    Verify Control Object Text Value Is Correct    [NAME:grpAPISPassengerDetails]    ${header}
    Verify Control Object Is Visible    [NAME:lblFirstName]
    Verify Control Object Is Visible    [NAME:lblMiddleName]
    Verify Control Object Is Visible    [NAME:lblLastName]
    Verify Control Object Is Visible    [NAME:lblDateOfBirth]
    Verify Control Object Is Visible    [NAME:lblNationality]
    Verify Control Object Is Visible    [NAME:lblGender]
    Verify Control Object Is Visible    [NAME:lblDocumentType]
    Verify Control Object Is Visible    [NAME:lblPlaceOfIssue]
    Verify Control Object Is Visible    [NAME:lblDocumentNumber]
    Verify Control Object Is Visible    [NAME:chkPaxDetails]

Verify SFPD Section Is Displayed
    Verify Control Object Is Visible    [NAME:grpSFPD]

Verify SFPD Section Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:grpSFPD]

Verify APIS Passenger And Travel Document Details Section Is Displayed
    Verify Control Object Is Visible    [NAME:grpAPISPassengerDetails]

Verify APIS Passenger And Travel Document Details Section Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:grpAPISPassengerDetails]

Verify APIS Other Information and Visa Details Section Is Displayed
    Verify Control Object Is Visible    [NAME:grpAPISOtherInfo]

Verify APIS Other Information and Visa Details Section Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:grpAPISOtherInfo]

Verify APIS Address Section Is Displayed
    Verify Control Object Is Visible    [NAME:grpAPISAddress]

Verify APIS Address Section Is Not Displayed
    Verify Control Object Is Not Visible    [NAME:grpAPISAddress]
