# -*- coding: utf-8 -*-
from pywinauto.findwindows import ElementNotFoundError
from pywinauto.application import Application
from pywinauto import Desktop
from robot.libraries.BuiltIn import BuiltIn
from robot.api import logger
import pywinauto
import autoit

class TravelportLibrary:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def _connect_to_travelport(self):
        app = Desktop(backend='uia')
        # appwindow = app.window(title_re='Galileo Desktop -', class_name='FrameWndClass', found_index=0)
        appwindow = app.window(title_re='Galileo Desktop -', found_index=0)
        travelport_window = appwindow.window(title='Window 1', control_type="Window", found_index=0)
        travelport_window.wait('ready', 60, 3)
        travelport_window.set_focus()
        return travelport_window

    def activate_travelport_smart_window(self):
        pnrviewercontrol = self._connect_to_travelport()\
                        .window(auto_id="PnrViewerControl", control_type="Custom")
        pnrviewercontrol.wait('ready', 60, 1)
        pnrviewercontrol.set_focus()
        return pnrviewercontrol

    def activate_travelport_terminal_window(self):
        terminal_window = self._connect_to_travelport()\
                        .window(class_name="RichTextBox", control_type="Document", found_index=0)
        terminal_window.wait('ready', 30, 1)
        terminal_window.set_focus()
        return terminal_window

    def click_travelport_smart_button(self, button_name):
        """ 
        Description:
        Clicks Travelport Smart button such as "*ALL", "*FOP", "*NP"
        
        Usage:
        | Click Travelport Smart Button | *FOP |
        """
        allbutton = self.activate_travelport_smart_window()\
                    .child_window(title=button_name, control_type="Button", found_index=0) 
        allbutton.set_focus()
        allbutton.click()

    def send_travelport_command(self, gds_command):
        logger.info("Sending command '{}'".format(gds_command))
        app = self._connect_to_travelport()
        terminal_window = app.window(class_name="RichTextBox", control_type="Document", found_index=0)
        terminal_window.wait('ready', 30, 1)
        terminal_window.set_focus()
        autoit.send(gds_command)
        autoit.send("{ENTER}")
        self.wait_until_smartpoint_terminal_is_refreshed()

    def wait_until_smartpoint_terminal_is_refreshed(self):
        app = self._connect_to_travelport()
        #ready_label = app.child_window(title="ready", auto_id="ReadyLabel", control_type="Text")       
        ready_label = app.child_window(title="ready", found_index=0)
        ready_label.wait('ready', 30, 1)

    def click_travelport_popup_ok_button(self):
        """
            To be updated...
        """
        control_popup = self._connect_to_travelport_popup_windows()
        try:
            control_popup.child_window(auto_id="PART_OKButton", control_type="Button").click()
        except pywinauto.findwindows.ElementNotFoundError:
            pass        

    def get_travelport_smart_window_details(self, command="*ALL"):
        """ 
        Description:
        Get details from clicking button from smart window such as "*ALL", "*FOP", "*NP". 
        By default, command used is *ALL
        
        Usage:
        | Get Travelport Smart Window Details | *FOP |
        | Get Travelport Smart Window Details |      |
        """
        self.click_travelport_smart_button(command)
        smart_window = self.activate_travelport_smart_window()
        data =  u''.join(smart_window.child_window\
            (auto_id="PART_PNRContainer", control_type="Document").texts())
        return data.strip()

    # def get_travelport_terminal_window_details(self):
    #     terminal_window = self.activate_travelport_terminal_window()
    #     return u''.join(terminal_window.texts()).strip()

    def _connect_to_travelport_popup_windows(self):
        app = Desktop(backend='uia')
        appwindow = app.window(title_re='Galileo Desktop -')
        travelport_popup_app = appwindow.window(class_name='Window', control_type='Window', found_index=0)
        return travelport_popup_app

    def _create_rapid_reprice_app_instance(self):
        app = Desktop(backend='uia')
        # rapid_reprice_app = app.window(title="Rapid Reprice Exchange", class_name="RAPID_REPRICE_APP")
        # rapid_reprice_app = app.window(class_name="RAPID_REPRICE_APP")
        rapid_reprice_app = app.window(control_type="Window")
        
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()
        return rapid_reprice_app

    def select_rapid_reprice_option(self, pricing_option, window_title, final_action="Continue"):  
        print "Wait until window title is '{}'".format(window_title)
        app = Desktop(backend='uia')
        # rapid_reprice_app = app.window(title=str_title, class_name="RAPID_REPRICE_APP")
        rapid_reprice_app = app.window(title=window_title)
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()

        print "Select '{}' radio button".format(pricing_option)
        pricing_option_dict = {
            "price as best buy in same cabin"   : "1000", 
            "price as booked"                   : "1001", 
            "price with no penalty"             : "1002"
        }
        # rapid_reprice_window    = self._create_rapid_reprice_app_instance()
        rapid_reprice_window    = rapid_reprice_app
        pricing_option          = pricing_option.lower()    
        pricing_option          = pricing_option_dict.get(pricing_option, "1000")

        try:
            rad_price_option = rapid_reprice_window.child_window(auto_id=pricing_option, control_type="RadioButton")
        except pywinauto.findwindows.ElementNotFoundError:
            BuiltIn().fail("'{}'".format(pricing_option))
        
        rad_price_option.set_focus()
        rad_price_option.click_input()

        if final_action == "Continue":
            print "Final action is '{}' hence this button will be clicked".format(final_action)
            final_action = final_action.upper()           

            try:
                button = rapid_reprice_window.child_window(title=final_action, control_type="Button")
            except pywinauto.findwindows.ElementNotFoundError:
                BuiltIn().fail("Invalid button name/label '{}'".format(final_action))
            
            button.set_focus()
            button.click()
            
    def click_rapid_reprice_button(self, button_label, window_title):
        print "Wait until window title is '{}'".format(window_title)
        app = Desktop(backend='uia')        
        rapid_reprice_app = app.window(title=window_title)
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()     

        print "Click '{}' button".format(button_label)        
        try:
            button = rapid_reprice_app.child_window(title=button_label, control_type="Button")
        except pywinauto.findwindows.ElementNotFoundError:
            BuiltIn().fail("Invalid button name/label '{}'".format(button_label))
        
        button.set_focus()        
        button.click()

    def wait_until_rapid_reprice_window_title_is(self, str_title):
        print "Wait until window title is '{}'".format(str_title)
        app = Desktop(backend='uia')
        # rapid_reprice_app = app.window(title=str_title, class_name="RAPID_REPRICE_APP")
        rapid_reprice_app = app.window(title=str_title)
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()
        # return rapid_reprice_app

    def enter_text_in_rapid_reprice_received_from(self, str_value, window_title, final_action="Continue"):
        print "Wait until window title is '{}'".format(window_title)
        app = Desktop(backend='uia')
        # rapid_reprice_app = app.window(title=str_title, class_name="RAPID_REPRICE_APP")
        rapid_reprice_app = app.window(title=window_title)
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()

        print "Enter '{}' in Recieved From field".format(str_value)
        rapid_reprice_window = rapid_reprice_app
        rapid_reprice_window.set_focus()
        txt_target_text_box = rapid_reprice_window.child_window(auto_id="1161", control_type="Edit")
        txt_target_text_box.draw_outline()
        txt_target_text_box.set_focus()
        txt_target_text_box.type_keys(str_value)

        if final_action == "Continue":
            print "Final action is '{}' hence this button will be clicked".format(final_action)
            final_action = final_action.upper()           

            try:
                button = rapid_reprice_window.child_window(title=final_action, control_type="Button")
            except pywinauto.findwindows.ElementNotFoundError:
                BuiltIn().fail("Invalid button name/label '{}'".format(final_action))
            
            button.set_focus()
            button.click()

    def click_travelport_menu_item(self, menu_item, menu_sub_item):
        print "Accessing Travelport menu"
        main_menu_dict = {
            "application"   : "Application", 
            "terminal"      : "Terminal", 
            "history"       : "History", 
            "window"        : "Window", 
            "pnr"           : "PNR",    
            "tools"         : "TOOLS",      
            "help"          : "Help"        
        }
        menu_item = menu_item.lower()
        menu_item = main_menu_dict.get(menu_item, "TOOLS")

        travelport_window = self._connect_to_travelport() 
        # travelport_window.print_control_identifiers()
        try:
            main_menu_item = travelport_window.child_window(title=menu_item, control_type="MenuItem") 
        except pywinauto.findwindows.ElementNotFoundError:
            BuiltIn().fail("Invalid menu item '{}'".format(menu_item))
        
        main_menu_item.set_focus()    
        main_menu_item.click_input()    

        try:
            sub_menu_item = main_menu_item.child_window(title=menu_sub_item, control_type="MenuItem")
        except pywinauto.findwindows.ElementNotFoundError:
            BuiltIn().fail("Invalid sub-menu item '{}'".format(menu_sub_item))

        sub_menu_item.set_focus()     
        sub_menu_item.click_input()
    
    def _is_rapid_reprice_dlg_exist(self, dlg_title):    
        rapid_reprice_window = self._create_rapid_reprice_app_instance()
        
        try:
            rapid_reprice_dlg = rapid_reprice_window.child_window(title=dlg_title, control_type="Window") 
        except pywinauto.findwindows.ElementNotFoundError:
             BuiltIn().fail("Dialog box is not visible")
        
        return rapid_reprice_dlg        

    def wait_until_rapid_reprice_dialog_box_exist(self, str_title):
        print "Wait until '{}' dialog box exist".format(str_title)
        dialog = self._is_rapid_reprice_dlg_exist(str_title)
        dialog.wait('visible', 60, 1)

    def select_item_from_rapid_reprice_combobox(self, combobox_label, item_value, window_title):
        print "Select '{}' item from {} combobox.".format(item_value, combobox_label)
        app = Desktop(backend='uia')
        rapid_reprice_instance = Application().Connect(path='RapidReprice1G.exe')
        rapid_reprice_app = rapid_reprice_instance.window(title_re=window_title) 
        rapid_reprice_app.wait('visible', 60, 1)
        rapid_reprice_app.set_focus()  

        try: 
            target_control = rapid_reprice_app[u''.join(combobox_label)+':ComboBox']
        except pywinauto.findbestmatch.MatchError: 
            BuiltIn().fail("{} combobox is not found in {}.".format(combobox_label, window_title))
        
        target_control.set_focus()

        try: 
            target_control.Select(item_value)
        except ValueError:
            BuiltIn().fail("'{}' is not a list item in '{}' combobox.".format(item_value, combobox_label))