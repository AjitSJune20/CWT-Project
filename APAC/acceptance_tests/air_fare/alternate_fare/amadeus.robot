*** Settings ***
Resource          ../air_fare_verification.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That Alternate Fare Values Are Pre-populated And Applicable Remarks Are Written
    [Tags]    in    us973    us972    us296    team_c    not_ready
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA
    ...    Amadeus
    Set Client And Traveler    US826 IN Airline Setup ¦ IN US826 Airline Setup    BEAR    INAIR
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    BLRDEL/AUK    SS1Y1    FXP/S2    6    15
    Book Flight X Months From Now    BLRDXB/AEK    SS1Y1    FXP/S3    6    25
    Book Amadeus Offer Retain Flight    S3    3
    Book Flight X Months From Now    BLRORD/AUK    SS1Y1    FXP/S4    6    35
    Book Amadeus Offer Retain Flight    S4    1
    Book Amadeus Offer Retain Flight    S4    4
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Populate Air Fare Panel Using Default Values For APAC
    Click Fare Tab    Fare 2
    Populate Air Fare Panel Using Default Values For APAC
    Click Fare Tab    Fare 3
    Populate Air Fare Panel Using Default Values For APAC
    Click Fare Tab    Alt Fare 1
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Get Offer From RTOF    Alt Fare 1
    Get Alternate Fare Details    Alt Fare 1    APAC
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 1
    Select Alternate Fare Class Code    Alt Fare 1    FF - First Class Full Fare
    Select Form Of Payment On Fare Quote Tab    Alt Fare 1    Cash
    Click Fare Tab    Alt Fare 2
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 2
    Get Offer From RTOF    Alt Fare 2
    Get Alternate Fare Details    Alt Fare 2    APAC
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 2
    Select Alternate Fare Class Code    Alt Fare 2    YF - Economy Class Full Fare
    Select Form Of Payment On Fare Quote Tab    Alt Fare 2    Cash
    Click Fare Tab    Alt Fare 3
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 3
    Get Offer From RTOF    Alt Fare 3
    Get Alternate Fare Details    Alt Fare 3    APAC
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 3
    Select Alternate Fare Class Code    Alt Fare 3    FD - First Class Discounted Fare
    Select Form Of Payment On Fare Quote Tab    Alt Fare 3    Cash
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Finish PNR
    Retrieve PNR Details from Amadeus
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 2
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 3

[AB IN] Verify That Alternate Fare Values Are Retained And Applicable Remarks Are Written
    [Tags]    in    us973    us972    us296    team_c    not_ready
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Book Flight X Months From Now    DXBBLR/AUK    SS1Y1    FXP/S2-3    6    5
    Book Amadeus Offer Retain Flight    S2-3    7
    Book Amadeus Offer Retain Flight    S2-3    2
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Air Fare
    Click Panel    Air Fare
    Click Fare Tab    Fare 1
    Populate Air Fare Panel Using Default Values For APAC
    Click Fare Tab    Alt Fare 3
    Get Alternate Fare Details    Alt Fare 3
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 3    Alt Fare 1
    Click Fare Tab    Alt Fare 4
    Get Alternate Fare Details    Alt Fare 4
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 4    Alt Fare 2
    Click Fare Tab    Alt Fare 5
    Get Alternate Fare Details    Alt Fare 5
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 5    Alt Fare 3
    Click Fare Tab    Alt Fare 1
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 1
    Get Offer From RTOF    Alt Fare 1
    Get Alternate Fare Details    Alt Fare 1    APAC
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 1
    Select Alternate Fare Class Code    Alt Fare 1    YF - Economy Class Full Fare
    Select Form Of Payment On Fare Quote Tab    Alt Fare 1    Cash
    Click Fare Tab    Alt Fare 2
    Get Alternate Base Fare, Total Taxes And Fare Basis    Alt Fare 2
    Get Offer From RTOF    Alt Fare 2
    Get Alternate Fare Details    Alt Fare 2    APAC
    Verify Offer Details Are Displayed On Alternate Fare Tab    Alt Fare 2
    Select Alternate Fare Class Code    Alt Fare 2    YW - Economy Class CWT Negotiated Fare
    Select Form Of Payment On Fare Quote Tab    Alt Fare 2    Cash
    Click Finish PNR
    Execute Simultaneous Change Handling    Amend Booking For Verify That Alternate Fare Values Are Retained And Applicable Remarks Are Written [IN]
    Retrieve PNR Details from Amadeus
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 1
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 2
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 3
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 4
    Verify Alternate Fare Itinerary Remarks Are Written    Alt Fare 5
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}
