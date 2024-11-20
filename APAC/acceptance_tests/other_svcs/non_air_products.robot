*** Settings ***
Suite Setup
Test Teardown     Take Screenshot On Failure
Force Tags        non_air    amadeus
Resource          other_services.robot
Library           Dialogs

*** Test Cases ***
[IN NB OS] Verify That Despatch Passive Segment, Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2100
    Create PNR Using Credit Card As FOP    IN    fop_dropdown_value=PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Rebate    REBATE (HANDLING)    rebate    False    False    True
    ...    Associated Charges    Vendor Info    Remarks
    Click Add Button In EO Panel    Charges
    Cancel Draft Exchange Order    Rebate
    Create Exchange Order Product And Vendor    Despatch    COURIER CHARGES    despatch    False    False    True
    ...    Associated Charges    Vendor Info    Remarks
    Create Associated Product And Vendor    ETS Call charges    ETS CALL CHARGES    ets
    Create Associated Product And Vendor    Merchant fee    CREDIT CARD CHARGES    mfee
    Click Vendor Info Tab
    Populate Other Services Vendor Info Control Details
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Despatch
    Verify Exchange Order Does Not Exists    Rebate
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Despatch    COURIER CHARGES    00800014    identifier=Despatch
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    despatch    2
    #Main Product: Despatch
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800014    despatch    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    despatch    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    despatch    02
    ...    CX2    6    nonair_subfees
    #Assoc Product: ETS Call charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    despatch    02
    ...    CX2    6    nonair_subfees
    #Assoc Product: Merchant fee
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    mfee    despatch    02
    ...    CX2    6    nonair_subfees
    #BA and TA
    Verify Agent Sign Remark Is Written    RM *BA/7041ER
    Comment    Verify Agent Sign Remark Is Written    RM *TA/7041ER

[IN AB OS] Verify That OTH Handling Fee Passive Segment, Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2100
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_Despatch}
    Click Request Tab
    Verify Other Services Request Info Details    Despatch
    Click Associated Charges Tab
    Verify Other Services Associated Charges Are Correct    ETS Call charges    Merchant fee
    Click Vendor Info Tab
    Verify Other Services Vendor Info Values Are Correct    Despatch
    Click Charges Tab
    Verify Other Services India Cost Details    Despatch
    Verify Other Services India Additional Information Details    Despatch    Despatch
    Click Back To List In Other Svcs
    Create Exchange Order Product And Vendor    Oths handling Fee    ASIANA HOTEL    oths    False    False    True
    ...    Associated Charges    Vendor Info    Remarks
    Create Associated Product And Vendor    Rebate    REBATE (HANDLING)    rebate
    Create Associated Product And Vendor    Transaction Fee-Air only    TRANSACTION FEE    tfee
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Oths handling Fee
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Despatch    COURIER CHARGES    00800014    identifier=Despatch
    Verify Other Services Passive Segment Is Written In The PNR    Oths handling Fee    ASIANA HOTEL    00100159    identifier=Oths handling Fee
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    despatch    2
    Verify Other Services Itinerary Remarks Are Written In The PNR    oths    3
    #Main Product: Despatch
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800014    despatch    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    despatch    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    despatch    02
    ...    CX2    6    nonair_subfees
    #Assoc Product: ETS Call charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    despatch    02
    ...    CX2    6    nonair_subfees
    #Assoc Product: Merchant fee
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    3    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    mfee    despatch    02
    ...    CX2    6    nonair_subfees
    #Main Product: OTHS Handling Fee
    Verify Non-Air Remarks Are Written In The PNR    Oths handling Fee    PC39    V00100159    oths    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    oths    oths handling fee    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    oths    oths handling fee    02
    ...    CX2    4    nonair_subfees
    #Assoc Product: Rebate
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    rebate    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    rebate    oths handling fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    rebate    oths handling fee    02
    ...    CX2    2    nonair_subfees
    #Assoc Product: Transaction Fee-Air only
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air only    PC35    V00800001    tfee    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    tfee    oths handling fee    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    tfee    oths handling fee    02
    ...    CX2    4    nonair_subfees
    #BA and TA
    Verify Agent Sign Remark Is Written    RM *BA/7041ER
    Comment    Verify Agent Sign Remark Is Written    RM *TA/7041ER
    [Teardown]

[IN AB OS] Verify That OTH Handling Fee Passive Segment, Accounting And Itinerary Remarks Are Not Written When EO Is Cancelled
    [Tags]    in    us2100    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_Despatch}
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Despatch    COURIER CHARGES    00800014    identifier=Despatch    expected_count=0
    Verify Other Services Passive Segment Is Written In The PNR    Oths handling Fee    ASIANA HOTEL    00100159    identifier=Oths handling Fee
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    despatch    2    expected_count=0
    Verify Other Services Itinerary Remarks Are Written In The PNR    oths    2
    #Main Product: Despatch
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800014    despatch    despatch    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    despatch    despatch    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    despatch    02
    ...    CX2    0    nonair_subfees
    #Assoc Product: ETS Call charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    despatch    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    despatch    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    despatch    02
    ...    CX2    0    nonair_subfees
    #Assoc Product: Merchant fee
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    mfee    despatch    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    mfee    despatch    02
    ...    CX2    0    nonair_subfees
    #Main Product: OTHS Handling Fee
    Verify Non-Air Remarks Are Written In The PNR    Oths handling Fee    PC39    V00100159    oths    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    oths    oths handling fee    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    oths    oths handling fee    02
    ...    CX2    4    nonair_subfees
    #Assoc Product: Rebate
    Verify Non-Air Remarks Are Written In The PNR    Rebate    PC50    V00800003    rebate    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    rebate    oths handling fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    rebate    oths handling fee    02
    ...    CX2    2    nonair_subfees
    #Assoc Product: Transaction Fee-Air only
    Verify Non-Air Remarks Are Written In The PNR    Transaction Fee-Air only    PC35    V00800001    tfee    oths handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    tfee    oths handling fee    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    tfee    oths handling fee    02
    ...    CX2    4    nonair_subfees
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Despatch    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Oths handling Fee    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB OS] Verify That Meet & Greet Passive Segment, Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2100    us2066
    Create PNR Using Credit Card As FOP    IN    fop_dropdown_value=PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Meet & Greet    Visa - Cash    Meet & Greet    False    False    True
    ...    Associated Charges    Vendor Info    Remarks
    Create Associated Product And Vendor    ETS Call charges    ETS CALL CHARGES    ets
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Meet & Greet
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Passive Segment Is Written In The PNR    Meet & Greet    VISA - CASH    00800085    SAO VICENTE    identifier=Meet & Greet
    #Main Product: Meet And Greet
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800085    Meet & Greet    Meet & Greet    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Meet & Greet    Meet & Greet    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Meet & Greet    Meet & Greet    02
    ...    CX2    4    nonair_subfees
    #Associated Product: ETS Call Charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    Meet & Greet    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    Meet & Greet    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    Meet & Greet    02
    ...    CX2    4    nonair_subfees

