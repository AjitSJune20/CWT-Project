*** Settings ***
Force Tags        amadeus
Resource          ../resource_sanity.robot
*** Test Cases ***

[NB SG] New Booking
    [Tags]    bps    car    hotel    eo    not_ready
    Open Power Express And Retrieve Profile    ${version}    pilot    U003JDC    en-GB    ${EMPTY}    SG SWISS RE TEAM
    ...    Amadeus
    Set Client And Traveler    Swiss Re ¦ SG-SR Intl SE SG Branch    BEAR    DAVID
    Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/SWISSRE INTL SE/56NDZNDAVIDBEAR
    Click New Booking
    Click Panel    Client Info
    Comment    Select Form Of Payment    PORTRAIT-A/VI************1111/D1223-TEST
    Manually Set Value In Form Of Payment    VI    4444333322221111    1220
    Click Panel    Cust Refs
    Populate CDR For Swiss Re Client With Default Values
    Click Panel    Cust Refs
    Click Update PNR
    Book Air Segment Using Default Values    SG
    ###Change Req
    Comment    Book Amadeus Offer Retain Flight    S2    1
    ###
    Simulate Power Hotel Segment Booking Using Default Values
    Book Active Car Segment    JFK    car_vendor=ZE    pdate_num=2    pdays_num=3    rdays_num=4
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S3
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    Comment    ###
    Comment    Click Fare Tab    Alt Fare 1
    Comment    Populate Alternate Fare Quote Tabs With Default Values
    Comment    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Comment    Get Alternate Fare Details    Alt Fare 1    APAC
    Comment    Get Main Fees On Fare Quote Tab    Alt Fare 1
    Comment    ###
    #--Car Panel
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    CF - Client Negotiated Rate Accepted    ${EMPTY}    1 - Prepaid
    ...    No    \    Manual    TEST REMARK SCENARIO 2
    Get Car Tab Values
    #--Other Svcs Panel
    #24 EMERGENCY SERVICE FEE
    Populate Exchange Order Product    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    24 Hours Emergency Svcs
    Get Other Services Form Of Payment Details    24 Hours Emergency Svcs
    Get Other Services Additional Information Details    24 Hours Emergency Svcs
    Click Add Button In EO Panel    Service Info
    #Car Rental Prepaid
    Populate Exchange Order Product    Car Transfer    AVIS SINGAPORE    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    Car Transfer
    Get Other Services Form Of Payment Details    Car Transfer
    Click Tab In Other Services Panel    Departure From
    Get Location Value    identifier=departure_from
    Click Tab In Other Services Panel    Departure To
    Select Flight Value    2
    Get Location Value    identifier=departure_to
    Get Date & Time Value    identifier=departure_to
    Get Date And Time Checkbox Status    identifier=departure_to
    Click Tab In Other Services Panel    Arrival From
    Get Location Value    identifier=arrival_from
    Click Tab In Other Services Panel    Arrival To
    Tick Date & Time Checkbox
    Select Flight Value    ${EMPTY}
    Get Flight Value    identifier=arrival_to
    Get Location Value    identifier=arrival_to
    Get Date & Time Value    identifier=arrival_to
    Get Date And Time Checkbox Status    identifier=arrival_to
    Click Add Button In EO Panel    Service Info
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    keyword=New Booking Workflow
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    24 Hours Emergency Svcs
    Get Exchange Order Number Using Product    Car Transfer
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S3    03    AX378282246310005/D1220    Airline    country=SG
    ###Change
    Verify Default Alternate Restrictions Are Written In PNR
    ####
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Pspt and Visa Remarks
    Comment    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    192061860057793    TP    10    2023    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs
    #Other Svcs - Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Transfer
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Transfer    AVIS SINGAPORE    SG
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Swiss Re
    #Itinerary Remarks
    Comment    ###
    Comment    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    ####
    ##Wing Remark Verification
    Comment    Verify Wings Remarks Are Not Written

[AB SG] Amend Booking
    [Tags]    bps    car    hotel    eo    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S3
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    ###Alternate Fare
    Click Fare Tab    Alt Fare 1
    Populate Alternate Fare Quote Tabs With Default Values
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Get Alternate Fare Details    Alt Fare 1    APAC
    Get Main Fees On Fare Quote Tab    Alt Fare 1
    ###
    #--Car Panel
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    CF - Client Negotiated Rate Accepted    ${EMPTY}    1 - Prepaid
    ...    No    \    Manual    TEST REMARK SCENARIO 2
    Get Car Tab Values
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    #--Other Svcs Panel
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    keyword=Amend Booking Workflow
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    24 Hours Emergency Svcs
    Get Exchange Order Number Using Product    Car Transfer
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S3    03    AX378282246310005/D1220    Airline    country=SG
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Pspt and Visa Remarks
    Comment    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    192061860057793    TP    10    2023    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs
    #Other Svcs - Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Transfer
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Transfer    AVIS SINGAPORE    SG
    ###Change
    Verify Default Alternate Restrictions Are Written In PNR
    ####
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Swiss Re
    #Itinerary Remarks
    ###
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    ####
    ##Wing Remark Verification
    Comment    Verify Wings Remarks Are Not Written

[SI SG] Send Itinerary
    [Tags]    bps    car    hotel    eo    not_ready
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S3    03    AX378282246310005/D1220    Airline    country=SG
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2    false
    #Pspt and Visa Remarks
    Comment    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False    False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    192061860057793    TP    10    2023    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs
    #Other Svcs - Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Transfer
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Transfer    AVIS SINGAPORE    SG
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Swiss Re
    #Itinerary Remarks
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB HK] New Booking
    [Tags]    bps    car    hotel    eo    not_ready
    Comment    Open Power Express And Retrieve Profile    ${version}    pilot    U003JDC    en-GB    ${EMPTY}
    ...    APAC Synergy    Amadeus
    Set Client And Traveler    APAC E2E ¦ APAC HK - LYONDELLBASELL 406    BEAR    AUTOMATION TEST
    #Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/SWISSRE SIN SG/Z684F012342526
    Set Mobile Number
    Click New Booking
    Click Panel    Client Info
    Comment    Select Form Of Payment    PORTRAIT-A/VI************1111/D1230-VISAAIR
    Manually Set Value In Form Of Payment    VI    4444333322221111    1220
    Click Panel    Cust Refs
    Populate CDR For Lyondell Client With Default Values
    Click Update PNR
    Book Air Segment Using Default Values    HK
    Simulate Power Hotel Segment Booking Using Default Values
    Book Active Car Segment    JFK    car_vendor=ZE    pdate_num=2    pdays_num=3    rdays_num=4
    Book Amadeus Offer Retain Flight    S4
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S4
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    ###
    Click Fare Tab    Alt Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Alt Fare 1    AX    378282246310005    1220
    Populate Alternate Fare Quote Tabs With Default Values
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Get Alternate Fare Details    Alt Fare 1    APAC
    Get Main Fees On Fare Quote Tab    Alt Fare 1
    ###
    #--Car Panel
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    CF - Client Negotiated Rate Accepted    ${EMPTY}    1 - Prepaid
    ...    No    \    Manual    TEST REMARK SCENARIO 2
    Get Car Tab Values
    #--Other Svcs Panel
    #24 EMERGENCY SERVICE FEE
    Populate Exchange Order Product    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    24 EMERGENCY SERVICE FEE
    Get Other Services Form Of Payment Details    24 EMERGENCY SERVICE FEE
    Get Other Services Additional Information Details    24 EMERGENCY SERVICE FEE
    Click Add Button In EO Panel    Service Info
    #Car Rental Prepaid
    Populate Exchange Order Product    Car Rental Prepaid    FAR EAST RENT A CAR LTD    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    Car Rental Prepaid
    Get Other Services Form Of Payment Details    Car Rental Prepaid
    Click Tab In Other Services Panel    Departure From
    Get Location Value    identifier=departure_from
    Click Tab In Other Services Panel    Departure To
    Select Flight Value    2
    Get Location Value    identifier=departure_to
    Get Date & Time Value    identifier=departure_to
    Get Date And Time Checkbox Status    identifier=departure_to
    Get Flight Value    identifier=departure_to
    Click Tab In Other Services Panel    Arrival From
    Get Location Value    identifier=arrival_from
    Click Tab In Other Services Panel    Arrival To
    Tick Date & Time Checkbox
    Select Flight Value    ${EMPTY}
    Get Flight Value    identifier=arrival_to
    Get Location Value    identifier=arrival_to
    Get Date & Time Value    identifier=arrival_to
    Get Date And Time Checkbox Status    identifier=arrival_to
    Click Add Button In EO Panel    Service Info
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    keyword=New Booking Workflow
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    24 EMERGENCY SERVICE FEE
    Get Exchange Order Number Using Product    Car Rental Prepaid
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S4    04    AX378282246310005/D1220    CWT    country=HK
    ###Change
    Verify Default Alternate Restrictions Are Written In PNR
    ####
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Pspt and Visa Remarks
    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    HK    identifier=24 EMERGENCY SERVICE FEE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    4484886032737710    VI    08    2023    Credit Card (CX)    HK
    ...    False    24 Emergency Service Fee
    #Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Rental Prepaid
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Rental Prepaid    FAR EAST RENT A CAR LTD    HK
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Lyondell
    #Itinerary Remarks
    ###
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    ####
    ##Wing Remark Verification
    Comment    Verify Wings Remarks Are Not Written

