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
    NumberFormat formatter = NumberFormat(' ## ', 'fa_IR');
    Jalali jalaliDate  = date.toJalali();
    String formattedDatePersian = '${formatter.format(jalaliDate.year)}/${formatter.format(jalaliDate.month)}/${formatter.format(jalaliDate.day)}  ${formatter.format(jalaliDate.hour)}:${formatter.format(jalaliDate.minute)}:${formatter.format(jalaliDate.second)}';
    return formattedDatePersian ;
  }
}