[IN AB OS] Verify That Meet & Greet Passive Segment, Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2100    us2066
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_Meet & Greet}
    Click Tab In Other Services Panel    Charges
    Verify Form Of Payment Selected Is Displayed    Cash    default_control_counter=False
    Click Back To List In Other Svcs
    Create Exchange Order Product And Vendor    Despatch    COURIER CHARGES    despatch    False    False    True
    ...    Associated Charges    Vendor Info    Remarks
    Create Associated Product And Vendor    ETS Call charges    ETS CALL CHARGES    ets call
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Meet & Greet
    Get Exchange Order Number Using Product    Despatch
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Meet & Greet    VISA - CASH    00800085    city=SAO VICENTE    identifier=Meet & Greet
    Verify Other Services Passive Segment Is Written In The PNR    Despatch    COURIER CHARGES    00800014    identifier=Despatch
    #Main Product: Meet And Greet
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800085    Meet & Greet    Meet & Greet    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Meet & Greet    Meet & Greet    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Meet & Greet    Meet & Greet    02
    ...    S    2    nonair_subfees
    #Associated Product: ETS Call Charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    Meet & Greet    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    Meet & Greet    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    Meet & Greet    02
    ...    S    2    nonair_subfees
    #Main Product: Despatch
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800014    despatch    despatch    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    despatch    despatch    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    despatch    02
    ...    S    2    nonair_subfees
    #Assoc Product: ETS Call charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets call    despatch    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets call    despatch    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets call    despatch    02
    ...    S    2    nonair_subfees

[IN AB CEO] Verify That Meet & Greet Passive Segment, Accounting And Itinerary Remarks Are Not Written When EO Is Cancelled
    [Tags]    in    US2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    Cash
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_Meet & Greet}
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Meet & Greet    VISA - CASH    00800085    city=SAO VICENTE    identifier=Meet & Greet    expected_count=0
    #Main Product: Meet And Greet
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800085    Meet & Greet    Meet & Greet    02
    ...    S    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Meet & Greet    Meet & Greet    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Meet & Greet    Meet & Greet    02
    ...    S    0    nonair_subfees
    #Associated Product: ETS Call Charges
    Verify Non-Air Remarks Are Written In The PNR    ETS Call charges    PC18    V00800490    ets    Meet & Greet    02
    ...    S    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    ets    Meet & Greet    02
    ...    S    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ets    Meet & Greet    02
    ...    S    0    nonair_subfees
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Meet & Greet    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB OS] Verify That Visa Group Passive Segment And Accounting Remarks Are Written When FOP Is Credit Card
    [Tags]    in    US2073    us2074    us2081
    Create PNR Using Credit Card As FOP    IN    fop_dropdown_value=PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Click Panel    Other Svcs
    #Create Main Product: Visa DD
    Create Exchange Order Product And Vendor    Visa DD    D D CHARGES    Visa DD    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Visa fee    YAHOO INTERNATIONAL    visafee_assoc
    Click Add Button In EO Panel    Charges
    #Create Main Product: Visa Handling Fee
    Create Exchange Order Product And Vendor    Visa handling Fee    SEEMA SETT    Visa handling Fee    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Populate Other Services Visa Standard Control    country=Philippines    document=Visa    validity=3650
    Populate Other Services Visa Custom Control    Yes    143143    10 Years
    Get Other Services Request Details    Visa handling Fee    Visa handling Fee
    Click Associated Charges Tab
    Click Cancel In Associated Charges
    Click Add Button In EO Panel    Charges
    #Create Main Product: Visa Fee
    Create Exchange Order Product And Vendor    Visa fee    VFS CHARGES    Visa fee    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Populate Other Services Visa Standard Control    country=Philippines    document=Visa    validity=3650    processing=Urgent
    Get Other Services Request Details    Visa fee    Visa fee
    Click Associated Charges Tab
    Click Cancel In Associated Charges
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Visa DD
    Get Exchange Order Number Using Product    Visa handling Fee
    Get Exchange Order Number Using Product    Visa fee
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Visa DD    D D CHARGES    00800015    identifier=Visa DD
    Verify Other Services Passive Segment Is Written In The PNR    Visa handling Fee    SEEMA SETT    00800550    identifier=Visa handling Fee
    Verify Other Services Passive Segment Is Written In The PNR    Visa fee    VFS CHARGES    00800013    identifier=Visa fee
    #Main Product: Visa DD
    Verify Non-Air Remarks Are Written In The PNR    Visa DD    PC25    V00800015    Visa DD    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa DD    Visa DD    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa DD    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Assoc Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800548    visafee_assoc    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    visafee_assoc    Visa DD    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    visafee_assoc    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Main Product: Visa Handling Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa handling Fee    PC37    V00800550    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa handling fee    Visa handling fee    02
    ...    CX2    2    nonair_subfees
    #Main Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800013    Visa fee    Visa fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa fee    Visa fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa fee    Visa fee    02
    ...    CX2    2    nonair_subfees
    [Teardown]

