*** Settings ***
Resource          ../../resources/common/global_resources.robot
Resource          ../../resources/common/core.robot

*** Keywords ***
Verify RMT Line Is Written
    [Arguments]    ${iata_code}    ${airline_code}    ${ticket_number}    ${amount}    ${traveller}    ${create_date}=${EMPTY}
    ${create_date}    Generate Date X Months From Now    0    0    %d%b%y
    ${create_date}    Convert To Uppercase    ${create_date}
    Verify Specific Line Is Written In The PNR X Times    RMT EXCH-${iata_code} ${airline_code}${ticket_number} ${create_date} ${amount} ${traveller}    1
