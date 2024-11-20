*** Settings ***
Test Teardown     Take Screenshot On Failure
Force Tags        amadeus    apac
Resource          ../air_fare_verification.robot

*** Test Cases ***
[NB IN] Verify That Nett Fare Is Captured On UI, Validate Values From TST And Hidden Commision % Is Validated As FM Remark
    [Documentation]    If test case fails make sure the price quote of fare 1 is associated with Nett Fare.
    ...    If no nettfare please change itinerary/pricequote commands to get nett fare in Fare 1
    [Tags]    us2165    in
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US273    BEAR    INTWOSEVENTHREE
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA AIR/VI************1122/D0622/CVV***
    Update PNR With Default Values    Client Info
    Book Flight X Months From Now    SINFRA/ASQ    SS1Y1    FXP/R,U/S2    5
    Book Flight X Months From Now    FRABLR/ALH    SS1Y1    FXP/S3    5    11
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Nett Fare Field Is Disabled
    Click Fare Tab    Fare 2
    Verify Nett Fare Field Is Enabled
    Set Nett Fare Field    Fare 2    1000
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details From Amadeus
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Nett Fare Value    Fare 1
    Get Airline Commission Percentage Value    Fare 1
    Verify Nett Fare Value Is Correct Based On Value From TST    Fare 1    Auto Entry
    Click Fare Tab    Fare 2
    Get Nett Fare Value    Fare 2
    Get Airline Commission Percentage Value    Fare 2
    Verify Nett Fare Value Is Correct Based On Value From TST    Fare 2    Manual Entry
    Verify FM Remarks For Airline Commission Is Written    Fare 1    F    S2
    Verify FM Remarks For Airline Commission Is Written    Fare 2    M    S3

[NB IN] Verify That High, Low And Charged Fare Are Written In The PNR
    [Tags]    us273    US2105    in    howan    us2098    us2145
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US273    BEAR    INTWOSEVENTHREE
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA AIR/VI************1122/D0622/CVV***
    Update PNR With Default Values    Client Info
    Book Flight X Months From Now    SINMNL    SS1Y1    FXP/S2    5    6
    Book Flight X Months From Now    BLRBKK/ATG    SS1Y1    FXP/S3    5    11
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Verify High Fare Value Is Retrieved From TST    Fare 1    S2
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2
    Verify Low Fare Value Is Retrieved From TST    Fare 1    S2    INR    IN    v1    FXD
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Base Fare From TST    Fare 1    S2
    Get Mark-Up Amount Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare1    CWT
    Populate Fare Quote Tabs with Default Values
    Get Nett Fare Value    Fare 1
    Click Fare Tab    Fare 2
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S3
    Verify High Fare Value Is Retrieved From TST    Fare 2    S3
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S3
    Verify Low Fare Value Is Retrieved From TST    Fare 2    S3    INR    IN    v3    FXD
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Base Fare From TST    Fare 2    S3
    Get Mark-Up Amount Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate Fare Quote Tabs with Default Values
    Get Nett Fare Value    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify FOP Remark Per TST Is Written    Fare 1    S2    VI4444222233331122/D0622    IN    CWT
    Verify FOP Remark Per TST Is Written    Fare 2    S3    VI4444222233331122/D0622    IN    Airline
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 1    S2    IN
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 2    S3    IN
    [Teardown]

[AB IN] Verify That High, Low And Charged Fare Are Written In The PNR When Flights Are Retained
    [Tags]    us273    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Low Fare Value Is Same From New Booking    Fare 1    v1    v2
    Verify High Fare Value Is Same From New Booking    Fare 1
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Mark-Up Amount Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Verify Low Fare Value Is Same From New Booking    Fare 2    v3    v4
    Verify High Fare Value Is Same From New Booking    Fare 2
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S3
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Mark-Up Amount Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That High, Low And Charged Fare Are Written In The PNR When Flights Are Retained For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That High, Low And Charged Fare Are Written In The PNR When Flights Are Retained For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 1    S2    IN
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 2    S3    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare
    [Documentation]    SO : Client Fee Geographical Regions for Identifying Route Codes Whether it is INTL or DOM.
    ...    Currently we have only INTL in Route Code Drop-down.
    [Tags]    us285    us404    us308    in    howan    us892
    ...    us1069    us2097    us2107    us2188
    Open Power Express And Retrieve Profile    ${version}    Test    u001mkr    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ XYZ AUTOMATION IN - US285    BEAR    INTWOEIGHTFIVE
    Select Client Account Value    3050300003 ¦ TEST 7TF BARCLAYS ¦ XYZ AUTOMATION IN - US285
    Click New Booking
    Select Form Of Payment    Cash
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    09AANCA6995Q1ZE
    Click Update PNR
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE    RT
    Book Flight X Months From Now    DELSIN/ASQ    SS1Y1    FXP/S2    5    5
    Book Flight X Months From Now    SINHKG/ACX    SS1Y1    FXP/S3    5    10
    Book Flight X Months From Now    BOMSIN/ASQ    SS1Y1    FXP/S4    5    15
    Book Flight X Months From Now    SINHKG/ASQ    SS1W1    FXP/R,U/S5    5    20
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Route Code Field Value    INTL
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 1    S2
    Select Route Code Value    DOM
    Get LFCC Field Value    Fare 1
    Select Fare Type    Published Fare
    Click Fare Tab    Fare 2
    Verify Route Code Field Value    INTL
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 2    S3
    Get LFCC Field Value    Fare 2
    Select Fare Type    Nett Remit Fare
    Click Fare Tab    Fare 3
    Verify Route Code Field Value    INTL
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 3    S4
    Get LFCC Field Value    Fare 3
    Select Fare Type    Corporate fare
    Click Fare Tab    Fare 4
    Verify Fare Type Default Value    CAT 35 Fare
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify FP Line Is Written In The PNR Per TST    Fare 1    CASH    S2    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 2    CASH    S3    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 3    CASH    S4    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 4    CASH    S5    ${EMPTY}    ${EMPTY}
    Verify That FOP Remark Is Written In The RM Lines    Cash
    Verify LFCC Accounting Remark Is Written    Fare 1    S2
    Verify LFCC Accounting Remark Is Written    Fare 2    S3
    Verify LFCC Accounting Remark Is Written    Fare 3    S4
    Verify PC Accounting Remark For Route Code Domestic Is Written    S2
    Verify PC Accounting Remark For Route Code International Is Written    S3    IN
    Verify PC Accounting Remark For Route Code International Is Written    S4    IN
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    S2
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    S3
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    S4
    Verify Correct Fare Type Is Written In The PNR    Fare 1    Published Fare    DOM
    Verify Correct Fare Type Is Written In The PNR    Fare 2    Nett Remit Fare    INTL
    Verify Correct Fare Type Is Written In The PNR    Fare 3    Corporate Fare    INTL
    Verify Correct Fare Type Is Written In The PNR    Fare 4    CAT 35 Fare    INTL
    Verify Agent Sign Remark Is Written    RM *BA/1234MR
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM

