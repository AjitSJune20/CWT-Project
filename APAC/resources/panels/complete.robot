*** Settings ***
Documentation     This resource file covers all reusable actions for Complete Panel related test cases
Variables         ../variables/complete_control_objects.py
Resource          ../common/core.robot

*** Keywords ***
Click Clear All Same Booking New Traveller
    Click Control Button    ${btn_clearAll}    ${title_power_express}
    Wait Until Control Object Is Visible    ${same_booking_new_traveller}    ${clear_all}
    Click Control Button    ${same_booking_new_traveller}    ${clear_all}
    Click Control Button    [NAME:btnOKButton]    ${clear_all}
    Wait Until Progress Info is Completed

Click Clear All New Booking Same Contact
    Click Control Button    ${btn_clearAll}    ${title_power_express}
    Wait Until Control Object Is Visible    ${radbtn_NewBookingSameContact}    ${clear_all}
    Click Control Button    ${radbtn_NewBookingSameContact}    ${clear_all}
    Click Control Button    [NAME:btnOKButton]    ${clear_all}
    Wait Until Progress Info is Completed

Click Clear All New Booking Same Traveller
    Click Control Button    ${btn_clearAll}    ${title_power_express}
    Wait Until Control Object Is Visible    ${radbtn_NewBookingSameTraveler}    ${clear_all}
    Click Control Button    ${radbtn_NewBookingSameTraveler}    ${clear_all}
    Click Control Button    [NAME:btnOKButton]    ${clear_all}
    Wait Until Progress Info is Completed

Get PNR Record Locator
    Comment    Wait Until Progress Info is Completed
    Comment    Run Keyword And Continue On Failure    Verify Control Object Is Visible    [NAME:ctxtLocator]    ${title_power_express}    true
    Wait Until Keyword Succeeds    180    3    Verify Control Object Is Visible    [NAME:ctxtLocator]    ${title_power_express}    true
    ${get_pnr} =    Get Control Text Value    [NAME:ctxtLocator]    ${title_power_express}
    Run Keyword If    '${get_pnr}' != '${EMPTY}'    Set Suite Variable    ${current_pnr}    ${get_pnr}
    Run Keyword If    '${get_pnr}' != '${EMPTY}'    Set Suite Variable    ${pt_pnr}    ${get_pnr}

Verify PNR Message
    ${pnr_message} =    Get Control Text Value    [NAME:TableLayoutPanel2]    ${title_power_express}
    ${pnr_message2} =    Get Control Text Value    ${label_end_message}    ${title_power_express}
    ${is_failed_queue_placement} =    Run Keyword And Return Status    Should Contain    ${pnr_message}    Failed queue placement
    Run Keyword Unless    ${is_failed_queue_placement} == False    Log    Failed queue placement    WARN
    Should Not Contain Any    ${pnr_message}    Fehler beim Beenden    Please manually end the booking and make sure it's sent    msg=Cannot end PNR due to error: ${\n}${pnr_message}
    Should Not Contain Any    ${pnr_message2}    NEED TICKETING TI    NO TRANSACTION PRESENT    There was a problem ending the booking file! Message from GDS: MODIFY BOOKING    There was a problem ending the booking file! Message from GDS: DUPLICATE SEGMENT    NEED TELEPHONE
    ...    INVALID TICKETING DATE    NEED ITINERARY    There was a problem ending the booking file! Message from GDS: NO CHANGES MADE TO PNR - UPDATE OR IGNORE    There was a problem ending the booking file! Message from GDS: NEED PASSENGER/SEGMENT ASSOC.    Exchange Order transaction not saved    There was a problem ending the booking file! Message from GDS: IGNORE AND RE-ENTER
    ...    msg=Should not contain ${\n}${pnr_message2}
    ${simultaneous_changes} =    Run Keyword And Return Status    Should Contain    ${pnr_message}    SIMULT
    ${simultaneous_changes_2} =    Run Keyword And Return Status    Should Contain    ${pnr_message2}    SIMULT
    ${simultaneous_changes}    Set Variable If    "${simultaneous_changes}" == "True" or "${simultaneous_changes_2}" == "True"    True    False
    Set Suite Variable    ${simultaneous_changes}
    [Teardown]

