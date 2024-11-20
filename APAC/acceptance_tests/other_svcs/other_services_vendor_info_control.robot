*** Settings ***
Resource          ../../resources/common/global_resources.robot

*** Keywords ***
Get Other Services Vendor Info Control
    [Arguments]    ${identifier}
    #Attention
    ${attention}    Get Control Text Value    [NAME:AttentionTextBox]
    #Vendor
    ${vendor}    Get Control Text Value    [NAME:VendorComboBox]
    #Address
    ${address}    Get Control Text Value    [NAME:AddressTextBox]
    #City
    ${city}    Get Control Text Value    [NAME:CityTextBox]
    #Country
    ${country}    Get Control Text Value    [NAME:CountryTextBox]
    #CWT Email For Vendor (Only 1 Email Address Allowed)
    ${cwt_email}    Get Control Text Value    [NAME:EmailTextBox]
    #CWT Phone for vendor
    ${cwt_phone}    Get Control Text Value    [NAME:ContactNumberTextBox]
    #Contact Type
    ${contact_type}    Get Control Text Value    [NAME:ContactTypeComboBox]
    #Details
    ${details}    Get Control Text Value    [NAME:DetailsTextBox]
    Set Test Variable    ${attention_${identifier}}    ${attention}
    Set Test Variable    ${vendor_${identifier}}    ${vendor}
    Set Test Variable    ${address_${identifier}}    ${address}
    Set Test Variable    ${city_${identifier}}    ${city}
    Set Test Variable    ${country_${identifier}}    ${country}
    Set Test Variable    ${cwt_email_${identifier}}    ${cwt_email}
    Set Test Variable    ${cwt_phone_${identifier}}    ${cwt_phone}
    Set Test Variable    ${contact_type_${identifier}}    ${contact_type}
    Set Test Variable    ${details_${identifier}}    ${details}

Populate Other Services Vendor Info Control Details
    [Arguments]    ${attention}=ALERT    ${vendor}=${EMPTY}    ${address}=MAKATI CITY, PHILIPPINES    ${city}=MAKATI CITY    ${country}=PHILIPPINES    ${cwt_email}=CWT@TEST.COM
    ...    ${cwt_phone}=143143    ${contact_type}=Email    ${details}=This is a test
    #Attention
    ${attention}    Set Control Text Value    [NAME:AttentionTextBox]    ${attention}
    #Vendor
    Comment    ${vendor}    Set Control Text Value    [NAME:VendorComboBox]    ${vendor}
    #Address
    ${address}    Set Control Text Value    [NAME:AddressTextBox]    ${address}
    #City
    ${city}    Set Control Text Value    [NAME:CityTextBox]    ${city}
    #Country
    ${country}    Set Control Text Value    [NAME:CountryTextBox]    ${country}
    #CWT Email For Vendor (Only 1 Email Address Allowed)
    ${cwt_email}    Set Control Text Value    [NAME:EmailTextBox]    ${cwt_email}
    #CWT Phone for vendor
    ${cwt_phone}    Set Control Text Value    [NAME:ContactNumberTextBox]    ${cwt_phone}
    #Contact Type
    ${contact_type}    Select Dropdown Value    [NAME:ContactTypeComboBox]    ${contact_type}
    #Details
    ${details}    Set Control Text Value    [NAME:DetailsTextBox]    ${details}
    #Click Add
    Click Control Button    [NAME:AddButton]

Verify Other Services Vendor Info Values Are Correct
    [Arguments]    ${identifier}
    ${identifier}    Convert To Lowercase    ${identifier}
    Run Keyword If    "${identifier}" == "despatch" or "${identifier}" == "car intl" or "${identifier}" == "air bsp"    Verify Vendor Info Values Are Correct    ${identifier}    attention=ALERT    vendor=${vendor.upper()}    address=MAKATI CITY, PHILIPPINES
    ...    city=MAKATI CITY    country=PHILIPPINES    cwt_email=CWT@TEST.COM    cwt_phone=143143    contact_type=Email    details=This is a test
    Run Keyword If    "${identifier}" == "despatch default"    Verify Vendor Info Values Are Correct    ${identifier}
    Run Keyword If    "${identifier}" == "air domestic default"    Verify Vendor Info Values Are Correct    ${identifier}    address=L8 GREEN PARK EXTN,NEW DELHI 110016, INDIA    city=New Delhi    country=India
    ...    cwt_phone=9910277463

Verify Vendor Info Values Are Correct
    [Arguments]    ${identifier}    ${attention}=${EMPTY}    ${vendor}=${vendor.upper()}    ${address}=${EMPTY}    ${city}=${EMPTY}    ${country}=${EMPTY}
    ...    ${cwt_email}=${EMPTY}    ${cwt_phone}=${EMPTY}    ${contact_type}=-- Select Contact Type --    ${details}=${EMPTY}
    Get Other Services Vendor Info Control    ${identifier}
    Verify Actual Value Matches Expected Value    ${attention_${identifier}}    ${attention}
    Verify Actual Value Matches Expected Value    ${vendor_${identifier}}    ${vendor}
    Verify Text Contains Expected Value    ${address_${identifier}.strip()}    ${address}    multi_line_search_flag=true    remove_spaces=true
    Verify Actual Value Matches Expected Value    ${city_${identifier}}    ${city}
    Verify Actual Value Matches Expected Value    ${country_${identifier}}    ${country}
    Verify Actual Value Matches Expected Value    ${cwt_email_${identifier}}    ${cwt_email}
    Verify Actual Value Matches Expected Value    ${cwt_phone_${identifier}}    ${cwt_phone}
    ${grid_value}    Get All Values From Datagrid    [NAME:ContactTypeDataGridView]
    #Contact Type Column
    Run Keyword If    "${grid_value}" != "[]"    Verify Actual Value Matches Expected Value    ${grid_value[0]}    ${contact_type}
    #Details Column
    Run Keyword If    "${grid_value}" != "[]"    Verify Actual Value Matches Expected Value    ${grid_value[1]}    ${details}
    #Prefer Column
    Run Keyword If    "${grid_value}" != "[]"    Verify Actual Value Matches Expected Value    ${grid_value[2]}    False