[AB IN] Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare
    [Documentation]    SO : Client Fee Geographical Regions for Identifying Route Codes Whether it is INTL or DOM.
    ...    Currently we have only INTL in Route Code Drop-down.
    [Tags]    us285    us404    us308    in    howan    us892
    ...    us1069
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/ALL    XE2-5    RT    RT
    Book Flight X Months From Now    LAXORD/AUA    SS1Y1    FXP/S2    6    0
    Book Flight X Months From Now    DENYYC/AUA    SS1Y1    FXP/S3    6    3
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    09AANCA6995Q1ZE
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 1
    Verify Route Code Field Value    INTL
    Get LFCC Field Value    Fare 1
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 2    S3
    Verify Route Code Field Value    INTL
    Get LFCC Field Value    Fare 2
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify LFCC Accounting Remark Is Written    Fare 1    S2
    Verify LFCC Accounting Remark Is Written    Fare 2    S3
    Verify PC Accounting Remark For Route Code Domestic Is Not Written    S2
    Verify PC Accounting Remark For Route Code Domestic Is Not Written    S3
    Verify PC Accounting Remark For Route Code International Is Written    S2    IN
    Verify PC Accounting Remark For Route Code International Is Written    S3    IN
    Verify Agent Sign Remark Is Written    RM *BA/1234MR
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    S2
    Verify FF34, FF35, FF36 And FF38 Accounting Remarks Are Written    S3
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN UA HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA UA HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP UA HK1 IND/918046412400    SSR GSTE UA HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Correct Routing Itinerary Remarks And Turnaround Accounting Remarks Are Written For Multiple Fares
    [Tags]    us274    US2105    in    howan    us2173    us2184
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ APAC SYN IN    BEAR    INDI
    Select Client Account Value    3024300001 ¦ EQUANT SOLUTIONS INDIA P LTD GGN ¦ APAC SYN IN
    Click New Booking
    Click Panel    Client Info
    Select Form Of Payment    BTA CTCL VI/VI************7710/D0823
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    06AABCE4540P1ZH
    Click Update PNR
    Verify GSTIN FF95 Is Written    06AABCE4540P1ZH    RT
    Book Flight X Months From Now    DELBMI/AAA    SS1Y1    FXP/S2-4    6    3
    Book Flight X Months From Now    LAXORD/AUA    SS1Y1    FXP/S5    6    5
    Book Flight X Months From Now    HKGBKK/AHX    SS1Y1    \    6    6
    Book Flight X Months From Now    HKGMNL/AHX    SS1Y1    \    6    7
    Book Flight X Months From Now    HKGNRT/AHX    SS1Y1    FXP/S6-8    6    8
    Click Panel    Complete
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Routing Field Value    DEL-LHR-ORD-BMI
    Verify Turnaround Value Is Correct    Fare 1    ${EMPTY}
    Select Turnaround    LON
    Select FOP Merchant On Fare Quote Tab    Fare1    CWT
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2-4
    Get Routing Name    Fare 1
    Get Point Of Turnaround    Fare 1
    Click Fare Tab    Fare 2
    Verify Routing Field Value    LAX-ORD
    Verify Turnaround Value Is Correct    Fare 2    CHI
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 2    S5
    Get Routing Name    Fare 2
    Get Point Of Turnaround    Fare 2
    Click Fare Tab    Fare 3
    Verify Routing Field Value    HKG-BKK-HKG-MNL-HKG-NRT
    Select Turnaround    BKK
    Get Routing Name    Fare 3
    Get Point Of Turnaround    Fare 3
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify FOP Remark Per TST Is Written    Fare 1    S2-4    VI4484886032737710/D0823    IN    CWT
    Verify FOP Remark Per TST Is Written    Fare 2    S5    VI4484886032737710/D0823    IN    Airline
    Verify Routing Itinerary Remarks Are Written    Fare 1
    Verify Routing Itinerary Remarks Are Written    Fare 2
    Verify Routing Itinerary Remarks Are Written    Fare 3    RIR ROUTING: HONG KONG/BANGKOK//HONG KONG/MANILA//HONG KONG/TOKYO
    Verify Routing Accounting Remarks Are Written    Fare 1    S2-4
    Verify Routing Accounting Remarks Are Written    Fare 2    S5
    Verify Routing Accounting Remarks Are Written    Fare 3    S6-8
    Verify GSTIN FF95 Is Written    06AABCE4540P1ZH
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN AA HK1 IND/06AABCE4540P1ZH/ORANGE BUS SVCS INDIA SOL PVT LTD    SSR GSTA AA HK1 IND/TWR B C7TH8TH FLRDLF INFINITY/CYBERCITY PHASEII SCTR25/GURGAON/HARYANA/122002    SSR GSTP AA HK1 IND/1246654218    SSR GSTE AA HK1 IND/FINANCE.MSCINDIA//ORANGE.COM
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN UA HK1 IND/06AABCE4540P1ZH/ORANGE BUS SVCS INDIA SOL PVT LTD    SSR GSTA UA HK1 IND/TWR B C7TH8TH FLRDLF INFINITY/CYBERCITY PHASEII SCTR25/GURGAON/HARYANA/122002    SSR GSTP UA HK1 IND/1246654218    SSR GSTE UA HK1 IND/FINANCE.MSCINDIA//ORANGE.COM

