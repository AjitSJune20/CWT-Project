*** Settings ***
Suite Setup
Test Teardown     Take Screenshot On Failure
Force Tags        air    amadeus
Resource          other_services.robot

*** Test Cases ***
[NB] Verify That Air BSP Accounting Remarks Are Written When FOP Is Credit Card And UATP Is Full Passthrough
    [Tags]    us2071    us2235    us2308    us2291    us2293    not_ready
    Create PNR Using Credit Card As FOP    IN    True    passive_air_segment=True    add_multiple_passenger=True
    Click Panel    Other Svcs
    #Main Product: Air BSP
    Create Exchange Order Product And Vendor    Air BSp    UNITED AIRLINES    airbsp    True    True    False
    ...    MI
    Click Request Tab
    Tick Air Segment    6
    Verify Passenger Names Are Correct    1 BEAR, INOTHERS    2 CHARLES, LUKE MR (ADT)    3 MAXIMOFF, WANDA MRS    3 MAXIMOFF, KATIE (INF)    4 PYM, HANK MR (CHD)    5 STARK, TONY MR (ADT)
    Select Passenger    2 CHARLES, LUKE MR (ADT)
    Click Charges Tab
    Verify Other Services Fare Calculated Values    airbsp
    Verify Uatp Value Is Correct    Full Passthrough
    Click MI Tab
    Verify Reference Fare Value Is Correct    1040
    Populate MI Tab With Default Values
    Get Client Mi Control Details    airbsp
    Generate Expected Client MI Remarks    airbsp
    Click Add Button In EO Panel    Charges
    #Main Product: Air Domestic
    Create Exchange Order Product And Vendor    Air domestic    PRIME AIR GLOBAL LIMITED    airdomestic    True    True    False
    ...    Vendor Info
    Click Vendor Info Tab
    Verify Other Services Vendor Info Values Are Correct    Air Domestic Default
    Click MI Tab
    Get Client Mi Control Details    airdomestic
    Generate Expected Client MI Remarks    airdomestic
    Click Add Button In EO Panel    Charges
    #Remove Draft EO: Air Domestic
    Cancel Draft Exchange Order    Air domestic
    Verify Exchange Order Does Not Exists    Air domestic
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Air BSp
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air BSp    B.S.P.DOMESTIC SALES    airbsp    PC0    V00900031    06
    ...    CC    1    True    passenger_no=2
    #Subfees
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    06
    ...    CC    1    Vat    True    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    06
    ...    CC    1    Merchant Fee    True    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    06
    ...    CC    4    Vat    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airbsp    Air BSp    06
    ...    CC    1    Transaction Fee-Air Only    True    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    ${EMPTY}
    ...    CC    4    Vat    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    06
    ...    CC    1    Merchant Fee TF    True    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    06
    ...    CC    4    Vat    True    passenger_no=2
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airbsp    Air BSp    06
    ...    CC    1    Rebate    True    True    passenger_no=2

