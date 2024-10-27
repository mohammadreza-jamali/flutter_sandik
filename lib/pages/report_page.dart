import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/core/application/phone_local_helper.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/widgets/custom_date_picker.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:flutter_sandik/widgets/persian_calendar_table.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Map<int, String> reportType = {0: 'گزارش کلی', 1: 'گزارش ماهانه', 2: 'گزارش بازه دلخواه'};

class ReportPage extends StatefulWidget {
  final String groupId;
  const ReportPage(this.groupId, {super.key});
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Category>? _categories;
  late MTransaction _transaction;
  int? selectedDropdownValue;
  int? selectedReportType;
  String? selectedDate;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false, format: 'point.x : point.y', header: '');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff050119),
      appBar: AppBar(
        backgroundColor: Color(0xff050119),
        foregroundColor: Color(0xff050119),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  CupertinoIcons.arrow_right,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'گزارش گیری',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'نوع گزارش',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SelectionBox(
                width: MediaQuery.of(context).size.width,
                heght: 40,
                title: reportType[selectedReportType ?? 0]!,
                icon: MdiIcons.finance,
                spinner: true,
                onTap: () async {
                  var res = await _reportTypeBottomSheet(context, selectedReportType ?? 0);
                  if (res != null) {
                    setState(() {
                      selectedReportType = res;
                    });
                  }
                },
              ),
            ),
            if ((selectedReportType ?? 0) == 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'انتخاب ماه',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SelectionBox(
                        width: MediaQuery.of(context).size.width,
                        heght: 40,
                        title: selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}",
                        icon: MdiIcons.calendarMonth,
                        spinner: false,
                        onTap: () async {
                          var res = await _monthCalendarBottomSheet(context, selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}");
                          if (res != null) {
                            setState(() {
                              selectedDate = res;
                            });
                          }
                        }),
                  ],
                ),
              ),

            if ((selectedReportType ?? 0) == 2)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                'تا تاریخ',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          SelectionBox(
                              width: double.maxFinite,
                              heght: 40,
                              title: selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}",
                              icon: MdiIcons.calendarMonth,
                              spinner: false,
                              onTap: () async {
                                var res = await _dateDurationCalendarBottomSheet(context, selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}");
                                if (res != null) {
                                  setState(() {
                                    selectedDate = res;
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                'از تاریخ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          SelectionBox(
                              width: double.maxFinite,
                              heght: 40,
                              title: selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}",
                              icon: MdiIcons.calendarMonth,
                              spinner: false,
                              onTap: () async {
                                var res = await _dateDurationCalendarBottomSheet(context, selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}");
                                if (res != null) {
                                  setState(() {
                                    selectedDate = res;
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            FutureBuilder<Widget>(
              future: renderReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return snapshot.data!;
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    ));
  }

  Future<Widget> renderReport() async {
    switch (selectedReportType ?? 0) {
      case 0:
        return await getTotalReport();
      case 1:
        return await getMonthReport(selectedDate ?? "${Jalali.now().year}-${Jalali.now().month}");
      default:
        return Future.value(Center(
          child: Text(" invalid Value"),
        ));
    }
  }

  // renderPieReport() {
  //   final List<ChartData> chartData = [ChartData("1", 35), ChartData("2", 23), ChartData("3", 34), ChartData("4", 25), ChartData("5", 40)];
  //   return SfCircularChart(legend: Legend(isVisible: true), series: <CircularSeries>[
  //     // Render pie chart
  //     PieSeries<ChartData, String>(
  //       dataSource: chartData,
  //       xValueMapper: (ChartData data, _) => data.x,
  //       yValueMapper: (ChartData data, _) => data.y,
  //       dataLabelMapper: (ChartData data, _) => "${data.x} : ${data.y}%",
  //       dataLabelSettings: DataLabelSettings(isVisible: true),
  //     )
  //   ]);
  // }

  renderReportType(Map<int, String> items, String hintText, Icon icon, Function? onChanged) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomDropdown(
        items: items,
        hintText: hintText,
        icon: icon,
        onChanged: onChanged,
        selectedValue: 0,
      ),
    );
  }

  Future<Widget> getTotalReport() async {
    final _transaction = context.read<MTransaction>();
    var _transactions = await _transaction.getTransactionsMonthlyReport(widget.groupId);
    final List<ChartData> chartData = _transactions
            ?.map((monthTransaction) => ChartData(
                  "${monthTransaction.month!.substring(0, 4)}-${monthNames[int.parse(monthTransaction.month!.substring(4))]}",
                  monthTransaction.sum?.toInt() ?? 0,
                ))
            .toList() ??
        [];
    final List<ChartData> budgets = _transactions
            ?.map((monthTransaction) => ChartData(
                  "${monthTransaction.month!.substring(0, 4)}-${monthNames[int.parse(monthTransaction.month!.substring(4))]}",
                  monthTransaction.plannedBudget?.toInt() ?? 0,
                ))
            .toList() ??
        [];
    var maxValue = (_transactions?.map((transaction) => transaction.sum ?? 0).toList().reduce(max) ?? 0) + 1000;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: MediaQuery.of(context).size.width / 0.7,
        child: //Container()
            SfCartesianChart(
          plotAreaBorderWidth: 0,
          borderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(
              width: 0,
            ),
            labelRotation: 45,
          ),
          primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: maxValue),
          axes: <ChartAxis>[
            NumericAxis(
              majorGridLines: const MajorGridLines(
                width: 0,
              ),
              name: 'yAxis1',
              interval: 1000,
              minimum: 0,
              maximum: maxValue,
            )
          ],
          series: <CartesianSeries<ChartData, String>>[
            // Renders column chart
            ColumnSeries<ChartData, String>(
              dataSource: budgets,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            )
          ],
          tooltipBehavior: _tooltipBehavior,
        ),
      ),
    );
  }

  Future<Widget> getMonthReport(String date) async {
    final _transaction = context.read<MTransaction>();
    var inputDateString = "";
    if (PhoneLocalHelper.phoneLocal == "ir") {
      var inputDate = Jalali(int.parse(date.split("-")[0]), int.parse(date.split("-")[1]));
      inputDateString = "${inputDate.year.toString().padLeft(2, "0")}${inputDate.month.toString().padLeft(2, "0")}";
    } else {
      var inputDate = DateTime(int.parse(date.split("-")[0]), int.parse(date.split("-")[1]));
      inputDateString = "${inputDate.year.toString().padLeft(2, "0")}${inputDate.month.toString().padLeft(2, "0")}";
    }
    var _transactions = await _transaction.getTransactions(widget.groupId, inputDateString);
    var groupTransactions = groupBy(
      _transactions ?? <MoneyTransaction>[],
      (MoneyTransaction transaction) => transaction.categoryId,
    );

    var monthBudget = await _transaction.getMonthBudget(widget.groupId, inputDateString);
    var categories = await _transaction.getAllCategories(widget.groupId);
    var maxValue = 0.0;
    List<TransactionPerCategory>? tempTransactions = [];
    for (var group in groupTransactions.entries) {
      double _sum = 0;
      var category = await categories.firstWhere((category) => category.categoryId == group.value.firstOrNull?.categoryId);
      for (var transaction in group.value) {
        _sum += transaction.amount!;
      }
      if (_sum > maxValue) maxValue = _sum;
      group.value.sort((a, b) => a.insertDate!.compareTo(b.insertDate!));
      tempTransactions.add(TransactionPerCategory(sum: _sum, category: category));
    }

    final List<ChartData> chartData =
        tempTransactions.map((transaction) => ChartData("${transaction.category?.categoryName ?? "Default"}", transaction.sum?.toInt() ?? 0)).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: MediaQuery.of(context).size.width / 0.7,
        child: //Container()
            SfCartesianChart(
          plotAreaBorderWidth: 0,
          borderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(
              width: 0,
            ),
            labelRotation: 45,
          ),
          primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: monthBudget?.budgetValue ?? 1.0),
          axes: <ChartAxis>[
            NumericAxis(
              majorGridLines: const MajorGridLines(
                width: 0,
              ),
              name: 'yAxis1',
              minimum: 0,
              interval: 100,
              maximum: monthBudget?.budgetValue ?? 1.0,
            )
          ],
          series: <CartesianSeries<ChartData, String>>[
            // Renders column chart
            ColumnSeries<ChartData, String>(
              dataLabelSettings:
                  const DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top, textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            )
          ],
          tooltipBehavior: _tooltipBehavior,
        ),
      ),
    );
  }

  Future<List<Category>> getCategories(bool isDefault) async {
    return await _transaction.getCategories(widget.groupId, isDefault);
  }
}