[AB HK] Amend Booking
    [Tags]    bps    car    hotel    eo    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S4
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    ###Alternate Fare
    Click Fare Tab    Alt Fare 1
    Populate Alternate Fare Quote Tabs With Default Values
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Get Alternate Fare Details    Alt Fare 1    APAC
    Get Main Fees On Fare Quote Tab    Alt Fare 1
    ###
    #--Car Panel
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    CF - Client Negotiated Rate Accepted    ${EMPTY}    1 - Prepaid
    ...    No    \    Manual    TEST REMARK SCENARIO 2
    Get Car Tab Values
    #--Other Svcs Panel
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    keyword=Amend Booking Workflow
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    24 Hours Emergency Svcs
    Get Exchange Order Number Using Product    Car Transfer
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S4    04    AX378282246310005/D1220    Airline    country=HK
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Pspt and Visa Remarks
    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    4484886032737710    VI    12    2023    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs
    #Other Svcs - Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Transfer
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Transfer    AVIS SINGAPORE    SG
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Swiss Re
    #Itinerary Remarks
    ###
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    ####
    ##Wing Remark Verification
    Comment    Verify Wings Remarks Are Not Written

[SI HK] Send Itinerary
    [Tags]    bps    car    hotel    eo    not_ready
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S3    03    AX378282246310005/D1220    Airline    country=HK
    #Remarks For Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2    false
    #Pspt and Visa Remarks
    Comment    Verify Visa Check Itinerary Remarks Are Written    check_ESTA_website=False    False
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written    4484886032737710    VI    12    2023    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs
    #Other Svcs - Remarks for Car Rental Prepaid
    Verify Other Services General Notepad Remarks    Car Transfer
    Verify That Car Remarks Are Written In PNR When FOP is CX    Car Transfer    AVIS SINGAPORE    SG
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #CDR For Car Remarks
    Verify CDR VFF Remarks Are Written For Swiss Re
    #CDR For Air Remarks
    Verify CDR FF Remarks Are Written For Swiss Re
    #Itinerary Remarks
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB HK]New Booking With Air
    [Tags]    with_air
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    APAC Synergy    Amadeus
    Set Client And Traveler    American Bureau of Shipping ¦ HK-ABS    BEAR    Vernon
    Tick Traveler Checkbox
    Select Client Account    0000001045 ¦ American Bureau of Shipping ¦ HK-ABS
    Select PCC/CompanyProfile/TravellerProfile    1A/HKGWL2113/ABSXHK/NXTMWL112233
    Set Mobile Number
    Click New Booking
    Comment    Populate CDR For Lyondell Client With Default Values
    Update PNR With Default Values
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    AX    378282246310005    1220
    Book Air Segment Using Default Values    HK
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    #24 EMERGENCY SERVICE FEE
    Populate Exchange Order Product    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Fare    654
    Get Other Services Cost Details    24 EMERGENCY SERVICE FEE
    Get Other Services Form Of Payment Details    24 EMERGENCY SERVICE FEE
    Get Other Services Additional Information Details    24 EMERGENCY SERVICE FEE
    Click Add Button In EO Panel    Service Info
    ###Second EO
    Select Product And Vendor    BSP AIR TICKET    BSP
    Click Tab In Other Services Panel    Ticket Info
    Populate Ticket Info Tab With Default Values
    Set Nett Fare    432
    Get Merchant Fee In Other Services
    Get Ticket Info Fee Values    HK
    Get Other Services Form Of Payment Details
    Get Selected Air Segment From Air Segment Grid
    ###Values Verification
    Compute Consolidator And LCC Fees For Other Services    HK    2
    Verify Total Selling Price Value Is Correct
    Verify Nett Cost In EO Value Is Correct
    Verify Gross Fare Value Is Correct
    Verify Merchant Fee Value Is Correct
    # MI Info Section
    Click Tab In Other Services Panel    MI
    Verify MI Default Field Values    HK
    Populate MI Tab With Default Values Pilot    hk
    Get MI Fields Values
    Click Add Button In EO Panel    Ticket Info
    Verify EO Product Added On EO Grid    BSP AIR TICKET
    Populate All Panels (Except Given Panels If Any)    Air Fare    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    HKG-SIN    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=New Booking Workflow
    ###PNR Message Verification
    Verify PNR Is Successfully Created    False    Exchange Order(s) Transaction Successfully Saved!
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    BSP AIR TICKET
    Get Exchange Order Number Using Product    24 EMERGENCY SERVICE FEE
    Click Panel    Other Svcs
    ###EO Status Verification
    Verify EO Status For Third Party Vendor    New    1
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S2    02    AX378282246310005/D1220    Airline    country=HK
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    Comment    #CDR For Air Remarks
    Comment    Verify CDR FF Remarks Are Written For Lyondell
    #Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    HK    identifier=24 EMERGENCY SERVICE FEE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    378282246310005    AX    12    1220    Credit Card (CX)    HK
    ...    False    24 EMERGENCY SERVICE FEE    identifier=24 EMERGENCY SERVICE FEE
    ### BSP AIR Ticket Remarks
    Verify BSP Ticket Accounting Remarks Are Written For Sandbox    BSP AIR TICKET    BSP    HK    eo_number=${eo_number_BSP AIR TICKET}
    Verify Merchant Fee Remarks Are Written    HK
    [Teardown]

[AB HK]Amend Booking With Air
    [Tags]    with_air
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    AX    378282246310005    1220
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    Click Panel    Other Svcs
    Cancel EO    ${eo_number_BSP AIR TICKET}    Ticket Info    HK
    #--Other Svcs Panel
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Air Fare    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    HKG-SIN    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=Amend Booking Workflow Without Air
    Execute Simultaneous Change Handling    Amend Booking Workflow With Air
    Click Panel    Other Svcs
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S2    02    AX378282246310005/D1220    Airline    country=HK
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    Comment    #CDR For Air Remarks
    Comment    Verify CDR FF Remarks Are Written For Lyondell
    ####Not Written
    Verify BSP Ticket Accounting Remarks Are Written Not Written
    Verify BSP Ticket Fuel Surcharge Accounting Remarks Are Not Written
    Verify BSP Ticket Discount Accounting Remarks Are Not Written
    #Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    HK    identifier=24 EMERGENCY SERVICE FEE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    378282246310005    AX    12    1220    Credit Card (CX)    HK
    ...    False    24 EMERGENCY SERVICE FEE    identifier=24 EMERGENCY SERVICE FEE
    [Teardown]

[SI HK] Send Itinerary With Air
    [Tags]    bps    car    hotel    eo
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Click Finish PNR    Send Itin Handling
    Execute Simultaneous Change Handling    Send Itin Handling
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Remarks For Main Sale
    Verify Accounting Remarks For Main Sale    Fare 1    S2    02    AX378282246310005/D1220    Airline    country=HK
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    HK    identifier=24 EMERGENCY SERVICE FEE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    378282246310005    AX    12    1220    Credit Card (CX)    HK
    ...    False    24 EMERGENCY SERVICE FEE    identifier=24 EMERGENCY SERVICE FEE
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB HK]New Booking Without Segments
    [Tags]    without_air    hk
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    APAC Synergy    Amadeus
    Set Client And Traveler    American Bureau of Shipping ¦ HK-ABS    BEAR    Vernon
    Tick Traveler Checkbox
    Select Client Account    0000001045 ¦ American Bureau of Shipping ¦ HK-ABS
    Select PCC/CompanyProfile/TravellerProfile    1A/HKGWL2113/ABSXHK/NXTMWL112233
    Set Mobile Number
    Click New Booking
    Update PNR With Default Values
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    MC    5555555555554444    1220
    Click Read Booking
    Click Panel    Other Svcs
    #First Eo
    Populate Exchange Order Product    CRUISE    FAE TRAVEL    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Cost    559
    Set Selling Price    765
    Get Other Services Cost Details    CRUISE
    Get Other Services Form Of Payment Details    CRUISE
    Get Other Services Additional Information Details    CRUISE
    Click Add Button In EO Panel    Service Info
    ##Eo2
    Populate Exchange Order Product    MEET AND GREET SERVICE    CENTRAL SKY TRAVEL LIMITED    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Cost    500
    Set Selling Price    600
    Get Other Services Cost Details    MEET AND GREET SERVICE
    Get Other Services Form Of Payment Details    MEET AND GREET SERVICE
    Get Other Services Additional Information Details    MEET AND GREET SERVICE
    Click Add Button In EO Panel    Service Info
    Populate All Panels (Except Given Panels If Any)    Delivery    Other Svcs
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    SIN-HKG    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=New Booking Workflow
    ###PNR Message Verification
    Verify PNR Is Successfully Created    False    Exchange Order(s) Transaction Successfully Saved!
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    CRUISE
    Get Exchange Order Number Using Product    MEET AND GREET SERVICE
    Click Panel    Other Svcs
    ###EO Status Verification
    Verify EO Status For Third Party Vendor    New    1
    Get Exchange Order Number    first
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    Comment    #CDR For Air Remarks
    Comment    Verify CDR FF Remarks Are Written For Lyondell
    #Remarks for CRUICE
    Verify Other Services Without GST Service Accounting General Remarks    CRUISE    FAE TRAVEL    Credit Card (CX)    HK    identifier=CRUISE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    5555555555554444    MC    12    1220    Credit Card (CX)    HK
    ...    False    CRUISE    identifier=CRUISE
    ####MEET AND GREET SERVICE
    Verify Other Services Without GST Service Accounting General Remarks    MEET AND GREET SERVICE    CENTRAL SKY TRAVEL LIMITED    Credit Card (CX)    HK    identifier=MEET AND GREET SERVICE
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    5555555555554444    MC    12    1220    Credit Card (CX)    HK
    ...    False    MEET AND GREET SERVICE    identifier=MEET AND GREET SERVICE
    [Teardown]

