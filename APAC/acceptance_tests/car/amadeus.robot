*** Settings ***
Resource          car_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That The Correct Remarks Are Written In The PNR When Active and Passive Car Segments Are Booked, Segment Is Commissionable, Booking Method is Manual, and Segments Partially Have Associated Remarks
    [Tags]    us316    us911    us996    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    Select GDS    amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US316    BEAR    INTHREEONESIX
    Click New Booking
    Update PNR With Default Values
    Book Active Car Segment    LAX    6    1    6    15    ET
    ...    1    CCAR
    Book Passive Car Segment X Months From Now    HKG    6    22    6    23    2
    ...    150    HKD    \    \    MCAR    WEEKEND
    Book Flight X Months From Now    SINMNL/APR    SS1Y1    FXP    5    3
    Click Read Booking
    Click Panel    Car
    Click Car Tab    LAX - ${pickup_date_1}
    Get Car Charged Rate From Amadeus    0
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    LC - LOW COST SUPPLIER RATE ACCEPTED    J - PASSENGER AUTHORISED TO CAR GRADE OUTSIDE POLICY    0 - Referral
    ...    Yes    7    GDS    ${EMPTY}
    Select Commissionable    No
    Click Car Tab    HKG - ${pickup_date_2}
    Verify Car Tab Values Are Populated Correctly    150.00    150.00    150.00    HKD    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    2330.33    1000.66    1500.22    SF - MULTI TRAVELLERS RATE SAVING ACCEPTED    B - PASSENGER REQUESTED SPECIFIC RENTAL COMPANY    0 - Referral
    ...    Yes    7    GDS    ${EMPTY}    Weekend
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Click Panel    Car
    Click Car Tab    LAX - ${pickup_date_1}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S3
    Click Car Tab    HKG - ${pickup_date_2}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S4

[AB IN] Verify That The Correct Remarks Are Written In The PNR When Multiple Active Car Segments Are Booked, Booking Method Is Mixed, And Segments Partially Have Associated Remarks
    [Tags]    us959    us316    us911    in    howan    us2120
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE3-4
    Book Active Car Segment    ORD    6    5    6    10    ET
    ...    1    FDMR
    Book Active Car Segment    JFK    6    15    6    20    ET
    ...    2    ICAR
    Book Passive Car Segment X Months From Now    SYD    7    1    7    8    3
    ...    120.04    HKD    EP    EUROPCAR    MCAR    WEEKEND
    Click Read Booking
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Get Car Charged Rate From Amadeus    0
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    1205.88    55.33    55.33    CR - PROMOTIONAL RATE    ${EMPTY}    0 - Referral
    ...    Yes    22    GDS    ${EMPTY}    ${EMPTY}
    Click Car Tab    JFK - ${pickup_date_2}
    Get Car Charged Rate From Amadeus    1
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    1205.89    55.34    70.33    TP - TRAVEL POLICY APPLIANCE    Z - CWT ALTERNATIVE DECLINED    0 - Referral
    ...    Yes    22.3    GDS    ${EMPTY}    ${EMPTY}
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Car Tab Values Are Populated Correctly    120.04    120.04    120.04    HKD    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    200.66    100.33    150.16    SF - MULTI TRAVELLERS RATE SAVING ACCEPTED    N - CLIENT SPECIFIC    1 - Prepaid
    ...    No    ${EMPTY}    Manual    TEST REMARK INDIA    Daily
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Correct Remarks Are Written In The PNR When Multiple Active Car Segments Are Booked, Booking Method Is Mixed, And Segments Partially Have Associated Remarks For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That The Correct Remarks Are Written In The PNR When Multiple Active Car Segments Are Booked, Booking Method Is Mixed, And Segments Partially Have Associated Remarks For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S3
    Get Car Charged Rate From Amadeus    0
    Verify Correct Car Remarks Per Panel Written to PNR    ET    ORD    ${pickup_date_1}    ${expected_car_charged_rate}    yes
    Click Car Tab    JFK - ${pickup_date_2}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S4
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S5
    Verify Correct Car Remarks Per Panel Written to PNR    1A    SYD    ${pickup_date_3}    120.04    yes

