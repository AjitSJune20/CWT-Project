*** Settings ***
Resource          obt_verification.robot
Resource          ../gds/gds_verification.robot

*** Keywords ***
Verfify FF34 and FF35 in Remarks
    [Arguments]    ${touch_level_code}    ${obt_code}    ${segment}    @{ff_value}
    : FOR    ${ff}    IN    @{ff_value}
    \    Run Keyword If    "${ff}" == "FF34"    Verify Specific Line Is Written In The PNR    FF34/${touch_level_code}/S${segment}
    \    Run Keyword If    "${ff}" == "FF35"    Verify Specific Line Is Written In The PNR    FF35/${obt_code}/S${segment}

Verify BT and Touch Level Value Added In PNR
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    Verify Specific Line Is Written In The PNR    RM *VFF35/${obt_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *VFF34/${touch_level_code}/S${segment}    multi_line_search_flag=true

Verify Commission Rebate is written in Remarks
    [Arguments]    ${fare_tab}    ${touch_level}    ${obt_code}    ${ff36}    ${segment_code}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${commission_rebate_value_${fare_tab_index}}/SF${commission_rebate_value_${fare_tab_index}}/C${commission_rebate_value_${fare_tab_index}}/SG01/S${segment_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-${touch_level}/FF35-${obt_code}/FF36-${ff36}/FF47-CWT/S${segment_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *MSX/FF REBATE/S${segment_code}    multi_line_search_flag=true

Verify FF Remarks Are Written In PNR
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    Verfify FF34 and FF35 in Remarks    ${touch_level_code}    ${obt_code}    ${segment}    FF34    FF35
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-${touch_level_code}/FF35-${obt_code}/FF36-S/FF47-CWT/S${segment}    multi_line_search_flag=true

Verify Fuel Surcharge is written in Remarks
    [Arguments]    ${fare_tab}    ${touch_level}    ${obt_code}    ${ff36}    ${segment_code}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${fuel_surcharge_value_${fare_tab_index}}/SF${fuel_surcharge_value_${fare_tab_index}}/C${fuel_surcharge_value_${fare_tab_index}}/S${segment_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *MSX/FF SVC FEE FOR SURCHARGE/S${segment_code}    multi_line_search_flag=true

Verify Merchant Fee written in Remarks
    [Arguments]    ${fare_tab}    ${touch_level}    ${obt_code}    ${ff36}    ${segment_code}
    Retrieve PNR Details From Amadeus    ${current_pnr}
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    Verify Specific Line Is Written In The PNR    RM *MSX/S${merchant_fee_value_${fare_tab_index}}/SF${merchant_fee_value_${fare_tab_index}}/C${merchant_fee_value_${fare_tab_index}}/SG0${segment_code}/S${segment_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *MSX/FF MERCHANT FEE/S${segment_code}    multi_line_search_flag=true
    [Teardown]    Take Screenshot

Verify Prepopulated Touch Level Value
    Activate Power Express Window
    ${actual}    Control Get Text    Power Express    ${EMPTY}    [NAME:cbTouchLevel]
    Should Be Empty    ${actual}

Verify Touch Level Default Value For Car Panel
    [Arguments]    ${expected_default_value}
    ${touch_level}    Get Control Text Current Value    [NAME:cbTouchLevel]
    Should Be Equal    ${touch_level}    ${expected_default_value}

Verify Touch Level Dropdown Values For Car Panel
    [Arguments]    @{level_values}
    ${actual_touch_level_value} =    Get Value From Dropdown List    [NAME:cbTouchLevel]
    : FOR    ${touch_level_value}    IN    @{level_values}
    \    Run Keyword And Return Status    List Should Contain Value    ${actual_touch_level_value}    ${touch_level_value}

Verify Touch Level Prepopulated Value In Dropdown
    [Arguments]    ${touch_level_value}    ${Expected_default_value}
    Run Keyword If    "${touch_level_value}"=="EB"    ${Expected_default_value}    Set Variable    AA
    Run Keyword If    "${touch_level_value}"=="AA"    ${Expected_default_value}    Set Variable    AM
    Run Keyword If    "${touch_level_value}"=="AM"    ${Expected_default_value}    Set Variable    AM
    Comment    Run Keyword If    "${touch_level_value}"=="EB"    ${Expected_default_value}    Set Variable    AA
    Comment    Run Keyword If    "${touch_level_value}"=="EB"    ${Expected_default_value}    Set Variable    AA
    Verify Control Object Text Value Is Correct    [NAME:cbTouchLevel]    ${Expected_default_value}

Verify FF34 FF35 And FF36 Values Are Written In PNR
    [Arguments]    ${touch_level}    ${obt_code}    ${ff36}    ${segment_code}
    Comment    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-${touch_level}/FF35-${obt_code}/FF36-${ff36}/FF47-CWT/S${segment_code}    multi_line_search_flag=true
    [Teardown]    Take Screenshot

Verify VFF Remarks Are Written In PNR
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}    ${expected_booking_method}
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    Comment    Verify VFF 34, VFF 35,VFF 36, VFF39 remaks for car only    ${touch_level_code}    ${obt_code}    ${segment}    ${expected _booking_method}    VFF34
    ...    VFF35    VFF36    VFF39
    Comment    Verify Specific Line Is Written In The PNR    RM *MSX/VFF34-${touch_level_code}/VFF35-${obt_code}/VFF36-S/VFF39-${expected _booking_method}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *VFF34/${touch_level_code}/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="EB"    Verify Specific Line Is Written In The PNR    RM *VFF35/${obt_code}/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EBA"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EBS"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMS/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CBK"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="GET"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMI/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EAM"    Verify Specific Line Is Written In The PNR    RM *VFF35/AME/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="KDS"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMK/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CYT"    Verify Specific Line Is Written In The PNR    RM *VFF35/AM6/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CTG"    Verify Specific Line Is Written In The PNR    RM *VFF35/AM5/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="ZIL"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="OTH"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EBA"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EBS"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMS/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CBK"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="GET"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMI/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EAM"    Verify Specific Line Is Written In The PNR    RM *VFF35/AME/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="KDS"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMK/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CYT"    Verify Specific Line Is Written In The PNR    RM *VFF35/AM6/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CTG"    Verify Specific Line Is Written In The PNR    RM *VFF35/AM5/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="ZIL"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="OTH"    Verify Specific Line Is Written In The PNR    RM *VFF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="EB"    Verify Specific Line Is Written In The PNR    RM *VFF36/S/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${expected_booking_method}"=="GDS"    Verify Specific Line Is Written In The PNR    RM *VFF36/G/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${expected_booking_method}"=="GDS"    Verify Specific Line Is Written In The PNR    RM *VFF36/G/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${expected_booking_method}"=="Manual"    Verify Specific Line Is Written In The PNR    RM *VFF36/M/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${expected_booking_method}"=="Manual"    Verify Specific Line Is Written In The PNR    RM *VFF36/M/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${expected_booking_method}"=="GDS"    Verify Specific Line Is Written In The PNR    RM *VFF39/A/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${expected_booking_method}"=="Manual"    Verify Specific Line Is Written In The PNR    RM *VFF39/P/S${segment}    multi_line_search_flag=true

Verify FF Remarks In PNR
    [Arguments]    ${obt_code}    ${touch_level_code}    ${segment}
    Retrieve PNR Details From Amadeus    ${current_pnr}    RTY
    Comment    Verify VFF 34, VFF 35,VFF 36, FF39 remaks for car only    ${touch_level_code}    ${obt_code}    ${segment}    ${expected _booking_method}    FF34
    Comment    Verify Specific Line Is Written In The PNR    RM *MSX/FF34-${touch_level_code}/FF35-${obt_code}    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *FF34/${touch_level_code}/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="EB"    Verify Specific Line Is Written In The PNR    RM *FF35/${obt_code}/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EBA"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EBS"    Verify Specific Line Is Written In The PNR    RM *FF35/AMS/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CBK"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="GET"    Verify Specific Line Is Written In The PNR    RM *FF35/AMI/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="EAM"    Verify Specific Line Is Written In The PNR    RM *FF35/AME/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="KDS"    Verify Specific Line Is Written In The PNR    RM *FF35/AMK/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CYT"    Verify Specific Line Is Written In The PNR    RM *FF35/AM6/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="CTG"    Verify Specific Line Is Written In The PNR    RM *FF35/AM5/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="ZIL"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AA" and "${obt_code}"=="OTH"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EBA"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EBS"    Verify Specific Line Is Written In The PNR    RM *FF35/AMS/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CBK"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="GET"    Verify Specific Line Is Written In The PNR    RM *FF35/AMI/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="EAM"    Verify Specific Line Is Written In The PNR    RM *FF35/AME/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="KDS"    Verify Specific Line Is Written In The PNR    RM *FF35/AMK/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CYT"    Verify Specific Line Is Written In The PNR    RM *FF35/AM6/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="CTG"    Verify Specific Line Is Written In The PNR    RM *FF35/AM5/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="ZIL"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true
    Run Keyword If    "${touch_level_code}"=="AM" and "${obt_code}"=="OTH"    Verify Specific Line Is Written In The PNR    RM *FF35/AMA/S${segment}    multi_line_search_flag=true