[AB] Verify That Air BSP And Air Domestic Accounting Remarks Are Written When FOP Is Credit Card And UATP Is Non Passthrough
    [Tags]    us2235    us2199    us2231    us2308    us2291    us2293
    ...    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    HKGSIN/ACX    SS5Y1    ${EMPTY}    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    #Main Product: Air BSP
    Click Amend Eo    ${eo_number}
    Verify Other Services Air Bsp Group Request Values Are Correct    airbsp
    Click Charges Tab
    Verify Other Services Air Charges Values Are Correct    airbsp
    Populate Other Services Related Details    cwt_ref_no3=${EMPTY}
    Populate Other Services Fare Calculation    1500    5    6    4    ${EMPTY}    20
    ...    25    30    250
    Get Other Services Charges Tab Details    airbsp    True    True    False
    Click Vendor Info Tab
    Verify Other Services Vendor Info Values Are Correct    airbsp
    Click MI Tab
    Verify Other Services MI Values Are Correct    airbsp
    Verify Client MI Grid View Details    FF25=11111    FF14=22222    FF13=COST1    FF66=COST2    FF63=333
    Get Client Mi Control Details    airbsp
    Click Add Button In EO Panel    Charges
    #Main Product: Air domestic
    Create Exchange Order Product And Vendor    Air domestic    B.S.P.DOMESTIC SALES    airdomestic    True    True    False
    ...    Request    Charges
    #Populate Request Tab
    Tick Air Segment    6    7
    Populate Request Tab For Air Bsp And Air Domestic    plating_carrier=CX
    Verify Passenger Names Are Correct    1 BEAR, INOTHERS    2 CHARLES, LUKE MR (ADT)    3 MAXIMOFF, WANDA MRS    3 MAXIMOFF, KATIE (INF)    4 PYM, HANK MR (CHD)    5 STARK, TONY MR (ADT)
    Select Passenger    4 PYM, HANK MR (CHD)
    #Populate Charges Tab
    Click Charges Tab
    Verify Uatp Value Is Correct    Non Passthrough
    Verify Merchant Fee Is Correct    2.25
    Populate Air Charges Tab With Default Values
    Click MI Tab
    Get Client Mi Control Details    airdomestic
    Generate Expected Client MI Remarks    airdomestic
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    #include Execute Simultaneous Change Handling    Other Svcs
    Get Exchange Order Number Using Product    Air domestic
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks: Air BSP
    Verify Air Remarks Are Written In The PNR    Air BSp    B.S.P.DOMESTIC SALES    airbsp    PC0    V00900031    07
    ...    CC    1    True
    #Subfees Accounting Remarks for Air BSP
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    07
    ...    CC    1    Merchant Fee    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airbsp    Air BSp    07
    ...    CC    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    07
    ...    CC    1    Merchant Fee TF    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airbsp    Air BSp    07
    ...    CC    1    Rebate    True    True
    #Main Product Accounting Remarks: Air Domesstic
    Verify Air Remarks Are Written In The PNR    Air domestic    B.S.P.DOMESTIC SALES    airdomestic    PC4    V00801418    0607
    ...    CX2    1    True    passenger_no=4    passenger_type=CHD
    #Subfees Accounting Remarks for Air Domestic
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    1    Vat    True    True    passenger_no=4
    ...    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airdomestic    Air domestic    0607
    ...    CX2    1    Merchant Fee    True    True    passenger_no=4
    ...    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True    passenger_no=4    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airdomestic    Air domestic    0607
    ...    CX2    1    Transaction Fee-Air Only    True    True    passenger_no=4
    ...    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True    passenger_no=4    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airdomestic    Air domestic    0607
    ...    CX2    1    Merchant Fee TF    True    True    passenger_no=4
    ...    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True    passenger_no=4    passenger_type=CHD
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airdomestic    Air domestic    0607
    ...    CX2    1    Rebate    True    True    passenger_no=4
    ...    passenger_type=CHD
    [Teardown]