[IN AB OS] Verify That Visa Group Passive Segment And Accounting Remarks Are Written When FOP Is Credit Card
    [Tags]    in    US2073    us2074    us2081
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Client Info
    Click Panel    Other Svcs
    #Update Main Product: Visa DD
    Click Amend Eo    ${eo_number_Visa DD}
    Click Request Tab
    Verify Other Services Visa Group Request Values Are Correct    Visa DD
    Click Associated Charges Tab
    Verify Other Services Associated Charges Are Correct    Visa fee
    Click Charges Tab
    Verify Other Services India Cost Details    Visa DD    merchant_fee=67    vat_gst_amount=0    total_selling_price=3238
    Verify Other Services India Additional Information Details    Visa DD    Visa DD
    Verify Form Of Payment Selected Is Displayed    PORTRAIT-A/AX***********0002/D1235-TEST-AX    default_control_counter=False
    Populate Cost Details    3500    10    800
    Get Other Services Charges Tab Details    Visa DD
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Visa DD
    Get Exchange Order Number Using Product    Visa handling Fee
    Get Exchange Order Number Using Product    Visa fee
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Visa DD    D D CHARGES    00800015    identifier=Visa DD
    Verify Other Services Passive Segment Is Written In The PNR    Visa handling Fee    SEEMA SETT    00800550    identifier=Visa handling Fee
    Verify Other Services Passive Segment Is Written In The PNR    Visa fee    VFS CHARGES    00800013    identifier=Visa fee
    #Main Product: Visa DD
    Verify Non-Air Remarks Are Written In The PNR    Visa DD    PC25    V00800015    Visa DD    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa DD    Visa DD    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa DD    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Assoc Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800548    visafee_assoc    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    visafee_assoc    Visa DD    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    visafee_assoc    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Main Product: Visa Handling Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa handling Fee    PC37    V00800550    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa handling fee    Visa handling fee    02
    ...    CX2    2    nonair_subfees
    #Main Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800013    Visa fee    Visa fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa fee    Visa fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa fee    Visa fee    02
    ...    CX2    2    nonair_subfees
    [Teardown]

[IN AB CEO] Verify That Visa Group Passive Segment And Accounting Remarks Are Not Written When EO Is Cancelled
    [Tags]    in    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_Visa fee }
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Visa DD    D D CHARGES    00800015    identifier=Visa DD
    Verify Other Services Passive Segment Is Written In The PNR    Visa handling Fee    SEEMA SETT    00800550    identifier=Visa handling Fee
    Verify Other Services Passive Segment Is Written In The PNR    Visa fee    VFS CHARGES    00800013    identifier=Visa fee    expected_count=0
    #Main Product: Visa DD
    Verify Non-Air Remarks Are Written In The PNR    Visa DD    PC25    V00800015    Visa DD    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa DD    Visa DD    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa DD    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Assoc Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800548    visafee_assoc    Visa DD    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    visafee_assoc    Visa DD    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    visafee_assoc    Visa DD    02
    ...    CX2    4    nonair_subfees
    #Main Product: Visa Handling Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa handling Fee    PC37    V00800550    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa handling fee    Visa handling fee    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa handling fee    Visa handling fee    02
    ...    CX2    2    nonair_subfees
    #Main Product: Visa Fee
    Verify Non-Air Remarks Are Written In The PNR    Visa fee    PC6    V00800013    Visa fee    Visa fee    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Visa fee    Visa fee    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Visa fee    Visa fee    02
    ...    CX2    0    nonair_subfees
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Visa DD    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Visa handling Fee    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Visa fee    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB] Verify That Car Group Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    not_ready    us2078    us2069
    Create PNR Using Credit Card As FOP    IN    car_segment=True    fop_dropdown_value=PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Click Panel    Other Svcs
    #Main Product: Car Dom
    Create Exchange Order Product And Vendor    Car DOM    AVIS    Car DOM    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Meet & Greet    ROYAL SERVICES    meet&greet
    Click Add Button In EO Panel    Charges
    #Main Product: Car Intl
    Create Exchange Order Product And Vendor    Car Intl    AVIS    Car Intl    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Populate Other Services Car Segment Control Details    3 CAR 1A HK1 HKG    cancellation_policy=Special Rate    guarantee_by=Deposit
    Click Vendor Info Tab
    Populate Other Services Vendor Info Control Details
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Car Intl
    Get Exchange Order Number Using Product    Car DOM
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM    2    Others
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car Intl    3    Special Rate
    #Main Product: Car Dom
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Intl
    Verify Non-Air Remarks Are Written In The PNR    Car Intl    PC7    V00200008    Car Intl    Car Intl    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car Intl    Car Intl    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car Intl    Car Intl    02
    ...    CX2    2    nonair_subfees

[IN AB] Verify That Car Group Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2078    us2069
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Passive Car Segment X Months From Now    HKG    0
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    #Main Product: Car Dom
    Create Exchange Order Product And Vendor    Car DOM    AVIS    Car DOM 2    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Populate Other Services Car Segment Control Details    2 CAR 1A HK1 HKG    pickup_date=02/07/2021    pickup_time=10:00:20 AM    dropoff_date=02/07/2022    dropoff_time=10:00:20 PM    cancellation_policy=Cancel By
    ...    guarantee_by=Credit Card
    Get Other Services Request Details    Car DOM 2    Car DOM
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number    Car DOM 2    grid_column=2
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM    3    Others
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car Intl    4    Special Rate
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM 2    2    Cancel By
    #Main Product: Car Dom 2
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM 2    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Dom
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Intl
    Verify Non-Air Remarks Are Written In The PNR    Car Intl    PC7    V00200008    Car Intl    Car Intl    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car Intl    Car Intl    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car Intl    Car Intl    02
    ...    CX2    2    nonair_subfees

