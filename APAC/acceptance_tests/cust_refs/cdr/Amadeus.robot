*** Settings ***
Force Tags        amadeus    apac
Resource          ../cust_refs_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That Only VFF Remarks Are Written In PNR For Single Car (Active)
    [Tags]    in    us307    de92    us861    howan
    Open Power Express And Retrieve Profile    ${version}    Test    u004hxc    en-GB    hcuellar    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ XYZ AUTOMATION IN - US307    BEAR    INTHREEZEROSEVEN
    Click New Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    ${EMPTY}
    Verify CDR Value Is Correct    Business Unit    ${EMPTY}
    Verify CDR Value Is Correct    Company    ${EMPTY}
    Verify CDR Value Is Correct    Company ID    ${EMPTY}
    Verify CDR Value Is Correct    DP Code    ${EMPTY}
    Verify CDR Value Is Correct    Department    ${EMPTY}
    Verify CDR Value Is Correct    INTL Approver ID    ${EMPTY}
    Verify CDR Value Is Correct    Invoice narration 1    ${EMPTY}
    Verify CDR Value Is Correct    Invoice narration 2    ${EMPTY}
    Verify CDR Value Is Correct    Invoice narration 3    ${EMPTY}
    Verify CDR Value Is Correct    Job Band    ${EMPTY}
    Verify CDR Value Is Correct    Location Code    ${EMPTY}
    Verify CDR Value Is Correct    Manager ID    ${EMPTY}
    Verify CDR Value Is Correct    Manager Name    ${EMPTY}
    Verify CDR Value Is Correct    Cost Centre    ${EMPTY}
    Verify CDR Value Is Correct    Employee ID    ${EMPTY}
    Verify CDR Value Is Correct    Name of INTL Approver    ${EMPTY}
    Verify CDR Value Is Correct    Designation    QA.QA/TEST*1_BB22@33
    Set CDR Value    Business    BUS
    Set CDR Value    Business Unit    DP
    Set CDR Value    Company    COM1
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    AAA
    Set CDR Value    Department    FI
    Set CDR Value    INTL Approver ID    222222
    Set CDR Value    Invoice narration 1    INV NAR 1
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    INV NAR 3
    Set CDR Value    Job Band    AGENT
    Set CDR Value    Location Code    ${EMPTY}
    Set CDR Value    Manager ID    ${EMPTY}
    Set CDR Value    Manager Name    ${EMPTY}
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    TEST
    Set CDR Value    Designation    QA.QA/TEST*1_BB22@33
    Get CDR Description And Value    IN
    Update PNR With Default Values
    Verify CDR Accounting Remarks For Air Are Written    IN    Update PNR
    Verify CDR Accounting Remarks For Non-Air Are Not Written    IN    Update PNR
    Book Active Amadeus Car Segment X Months From Now    MNL    6    8
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    BUS
    Verify CDR Value Is Correct    Business Unit    DP
    Verify CDR Value Is Correct    Company    COM1
    Verify CDR Value Is Correct    Company ID    123456
    Verify CDR Value Is Correct    DP Code    AAA
    Verify CDR Value Is Correct    Department    FI
    Verify CDR Value Is Correct    INTL Approver ID    222222
    Verify CDR Value Is Correct    Invoice narration 1    INV NAR 1
    Verify CDR Value Is Correct    Invoice narration 2    INV NAR 2
    Verify CDR Value Is Correct    Invoice narration 3    INV NAR 3
    Verify CDR Value Is Correct    Job Band    AGENT
    Verify CDR Value Is Correct    Location Code    ${EMPTY}
    Verify CDR Value Is Correct    Manager ID    ${EMPTY}
    Verify CDR Value Is Correct    Manager Name    ${EMPTY}
    Verify CDR Value Is Correct    Cost Centre    IT
    Verify CDR Value Is Correct    Employee ID    555-55
    Verify CDR Value Is Correct    Name of INTL Approver    TEST
    Verify CDR Value Is Correct    Designation    QA.QA/TEST*1_BB22@33
    Set CDR Value    Business    BUSINE
    Set CDR Value    Business Unit    ${EMPTY}
    Set CDR Value    Company    COM2
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    AAA
    Set CDR Value    Department    ${EMPTY}
    Set CDR Value    INTL Approver ID    222223
    Set CDR Value    Invoice narration 1    INV NAR 1
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    ${EMPTY}
    Set CDR Value    Job Band    AGENT
    Set CDR Value    Location Code    CD222
    Set CDR Value    Manager ID    323232
    Set CDR Value    Manager Name    ${EMPTY}
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    ${EMPTY}
    Set CDR Value    Designation    QA.QA/TEST*1_CC22@33
    Get CDR Description And Value    IN
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify CDR Accounting Remarks For Non-Air Are Written    IN    Finish PNR
    Verify CDR Accounting Remarks For Air Are Not Written    IN    Finish PNR