[AB HK]Amend Booking Without Segments
    [Tags]    without_air
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    MC    5555555555554444    1220
    Click Read Booking
    Click Panel    Other Svcs
    Cancel EO    ${eo_number_first}    Service Info    HK
    Populate Exchange Order Product    TRAIN TICKET    CWT CHINA JV-SHANGHAI    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Cost    300
    Set Selling Price    500
    Get Other Services Cost Details    TRAIN TICKET
    Get Other Services Form Of Payment Details    TRAIN TICKET
    Get Passenger ID Value
    Get Routing Details
    Click Add Button In EO Panel    Service Info
    #--Other Svcs Panel
    Populate All Panels (Except Given Panels If Any)    Other Svcs
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    SIN-HKG    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    Amend Booking Workflow Without Air
    Execute Simultaneous Change Handling    Amend Booking Workflow Without Air
    Verify PNR Is Successfully Created    False    1 Exchange Order(s) Successfully Cancelled!
    Get Exchange Order Number Using Product    TRAIN TICKET
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Comment    #CDR For Air Remarks
    Comment    Verify CDR FF Remarks Are Written For Lyondell
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    ##Remarks Not written for Meet and Greet
    Verify Other Services Credit Card Fees Accounting Remarks Are Not Written
    Verify Other Services Without GST Service Accounting General Remarks Are Not Written In The PNR
    ###Train Remarks
    Verify That Train And Ferry Remarks Are Written In PNR When FOP Is Credit Card    TRAIN TICKET    15    000281    HK
    [Teardown]

[SI HK] Send Itinerary without Segments
    [Tags]    bps    car    hotel    eo
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Click Finish PNR    Send Itin Handling
    Execute Simultaneous Change Handling    Send Itin Handling
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True    True
    Comment    #CDR For Air Remarks
    Comment    Verify CDR FF Remarks Are Written For Lyondell
    ##Remarks Not written for Meet and Greet
    Verify Other Services Credit Card Fees Accounting Remarks Are Not Written
    Verify Other Services Without GST Service Accounting General Remarks Are Not Written In The PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB SG] New Booking With Air
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    SG SWISS RE TEAM    Amadeus
    Set Client And Traveler    BP ¦ SG-BP    BEAR    TEST
    Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/BP SG/63MWDRUTEST123
    Click New Booking
    Update PNR With Default Values
    Click Panel    Client Info
    Click Panel    Cust Refs
    Comment    Populate CDR For E2E Paypal Client With Default Values
    Click Panel    Complete
    Book Air Segment Using Default Values    SG
    Book Active Car Segment    LAX    5    1    5    5    ET
    ...    1    CCAR
    Simulate Power Hotel Segment Booking Using Default Values
    Click Read Booking
    #air verification
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select Missed Saving Code Value    O - TRAVELLING WITH ANOTHER PERSON
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    HKG-SIN    Awaiting Approval    Awaiting Itinerary Segment
    Get Ticketing Date
    Get Follow Up Date Value
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    #car
    Select Commissionable    Yes
    Verify Commission Field Is Populated Correctly    10
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    SF - TRAVEL POLICY APPLIANCE    ${EMPTY}    0 - Referral
    ...    Yes    11.33    Manual    TEST REMARK SCENARIO 1
    Populate Delivery Panel With Default Values
    #--Other Svcs Panel
    ###Air EO 2
    Select Product And Vendor    AA SEGMENT BOOKING FEE    BANK SETTLEMENT PLAN
    Click Tab In Other Services Panel    Ticket Info
    Select Bill Fare    Marked Up Nett Fare
    Populate Other Services Ticket Cost For BSP Ticket    500.00    800.00    0.00    AA    0.00    BB
    ...    0.00    0.00    0.00
    Set Issue In Exchange For    ${EMPTY}
    Populate Airline Code And Ticket Number    111    0000000000
    Get Ticket Info Fee Values
    Get Other Services Form Of Payment Details
    Get Selected Air Segment From Air Segment Grid
    ###Values Verification
    Compute Consolidator And LCC Fees For Other Services    SG    2
    Verify Total Selling Price Value Is Correct
    Verify Nett Cost In EO Value Is Correct
    # MI Info Section
    Click Tab In Other Services Panel    MI
    Populate MI Tab With Default Values Pilot    sg
    Get MI Fields Values    AA SEGMENT BOOKING FEE
    Click Add Button In EO Panel    Ticket Info
    Verify EO Product Added On EO Grid    AA SEGMENT BOOKING FEE
    Click Panel    Pspt and Visa
    Select Is Doc Valid    Yes
    Click Check Visa Requirements
    Tick Transit Checkbox    Philippines
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    SIN-HKG    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=New Booking Workflow
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    AA SEGMENT BOOKING FEE
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Click Panel    Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    ###AA Segment Booking Fee Remarks Verification
    Verify BSP Ticket Accounting Remarks Are Written    AA SEGMENT BOOKING FEE    BANK SETTLEMENT PLAN    SG
    Verify BSP Ticket Air Commission Returned Accounting Remarks Are Not Written
    [Teardown]

[AB SG] Amend Booking With Air
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Manually Set Value In Form Of Payment    VI    4444333322221111    1230
    Populate All Panels (Except Given Panels If Any)    Delivery    Other Svcs
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Add Email Address Receive Itinerary and Invoice On Delivery Panel    1    madhurima2111sarkar@gmail.com    True    True
    Add Email Address Receive Itinerary and Invoice On Delivery Panel    2    madhurima2016sarkar@gmail.com    True    True
    Set On Hold Reasons    HKG-SIN    Awaiting Approval    Awaiting Itinerary Segment
    Select Delivery Method    Ticket Time Limit (TKTL)
    Get Ticketing Date
    Get Follow Up Date Value
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    #24 EMERGENCY SERVICE FEE
    Populate Exchange Order Product    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Cost    768
    Set Selling Price    987
    Manually Add Form Of Payment (FOP) In Other Services    Credit Card (CX)    VI    4988438843884305    12    2023
    Get Other Services Cost Details    24 Hours Emergency Svcs
    Get Other Services Form Of Payment Details    24 Hours Emergency Svcs
    Get Other Services Additional Information Details    24 Hours Emergency Svcs
    Click Add Button In EO Panel    Service Info
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    Amend Booking Workflow With Air SG
    Execute Simultaneous Change Handling    Amend Booking Workflow With Air SG
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    24 Hours Emergency Svcs
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Click Panel    Car
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Cash Or Invoice Fees Accounting Remarks Are Written    SG    24 HOURS EMERGENCY SVCS
    #Delivery Remarks
    Verify Ticketing RIR Remarks    TLIS    True

