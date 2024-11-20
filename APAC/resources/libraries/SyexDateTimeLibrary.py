# -*- coding: utf-8 -*-
import datetime
import time
import calendar
import random
import locale
from robot.libraries.BuiltIn import BuiltIn

class SyexDateTimeLibrary:

    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        self.builtin = BuiltIn()

    def set_departure_date_x_months_from_now_in_gds_format(self, number_of_months, number_of_days=0):
        future_date = self._set_future_date(number_of_months, number_of_days)
        return self._set_gds_date_format(future_date)

    def set_departure_date_x_months_from_now_in_syex_format(self, number_of_months, number_of_days=0):
        future_date = self._set_future_date(number_of_months, number_of_days)
        adjusted_date = self._adjust_weekend_to_weekday(future_date)
        return self._set_syex_date_format(adjusted_date)

    def add_days_to_current_date_in_syex_format(self, day_to_add):
        future_date = self._add_days_to_current_day(day_to_add)
        adjusted_date = self._adjust_weekend_to_weekday(future_date, 'add')
        return self._set_syex_date_format(adjusted_date)

    def set_rail_trip_date_x_months_from_now(self, number_of_months, number_of_days=0):
        return str(self.generate_date_x_months_from_now(number_of_months, number_of_days, '%d %B %Y'))

    def generate_date_x_months_from_now(self, number_of_months, number_of_days=0, date_format='%d/%m/%Y'):
        """
        Description:
        Generates date given the number of months, days and date format. If date format is not
        given, will use this format "%d %B %Y"

        Usage:
        | ${generated_date} = | Generate Date X Months From Now | 2 | 1 | %m-%d-%Y
        | ${generated_date} = | Generate Date X Months From Now | 2 | 1 | %d %b %Y
        | ${generated_date} = | Generate Date X Months From Now | 2 | 1 |
        =>
        | ${generated_date} = | 08-20-2017  |
        | ${generated_date} = | 20 Aug 2017 |
        | ${generated_date} = | 20/08/2017  |

        """        
        date_formatted = self._set_future_date(number_of_months, number_of_days)
        return str(date_formatted.strftime(date_format))

    def get_current_date(self):
        date_today = '{dt.month}/{dt.day}/{dt.year}'.format(dt=datetime.datetime.now())
        return str(date_today)

    def get_gds_current_date(self, remove_leading_zero='true'):
        """ 
        Returns gds current date. If you want to remove leading zero in days, set remove
        leading zero to 'true'

        | ${gds_date} = | Get Gds Current Date | remove_leading_zero=true |
        """
        time_now = datetime.datetime.now().time()
        today_2pm = time_now.replace(hour=14, minute=31, second=0, microsecond=0)
        if time_now < today_2pm:
            gds_date = datetime.datetime.now() - datetime.timedelta(days=int(1))
        else:
            gds_date = datetime.datetime.now()

        if remove_leading_zero.lower() == 'true':
            return str('{dt.day}{dt:%b}'.format(dt=gds_date).upper())
        else:
            return self._set_gds_date_format(gds_date)

    def convert_date_to_gds_format(self, date, actual_date_format, is_year_needed='false'):
        """ 
        Example:
        | ${date} = | Convert Date To Gds Format | 11/5/2016  | %m/%d/%Y |
        | ${date} = | Convert Date To Gds Format | 2016/11/09 | %Y/%m/%d |
        
        =>
        | ${date} = | 05NOV |        
        """
        converted_date = datetime.datetime.strptime(date, actual_date_format)
        return self._set_gds_date_format(converted_date, is_year_needed)

    def convert_date_to_defined_format(self, date, actual_date_format, expected_date_format):
        """ 
        Example:
        | ${date} = | Convert Date To Defined Format | 1/25/2016  | %m/%d/%Y | %d/%m/%Y |
        | ${date} = | Convert Date To Defined Format | 2016/11/09 | %Y/%m/%d | %m/%d/%Y |
        
        =>
        | ${date} = | 25/01/2015 |        
        | ${date} = | 11/09/2016 |        
        """
        try:
            converted_date = datetime.datetime.strptime(date, actual_date_format)
            return converted_date.strftime(expected_date_format)
        except ValueError:
            self.builtin.fail("Error in date format")

    def convert_date_to_syex_format(self, date, actual_date_format):
        """ 
        Example:
        | ${date} = | Convert Date To Syex Format | 11/5/2016  | %m/%d/%Y
        | ${date} = | Convert Date To Syex Format | 2016/11/09 | %Y/%m/%d
        """
        converted_date = datetime.datetime.strptime(date, actual_date_format)
        return self._set_syex_date_format(converted_date)
		
    def convert_date_to_timestamp_format(self, date, actual_date_format):
        """ 
        Example:
        | ${date} = | Convert Date To Timestamp Format | 11/5/2016  | %m/%d/%Y |
        | ${date} = | Convert Date To Timestamp Format | 2016/11/09 | %Y/%m/%d |
        """
        converted_date = datetime.datetime.strptime(date, actual_date_format)
        return self._set_timestamp_format(converted_date)

    def add_days_in_gds_format(self, date, day_to_add, adjust_weekend_to_weekday='True'):
        """ 
        Description:
        Add days using GDS format which is %d%b or 09SEP
        By default adjusted weekend to weekday. Set adjust_weekend_to_weekday to False to ignore adjustment

        Example:
        | ${adjusted_date} = | Add days In GDS Format | 09SEP  | 1 |

        =>
        ${adjusted_date} = 10SEP
        """
        converted_date = datetime.datetime.strptime(date, '%d%b')
        added_date = converted_date + datetime.timedelta(days=int(day_to_add))
        if adjust_weekend_to_weekday == 'True':
            actual_date = self._adjust_weekend_to_weekday(added_date)
            return self._set_gds_date_format(actual_date)
        else:
            return self._set_gds_date_format(added_date)

    def add_days_in_syex_format(self, date, day_to_add, adjust_weekend_to_weekday='True'):
        """ 
        Description:
        Add days using Syex format which is %m/%d/%Y or 12302017
        By default adjusted weekend to weekday. Set adjust_weekend_to_weekday to False to ignore adjustment
        Example:
        | ${adjusted_date} = | Add days In Syex Format | 12302017  | 1 |

        =>
        ${adjusted_date} = 12312017
        """        
        converted_date = datetime.datetime.strptime(date, '%m/%d/%Y')
        added_date = converted_date + datetime.timedelta(days=int(day_to_add))
        if adjust_weekend_to_weekday == 'True':
            actual_date = self._adjust_weekend_to_weekday(added_date)
            return self._set_syex_date_format(actual_date)
        else:
            return self._set_syex_date_format(added_date)

    def subtract_days_in_gds_format(self, date, day_to_subtract, adjust_weekend_to_weekday='True'):
        """ 
        Description:
        Subtract days using GDS format which is %d%b or 09SEP
        By default adjusted weekend to weekday. Set adjust_weekend_to_weekday to False to ignore adjustment

        Example:
        | ${adjusted_date} = | Subtract days In GDS Format | 09SEP  | 1 |

        =>
        ${adjusted_date} = 08SEP
        """
        converted_date = datetime.datetime.strptime(date, '%d%b')
        subtracted_date = converted_date - datetime.timedelta(days=int(day_to_subtract))
        if adjust_weekend_to_weekday == 'True':
            actual_date = self._adjust_weekend_to_weekday(subtracted_date)
            return str('{dt:%d}{dt:%b}'.format(dt=actual_date).upper())
        else:
            return str('{dt:%d}{dt:%b}'.format(dt=subtracted_date).upper())

    def subtract_days_in_syex_format(self, date, day_to_subtract, adjust_weekend_to_weekday='True'):
        """ 
        Description:
        Subtract days using Syex format which is %m/%d/%Y or 12302017
        By default adjusted weekend to weekday. Set adjust_weekend_to_weekday to False to ignore adjustment
        Example:
        | ${adjusted_date} = | Subtract days In Syex Format | 12302017  | 1 |

        =>
        ${adjusted_date} = 12292017
        """        
        converted_date = datetime.datetime.strptime(date, '%m/%d/%Y')
        subtracted_date = converted_date - datetime.timedelta(days=int(day_to_subtract))
        if adjust_weekend_to_weekday == 'True':
            actual_date = self._adjust_weekend_to_weekday(subtracted_date)
            return self._set_syex_date_format(actual_date)
        else:
            return self._set_syex_date_format(subtracted_date)

    def _set_gds_date_format(self, date, is_year_needed='false'):
        if is_year_needed.lower() == 'true':
            return str('{dt:%d}{dt:%b}{dt:%y}'.format(dt=date).upper())
        else:
            return str('{dt:%d}{dt:%b}'.format(dt=date).upper()) 

    def _set_syex_date_format(self, date):
        return str('{dt.month}/{dt.day}/{dt.year}'.format(dt=date))
    
    def _set_timestamp_format(self, date):
        return str('{dt:%Y}-{dt:%m}-{dt:%d}'.format(dt=date))	

    def _adjust_weekend_to_weekday(self, adjusted_date, operation='subtract'):
        if str(adjusted_date.weekday()) == '5':
            if operation != 'subtract':
                return adjusted_date + datetime.timedelta(days=int(2))
            else:
                return adjusted_date - datetime.timedelta(days=int(1))
        elif str(adjusted_date.weekday()) == '6':
            if operation != 'subtract':
                return adjusted_date + datetime.timedelta(days=int(1))
            else:
                return adjusted_date - datetime.timedelta(days=int(2))
        else:
            return adjusted_date

    def _add_days_to_current_day(self, day_to_add):
        return datetime.datetime.now() + datetime.timedelta(days=int(day_to_add))

    def _set_future_date(self, number_of_months, number_of_days):
        if number_of_days > 0:
            return self._add_month_to_current_date(int(number_of_months)) + datetime.timedelta(days=int(number_of_days))
        else:
            return self._add_month_to_current_date(int(number_of_months))

    def _add_month_to_current_date(self, month_to_add):
        today = datetime.date.today()
        month = today.month - 1 + month_to_add
        year = int(today.year + month / 12)
        month = month % 12 + 1
        day = min(today.day, calendar.monthrange(year, month)[1])
        future_date = datetime.date(year, month, day)
        return future_date

    def generate_random_date(self, year, date_format, strip_leading_zero_in_day=False):
        """ 
        Description:
        Generate random date using gien start, end and date format

        Usage:
        | ${new_date} = | Generate Random Date | 1980 | %m/%d/%Y |
        
        =>
        ${new_date} = 12/24/1980
        """              
        month = random.randint(1, 12)
        day = random.randint(1, 28)
        date = datetime.date(int(year),month,int(day))
        generated_date = str(date.strftime(date_format).upper())
        return generated_date if strip_leading_zero_in_day == False else generated_date.lstrip('0')

    def sort_date_list(self, date_list, date_format):
        sorted_date_list = []
        for v in sorted([datetime.datetime.strptime(d, date_format) for d in date_list]):
            sorted_date_list.append(str(v.strftime(date_format)))
        return sorted_date_list
    
    def convert_month_to_french_locale(self, month):
        """
        | ${month_french} | Convert Month To French Month | 07FEB |
        >
        07FÉVR.
        """
        converted_month = datetime.datetime.strptime(month.capitalize(), '%b')
        locale.setlocale(locale.LC_ALL, 'French_France.1252')
        return converted_month.strftime('%b').upper()

    def convert_month_to_english_locale(self, month):
        """
        Currently supports french to english locale
        | ${month_french} | Convert Month To French Month | FÉVR |
        >
        07FEB
        """
        converted_month = datetime.datetime.strptime(month.capitalize(), "%b")
        locale.setlocale(locale.LC_ALL, 'English_United States.1254')
        return converted_month.strftime('%b').upper()

    def generate_weekend_date_for_the_week(self, date_format='%m/%d/%Y'):
        """
        Generate weekend date for the week.
        """        
        day_to_add = random.randint(1, 7)
        weekend_date = datetime.datetime.now() + datetime.timedelta(days=int(day_to_add))
        if weekend_date.weekday() == 5 or weekend_date.weekday() == 6:
            return str(weekend_date.strftime(date_format))
        else:
            return self.generate_weekend_date_for_the_week()

# if __name__ == '__main__':
#     syex = SyexDateTimeLibrary()