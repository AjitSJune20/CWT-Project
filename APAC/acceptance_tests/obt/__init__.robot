*** Settings ***
Suite Setup       Run Keyword If    "${sellco_username}" != "${EMPTY}"    Login To Sellco    ${sellco_username}    ${sellco_password}
Force Tags        obt
Library           ../../resources/libraries/SellcoLogin.py

*** Variables ***
${sellco_username}    ${EMPTY}
${sellco_password}    ${EMPTY}
