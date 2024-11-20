# -*- coding: utf8 -*-
"""
Common Variables
"""
import os
__author__  = "Sunny Postrado <sunny.postrado@carlsonwagonlit.com>"
__version__ = "1.1"
#
# General Variables
#
port = '8270'
run_remoteServer = 'C:\\robot\\StartSikuliRemoteServer.bat'
current_pnr = ''
eo_number_collection = []

# application checking variables
title_power_express = 'Power Express'
#
# GDS Search Availability & Pricing Variables
#

date_ob_1 = '09FEB'
date_ib_1 = '12FEB'
date_ob_2 = '14FEB'
date_ib_2 = '16FEB'
date_ob_3 = '18FEB'
date_ib_3 = '20FEB'
date_ob_4 = '22FEB'
date_ib_4 = '24FEB'
date_ob_5 = '26FEB'
date_ib_5 = '28FEB'
date_ob_6 = '30FEB'
date_ib_6 = '02FEB'
date_ob_7 = '01FEB'
date_ob_8 = '09NOV'
date_ob_9 = '14DEC'
date_ib_9 = '18DEC'
date_ob_10 = '22DEC'
churning_airlines_sabre = '¥*DLBASQCX'
churning_airlines_galileo = '/DL-/BA-/SQ-/CX-'
churning_airlines_amadeus = '/A-BA,DL,CX,SQ'
churning_airlines_apollo = '-BA.DL.SQ'
new_ticketing_date = '7/1/2016'
#
# GDS Search Availability & Pricing Variables
#

similarity = '0.80'
timeout = '3'
user_selection_window = '[NAME:gbSystemUserSelection]'
end_pnr_window = '[NAME:grpEndPNRResults]'
enter_booking_locator = '[NAME:ctxtBookingLocator]'
edit_Locator = '[NAME:ctxtLocator]'
btn_Searchpnr = '[NAME:btnSearchPNR]'
btn_GDScommand = '[NAME:btnNativeEntry]'
cbo_gdscommandline = '[NAME:cboNativeEntry]'
btn_newBooking = '[NAME:btnSendPNR]'
btn_sendtoPNR = '[NAME:btnSendPNR]'
btn_readBooking = '[NAME:btnLoadPNR]'
btn_Create_Shell_PNR = '[NAME:btnShell]'
btn_clearAll = '[NAME:btnClear]'
btn_cancelBooking = '[NAME:btnCancelPNR]'
btn_sendItin = '[NAME:btnSendItinerary]'
btn_amendBooking = '[NAME:btnAmendPNR]'
status_strip = '[NAME:StatusStrip]'
edit_PCC_Officeid = '[NAME:ctxtPCCOfficeID]'
function_wError_list = ''
failed_function_name = ''
no_of_failed_verifications = '0'
advertisement_obj = '[CLASS:Internet Explorer_Server; INSTANCE:1]'
process_Name = 'PowerExpress.exe'

#
# ---Login Function Related Variables---
#
# environment = 'test'
title_settings = 'System User Settings'
text_User = '[NAME:txtUser]'
cbo_locale = '[NAME:cboLocale]'
btn_OKSettings = '[NAME:btnOK]'
btn_CancelSettings = '[NAME:btnCancel]'
list_UserProfile = '[NAME:lbSystemUserList]'
btn_OKUserProfile = '[NAME:OKButton]'
title_incomplete_contacts = 'Incomplete Contacts?'
btn_incomplete_contacts = '[NAME:NoBtn]'
disable_portrait_search = '[NAME:chkDisablePortraitSearch]'
title_Express = 'Power Express'
btn_Express = '[NAME:YesBtn]'
btn_Express_No = '[NAME:NoBtn]'
chklist_TeamSelection = '[NAME:chklistTeam]'
btn_TeamSelection = '[NAME:btnOK]'
title_active_window = '[ACTIVE]'
chk_SelectUnSelect_Team = '[NAME:cchkSelectUnselect]'
chk_DisablePortraitSearch = '[NAME:chkDisablePortraitSearch]'
cbo_CompanyProfile = '[NAME:ccboCompanyProfile]'
# ---Login Function Related Variables---
#

