*** Settings ***
Library           DateTime
Library           DatabaseLibrary
Library           String
Library           OperatingSystem
Library           Collections
Library           ../libraries/SyexUiaLibrary.py
Library           ../libraries/SyexCustomLibrary.py
Library           ../libraries/SyexDateTimeLibrary.py
Library           ScreenCapLibrary    screenshot_directory=${OUTPUTDIR}
Library           AutoItLibrary
Library           ExcelLibrary

*** Variables ***
${public_documents_path}    C:\\Users\\Public\\Documents
${is_new_booking_worflow}    ${False}
${use_mock_env}    False
${syex_env}       Test
${use_local_dev_build}    False

*** Keywords ***