[SI SG] Send ITIN With Air
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Click Panel    Recap
    Click Finish PNR    Send Itin Handling
    Execute Simultaneous Change Handling    Send Itin Handling
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Correct Car Segment Related Remarks Are Written In The PNR    S2    false
    #Power Hotel Remarks
    Verify Power Hotel Remarks Are Written In The PNR
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB HK] New Booking With LCC
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    APAC Synergy    Amadeus
    Comment    Set Client And Traveler    APAC E2E ¦ APAC HK - LYONDELLBASELL 406    BEAR    AUTOMATION TEST
    Set Client And Traveler    American Bureau of Shipping ¦ HK-ABS    BEAR    Vernon
    Tick Traveler Checkbox
    Select Client Account    0000001045 ¦ American Bureau of Shipping ¦ HK-ABS
    Select PCC/CompanyProfile/TravellerProfile    1A/HKGWL2113/ABSXHK/NXTMWL112233
    Set Mobile Number
    Click New Booking
    Manually Set Value In Form Of Payment    VI    4444333322221111    1230
    Update PNR With Default Values
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=100    taxes_total=78    servicefee_total=2    charge=2    grand_total=180
    ...    booking_reference=A06PJT    currency=SGD
    #LCC 1 Booking
    Book Travel Fusion Air Segment    CEBUPACIFIC    5J    MNLSIN    6    S2    A06PJT
    Enter Travel Fusion Fare Remarks    LCC1    5J    S2    SGD    Airline
    Enter Travel Fusion Other Remarks    LCC1    SGD    S2
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Complete
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    MNL-SIN    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Fare Including Taxes Value Is Correct    LCC1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    CF - Business Full Fare
    Select Form Of Payment On Fare Quote Tab    LCC1    VI************1111/D1230
    Populate Fare Quote Tabs with Default Values
    Set Transaction Fee On Air Fare Panel    10
    Get LFCC Field Value    LCC1
    Get Point Of Turnaround    LCC1
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Savings Code    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Fuel Surcharge Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Air Fare Restrictions Radio Button    LCC 1    Default
    #SVC Fee for Surcharges
    Populate Exchange Order Product    SVC Fee for Surcharges    CWT    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Fare    500
    Get Other Services Cost Details    SVC Fee for Surcharges
    Get Other Services Form Of Payment Details    SVC Fee for Surcharges
    Get Other Services Additional Information Details    SVC Fee for Surcharges
    Click Add Button In EO Panel    Service Info
    Click Finish PNR
    Click Panel    Other Svcs
    Get Exchange Order Number Using Product    SVC Fee for Surcharges
    Retrieve PNR Details from Amadeus
    #LCC 1 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC1    HKD    HK
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC1    00003152    203    A06PJT    VI************1111/D1230    SG02
    ...    S2
    #Remarks for SVC Fee for Surcharges
    Verify Other Services General Notepad Remarks    SVC Fee for Surcharges

[AB HK] Amend Booking With LCC
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1223
    Enter GDS Command    XE2
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=300    taxes_total=100    servicefee_total=0    charge=250    grand_total=550
    ...    booking_reference=A06PJTX    currency=PHP    country=HK
    #LCC 1 Booking
    Book Travel Fusion Air Segment    JETSTAR    3K    HKGMNL    6    S2    A06PJXX
    Enter Travel Fusion Fare Remarks    LCC1    3K    S2    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC1    PHP    S2
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    HKG-MNL    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Fare Including Taxes Value Is Correct    LCC1
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 1    MNL
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    3K    LCC 1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    CF - Business Full Fare
    Select Form Of Payment On Fare Quote Tab    LCC 1    VI************4305/D1223
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Point Of Turnaround    LCC1
    Get Savings Code    LCC1
    Get LFCC Field Value    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Fuel Surcharge Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Air Fare Restrictions Radio Button    LCC 1    Default
    Click Finish PNR    Amend To Verify That LCC Bookings [HK]
    Execute Simultaneous Change Handling    Amend To Verify That LCC Bookings [HK]
    Retrieve PNR Details from Amadeus
    #LCC 1 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC1    HKD    HK
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC1    00003152    375    A06PJXX    VI************4305/D1223    SG02
    ...    S2
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB SG] New Booking LCC
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    SG SWISS RE TEAM    Amadeus
    Set Client And Traveler    BP ¦ SG-BP    BEAR    TEST
    Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/BP SG/63MWDRUTEST123
    Click New Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1223
    Update PNR With Default Values
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=100    taxes_total=78    servicefee_total=2    charge=20    grand_total=183
    ...    booking_reference=A06PJTT    currency=PHP    country=SG
    #LCC 1 Booking
    Book Travel Fusion Air Segment    CEBUPACIFIC    5J    MNLCEB    6    S2    A06PJTT
    Enter Travel Fusion Fare Remarks    LCC1    5J    S2    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC1    PHP    S2
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC2    fare_total=200    taxes_total=100    servicefee_total=0    charge=250    grand_total=450
    ...    booking_reference=A06PJTX    currency=PHP    country=SG
    #LCC 2 Booking
    Book Travel Fusion Air Segment    CEBUPACIFIC    5J    SINHKG    7    S3    A06PJTX
    Enter Travel Fusion Fare Remarks    LCC2    5J    S3    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC2    PHP    S3
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    MNL-CEB    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify Fare Including Taxes Value Is Correct    LCC 1
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 1    CEB
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    5J    LCC 1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON    CD - Business Discounted Fare
    Set Airline Commission Percentage    2
    Set Transaction Fee On Air Fare Panel    10
    Comment    Select Form Of Payment On Fare Quote Tab    LCC 1    PORTRAIT-A/AX***********0002/D0899-AX
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Point Of Turnaround    LCC1
    Get Savings Code    LCC1
    Get LFCC Field Value    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Default Restricions in Fare Tab    LCC 1
    #LCC Fare 2
    Click Fare Tab    LCC 2
    Verify LCC Fare Tab Details    SIN-HKG    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC2    True
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify Fare Including Taxes Value Is Correct    LCC 2
    Set Transaction Fee On Air Fare Panel    76.76
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 2    HKG
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    5J    LCC 2
    Set Airline Commission Percentage    2
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON    FC - First Corporate Fare
    Comment    Select Form Of Payment On Fare Quote Tab    LCC 2    VI************4305/D1223
    Get Charged Fare Value    LCC2
    Get High Fare Value    LCC2
    Get Low Fare Value    LCC2
    Get Routing Name    LCC2
    Get Point Of Turnaround    LCC2
    Get Savings Code    LCC2
    Get LFCC Field Value    LCC2
    Get Fare Including Airline Taxes Value    LCC2
    Get Transaction Fee Amount Value    LCC2
    Get Total Amount    LCC2
    Verify Total Amount Value Is Correct Based On Computed Value    LCC2
    Select Default Restricions in Fare Tab    LCC 2
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    #LCC 1 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC1    SGD    SG
    Comment    Verify Routing Itinerary Remarks Are Written    LCC1
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC1    022103    203    A06PJTT    VI************1111/D1221    SG02
    ...    S2
    #LCC 2 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC2    SGD    SG
    Comment    Verify Routing Itinerary Remarks Are Written    LCC2
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC2    022103    203    A06PJTX    VI************1111/D1221    SG03
    ...    S3
    Verify Default Restriction Remarks Are Written    2
    Verify Static Remarks On LCC Is Not Displayed
    Verify ViewTrip Itinerary Remarks Are Not Displayed

[AB SG] Amend Booking With LCC
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1223
    Enter GDS Command    XE2
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=300    taxes_total=100    servicefee_total=0    charge=250    grand_total=550
    ...    booking_reference=A06PJTX    currency=PHP    country=SG
    #LCC 1 Booking
    Book Travel Fusion Air Segment    JETSTAR    3K    HKGMNL    6    S2    A06PJXT
    Enter Travel Fusion Fare Remarks    LCC1    3K    S2    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC1    PHP    S2
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    HKG-MNL    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify Fare Including Taxes Value Is Correct    LCC 1
    Set Transaction Fee On Air Fare Panel    10
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 1    MNL
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    3K    LCC 1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON    CW - Business CWT Negotiated Fare
    Comment    Select Form Of Payment On Fare Quote Tab    LCC 1    PORTRAIT-A/AX***********0002/D0899-AX
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Point Of Turnaround    LCC1
    Get Savings Code    LCC1
    Get LFCC Field Value    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Default Restricions in Fare Tab    LCC 1
    #LCC Fare 2
    Click Fare Tab    LCC 2
    Verify LCC Fare Tab Details    SIN-HKG    14.60    14.60    14.60    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Select Form Of Payment On Fare Quote Tab    LCC 2    VI************4305/D1223
    Verify Fare Including Taxes Value Is Correct    LCC 2
    Verify Transaction Fee Value And Description Are Correct    LCC 2    76.76
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 2    HKG
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    5J    LCC 2
    Get Charged Fare Value    LCC2
    Get High Fare Value    LCC2
    Get Low Fare Value    LCC2
    Get Routing Name    LCC2
    Get Point Of Turnaround    LCC2
    Get Savings Code    LCC2
    Get LFCC Field Value    LCC2
    Get Fare Including Airline Taxes Value    LCC2
    Get Transaction Fee Amount Value    LCC2
    Get Total Amount    LCC2
    Verify Total Amount Value Is Correct Based On Computed Value    LCC2
    Select Default Restricions in Fare Tab    LCC 2
    Click Finish PNR    Amend To Verify That LCC Bookings [SG]
    Execute Simultaneous Change Handling    Amend To Verify That LCC Bookings [SG]
    Retrieve PNR Details from Amadeus
    #LCC 1 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC1    SGD    SG
    Comment    Verify Routing Itinerary Remarks Are Written    LCC1
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC1    022103    375    A06PJXT    VI************4305/D1223    SG02
    ...    S2
    #LCC 2 Remarks
    Verify Itinerary Remarks Are Written For LCC    LCC2    SGD    SG
    Comment    Verify Routing Itinerary Remarks Are Written    LCC2
    Verify Travel Fusion Remarks Are Written In The Accounting Lines    LCC2    022103    203    A06PJTX    VI************4305/D1223    SG03
    ...    S3
    Verify Default Restriction Remarks Are Written    2
    Verify Static Remarks On LCC Is Not Displayed
    Verify ViewTrip Itinerary Remarks Are Not Displayed
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

