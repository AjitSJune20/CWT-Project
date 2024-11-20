*** Settings ***
Force Tags        amadeus    apac
Resource          apis_sfpd_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That APIS/SFPD Is Captured And Written Upon Finish PNR
    [Tags]    in    howan    us423    us2092
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ XYZ Automation IN - US423    BEAR    RJ
    Select Client Account    5030500473 ¦ Another detail ¦ XYZ Automation IN - US423
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    DELHKG/ACX    SS1Y1    FXB/S2    5    4
    Click Read Booking
    Click Panel    APIS/SFPD
    Verify SFPD Section Is Not Displayed
    Verify APIS Address Section Is Not Displayed
    Verify APIS Passenger And Travel Document Details Section    APIS Passenger and Travel Document Details
    Verify APIS Other Information And Visa Details Section    APIS Other Information and Visa Details
    Click Read Booking
    Click Panel    APIS/SFPD
    Book Flight X Months From Now    LAXJFK/ADL    SS1Y1    FXB/S3    5    7
    Click Read Booking
    Click Panel    Pspt and Visa
    Select Is Doc Valid    Yes
    Click Check Visa Requirements
    Click Panel    APIS/SFPD
    Verify SFPD Section    Secure Flight Passenger Data
    Verify APIS Passenger And Travel Document Details Section    APIS Passenger and Travel Document Details
    Verify APIS Other Information And Visa Details Section    APIS Other Information and Visa Details
    Verify APIS/SFPD Address Section    Address
    Populate APIS Other Information And Visa Details    Manila    India    Pasig    India    Star Mall    A2
    ...    22/12/2010
    Populate APIS/SFPD Address    Wall Street    Star City    Bahamas    Alaska    0201
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD    Pspt and Visa
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify SFPD Remarks    RJ    FOX    BEAR    02JAN89    M    22
    ...    A2
    Verify APIS Passenger And Travel Document Details Remarks    CX    HK1    P    IN    A2    IN
    ...    02JAN89    M    22DEC20    BEAR    RJ    FOX
    ...    S2
    Verify APIS Passenger And Travel Document Details Remarks    DL    HK1    P    IN    A2    IN
    ...    02JAN89    M    22DEC20    BEAR    RJ    FOX
    ...    S3
    Verify APIS Other Information And Visa Details Remarks    CX    HK1    MANILA    A2    STAR MALL    22DEC10
    ...    IN    IN    PASIG    S2
    Verify APIS Other Information And Visa Details Remarks    DL    HK1    MANILA    A2    STAR MALL    22DEC10
    ...    IN    IN    PASIG    S3
    Verify APIS/SFPD Address Remarks    CX    HK1    R    BS    WALL STREET    STAR CITY
    ...    AK    0201    S2
    Verify APIS/SFPD Address Remarks    DL    HK1    R    BS    WALL STREET    STAR CITY
    ...    AK    0201    S3

[AB IN] Verify That APIS/SFPD Is Captured And Written Upon Finish PNR
    [Tags]    in    howan    us423    us2092
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2
    Click Read Booking
    Click Panel    APIS/SFPD
    Verify SFPD Section    Secure Flight Passenger Data
    Verify APIS Passenger And Travel Document Details Section Is Not Displayed
    Verify APIS Other Information and Visa Details Section Is Not Displayed
    Verify APIS Address Section Is Not Displayed
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD
    Click Finish PNR    Amend Booking For Verify That APIS/SFPD Is Captured And Written Upon Finish PNR For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That APIS/SFPD Is Captured And Written Upon Finish PNR For IN
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify SFPD Remarks    RJ    FOX    BEAR    02JAN89    M    22
    ...    A2
    Verify APIS Passenger And Travel Documents Details Remarks Is Not Written    DL    HK1    P    IN    A2    IN
    ...    02JAN89    M    22DEC20    BEAR    RJ    FOX
    ...    S2
    Verify APIS Other Information And Visa Details Remarks Is Not Written    DL    HK1    MANILA    A2    STAR MALL    22DEC10
    ...    IN    IN    PASIG    S2
    Verify APIS/SFPD Address Remarks Is Not Written    DL    HK1    R    BS    WALL STREET    STAR CITY
    ...    AK    0201    S2
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That APIS/SFPD Is Captured And Written Upon Finish PNR For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2
    Click Read Booking
    Click Panel    APIS/SFPD
    Verify SFPD Section    Secure Flight Passenger Data
    Verify APIS Passenger And Travel Document Details Section Is Not Displayed
    Verify APIS Other Information and Visa Details Section Is Not Displayed
    Verify APIS Address Section Is Not Displayed
    Populate All Panels (Except Given Panels If Any)    APIS/SFPD
    Click Finish PNR    Amend Booking For Verify That APIS/SFPD Is Captured And Written Upon Finish PNR For IN