[AB IN] Verify That Correct Routing Itinerary Remarks And Turnaround Accounting Remarks Are Written When Flights/Fares were retained For Multiple Fares
    [Tags]    us274    in    howan    us2184
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Routing Field Value    DEL-LHR-ORD-BMI
    Verify Turnaround Value Is Correct    Fare 1    LON
    Click Fare Tab    Fare 2
    Verify Routing Field Value    LAX-ORD
    Verify Turnaround Value Is Correct    Fare 2    CHI
    Enter GDS Command    TTE/ALL    XE2-8    RT
    Book Flight X Months From Now    LHREWR/AUA    SS1Y1    \    6    5
    Book Flight X Months From Now    JFKLHR/AUA    SS1Y1    FXP/S2-4    6    10
    Book Flight X Months From Now    MNLLHR/APR    SS1Y1    \    6    15
    Book Flight X Months From Now    LHRMNL/APR    SS1Y1    FXP/S5-6    6    17
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    06AABCE4540P1ZH
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Routing Field Value    LHR-EWR-JFK-DUB-LHR
    Verify Turnaround Value Is Correct    Fare 1    NYC
    Get Routing Name    Fare 1
    Get Point Of Turnaround    Fare 1
    Click Fare Tab    Fare 2
    Verify Routing Field Value    MNL-LHR-MNL
    Verify Turnaround Value Is Correct    Fare 2    LON
    Get Routing Name    Fare 2
    Get Point Of Turnaround    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Correct Routing Itinerary Remarks and Turnaround Accounting Remarks Are Written When Flights/Fares were retained for Multiple Fares For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That Correct Routing Itinerary Remarks and Turnaround Accounting Remarks Are Written When Flights/Fares were retained for Multiple Fares For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Routing Itinerary Remarks Are Written    Fare 1    RIR ROUTING: LONDON/NEWARK//NEW YORK/DUBLIN/LONDON
    Verify Routing Accounting Remarks Are Written    Fare 1    S2-4
    Verify Routing Itinerary Remarks Are Written    Fare 2
    Verify Routing Accounting Remarks Are Written    Fare 2    S5-6
    Verify GSTIN FF95 Is Written    06AABCE4540P1ZH
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN PR HK1 IND/06AABCE4540P1ZH/ORANGE BUS SVCS INDIA SOL PVT LTD    SSR GSTA PR HK1 IND/TWR B C7TH8TH FLRDLF INFINITY/CYBERCITY PHASEII SCTR25/GURGAON/HARYANA/122002 \    SSR GSTP PR HK1 IND/1246654218    SSR GSTE PR HK1 IND/FINANCE.MSCINDIA//ORANGE.COM \
    Verify SSR GST Remars Are Written Per Airline    SSR GSTN UA HK1 IND/06AABCE4540P1ZH/ORANGE BUS SVCS INDIA SOL PVT LTD    SSR GSTA UA HK1 IND/TWR B C7TH8TH FLRDLF INFINITY/CYBERCITY PHASEII SCTR25/GURGAON/HARYANA/122002    SSR GSTP UA HK1 IND/1246654218    SSR GSTE UA HK1 IND/FINANCE.MSCINDIA//ORANGE.COM
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Correct MIS Codes Are Listed, Pre-selected and Written to Back Office Remark for Multiple Fare
    [Tags]    us272    in    howan    us2097    us2188
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US272    BEAR    INTWOSVENTWO
    Click New Booking
    Update PNR With Default Values
    Comment    Book Flight X Months From Now    DELHKG/ACX    SS1Y1    \    6    3
    Comment    Book Flight X Months From Now    HKGSIN/ACX    SS1Y1    \    6    8
    Book Flight X Months From Now    MAADEL/AUK    SS1Y1    \    6    10
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    \    6    15
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP/S4    6    20
    Book Flight X Months From Now    DELMAA/AUK    SS1Y1    FXP/S5    6    23
    Enter GDS Command    FXA/S2    FXU2    FXP/S3
    Click Read Booking
    Click Panel    Client Info
    Select Form Of Payment    Invoice
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select Fare Type    Published Fare
    Select Route Code Value    INTL
    Verify Realised Savings Code Functionality    Fare 1
    Verify Missed Savings Code Is Mandatory And Has No Value
    Verify Class Code Is Mandatory And Has No Value
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Class Code Dropdown Values Are Correct    Fare 1
    Populate Air Fare Savings Code    XX - NO SAVING    Z - CWT ALTERNATIVE DECLINED    YW - Economy Class CWT Negotiated Fare
    Set High Fare Field (If blank) with Charged Fare
    Set Low Fare Field (If blank) with Charged Fare
    Set Transaction Fee Value Default Value If Empty    Fare 1    0
    Get Savings Code    Fare 1
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Select Fare Type    Nett Remit Fare
    Verify Realised Savings Code Functionality    Fare 2
    Verify Missed Savings Code Is Mandatory And Has No Value
    Verify Class Code Is Mandatory And Has No Value
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Class Code Dropdown Values Are Correct    Fare 2
    Populate Air Fare Savings Code    XI - ROUTE DEAL ACCEPTED    X - POLICY WAIVED - EMERGENCY CONDITIONS    YC - Economy Class Corporate Fare
    Set High Fare Field (If blank) with Charged Fare
    Set Low Fare Field (If blank) with Charged Fare
    Set Transaction Fee Value Default Value If Empty    Fare 2    0
    Get Savings Code    Fare 2
    Click Fare Tab    Fare 3
    Select Fare Type    Corporate fare
    Populate Air Fare Savings Code    XX - NO SAVING    Z - CWT ALTERNATIVE DECLINED    YW - Economy Class CWT Negotiated Fare
    Get Savings Code    Fare 3
    Click Fare Tab    Fare 4
    Select Fare Type    CAT 35 Fare
    Select Route Code Value    DOM
    Populate Air Fare Savings Code    XI - ROUTE DEAL ACCEPTED    X - POLICY WAIVED - EMERGENCY CONDITIONS    YC - Economy Class Corporate Fare
    Get Savings Code    Fare 4
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify That FOP Remark Is Written In The RM Lines    Invoice
    Verify FP Line Is Written In The PNR Per TST    Fare 1    Invoice    S2    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 2    Invoice    S3    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 3    Invoice    S4    ${EMPTY}    ${EMPTY}
    Verify FP Line Is Written In The PNR Per TST    Fare 4    Invoice    S5    ${EMPTY}    ${EMPTY}
    Verify FF30, FF8 and EC Account Remarks Are Written    Fare 1    S2
    Verify FF30, FF8 and EC Account Remarks Are Written    Fare 2    S3
    Verify FF30, FF8 and EC Account Remarks Are Written    Fare 3    S4
    Verify FF30, FF8 and EC Account Remarks Are Written    Fare 4    S5
    Verify Correct Fare Type Is Written In The PNR    Fare 1    Published Fare    INTL
    Verify Correct Fare Type Is Written In The PNR    Fare 2    Nett Remit Fare    DOM
    Verify Correct Fare Type Is Written In The PNR    Fare 3    Corporate Fare    DOM
    Verify Correct Fare Type Is Written In The PNR    Fare 4    CAT 35 Fare    DOM