[AB] Verify That Air BSP Accounting Remarks Are Not Written When EO Is Cancelled
    [Tags]    us2129    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_air bsp}
    Click Finish PNR
    #include Execute Simultaneous Change Handling    Other Svcs
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks: Air BSP
    Verify Air Remarks Are Written In The PNR    Air BSp    B.S.P.DOMESTIC SALES    airbsp    PC0    V00900031    07
    ...    CC    0    True
    #Subfees Accounting Remarks for Air BSP
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    0    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    07
    ...    CC    0    Merchant Fee    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    0    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airbsp    Air BSp    07
    ...    CC    0    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    0    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airbsp    Air BSp    07
    ...    CC    0    Merchant Fee TF    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airbsp    Air BSp    07
    ...    CC    0    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airbsp    Air BSp    07
    ...    CC    0    Rebate    True    True
    #Main Product Accounting Remarks: Air Domestic - Set Vendor back to BSP, place Vendor Info verification in Multiple EO test scripts
    Verify Air Remarks Are Written In The PNR    Air domestic    PRIME AIR GLOBAL LIMITED    airdomestic    PC4    V00801418    0607
    ...    CX2    1    True
    #Subfees Accounting Remarks for Air Domestic
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airdomestic    Air domestic    0607
    ...    CX2    1    Merchant Fee    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airdomestic    Air domestic    0607
    ...    CX2    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    airdomestic    Air domestic    0607
    ...    CX2    1    Merchant Fee TF    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airdomestic    Air domestic    0607
    ...    CX2    4    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airdomestic    Air domestic    0607
    ...    CX2    1    Rebate    True    True
    #General Remarks XO
    Verify Other Services General Remarks Are Written in PNR    Air domestic    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Air BSp    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB] Verify That Air Conso-Dom Accounting And General Remarks Are Written When FOP Is Cash
    [Tags]    us2072    us2308    not_ready    us2291
    Create PNR Using Cash As FOP    IN    True
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Air Conso-Dom    JET AIRWAYS    airconsodom    True    True    False
    ...    Charges    Vendor Info
    #Populate Charges Tab
    Click Charges Tab
    Verify Uatp Value Is Correct    ${EMPTY}
    Verify Merchant Fee Is Correct    ${EMPTY}
    Populate Other Services Pricing Paramerters Details
    Populate Other Services Related Details
    Populate Other Services Fare Calculation    merchant_fee=${EMPTY}
    Get Other Services Air Charges    airconsodom
    #Get MI Tab Values
    Click MI Tab
    Get Client Mi Control Details    airconsodom
    Generate Expected Client MI Remarks    airconsodom
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Air Conso-Dom
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks: Air Conso-Dom
    Verify Air Remarks Are Written In The PNR    Air Conso-Dom    JET AIRWAYS    airconsodom    PC2    V00900005    02
    ...    S    1    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    02
    ...    S    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airconsodom    Air Conso-Dom    02
    ...    S    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    02
    ...    S    2    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airconsodom    Air Conso-Dom    02
    ...    S    1    Rebate    True    True
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Air Conso-Dom    airconsodom

[AB] Verify That Air Conso-Dom Accounting And General Remarks Are Written When FOP Is Cash
    [Tags]    us2231    us2308    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    DELSIN/AEY    SS1Y1    ${EMPTY}    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    #Verify Air Conso-Dom EO Request Values Are Saved
    Click Amend Eo    ${eo_number}
    Verify Other Services Air Conso-Dom Or Air Sales-Non Bsp Int Request Values Are Correct    airconsodom
    #Amend Air Conso-Dom EO
    Click Charges Tab
    Populate Other Services Fare Calculation    1500    5    6    ${EMPTY}    100    20
    ...    25    30    250
    Get Other Services Charges Tab Details    airconsodom    True    True    False
    Click MI Tab
    Populate Client MI Control Details    3000    100    FD - First Class Discounted Fare    5J    Agent Booked    CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED
    ...    A - PARTIAL MISSED SAVING    9W    5000    AI    4000    FF25=1
    ...    FF14=2    FF13=3    FF66=4    FF63=5
    Get Client Mi Control Details    airconsodom
    Generate Expected Client MI Remarks    airconsodom
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    #To-do: Include Execute Simultaneous Change Handling    Other Svcs
    Get Exchange Order Number Using Product    Air Conso-Dom
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air Conso-Dom    JET AIRWAYS    airconsodom    PC2    V00900005    03
    ...    S    1    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    03
    ...    S    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airconsodom    Air Conso-Dom    03
    ...    S    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    03
    ...    S    2    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airconsodom    Air Conso-Dom    03
    ...    S    1    Rebate    True    True
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Air Conso-Dom    airconsodom
    [Teardown]