class TransactionPerCategory {
  final double? sum;
  final Category? category;

  TransactionPerCategory({required this.sum, required this.category});
}

class ReportResult {
  final List<ChartData> transactions;
  final List<ChartData> budgets;
  final double chartMaxValue;

  ReportResult(this.transactions, this.budgets, this.chartMaxValue);
}

class SelectionBox extends StatelessWidget {
  final double width;
  final double heght;
  final String title;
  final IconData? icon;
  final bool spinner;
  final bool? isSelected;
  final Function onTap;

  const SelectionBox(
      {super.key, required this.width, required this.heght, required this.title, this.icon, required this.spinner, required this.onTap, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heght,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.grey.shade800),
            // .resolveWith<Color?>(
            //     (Set<WidgetState> states) {
            //   if (states.contains(WidgetState.disabled))
            //     return Colors.grey.shade800;
            //   if (states.contains(WidgetState.selected))
            //     return Colors.grey.shade200;
            //   return null;
            // }),
            shape: WidgetStatePropertyAll(isSelected == true
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, color: Colors.blue.shade200))),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))),
        onPressed: () {
          onTap();
        },
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      icon != null
                          ? Icon(
                              icon,
                              color: Colors.white,
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                spinner
                    ? Icon(
                        MdiIcons.triangleSmallDown,
                        color: Colors.white,
                      )
                    : SizedBox(),
              ],
            )),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

