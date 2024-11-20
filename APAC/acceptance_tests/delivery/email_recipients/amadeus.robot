*** Settings ***
Resource          ../delivery_verification.robot
Resource          ../../../resources/panels/air_fare.robot
Test TearDown    Take Screenshot On Failure

*** Test Cases ***
[NB IN] Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
    [Tags]    us302    team_c    US992    US433    in    howan
    ...    DE663    us2101
    Open Power Express And Retrieve Profile    ${version}    Test    u003axo    en-GB    aobsum    APAC QA
    ...    Amadeus
    Set Client And Traveler    XYZ Company PV2 ¦ AUTOMATION IN - US992    BEAR    INNINENINETWO
    Verify The E-Mail Address On Contact Tab    Traveller/Contact    fcatacutan@carlsonwagonlit.com
    Click New Booking
    Update PNR With Default Values
    Book Flight X Months From Now    SINMNL/APR    SS1Y1    FXP    6
    Click Read Booking
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify Email Address Details In Choose/Add Recipients    0    fcatacutan@carlsonwagonlit.com    True    True
    Verify Email Address Details In Choose/Add Recipients    1    mehola.teodoro@cwt.com    True    False
    Verify Email Address Details In Choose/Add Recipients    2    mteodoro1231321312312312323123123122323123123123131231232123312@cwt.com    True    True
    Select Delivery Method    E-Ticket
    Click Finish PNR
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MTEODORO123132131231231232312312312232 3123123123131231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *EMAIL/FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Not Written In The PNR    RM *EMAIL/MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RM *EMAIL/MTEODORO123132131231231232312312312232312312312313 1231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RMZ AUTOMAIL-NO

[AB IN] Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
    [Tags]    us302    team_c    us992    in    howan    DE663
    ...    us2101
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify The E-Mail Address On Contact Tab    Traveller/Contact    fcatacutan@carlsonwagonlit.com
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify Email Address Details In Choose/Add Recipients    0    FCATACUTAN@CARLSONWAGONLIT.COM    True    True
    Verify Email Address Details In Choose/Add Recipients    1    MEHOLA.TEODORO@CWT.COM    True    False
    Verify Email Address Details In Choose/Add Recipients    2    MTEODORO1231321312312312323123123122323123123123131231232123312@CWT.COM    True    True
    Get Ticketing Date
    Select Delivery Method    E-Ticket
    Untick Do Not Send Itinerary Checkbox
    Click Finish PNR    Amend Booking For Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
    Execute Simultaneous Change Handling    Amend Booking For Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
    Retrieve PNR Details from Amadeus    ${current_pnr}
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MTEODORO123132131231231232312312312232 3123123123131231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *EMAIL/FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Not Written In The PNR    RM *EMAIL/MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RM *EMAIL/MTEODORO123132131231231232312312312232312312312313 1231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RMZ AUTOMAIL-YES
    Retrieve PNR    ${current_pnr}
    Click Send Itinerary
    Click Panel    Delivery
    Verify Email Address Details In Choose/Add Recipients    0    FCATACUTAN@CARLSONWAGONLIT.COM    True    True
    Verify Email Address Details In Choose/Add Recipients    1    MEHOLA.TEODORO@CWT.COM    True    False
    Verify Email Address Details In Choose/Add Recipients    2    MTEODORO1231321312312312323123123122323123123123131231232123312@CWT.COM    True    True
    Verify Ticketing Date Field Value
    Click Finish PNR
    Retrieve PNR Details From Amadeus    ${current_pnr}
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RMZ CONF*SEND TO MAIL MTEODORO123132131231231232312312312232 3123123123131231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RM *EMAIL/FCATACUTAN@CARLSONWAGONLIT.COM
    Verify Specific Line Is Not Written In The PNR    RM *EMAIL/MEHOLA.TEODORO@CWT.COM
    Verify Specific Line Is Written In The PNR    RM *EMAIL/MTEODORO123132131231231232312312312232312312312313 1231232123312@CWT.COM    multi_line_search_flag=true
    Verify Specific Line Is Written In The PNR    RMZ AUTOMAIL-YES
    [Teardown]    Cancel PNR Thru GDS Native    ${current_pnr}

*** Keywords ***
Amend Booking For Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
    Retrieve PNR    ${current_pnr}
    Click Amend Booking
    Click Read Booking
    Verify The E-Mail Address On Contact Tab    Traveller/Contact    fcatacutan@carlsonwagonlit.com
    Populate All Panels (Except Given Panels If Any)    Delivery
    Click Panel    Delivery
    Verify Email Address Details In Choose/Add Recipients    0    FCATACUTAN@CARLSONWAGONLIT.COM    True    True
    Verify Email Address Details In Choose/Add Recipients    1    MEHOLA.TEODORO@CWT.COM    True    False
    Verify Email Address Details In Choose/Add Recipients    2    MTEODORO1231321312312312323123123122323123123123131231232123312@CWT.COM    True    True
    Get Ticketing Date
    Select Delivery Method    E-Ticket
    Untick Do Not Send Itinerary Checkbox
    Click Finish PNR    Amend Booking For Verify That E-Mail Addresses Are Pre-Populated From Both Portrait And GDS Profile For Traveller/Contact