[NB SG]New Booking Without Segments
    Comment    Open Power Express And Retrieve Profile    ${version}    sandboxpilot    U003JDC    en-GB    ${EMPTY}
    ...    SG SWISS RE TEAM    Amadeus
    Set Client And Traveler    BP ¦ SG-BP    BEAR    TEST
    Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/BP SG/63MWDRUTEST123
    Click New Booking
    Update PNR With Default Values
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    MC    5555555555554444    1230
    Click Panel    Client Info
    Click Panel    Cust Refs
    Click Panel    Complete
    Click Read Booking
    #--Other Svcs Panel
    #24 Hours Emergency Svcs
    Populate Exchange Order Product    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    Remarks    Vendor Info
    Set Nett Fare    432
    Get Other Services Cost Details    24 Hours Emergency Svcs
    Get Other Services Form Of Payment Details    24 Hours Emergency Svcs
    Get Other Services Additional Information Details    24 Hours Emergency Svcs
    Click Add Button In EO Panel    Service Info
    # passport visa
    Click Panel    Pspt and Visa
    Select Is Doc Valid    Yes
    Click Check Visa Requirements
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    SIN-HKG    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=New Booking Workflow
    Get Exchange Order Number Using Product    24 Hours Emergency Svcs
    Retrieve PNR Details from Amadeus    ${current_pnr}
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    5555555555554444    MC    12    1230    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs    identifier=24 Hours Emergency Svcs

[AB SG] Amend Booking Without Segments
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1221
    Populate All Panels (Except Given Panels If Any)    Delivery    Other Svcs    Client Info
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Get Ticketing Date
    Get Follow Up Date Value
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Delivery
    Click Finish PNR    Amend Booking Workflow Without Segments
    Execute Simultaneous Change Handling    Amend Booking Workflow Without Segments
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Without GST Service Accounting General Remarks    24 Hours Emergency Svcs    Carlson Wagonlit GST    Credit Card (CX)    SG    identifier=24 Hours Emergency Svcs
    Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot    5555555555554444    MC    12    1230    Credit Card (CX)    SG
    ...    False    24 Hours Emergency Svcs    identifier=24 Hours Emergency Svcs

[SI SG]Send Itin Without Segments
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Click Panel    Recap
    Click Finish PNR    Send Itin Handling
    Execute Simultaneous Change Handling    Send Itin Handling
    Retrieve PNR Details From Amadeus    ${current_pnr}
    #Other Svcs - Remarks for 24 Emergency Service Fee
    Verify Other Services Cash Or Invoice Fees Accounting Remarks Are Written    SG    24 HOURS EMERGENCY SVCS
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Populate CDR For Swiss Re Client With Default Values
    Set CDR Value    COMPANY CODE    11111111
    Set CDR Value    Cost Center    COSTCENTER
    Set CDR Value    Division No    44444444
    Set CDR Value    LINE MANAGER    LINEMANAGER
    Set CDR Value    Project Code    PROJECTCODE
    Set CDR Value    Record Locator (PNR)    ABCDEF
    Set CDR Value    SR USER ID    ABCDE
    Set CDR Value    Trip reason    H

Populate CDR For Lyondell Client With Default Values
    Set CDR Value    Company Code    11111111
    Set CDR Value    Cost Center    COSTCENTER
    Set CDR Value    Employee ID    44444444
    Set CDR Value    Employee SAP Name    EMPSAPNAME
    Set CDR Value    EVP/SVP Name    EVPSVPNAME
    Set CDR Value    HR Division Name    HRDIVISIONNAME

Verify CDR FF Remarks Are Written For Lyondell
    Verify Specific Line Is Written In The PNR X Times    RM *FF12/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF13/11111111    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF14/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF15/EMPSAPNAME    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF16/EVPSVPNAME    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF17/HRDIVISIONNAME    1

Verify CDR VFF Remarks Are Written For Swiss Re
    Verify Specific Line Is Written In The PNR X Times    RM *VFF73/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFFCD/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF3/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF66/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF12/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF10/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF25/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF63/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF13/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF27/PROJECTCODE    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF14/PROJECTCODE    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF17/ABCDEF    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF26/ABCDEF    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF18/LINEMANAGER    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF20/11111111    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF24/11111111    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF23/H    1

Verify CDR FF Remarks Are Written For Swiss Re
    Verify Specific Line Is Written In The PNR X Times    RM *FFCD/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF73/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF3/44444444    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF10/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF66/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF12/COSTCENTER    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF25/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF13/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF63/ABCDE    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF27/PROJECTCODE    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF14/PROJECTCODE    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF17/ABCDEF    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF26/ABCDEF    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF18/LINEMANAGER    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF24/11111111    1
    Verify Specific Line Is Written In The PNR X Times    RM *FF20/11111111    1

Verify Hotel Remarks Are Written For Swiss Re
    Verify Specific Line Is Written In The PNR X Times    RM *NOCOMM/H00000001    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF33/H00000001/0    1
    Verify Specific Line Is Written In The PNR X Times    RM *VRF/H00000001/6941.00    1
    Verify Specific Line Is Written In The PNR X Times    RM *VLF/H00000001/6941.00    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF30/H00000001/CF    1
    Verify Specific Line Is Written In The PNR X Times    RM *VEC/H00000001/L    1
    Verify Specific Line Is Written In The PNR X Times    RM *VTYP/H00000001/C1D    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF35/H00000001/HHH    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF36/H00000001/G    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF34/H00000001/AB    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF39/H00000001/A    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF42/H00000001/309791    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF28/H00000001/G    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF58/H00000001/CWV    1

Verify Car Remarks Are Written For Swiss Re
    Verify Specific Line Is Written In The PNR X Times    RM *VLF/120.62/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VRF/120.62/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VEC/L/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF30/CF/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *NOCOMM/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF33/1/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF34/AB/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF35/AMA/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF36/M/S2    1
    Verify Specific Line Is Written In The PNR X Times    RM *VFF39/P/S2    1

New Booking Workflow
    Click Clear All
    Set Client And Traveler    Swiss Re ¦ SG-Swiss Re    BEAR    CHAWZ
    Select PCC/CompanyProfile/TravellerProfile    1A/SINWL2114/SWISSRE SIN SG/Z684F012342526
    Click New Booking
    Click Panel    Cust Refs
    Populate CDR For Swiss Re Client With Default Values
    Click Update PNR
    Book Air Segment Using Default Values    SG
    Book Hotel Segment Using Default Values
    Book Active Car Segment    JFK    car_vendor=ZE    pdate_num=2    pdays_num=3    rdays_num=4
    Click Read Booking
    #--Air Fare Panel
    Click Fare Tab    Fare 1
    Manually Set Form Of Payment - Card Details On Fare Quote Tab    Fare 1    AX    378282246310005    1220
    Select FOP Merchant On Fare Quote Tab    Fare 1    CWT
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    #--Car Panel
    Populate Car Tab With Values    ${EMPTY}    ${EMPTY}    ${EMPTY}    UC - VALUE ADDED OFFER    ${EMPTY}    1 - Prepaid
    ...    No    \    Manual    TEST REMARK SCENARIO 2
    Get Car Tab Values
    #-- Pspt and Visa
    #--Other Svcs Panel
    #24 EMERGENCY SERVICE FEE
    Populate Exchange Order Product    24 EMERGENCY SERVICE FEE    CWT    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    24 EMERGENCY SERVICE FEE
    Get Other Services Form Of Payment Details    24 EMERGENCY SERVICE FEE
    Get Other Services Additional Information Details    24 EMERGENCY SERVICE FEE
    Click Add Button In EO Panel    Service Info
    #Car Rental Prepaid
    Populate Exchange Order Product    Car Rental Prepaid    FAR EAST RENT A CAR LTD    Credit Card (CX)    Remarks    Vendor Info
    Get Other Services Cost Details    Car Rental Prepaid
    Get Other Services Form Of Payment Details    Car Rental Prepaid
    Click Tab In Other Services Panel    Departure From
    Get Location Value    identifier=departure_from
    Click Tab In Other Services Panel    Departure To
    Select Flight Value    2
    Get Location Value    identifier=departure_to
    Get Date & Time Value    identifier=departure_to
    Get Date And Time Checkbox Status    identifier=departure_to
    Click Tab In Other Services Panel    Arrival From
    Get Location Value    identifier=arrival_from
    Click Tab In Other Services Panel    Arrival To
    Tick Date & Time Checkbox
    Select Flight Value    ${EMPTY}
    Get Flight Value    identifier=arrival_to
    Get Location Value    identifier=arrival_to
    Get Date & Time Value    identifier=arrival_to
    Get Date And Time Checkbox Status    identifier=arrival_to
    Click Add Button In EO Panel    Service Info
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR    keyword=New Booking Workflow

