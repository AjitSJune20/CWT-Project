*** Settings ***
Resource          ../../resources/common/utilities.robot
Resource          ../../resources/common/global_resources.robot

*** Keywords ***
Verify Traveler Name Entered By Counselor And On GDS Screen Are The Same
    [Arguments]    ${expected_traveler_name}
    ${actual_traveler_name}    Get Traveler Name From GDS Screen
    Should Be Equal As Strings    ${actual_traveler_name}    ${expected_traveler_name}
    [Teardown]    Take Screenshot

Get Traveler Name From GDS Screen
    ${gds_data}    Get Data From GDS Screen    RT    True
    ${gds_data}    Flatten String    ${gds_data}
    ${actual_traveler_name}    Get String Between Strings    ${gds_data}    1.    2
    ${actual_traveler_name}    Strip String    ${actual_traveler_name}
    [Return]    ${actual_traveler_name}

Simulate Power Hotel Segment Booking Using Default Values
    Enter GDS Command    RU1AHK1XXX22AUG/****
    Book Passive Hotel    LON    8    3    PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED
    #on click of Click Here in order to write power hotel remarks
    #Adding Accounting Lines
    Set Test Variable    @{air_remarks_list}    RM *NOCOMM/H00000001    RM *VFF33/H00000001/0    RM *VRF/H00000001/6941.00    RM *VLF/H00000001/6941.00    RM *VFF30/H00000001/CF
    ...    RM *VEC/H00000001/L    RM *VTYP/H00000001/C1D    RM *VFF35/H00000001/HHH    RM *VFF36/H00000001/G    RM *VFF34/H00000001/AB    RM *VFF39/H00000001/A
    ...    RM *VFF42/H00000001/309791    RM *VFF28/H00000001/G    RM *VFF58/H00000001/CWV
    ${end_of _list}    Get Length    ${air_remarks_list}
    : FOR    ${index}    IN RANGE    0    ${end_of _list}
    \    ${remark_value}    Get From List    ${air_remarks_list}    ${index}
    \    Enter GDS Command    ${remark_value}
    Log    Hotel Accounting Remarks added
    #Adding General Remarks
    Enter GDS Command    RMH/HHB-*H00000001*MOD/BOOKING MODIFIED-CN210391778-1 HHID HH122069
    Log    Hotel General Remarks added
    Get Passive HTL Hotel Segment From The PNR For Power Hotel
    ${segment_number}    Fetch From Left    ${segment}    HTL
    Set Test Variable    @{rir_remarks_list}    RIR HOTEL ADDRESS: CROWNE PLAZA GALLERIA    RIR ORTIGAS AVENUE CORNER    RIR QUEZON CITY 1100    RIR PHONE NUMBER: 63 26337222    RIR PAYMENT: TO BE PAID DIRECTLY AT THE HOTEL
    ...    RIR GUARANTEED BY: TRAVELLER CREDIT CARD VI    RIR CANCELLATION POLICY: PLEASE SEE DETAILS BELOW IN NOTE FIELD    RIR CANCELLATION RULES: THIS BOOKING CAN BE CANCELLED 24 HOURS    RIR BEFORE 12 00 HOURS AT THE LOCAL HOTEL TIME ON THE DATE OF    RIR BEFORE 12 00 HOURS AT THE LOCAL HOTEL TIME ON THE DATE OF    RIR ARRIVAL TO AVOID ANY CANCELLATION CHARGES.
    ...    RIR COST/NIGHT: ROOM 1000.00 PHP
    ${end_of _list}    Get Length    ${rir_remarks_list}
    : FOR    ${index}    IN RANGE    0    ${end_of _list}
    \    ${remark_value}    Get From List    ${rir_remarks_list}    ${index}
    \    Enter GDS Command    ${remark_value}/S${segment_number}
    Log    Hotel Itenerary Remarks added

Get Passive HTL Hotel Segment From The PNR For Power Hotel
    Enter GDS Command    RTH
    ${data_clipboard}    Get Data From GDS Screen    RTH    True
    ${segments}    Get Lines Using Regexp    ${data_clipboard}    (\\\s+\\\d{1}\\\s+HTL\\\s+)
    ${segments}    Split To Lines    ${segments}
    ${htl_segments_list}    Create List
    : FOR    ${segment}    IN    @{segments}
    \    ${detail_1}    Get String Matching Regexp    (\\\d{1}\\\s+HTL\\\s+)(\\\w{2}\\\s\\\w{3}\\\s\\\w{3})(\\\s\\\w{5}-\\\w{5})    ${segment}
    \    Append To List    ${htl_segments_list}    ${detail_1.replace("HTL ", "")}
    Set Test Variable    ${htl_segments_list}
    Set Test Variable    ${segment}

Verify Power Hotel Remarks Are Written In The PNR
    #Verify Accounting Remarks are written
    Set Test Variable    @{air_remarks_list}    RM *NOCOMM/H00000001    RM *VFF33/H00000001/0    RM *VRF/H00000001/6941.00    RM *VLF/H00000001/6941.00    RM *VFF30/H00000001/CF
    ...    RM *VEC/H00000001/L    RM *VTYP/H00000001/C1D    RM *VFF35/H00000001/HHH    RM *VFF36/H00000001/G    RM *VFF34/H00000001/AB    RM *VFF39/H00000001/A
    ...    RM *VFF42/H00000001/309791    RM *VFF28/H00000001/G    RM *VFF58/H00000001/CWV
    ${end_of _list}    Get Length    ${air_remarks_list}
    : FOR    ${index}    IN RANGE    0    ${end_of _list}
    \    ${remark_value}    Get From List    ${air_remarks_list}    ${index}
    \    Verify Specific Line Is Written In The PNR    ${remark_value}    multi_line_search_flag=true
    Log    Accounting Remarks for Power Hotel is Written
    #Verify RIR remarks are written
    Set Test Variable    @{rir_remarks_list}    RIR HOTEL ADDRESS: CROWNE PLAZA GALLERIA    RIR ORTIGAS AVENUE CORNER    RIR QUEZON CITY 1100    RIR PHONE NUMBER: 63 26337222    RIR PAYMENT: TO BE PAID DIRECTLY AT THE HOTEL
    ...    RIR GUARANTEED BY: TRAVELLER CREDIT CARD VI    RIR CANCELLATION POLICY: PLEASE SEE DETAILS BELOW IN NOTE FIELD    RIR CANCELLATION RULES: THIS BOOKING CAN BE CANCELLED 24 HOURS    RIR BEFORE 12 00 HOURS AT THE LOCAL HOTEL TIME ON THE DATE OF    RIR BEFORE 12 00 HOURS AT THE LOCAL HOTEL TIME ON THE DATE OF    RIR ARRIVAL TO AVOID ANY CANCELLATION CHARGES.
    ...    RIR COST/NIGHT: ROOM 1000.00 PHP
    ${end_of _list}    Get Length    ${rir_remarks_list}
    : FOR    ${index}    IN RANGE    0    ${end_of _list}
    \    ${remark_value}    Get From List    ${rir_remarks_list}    ${index}
    \    Verify Specific Line Is Written In The PNR    ${remark_value}    multi_line_search_flag=true
    Log    Hotel Itenerary Remarks added
    #verify if general remark is written
    Verify Specific Line Is Written In The PNR    RMH HHB-*H00000001*MOD/BOOKING MODIFIED-CN210391778-1 HHID HH122069    multi_line_search_flag=true
