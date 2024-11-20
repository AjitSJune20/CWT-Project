# -*- coding: utf-8 -*-
import os
import sys
import time
import autoit
import uialibrary
from SyexUiaLibrary import SyexUiaLibrary
from SyexCustomLibrary import SyexCustomLibrary
from robot.libraries.BuiltIn import BuiltIn
#from ImageHorizonLibrary import ImageHorizonLibrary

ROBOT_LIBRARY_SCOPE = 'Global'

class OtherServicesFormula:

    ROBOT_LIBRARY_SCOPE = 'Global'

    def _initialize(self, country):
        try:
            SyexUiaLibrary().create_power_express_handle()
            self.builtin = BuiltIn()
            if country.lower() == 'hk':
                self.ui_client_type = self._get_client_type()
                self.ui_nett_fare = int(self._get_nett_fare())
                self.ui_tax_1 = int(self._get_tax_1())
                self.ui_tax_2 = int(self._get_tax_2())
                self.ui_commission = int(self._get_commission())
                self.ui_discount = int(self._get_discount())
                self.ui_tranx_service_fee = int(self._get_tranx_service_fee())      
                self.ui_merchant_fee = int(self._get_merchant_fee())
                self.ui_form_of_payment = self._get_form_of_payment()
                self.is_apply_formula_checked = self._is_apply_formula_checked()
                self.is_merchant_fee_cwt_absorb_checked = self._is_merchant_fee_cwt_absorb_checked()
                self.is_uatp_checked = self._is_uatp_checked()
                self.is_web_fare_selected = self._is_web_fare_selected()
            elif country.lower() == 'sg':
                self.ui_published_fare = self._get_published_fare()
                self.ui_selling_fare = self._get_selling_fare()
                self.ui_tax_1 = self._get_tax_1()
                self.ui_tax_2 = self._get_tax_2()
                self.ui_commission = self._get_commission()
                self.ui_discount = self._get_discount()
                self.ui_tranx_service_fee = self._get_tranx_service_fee()    
                self.ui_merchant_fee = self._get_merchant_fee()
                self.ui_form_of_payment = self._get_form_of_payment()
                self.is_apply_formula_checked = self._is_apply_formula_checked()
                self.is_merchant_fee_cwt_absorb_checked = self._is_merchant_fee_cwt_absorb_checked()
                self.is_uatp_checked = self._is_uatp_checked()
                self.is_web_fare_selected = self._is_web_fare_selected()

        except LookupError:
            self.builtin.fail("Cannot Find Power Express. '{}' is not visible".format('frmMain'))

    def _select_commission_percentage(self):
        try:
            autoit.control_focus("Power Express", "[NAME:CommissionToggleButton_PaymentButton]")
            autoit.control_click("Power Express", "[NAME:CommissionToggleButton_PaymentButton]")
            uialibrary.MenuItemControl(Name='Percentage').Click()
            ImageHorizonLibrary().take_a_screenshot()
            autoit.send('{TAB}')
            self.builtin.sleep('3s')
        except LookupError:
            self.builtin.fail("Unable to select commission percentage. '{}' is not visible".format('Percentage'))

    def _select_discount_percentage(self):
        try:
            autoit.control_focus("Power Express", "[NAME:DiscountToggleButton_PaymentButton]")
            autoit.control_click("Power Express", "[NAME:DiscountToggleButton_PaymentButton]")
            uialibrary.MenuItemControl(Name='Percentage').Click()
            ImageHorizonLibrary().take_a_screenshot()
            autoit.send('{TAB}')
            self.builtin.sleep('3s')
        except LookupError:
            self.builtin.fail("Unable to select commission percentage. '{}' is not visible".format('Percentage'))

    def _get_published_fare(self):
        if SyexUiaLibrary().is_control_edit_visible('PublishFareTextBox'):
            return autoit.control_get_text("Power Express", "[NAME:PublishFareTextBox]")

    def _get_client_type(self):
        return autoit.control_get_text("Power Express", "[NAME:ClientTypeComboBox]")

    def _get_nett_fare(self):
        return autoit.control_get_text("Power Express", "[NAME:NettFareTextBox]")

    def _get_selling_fare(self):
        return autoit.control_get_text("Power Express", "[NAME:SellingFareClientTextBox]")

    def _get_tax_1(self):
        return autoit.control_get_text("Power Express", "[NAME:Tax1TextBox]")

    def _get_tax_2(self):
        return autoit.control_get_text("Power Express", "[NAME:Tax2TextBox]")

    def _get_commission(self):
        return autoit.control_get_text("Power Express", "[NAME:CommissionTextBox]")

    def _get_discount(self):
        return autoit.control_get_text("Power Express", "[NAME:DiscountTextBox]")

    def _get_merchant_fee(self):
        test = autoit.control_get_text("Power Express", "[NAME:MerchantTextBox]")
        return test

    def _get_tranx_service_fee(self):
        return autoit.control_get_text("Power Express", "[NAME:TransactionServiceFeeTextBox]")

    def _get_form_of_payment(self):
        return autoit.control_get_text("Power Express", "[NAME:FormOfPaymentComboBox]")

    def _is_apply_formula_checked(self):
        return SyexUiaLibrary().get_checkbox_state('[NAME:ApplyFormulaCheckBox]')

    def _is_merchant_fee_cwt_absorb_checked(self):
        return SyexUiaLibrary().get_checkbox_state('[NAME:CwtAbsorbCheckbox]')

    def _is_uatp_checked(self):
        if SyexUiaLibrary().is_control_visible('[NAME:UatpCheckbox]'):
            return SyexUiaLibrary().get_checkbox_state('[NAME:UatpCheckbox]')
        else:
            return False

    def _is_web_fare_selected(self):
        segment_list = SyexCustomLibrary().get_segments_from_list_control()
        is_checked = 'false'
        for segment in segment_list:
            if is_checked == 'false' and segment != 'Header Control':
                is_checked = SyexUiaLibrary().get_checkbox_state_from_list_control(segment)
                break
        return is_checked

    def compute_consolidator_and_lcc_fees(self, country, merchant_fee_percentage, is_commission_percent='false', is_discount_percent='false', tfinmf='false', product_type='MS'):
        os = OtherServicesFormula()
        os._initialize(country)

        currency = SyexCustomLibrary().get_currency(country)

        commission = 0
        total_selling_fare = 0
        nett_cost_in_eo = 0
        selling_price = 0
        discount = 0
        nett_fare = 0
        merchant_fee = 0

        if country.lower() == 'hk':
            if os.is_apply_formula_checked == False:
                discount = SyexCustomLibrary().round_apac(os.ui_discount, country)
                if os.is_web_fare_selected == True:
                    total_selling_fare = os.ui_nett_fare + os.ui_commission - discount + os.ui_tax_1 + os.ui_tax_2 + os.ui_merchant_fee
                    nett_cost_in_eo = os.ui_nett_fare
                else:
                    computed = os.ui_nett_fare + os.ui_commission - discount + os.ui_tax_1 + os.ui_tax_2 + os.ui_merchant_fee
                    total_selling_fare = SyexCustomLibrary().round_apac(computed, country)
                    nett_cost_in_eo = os.ui_nett_fare

                nett_cost_in_eo = SyexCustomLibrary().round_apac(nett_cost_in_eo, country)
                total_selling_fare = SyexCustomLibrary().round_apac(total_selling_fare, country)

                return nett_cost_in_eo, total_selling_fare
            else:
                if is_commission_percent.lower() == 'true':
                    os._select_commission_percentage()
                    computed = os.ui_nett_fare / (1 - os.ui_commission * 0.01)

                    if country.lower() == 'hk' and os.ui_client_type != 'TP':
                        if computed > 0 and os.ui_client_type == 'DU':
                            commission = SyexCustomLibrary().round_apac(computed - os.ui_nett_fare + 10, country)
                        else:
                            commission = SyexCustomLibrary().round_apac(computed - os.ui_nett_fare, country)
                    else:
                        commission = 0

                    if os.is_web_fare_selected == True:
                        if os.ui_client_type == "MG" or os.ui_client_type == "DB" or os.ui_client_type == "TF" or os.ui_client_type == "MN":
                           selling_price = computed
                        else:
                           selling_price = computed + 10
                    else:
                        if os.ui_client_type == "MG" or os.ui_client_type == "DB" or os.ui_client_type == "TF" or os.ui_client_type == "MN":
                           selling_price = SyexCustomLibrary().round_apac(computed, country)
                        else:
                           selling_price = SyexCustomLibrary().round_apac(computed + 10, country)
                else:
                    commission = os.ui_commission
                    if os._is_web_fare_selected == True:
                        selling_price = os.ui_nett_fare + os.ui_commission
                    else:
                        selling_price = SyexCustomLibrary().round_apac(os.ui_nett_fare + os.ui_commission, country)

                if is_discount_percent.lower() == "true":
                    os._select_discount_percentage()
                    if os.ui_client_type == "DU" or os.ui_client_type == "DB":
                        discount = SyexCustomLibrary().round_apac((os.ui_nett_fare + os.ui_commission) * (os.ui_discount * 0.01), country)
                    elif os.ui_client_type == "MN" or os.ui_client_type == "TF" or os.ui_client_type == "TP":
                        discount = SyexCustomLibrary().round_apac(commission,country)
                    else:
                        discount = 0
                else:
                    discount = os.ui_discount

                nett_cost_in_eo = os.ui_nett_fare

                if os.ui_client_type == "" or os.ui_client_type == "MN":
                    discount = 0

                if os.ui_client_type == "TF" or os.ui_client_type == "MN":
                    discount = 0
                    nett_fare = selling_price + os.ui_tax_1 + os.ui_tax_2
                else:
                    nett_fare = selling_price + os.ui_tax_1 + os.ui_tax_2 - discount

                if os.is_merchant_fee_cwt_absorb_checked == False and (os.ui_form_of_payment.lower() == 'credit card (cx)' or os.ui_form_of_payment.lower() == 'credit card (cc)'):
                    # Sending of UATP status to service is not yet implemented in UI (Oct. 5, 2018 US467)
                        if os.is_uatp_checked == True:
                            if country.lower() == "hk":
                                if os.ui_client_type == 'TF':
                                    merchant_fee = SyexCustomLibrary().round_apac(os.ui_tranx_service_fee * (int(merchant_fee_percentage) * 0.01), country)
                                else:
                                    total_tax = os.ui_tax_1 + os.ui_tax_2
                                    merchant_fee = SyexCustomLibrary().round_apac((selling_price - discount - os.ui_nett_fare) * (int(merchant_fee_percentage) * 0.01), country)
                        else:
                            if os.ui_client_type == 'TF' and tfinmf.lower() == "true":
                                merchant_fee = SyexCustomLibrary().round_apac(((nett_fare + os.ui_tranx_service_fee) * (int(merchant_fee_percentage) * 0.01)), country)
                            else:
                                nett_and_mf = nett_fare * (int(merchant_fee_percentage) * 0.01)
                                merchant_fee = SyexCustomLibrary().round_apac(nett_and_mf, country)
                else:
                    merchant_fee = 0
                
                if os.is_web_fare_selected == True:
                    total_selling_fare = nett_fare + merchant_fee
                else:
                    total_selling_fare = SyexCustomLibrary().round_apac(nett_fare + merchant_fee, country)

        elif country.lower() == 'sg':
            client_type = 'DU'
            if os.is_apply_formula_checked == False:
                if product_type.upper() == 'CT':
                    total_selling_fare = os.ui_nett_fare + os.ui_commission - os.ui_discount + os.ui_tax_1 + os.ui_tax_2 + os.ui_merchant_fee
                else:
                    computed = float(os.ui_selling_fare) - float(os.ui_discount) + float(os.ui_tax_1) + float(os.ui_tax_2) + float(os.ui_merchant_fee)
                    total_selling_fare = SyexCustomLibrary().round_apac(computed, country)

                if os.ui_published_fare > 0:
                    nett_cost_in_eo = float(os.ui_published_fare) - float(os.ui_commission)
                else:
                    nett_cost_in_eo = float(os.ui_selling_fare) - float(os.ui_commission)

                nett_cost_in_eo = SyexCustomLibrary().round_apac(nett_cost_in_eo, country)
                total_selling_fare = SyexCustomLibrary().round_apac(total_selling_fare, country)

                return nett_cost_in_eo, total_selling_fare
            else:

                if is_commission_percent.lower() == 'true':
                    os._select_commission_percentage()
                    if os.ui_published_fare > 0:
                        commission = float(os.ui_published_fare) * (float(os.ui_commission) * 0.01)
                    else:
                        commission = float(os.ui_selling_fare) * (float(os.ui_commission) * 0.01)
                else:
                    commission = float(os.ui_commission)

                if is_discount_percent.lower() == "true":
                    os._select_discount_percentage()
                    if os.ui_published_fare > 0:
                        discount = float(os.ui_published_fare) * (float(os.ui_discount) * 0.01)
                    else:
                        discount = float(os.ui_selling_fare) * (float(os.ui_discount) * 0.01)
                else:
                    discount = float(os.ui_discount)

                if product_type.upper() == 'CT':
                    if os.is_merchant_fee_cwt_absorb_checked == False and (os.ui_form_of_payment.lower() == 'credit card (cx)' or os.ui_form_of_payment.lower() == 'credit card (cc)'):
                        if  client_type == 'TF' and tfinmf.lower() == "true":
                            merchant_fee = SyexCustomLibrary().round_apac((os.ui_nett_cost_in_eo + os.ui_commission - discount + os.ui_tax_1 + os.ui_tax_2 + os.ui_tranx_service_fee) * (merchant_fee_percentage * 0.01))
                        else:
                            computed = float(os.ui_selling_fare) + float(os.ui_commission) + float(os.ui_tax_1) + float(os.ui_tax_2) - float(discount)
                            merchant_fee = computed * (merchant_fee_percentage * 0.01)
                else:
                    if os.is_merchant_fee_cwt_absorb_checked == False and (os.ui_form_of_payment.lower() == 'credit card (cx)' or os.ui_form_of_payment.lower() == 'credit card (cc)'):
                        if  client_type == 'TF' and tfinmf.lower() == "true":
                            merchant_fee = (float(os.ui_selling_fare) + commission - float(discount) + float(os.ui_tax_1) + float(os.ui_tax_2) + float(os.ui_tranx_service_fee)) * (merchant_fee_percentage * 0.01)
                        else:
                            computed = float(os.ui_selling_fare) - float(discount) + float(os.ui_tax_1) + float(os.ui_tax_2)
                            merchant_fee = float(computed) * (int(merchant_fee_percentage) * 0.01)
                            
                if os.is_merchant_fee_cwt_absorb_checked == True and (os.ui_form_of_payment.lower() != 'credit card (cx)' or os.ui_form_of_payment.lower() != 'credit card (cc)'):
                    merchant_fee = 0

                if product_type.upper() == 'CT':
                    total_selling_fare = float(os.ui_selling_fare) + commission - discount + float(os.ui_tax_1) + float(os.ui_tax_2)
                else:
                    total_selling_fare = float(os.ui_selling_fare) - float(discount) + float(os.ui_tax_1) + float(os.ui_tax_2) + float(merchant_fee)
                
                if os.ui_published_fare > 0:
                    nett_cost_in_eo = float(os.ui_published_fare) - commission
                else:
                    nett_cost_in_eo = float(os.ui_selling_fare) - commission
        
        nett_fare = SyexCustomLibrary().round_apac(nett_fare, country)
        nett_cost_in_eo = SyexCustomLibrary().round_apac(nett_cost_in_eo, country)
        commission = SyexCustomLibrary().round_apac(commission, country)
        discount = SyexCustomLibrary().round_apac(discount, country)
        merchant_fee = SyexCustomLibrary().round_apac(merchant_fee, country)
        total_selling_fare = SyexCustomLibrary().round_apac(total_selling_fare, country)
        selling_price = SyexCustomLibrary().round_apac(selling_price, country)

        return commission, total_selling_fare, nett_cost_in_eo, selling_price, discount, nett_fare, merchant_fee

# if __name__ == '__main__':
#   os = OtherServicesFormula()
#   commission, total_selling_fare, nett_cost_in_eo, selling_price, discount, gross_fare, merchant_fee = os.compute_consolidator_and_lcc_fees('HK', 2, 'false', 'false')
#   print "commission {}".format(commission)
#   print "total_selling_fare {}".format(total_selling_fare)
#   print "nett_cost_in_eo {}".format(nett_cost_in_eo)
#   print "selling_price {}".format(selling_price)
#   print "discount {}".format(discount)
#   print "gross_fare {}".format(gross_fare)
#   print "merchant_fee {}".format(merchant_fee)
  # nett_cost_in_eo, total_selling_fare = os.compute_consolidator_and_lcc_fees('HK', 7)
  # print "total_selling_fare {}".format(total_selling_fare)
  # print "nett_cost_in_eo {}".format(nett_cost_in_eo)
