# -*- coding: utf-8 -*-
from pywinauto.findwindows import ElementNotFoundError
from pywinauto.findbestmatch import MatchError
from pywinauto.application import Application
from robot.libraries.BuiltIn import BuiltIn
from robot.api import logger

class RailLibrary():

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def _connect_to_sabre_instance(self):
        app = Application().Connect(path="mysabre.exe")
        swtwindow = app.SWT_Window0
        swtwindow.Wait('ready', 60, 1)
        swtwindow.SetFocus()
        return swtwindow

    def _connect_to_sabre_uia(self):
        app = Application(backend="uia").connect(path="mysabre.exe")
        sabre_window = app.window(class_name='SWT_Window0', top_level_only=True)
        # sabre_window = app[u'Sabre Travel Network']
        sabre_window.wait('ready')
        # sabre_window.set_focus()
        return sabre_window

    def retrieve_sabre_rail_pnr(self, rail_pnr):
        sabre_instance = self._connect_to_sabre_uia()
        edit_field = sabre_instance.child_window(auto_id="pnrLocator", control_type="Edit")
        edit_field.set_focus()
        edit_field.set_text("")
        edit_field.set_text(rail_pnr)

    def set_value_in_rail_edit_field(self, text_field, value, instance='', backend='win32'):
        if backend == 'uia':
            sabre_instance = self._connect_to_sabre_uia()
            try:
                edit_field = sabre_instance.child_window(auto_id=text_field, control_type="Edit")
            except ElementNotFoundError:
                BuiltIn().fail("Element or field '{}' was not found".format(text_field))
                edit_field.set_focus()
                edit_field.set_text(value)
            except MatchError:
                BuiltIn().fail("Match Error '{}' was not found".format(text_field))
        else:
            control_field = [u''.join(text_field) + "Edit" + str(instance)]
            sabre_instance = self._connect_to_sabre_instance()
            try:
                sabre_instance[control_field].set_text(value)
            except MatchError:
                BuiltIn().fail("Match Error: field '{}' was not found".format(text_field))

    def get_sabre_rail_checkbox_state(self, field_name):       
        checkbox_field = [u''.join(field_name) + 'CheckBox']
        sabre_instance = self._connect_to_sabre_instance()
        return sabre_instance[checkbox_field].GetCheckState()

    def select_checkbox_state(self, field_name, checkbox_status):
        checkbox_field = [u''.join(field_name) + 'CheckBox']
        sabre_instance = self._connect_to_sabre_instance()
        try:
            checkbox_state = sabre_instance[checkbox_field].GetCheckState()
        except MatchError:
            BuiltIn().fail("Match Error: field '{}' was not found".format(field_name))
        if checkbox_status == "Enable" and checkbox_state == 0:
            sabre_instance[checkbox_field].CheckByClickInput()
        elif checkbox_status == "Enable" and checkbox_state == 1:
            logger.info("Checkbox {} is already enabled".format(field_name))
        elif checkbox_status == "Disable" and checkbox_state == 1:
            sabre_instance[checkbox_field].UncheckByClickInput()
        elif checkbox_status == "Disable" and checkbox_state == 0:
            logger.info("Checkbox {} is already disabled".format(field_name))

    def click_sabre_uia_object(self, control_title, control_type_object):
        sabre_window = self._connect_to_sabre_uia()
        control_title = u''.join(control_title)
        control_type_object = u''.join(control_type_object)
        sabre_field = sabre_window.child_window(title=control_title, control_type=control_type_object)
        try:
            sabre_field.click_input()
        except ElementNotFoundError:
            BuiltIn().fail("Timeout Error: field '{}' was not found".format(control_title))

    def get_sncf_pnr_locator(self):
        sabre_window = self._connect_to_sabre_uia()
        sabre_rail_pnr = sabre_window.child_window(title_re="PNR: *", control_type="TabItem").texts()
        return u''.join(sabre_rail_pnr)[5:]

    def does_rail_text_exists(self, control_title):
        sabre_instance = self._connect_to_sabre_uia()
        control_field = sabre_instance.child_window(title=control_title, control_type='Text')
        return control_field.exists()

    def select_rail_radio_button(self, control_title):
        sabre_window = self._connect_to_sabre_uia()
        sabre_field = sabre_window.child_window(title=u''.join(control_title), control_type="RadioButton")
        sabre_field.select()