#
# ---Clear All Function Related Variables---
#
title_newContact = 'New Contact'
title_newContact_fr = 'Nouveau contact...'
primaryReason = 'Test/training'
location_counselor = 'Emergency Service Center - 40017'
explorer_server = '[CLASS:Internet Explorer_Server; INSTANCE:1]'
title_clearAll = 'Clear All'
title_contact_creation_error = 'Contact Creation Error'
title_clearAll_fr = 'Tout effacer'
title_clearAll_de = 'Neu starten'
btn_clearAllbox = '[NAME:btnOKButton]'
title_errorPopup = 'Fehler beim Speichern des Bestellers'
btn_errorPopup = '[NAME:OKBtn]'
radbtn_ClearAll = '[NAME:ClearAllRadioButton]'
radbtn_NewBookingSameTraveler = '[NAME:NewPNRSameTravellerRadioButton]'
radbtn_NewBookingSameContact = '[NAME:NewPNRSameContactRadioButton]'
radbtn_NewBookingNewTraveller = '[NAME:SameBookingNewTravellerRadioButton]'
msg_clearAll = '[NAME:ClearAllMessage]'
msg_clearAll_Question = '[NAME:ClearMessageQuestion]'
clearAll_OptionBox = '[NAME:OptionGroupBox]'

# ---Clear All Function Related Variables---
#

#
# ---Client & Traveller Variables---
#
quick_amend_spiel = '[NAME:lblQuickAmend]'
btn_quick_amend = '[NAME:btnQuickAmend]'
lbl_quickAmend = '[NAME:lblQuickAmend]'
edit_Client = 'Edit2'

btn_searchProfile1 = '[NAME:btnPortraitSearchTravellerProfile1]'
title_profile_remarks = 'Profile Remarks'
btn_profile_remarks = '[NAME:btnClose]'
edit_external_id = '[NAME:ctxtExtSysId]'
frm_g_Profile_Grid = '[NAME:gProfileGrid]'
btn_addTraveler = '[NAME:btnNewGDS]'
edit_emailprior = '[NAME:ctxtEmployeeIdentifier]'
btn_searchProfile = '[NAME:btnPortraitSearchTravellerProfile]'
edit_profile = '[NAME:txtcTravellerProfile]'
btn_profile = '[NAME:btnPortraitSearchTravellerProfile]'
btn_viaMoxie = '[NAME:btnSearchEmail]'
edit_portraitPin = '[NAME:ctxtPortraitPIN]'
btn_NoReviewDuplicates = '[NAME:CancelBtn]'
chk_my_sub_unit = '[NAME:cchkMySubUnit]'
lbl_Ext_Sys_Id = '[NAME:lblExtSysId]'

edit_booking_locator = '[NAME:ctxtBookingLocator]'
btn_booking_locator = '[NAME:btnSearchLocator]'

# ---Client & Traveller  Variables---
#

# ---Duplicate Name Variables---
#
title_duplicate = 'Duplicate Name Found'
icon_box = '[NAME:IconBox]'

# ---Profile Selection Variables---
#
checkbox_prof_select = '[NAME:ChkProfile]'

#
# ---GDS Variables---
#

toolstrip = '[NAME:toolStripCRS]'

#
#Sabre
#
Sabre_Red = 'C:\\Users\\Administrator\\AppData\\Local\\Sabre Red Workspace\\Profiles\\U5ZH_1049\\mysabre.exe'
sabre_agentid = '1049'
Sabre_Password = '3ahyeah'
sabre_pcc = 'U5ZH'
default_Sabre_pcc = '3W7F'
title_SabreRed = 'Sabre® Red™ Workspace - Sabre Travel Network'
edit_SabreAgentid = 'Edit1'
edit_SabrePassword = 'Edit2'
edit_SabrePcc = 'Edit5'
btn_SabreOk = 'Button2'
title_sabre_confirm_exit = 'Confirm Exit'
btn_sabre_confirm_exit_yes = '[CLASS:Button; INSTANCE:1]'
sabre_res_cert = 'RES'
GDS_Main =      '[CLASS:SunAwtCanvas]'
Sabre_CommandLine =   '[CLASS:Edit;INSTANCE:5]'
MoveDown =       'MD'
title_Err_BeforeSI_Sabre = 'An error has occured'
btn_SabreOK_Err = '[CLASS:SWT_Window0; INSTANCE:5]'