[AB IN] Verify That The Car Fields Are Prepopulated Correctly When Car Segments Are Partially Modified
    [Tags]    us959    us316    us911    in    howan    us2120
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE4
    Book Passive Car Segment X Months From Now    MNL    7    15    7    23    4
    ...    120.04    HKD    EP    EUROPCAR    MCAR    WEEKEND
    Click Read Booking
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Verify Car Tab Values Are Populated Correctly    1205.88    55.33    55.33    USD    Weekly    CR - PROMOTIONAL RATE
    ...    L - NO MISSED SAVING    0 - Referral    Yes    22    GDS    ${EMPTY}
    Verify Correct Car Remarks Per Panel Written to PNR    ET    ORD    ${pickup_date_1}    ${expected_car_charged_rate}    no
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Car Tab Values Are Populated Correctly    200.66    100.33    150.16    HKD    Daily    SF - MULTI TRAVELLERS RATE SAVING ACCEPTED
    ...    N - CLIENT SPECIFIC    1 - Prepaid    No    ${EMPTY}    Manual    TEST REMARK INDIA
    Verify Correct Car Remarks Per Panel Written to PNR    1A    SYD    ${pickup_date_3}    120.04    no
    Click Car Tab    MNL - ${pickup_date_4}
    Verify Car Tab Values Are Populated Correctly    120.04    120.04    120.04    HKD    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    2205.88    1155.33    1550.33    TP - TRAVEL POLICY APPLIANCE    Z - CWT ALTERNATIVE DECLINED    0 - Referral
    ...    Yes    22    GDS    ${EMPTY}    Weekly
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Car Fields Are Prepopulated Correctly When Car Segments Are Partially Modified For IN
    Execute Simultaneous Change Handling    Amend Booking For Verify That The Car Fields Are Prepopulated Correctly When Car Segments Are Partially Modified For IN
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S3
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S4
    Click Car Tab    MNL - ${pickup_date_4}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S5
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB IN] Verify That Car Panel Autopopulates Correctly When Both TTL/RG and TTL/RQ Block Is Present In Multiple Passive Car Segments
    [Tags]    us996    in    howan
    Open Power Express And Retrieve Profile    ${version}    Test    U001MKR    en-GB    mruizapac    APAC QA
    Select GDS    amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US316    BEAR    INTHREEONESIX
    Click New Booking
    Update PNR With Default Values
    Book Active Car Segment    LAX    6    1    6    2    ET
    ...    1    CCAR
    Book Passive Car Segment X Months From Now With RG/RQ And TTL Block    SYD    7    1    7    8    2
    ...    120.04    HKD    EP    EUROPCAR    MCAR    WEEKEND
    ...    \    \    1
    Book Passive Car Segment X Months From Now With RG/RQ And TTL Block    SFO    7    9    7    10    3
    ...    120.04    EUR    EP    EUROPCAR    MCAR    WEEKEND
    ...    RG    \    0
    Book Passive Car Segment X Months From Now With RG/RQ And TTL Block    BKK    7    9    7    10    4
    ...    120.04    EUR    EP    EUROPCAR    MCAR    WEEKEND
    ...    RQ    \    0
    Click Read Booking
    Click Panel    Car
    Click Car Tab    LAX - ${pickup_date_1}
    Get Car Charged Rate From Amadeus
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    XI - CORPORATE CONTRACT ACCEPTED    ${EMPTY}    0 - Referral
    ...    Yes    11.33    Manual    TEST REMARKS 1
    Click Car Tab    SYD - ${pickup_date_2}
    Verify Car Tab Values Are Populated Correctly    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    120.04    120.04    120.04    SD - SPECIAL SUPPLIER DISCOUNT    J - PASSENGER AUTHORISED TO CAR GRADE OUTSIDE POLICY    0 - Referral
    ...    Yes    12.34    GDS    TEST REMARKS 2    Weekly
    Click Car Tab    SFO - ${pickup_date_3}
    Verify Car Tab Values Are Populated Correctly    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    200.33    121.04    121.04    TP - TRAVEL POLICY APPLIANCE    L - NO MISSED SAVING    0 - Referral
    ...    Yes    13.56    GDS    TEST REMARK 3    Weekly
    Click Car Tab    BKK - ${pickup_date_4}
    Verify Car Tab Values Are Populated Correctly    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    300.33    160.34    170.33    RF - RESTRICTED RATE ACCEPTED    N - CLIENT SPECIFIC    0 - Referral
    ...    Yes    66.33    GDS    TEST REMARK 4    Weekly
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR

