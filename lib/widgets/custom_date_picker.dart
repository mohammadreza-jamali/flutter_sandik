import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CustomDatePicker extends StatefulWidget {
   const CustomDatePicker({
    required this.onDateChanged,
    required this.initialDate,
    required this.minimumYear,
    this.backgroundColor,
    super.key,
  });
  final Jalali initialDate;
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
  Map<int,String> monthNames={
    1:"Farvardin",
    2:"ordibehesht",
    3:"xordad",
    4:"tir",
    5:"mordad",
    6:"shahrivar",
    7:"mehr",
    8:"aban",
    9:"azar",
    10:"dey",
    11:"bahman",
    12:"esfand",
  };

@override
void initState() {
  super.initState();
  yearController=FixedExtentScrollController(initialItem: 0);
  monthController=FixedExtentScrollController(initialItem: 0);
  selectedYear=widget.initialDate.year;
  selectedMonth=widget.initialDate.month;
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
      height: 300,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width/2 - 20,
            child: CupertinoPicker(
              backgroundColor: widget.backgroundColor,
              scrollController: yearController,
              children: List.generate(Jalali.now().year+1 - widget.minimumYear, (i)=>Center(child: Text("${widget.minimumYear+i}"))),
              itemExtent: 82,
              looping: true,
              useMagnifier: true,
              magnification: 1.2,
              squeeze: 2,
              onSelectedItemChanged: (value) {
                selectedYear=value;
                debugPrint("Selected Year is : $value");
              },
            ),
          ),
         SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 20,
            child: CupertinoPicker(
              backgroundColor: widget.backgroundColor,
              scrollController: monthController,
              children: List.generate(12,
                  (i) => Center(child: Text(monthNames[i+1]!))),
              itemExtent: 82,
              looping: true,
              useMagnifier: true,
              magnification: 1.2,
              onSelectedItemChanged: (value) {
                selectedMonth = value;
                debugPrint("Selected Month is : $value");
              },
            ),
          )
        ],
      ),
    );
  }
}