[IN AB] Verify That Car Group Values Are Correct
    [Tags]    in    us2078    us2069
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    #Main Product: Car Dom 1
    Click Amend Eo    ${eo_number_car dom}
    Click Request Tab
    Verify Other Services Car Group Request Values Are Correct    Car DOM    car_segment=3 CAR ZE HK1 JFK    guarantee_by=Travel Agent    others=Not Applicable
    Click Charges Tab
    Verify Other Services India Cost Details    Car DOM    merchant_fee=71    vat_gst_amount=179    total_selling_price=3238
    Verify Other Services India Additional Information Details    Car DOM    Car DOM
    Click Back To List In Other Svcs
    #Main Product: Car Dom 2
    Click Amend Eo    ${eo_number_car dom 2}
    Click Request Tab
    Verify Other Services Car Group Request Values Are Correct    Car DOM 2    car_segment=2 CAR 1A HK1 HKG    pickup_date=02/07/2021    pickup_time=10:00:20 AM    dropoff_date=02/07/2022    dropoff_time=10:00:20 PM
    ...    cancellation_policy=Cancel By    guarantee_by=Credit Card    cancelby_amount=24
    Click Charges Tab
    Verify Other Services India Cost Details    Car DOM 2    merchant_fee=71    vat_gst_amount=179    total_selling_price=3238
    Verify Other Services India Additional Information Details    Car DOM 2    Car DOM
    Click Back To List In Other Svcs
    #Main Product: Car Intl
    Click Amend Eo    ${eo_number_car intl}
    Click Request Tab
    Verify Other Services Car Group Request Values Are Correct    Car Intl    car_segment=4 CAR 1A HK1 HKG    guarantee_by=Deposit
    Click Vendor Info Tab
    Verify Other Services Vendor Info Values Are Correct    Car Intl
    Click Charges Tab
    Verify Other Services India Cost Details    Car Intl    merchant_fee=67    vat_gst_amount=0    total_selling_price=3055
    Verify Other Services India Additional Information Details    Car Intl    Car Intl
    Click Back To List In Other Svcs
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM    3    Others
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car Intl    4    Special Rate
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM 2    2    Cancel By
    #Main Product: Car Dom 2
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM 2    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Dom
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Intl
    Verify Non-Air Remarks Are Written In The PNR    Car Intl    PC7    V00200008    Car Intl    Car Intl    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car Intl    Car Intl    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car Intl    Car Intl    02
    ...    CX2    2    nonair_subfees

[IN AB CEO] Verify That Car Group Accounting And Itinerary Remarks Are Not Written When EO Is Cancelled
    [Tags]    in    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_car dom}
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Itinerary Remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM    3    Others    expected_count=0
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car Intl    4    Special Rate
    Verify Other Services Itinerary Remarks Are Written In The PNR    Car DOM 2    2    Cancel By
    #Main Product: Car Dom 2
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM 2    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM 2    02
    ...    CX2    2    nonair_subfees
    #Main Product: Car Dom
    Verify Non-Air Remarks Are Written In The PNR    Car DOM    PC19    V00200008    Car DOM    Car DOM    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car DOM    Car DOM    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car DOM    Car DOM    02
    ...    CX2    0    nonair_subfees
    #Main Product: Car Intl
    Verify Non-Air Remarks Are Written In The PNR    Car Intl    PC7    V00200008    Car Intl    Car Intl    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    Car Intl    Car Intl    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    Car Intl    Car Intl    02
    ...    CX2    2    nonair_subfees
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Car DOM    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Car Intl    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Air Conso-Dom    expected_count=1
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB OS] Verify That Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written In The PNR When FOP Is Credit Card
    [Tags]    in    us2068    us2077
    Create PNR Using Credit Card As FOP    IN
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Train- Dom    VENUS TRAVELS    train- dom    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Insurance    Reliance Corporate Insurance    insurance
    Create Associated Product And Vendor    Meet & Greet    ROYAL SERVICES    meet&greet
    Click Add Button In EO Panel    Charges
    Create Exchange Order Product And Vendor    Transaction Charges    EURORAIL    transaction charges    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Insurance    Reliance Corporate Insurance    insurance
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Train- Dom
    Get Exchange Order Number Using Product    Transaction Charges
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Train- Dom    VENUS TRAVELS    00800680    identifier=train- dom
    Verify Other Services Passive Segment Is Written In The PNR    Transaction Charges    EURORAIL    00500002    identifier=transaction charges
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train- Dom    identifier=train- dom
    #Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train- dom    3
    Verify Other Services Itinerary Remarks Are Written In The PNR    transaction charges    2
    #Train-Dom Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train- Dom    PC26    V00800680    train- dom    train- dom    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    train- dom    train- dom    02
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    train- dom    train- dom    02
    ...    CX2    4    nonair_subfees
    #Train-Dom Assoc Charges for Meet&Greet Remarks
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800258    meet&greet    train- dom    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    meet&greet    train- dom    03
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    meet&greet    train- dom    03
    ...    CX2    2    nonair_subfees
    #Train-Dom Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train- dom    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    train- dom    03
    ...    CX2    2    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train- dom    03
    ...    CX2    4    nonair_subfees
    #Transaction Charges Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Transaction Charges    PC43    V00500002    transaction charges    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    transaction charges    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    transaction charges    transaction charges    02
    ...    CX2    2    nonair_subfees
    #Transaction Charges Assoc Charges For Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    transaction charges    02
    ...    CX2    2    nonair_subfees