Amend Booking Workflow Without Air
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Panel    Client Info
    Manually Set Value In Form Of Payment    MC    5555555555554444    1220
    Click Read Booking
    Click Panel    Other Svcs
    #--Other Svcs Panel
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Delivery
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    SIN-HKG    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    Amend Booking Workflow Without Air
    Execute Simultaneous Change Handling    Amend Booking Workflow Without Air

Amend Booking Workflow With Air
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    AX    378282246310005    1220
    Click Read Booking
    #--Air Fare Panel
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Select FOP Merchant On Fare Quote Tab    Fare 1    Airline
    Populate Fare Details And Fees Tab With Default Values    Fare 1
    Get Base Fare, Total Taxes, YQ Tax, OB Fee And LFCC From TST    Fare 1    S2
    Get High, Charged And Low Fare In Fare Tab    Fare 1
    Get Routing, Turnaround and Route Code    Fare 1
    Get LFCC Field Value    Fare 1
    Get Main Fees On Fare Quote Tab    Fare 1
    Get Savings Code    Fare 1
    Click Panel    Other Svcs
    Comment    Cancel EO    ${eo_number_BSP AIR TICKET}    Ticket Info    HK
    #--Other Svcs Panel
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Air Fare    Delivery
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Set On Hold Reasons    HKG-SIN    Awaiting Approval    Awaiting Itinerary Segment
    Click Finish PNR    keyword=Amend Booking Workflow Without Air

Send Itin Handling
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Populate All Panels (Except Given Panels If Any)
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Click Finish PNR    Send Itin Handling

Verify Other Services Without GST Service Accounting General Remarks Are Not Written In The PNR
    #General Accounting Remarks
    Run Keyword And Continue On Failure    Verify Specific Line Is Not Written In The PNR    ${accounting_remarks_first_line}
    Run Keyword And Continue On Failure    Verify Specific Line Is Not Written In The PNR    ${accounting_remarks_last_line}
    #Without GST Remarks Not Written
    Run Keyword And Continue On Failure    Run Keyword If    "${bta_description}" != "${EMPTY}"    Verify Specific Line Is Not Written In The PNR    ${without_gst_acc_rem_1}

Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    [Arguments]    ${fop_identifier}==${EMPTY}    ${fop_dropdown_value}==${EMPTY}    ${select_val_from_dropdown}==False    ${fop_type_value}=="Credit Card (CX)"
    Activate Power Express Window
    Get Passive HHL Hotel Segment From The PNR
    Get Passive HTL Hotel Segment From The PNR
    @{error_eos}    Get Row Index In Error Eo Grid
    : FOR    ${error_eo_number}    IN    @{error_eos}
    \    Click Amend In Eo Grid    ${error_eo_number}
    \    Get Product
    \    Wait Until Control Object Is Visible    [NAME:OtherServicesTabControl]
    \    ${visible_tabs}    Get Tab Items    OtherServicesTabControl
    \    ${actual_tab}    Set Variable    ${visible_tabs[0]}
    \    ${ticket_type_tab}    Set Variable    ${visible_tabs[1]}
    \    ${hotel_segment_visibility}    Is Control Visible    [NAME:SegmentListView]
    \    Run Keyword If    "${actual_tab.lower()}"=="hotel info" and "${hotel_segment_visibility}"=="True" and "${hhl_segments_list}"!="${EMPTY}"    Select Hotel Segment    ${hhl_segments_list[0]}
    \    Run Keyword If    "${actual_tab.lower()}"=="hotel info" and "${hotel_segment_visibility}"=="True" and "${htl_segments_list}"!="${EMPTY}"    Select Hotel Segment    ${htl_segments_list[0]}
    \    ${object_visibility}    Is Control Visible    [NAME:FormsOfPaymentComboBox]
    \    Run Keyword If    "${object_visibility}"=="True"    Get FOP Type In Other Services
    \    ${fop_is}    Get Control Field Mandatory State    [NAME:FormsOfPaymentComboBox]
    \    Run Keyword If    "${object_visibility}"=="True" and "${fop_is.lower()}"=="mandatory"    Select Form Of Payment (FOP) In Other Services    ${EMPTY}    Invoice
    \    ${air_segment_visibility}    Is Control Visible    [NAME:SegmentListView]
    \    Run Keyword If    ("${actual_tab.lower()}"=="ticket info" or "${actual_tab.lower()}"=="service info" ) and "${air_segment_visibility}"=="True" and "${actual_tab.lower()}"!="visa info" and "${actual_tab.lower()}"!="hotel info"    Tick Select All Segments
    \    Run Keyword If    "${ticket_type_tab.lower()}"=="ticket type"    Click Tab In Other Services Panel    Ticket Type
    \    ${ticket_type_air_segment}    Is Control Visible    [NAME:SegmentListView]
    \    Run Keyword If    "${ticket_type_tab.lower()}"=="ticket type" and "${ticket_type_air_segment}"=="True"    Tick Select All Segments
    \    ${ticket_type}    Run Keyword If    "${ticket_type_tab.lower()}"=="ticket type"    Get Ticket Type Current Value
    \    ${object_fare_no_visible}    Is Control Visible    [NAME:FiledFareNumberComboBox]
    \    ${is_fare_no_mandatory}    Run Keyword If    "${ticket_type_tab.lower()}"=="ticket type" and "${object_fare_no_visible}"=="True"    Get Control Field Mandatory State    [NAME:FiledFareNumberComboBox]
    \    Run Keyword If    "${is_fare_no_mandatory}"=="Mandatory"    Select Value From Dropdown List    [NAME:FiledFareNumberComboBox]    1    by_index=True
    \    Take Screenshot
    \    Click Update Button In EO Panel    ${actual_tab}
    [Teardown]    Take Screenshot