[AB IN] Verify That Correct MIS Codes Are Listed, Pre-selected and Written To Back Office Remark For Multiple Fares
    [Tags]    us272    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Default Value    XX - NO SAVING
    Verify Missed Savings Code Default Value    Z - CWT ALTERNATIVE DECLINED
    Verify Class Code Default Value Is Correct    YW - Economy Class CWT Negotiated Fare
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Class Code Dropdown Values Are Correct    Fare 1
    Click Fare Tab    Fare 2
    Verify Realised Savings Code Default Value    XI - ROUTE DEAL ACCEPTED
    Verify Missed Savings Code Default Value    X - POLICY WAIVED - EMERGENCY CONDITIONS
    Verify Class Code Default Value Is Correct    YC - Economy Class Corporate Fare
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Class Code Dropdown Values Are Correct    Fare 2
    Enter GDS Command    TTE/ALL    XE2    FXP
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Default Value    XX - NO SAVING
    Verify Missed Savings Code Is Mandatory And Has No Value
    Verify Class Code Is Mandatory And Has No Value
    Populate Air Fare Savings Code    XX - NO SAVING    A - PARTIAL MISSED SAVING    CC - Business Class Corporate Fare
    Set Transaction Fee Value Default Value If Empty    Fare 1    0
    Get Savings Code    Fare 1
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Correct MIS Codes Are Listed, Pre-selected and Written To Back Office Remark For Multiple Fares For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That Correct MIS Codes Are Listed, Pre-selected and Written To Back Office Remark For Multiple Fares For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify FF30, FF8 and EC Account Remarks Are Written    Fare 1    S2
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats
    [Tags]    DE81    DE80    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US273    BEAR    INTWOSEVENTHREE
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now Without Pricing    DELSFO/AAC    SS1Y1    4    12
    Book Flight X Months From Now    SFODEL/AAC    SS1Y1    FXP/S2-5    4    18
    Book Flight X Months From Now Without Pricing    DELFRA/ALH    SS1Y1    4    21
    Book Flight X Months From Now    FRADEL/ALH    SS1Y1    FXP/S6-7    4    26
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify High Fare Value Is Retrieved From TST    Fare 1    S2,3,4,5
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2,3,4,5
    Verify Low Fare Value Is Retrieved From TST    Fare 1    S2,3,4,5    INR    IN
    Get High Fare Value    Fare 1
    Get Low Fare Value    Fare 1
    Get Nett Fare Value    Fare 1
    Get Base Fare From TST    Fare 1    S2,3,4,5
    Get Mark-Up Amount Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Click Fare Tab    Fare 2
    Verify High Fare Value Is Retrieved From TST    Fare 2    S6-7
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S6-7
    Verify Low Fare Value Is Retrieved From TST    Fare 2    S6-7    INR    IN
    Get High Fare Value    Fare 2
    Get Low Fare Value    Fare 2
    Get Nett Fare Value    Fare 2
    Get Base Fare From TST    Fare 2    S6-7
    Get Mark-Up Amount Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 1    S2-5    IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 2
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 2    S6-7    IN