Verify Requested Booking File Segments Is Cancelled
    ${cancel_message} =    Get Control Text Value    ${label_end_message}    ${title_power_express}
    Verify Text Contains Expected Value    ${cancel_message}    Segment
    [Teardown]

Verify Simultaneous Changes To PNR Error Message Is Displayed
    Run Keyword And Continue On Failure    Should Be Equal    True    ${simultaneous_changes}    Simultaneous Changes To PNR error message is not displayed.    FALSE

Click Clear All With Options
    [Arguments]    ${clear_all_option}
    Click Control Button    ${btn_clearAll}    ${title_power_express}
    ${clear_all_window}    Set Variable If    "${locale}"=="fr-FR"    Tout effacer    "${locale}"=="en-US"    Clear All    "${locale}"=="en-GB"
    ...    Clear All
    Wait Until Window Exists    ${clear_all_window}
    ${radiobutton_clear_all_option}    Set Variable If    "${clear_all_option.lower()}"=="new booking, same traveller"    [NAME:NewPNRSameTravellerRadioButton]    "${clear_all_option.lower()}"=="new booking, same contact"    [NAME:NewPNRSameContactRadioButton]    "${clear_all_option.lower()}"=="same booking, new traveller"
    ...    [NAME:SameBookingNewTravellerRadioButton]    "${clear_all_option.lower()}"=="clear all"    [NAME:ClearAllRadioButton]
    Wait Until Control Object Is Visible    ${radiobutton_clear_all_option}    ${clear_all_window}
    Click Control Button    ${radiobutton_clear_all_option}    ${clear_all_window}
    Click Control Button    [NAME:btnOKButton]    ${clear_all_window}
    Wait Until Progress Info is Completed
    Wait Until Progress Info is Completed

Get Arranger Details
    ${arranger_lastname} =    Get Control Text Value    ${contact_last_name}
    ${arranger_firstname} =    Get Control Text Value    ${contact_first_name}
    Set Test Variable    ${arranger_lastname}
    Set Test Variable    ${arranger_firstname}

Click Other Services
    [Documentation]    This is now obsolete since Other Services is now integrated in the New and Amend Booking Workflow
    [Tags]    _obsolete
    Wait Until Control Object Is Enabled    [NAME:btnOtherServices]    ${title_power_express}
    Click Control Button    [NAME:btnOtherServices]    ${title_power_express}
    Wait Until Progress Info is Completed
    Wait Until Control Object Is Visible    [NAME:otherServicesContainer]    handle_popups=true
    Wait Until Exchange Order Grid Is Displayed

Verify PNR Is Successfully Created
    [Arguments]    ${should_match}=true    ${expected_message}=${EMPTY}
    ${pnr}    Get Control Text Value    [NAME:ctxtLocator]    ${title_power_express}
    ${message}    Get Control Text Value    [NAME:lblEndMessage]    ${title_power_express}
    Run Keyword And Continue On Failure    Should Match RegExp    ${pnr}    ^[A-z0-9][A-z0-9][A-z0-9][A-z0-9][A-z0-9][A-z0-9]$
    Run Keyword And Continue On Failure    Run Keyword If    "${should_match.lower()}" == "true"    Should Match    ${message}    Exchange Order(s) Transaction Successfully Saved!
    ...    ELSE    Should Contain    ${message}    ${expected_message}

Verify PNR Is Successfully Updated
    ${pnr}    Get Control Text Value    [NAME:ctxtLocator]    ${title_power_express}
    ${message}    Get Control Text Value    [NAME:lblEndMessage]    ${title_power_express}
    Run Keyword And Continue On Failure    Should Match RegExp    ${pnr}    \\w{6}
    Run Keyword And Continue On Failure    Should Match    ${message}    Booking File Updated Successfully!
