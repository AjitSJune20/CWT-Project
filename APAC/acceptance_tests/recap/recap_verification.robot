*** Settings ***
Resource          ../../resources/panels/recap.robot

*** Keywords ***
Add New Queue Minder Row
    [Arguments]    ${row_number}=1
    Click Panel    Recap
    ${row_number}=    Convert To Integer    ${row_number}
    ${row_number}    Evaluate    ${row_number}-1
    Click Control Button    [NAME:cmdAddQM${row_number}]
    [Teardown]    Take Screenshot

Click Add General Remark
    Click Control Button    [NAME:cmdAddGeneralRemark]
    [Teardown]    Take Screenshot

Click Add General Remark Button
    [Arguments]    ${row_number}=1
    ${row_number}    Evaluate    ${row_number}-1
    Click Control Button    [NAME:cmdAddGR${row_number}]
    [Teardown]    Take Screenshot

Create General Remark By Qualifier
    [Arguments]    ${user_qualifier_value}    ${row_number}    ${user_defined_remarks}
    &{qualifiers}    Create Dictionary    A=A - Air    C=C - Car    D=D - Delivery    E=E - ESC    F=F - Fares
    ...    G=G - General    H=H - Hotels    H=I - Invoicing    J=J - CWT Internal notes    L=L - Limos    M=M - On hold notes
    ...    N=N - GSC/LFC Info    O=O - Online tool notes    P=P - Pspt and Visa    Q=Q - Quality Control    R=R - Rail or Ferry    T=T - Traveller Info
    ...    U=U - Aqua    V=V - Arranger Info    X=X - Cancel or Refund    Y=Y - Team Info
    Log Dictionary    ${qualifiers}
    ${qualifier_value}    Get From Dictionary    ${qualifiers}    ${user_qualifier_value}
    Select Qualifier General Remark    ${qualifier_value}    ${row_number}
    Set General Remark Qualifier Text    ${user_defined_remarks}    ${row_number}
    [Teardown]    Take Screenshot
    [Return]    ${user_defined_remarks}

Populate Queue Minder
    [Arguments]    ${line}    ${is_tickbox}    ${no_of_day}    ${queue_pcc}    ${queue_number}    ${queue_category}
    ...    ${queue_message}=${EMPTY}
    Click Panel    Recap
    Run Keyword If    '${is_tickbox}' == '1'    Tick Queue Minder Checkbox    ${line}
    Run Keyword If    '${is_tickbox}' == '1'    Set Queue Minder Date X Day Ahead    ${no_of_day}    ${line}
    Run Keyword If    '${is_tickbox}' == '1'    Set Suite Variable    ${date_${line}}    ${queue_date}
    Set Queue Minder PCC    ${queue_pcc}    ${line}
    Set Queue Minder Number    ${queue_number}    ${line}
    Set Queue Minder Category    ${queue_category}    ${line}
    Set Queue Minder Message    ${queue_message}    ${line}
    [Teardown]    Take Screenshot

Set Queue Minder Date X Day Ahead
    [Arguments]    ${no_of_days}    ${line}
    ${queue_date} =    Add Days To Current Date In Syex Format    ${no_of_days}
    ${month} =    Fetch From Left    ${queue_date}    /
    ${year} =    Fetch From Right    ${queue_date}    /
    ${day} =    Fetch From Left    ${queue_date}    /${year}
    ${day} =    Fetch From Right    ${day}    /
    ${index} =    Evaluate    ${line}-1
    Click Control Button    [NAME:cdtpDate${index}]    ${title_power_express}
    Send    ${day}    1
    Send    {LEFT}
    Send    ${month}    1
    Send    {RIGHT}
    Send    {RIGHT}
    Send    ${year}    1
    Send    {TAB}
    Sleep    1
    Set Suite Variable    ${queue_date}    ${queue_date}
    [Teardown]    Take Screenshot

Tick Queue Minder Checkbox
    [Arguments]    ${line}
    ${index} =    Evaluate    ${line}-1
    Control Focus    ${title_power_express}    ${EMPTY}    [NAME:cdtpDate${index}]
    Send    ${SPACE}
    [Teardown]    Take Screenshot

Verify General Remarks Are Writen In PNR For Qualifier
    [Arguments]    ${user_qualifier_value}    ${user_defined_remarks}
    ${user_defined_remarks1}    Convert To Uppercase    ${user_defined_remarks}
    Verify Text Contains Expected Value X Times Only    ${pnr_details}    RM${user_qualifier_value} ${user_defined_remarks1}    1

Verify PCC And Team Name Remarks Are Written
    [Arguments]    ${pcc}    ${team_name}
    Verify Text Contains Expected Value X Times Only    ${pnr_details}    ${pcc}    1
    Verify Text Contains Expected Value X Times Only    ${pnr_details}    ${team_name}    1

Verify PCC And Team Name Values
    [Arguments]    ${pcc}    ${team_name}
    Verify Control Object Text Value Is Correct    ${edit_pcc}    ${pcc}
    Verify Control Object Text Value Is Correct    [NAME:ctxtTeamName]    ${team_name}

Verify Queue Minder In Recap Are Written
    [Arguments]    ${line}    ${pcc}    ${queue_number}    ${queue_category}    ${description}    ${occurence}=1
    ${date}    Convert Date To GDS Format    ${date_${line}}    %m/%d/%Y
    Verify Text Contains Expected Value X Times Only    ${pnr_details}    OP ${pcc}/${date}/${queue_number}C${queue_category}/${description}    ${occurence}    True
    [Teardown]

Verify Skip Entries Remark Is Not Written
    [Arguments]    ${skip_entries}
    ${skip_entries}    Convert To Uppercase    ${skip_entries}
    Verify Text Does Not Contain Value    ${pnr_details}    ${skip_entries}

Verify Skip Entries Remark Is Written
    [Arguments]    ${skip_entries}
    ${skip_entries}    Convert To Uppercase    ${skip_entries}
    Verify Text Contains Expected Value X Times Only    ${pnr_details}    ${skip_entries}    1