[AB IN] Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats
    [Tags]    DE81    DE80    in    howan
    [Setup]
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Low Fare Value Is Same From New Booking    Fare 1
    Verify High Fare Value Is Same From New Booking    Fare 1
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2,3,4,5
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Mark-Up Amount Value    Fare 1
    Get Nett Fare Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Populate Fare Details And Fees Tab With Default Values
    Click Fare Tab    Fare 2
    Verify Low Fare Value Is Same From New Booking    Fare 2
    Verify High Fare Value Is Same From New Booking    Fare 2
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S6-7
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Mark-Up Amount Value    Fare 2
    Get Nett Fare Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate Fare Details And Fees Tab With Default Values
    Click Finish PNR    Amend Booking For Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 1
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 1    S2-5    IN
    Verify Adult Fare And Taxes Itinerary Remarks Are Written    Fare 2
    Verify RF, LF And SF Accounting Remarks Per TST Are Written    Fare 2    S6-7    IN
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That On Hold Remarks Are Not Written When Fare Is Finalized And TST Is Complete
    [Tags]    us773    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US710    BEAR    INSEVENONEZERO
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    DELSFO/AEK    SS1Y1    FXP/S2-3    5    3
    Book Flight X Months From Now    SFODEL/AEK    SS1Y1    FXP/S4-5    6    3
    Click Read Booking
    Click Panel    Air Fare
    Verify Panel Is Red    Air Fare
    Verify Fare Not Finalised Is Enabled
    Verify Fare Not Finalised Is Unticked
    Verify Specific Warning In Air Fare Is Shown    ${EMPTY}
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify On Hold Booking Reason Is Unchecked    Awaiting Fare Details
    Verify On Hold Booking Reason Is Disabled    Awaiting Fare Details
    Select Delivery Method    No Queue Placement
    Set Ticketing Date    6
    Set Email Address In Delivery Panel
    Get Follow Update Value
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHQ
    Verify On Hold Queue Place Is Written In The PNR    BLRWL22MS    64    C0
    Retrieve PNR Details from Amadeus    ${current_pnr}    RHO
    Verify On Hold Queue Minder Is Written In The PNR    BLRWL22MS    64    C0
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify RIR On Hold Reason Remarks Are Not Written    Awaiting Fare Details
    Verify Ticketing RMM Remarks Are Not Written    Awaiting Fare Details

[AB IN] Verify That On Hold Remarks Are Not Written When Fare Is Finalized And TST Is Partially Complete
    [Tags]    us773    in    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/T1
    Click Read Booking
    Click Panel    Air Fare
    Verify Fare Not Finalised Is Enabled
    Verify Fare Not Finalised Is Unticked
    Verify Specific Warning In Air Fare Is Shown    Warning - No fare found for segment 2-3. \ If necessary, please fare quote and read the PNR again.
    Click Panel    Cust Refs
    Set CDR Value    Cost Centre    AD
    Set CDR Value    Designation    EEE.EE/EE*N_A@DD
    Set CDR Value    Employee ID    WWW-RR
    Click Panel    Policy Check
    Select Policy Status    India Malaria    TA - Traveller/Booker Advised
    Populate All Panels (Except Given Panels If Any)    Delivery    Cust Refs    Policy Check
    Click Panel    Delivery
    Verify On Hold Booking Reason Is Unchecked    Awaiting Fare Details
    Verify On Hold Booking Reason Is Disabled    Awaiting Fare Details
    Select Delivery Method    Auto Ticket
    Set Ticketing Date    6
    Set Email Address In Delivery Panel
    Comment    Get Follow Update Value
    Click Finish PNR    Amend Booking For Verify That On Hold Remarks Are Written When Fare Is Finalized And TST Is Partially Complete
    Execute Simultaneous Change Handling    Amend Booking For Verify That On Hold Remarks Are Written When Fare Is Finalized And TST Is Partially Complete
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify On Hold Queue Place Is Not Written In The PNR    BLRWL22MS    64    C0    1
    Comment    Verify On Hold Queue Minder Is Not Written In The PNR    BLRWL22MS    64    C0    2
    Verify Ticketing RIR Remarks    TLIS
    Verify RIR On Hold Reason Remarks Are Not Written    Awaiting Fare Details
    Verify Ticketing RMM Remarks Are Not Written    Awaiting Fare Details

[AB IN] Verify That On Hold Remarks Are Written And Fare Remarks Are Not Written When Fare Is Not Finalized
    [Tags]    us773    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Air Fare
    Tick Fare Not Finalised
    Verify Air Fare Fields Are Disabled
    Click Restriction Tab
    Verify Default Restrictions Field Is Disabled
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify On Hold Booking Reason Is Disabled    Awaiting Fare Details
    Verify Specific On Hold Reason Status    Awaiting Fare Details    True
    Select Delivery Method    Auto Ticket
    Set Ticketing Date    6
    Set Email Address In Delivery Panel
    Click Finish PNR    Amend Booking For Verify That On Hold Remarks Are Written And Fare Remarks Are Not Written When Fare Is Not Finalized
    Execute Simultaneous Change Handling    Amend Booking For Verify That On Hold Remarks Are Written And Fare Remarks Are Not Written When Fare Is Not Finalized
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Ticketing RIR Remarks    TLXL
    Verify RIR On Hold Reason Remarks Are Written    Awaiting Fare Details
    Verify Ticketing RMM Remarks Are Written    Awaiting Fare Details
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[AB IN] Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    [Tags]    us1032    in    howan    us2097    us2209
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US272    BEAR    INTWOSVENTWO
    Click New Booking
    Update PNR With Default Values
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify MIS Remark is Written In The PNR
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Book Flight X Months From Now    HKGMNL/APR    SS1Y1    FXP    6    3
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Functionality    Fare 1
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Set Low Fare Field With Charged Fare
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Finish PNR    1st Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Execute Simultaneous Change Handling    1st Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify MIS Remark Is Not Written In The PNR
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/ALL    XI    RFCWTPTEST    ER    ER
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    2nd Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Execute Simultaneous Change Handling    2nd Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify MIS Remark is Written In The PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF
    [Tags]    us1032    in    howan    us2106
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Select GDS    Amadeus
    Set Client And Traveler    APAC SYN CORP ¦ AUTOMATION IN - US272    BEAR    INTWOSVENTWO
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    CDGNCE/AAF    SS1Y1    FXP/S2    4    3
    Book Flight X Months From Now    CDGLAX/AAF    SS1Y1    FXP/S3    4    7
    Book Flight X Months From Now    SINHKG/ASQ    SS1Y1    FXP/S4    4    11
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Set Low Fare Field    100
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Displayed    Invalid Missed Saving Code
    Select Missed Saving Code Value    E - EXCHANGE
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}    RTF
    Verify Tour Code Remark Per TST Is Written    A007    S2
    Verify Tour Code Remark Per TST Is Written    A007    S3
    Verify Tour Code Remark Per TST Is Not Written    QA_TEST_EXPIRED    S4
    Verify FE Line Is Written In The PNR Per TST    BG:AF    S3

