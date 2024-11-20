*** Settings ***
Variables         ../variables/id_traveller.py
Resource          ../common/core.robot

*** Keywords ***
Click Create One Time Contact
    Click Control Button    [NAME:btnAddContactPortrait]
    Sleep    2
    Wait Until Control Object Is Visible    [NAME:grpCaller]

Click Create Traveller Profile
    Click Control Button    [NAME:btnNewPortrait]

Click Profile Button
    [Arguments]    ${order}=${EMPTY}
    Click Control Button    [NAME:gProfileGrid]    ${title_power_express}
    Sleep    1
    Run Keyword If    "${order}" != "${EMPTY}"    Send    {DOWN ${order}}
    ...    ELSE    Send    {SPACE}
    Wait Until Progress Info is Completed

Click ${tab_name} Tab In Caller Panel
    Click Control Button    [NAME:ContactDetailsTabControl]
    Select Tab Control    ${tab_name}

Click Search Portrait Profile
    Click Control Button    [NAME:btnPortraitSearchTravellerProfile1]

Handle Profile Remarks Popup
    ${profile_remark_win}    Set Variable If    "${locale}" == "fr-FR"    Remarques du profil    Profile Remarks
    Win Activate    ${profile_remark_win}    ${EMPTY}
    Click Control Button    [NAME:btnClose]    ${profile_remark_win}
    Wait Until Window Does Not Exists    ${profile_remark_win}

Populate Add New Traveller
    [Arguments]    ${traveller_type}    ${firstname}    ${lastname}    ${email_address}    ${country_code}    ${area_code}
    ...    ${phone_number}    ${create_portrait_profile}=no    ${reason_for_skipping}=${EMPTY}
    [Documentation]    Use "random" as value in First Name if you want first name to be a RANDOM VALUE
    ${add_new_traveller_window}    Set Variable    Add New Traveller
    Wait Until Window Exists    ${add_new_traveller_window}
    Win Activate    ${add_new_traveller_window}
    Select Value From Dropdown List    [NAME:ccboTravellerType]    ${traveller_type}    Add New Traveller
    ${firstname}    Run Keyword If    "${firstname.lower()}" == "random"    Generate Random String    length=8    chars=[UPPER]
    ...    ELSE    Set Variable    ${firstname}
    Set Control Text Value    [NAME:ctxtFirstName]    ${firstname}    ${add_new_traveller_window}
    Set Control Text Value    [NAME:ctxtLastName]    ${lastname}    ${add_new_traveller_window}
    Set Control Text Value    [NAME:ctxtEmail]    ${email_address}    ${add_new_traveller_window}
    Set Control Text Value    [NAME:ctxtCountryCode]    ${country_code}    ${add_new_traveller_window}
    Set Control Text Value    [NAME:ctxtAreaCode]    ${area_code}    ${add_new_traveller_window}
    Set Control Text Value    [NAME:ctxtPhoneNumber]    ${phone_number}    ${add_new_traveller_window}
    Run Keyword If    "${create_portrait_profile.lower()}" == "no"    Click Control Button    [NAME:radCreateNo]    ${add_new_traveller_window}
    ...    ELSE    Click Control Button    [NAME:radCreateYes]    ${add_new_traveller_window}
    Run Keyword If    "${create_portrait_profile.lower()}" == "no" and "${selected_team}" != "UK 24HSC UAT Team"    Set Control Text Value    [NAME:ctxtReason]    ${reason_for_skipping}    ${add_new_traveller_window}
    Click Control Button    [NAME:btnFinish]    ${add_new_traveller_window}
    Sleep    5

Select PCC/CompanyProfile/TravellerProfile
    [Arguments]    ${pcc_companyprofile_travellerprofile}
    Select Value From Combobox    PCC/CompanyProfile/TravellerProfile    ${pcc_companyprofile_travellerprofile}

Get First Name
    Click Given Object Using Coords    ${edt_FirstName}
    Send    ^a
    Send    ^c
    ${first_name}    Get Data From Clipboard
    [Return]    ${first_name}

Get Last Name
    Click Given Object Using Coords    ${edt_LastName}
    Send    ^a
    Send    ^c
    ${last_name}    Get Data From Clipboard
    [Return]    ${last_name}

Select Arranger
    [Documentation]    Pre Requisite: Traveller Is Already Selected
    Click Control Button    [NAME:gProfileGrid]    ${title_power_express}
    Sleep    1
    Send    {TAB}
    Sleep    1
    Send    {SPACE}

Select Traveller
    [Documentation]    Pre Requisite: Arranger Is Already Selected
    Click Control Button    [NAME:gProfileGrid]    ${title_power_express}
    Sleep    1
    Send    {TAB}
    Sleep    1
    Send    {SPACE}

