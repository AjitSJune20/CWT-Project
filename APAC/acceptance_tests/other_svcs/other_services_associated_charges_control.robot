*** Settings ***
Resource          ../../resources/common/global_resources.robot

*** Keywords ***
Get Associated Charges Field Values
    [Arguments]    ${identifier}
    Get Cost Amount In Associated Charges
    Get Commission In Associated Charges
    Get Discount In Associated Charges
    Get Gross Sell In Associated Charges
    Get VAT/GST Amount In Associated Charges
    Get Merchant Fee In Associated Charges
    Get Total Selling Price In Associated Charges
    Get Description In Associated Charges
    Get CWT Reference No (TK) In Associated Charges
    Get Vendor Reference No (GSA) In Associated Charges
    Get Other Related No (PO) In Associated Charges
    Get Form Of Payment Type In Associated Charges

Click Save
    ${save_object}    Determine Multiple Object Name Based On Active Tab    SaveButton,AssociatedCharges_SaveButton    False
    Click Control Button    ${save_object}
    ${object}    Determine Multiple Object Name Based On Active Tab    TrainTripsGrid,OtherServicesTrainGridControl,AssociatedCharges_AssociatedInfoGrid    False
    Wait Until Control Object Is Visible    ${object}
    [Teardown]    Take Screenshot

Click Add
    ${is_add_visible}    Determine Control Object Is Visible On Active Tab    AddButton, AssociatedCharges_AddButton    False
    ${add_button}    Run Keyword If    ${is_add_visible}    Determine Multiple Object Name Based On Active Tab    AddButton,AssociatedCharges_AddButton,Charges_AddOrUpdateButton    False
    Run Keyword If    ${is_add_visible}    Click Control Button    ${add_button}
    ${object}    Determine Multiple Object Name Based On Active Tab    OtherServicesTrainControl,AssociatedCharges_OtherServicesProductVendorControl    False
    Wait Until Control Object Is Visible    ${object}
    [Teardown]    Take Screenshot

Verify Other Services Associated Charges Are Correct
    [Arguments]    @{assoc_charges}
    ${actual_assoc_charges}    Get All Values From Datagrid    [NAME:AssociatedCharges_AssociatedInfoGrid]
    Run Keyword And Continue On Failure    List Should Contain Sub List    ${actual_assoc_charges}    ${assoc_charges}