#Galileo
title_FrontPage = 'Front Page News'
cnclbtn_startGalileo = '[CLASS:Button; INSTANCE:2]'
path_galileo_desktop = 'C:\\FP\\SWDIR\\viewpoint.exe'
edit_GalileoUserId = 'Edit1'
Title_Galileo_Logon = 'Logon'
Title_Galileo_SignOn = 'Sign On'
edit_Galileo_User = 'Edit1'
edit_Galileo_Password = 'Edit2'
edit_Galileo_Emulate_PCC = 'Edit1'
Title_Galileo_Emulate = 'Emulate'
img_Travel_Port = '[CLASS:ToolbarWindow32; INSTANCE:2]'
title_galileo_desktop = 'Galileo Desktop'
title_smartpoint = 'Window 1'
btn_startGalileo = '[CLASS:Button; INSTANCE:1]'
galileo_text_control = 'HwndWrapper[Travelport.Smartpoint.App.exe;;f213a6b0-f459-44e1-9b5e-795c51897605]'
title_logoffPopupGalileo = 'Galileo Viewpoint'
btn_logoffPopupGalileo = '[CLASS:Button; INSTANCE:1]'
title_tcp_ip = 'Host/Galileo Desktop TCP/IP Configuration'
btn_tcp_ip = '[CLASS:Button; INSTANCE:1]'
title_booking_updated = 'Booking File Was Updated'
btn_OK_booking_updated = '[CLASS:Button; INSTANCE:1]'

#Apollo
btn_startGalileo = 'Button1'
title_galileoUpdatedWin = 'Updated data may be available'
btn_galileoUpdatedWin = 'Button2'
title_galileoDesktop = 'Galileo Desktop'
edit_Galileo_User = 'Edit1'
edit_Galileo_Password = 'Edit2'
img_Travel_Port = '[CLASS:ToolbarWindow32; INSTANCE:2]'
edit_Galileo_Emulate_PCC = 'Edit1'
title_Galileo_Emulate = 'Emulate'
title_Galileo_Logon = 'Logon'
title_Galileo_SignOn = 'Sign On'
Gal_Text =      'HwndWrapper[Travelport.Smartpoint.App.exe;;f213a6b0-f459-44e1-9b5e-795c51897605]'
title_tcp_ip = 'Host/Galileo Desktop TCP/IP Configuration'
btn_tcp_ip = '[CLASS:Button; INSTANCE:1]'
title_pnr_was_updated = 'PNR Was Updated'
btn_pnr_was_updated = '[CLASS:Button; INSTANCE:1]'

#Amadeus
Launch_Selling_Platform = 'xpath=//*[@id="goMainProductButton"]/li[1]/a'
Path_Amadeus_Desktop = 'C:\\Program Files (86)\\Internet Explorer\\iexplore.exe'
IE_Amadeus_Vistaa = 'http://amadeusvista.com/'
title_Amadeus_Main = 'Selling Platform - Sign-in window -- Webpage Dialog'
title_Amadeus_Selling_Platform = 'SELLING PLATFORM'
title_Amadeus_PopUp = 'Selling Platform messages -- Webpage Dialog'

# ---GDS Variables---
#

#
# ---Panel Variables---
cbo_touch_type = '[NAME:ccboTouchType]'
cbo_touch_reason = '[NAME:ccboTouchReason]'
cbo_touch_level = '[NAME:ccboTouchLevel]'
chk_touch_reason_notes = '[NAME:cchkTouchReasonNotes]'


# ---Panel Variables---
#