Verify BSP Ticket Accounting Remarks Are Written For Sandbox
    [Arguments]    ${product_name}    ${vendor_name}    ${country}    ${card_number_is_masked}=True    ${identifier}=${EMPTY}    ${eo_number}=${EMPTY}
    ${product_code_number}    Get Product Code    ${country}    ${product_name}
    ${vendor_code_number}    Get Vendor Code    ${country}    ${product_name}    ${vendor_name}
    ${form_of_payment}    Set Variable If    "{identifier}"!="${EMPTY}"    ${form_of_payment_${identifier}}    ${form_of_payment}
    ${cc_number}    Run Keyword If    "${form_of_payment}" == "Credit Card (CX)" or "${form_of_payment}" == "Credit Card (CC)"    Is Credit Card Number Masked    ${card_number_is_masked}
    ${vendor_code_cc}    Run Keyword If    "${form_of_payment}" == "Credit Card (CX)"    Get Credit Card Vendor Code    ${form_of_payment_vendor_${identifier}}
    ...    ELSE IF    "${form_of_payment}" == "Credit Card (CC)"    Set Variable    CC
    ...    ELSE    Set Variable    S
    ${market_identifier}    Set Variable If    "${country.upper()}" == "SG"    S    A
    ${commission}    Get Variable Value    ${commission_${identifier}}    ${commission}
    Verify BSP Ticket Generic Accounting Remarks Are Written    ${product_name}    ${product_code_number}    ${vendor_code_number}    ${country}    ${identifier}
    ${status}    Run Keyword And Return Status    Should Be True    "${bill_fare_${identifier}}" != "Marked Up Nett Fare" or "${form_of_payment_${identifier}}" != "Credit Card (CX)"
    ${fee_value}    Set Variable If    "${country.upper()}" == "SG"    ${selling_fare_${identifier}}    ${nett_fare_${identifier}}
    ${commission}    Round APAC    ${commission}    ${country}
    ${sf_value}    Run Keyword If    "${country.upper()}" == "HK"    Evaluate    ${fee_value} + ${commission}
    ...    ELSE    Set Variable    ${fee_value}
    ${sf_value}    Round APAC    ${sf_value}    ${country}
    Set Suite Variable    ${bsp_line2}    RM *MSX/${market_identifier}${sf_value}/SF${sf_value}/C${commission}/SG${segment_long}/S${segment_short}
    Verify Specific Line Is Written In The PNR    RM *MSX/${market_identifier}${sf_value}/SF${sf_value}/C${commission}/SG${segment_long}/S${segment_short}
    Run Keyword If    "${bill_fare_${identifier}}" == "Marked Up Net Fare" and "${country.upper()}" == "SG"    Verify Specific Line Is Written In The PNR    RM *MSX/NF${fee_value}    #    # ELSE IF    "${bill_fare}" == "Marked Up Net Fare" and "${country.upper()}" == "HK"
    ...    # Verify Specific Line Is Written In The PNR    RM *MSX/NF${total_selling_price}
    ${bsp_line3}    Set Variable If    "${bill_fare_${identifier}}" == "Marked Up Net Fare" and "${country.upper()}" == "SG"    RM *MSX/NF${fee_value}    ${EMPTY}
    Set Suite Variable    ${bsp_line3}
    ${tax_line_remarks}    Set Variable If    ("${tax_value1_${identifier}}" != "0" and "${tax_value1_${identifier}}" != "0.00") and ("${tax_value2_${identifier}}" != "0" and "${tax_value2_${identifier}}" != "0.00")    RM *MSX/TX${tax_value1__${identifier}}${tax_code1__${identifier}}${tax_value2__${identifier}}${tax_code2__${identifier}}/F${vendor_code_cc}/R${mi_reference_fare_${identifier}}/L${mi_low_fare_${identifier}}/E${mi_missed_saving_code_${identifier}}/FF7-${mi_final_destination_${identifier}}/FF8-${mi_class_of_service_${identifier}}/FF81-${mi_low_fare_carrier_${identifier}.upper()}    ("${tax_value1_${identifier}}" != "0" and "${tax_value1_${identifier}}" != "0.00") and ("${tax_value2_${identifier}}" == "0" or "${tax_value2_${identifier}}" == "0.00")    RM *MSX/TX${tax_value1_${identifier}}${tax_code1_${identifier}}/F${vendor_code_cc}/R${mi_reference_fare_${identifier}}/L${mi_low_fare_${identifier}}/E${mi_missed_saving_code_${identifier}}/FF7-${mi_final_destination_${identifier}}/FF8-${mi_class_of_service_${identifier}}/FF81-${mi_low_fare_carrier_${identifier}.upper()}    ("${tax_value1_${identifier}}" == "0" or "${tax_value1_${identifier}}" == "0.00") and ("${tax_value2_${identifier}}" != "0" and "${tax_value2_${identifier}}" != "0.00")
    ...    RM *MSX/TX${tax_value2}${tax_code2}/F${vendor_code_cc}/R${mi_reference_fare}/L${mi_low_fare}/E${mi_missed_saving_code}/FF7-${mi_final_destination}/FF8-${mi_class_of_service}/FF81-${mi_low_fare_carrier.upper()}    RM *MSX/F${vendor_code_cc}/R${mi_reference_fare_${identifier}}/L${mi_low_fare_${identifier}}/E${mi_missed_saving_code_${identifier}}/FF7-${mi_final_destination_${identifier}}/FF8-${mi_class_of_service_${identifier}}/FF81-${mi_low_fare_carrier_${identifier}.upper()}
    Set Suite Variable    ${bsp_line4}    ${tax_line_remarks}
    Verify Specific Line Is Written In The PNR    ${tax_line_remarks}    false    true    true
    ${gross_fare}    Run Keyword If    "${bill_fare_${identifier}}" == "Published Fare" and "${country.upper()}" == "SG" and "${form_of_payment_${identifier}}" != "Credit Card (CX)"    Evaluate    ${selling_fare_${identifier}}-${merchant_fee_${identifier}}
    ...    ELSE    Evaluate    ${total_selling_price_${identifier}}-${merchant_fee_${identifier}}
    Run Keyword If    ("${form_of_payment_${identifier}}" == "Credit Card (CX)" or "${form_of_payment_${identifier}}" == "Credit Card (CC)")    Verify Specific Line Is Written In The PNR    RM \\*MSX/CCN${form_of_payment_vendor}.*EXP${expiry_month_${identifier}}${expiry_year_${identifier}}/D${gross_fare}    true
    ${bsp_line5}    Set Variable If    ("${form_of_payment}" == "Credit Card (CX)" or "${form_of_payment}" == "Credit Card (CC)")    RM *MSX/CCN${form_of_payment_vendor}${cc_number}EXP${expiry_month}${expiry_year}/D${gross_fare}    ${EMPTY}
    Set Suite Variable    ${bsp_line5}
    ${expected_booking_remarks}    Set Variable If    "${tranx_srv_fee_${identifier}}" == "0" or "${tranx_srv_fee_${identifier}}" == "0.00"    RM *MSX/FF38-${et_pt}/FF30-${mi_realised_saving_code_${identifier}}/FF31-N/FF34-AB/FF35-AMA/FF36-M    RM *MSX/FF38-${et_pt}/FF30-${mi_realised_saving_code_${identifier}}/FF31-Y/FF32-${tranx_srv_fee_${identifier}}/FF34-AB/FF35-AMA/FF36-M    #${et_pt}
    Verify Specific Line Is Written In The PNR    ${expected_booking_remarks}    false    true    true
    Set Suite Variable    ${bsp_line6}    ${expected_booking_remarks}
    Run Keyword If    "${issue_in_exchange_for_${identifier}}" != "${EMPTY}"    Verify Specific Line Is Written In The PNR    RM *MSX/EX${issue_in_exchange_for_${identifier}}
    ${bsp_line7}    Set Variable If    "${issue_in_exchange_for_${identifier}}" != "${EMPTY}"    RM *MSX/EX${issue_in_exchange_for_${identifier}}    ${EMPTY}
    Set Suite Variable    ${bsp_line7}

Amend To Verify That LCC Bookings [HK]
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1223
    Enter GDS Command    XE2
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=300    taxes_total=100    servicefee_total=0    charge=250    grand_total=550
    ...    booking_reference=A06PJTX    currency=PHP    country=HK
    #LCC 1 Booking
    Book Travel Fusion Air Segment    JETSTAR    3K    HKGMNL    6    S2    A06PJXX
    Enter Travel Fusion Fare Remarks    LCC1    3K    S2    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC1    PHP    S2
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    HKG-MNL    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Fare Including Taxes Value Is Correct    LCC1
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 1    MNL
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    3K    LCC 1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    J - PASSENGER AUTHORISED TO TRAVEL OUTSIDE POLICY    CF - Business Full Fare
    Select Form Of Payment On Fare Quote Tab    LCC 1    VI************4305/D1223
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Point Of Turnaround    LCC1
    Get Savings Code    LCC1
    Get LFCC Field Value    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Fuel Surcharge Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Air Fare Restrictions Radio Button    LCC 1    Default
    Click Finish PNR

Amend To Verify That LCC Bookings [SG]
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1223
    Enter GDS Command    XE2
    #Generate Test Data
    Generate Fee Data For Travel Fusion    LCC1    fare_total=300    taxes_total=100    servicefee_total=0    charge=250    grand_total=550
    ...    booking_reference=A06PJTX    currency=PHP    country=SG
    #LCC 1 Booking
    Book Travel Fusion Air Segment    JETSTAR    3K    HKGMNL    6    S2    A06PJXT
    Enter Travel Fusion Fare Remarks    LCC1    3K    S2    PHP    Airline
    Enter Travel Fusion Other Remarks    LCC1    PHP    S2
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    #LCC Fare 1
    Click Fare Tab    LCC 1
    Verify LCC Fare Tab Details    HKG-MNL    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    ...    True    LCC1    True
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Verify Fare Including Taxes Value Is Correct    LCC 1
    Set Transaction Fee On Air Fare Panel    10
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 1    MNL
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    3K    LCC 1
    Populate Air Fare Savings Code    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON    CW - Business CWT Negotiated Fare
    Comment    Select Form Of Payment On Fare Quote Tab    LCC 1    PORTRAIT-A/AX***********0002/D0899-AX
    Get Charged Fare Value    LCC1
    Get High Fare Value    LCC1
    Get Low Fare Value    LCC1
    Get Routing Name    LCC1
    Get Point Of Turnaround    LCC1
    Get Savings Code    LCC1
    Get LFCC Field Value    LCC1
    Get Fare Including Airline Taxes Value    LCC1
    Get Transaction Fee Amount Value    LCC1
    Get Total Amount    LCC1
    Verify Total Amount Value Is Correct Based On Computed Value    LCC1
    Select Default Restricions in Fare Tab    LCC 1
    #LCC Fare 2
    Click Fare Tab    LCC 2
    Verify LCC Fare Tab Details    SIN-HKG    14.60    14.60    14.60    LC - LOW COST CARRIER FARE ACCEPTED    O - TRAVELLING WITH ANOTHER PERSON
    Verify Main Fees Fields Are Disabled (Except Given Field Name If Any)    Transaction Fee
    Select Form Of Payment On Fare Quote Tab    LCC 2    VI************4305/D1223
    Verify Fare Including Taxes Value Is Correct    LCC 2
    Verify Transaction Fee Value And Description Are Correct    LCC 2    76.76
    Verify FOP Merchant Field Is Not Visible On Fare Quote Tab
    Verify Turnaround Value Is Correct    LCC 2    HKG
    Verify Route Code Default Value    INTL
    Verify LFCC Field Value    5J    LCC 2
    Get Charged Fare Value    LCC2
    Get High Fare Value    LCC2
    Get Low Fare Value    LCC2
    Get Routing Name    LCC2
    Get Point Of Turnaround    LCC2
    Get Savings Code    LCC2
    Get LFCC Field Value    LCC2
    Get Fare Including Airline Taxes Value    LCC2
    Get Transaction Fee Amount Value    LCC2
    Get Total Amount    LCC2
    Verify Total Amount Value Is Correct Based On Computed Value    LCC2
    Select Default Restricions in Fare Tab    LCC 2
    Click Finish PNR