[SI IN] Verify That CDR Remarks Are Not Removed/Duplicated In The PNR For Single Car Segment (Active)
    [Tags]    in    us307    de126    voltes
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify CDR Accounting Remarks For Air Are Not Written    IN    Finish PNR
    Verify CDR Accounting Remarks For Non-Air Are Written    IN    Finish PNR

[AB IN] Verify That CDRs Are Displayed From VFF PNR Remarks And Only FF remarks Are Written In PNR For Multiple AIR
    [Tags]    in    us307    de92    us861    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XI
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP/S2    6    2
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP/S3    6    8
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    BUSINE
    Verify CDR Value Is Correct    Business Unit    ${EMPTY}
    Verify CDR Value Is Correct    Company    COM2
    Verify CDR Value Is Correct    Company ID    123456
    Verify CDR Value Is Correct    DP Code    AAA
    Verify CDR Value Is Correct    Department    ${EMPTY}
    Verify CDR Value Is Correct    INTL Approver ID    222223
    Verify CDR Value Is Correct    Invoice narration 1    INV NAR 1
    Verify CDR Value Is Correct    Invoice narration 2    INV NAR 2
    Verify CDR Value Is Correct    Invoice narration 3    ${EMPTY}
    Verify CDR Value Is Correct    Job Band    AGENT
    Verify CDR Value Is Correct    Location Code    CD222
    Verify CDR Value Is Correct    Manager ID    323232
    Verify CDR Value Is Correct    Manager Name    ${EMPTY}
    Verify CDR Value Is Correct    Cost Centre    IT
    Verify CDR Value Is Correct    Employee ID    555-55
    Verify CDR Value Is Correct    Name of INTL Approver    ${EMPTY}
    Verify CDR Value Is Correct    Designation    QA.QA/TEST*1_CC22@33
    Set CDR Value    Business    BUSINE
    Set CDR Value    Business Unit    TT
    Set CDR Value    Company    COMP1
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    AAA
    Set CDR Value    Department    AD
    Set CDR Value    INTL Approver ID    222222
    Set CDR Value    Invoice narration 1    INV NAR 11
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    INV NAR 3
    Set CDR Value    Job Band    Agent
    Set CDR Value    Location Code    EF333
    Set CDR Value    Manager ID    ABC333
    Set CDR Value    Manager Name    Juan Miguel
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    TEST
    Set CDR Value    Designation    QA.QC/TEST*1_BB22@33
    Get CDR Description And Value    IN
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That CDRs Are Displayed From VFF PNR Remarks And Only FF remarks Are Written In PNR For Multiple AIR
    Execute Simultaneous Change Handling    Amend Booking For Verify That CDRs Are Displayed From VFF PNR Remarks And Only FF remarks Are Written In PNR For Multiple AIR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify CDR Accounting Remarks For Air Are Written    IN    Finish PNR
    Verify CDR Accounting Remarks For Non-Air Are Not Written    IN    Finish PNR

