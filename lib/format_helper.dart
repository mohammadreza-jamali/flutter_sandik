import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shamsi_date/shamsi_date.dart';

class FormatHelper {
  
  static String numberFormatter(double? number) {
    NumberFormat formatter = NumberFormat(' #,### ', 'fa_IR');
    String formattedNumber = formatter.format(number);
    return(formattedNumber);
  }

  static String dateFormatter(DateTime date){
    Jalali jalaliDate  = date.toJalali();
    String formattedDatePersian = '${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}  ${jalaliDate.hour}:${jalaliDate.minute}:${jalaliDate.second}';
    return formattedDatePersian ;
  }
}