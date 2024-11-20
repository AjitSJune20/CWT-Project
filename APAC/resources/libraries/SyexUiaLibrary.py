# -*- coding: utf-8 -*-
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from pywinauto.findwindows import ElementNotFoundError
from pywinauto.application import Application
from pywinauto import Desktop
from pywinauto import keyboard
from robot.utils import unic
import uialibrary
import autoit
import re
import itertools
import win32gui
import win32api
import pywinauto
from time import sleep
from uialibrary import (Win32API, ControlFromCursor, Bitmap)

class SyexUiaLibrary:

	ROBOT_LIBRARY_SCOPE = 'Global'

	def __init__(self):
		self.uia = Desktop(backend='uia')
		self.builtin = BuiltIn()

	def connect_to_uia(self, auto_id=None, window=None):
		if auto_id is not None:
			return self.uia.window(auto_id=auto_id, control_type="Window", found_index=0)
		elif window is not None:
			return self.uia.window(title=window, control_type="Window", found_index=0)
		else:
			return False

	def connect_to_express_via_uia(self, auto_id=None):
		uia = self.connect_to_uia(auto_id="frmMain")
		uia.wait('ready', 60, 1)
		uia.set_focus()
		return uia

	def create_power_express_handle(self):
		autoit.win_activate('Power Express')
		try:
			syexuia = uialibrary.WindowControl(AutomationId='frmMain')
			syexuia.SetActive()
			# syexuia.SetTopmost()
			return syexuia
		except LookupError:
			self.builtin.fail("Cannot Find Power Express. '{}' is not visible".format('frmMain'))

	def _convert_control_id_to_uia_format(self, control_id):
		return re.sub(r"(\[.*:)|(\])", "", control_id)
			
	def select_gds_screen_tab(self):
		try:
			uialibrary.TabControl(AutomationId='TopLeftTabControl').TabItemControl(0).Click()
		except Exception:
			pass

	def select_tab_from_top_left(self, tab_name):
		uialibrary.TabControl(AutomationId='TopLeftTabControl').TabItemControl(RegexName=tab_name).Click()

	def get_checkbox_state(self, control_id):
		logger.info("Getting checkbox status of control '{}'".format(control_id))
		try:
			if not self._is_control_in_uia_format(control_id):
				checkbox_control = uialibrary.CheckBoxControl(RegexName=control_id)
			else:
				auto_id = self._convert_control_id_to_uia_format(control_id)
				checkbox_control = uialibrary.CheckBoxControl(AutomationId=auto_id)
			toggle_state = checkbox_control.CurrentToggleState()
		except LookupError:
			self.builtin.fail("Control '{}' is not visible".format(control_id))
		logger.info("Checkbox status is '{}'".format(toggle_state))
		return True if toggle_state == 1 else False

	def is_checkbox_enabled(self, control_id):
		logger.info("Checking if checkbox '{}' is enabled ".format(control_id))
		try:
			if not self._is_control_in_uia_format(control_id):
				checkbox_control = uialibrary.CheckBoxControl(RegexName=control_id)
			else:
				auto_id = self._convert_control_id_to_uia_format(control_id)
				checkbox_control = uialibrary.CheckBoxControl(AutomationId=auto_id)
			is_enabled = checkbox_control.IsEnabled
		except LookupError:
			self.builtin.fail("Control '{}' is not visible".format(control_id))
		return True if is_enabled == 1 else False			

	def set_control_text(self, control_id_or_name, text_value, use_control_name=False):
		""""
		Description: Use only if Set Control Text Value is not working

		| Set Control Text | [NAME:PassengerIDTextBox] | Text Value   |                       |
		| Set Control Text | Issue in Exchange For     | Sample Value | use_control_name=True |
		"""
		try:
			if use_control_name == "True":
				control_field = self.connect_to_express_via_uia().child_window(title_re=control_id_or_name)
			else:
				auto_id = self._convert_control_id_to_uia_format(control_id_or_name)
				control_field = self.connect_to_express_via_uia().child_window(auto_id=auto_id)
			control_field.set_focus()
			control_field.set_text(text_value)
		except Exception:
		    self.builtin.fail("Field with control id '{}' is not found".format(control_id_or_name))

	def get_dropdown_values(self, control_id):
		"""
		Gets all dropdown values. Returns values in List

		Example:
		| ${sdropdown_values} = | Get Dropdown Values | [NAME:ccboTouchLevel] |
		"""
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			combo_field = uialibrary.ComboBoxControl(AutomationId=control_field)
			combo_field.SetFocus()
			combo_field.ButtonControl().Click()
			sleep(1)
			combo_values = filter(lambda k: "Vertical" not in k, [item.Name for item in uialibrary\
				.ListControl(RegexClassName='Combo').GetChildren()])
			combo_field.SendKeys('{Esc}')
			# combo_field.ButtonControl().Click()
		except LookupError:
			self.builtin.fail("Control '{}' is not visible".format(control_id))
		return combo_values

	def select_dropdown_value(self, control_id, dropdown_value):
		"""
		Selects dropdown value

		Example:
		| Select Dropdown Value | [NAME:ccboTouchLevel] |
		"""
		control_id_uia = self._convert_control_id_to_uia_format(control_id)
		syex = self.create_power_express_handle()
		dropdown_value = unic(dropdown_value)
		try:
			combobox = uialibrary.ComboBoxControl(AutomationId=control_id_uia, searchFromControl=syex)
			combobox.SetFocus()
			combobox.ButtonControl().Click()
			list_control = uialibrary.ListControl(RegexClassName='Combo')
		except LookupError:
			self.builtin.fail("Control '{}'' is not present".format(control_id))
		try:
			list_item = uialibrary.ListItemControl(Name=dropdown_value, searchFromControl=list_control)
			list_item.ScrollIntoView()
			list_item.Click()
		except LookupError:
			combo_values = filter(lambda k: "Vertical" not in k, [item.Name for item in uialibrary\
				.ListControl(RegexClassName='Combo').GetChildren()])			
			self.builtin.fail("Value '{}' is not present in dropdown. \nDropdown values are: \n{}"\
				.format(dropdown_value, "\n".join(combo_values)))
		finally:
			combobox.SendKeys("{ESCAPE}")
		
	def select_radio_button_value(self, radio_button):
		"""
		Select radio button using title or label

		Example:
		| Select Radio Button | Air: Void and Re-Issue |
		"""
		try:
			if not self._is_control_in_uia_format(radio_button):
				uialibrary.RadioButtonControl(Name=radio_button).Click()
			else:
				radio_button = self._convert_control_id_to_uia_format(radio_button)
				uialibrary.RadioButtonControl(AutomationId=radio_button).Click()
		except LookupError:
			self.builtin.fail("Radio button '{}' is not visible".format(radio_button))

	def get_tooltip_text(self, xpos, ypos):
		"""
		Returns tooltip text.
		Use KW "Get Control Object Coordinates" as pre-requisite or explicitly indicate coordinates

		"""
		logger.info("Getting tooltip text")
		# self.create_power_express_handle()
		# Win32API.MouseMoveTo(int(xpos), int(ypos))
		# return control.ToolTipControl(searchWaitTime=2).Name
		uia = self.connect_to_express_via_uia()		
		pywinauto.mouse.move(coords=(int(xpos), int(ypos)))
		try:
			tooltip_control = uia.child_window(control_type="ToolTip")
			return "".join(tooltip_control.texts())
		except ElementNotFoundError:
		    self.builtin.fail("Tooltip text is not found")		

	def is_tooltip_present(self, xpos, ypos):
		"""
		Returns tooltip text visibility.
		"""

		# return False if self.get_tooltip_text(xpos, ypos) == "" else True
		# self.create_power_express_handle()
		# Win32API.MouseMoveTo(int(xpos), int(ypos))
		# return uialibrary.ToolTipControl(searchWaitTime=2)
		uia = self.connect_to_express_via_uia()
		pywinauto.mouse.move(coords=(int(xpos), int(ypos)))
		try:
			return uia.child_window(control_type="ToolTip").is_visible()
		except ElementNotFoundError:
		    return False

	def select_tab_item(self, tab_item):
		"""
		Selects tab item. Use this if select tab control is not working

		Example:
		| Select Tab Item | EMD | 
		"""
		logger.info("Selecting '{}' tab".format(tab_item))
		try:
		    self.connect_to_express_via_uia().child_window(title=tab_item, control_type="TabItem").select()
		except ElementNotFoundError:
		    self.builtin.fail("Tab '{}' is not visible".format(tab_item))

	def get_tab_items(self, automation_id):
		"""
		Gets the list of tabs from input panel recognized by automation_id
		Example:
		@{list_tabs} | Get Tab Items | 9
		"""
		try:
			automation_id = str(automation_id) 
			return [tab.Name for tab in uialibrary.TabControl(AutomationId=automation_id).GetChildren() \
					if tab.ControlTypeName == 'TabItemControl']
		except LookupError:
			self.builtin.fail("Control '{}' not visible".format(automation_id))

	def toggle_checkbox(self, control_id):
		toggle_status = self.get_checkbox_state(control_id)
		is_automation_id = self._is_control_in_uia_format(control_id)
		if not is_automation_id and toggle_status == False:
			uialibrary.CheckBoxControl(RegexName=control_id).Toggle()
			if self.get_checkbox_state(control_id) == False:
				uialibrary.CheckBoxControl(RegexName=control_id).Click()
		elif is_automation_id and toggle_status == False:
			auto_id = self._convert_control_id_to_uia_format(control_id)
			uialibrary.CheckBoxControl(AutomationId=auto_id).Toggle()
		else:
			logger.info("Checkbox '{}' is already ticked".format(control_id))

	def untoggle_checkbox(self, control_id):
		toggle_status = self.get_checkbox_state(control_id)
		is_automation_id = self._is_control_in_uia_format(control_id)		
		if not is_automation_id and toggle_status == True:
			uialibrary.CheckBoxControl(RegexName=control_id).Toggle()
			if self.get_checkbox_state(control_id) == True:
				uialibrary.CheckBoxControl(RegexName=control_id).Click()
		elif is_automation_id and toggle_status == True:
			auto_id = self._convert_control_id_to_uia_format(control_id)
			uialibrary.CheckBoxControl(AutomationId=auto_id).Toggle()
		else:
			logger.info("Checkbox '{}' is already unticked".format(control_id))

	def get_radio_button_state(self, radio_button):
		""" 
		Description:
		Gets Radio Button Status and returns True if Selected and False if Not Selected
		"""
		try:
			if not self._is_control_in_uia_format(radio_button):
				radio_button = uialibrary.RadioButtonControl(Name=radio_button)
			else:
				control_field = self._convert_control_id_to_uia_format(radio_button)
				radio_button = uialibrary.RadioButtonControl(AutomationId=control_field)
			radio_button_state = radio_button.CurrentIsSelected()
			return True if radio_button_state == 1 else False
		except LookupError:
			self.builtin.fail("Control '{}' is not visible".format(radio_button))
		logger.info("Radio Button status is '{}'".format(radio_button_state))

	def get_control_text(self, control_id, window="Power Express", convert_to_string=False):
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
		    if convert_to_string == "True":
		        return ''.join(self.connect_to_express_via_uia().dlg.window(auto_id=control_field).texts())
		    else:
		        return self.connect_to_express_via_uia().dlg.window(auto_id=control_field).texts()
		except ElementNotFoundError:
			self.builtin.fail("Control '{}' is not visible".format(control_id))

	def get_control_text_current_value(self, control_id):
		"""
		Gets text value of current control. Use this for multiple control instances
		"""
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			current_field = self.connect_to_express_via_uia().child_window(auto_id=control_field)
			return current_field.iface_value.CurrentValue
		except ElementNotFoundError:
		    self.builtin.fail("Control '{}' is not visible".format(control_id))

	def click_control(self, control_id, control_index=0):
		"""
		Use this for multiple control instances
		"""   
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_field, found_index=int(control_index))
			control_field.wait('ready', 60, 0.5)
			control_field.set_focus()
			control_field.click()
		except ElementNotFoundError:
			self.builtin.fail("Control '{}' is not visible".format(control_id))

	def is_control_visible(self, control_id):
		"""
		Use this for multiple control instances. Return boolean.
		"""   
		control_id = self._convert_control_id_to_uia_format(control_id)
		try:
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_id, found_index=0)
			return True if control_field.is_visible() else False
		except ElementNotFoundError:
			return False

	def is_control_enabled(self, control_id):
		"""
		Use this to check if control is enabled. Return boolean
		"""   
		control_id = self._convert_control_id_to_uia_format(control_id)
		try:
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_id, found_index=0)
			return True if control_field.is_enabled() else False
		except ElementNotFoundError:
			return False

	def is_control_enabled_and_empty(self, control_id):
		"""
		Use this to check if control is enabled and value is empty. Return boolean
		"""   
		control_id = self._convert_control_id_to_uia_format(control_id)
		try:
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_id, found_index=0)
			return True if control_field.is_enabled() and not control_field.iface_value.CurrentValue else False
		except ElementNotFoundError:
			return False			

	def wait_until_control_is_ready(self, control_id_or_name):
		"""
		Use this when you want o wait for control until is visible and enabled 
		"""   
		try:
			if self._is_control_in_uia_format(control_id_or_name):
				control_id_or_name = self._convert_control_id_to_uia_format(control_id_or_name)
				control_field = self.connect_to_express_via_uia().child_window(auto_id=control_id_or_name, found_index=0)
			else:
				control_field = self.connect_to_express_via_uia().child_window(title=control_id_or_name, found_index=0)
			control_field.wait('ready', 60, 1)			
		except ElementNotFoundError:
			self.builtin.fail("Control '{}' is not present".format(control_id_or_name))

	def wait_until_control_is_not_ready(self, control_id):
		"""
		Use this when you want to wait for control until IS NOT visible and enabled 
		"""		
		control_id = self._convert_control_id_to_uia_format(control_id)
		try:
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_id, found_index=0)
			control_field.wait_not('ready', 60, 1)	
		except ElementNotFoundError:
			self.builtin.fail("Control '{}' is not present".format(control_id))

	def is_tab_selected(self, tab_name):
	    tab_item = self.connect_to_express_via_uia().child_window(title=u''.join(tab_name), control_type="TabItem")
	    return True if tab_item.is_selected() == 1 else False

	def get_status_strip_text(self):
	    """
	    Gets the status strip text.

	    Example:
	    ${status_strip_text} = | Get Status Strip Text |

	    Output:
	    ${status_strip_text} = Form of Payment Update Failed
	    """
	    try:
	    	status_strip = uialibrary.StatusBarControl(AutomationId="StatusStrip").TextControl()
	    	return status_strip.Name
	    except Exception:
	    	return ""
	    # status_strip = self.connect_to_express_via_uia().child_window(auto_id="StatusStrip").Text
	    # return status_strip.Name

	def get_control_coords(self, control_id_or_title):
		"""
		Returns coordinates midpoint (x and y)

		| {x} | ${y} | Get Control Coords | [NAME:ccboNoActionCode] |

		"""
		uia = self.connect_to_express_via_uia()
		try:
			if self._is_control_in_uia_format(control_id_or_title):
				control_field = self._convert_control_id_to_uia_format(control_id_or_title)
				control = uia.child_window(auto_id=control_field)
			else:
				control = uia.child_window(title=control_id_or_title)
		except Exception:
		    self.builtin.fail("Control '{}' is not visible".format(control_id_or_title))
		control.set_focus()
		mid_point = control.rectangle().mid_point()
		return mid_point.x, mid_point.y	
		# pos = win32api.GetCursorPos()
		# return pos[0], pos[1]

	def get_pixel_color(self, x=None, y=None, control_id=None):
		"""
		Returns pixel color in HEX format. Use Get Control Coords is x an y is not known

		| ${pixel_color} | Get Pixel Color | control_id=[NAME:ChangesBeforeDepartureComboBox_alt_2] |
		| ${pixel_color} | Get Pixel Color | x=638 | y=496 |

		"""
		# desktop = DesktopWindow()
		if all(v is None for v in [x, y]):
			control_field = self._convert_control_id_to_uia_format(control_id)
			control_field = self.connect_to_express_via_uia().child_window(auto_id=control_field, found_index=0)
			# control_field.set_focus()
			mid_point = control_field.rectangle().mid_point()
			color =  autoit.pixel_get_color(int(mid_point.x), int(mid_point.y))
			# color = desktop.get_pixel_color(int(mid_point.x), int(mid_point.y))
		else:
			color =  autoit.pixel_get_color(int(mid_point.x), int(mid_point.y))
			# color = desktop.get_pixel_color(int(x), int(y))
		# return "".join([format(val, '02X') for val in color])
		return self.builtin.convert_to_hex(color)

	def handle_contact_tracking_service(self):
	    uia = self.uia.window(title_re="Contact Tracking", control_type="Window")
	    uia.wait('ready')
	    uia.set_focus()
	    uia.child_window(title="Internal", control_type="ListItem").set_focus()
	    uia.child_window(title="Internal", control_type="Hyperlink").click_input()
	    uia.child_window(title="Quality/PNR check", control_type="Text").click_input()
	    uia.child_window(title="See selected services", control_type="Button").click_input()        

	def emulate_pcc_in_sellco(self, pcc):
		uialibrary.WindowControl(ClassName='IEFrame').SetActive()
		ie_tab = uialibrary.TabControl(Name='Tab Row')
		ie_tab.SetFocus()
		ie_tabs = [tab.Name for tab in ie_tab.GetChildren()]
		if bool(filter(lambda tab: tab.startswith(pcc), ie_tabs)):
			for tab in [tab for tab in ie_tab.GetChildren() if tab.ControlType == 50019]:
				if not tab.Name.startswith(pcc):
					tab.Click()
					tab.ButtonControl(Name='Close Tab (Ctrl+w)').Click()
					sleep(5)
					tab.Click()
					uialibrary.WindowControl(Name='Windows Internet Explorer').SetActive()
					ie_prompt = uialibrary.ButtonControl(Name='Leave this page')
					ie_prompt.SetFocus()
					ie_prompt.Click()
		else:
			uialibrary.ListItemControl(Name='Main Page').Click()
			office_id_link = uialibrary.ListItemControl(RegexName='Office ID')
			office_id_link.Click()
			pcc_textfield = office_id_link.GetParentControl().GetNextSiblingControl()
			pcc_textfield.Click()
			pcc_textfield.SendKeys(pcc)
			uialibrary.HyperlinkControl(Name=pcc).Click()
			sleep(15)
			ie_tab.GetFirstChildControl().Click()
			sleep(2)
			ie_tab.GetFirstChildControl().ButtonControl(Name='Close Tab (Ctrl+W)').Click()
			sleep(5)
			ie_tab.GetFirstChildControl().Click()
			uialibrary.WindowControl(Name='Windows Internet Explorer').SetActive()
			ie_prompt = uialibrary.ButtonControl(Name='Leave this page')
			ie_prompt.SetFocus()
			ie_prompt.Click()
		
	def click_button_control(self, button_name_or_control_id, double_click=False, use_automation_id=False):
		"""
		Click button name using either control_field or button_name
		Control id may use argument use_automation_id=True if [Name:] is not available

		| Click Button Control | Change Team           |
		| Click Button Control | [NAME:btnSomething]   |

		"""
		logger.info("Clicking button '{}'".format(button_name_or_control_id))
		try:
			if self._is_control_in_uia_format(button_name_or_control_id) or use_automation_id == 'True':
				control_id = self._convert_control_id_to_uia_format(button_name_or_control_id)
				button_field = uialibrary.ButtonControl(AutomationId=control_id)
			else:
				button_field = uialibrary.ButtonControl(Name=button_name_or_control_id)
			if double_click == 'True':
				button_field.DoubleClick()
			else:
				button_field.Click()
		except LookupError:
			self.builtin.fail('Button control {} is not found'.format(button_name_or_control_id))

	def click_menuitem_control(self, menuitem_name, double_click=False):
		"""
		Click MenuItem control using either control_field or button_name
		Accepts regex name for menuitem_nane argument

		| Click Menuitem Control  | Itinerary Language: |
		"""
		logger.info("Clicking menu item '{}'".format(menuitem_name))
		try:
			menuitem_field = uialibrary.MenuItemControl(RegexName=menuitem_name)
			if double_click == True:
				menuitem_field.DoubleClick()
			else:
				menuitem_field.Click()
		except LookupError:
		    self.builtin.fail('Menu item {} not found'.format(menuitem_name))

	def click_tabitem_control(self, tabitem_name, parent_tab_auto_id=None):
		"""
		Usage:
		| Click TabITem Control  | Cust Refs |
		"""
		try:
			if parent_tab_auto_id is not None:
				parent_control = uialibrary.TabControl(AutomationId=parent_tab_auto_id)
				parent_control.TabItemControl(Name=tabitem_name).Click()
			else:
				uialibrary.TabItemControl(Name=tabitem_name).Click()
		except LookupError:
		    self.builtin.fail('Tab item {} not found'.format(tabitem_name))

	def is_tab_item_visible(self, tabitem_name, parent_tab_auto_id=None):
		"""
		"""
		if parent_tab_auto_id is not None:
			parent_control = uialibrary.TabControl(AutomationId=parent_tab_auto_id, maxSearchSeconds=2)
			tab_item = parent_control.TabItemControl(Name=tabitem_name, maxSearchSeconds=2)
		else:
			tab_item = uialibrary.TabItemControl(Name=tabitem_name, maxSearchSeconds=2)
		return tab_item.Exists()
	
	def get_tab_controls_items(self, class_name=None):
		"""
		Usage:

		"""
		if class_name is not None:
			return [item.Name for item in uialibrary.TabControl(ClassName=class_name).GetChildren()]
		else:
			return [item.Name for item in uialibrary.TabControl().GetChildren()]

	def get_table_control(self, control_id):
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			table_control = uialibrary.TableControl(AutomationId=control_field)
		except LookupError:
			self.builtin.fail("Table control '{}' is not visible".format(control_id))
		return table_control

	def get_pane_control(self, control_id):
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			pane_control = uialibrary.PaneControl(AutomationId=control_field)
		except LookupError:
			self.builtin.fail("Pane control '{}' is not visible".format(control_id))
		return pane_control

	def get_first_child_automation_id(self, parent_control_id):
		syex = self.create_power_express_handle()
		parent_control_id = self._convert_control_id_to_uia_format(parent_control_id)
		child_field = uialibrary.PaneControl(RegexAutomationId=parent_control_id, 
									searchFromControl=syex).GetFirstChildControl()
		return child_field.AutomationId

	def move_cursor_to_pane_control(self, automation_id, ratio_x=0.5, ratio_y=0.5):
		automation_id = self._convert_control_id_to_uia_format(automation_id)		
		uialibrary.PaneControl(RegexAutomationId=automation_id).MoveCursor(ratioX=ratio_x, ratioY=ratio_y)
	
	def get_tooltip_from_error_icon(self, *parent_control_id):
		"""
		Parent control id must be passed as an argument. Use Inspect Object to get the id
		Parent control id also accepts regex value
		"""
		tooltip_list = []
		uialibrary.SetGlobalSearchTimeOut(20)
		try:
			for parent in parent_control_id:
				automation_id = self.get_first_child_automation_id(parent)
				self.move_cursor_to_pane_control(automation_id)
				tooltip_list.append(uialibrary.ToolTipControl().Name)
			return tooltip_list if len(tooltip_list) > 1 else ''.join(tooltip_list)
		except LookupError:
			self.builtin.fail("Tooltip is not visible")

	def get_control_type(self, control_id):
		self.create_power_express_handle()
		autoit.control_focus("Power Express", control_id)
		return uialibrary.GetFocusedControl().ControlTypeName

	def _is_control_in_uia_format(self, control_id_or_label):
		return bool(re.search(r"(\[.*:)|(\])", control_id_or_label))

	def get_pixel_color_left(self, control_id, left_offset=5):
		self.create_power_express_handle()
		autoit.control_focus("Power Express", control_id)
		control = uialibrary.GetFocusedControl()
		control.MoveCursor(int(left_offset), 0.5)
		cursor = Win32API().GetCursorPos()
		return self.get_pixel_color(cursor[0], cursor[1])

	def get_pixel_color_right(self, control_id, right_offset=-5):
		self.create_power_express_handle()
		autoit.control_focus("Power Express", control_id)
		control = uialibrary.GetFocusedControl()
		control.MoveCursor(int(right_offset), 0.5)
		cursor = Win32API().GetCursorPos()
		return self.get_pixel_color(cursor[0], cursor[1])

	def verify_button_exists(self, button_name=None, button_id=None):
		"""
		| ${is_button_visible} | Verify Button Exists | button_name=Telephony      |
		| ${is_button_visible} | Verify Button Exists | button_id=btnSearchLocator |

		"""
		if button_name:
			return uialibrary.ButtonControl(Name=button_name).Exists()
		elif button_id:
			return uialibrary.ButtonControl(AutomationId=button_id).Exists()
		else:
			self.builtin.fail("Provide button_name or button_id as argument")

	def get_button_color(self, button_name=None, button_id=None):
		"""
		Supports only Button control
		Current get pixel of mid
		| ${button_color} | Get Button Color | button_name=Telephony      |
		| ${button_color} | Get Button Color | button_id=btnSearchLocator |

		"""
		self.create_power_express_handle()
		if button_name:
			uialibrary.ButtonControl(Name=button_name)
			control = uialibrary.GetFocusedControl()
			control.MoveCursor()
			cursor = Win32API().GetCursorPos()
			return self.get_pixel_color(cursor[0], cursor[1])
		elif button_id:
			uialibrary.ButtonControl(AutomationId=button_id)
			control = uialibrary.GetFocusedControl()
			control.MoveCursor()
			cursor = Win32API().GetCursorPos()
			return self.get_pixel_color(cursor[0], cursor[1])
		else:
			self.builtin.fail("Provide button_name or button_id as argument")

	def get_control_edit_value(self, control_id):
		"""
		Description: Use this if Get Control Text Value is not working. 
		             Currently supports Edit control only

		| ${text_value} | Get Control Edit Value | [NAME:PassengerIDTextBox] |
		"""
		try:
			if self._is_control_in_uia_format(control_id):
				control_id = self._convert_control_id_to_uia_format(control_id)
			return uialibrary.EditControl(AutomationId=control_id).AccessibleCurrentValue()
		except LookupError:
			# ImageHorizonLibrary().take_a_screenshot()
			self.builtin.fail("Control '{}' is not visible".format(control_id))

	def set_control_edit_value(self, control_id_or_name, text_value, use_control_name=False):
		"""
		Description: Use this if Set Control Text Value is not working. 
		             Currently supports Edit control only

		| Set Control Edit Value | [NAME:PassengerIDTextBox] | Text Value   |                       |
		| Set Control Edit Value | Issue in Exchange For     | Sample Value | use_control_name=True |

		"""
		try:
			if use_control_name == "True":
				edit = uialibrary.EditControl(RegexName=control_id_or_name)
			else:
				automation_id = self._convert_control_id_to_uia_format(control_id_or_name)
				edit = uialibrary.EditControl(RegexAutomationId=automation_id)
			edit.SetFocus()
			edit.SetValue(text_value)
		except LookupError:
			self.builtin.fail("Control '{}' is not visible".format(control_id_or_name))

	def is_control_edit_visible(self, automation_id):
		"""
		Description: Use this if Get Control Text Value is not working. 
		             Currently supports Edit control only
		             You need to pass automation_id using Inspect 

		| ${is_control_edit_visible} | Is Control Edit Visible | GSTTextBox |
		"""
		syex = self.create_power_express_handle()
		return uialibrary.EditControl(AutomationId=automation_id, searchFromControl=syex).Exists(maxSearchSeconds=5)

	def scroll_down(self, parent_id):
		syex = self.connect_to_express_via_uia()
		scrollbar = syex.child_window(auto_id=parent_id).child_window(title_re="Vertical")
		scrollbar.child_window(title="Page down", control_type="Button").click_input()
	
	def scroll_up(self, parent_id):
		syex = self.connect_to_express_via_uia()
		scrollbar = syex.child_window(auto_id=parent_id).child_window(title_re="Vertical")
		scrollbar.child_window(title="Page up", control_type="Button").click_input()

	def get_checkbox_state_from_list_control(self, item):
		"""
		Description: Accepts argument as regex or literal value 
		| Get Checkbox State From List Control | 2                          |
		| Get Checkbox State From List Control | 2. PR 22FEB2019 SINMNL HK1 |
		"""
		logger.info("Getting checkbox status from list control '{}'".format(item))
		toggle_state = uialibrary.ListItemControl(RegexName='{}'.format(item)).CurrentToggleState()
		return True if toggle_state == 1 else False

	def get_pane_control_children_name(self, automation_id):
		return [item.Name for item in uialibrary.PaneControl(AutomationId=automation_id).GetChildren()]

	def is_error_icon_visible(self, parent_auto_id):
		"""
		Description: Use the parent id of error icon
		| ${is_ticketing_date_error } | Is Error Icon Visible | grpTicketingDetails |

		Returns boolean
		"""
		auto_id = self._convert_control_id_to_uia_format(parent_auto_id)
		control = self.connect_to_express_via_uia().child_window(auto_id=auto_id, found_index=0)\
			.children()[0]
		try:
			return control.friendly_class_name() == "Pane" and bool(re.match(r'\d+', control.automation_id())\
				or control.automation_id() == "")
		except AttributeError:
			return control.friendly_class_name() == "Pane"

	def get_tree_control(self, control_id):
		control_field = self._convert_control_id_to_uia_format(control_id)
		try:
			tree_control = uialibrary.TreeControl(AutomationId=control_field)
		except LookupError:
			self.builtin.fail("Tree control '{}' is not visible".format(control_id))
		return tree_control
			
# if __name__ == '__main__':
# 	syex = SyexUiaLibrary()