[IN AB OS] Verify That Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2231
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Click Panel    Other Svcs
    #Amend Train-DOM EO
    Click Amend Eo    ${eo_number_train- dom}
    #Verify Request Fields
    Verify Other Services Train Group Request Values Are Correct    train- dom    train- dom    NORTH    SOUTH    11111    GUADA
    ...    BUSINESS
    #Verify Charges Fields
    Click Tab In Other Services Panel    Charges
    Verify Form Of Payment Selected Is Displayed    PORTRAIT-A/AX***********0002/D1235-TEST-AX    default_control_counter=False
    Populate Cost Details    3500    150    75
    Populate Additional Information    AmendGSA    AmendPO
    #Get Charges Details
    Get Other Services Charges Tab Details    ab_train- dom    False    False    True
    #Verify Associated Charges Grid
    Comment    Verify Other Services Associated Charges Are Correct    Insurance    Meet & Greet
    Click Update Button In EO Panel    Charges
    #Amend Transaction Charges EO
    Click Amend Eo    ${eo_number_transaction charges}
    #Verify Request Fields
    Verify Other Services Train Group Request Values Are Correct    transaction charges    transaction charges    NORTH    SOUTH    11111    GUADA
    ...    BUSINESS
    #Verify Charges Fields
    Click Tab In Other Services Panel    Charges
    Verify Form Of Payment Selected Is Displayed    PORTRAIT-A/AX***********0002/D1235-TEST-AX    default_control_counter=False
    Populate Cost Details    4789    254    75
    Populate Additional Information    AmendGSATransaction charges    AmendPO transaction charges
    Get Other Services Charges Tab Details    ab_transaction charges    False    False    True
    #Verify Associated Charges Grid
    Comment    Verify Other Services Associated Charges Are Correct    Insurance
    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Credit Card
    Execute Simultaneous Change Handling    Amend Verify Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Credit Card
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Train- Dom    VENUS TRAVELS    00800680    identifier=train- dom
    Verify Other Services Passive Segment Is Written In The PNR    Transaction Charges    EURORAIL    00500002    identifier=transaction charges
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train- Dom    identifier=train- dom
    #Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train- dom    3
    Verify Other Services Itinerary Remarks Are Written In The PNR    transaction charges    2
    #Train-Dom Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train- Dom    PC26    V00800680    ab_train- dom    train- dom    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_train- dom    train- dom    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_train- dom    train- dom    02
    ...    CX2    2    nonair_subfees
    #Train-Dom Assoc Charges for Meet&Greet Remarks
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800258    meet&greet    train- dom    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    meet&greet    train- dom    03
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    meet&greet    train- dom    03
    ...    CX2    2    nonair_subfees
    #Train-Dom Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train- dom    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    train- dom    03
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train- dom    03
    ...    CX2    2    nonair_subfees
    #Transaction Charges Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Transaction Charges    PC43    V00500002    ab_transaction charges    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_transaction charges    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_transaction charges    transaction charges    02
    ...    CX2    2    nonair_subfees
    #Transaction Charges Assoc Charges For Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    transaction charges    02
    ...    CX2    2    nonair_subfees

[IN AB CEO] Verify That Train-DOM Passive Segment, Accounting And Itinerary Remarks Are Not Written When EO Is Cancelled
    [Tags]    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_train- dom}
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Passive Segments
    Verify Other Services Passive Segment Is Written In The PNR    Train- Dom    VENUS TRAVELS    00800680    identifier=train- dom    expected_count=0
    Verify Other Services Passive Segment Is Written In The PNR    Transaction Charges    EURORAIL    00500002    identifier=transaction charges
    #General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train- Dom    identifier=train- dom    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Transaction Charges    expected_count=1
    #Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train- dom    3    expected_count=0
    Verify Other Services Itinerary Remarks Are Written In The PNR    transaction charges    2
    #Train-Dom Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train- Dom    PC26    V00800680    ab_train- dom    train- dom    03
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_train- dom    train- dom    03
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_train- dom    train- dom    03
    ...    CX2    0    nonair_subfees
    #Train-Dom Assoc Charges for Meet&Greet Remarks
    Verify Non-Air Remarks Are Written In The PNR    Meet & Greet    PC12    V00800258    meet&greet    train- dom    03
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    meet&greet    train- dom    03
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    meet&greet    train- dom    03
    ...    CX2    0    nonair_subfees
    #Train-Dom Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train- dom    03
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    train- dom    03
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train- dom    03
    ...    CX2    0    nonair_subfees
    #Transaction Charges Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Transaction Charges    PC43    V00500002    ab_transaction charges    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_transaction charges    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_transaction charges    transaction charges    02
    ...    CX2    2    nonair_subfees
    #Transaction Charges Assoc Charges For Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    transaction charges    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    transaction charges    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    transaction charges    02
    ...    CX2    2    nonair_subfees
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB OS] Verify That Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card
    [Tags]    us2067
    Create PNR Using Credit Card As FOP    IN
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Insurance    Visa - Cash    insurance    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Despatch    ROYAL SERVICES    despatch
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Insurance
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Passive Segment Is Written In The PNR    Insurance    Visa - Cash    00800085    identifier=insurance
    #Insurance General Remarks
    Verify Other Services General Remarks Are Written in PNR    Insurance    identifier=insurance
    #Insurance Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00800085    insurance    insurance    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    insurance    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    insurance    02
    ...    CX2    2    nonair_subfees
    #Insurance Assoc Charges for Despatch Remarks
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800258    despatch    insurance    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    despatch    insurance    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    insurance    02
    ...    CX2    2    nonair_subfees

[IN AB OS] Verify That Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2231
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_insurance}
    #Verify Request Fields
    Verify Other Services Insurance Request Values Are Correct    insurance    Detail 1    Detail 2    Detail 3    Internal Remarks    20090
    ...    Baner    K21121    Stark    M    12-Jun-1992    Address 1
    ...    Street1    Area15    91    560029    GOA    India
    ...    985645212    Single    15-Jun-2020    17-Jun-2020
    #Update Request Fields
    Populate Other Services Insurance Custom Fields Control Details    employee_number=777222    employee_name=Captain    passport_number=DT5897    dateofbirth=15-Jul-1982    departure_date_insurance=15-Nov-2020    arrival_date=17-Nov-2020
    Get Request Tab Field Details When Product Is Insurance    ab_insurance
    #Verify Charges Fields
    Click Tab In Other Services Panel    Charges
    Verify Form Of Payment Selected Is Displayed    PORTRAIT-A/AX***********0002/D1235-TEST-AX    default_control_counter=False
    Populate Cost Details    3259    128    72
    Populate Additional Information    AmendGSA    AmendPO
    Comment    Populate Charges Fields Details    3259    128    72    Amend_insurance    AmendGSA
    ...    AmendPO
    #Get Charges Details
    Get Other Services Charges Tab Details    ab_insurance    False    False    True
    #Verify Associated Charges Grid
    Comment    Verify Other Services Associated Charges Are Correct    Despatch
    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card
    Execute Simultaneous Change Handling    Amend Verify Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Verify Remarks
    Verify Other Services Passive Segment Is Written In The PNR    Insurance    Visa - Cash    00800085    identifier=insurance
    #Insurance General Remarks
    Verify Other Services General Remarks Are Written in PNR    Insurance    identifier=ab_insurance
    #Insurance Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00800085    ab_insurance    insurance    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_insurance    insurance    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_insurance    insurance    02
    ...    CX2    2    nonair_subfees
    #Insurance Assoc Charges for Despatch Remarks
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800258    despatch    insurance    02
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    despatch    insurance    02
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    insurance    02
    ...    CX2    2    nonair_subfees
    [Teardown]