[AB IN] Verify That CDRs Are Displayed From FF PNR Remarks And FF and VFF Are Written In PNR For Single Air and Single Car (Passive) when Not Known at Time of Booking is Ticked
    [Tags]    in    us307    de92    us861    howan
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XI
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP    4    2
    Book Passive Car Segment X Months From Now    FRA    4    4
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    BUSINE
    Verify CDR Value Is Correct    Business Unit    TT
    Verify CDR Value Is Correct    Company    COMP1
    Verify CDR Value Is Correct    Company ID    123456
    Verify CDR Value Is Correct    DP Code    AAA
    Verify CDR Value Is Correct    Department    AD
    Verify CDR Value Is Correct    INTL Approver ID    222222
    Verify CDR Value Is Correct    Invoice narration 1    INV NAR 11
    Verify CDR Value Is Correct    Invoice narration 2    INV NAR 2
    Verify CDR Value Is Correct    Invoice narration 3    INV NAR 3
    Verify CDR Value Is Correct    Job Band    AGENT
    Verify CDR Value Is Correct    Location Code    EF333
    Verify CDR Value Is Correct    Manager ID    ABC333
    Verify CDR Value Is Correct    Manager Name    JUAN MIGUEL
    Verify CDR Value Is Correct    Cost Centre    IT
    Verify CDR Value Is Correct    Employee ID    555-55
    Verify CDR Value Is Correct    Name of INTL Approver    TEST
    Verify CDR Value Is Correct    Designation    QA.QC/TEST*1_BB22@33
    Set CDR Value    Business    BUSIN
    Set CDR Value    Business Unit    ${EMPTY}
    Set CDR Value    Company    COM2
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    BBB
    Set CDR Value    Department    ${EMPTY}
    Set CDR Value    INTL Approver ID    222223
    Set CDR Value    Invoice narration 1    INV NAR 1
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    ${EMPTY}
    Set CDR Value    Job Band    AGENT
    Set CDR Value    Location Code    CD222
    Set CDR Value    Manager ID    323232
    Set CDR Value    Manager Name    ${EMPTY}
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    ${EMPTY}
    Set CDR Value    Designation    QA.QA/TEST*1_BB22@33
    Tick Not Known At Time Of Booking
    Get CDR Description And Value    IN
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That CDRs Are Displayed From FF PNR Remarks And FF and VFF Are Written In PNR For Single Air and Single Car (Passive) when Not Known at Time of Booking is Ticked For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That CDRs Are Displayed From FF PNR Remarks And FF and VFF Are Written In PNR For Single Air and Single Car (Passive) when Not Known at Time of Booking is Ticked For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify CDR Accounting Remarks For Air Are Written    IN    Finish PNR
    Verify CDR Accounting Remarks For Non-Air Are Written    IN    Finish PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That CDRs Are Displayed From FF/VFF PNR Remarks And Only VFF remarks Are Written In PNR For Single Hotel For HK
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2-4
    Comment    Enter GDS Command    11AHSJTLON423 14NOV-3/CF-123456/RT-A1D/RQ-GBP425.00
    Book Passive Amadeus HHL Hotel Segment X Months From Now    FRA    6    8
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    COUNTRY E.G. HK    HK
    Verify CDR Value Is Correct    DEPARTMENT    FI
    Verify CDR Value Is Correct    DIVISON E.G. GLOBAL FINANCE    03
    Verify CDR Value Is Correct    DP Code    9999999998
    Verify CDR Value Is Correct    GRADE - OPTIONAL    GRADE TEST
    Verify CDR Value Is Correct    LOCAL ENTITY    ENT2
    Verify CDR Value Is Correct    PERSONNEL ID OR STAFF ID    AAA-12
    Verify CDR Value Is Correct    TRAVEL REASON E.G. INTERNA MEETING    TRAINING
    Verify CDR Value Is Correct    TRAVEL REQUEST NO    112233
    Verify CDR Value Is Correct    TRAVEL REQUEST REASON    ${EMPTY}
    Set CDR Value    COUNTRY E.G. HK    HK
    Set CDR Value    DP Code    9999999999
    Set CDR Value    GRADE - OPTIONAL    ${EMPTY}
    Set CDR Value    LOCAL ENTITY    ENT1
    Set CDR Value    TRAVEL REQUEST NO    ${EMPTY}
    Get CDR Description And Value
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR

Amend Booking For Verify That CDRs Are Displayed From FF/VFF PNR Remarks And Only FF remarks Are Written In PNR For Single AIR For SG
    Retrieve PNR    ${current _pnr}
    Click Amend Booking
    Enter GDS Command    XI
    Book Flight X Months From Now    MNLSIN/APR    SS1Y1    FXP/S2    4    1
    Click Read Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    VI    4111111111111111    1233
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Travler Type Alpha Policy Code    S
    Verify CDR Value Is Correct    GEID    1234567892
    Verify CDR Value Is Correct    MSL 8    8888888888
    Verify CDR Value Is Correct    MSL 9    ${EMPTY}
    Verify CDR Value Is Correct    Revenue/Non Revenue Generating    NO REVENUE
    Verify CDR Value Is Correct    DEALCODE    123456
    Verify CDR Value Is Correct    No Hotel Reason Code    7
    Verify CDR Value Is Correct    OFFLINE    A
    Verify CDR Value Is Correct    Employee ID    444-44
    Verify CDR Value Is Correct    Cost Centre    FI
    Set CDR Value    Travler Type Alpha Policy Code    G
    Set CDR Value    GEID    1234567891
    Set CDR Value    MSL 8    ${EMPTY}
    Set CDR Value    MSL 9    77777
    Set CDR Value    Revenue/Non Revenue Generating    No Revenue
    Set CDR Value    DEALCODE    ${EMPTY}
    Set CDR Value    No Hotel Reason Code    5
    Set CDR Value    OFFLINE    B
    Set CDR Value    Employee ID    ${EMPTY}
    Set CDR Value    Cost Centre    IT
    Get CDR Description And Value    SG
    Click Panel    Air Fare
    Populate Fare Details And Fees Tab With Default Values
    Click Panel    Fare 1
    Set Commission Rebate Percentage    0
    Populate All Panels (Except Given Panels If Any)    Client Info
    Click Finish PNR

Amend Booking For Verify That CDRs Are Displayed From FF PNR Remarks And FF and VFF Are Written In PNR For Single Air and Single Car (Passive) when Not Known at Time of Booking is Ticked For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XI
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP    4    2
    Book Passive Car Segment X Months From Now    FRA    4    4
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    BUSINE
    Verify CDR Value Is Correct    Business Unit    TT
    Verify CDR Value Is Correct    Company    COMP1
    Verify CDR Value Is Correct    Company ID    123456
    Verify CDR Value Is Correct    DP Code    AAA
    Verify CDR Value Is Correct    Department    AD
    Verify CDR Value Is Correct    INTL Approver ID    222222
    Verify CDR Value Is Correct    Invoice narration 1    INV NAR 11
    Verify CDR Value Is Correct    Invoice narration 2    INV NAR 2
    Verify CDR Value Is Correct    Invoice narration 3    INV NAR 3
    Verify CDR Value Is Correct    Job Band    AGENT
    Verify CDR Value Is Correct    Location Code    EF333
    Verify CDR Value Is Correct    Manager ID    ABC333
    Verify CDR Value Is Correct    Manager Name    JUAN MIGUEL
    Verify CDR Value Is Correct    Cost Centre    IT
    Verify CDR Value Is Correct    Employee ID    555-55
    Verify CDR Value Is Correct    Name of INTL Approver    TEST
    Verify CDR Value Is Correct    Designation    QA.QC/TEST*1_BB22@33
    Set CDR Value    Business    BUSIN
    Set CDR Value    Business Unit    ${EMPTY}
    Set CDR Value    Company    COM2
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    BBB
    Set CDR Value    Department    ${EMPTY}
    Set CDR Value    INTL Approver ID    222223
    Set CDR Value    Invoice narration 1    INV NAR 1
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    ${EMPTY}
    Set CDR Value    Job Band    AGENT
    Set CDR Value    Location Code    CD222
    Set CDR Value    Manager ID    323232
    Set CDR Value    Manager Name    ${EMPTY}
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    ${EMPTY}
    Set CDR Value    Designation    QA.QA/TEST*1_BB22@33
    Tick Not Known At Time Of Booking
    Get CDR Description And Value    IN
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That CDRs Are Displayed From FF PNR Remarks And FF and VFF Are Written In PNR For Single Air and Single Car (Passive) when Not Known at Time of Booking is Ticked For IN