Amend Booking Workflow Without Segments
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Manually Set Value In Form Of Payment    VI    4988438843884305    1221
    Populate All Panels (Except Given Panels If Any)    Delivery    Other Svcs    Client Info
    Click Panel    Delivery
    Select On Hold Booking Reasons    Awaiting Approval
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Select Delivery Method    Ticket Time Limit (TKTL)
    Get Ticketing Date
    Get Follow Up Date Value
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)    Other Svcs    Delivery
    Click Finish PNR    Amend Booking Workflow Without Segments
    Execute Simultaneous Change Handling    Amend Booking Workflow Without Segments

Amend Booking Workflow With Air SG
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Manually Set Value In Form Of Payment    VI    4444333322221111    1230
    Populate All Panels (Except Given Panels If Any)    Delivery    Other Svcs
    Click Panel    Delivery
    Set Email Address In Delivery Panel    madhurima.sarkar@carlosonwagonlit.com
    Add Email Address Receive Itinerary and Invoice On Delivery Panel    1    madhurima2111sarkar@gmail.com    True    True
    Add Email Address Receive Itinerary and Invoice On Delivery Panel    2    madhurima2016sarkar@gmail.com    True    True
    Select On Hold Booking Reasons    Awaiting Approval
    Select Delivery Method    Auto Cancel Client Queue
    Get Ticketing Date
    Get Follow Up Date Value
    Click Panel    Other Svcs
    Populate Segments And Fop In Other Services Error EO For Sandbox Pilot
    Populate All Panels (Except Given Panels If Any)
    Click Finish PNR

Populate MI Tab With Default Values Pilot
    [Arguments]    ${country}=${EMPTY}
    Populate MI Fields    1234    500    MNL    PR
    Select MI Realised Saving Code    XX - NO SAVING
    Run Keyword If    "${country.lower()}"=="sg"    Select MI Missed Saving Code    T - CONTRACTED AIRLINE NON CONVENIENT
    ...    ELSE    Select MI Missed Saving Code    O - TRAVELLING WITH ANOTHER PERSON
    Run Keyword If    "${country.lower()}"=="sg"    Select MI Class Of Service    FC - First Corporate Fare
    ...    ELSE    Select MI Class Of Service    FF - First Full Fare

Verify Other Services Credit Card Fees Accounting Remarks Are Written For Pilot
    [Arguments]    ${credit_card_number}    ${fop_vendor}    ${expiry_month}    ${expiry_year}    ${fop}    ${country}
    ...    ${card_number_is_masked}=True    ${product_name}=${EMPTY}    ${identifier}=${EMPTY}
    [Documentation]    Ideal Usage:
    ...
    ...    Verify Other Services Credit Card Fees Accounting Remarks Are Written 5555000044440000 TP 12 2026 Credit Card (CX) SG
    ...
    ...    ..which verifies if the following line is written in the PNR (by default it will expect a masked credit card number)
    ...
    ...    RM *MSX/CCN${fop_vendor}${masked_credit_card_number}EXP${expiry_month}${last_two_digit_expiry_year}/D${total_selling_price}
    ...
    ...    Alternative Usage:
    ...
    ...    Verify Other Services Credit Card Fees Accounting Remarks Are Written 5555000044440000 JC 12 2026 Credit Card (CX) SG False
    ...
    ...    ..giving a False value to the last parameter verifies if the following line is written in the PNR and the card number is not masked
    ...
    ...    RM *MSX/CCN${fop_vendor}${credit_card_number}EXP${expiry_month}${last_two_digit_expiry_year}/D${total_selling_price}
    ${last_two_digit_expiry_year}    Get Substring    ${expiry_year}    2
    ${credit_card_length_excluding_last_four_digits}    Get Length    ${credit_card_number[:-4]}
    ${masked_characters_excluding_last_four}    Evaluate    "".join(["X" * ${credit_card_length_excluding_last_four_digits}])
    ${masked_credit_card_number}    Replace String    ${credit_card_number}    ${credit_card_number[:-4]}    ${masked_characters_excluding_last_four}
    ${masked_credit_card_number}    Set Variable If    '${card_number_is_masked.lower()}' == 'false'    ${credit_card_number}    ${masked_credit_card_number}
    ${cx_fee_code}    Set Variable If    "${fop_vendor}" == "VI" or "${fop_vendor}" == "CA" or "${fop_vendor}" == "MC" or "${fop_vendor}" == "JC"    CX4    "${fop_vendor}" == "AX"    CX2    "${fop_vendor}" == "TP"
    ...    CX5    "${fop_vendor}" == "DC"    CX3
    ${gst_amount}    Get Variable Value    ${gst_amount}    ${EMPTY}
    ${is_gst_applied}    Set Variable If    "${gst_amount}" != "${EMPTY}"    ${True}    ${False}
    ${total_selling_price}    Get Variable Value    ${total_selling_price_${product_name}}    ${total_selling_price}
    ${gst_amount}    Get Variable Value    ${gst_amount_${product_name}}    ${gst_amount}
    ${total_selling_price_value}    Round Apac    ${total_selling_price}    ${country}
    ${gst_computed_value}    Evaluate    ${total_selling_price} * 7 * 0.01
    ${gst_computed_value}    Run Keyword If    "${country}" == "SG"    Round APAC    ${gst_computed_value}    SG
    ${selling_price}    Get Variable Value    ${selling_price_${identifier}}    ${selling_price}
    ${merchant_fee}    Get Variable Value    ${merchant_fee_${identifier}}    ${merchant_fee}
    ${selling_price_with_gst}    Run Keyword If    "${gst_amount}" != "${EMPTY}" and "${country}" == "SG"    Evaluate    ${selling_price} + ${gst_amount} + ${merchant_fee}
    ...    ELSE    Set Variable    ${total_selling_price}
    ${selling_price_with_gst}    Round APAC    ${selling_price_with_gst}    ${country}
    ${market_identifier}    Set Variable If    "${country}" == "SG"    S    A
    ${is_included}    Verify If Product Is Included In List For Commission Line Update    ${product_name}    ${country}
    ${expected_fee_values}    Set Variable If    "${is_included}" == "True"    RM *MSX/${market_identifier}${total_selling_price_value}/SF${total_selling_price_value}/C${total_selling_price_value}    RM *MSX/${market_identifier}${total_selling_price_value}/SF${total_selling_price_value}/C${commission_${identifier}}
    Run Keyword If    "${fop}" == "Credit Card (CX)" and ${is_gst_applied} and "${country}" == "SG"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/G${gst_computed_value}/F${cx_fee_code}
    Run Keyword If    "${fop}" == "Credit Card (CX)" and not ${is_gst_applied} and "${country}" == "SG"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/F${cx_fee_code}
    Run Keyword If    "${fop}" == "Credit Card (CC)" and ${is_gst_applied} and "${country}" == "SG"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/G${gst_computed_value}/FCC
    Run Keyword If    "${fop}" == "Credit Card (CC)" and not ${is_gst_applied} and "${country}" == "SG"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/FCC
    #For HK
    Run Keyword If    "${fop}" == "Credit Card (CX)" and "${country}" == "HK"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/F${cx_fee_code}
    Run Keyword If    "${fop}" == "Credit Card (CC)" and "${country}" == "HK"    Verify Specific Line Is Written In The PNR    ${expected_fee_values}/FCC
    #For HK and SG
    Verify Specific Line Is Written In The PNR    RM \\*MSX/CCN${fop_vendor}.*EXP${expiry_month}${last_two_digit_expiry_year}/D${selling_price_with_gst}    true
    #Set Lines To A Variable For Not Written Checking
    ${other_services_cc_line2}    Run Keyword If    "${fop}" == "Credit Card (CX)" and ${is_gst_applied} and "${country}" == "SG"    Set Variable    ${expected_fee_values}/G${gst_amount}/F${cx_fee_code}
    ...    ELSE IF    "${fop}" == "Credit Card (CX)" and not ${is_gst_applied} and "${country}" == "SG"    Set Variable    ${expected_fee_values}/F${cx_fee_code}
    ...    ELSE IF    "${fop}" == "Credit Card (CC)" and ${is_gst_applied} and "${country}" == "SG"    Set Variable    ${expected_fee_values}/G${gst_amount}/FCC
    ...    ELSE IF    "${fop}" == "Credit Card (CC)" and not ${is_gst_applied} and "${country}" == "SG"    Set Variable    ${expected_fee_values}/FCC
    ...    ELSE IF    "${fop}" == "Credit Card (CX)" and "${country}" == "HK"    Set Variable    ${expected_fee_values}/F${cx_fee_code}
    ...    ELSE IF    "${fop}" == "Credit Card (CC)" and "${country}" == "HK"    Set Variable    ${expected_fee_values}/FCC
    Set Suite Variable    ${other_services_cc_line2}
    Set Suite Variable    ${fees_line_${product_name}}    ${other_services_cc_line2}
    Set Suite Variable    ${other_services_cc_line3}    RM \\*MSX/CCN${fop_vendor}.*EXP${expiry_month}${last_two_digit_expiry_year}/D${selling_price_with_gst}
    Set Suite Variable    ${credit_card_line_${product_name}}    ${other_services_cc_line3}