[IN AB CEO] Verify That Insurance Passive Segment And Accounting Remarks Are Not Written When EO Is Cancelled
    [Tags]    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_insurance}
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Verify Remarks Are Not Written
    Verify Other Services Passive Segment Is Written In The PNR    Insurance    Visa - Cash    00800085    identifier=insurance    expected_count=0
    #Insurance General Remarks
    Verify Other Services General Remarks Are Written in PNR    Insurance    identifier=ab_insurance    expected_count=1
    #Insurance Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00800085    ab_insurance    insurance    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    ab_insurance    insurance    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_insurance    insurance    02
    ...    CX2    0    nonair_subfees
    #Insurance Assoc Charges for Despatch Remarks
    Verify Non-Air Remarks Are Written In The PNR    Despatch    PC8    V00800258    despatch    insurance    02
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    despatch    insurance    02
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    despatch    insurance    02
    ...    CX2    0    nonair_subfees
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[IN NB OS] Verify That Train Passive Segment, Accounting And Itinerary Remarks Are Written When FOP Is Invoice
    [Tags]    us2076
    Create PNR Using Cash As FOP    IN    fop=Invoice
    Click Panel    Other Svcs
    Create Exchange Order Product And Vendor    Train    EURORAIL    train    False    False    True
    ...    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Insurance    Reliance Corporate Insurance    insurance
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Train
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Passive Segment Is Written In The PNR    Train    EURORAIL    00500002    identifier=train
    #Train General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train    identifier=train
    #Train-Dom Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train    PC15    V00500002    train    train    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    train    train    02
    ...    S    2    nonair_subfees
    #Train-Dom Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train    02
    ...    S    2    nonair_subfees
    #Train-Dom Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train    2

[IN AB OS] Verify That Train Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Invoice
    [Tags]    us2231
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_train}
    #Verify Request Fields
    Verify Other Services Train Group Request Values Are Correct    train    train    NORTH    SOUTH    11111    GUADA
    ...    BUSINESS
    #Verify Charges Fields
    Click Tab In Other Services Panel    Charges
    Verify Form Of Payment Selected Is Displayed    Invoice    default_control_counter=False
    Populate Cost Details    4425    200    65
    Populate Additional Information    AmendGSA    AmendPO
    #Get Charges Details
    Get Other Services Charges Tab Details    ab_train    False    False    True
    #Verify Associated Charges Grid
    Comment    Click Tab In Other Services Panel    Associated Charges
    Comment    Verify Other Services Associated Charges Are Correct    Insurance
    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Train Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Invoice
    Execute Simultaneous Change Handling    Amend Verify Train Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Invoice
    Comment    Click Panel    Other Svcs
    Comment    Get Exchange Order Number Using Product    train
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Verify Remarks
    Verify Other Services Passive Segment Is Written In The PNR    Train    EURORAIL    00500002    identifier=train
    #Insurance General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train    identifier=train
    #Train-Dom Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train    PC15    V00500002    ab_train    train    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_train    train    02
    ...    S    1    nonair_subfees
    #Train-Dom Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train    02
    ...    S    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train    02
    ...    S    1    nonair_subfees
    #Train-Dom Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train    2

[IN AB CEO] Verify That Train Passive Segment, Accounting And Itinerary Remarks Are Not Written When EO Is Cancelled
    [Tags]    in    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_train}
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Verify Remarks
    Verify Other Services Passive Segment Is Written In The PNR    Train    EURORAIL    00500002    identifier=train    expected_count=0
    #Insurance General Remarks
    Verify Other Services General Remarks Are Written in PNR    Train    identifier=train    expected_count=1
    #Train Main Accounting Remarks
    Verify Non-Air Remarks Are Written In The PNR    Train    PC15    V00500002    ab_train    train    02
    ...    S    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    ab_train    train    02
    ...    S    0    nonair_subfees
    #Train Assoc Charges for Insurance Remarks
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    train    02
    ...    S    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    train    02
    ...    S    0    nonair_subfees
    #Train Itinerary remarks
    Verify Other Services Itinerary Remarks Are Written In The PNR    train    2    expected_count=0
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB] Verify Hotel Prepaid-Intl Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2070
    Create PNR Using Credit Card As FOP    IN    True    \    True    PORTRAIT-A/AX***********0002/D1235-TEST-AX
    Create Exchange Order Product And Vendor    Hotel pre paid- INTL    ACCOR    hotel pre paid intl    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Create Associated Product And Vendor    Insurance    Reliance Corporate Insurance    insurance
    Click Request Tab
    Select Hotel Segment    3 JT LON
    Verify Other Services Request Details For Hotel Group    Default    hotel 1    3 JT LON    JUMEIRAH CARLTON TOWER    GBP \ \ \ Great British Pound    425
    ...    LON
    Populate Request Tab With Default Values
    Get Other Services Request Details    hotel pre paid intl    Hotel pre paid- INTL
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Hotel pre paid- INTL
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl    3    Cancel By
    #Main Product: Hotel Prepaid INTL
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00100063    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    2    nonair_subfees
    #Secondary Product: Insurance
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    Hotel pre paid- INTL    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    Hotel pre paid- INTL    03
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    Hotel pre paid- INTL    03
    ...    CX2    2    nonair_subfees

