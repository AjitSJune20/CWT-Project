*** Settings ***
Force Tags        policy_check
Library    ../../resources/libraries/SellcoLogin.py
Suite Setup    Run Keyword If    "${sellco_username}" != "${EMPTY}"    Login To Sellco    ${sellco_username}    ${sellco_password}

*** Variables ***
${sellco_username}    ${EMPTY}
${sellco_password}    ${EMPTY}