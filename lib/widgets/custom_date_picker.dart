import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/core/application/phone_local_helper.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/locale_keys.g.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    required this.onDateChanged,
    required this.initialDate,
    required this.minimumYear,
    this.backgroundColor,
    super.key,
  });
  final String initialDate;
  final Function onDateChanged;
  final int minimumYear;
  final Color? backgroundColor;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = int.parse(widget.initialDate.split("-")[0]);
    selectedMonth = int.parse(widget.initialDate.split("-")[1]);
    yearController = FixedExtentScrollController(initialItem: 0);
    monthController = FixedExtentScrollController(initialItem: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      yearController.jumpTo((selectedYear - widget.minimumYear) * 82);
      monthController.jumpTo((selectedMonth - 1) * 82);
    });
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              LocaleKeys.customDatePicker_title,
              style: Theme.of(context).textTheme.headlineLarge,
            ).tr(),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: CupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: yearController,
                        children: List.generate(
                            (PhoneLocalHelper.phoneLocal == "ir"
                                    ? Jalali.now().year
                                    : DateTime.now().year) +
                                1 -
                                widget.minimumYear,
                            (i) => Center(
                                    child: Text(
                                  "${widget.minimumYear + i}",
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ))),
                        itemExtent: 82,
                        looping: true,
                        useMagnifier: true,
                        magnification: 1.2,
                        squeeze: 2,
                        onSelectedItemChanged: (value) {
                          selectedYear = widget.minimumYear + value;
                          debugPrint("Selected Year is : $selectedYear");
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: CupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: monthController,
                        children: List.generate(
                            12,
                            (i) => Center(
                                    child: Text(
                                  PhoneLocalHelper.phoneLocal == "ir"
                                      ? persianMonthNames[i + 1]!
                                      : gregorianMonthNames[i + 1]!,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ).tr())),
                        itemExtent: 82,
                        looping: true,
                        useMagnifier: true,
                        magnification: 1.2,
                        onSelectedItemChanged: (value) {
                          selectedMonth = value + 1;
                          debugPrint("Selected Month is : $selectedMonth");
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50,
              child: IconButton(
                  onPressed: () {
                    widget.onDateChanged("${selectedYear}-${selectedMonth}");
                  },
                  icon: Icon(Icons.check,color: Theme.of(context).iconTheme.color,)),
            ),
          )
        ],
      ),
    );
  }
}