[AB] Verify That Hotel Prepaid-Dom Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2070    us2231
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_hotel pre paid- intl}
    Verify Other Services Request Details For Hotel Group    hotel pre paid intl    hotel 1    3 JT LON    JUMEIRAH CARLTON TOWER    GBP \ \ \ Great British Pound    1200
    ...    LON
    Click Charges Tab
    Verify Other Services India Cost Details    hotel pre paid intl    merchant_fee=73    vat_gst_amount=269    total_selling_price=3330
    Verify Other Services India Additional Information Details    hotel pre paid intl    Hotel pre paid- INTL
    Click Back To List In Other Svcs
    Create Exchange Order Product And Vendor    Hotel Prepaid-Dom    ADAMS MARKS HOTELS    hotel prepaid dom    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Select Hotel Segment    4 1A LON
    Verify Other Services Request Details For Hotel Group    Default    hotel 2    4 1A LON    PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED    ${EMPTY}    ${EMPTY}
    ...    LON
    Populate Other Services Hotel Information Control Details    2    GBP \ \ \ Great British Pound    1200    Deluxe    1    Credit Card
    ...    12345678
    Populate Other Services Cancellation Policy Control Details    Cancel By    12
    Populate Other Services Internal Remarks Control Details
    Populate Other Services Request Credit Card Group Details    4988438843884305    CORP    VI
    Get Other Services Request Details    hotel prepaid dom    Hotel Prepaid-Dom
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    Hotel Prepaid-Dom
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl    3    Cancel By
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel prepaid dom    4    Cancel By
    #Main Product: Hotel Prepaid INTL
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00100063    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl    Hotel pre paid- INTL    3
    ...    CX2    2    nonair_subfees
    #Secondary Product: Insurance
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    Hotel pre paid- INTL    03
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    Hotel pre paid- INTL    03
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    Hotel pre paid- INTL    03
    ...    CX2    2    nonair_subfees
    #Main Product: Hotel Prepaid DOM
    Verify Non-Air Remarks Are Written In The PNR    Hotel Prepaid-Dom    PC16    V00100005    hotel prepaid dom    Hotel Prepaid-Dom    4
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel prepaid dom    Hotel Prepaid-Dom    4
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel prepaid dom    Hotel Prepaid-Dom    4
    ...    CX2    2    nonair_subfees

[AB] Verify That Hotel Prepaid-Intl Accounting And Itinerary Remarks Are Written When FOP Is Credit Card
    [Tags]    in    us2070    us2231
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Passive Hotel    LON    6    3    BEST WESTERN HOTEL BREAKFAST INCLUDED    hotel 3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Click Amend Eo    ${eo_number_hotel prepaid-dom}
    Verify Other Services Request Details For Hotel Group    hotel prepaid dom    hotel 2    5 1A LON    PLAZA HOTEL TWIN ROOM NO MEALS INCLUDED    GBP \ \ \ Great British Pound    1200
    ...    LON
    Click Charges Tab
    Verify Other Services India Cost Details    hotel prepaid dom    merchant_fee=73    vat_gst_amount=269    total_selling_price=3330
    Verify Other Services India Additional Information Details    hotel prepaid dom    Hotel Prepaid-Dom
    Click Back To List In Other Svcs
    Create Exchange Order Product And Vendor    Hotel pre paid- INTL    GARUDA INDIA HOLIDAYS    hotel pre paid intl 2    False    False    True
    ...    Request    Associated Charges    Vendor Info
    Click Request Tab
    Select Hotel Segment    3 1A LON
    Verify Other Services Request Details For Hotel Group    Default    hotel 3    3 1A LON    BEST WESTERN HOTEL BREAKFAST INCLUDED    ${EMPTY}    ${EMPTY}
    ...    LON
    Populate Request Tab With Default Values
    Get Other Services Request Details    hotel pre paid intl 2    Hotel pre paid- INTL
    Click Add Button In EO Panel    Charges
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number    Hotel pre paid- INTL 2    grid_column=2
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl 2    3    Cancel By
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl    4    Cancel By
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel prepaid dom    5    Cancel By
    #Main Product: Hotel Prepaid INTL
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00100063    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    2    nonair_subfees
    #Secondary Product: Insurance
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    Hotel pre paid- INTL    4
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    Hotel pre paid- INTL    4
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    Hotel pre paid- INTL    4
    ...    CX2    2    nonair_subfees
    #Main Product: Hotel Prepaid DOM
    Verify Non-Air Remarks Are Written In The PNR    Hotel Prepaid-Dom    PC16    V00100005    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    2    nonair_subfees
    #Main Product: Hotel Prepaid INTL 2
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00800144    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    2    nonair_subfees