#
# ---Add New Traveller Variables---
#
title_addnewtraveller = 'Add New Traveller'
title_addnewtraveller_amadeus = 'Ajouter une nouveau voyageur'
title_addnewtraveller_amadeus_de = 'Neuen Reisenden hinzufügen'
title_client_account_selection = 'Client Account Selection'
cbo_add_client_sub = '[NAME:ccboClientSub]'
cbo_add_traveller_type = '[NAME:ccboTravellerType]'
cbo_usage = '[NAME:ccboUsage]'
edit_add_firstname = '[NAME:ctxtFirstName]'
edit_add_lastname = '[NAME:ctxtLastName]'
edit_add_emailaddress = '[NAME:ctxtEmail]'
edit_add_phone_country = '[NAME:ctxtCountryCode]'
edit_add_phone_area = '[NAME:ctxtAreaCode]'
edit_add_phone_number = '[NAME:ctxtPhoneNumber]'
chk_add_createNo = '[NAME:radCreateNo]'
edit_add_reason_skipping = '[NAME:ctxtReason]'
btn_add_finish = '[NAME:btnFinish]'
btn_cancel_add = '[NAME:btnCancel]'
add_traveller_error_msg = '[NAME:txtMessageTextBox]'
btn_add_traveller_errorpopup = '[NAME:OKBtn]'
Btn_Create_traveller_profile = '[NAME:btnNewPortrait]'
Verify_Create_new = '[NAME:grpCreateProfile]'
traveller_panel = '[NAME:grpCreateProfile]'
btn_new_gds_add_traveller = '[NAME:btnNewGDS]'
btn_new_gds_add_contact = '[NAME:btnAddContactGDS]'
edit_add_emailtype = '[NAME:ccboEmailType]'
edit_add_gender = '[NAME:pnlGender]'
chk_add_createYes = '[NAME:radCreateYes]'
edit_add_middlename = '[NAME:ctxtMiddleName]'
create_portrait_profile = '[NAME:lblCreatePortraitProfile]'
edit_add_phone_type = '[NAME:ccboPhoneType]'
edit_date_of_birth = '[NAME:mdtcDOB]'
btn_client_account_search = '[NAME:btnSearch]'
txt_client_account_advice_message = '[NAME:lblClientAccountSearchMessage]'
edt_client_account_search = '[NAME:txtClientAccountSearch]'
btn_client_account_selection = '[NAME:btnOK]'

# ------Add New Traveller Variables---
#

#
# ---One Time Contact Variables---
#
cbo_onetime_title = '[NAME:ccboTitle]'
edit_onetime_firstname = '[NAME:CtxtFirstName]'
edit_onetime_lastname = '[NAME:CtxtLastName]'
edit_onetime_phone_country = '[NAME:ctxtCountryCode]'
edit_onetime_phone_area = '[NAME:ctxtAreaCode]'
edit_onetime_phone_number = '[NAME:ctxtMPhoneNumber]'
edit_onetime_Mphone_country = '[NAME:ctxtMCountryCode]'
edit_onetime_Mphone_area = '[NAME:ctxtMAreaCode]'
edit_onetime_Mphone_number = '[NAME:ctxtPhoneNumber]'

edit_onetime_emailaddress = '[NAME:CtxtEmail]'
cbo_onetime_clientaccount = '[NAME:ccboAccountNumber]'
cbo_onetime_trip_type = '[NAME:ccboTripType]'
btn_onetime_remove_caller = '[NAME:btnRemoveProfile]'
tab_onetime_caller = '[NAME:grpCaller]'
Btn_One_time_contact = '[NAME:btnAddContactPortrait]'
Btn_Create_traveller_profile = '[NAME:btnNewPortrait]'
edit_onetime_firstname_caller = '[NAME:ctxtFirstName]'
edit_onetime_lastname_caller = '[NAME:ctxtLastName]'
edit_onetime_emailaddress_caller = '[NAME:ctxtEmail]'

#
# ---Profile Remarks Variables---
#
tb_line_1 = '[NAME:tbLine1]'
tb_line_2 = '[NAME:tbLine2]'
tb_line_3 = '[NAME:tbLine3]'
tb_line_4 = '[NAME:tbLine4]'
tb_line_5 = '[NAME:tbLine5]'
tb_line_6 = '[NAME:tbLine6]'
 
#
# ---Booking Details Variables---
#
lbl_BookingDetails = '[NAME:grbAccount]'
lbl_ClientAccount = '[NAME:lblAccountNo]'
lbl_TripType = '[NAME:lblTripType]'
drpdown_TripType = '[NAME:ccboTripType]'

#
# ---Cust Refs tab Variables---
#
lbl_ClientAccountNumber = '[NAME:lblClientAccountNumber]'
edit_add_ClientAccountNumber = '[NAME:ctxtAccountNumber]'
lbl_ClientAccountName = '[NAME:lblClientAccountNameTitle]'
lbl_ClientAccountName2 = '[NAME:lblClientAccountName]'
lbl_ClientDefinedReferences = '[NAME:grpCDReferences]'
edit_PopUpValueSearch = '[NAME:_txtCdrValueSearch]'
#
# ---Client Info tab Variables---
#
lbl_FormOfPayment = '[NAME:gbFOPs]'
drpdwn_FormOfPayment = '[CLASS:Edit; INSTANCE:2]'
lbl_ClientTravelPolicy = '[NAME:grpPolicy]'
tabs_ClientTravelPolicy = '[NAME:tabClientInformation]'