[AB] Verify That Air Conso-Dom Accounting Remarks Are Not Written When EO Is Cancelled
    [Tags]    us2129    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_air conso-dom}
    Click Finish PNR
    #To-do: Include Execute Simultaneous Change Handling    Other Svcs
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air Conso-Dom    JET AIRWAYS    airconsodom    PC2    V00900005    03
    ...    S    0    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    03
    ...    S    0    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airconsodom    Air Conso-Dom    03
    ...    S    0    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airconsodom    Air Conso-Dom    03
    ...    S    0    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airconsodom    Air Conso-Dom    03
    ...    S    0    Rebate    True    True
    #General Notepad Re1marks
    Verify Other Services General Remarks Are Written in PNR    Air Conso-Dom    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB] Verify That Air Sales-Non Bsp Int Accounting Remarks Are Written When FOP Is Invoice
    [Tags]    us2204    us2308    not_ready    us2291
    Create PNR Using Cash As FOP    IN    True    passive_air_segment=True    fop=Invoice
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Air Sales-Non BSP INT    QATAR AIRWAYS    airsales    True    True    False
    ...    Charges    Vendor Info
    #Populate Charges Tab
    Click Charges Tab
    Verify Uatp Value Is Correct    ${EMPTY}
    Verify Merchant Fee Is Correct    ${EMPTY}
    Populate Other Services Pricing Paramerters Details
    Populate Other Services Related Details
    Populate Other Services Fare Calculation    merchant_fee=0
    Get Other Services Air Charges    airsales
    #Get MI Tab Values
    Click MI Tab
    Get Client Mi Control Details    airsales
    Generate Expected Client MI Remarks    airsales
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Air Sales-Non BSP INT
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air Sales-Non BSP INT    QATAR AIRWAYS    airsales    PC86    V00900057    0203
    ...    S    1    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    0203
    ...    S    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airsales    Air Sales-Non BSP INT    0203
    ...    S    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    0203
    ...    S    2    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airsales    Air Sales-Non BSP INT    0203
    ...    S    1    Rebate    True    True

[AB] Verify That Air Sales-Non Bsp Int Accounting And General Remarks Are Written When FOP Is Invoice
    [Tags]    us2231    us2308    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    DELSIN/AEY    SS1Y1    ${EMPTY}    5
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    #Verify Air Conso-Dom EO Request Values Are Saved
    Click Amend Eo    ${eo_number}
    Verify Other Services Air Conso-Dom Or Air Sales-Non Bsp Int Request Values Are Correct    airsales
    #Amend Air Conso-Dom EO
    Populate Other Services Air Segment Control Details
    Click Charges Tab
    Populate Other Services Fare Calculation    1500    5    6    ${EMPTY}    100    20
    ...    25    30    250
    Get Other Services Charges Tab Details    airsales    True    True    False
    Click MI Tab
    Populate Client MI Control Details    3000    100    FD - First Class Discounted Fare    5J    Agent Booked    CF - CLIENT NEGOTIATED FARE SAVING ACCEPTED
    ...    A - PARTIAL MISSED SAVING    9W    5000    AI    4000    FF25=123
    ...    FF14=456    FF13=COST3    FF66=COST4    FF63=789
    Get Client Mi Control Details    airsales
    Generate Expected Client MI Remarks    airsales
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    #To-do: Include Execute Simultaneous Change Handling    Other Svcs
    Get Exchange Order Number Using Product    Air Sales-Non BSP INT
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air Sales-Non BSP INT    QATAR AIRWAYS    airsales    PC86    V00900057    020304
    ...    S    1    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    020304
    ...    S    1    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airsales    Air Sales-Non BSP INT    020304
    ...    S    1    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    020304
    ...    S    2    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airsales    Air Sales-Non BSP INT    020304
    ...    S    1    Rebate    True    True
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Air Sales-Non BSP INT    airsales
    [Teardown]

[AB] Verify That Air Sales-Non Bsp Int Accounting Remarks Are Not Written When EO Is Cancelled
    [Tags]    us2129    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_air sales-non bsp int}
    Click Finish PNR
    #To-do: Include Execute Simultaneous Change Handling    Other Svcs
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Main Product Accounting Remarks
    Verify Air Remarks Are Written In The PNR    Air Sales-Non BSP INT    QATAR AIRWAYS    airsales    PC86    V00900057    020304
    ...    S    0    True
    #Subfees Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    020304
    ...    S    0    Vat    True    True
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air Only    PC35    V00800001    airsales    Air Sales-Non BSP INT    020304
    ...    S    0    Transaction Fee-Air Only    True    True
    Verify Non-Air Remarks Are Written In The PNR    Vat    PC87    V00800011    airsales    Air Sales-Non BSP INT    020304
    ...    S    0    Vat    True
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    airsales    Air Sales-Non BSP INT    020304
    ...    S    0    Rebate    True    True
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Air Sales-Non BSP INT    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