[AB] Verify That Hotel Prepaid-Intl Accounting And Itinerary Remarks Are Not Written When FOP Is Cancelled
    [Tags]    in    us2070    us2231    us2129
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Cancel Exchange Order    ${eo_number_hotel prepaid-dom}
    Cancel Exchange Order    ${eo_number_hotel pre paid- intl}
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl 2    3    Cancel By
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel pre paid intl    4    Cancel By    expected_count=0
    Verify Other Services Itinerary Remarks Are Written In The PNR    hotel prepaid dom    5    Cancel By    expected_count=0
    #Main Product: Hotel Prepaid INTL
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00100063    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl    Hotel pre paid- INTL    4
    ...    CX2    0    nonair_subfees
    #Secondary Product: Insurance
    Verify Non-Air Remarks Are Written In The PNR    Insurance    PC9    V00600011    insurance    Hotel pre paid- INTL    4
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant Fee    PC40    V00800004    insurance    Hotel pre paid- INTL    4
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    insurance    Hotel pre paid- INTL    4
    ...    CX2    0    nonair_subfees
    #Main Product: Hotel Prepaid DOM
    Verify Non-Air Remarks Are Written In The PNR    Hotel Prepaid-Dom    PC16    V00100005    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    0    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    0    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel prepaid dom    Hotel Prepaid-Dom    5
    ...    CX2    0    nonair_subfees
    #Main Product: Hotel Prepaid INTL 2
    Verify Non-Air Remarks Are Written In The PNR    Hotel pre paid- INTL    PC24    V00800144    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    1    nonair
    Verify Non-Air Remarks Are Written In The PNR    Merchant fee    PC40    V00800004    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    1    nonair_subfees
    Verify Non-Air Remarks Are Written In The PNR    VAT    PC87    V00800011    hotel pre paid intl 2    Hotel pre paid- INTL 2    3
    ...    CX2    2    nonair_subfees
    #General Notepad Remarks
    Verify Other Services General Remarks Are Written in PNR    Hotel pre paid- INTL    expected_count=1
    Verify Other Services General Remarks Are Written in PNR    Hotel Prepaid-Dom    expected_count=1

*** Keywords ***
Amend Verify Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Credit Card
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Comment    Click Panel    Other Svcs
    Comment    #Amend Train-DOM EO
    Comment    Click Amend Eo    ${eo_number_train- dom}
    Comment    #Verify Request Fields
    Comment    Verify Other Services Train Group Request Values Are Correct    train- dom    train- dom    NORTH    SOUTH    11111
    ...    GUADA    BUSINESS
    Comment    #Verify Charges Fields
    Comment    Click Tab In Other Services Panel    Charges
    Comment    Verify Form Of Payment Selected Is Displayed    BTA CTCL VI/VI************7710/D0823
    Comment    Populate Cost Details    3500    150    75
    Comment    Populate Additional Information    AmendGSA    AmendPO
    Comment    #Get Charges Details
    Comment    Get Other Services Charges Tab Details    ab_train- dom    False    False    True
    Comment    #Verify Associated Charges Grid
    Comment    Comment    Verify Other Services Associated Charges Are Correct    Insurance    Meet & Greet
    Comment    Click Update Button In EO Panel    Charges
    Comment    #Amend Transaction Charges EO
    Comment    Click Amend Eo    ${eo_number_transaction charges}
    Comment    #Verify Request Fields
    Comment    Verify Other Services Train Group Request Values Are Correct    transaction charges    transaction charges    NORTH    SOUTH    11111
    ...    GUADA    BUSINESS
    Comment    #Verify Charges Fields
    Comment    Click Tab In Other Services Panel    Charges
    Comment    Verify Form Of Payment Selected Is Displayed    BTA CTCL VI/VI************7710/D0823
    Comment    Populate Cost Details    4789    254    75
    Comment    Populate Additional Information    AmendGSATransaction charges    AmendPO transaction charges
    Comment    Get Other Services Charges Tab Details    ab_transaction charges    False    False    True
    Comment    #Verify Associated Charges Grid
    Comment    Comment    Verify Other Services Associated Charges Are Correct    Insurance
    Comment    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Train-DOM Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Credit Card

Amend Verify Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Comment    Click Panel    Other Svcs
    Comment    Click Amend Eo    ${eo_number_insurance}
    Comment    #Verify Request Fields
    Comment    Verify Other Services Insurance Request Values Are Correct    insurance    Detail 1    Detail 2    Detail 3    Internal Remarks
    ...    20090    Baner    K21121    Stark    M    12-Jun-1992
    ...    Address 1    Street1    Area15    91    560029    GOA
    ...    India    985645212    Single    15-Jun-2020    17-Jun-2020
    Comment    #Update Request Fields
    Comment    Populate Other Services Insurance Custom Fields Control Details    employee_number=777222    employee_name=Captain    passport_number=DT5897    dateofbirth=15-Jul-1982    departure_date_insurance=15-Nov-2020
    ...    arrival_date=17-Nov-2020
    Comment    Get Request Tab Field Details When Product Is Insurance    ab_insurance
    Comment    #Verify Charges Fields
    Comment    Click Tab In Other Services Panel    Charges
    Comment    Verify Form Of Payment Selected Is Displayed    BTA CTCL VI/VI************7710/D0823
    Comment    Populate Cost Details    3259    128    72
    Comment    Populate Additional Information    AmendGSA    AmendPO
    Comment    Comment    Populate Charges Fields Details    3259    128    72    Amend_insurance
    ...    AmendGSA    AmendPO
    Comment    #Get Charges Details
    Comment    Get Other Services Charges Tab Details    ab_insurance    False    False    True
    Comment    #Verify Associated Charges Grid
    Comment    Comment    Verify Other Services Associated Charges Are Correct    Despatch
    Comment    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Insurance Passive Segment, Accounting And General Remarks Are Written When FOP Is Credit Card

Amend Verify Train Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Invoice
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Click Read Booking
    Comment    Click Panel    Other Svcs
    Comment    Click Amend Eo    ${eo_number_train}
    Comment    #Verify Request Fields
    Comment    Verify Other Services Train Group Request Values Are Correct    train    train    NORTH    SOUTH    11111
    ...    GUADA    BUSINESS
    Comment    #Verify Charges Fields
    Comment    Click Tab In Other Services Panel    Charges
    Comment    Verify Form Of Payment Selected Is Displayed    Invoice
    Comment    Populate Cost Details    4425    200    65
    Comment    Populate Additional Information    AmendGSA    AmendPO
    Comment    #Get Charges Details
    Comment    Get Other Services Charges Tab Details    ab_train    False    False    True
    Comment    #Verify Associated Charges Grid
    Comment    Comment    Click Tab In Other Services Panel    Associated Charges
    Comment    Comment    Verify Other Services Associated Charges Are Correct    Insurance
    Comment    Click Update Button In EO Panel    Charges
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Finish PNR    Amend Verify Train Passive Segment, Accounting, Itinerary And General Remarks Are Written When FOP Is Invoice