Future<int?> _reportTypeBottomSheet(BuildContext context, int selected) async {
  int selectIndex = selected;
  return await showModalBottomSheet<int>(
      backgroundColor: Color(0xff03001C),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'انتخاب نوع گزارش',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // SelectionBox(width: MediaQuery.of(context).size.width, heght: 48, title: 'گزارش کلی', icon:MdiIcons.finance,spinner: false),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 0;
                              });
                              Navigator.pop(context, selectIndex);
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 0 ? Colors.blue.shade200 : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 0 ? Colors.grey.shade800 : Colors.transparent,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 0
                                  ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none)
                                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.shade200)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش کلی',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 1;
                              });
                              Navigator.pop(context, selectIndex);
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 1 ? Colors.blue.shade200 : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 1 ? Colors.grey.shade800 : Colors.transparent,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 1
                                  ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none)
                                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.shade200)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش ماهانه',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 2;
                              });
                              Navigator.pop(context, selectIndex);
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 2 ? Colors.blue.shade200 : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 2 ? Colors.grey.shade800 : Colors.transparent,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 2
                                  ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none)
                                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.shade200)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش بازه دلخواه',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
      });
}

Future<String?> _monthCalendarBottomSheet(BuildContext context, String initDate) async {
  var selectedDate = initDate;
  return await showModalBottomSheet<String?>(
    context: context,
    builder: (context) => CustomDatePicker(
      initialDate: selectedDate,
      minimumYear: 1390,
      onDateChanged: (value) {
        selectedDate = value;
        Navigator.pop(context, selectedDate);
      },
      backgroundColor: Colors.white,
    ),
  );
}

Future<String?> _dateDurationCalendarBottomSheet(BuildContext context, String initDate) async {
  return await showModalBottomSheet<String?>(
    context: context,
    builder: (context) => PersianCalendarTable(),
  );
}

Future<int?> _categoryBottomSheet(BuildContext context, String initDate) async {
  var categoryId;
  return await showModalBottomSheet<int?>(context: context, builder: (context) => SizedBox());
}