Amend Booking For Verify That Create Shell And Other Services Buttons Are Not Displayed
    Retrieve PNR    ${current_pnr}
    Verify Other Services Button Is Not Displayed
    Click Amend Booking
    Click Panel    Client Info
    Select Form Of Payment    Invoice
    Book Flight X Months From Now    HKGLAX/ACX    SS1Y1    FXP/S4    3    20
    Click Read Booking
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select Form Of Payment Value On Fare Quote Tab    Fare 1    Invoice
    Populate Fare Quote Tabs with Default Values
    Click Fare Tab    Fare 2
    Select Form Of Payment Value On Fare Quote Tab    Fare 2    Invoice
    Populate Fare Quote Tabs with Default Values
    Populate Fare Quote Tabs with Default Values
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR

Amend Booking For Verify That CDRs Are Displayed From VFF PNR Remarks And Only FF remarks Are Written In PNR For Multiple AIR
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XI
    Book Flight X Months From Now    BOMDEL/AUK    SS1Y1    FXP/S2    6    2
    Book Flight X Months From Now    DELBOM/AUK    SS1Y1    FXP/S3    6    8
    Click Read Booking
    Click Panel    Cust Refs
    Verify CDR Value Is Correct    Business    BUSINE
    Verify CDR Value Is Correct    Business Unit    ${EMPTY}
    Verify CDR Value Is Correct    Company    COM2
    Verify CDR Value Is Correct    Company ID    123456
    Verify CDR Value Is Correct    DP Code    AAA
    Verify CDR Value Is Correct    Department    ${EMPTY}
    Verify CDR Value Is Correct    INTL Approver ID    222223
    Verify CDR Value Is Correct    Invoice narration 1    INV NAR 1
    Verify CDR Value Is Correct    Invoice narration 2    INV NAR 2
    Verify CDR Value Is Correct    Invoice narration 3    ${EMPTY}
    Verify CDR Value Is Correct    Job Band    AGENT
    Verify CDR Value Is Correct    Location Code    CD222
    Verify CDR Value Is Correct    Manager ID    323232
    Verify CDR Value Is Correct    Manager Name    ${EMPTY}
    Verify CDR Value Is Correct    Cost Centre    IT
    Verify CDR Value Is Correct    Employee ID    555-55
    Verify CDR Value Is Correct    Name of INTL Approver    ${EMPTY}
    Verify CDR Value Is Correct    Designation    QA.QA/TEST*1_CC22@33
    Set CDR Value    Business    BUSINE
    Set CDR Value    Business Unit    TT
    Set CDR Value    Company    COMP1
    Set CDR Value    Company ID    123456
    Set CDR Value    DP Code    AAA
    Set CDR Value    Department    AD
    Set CDR Value    INTL Approver ID    222222
    Set CDR Value    Invoice narration 1    INV NAR 11
    Set CDR Value    Invoice narration 2    INV NAR 2
    Set CDR Value    Invoice narration 3    INV NAR 3
    Set CDR Value    Job Band    Agent
    Set CDR Value    Location Code    EF333
    Set CDR Value    Manager ID    ABC333
    Set CDR Value    Manager Name    Juan Miguel
    Set CDR Value    Cost Centre    IT
    Set CDR Value    Employee ID    555-55
    Set CDR Value    Name of INTL Approver    TEST
    Set CDR Value    Designation    QA.QC/TEST*1_BB22@33
    Get CDR Description And Value    IN
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking For Verify That CDRs Are Displayed From VFF PNR Remarks And Only FF remarks Are Written In PNR For Multiple AIR