[AB IN] Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF
    [Tags]    us1032    in    howan    us2106
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Update FT Remark    A007_UPDATED    S2    A007
    Update FT Remark    ATEST_ADDED    S4
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Set Low Fare Field    100
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Displayed    Invalid Missed Saving Code
    Select Missed Saving Code Value    M - MISCELLANEOUS
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Fare Tab    Fare 2
    Set Low Fare Field    110
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Displayed    Invalid Missed Saving Code
    Select Missed Saving Code Value    B - PASSENGER REQUESTED SPECIFIC AIRLINE
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Finish PNR    Amend Booking for Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF
    Execute Simultaneous Change Handling    Amend Booking for Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF
    Retrieve PNR Details from Amadeus    ${current_pnr}    RTF
    Verify Tour Code Remark Per TST Is Written    A007_UPDATED    S2
    Verify Tour Code Remark Per TST Is Written    ATEST_ADDED    S4
    Verify Tour Code Remark Per TST Is Written    A007    S3
    Verify Tour Code Remark Per TST Is Not Written    A007    S2
    Verify Tour Code Remark Per TST Is Not Written    QA_Test_Expired    S4
    Verify FE Line Is Written In The PNR Per TST    BG:AF    S3
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That GSTIN Is Captured For Multipax
    [Tags]    in    us2258
    Open Power Express And Retrieve Profile    ${version}    Test    u001mkr    en-GB    mruizapac    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ XYZ AUTOMATION IN - US285    BEAR    INTWOEIGHTFIVE
    Select Client Account Value    3050300003 ¦ TEST 7TF BARCLAYS ¦ XYZ AUTOMATION IN - US285
    Click New Booking
    Add Additional Pax    WATSON/JOHN MRS    WATSON/JOHN CHD
    Select Form Of Payment    Cash
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    09AANCA6995Q1ZE
    Click Update PNR
    Verify GSTIN FF95 Is Written    09AANCA6995Q1ZE    RT
    Book Flight X Months From Now    DELSIN/ASQ    SS3Y1    \    5    5
    Pricing The Fare For Multipax    3    4
    Book Flight X Months From Now    SINHKG/ACX    SS3Y1    \    5    10
    Pricing The Fare For Multipax    3    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify SSR GST Remars Are Written Per Airline Per Pax    1    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PV TLTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    2    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVT LTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    3    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVT LTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    1    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVT LTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    2    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVT LTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    3    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVT LTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA /UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM

[AB IN] Verify That GSTIN Is Captured For Multipax
    [Tags]    in    us2258
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify GSTIN Is Captured For Multipax For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify GSTIN Is Captured For Multipax For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify SSR GST Remars Are Written Per Airline Per Pax    1    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    2    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Not Written Per Airline Per Pax    3    SSR GSTN CX HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA CX HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP CX HK1 IND/918046412400    SSR GSTE CX HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    1    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Written Per Airline Per Pax    2    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    Verify SSR GST Remars Are Not Written Per Airline Per Pax    3    SSR GSTN SQ HK1 IND/09AANCA6995Q1ZE/ALSTOM SYSTEMS INDIA PVTLTD    SSR GSTA SQ HK1 IND/CHANDRA RESORT/MAIN NH2 FIROZABAD/TUNDLA/UTTARPRADESH/283204    SSR GSTP SQ HK1 IND/918046412400    SSR GSTE SQ HK1 IND/SM.IST.IN.GST//ALSTOMGROUP.COM
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That Correct MIS Codes Are Listed, Pre-selected and Written To Back Office Remark For Multiple Fares For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Default Value    XX - NO SAVING
    Verify Missed Savings Code Default Value    Z - CWT ALTERNATIVE DECLINED
    Verify Class Code Default Value Is Correct    YW - Economy Class CWT Negotiated Fare
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 1    IN
    Verify Class Code Dropdown Values Are Correct    Fare 1
    Click Fare Tab    Fare 2
    Verify Realised Savings Code Default Value    XI - ROUTE DEAL ACCEPTED
    Verify Missed Savings Code Default Value    X - POLICY WAIVED - EMERGENCY CONDITIONS
    Verify Class Code Default Value Is Correct    YC - Economy Class Corporate Fare
    Verify Realised Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Missed Saving Code Dropdown Values Are Correct    Fare 2    IN
    Verify Class Code Dropdown Values Are Correct    Fare 2
    Enter GDS Command    TTE/ALL    XE2    FXP
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Default Value    XX - NO SAVING
    Verify Missed Savings Code Is Mandatory And Has No Value
    Verify Class Code Is Mandatory And Has No Value
    Populate Air Fare Savings Code    XX - NO SAVING    A - PARTIAL MISSED SAVING    CC - Business Class Corporate Fare
    Set Transaction Fee Value Default Value If Empty    Fare 1    0
    Get Savings Code    Fare 1
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Correct MIS Codes Are Listed, Pre-selected and Written To Back Office Remark For Multiple Fares For IN