Select Type Of Booking
    [Arguments]    ${booking_type}
    Run Keyword If    "${booking_type.lower()}" == "classic"    Click Control Button    [NAME:rbClassic]
    ...    ELSE IF    "${booking_type.lower()}" == "kds"    Click Control Button    [NAME:rbKDS]

Set Client
    [Arguments]    ${client}
    Comment    Click Control Button    ${cbo_Client}    ${title_power_express}
    Comment    Control Set Text    ${title_power_express}    ${EMPTY}    ${cbo_Client}    ${client}
    Comment    Sleep    1
    Comment    Control Focus    ${title_power_express}    ${EMPTY}    ${cbo_Client}
    Comment    Send    {ENTER}
    Comment    Send    {TAB}
    Set Control Text Value    ${cbo_Client}    ${client}
    Send    {ENTER}{TAB}
    Click Control Button    ${cbo_Client}

Set Client And Traveler
    [Arguments]    ${client}    ${lastname}    ${firstname}    ${order}=${EMPTY}    ${handle_profile_popup}=False
    Click Control Button    [NAME:grpPortraitProfileInformation]
    Set Client    ${client}
    Set Last Name    ${lastname}
    Set First Name    ${firstname}
    Click Search Portrait Profile
    Click Profile Button    ${order}
    Run Keyword If    ${handle_profile_popup} == True    Handle Profile Remarks Popup

Set Client And Traveler With Timestamp
    [Arguments]    ${client}    ${lastname}    ${firstname}    ${order}=${EMPTY}
    Sleep    5
    Activate Power Express Window
    Click Control Button    ${cbo_Client}    ${title_power_express}
    Control Set Text    ${title_power_express}    ${EMPTY}    ${cbo_Client}    ${client}
    Sleep    1
    Control Focus    ${title_power_express}    ${EMPTY}    ${cbo_Client}
    Send    {TAB}
    Set Control Text Value    ${edit_lastName}    ${lastname}    ${title_power_express}
    Control Focus    ${title_power_express}    ${EMPTY}    ${edit_lastName}
    Send    {TAB}
    Control Set Text    ${title_power_express}    ${EMPTY}    ${edit_firstName}    ${firstname}
    Send    {ENTER}
    Control Focus    ${title_power_express}    ${EMPTY}    [NAME:btnPortraitSearchTravellerProfile1]
    Control Click    ${title_power_express}    ${EMPTY}    [NAME:btnPortraitSearchTravellerProfile1]
    Click Control Button    [NAME:gProfileGrid]    ${title_power_express}
    Sleep    1
    Run Keyword If    "${order}" != "${EMPTY}"    Send    {DOWN ${order}}
    ...    ELSE    Send    {SPACE}
    Sleep    1
    ${exp_overalltransaction_start_time}    Get Time
    Set Test Variable    ${exp_overalltransaction_start_time}
    Wait Until Progress Info is Completed

Set First Name
    [Arguments]    ${firstname}    ${active_panel}=id traveller
    ${object_name}    Set Variable If    '${active_panel}'=='id traveller'    ${edit_firstName}    ${edt_FirstName}
    Set Control Text Value    ${object_name}    ${firstname}    ${title_power_express}
    Comment    Send    {ENTER}

Set Last Name
    [Arguments]    ${lastname}    ${active_panel}=id traveller
    ${object_name}    Set Variable If    '${active_panel}'=='id traveller'    ${edit_lastName}    ${edt_LastName}
    Set Control Text Value    ${object_name}    ${lastname}    ${title_power_express}
    Control Focus    ${title_power_express}    ${EMPTY}    ${edit_lastName}
    Send    {ENTER}

Set Traveller Name In Traveller/Contact
    [Arguments]    ${first_name}=${EMPTY}    ${last_name}=${EMPTY}
    Run Keyword If    '${first_name}'!='${EMPTY}'    Set First Name    ${first_name}    traveller/contact
    Run Keyword If    '${last_name}'!='${EMPTY}'    Set Last Name    ${last_name}    traveller/contact

Untick Traveler Checkbox
    Untick Checkbox    [NAME:CchkTraveller]

Tick Traveler Checkbox
    Click Given Object Using Coords    [NAME:CchkTraveller]

Set Company Profile
    [Arguments]    ${company_profile}
    Set Control Text Value    [NAME:ccboCompanyProfile]    ${company_profile}

Set Profile Name
    [Arguments]    ${profile_name}
    Set Control Text Value    [NAME:txtcTravellerProfile]    ${profile_name}

Search PIN Portrait
    [Arguments]    ${portrait_pin}
    Set Control Text Value    [NAME:ctxtPortraitPIN]    ${portrait_pin}    ${title_power_express}
    Click Search Portrait Profile

Click Search Email
    Click Control Button    [NAME:btnSearchEmail]