[AB IN] Verify That Car Segments And Car Remarks Are Not Present For Full Cancellation
    [Tags]    US2262    in
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE2-5
    Click Read Booking
    Verify Actual Panel Does Not Contain Expected Panel    Car
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details    ${current_pnr}
    Verify Specific Line Is Not Written In The PNR    RM CAR    true
    Verify Specific Line Is Not Written In The PNR    RM *VLF      
    Verify Specific Line Is Not Written In The PNR    RM *VRF      
    Verify Specific Line Is Not Written In The PNR    RM *VEC      
    Verify Specific Line Is Not Written In The PNR    RM *VFF      
    Verify Specific Line Is Not Written In The PNR    RM *VCM      
    Verify Specific Line Is Not Written In The PNR    RM *NOCOMM      
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}
    
*** Keywords ***
Amend Booking For Verify That The Correct Remarks Are Written In The PNR When Multiple Active Car Segments Are Booked, Booking Method Is Mixed, And Segments Partially Have Associated Remarks For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE3-4
    Book Active Car Segment    ORD    6    5    6    10    ET
    ...    1    FDMR
    Book Active Car Segment    JFK    6    15    6    20    ET
    ...    2    ICAR
    Book Passive Car Segment X Months From Now    SYD    7    1    7    8    3
    ...    120.04    HKD    EP    EUROPCAR    MCAR    WEEKEND
    Click Read Booking
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Get Car Charged Rate From Amadeus    0
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    1205.88    55.33    55.33    CR - PROMOTIONAL RATE    ${EMPTY}    0 - Referral
    ...    Yes    22    GDS    ${EMPTY}    ${EMPTY}
    Click Car Tab    JFK - ${pickup_date_2}
    Get Car Charged Rate From Amadeus    1
    Verify Car Tab Values For Newly Added Car Segment Are Populated Correctly Depending On Client Policy    No Policy    USD    L - NO MISSED SAVING    GDS
    Verify Car Tab Fields Are Mandatory
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    ${EMPTY}
    Populate Car Tab With Values    1205.89    55.34    70.33    TP - TRAVEL POLICY APPLIANCE    Z - CWT ALTERNATIVE DECLINED    0 - Referral
    ...    Yes    22.3    GDS    ${EMPTY}    ${EMPTY}
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Car Tab Values Are Populated Correctly    120.04    120.04    120.04    HKD    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    200.66    100.33    150.16    SF - MULTI TRAVELLERS RATE SAVING ACCEPTED    N - CLIENT SPECIFIC    1 - Prepaid
    ...    No    ${EMPTY}    Manual    TEST REMARK INDIA    Daily
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR

Amend Booking For Verify That The Car Fields Are Prepopulated Correctly When Car Segments Are Partially Modified For IN
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Enter GDS Command    XE4
    Book Passive Car Segment X Months From Now    MNL    7    15    7    23    4
    ...    120.04    HKD    EP    EUROPCAR    MCAR    WEEKEND
    Click Read Booking
    Click Panel    Car
    Click Car Tab    ORD - ${pickup_date_1}
    Verify Car Tab Values Are Populated Correctly    1205.88    55.33    55.33    USD    Weekly    CR - PROMOTIONAL RATE
    ...    L - NO MISSED SAVING    0 - Referral    Yes    22    GDS    ${EMPTY}
    Verify Correct Car Remarks Per Panel Written to PNR    ET    ORD    ${pickup_date_1}    ${expected_car_charged_rate}    no
    Click Car Tab    SYD - ${pickup_date_3}
    Verify Car Tab Values Are Populated Correctly    200.66    100.33    150.16    HKD    Daily    SF - MULTI TRAVELLERS RATE SAVING ACCEPTED
    ...    N - CLIENT SPECIFIC    1 - Prepaid    No    ${EMPTY}    Manual    TEST REMARK INDIA
    Verify Correct Car Remarks Per Panel Written to PNR    1A    SYD    ${pickup_date_3}    120.04    no
    Click Car Tab    MNL - ${pickup_date_4}
    Verify Car Tab Values Are Populated Correctly    120.04    120.04    120.04    HKD    ${EMPTY}    ${EMPTY}
    ...    L - NO MISSED SAVING    ${EMPTY}    ${EMPTY}    ${EMPTY}    Manual    ${EMPTY}
    Populate Car Tab With Values    2205.88    1155.33    1550.33    TP - TRAVEL POLICY APPLIANCE    Z - CWT ALTERNATIVE DECLINED    0 - Referral
    ...    Yes    22    GDS    ${EMPTY}    Weekly
    Populate All Panels (Except Given Panels If Any)    Car
    Click Finish PNR    Amend Booking For Verify That The Car Fields Are Prepopulated Correctly When Car Segments Are Partially Modified For IN