Amend Booking For Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/ALL    XE2-5    RT    RT
    Book Flight X Months From Now    LAXORD/AUA    SS1Y1    FXP/S2    6    0
    Book Flight X Months From Now    DENYYC/AUA    SS1Y1    FXP/S3    6    3
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    09AANCA6995Q1ZE
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 1
    Verify Route Code Field Value    INTL
    Get LFCC Field Value    Fare 1
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Verify LFCC Value Is Retrieved From FV Line In TST    Fare 2    S3
    Verify Route Code Field Value    INTL
    Get LFCC Field Value    Fare 2
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Air Miscellaneous Information Are Pre-populated And Remarks Are Written For Multiple Fare For IN

Amend Booking For Verify That High, Low And Charged Fare Are Written In The PNR When Flights Are Retained For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Populate All Panels (Except Given Panels If Any)
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Low Fare Value Is Same From New Booking    Fare 1
    Verify High Fare Value Is Same From New Booking    Fare 1
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Mark-Up Amount Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Verify Low Fare Value Is Same From New Booking    Fare 2
    Verify High Fare Value Is Same From New Booking    Fare 2
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S3
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Mark-Up Amount Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That High, Low And Charged Fare Are Written In The PNR When Flights Are Retained For IN

Amend Booking For Verify That Correct Routing Itinerary Remarks and Turnaround Accounting Remarks Are Written When Flights/Fares were retained for Multiple Fares For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Routing Field Value    DEL-LHR-ORD-BMI
    Verify Turnaround Value Is Correct    Fare 1    LON
    Click Fare Tab    Fare 2
    Verify Routing Field Value    LAX-ORD
    Verify Turnaround Value Is Correct    Fare 2    CHI
    Enter GDS Command    TTE/ALL    XE2-8    RT
    Book Flight X Months From Now    LHREWR/AUA    SS1Y1    \    6    5
    Book Flight X Months From Now    JFKLHR/AUA    SS1Y1    FXP/S2-4    6    10
    Book Flight X Months From Now    MNLLHR/APR    SS1Y1    \    6    15
    Book Flight X Months From Now    LHRMNL/APR    SS1Y1    FXP/S5-6    6    17
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    GSTIN    06AABCE4540P1ZH
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Routing Field Value    LHR-EWR-JFK-DUB-LHR
    Verify Turnaround Value Is Correct    Fare 1    NYC
    Get Routing Name    Fare 1
    Get Point Of Turnaround    Fare 1
    Click Fare Tab    Fare 2
    Verify Routing Field Value    MNL-LHR-MNL
    Verify Turnaround Value Is Correct    Fare 2    LON
    Get Routing Name    Fare 2
    Get Point Of Turnaround    Fare 2
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That Correct Routing Itinerary Remarks and Turnaround Accounting Remarks Are Written When Flights/Fares were retained for Multiple Fares For IN

Amend Booking For Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Low Fare Value Is Same From New Booking    Fare 1
    Verify High Fare Value Is Same From New Booking    Fare 1
    Verify Charged Fare Value Is Retrieved From TST    Fare 1    S2,3,4,5
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Mark-Up Amount Value    Fare 1
    Get Nett Fare Value    Fare 1
    Get Commission Rebate Amount Value    Fare 1
    Populate Fare Details And Fees Tab With Default Values
    Click Fare Tab    Fare 2
    Verify Low Fare Value Is Same From New Booking    Fare 2
    Verify High Fare Value Is Same From New Booking    Fare 2
    Verify Charged Fare Value Is Retrieved From TST    Fare 2    S6-7
    Get High, Charged And Low Fare In Fare Tab    Fare 2
    Get Mark-Up Amount Value    Fare 2
    Get Nett Fare Value    Fare 2
    Get Commission Rebate Amount Value    Fare 2
    Populate Fare Details And Fees Tab With Default Values
    Click Finish PNR    Amend Booking For Verify That High, Low, And Charged Fare Are Written In The PNR When FXA And FXL Responses Have Different Formats For IN

Verify Realised Savings Code Functionality
    [Arguments]    ${fare_tab}
    Get Charged Fare Value    ${fare_tab}
    Get High Fare Value    ${fare_tab}
    Run Keyword If    "${charged_value_${fare_tab_index}}" == "${high_fare_value_${fare_tab_index}}"    Verify Realised Savings Code Default Value    XX - NO SAVING
    ...    ELSE    Verify Realised Savings Code Is Mandatory And Has No Value

Get Agent Sign Remark From GDS Screen
    Activate Power Express Window
    Retrieve PNR Details From Amadeus    \    RT    False

Amend Booking For Verify That On Hold Remarks Are Written When Fare Is Finalized And TST Is Partially Complete
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/T1
    Click Read Booking
    Click Panel    Air Fare
    Verify Fare Not Finalised Is Enabled
    Verify Fare Not Finalised Is Unticked
    Verify Specific Warning In Air Fare Is Shown    Warning - No fare found for segment 2-3. \ If necessary, please fare quote and read the PNR again.
    Click Panel    Cust Refs
    Set CDR Value    Cost Centre    AD
    Set CDR Value    Designation    EEE.EE/EE*N_A@DD
    Set CDR Value    Employee ID    WWW-RR
    Click Panel    Policy Check
    Select Policy Status    India Malaria    TA - Traveller/Booker Advised
    Populate All Panels (Except Given Panels If Any)    Delivery    Cust Refs    Policy Check
    Click Panel    Delivery
    Verify On Hold Booking Reason Is Unchecked    Awaiting Fare Details
    Verify On Hold Booking Reason Is Disabled    Awaiting Fare Details
    Select Delivery Method    Auto Ticket
    Set Ticketing Date    6
    Set Email Address In Delivery Panel
    Comment    Get Follow Update Value
    Click Finish PNR    Amend Booking For Verify That On Hold Remarks Are Written When Fare Is Finalized And TST Is Partially Complete