#
# ---Complete tab Variables---
#
lbl_EndPNRResults = '[NAME:grpEndPNRResults]'
lbl_RecordLocator = '[NAME:lblRecordLocator]'
edt_RecordLocator = '[NAME:ctxtLocator]'

#
# ---Portrait Variables---
#
title_Portrait = 'Portrait'
Portrait_Web_Browser = '[NAME:profileWebBrowser]'
portrait_page = '[CLASS:Internet Explorer_Server; INSTANCE:1]'

# ---Portrait Variables---
#

#
# ---Unused Documents Variables---
#
tab_top_left_control = '[NAME:TopLeftTabControl]'
tab_unused_doc = '[NAME:UnusedDocumentPanel]'
btn_unused_adddoc = '[NAME:CreateDocButton]'
btn_unused_canceldoc = '[NAME:CancelAddButton]'
title_unused_adddoc = 'Add Travel Document'
cbo_unused_tickettype = '[NAME:TicketTypeComboBox]'
edit_unused_airlinecode = '[NAME:AirlineCodeText]'
edit_unused_ticketnumber = '[NAME:TicketNumberText]'
dp_unused_issuedate = '[NAME:IssueDatePicker]'
dp_unused_expiredate = '[NAME:ExpDatePicker]'
edit_unused_valuetext = '[NAME:ValueText]'
cbo_unused_currency = '[NAME:CurrencyComboBox]'
edit_unused_pnrlocator = '[NAME:PNRLocatorText]'
dp_unused_traveldate = '[NAME:TravelDatePicker]'
edit_unused_from = '[NAME:FromText]'
edit_unused_to = '[NAME:ToText]'
edit_unused_IATA = '[NAME:BookingIATAText]'
edit_unused_pcc = '[NAME:IssuingPCCText]'
edit_unused_remark = '[NAME:RemarkText]'
txt_document_tree = '[NAME:DocumentTree]'
btn_add_pnr = '[NAME:AddToPNRButton]'
btn_unused_save = '[NAME:SaveButton]'
add_document_error_msg = '[NAME:txtMessageTextBox]'
title_remark = 'View Document Remarks...'
object_name = 'New Status'
btn_view_remarks = '[NAME:ViewRemarksButton]'
btn_view_remarks_close = '[NAME:CloseButton]'
drpdown_unused_status_code = '[NAME:StatusCodecomboBox]'
btn_status_set = '[NAME:StatusSetButton]'
# ---Unused Documents Variables---
#

#
# ---Existing Bookings Variables---
#
edit_traveller_name = '[NAME:ctxtTravellerName]'
edit_pcc_office_id = '[NAME:ctxtPCCOfficeID]'
tab_existing_bookings = '[NAME:ExistingBookings]'
toplefttab_control = '[NAME:TopLeftTabControl]'

#
# ---New Bookings Variables---
#
lbl_profile_selection = '[NAME:lblGDSProfileMessage]'

#
# ---Profile Selection---
#
title_ProfileSelection = 'Profile Selection'
btn_OK_Search_Profile = '[NAME:btnOK]'

# ---CDR Panel pop-up---
#-For handling CDR panel pop-up when commencing new booking--
title_CDR_Panel = 'CDR Driving Account/FOP'
btn_CDR_Panel_Cancel = '[NAME:btnCancel]'
title_progress_info = 'Progress Information'
title_progress_info_fr = 'Information sur l\'avancement'
title_progress_info_de = 'Fortschrittsinformation'
title_progress_info_amadeus = 'Information sur l\'avancement'
edt_CDR_Panel_SAPCOMP = '[NAME:ctxtCDRValue3]'
edt_CDR_Panel_Account = '[NAME:cboAccount]'
edt_CDR_Panel_LOCALCOM = '[NAME:ctxtCDRValue6]'
edt_CDR_Panel_FOP = '[NAME:cboFOP]'
edt_CDR_Panel_LOCALCOS = '[NAME:ctxtCDRValue7]'
btn_CDR_Panel_OK = '[NAME:btnOK]'

