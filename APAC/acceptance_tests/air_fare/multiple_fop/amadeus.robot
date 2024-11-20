*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags
Resource          ../air_fare_verification.robot
Resource          ../../client_info/client_info_verification.robot

*** Test Cases ***
[NB IN] Verify That Accounting Remarks Using Single (VI) FOP For All Segments
    [Tags]    us592    us852    us853    us854    us855    us293
    ...    team_c    in    us2188    us2322
    Open Power Express And Retrieve Profile    ${version}    Test    u003wxr    en-GB    AutomationIN    ${EMPTY}
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC IN OS AUTOMATION    BEAR    INOTHERS
    Select Client Account Value    3104300001 ¦ MONSANTO HOLDINGS PVT. LTD ¦ APAC IN OS AUTOMATION
    Click New Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    VI    4484886075896240    1231
    Verify Form Of Payment Card Is Masked On Client Info
    Verify FOP Merchant Field Is Not Visible On Client Info Panel
    Update PNR With Default Values
    Book Flight X Months From Now    SINMNL/ASQ    SS1Y1    FXP/S2    4    5
    Book Flight X Months From Now    MNLSIN/ASQ    SS1Y1    FXP/S3    4    15
    Click Read Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    AX    378282246310005    1233
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Fuel Surcharge Is Not Displayed    Fare 1
    Verify FOP Merchant Selected Is Displayed On Fare Quote Tab    CWT
    Verify Form Of Payment Field Is Disabled
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Get FOP Merchant Field Value On Fare Quote Tab
    Click Mask Icon To Unmask Card On Fare Quote Tab
    Verify FOP Credit Card Is UnMasked On Fare Quote Tab
    Verify Form Of Payment Selected Is Displayed    AX378282246310005/D1233
    Populate Fare Quote Tabs with Default Values
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Route Code Value    Fare 1
    Click Fare Tab    Fare 2
    Verify Fuel Surcharge Is Not Displayed    Fare 2
    Verify FOP Merchant Selected Is Displayed On Fare Quote Tab    CWT
    Verify Form Of Payment Field Is Disabled
    Click Mask Icon To Unmask Card On Fare Quote Tab
    Verify FOP Credit Card Is UnMasked On Fare Quote Tab
    Verify Form Of Payment Selected Is Displayed    AX378282246310005/D1233
    Select FOP Merchant On Fare Quote Tab    Fare 2    CWT
    Get FOP Merchant Field Value On Fare Quote Tab
    Click Mask Icon To Unmask Card On Fare Quote Tab
    Verify FOP Credit Card Is UnMasked On Fare Quote Tab
    Verify Form Of Payment Selected Is Displayed    AX378282246310005/D1233
    Populate Fare Quote Tabs with Default Values
    Get Main Fees On Fare Quote Tab    Fare 2
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Get Route Code Value    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify FP Line Is Written In The PNR Per TST    Fare 1    Credit Card    S2    Airline    ${EMPTY}    IN
    Verify FP Line Is Written In The PNR Per TST    Fare 2    Credit Card    S3    CWT    ${EMPTY}    IN
    Verify That FOP Remark Is Written In The RM Lines    Credit Card    AX    1233
    Verify FOP, Transaction, Merchant And Commission Rebate Remarks    Fare 1    S2    02    AX378282246310005/D1233    IN    Airline
    Verify FOP, Transaction, Merchant And Commission Rebate Remarks    Fare 2    S3    03    AX378282246310005/D1233    IN    CWT
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee    S2    02    AX378282246310005/D1233    1
    Verify GST Remarks Per TST Are Correct    Fare 2    Merchant Fee    S3    03    AX378282246310005/D1233    1
    [Teardown]

[AB IN] Verify That Accounting Remarks When Changing FOP For All New Segments
    [Tags]    us592    us852    us853    us854    us855    us293
    ...    team_c    in    us2322
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Delete All Segments
    Book Flight X Months From Now    BLRDEL/AUK    SS1Y1    FXP/S2    4    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Form Of Payment Selected Is Displayed    PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Route Code Value    Fare 1
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Accounting Remarks When Changing FOP For All New Segments
    Execute Simultaneous Change Handling    Amend Booking For Verify That Accounting Remarks When Changing FOP For All New Segments
    Retrieve PNR Details from Amadeus
    Verify FOP, Transaction, Merchant And Commission Rebate Remarks    Fare 1    S2    02    PORTRAIT-A/AX***********0002/D1235-TEST-AX    IN    Airline
    Verify GST Remarks Per TST Are Correct    Fare 1    Merchant Fee    S2    02    PORTRAIT-A/AX***********0002/D1235-TEST-AX    1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That Accounting Remarks When Changing FOP For All New Segments
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    AX    378282246310005    1233
    Delete All Segments
    Book Flight X Months From Now    BLRDEL/AUK    SS1Y1    FXP/S2    4    6
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Form Of Payment Selected Is Displayed    AX***********0005/D1233
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Route Code Value    Fare 1
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Accounting Remarks When Changing FOP For All New Segments