Amend Booking For Verify That On Hold Remarks Are Written And Fare Remarks Are Not Written When Fare Is Not Finalized
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Click Panel    Air Fare
    Tick Fare Not Finalised
    Verify Air Fare Fields Are Disabled
    Click Restriction Tab
    Verify Default Restrictions Field Is Disabled
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify On Hold Booking Reason Is Disabled    Awaiting Fare Details
    Verify Specific On Hold Reason Status    Awaiting Fare Details    True
    Select Delivery Method    Auto Ticket
    Set Ticketing Date    6
    Set Email Address In Delivery Panel
    Click Finish PNR    Amend Booking For Verify That On Hold Remarks Are Written And Fare Remarks Are Not Written When Fare Is Not Finalized

Amend Booking for Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Update FT Remark    A007_UPDATED    S2    A007
    Update FT Remark    ATEST_ADDED    S4
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Set Low Fare Field    100
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Displayed    Invalid Missed Saving Code
    Select Missed Saving Code Value    M - MISCELLANEOUS
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Fare Tab    Fare 2
    Set Low Fare Field    110
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Displayed    Invalid Missed Saving Code
    Select Missed Saving Code Value    B - PASSENGER REQUESTED SPECIFIC AIRLINE
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Finish PNR    Amend Booking for Verify That Invalid Missed Saving Code Error Message Is Displayed When CF > LF

Verify MIS Remark is Written In The PNR
    Add Days On Current Date    90
    Convert Month From MM to MMM    ${mm}
    Verify Specific Line Is Written In The PNR    MIS 1A HK1 XXX ${dd}${month_MMM}-****

Verify MIS Remark Is Not Written In The PNR
    Add Days On Current Date    90
    Convert Month From MM to MMM    ${mm}
    Verify Specific Line Is Not Written In The PNR    MIS 1A HK1 XXX ${dd}${month_MMM}-****

1st Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Book Flight X Months From Now    HKGMNL/APR    SS1Y1    FXP/S2    6    3
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Verify Realised Savings Code Functionality    Fare 1
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Air Fare
    Set Low Fare Field With Charged Fare
    Select Missed Saving Code Value    L - NO MISSED SAVING
    Verify Invalid Missed Saving Code Error Message Is Not Displayed
    Click Finish PNR    1st Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF

2nd Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    TTE/ALL    XI    RFCWTPTEST    ER    ER
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    2nd Amend Booking For Verify That MIS Remark Is Written If No Segment Booked And Invalid Missed Saving Code Error Message Is Not Displayed When CF = LF

Verify Nett Fare Value Is Correct Based On Value From TST
    [Arguments]    ${fare_tab}    ${nett_fare_type}
    [Documentation]    nett_fare_type=='Manual Entry' - When Nett Fare is entered through PEx UI
    ...    else(nett_fare_type=='Auto Entry') it is considered that the fare quote already ha Nett Fare associated to it
    ${fare_tab_index}    Fetch From Right    ${fare_tab}    ${SPACE}
    ${gds_screen_data}    Run Keyword If    '${nett_fare_type}'=='Manual Entry'    Get Data From GDS Screen    TQT/T${fare_tab_index}
    ...    ELSE    Get Data From GDS Screen    TQN/T${fare_tab_index}
    ${netfare_string}    Run Keyword If    '${nett_fare_type}'=='Manual Entry'    Get String Matching Regexp    (NETFARE\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${gds_screen_data}
    ...    ELSE    Get String Matching Regexp    (EQUIV\\s+\\w+\\s+\\s+\\d+\.?\\d+)    ${gds_screen_data}
    ${net_fare_tst_value}    Remove All Non-Integer (retain period)    ${netfare_string}
    Verify Nett Fare Value    ${fare_tab}    ${net_fare_tst_value}

Pricing The Fare For Multipax
    [Arguments]    ${number_pax}    ${segment_no}
    : FOR    ${index}    IN RANGE    1    ${number_pax} +1
    \    Enter GDS Command    FXP/P${index}/S${segment_no}
    \    Enter GDS Command    FXT1/P${index}
    Log    Pricing done for multipax

Add Additional Pax
    [Arguments]    @{pax_list}
    ${end_of _list}    Get Length    ${pax_list}
    : FOR    ${index}    IN RANGE    0    ${end_of _list}
    \    ${pax_value}    Get From List    ${pax_list}    ${index}
    \    Enter GDS Command    NM1${pax_value}
    Log    Additional Pax added

Verify SSR GST Remars Are Written Per Airline Per Pax
    [Arguments]    ${passenger_no}    @{ssr_gst_remarks}
    : FOR    ${ssr_gst_remark}    IN    @{ssr_gst_remarks}
    \    Verify Specific Line Is Written In The PNR X Times    ${ssr_gst_remark}/P${passenger_no}    1    true

Verify SSR GST Remars Are Not Written Per Airline Per Pax
    [Arguments]    ${passenger_no}    @{ssr_gst_remarks}
    : FOR    ${ssr_gst_remark}    IN    @{ssr_gst_remarks}
    \    Verify Specific Line Is Not Written In The PNR    ${ssr_gst_remark}/P${passenger_no}    false    true

Amend Booking For Verify GSTIN Is Captured For Multipax For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify GSTIN Is Captured For Multipax For IN