#Language Variables
itin_toolstrip = '[NAME:ToolStrip]'
title_win_lang = 'Region and Language'
cbo_win_lang = '[CLASS:ComboBox; INSTANCE:1]'
btn_win_lang = '[CLASS:Button; INSTANCE:4]'

#Additional
title_moveprofile_popup = 'Move profile messages'
title_moveprofile_popup_amadeus = 'Déplacer les messages du profil' 
btn_moveprofile_popup = '[NAME:OKBtn]'
mock_gds_screen = '[NAME:txtCRS]'

#Cancel Booking
lbl_cancel_segments = '[NAME:grpSements]'
chk_receive_invoice_1 = '[NAME:chkInvoice1]'
chk_receive_invoice_2 = '[NAME:chkInvoice2]'

#Emulation GDS & PCC
title_Emulation_GDS_and_PCC = 'Emulation GDS & PCC '
cbo_select_gds_and_pcc = '[NAME:CcboPCC]'
btn_OK_Emulation_GDS = '[NAME:btnOK]'

#For handling new booking error in Amadeus DE
title_new_booking_err_amadeus_de = 'Profilübertragung Benachrichtigungen'

#Booking Summary
booking_summary = '[NAME:lvwSummary]'

#Sabre Rail
chk_rail_compliance = '[NAME:RailComplianceCheckBox]'
btn_sync_to_sabre_yes = '[CLASS:Button; INSTANCE:1]'
btn_sr_cancel_itinerary_yes = '[CLASS:Button; INSTANCE:2]'
btn_sr_ignore_pnr_yes = '[CLASS:Button; INSTANCE:1]'

#System User Settings
chk_disabled_contact_tracking = '[NAME:chkDisableContactTracking]'

##########
edit_sr_date_of_birth = '[CLASS:Edit; INSTANCE:16]'
edit_sr_email_address = '[CLASS:Edit; INSTANCE:17]'
btn_sr_next = '[CLASS:SWT_Window0; INSTANCE:108]'
edit_sr_from = '[CLASS:Edit; INSTANCE:14]'
edit_sr_to = '[CLASS:Edit; INSTANCE:15]'
edit_sr_departure_date = '[CLASS:Edit; INSTANCE:16]'
edit_sr_class_of_service = '[CLASS:Edit; INSTANCE:35]'
edit_sr_fare_code = '[CLASS:Edit; INSTANCE:36]'
btn_sr_search = '[CLASS:SWT_Window0; INSTANCE:117]'
edit_pre_selection_1 = '[CLASS:Edit; INSTANCE:14]'
btn_sr_select = '[CLASS:SWT_Window0; INSTANCE:139]'
btn_sr_station_search_result_select = '[CLASS:SWT_Window0; INSTANCE:4]'


btn_sr_itinerary_next = '[CLASS:SWT_Window0; INSTANCE:98]'
btn_sr_seats_next = '[CLASS:SWT_Window0; INSTANCE:121]'
btn_sr_contact_info_next = '[CLASS:SWT_Window0; INSTANCE:101]'
btn_sr_book = '[CLASS:SWT_Window0; INSTANCE:141]'
#Panels
expected_panels = ['Cust Refs',
                   'Client Info',
                   'Policy Check',
                   'Air Fare',
                   'Rail',
                   'Pspt and Visa',
                   'APIS/SFPD',
                   'APIS / SFPD',
                   'Delivery',
                   'Client Fees',
                   'Recap',
                   'Réf Client',
                   'Livraison',
                   'Résumer',
                   'Amend',
                   'Complete',
                   'Cancel']

expected_fare_tabs = ['Fare 1',
                   'Fare 2',
                   'Fare 3',
                   'Fare 4',
                   'Fare 5',
                   'Fare 6',
                   'Alternate Fare 1',
                   'Alternate Fare 2',
                   'Alternate Fare 3']

expected_syex_main_tabs = ['GDS Screen',
                   'Unused Documents',
                   'Existing Bookings']

panel_portrait_profile_info = '[NAME:grpPortraitProfileInformation]'
#
#
# -------------------------------- End of file --------------------------------------------------------------- End of Amend Variables -------------------------
