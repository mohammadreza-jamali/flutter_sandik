import 'package:easy_localization/easy_localization.dart';

const String OPERATIONAL_DATE_TIME_FORMAT = 'yyyy-MM-dd HH:mm:ss';

extension PersianMonthNameExt on DateTime {
  String get persianMonthName => {
        1: "فروردین",
        2: "اردیبهشت",
        3: "خرداد",
        4: "تیر",
        5: "مرداد",
        6: "شهریور",
        7: "مهر",
        8: "آبان",
        9: "آذر",
        10: "دی",
        11: "بهمن",
        12: "اسفند",
      }[month]!;
}
