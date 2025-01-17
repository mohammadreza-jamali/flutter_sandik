import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/core/application/phone_local_helper.dart';
import 'package:flutter_sandik/core/constants/core_enum.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
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

Map<int, String> reportType = {
  0: 'گزارش کلی',
  1: 'گزارش ماهانه',
  2: 'گزارش برحسب دسته بندی',
};

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
  String? selectedCategory;
  String? selectedDate;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        format: 'point.x : point.y',
        header: '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Theme.of(context).iconTheme.color!)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  CupertinoIcons.arrow_left,
                  size: 24,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'گزارش گیری',
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
                style: Theme.of(context).textTheme.headlineMedium,
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
                  var res = await _reportTypeBottomSheet(
                      context, selectedReportType ?? 0);
                  if (res != null&& mounted) {
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
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SelectionBox(
                        width: MediaQuery.of(context).size.width,
                        heght: 40,
                        title: selectedDate ?? getNow(),
                        icon: MdiIcons.calendarMonth,
                        spinner: false,
                        onTap: () async {
                          var res = await _monthCalendarBottomSheet(
                              context, selectedDate ?? getNow());
                          if (res != null&& mounted) {
                            setState(() {
                              selectedDate = res;
                            });
                          }
                        }),
                  ],
                ),
              ),
            if ((selectedReportType ?? 0) == 2)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'انتخاب دسته',
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SelectionBox(
                        width: MediaQuery.of(context).size.width,
                        heght: 40,
                        title: selectedCategory ?? "یک دسته بندی انتخاب کنید",
                        icon: MdiIcons.arrangeBringForward,
                        spinner: false,
                        onTap: () async {
                          var res = await _categoryReportBottomSheet(
                              context, widget.groupId);

                              if (res != null && mounted) {
                            setState(() {
                              selectedCategory = res;
                            });
                          }
                        }),
                  ],
                ),
              ),
            FutureBuilder<Widget>(
              future: renderReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
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
        return await getMonthReport(selectedDate ?? getNow());
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

  renderReportType(
      Map<int, String> items, String hintText, Icon icon, Function? onChanged) {
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
    var _transactions =
        await _transaction.getTransactionsMonthlyReport(widget.groupId);
    final List<ChartData> chartData = _transactions
            ?.map((monthTransaction) => ChartData(
                  "${monthTransaction.month!.substring(0, 4)}-${persianMonthNames[int.parse(monthTransaction.month!.substring(4))]}",
                  monthTransaction.sum?.toInt() ?? 0,
                ))
            .toList() ??
        [];
    final List<ChartData> budgets = _transactions
            ?.map((monthTransaction) => ChartData(
                  "${monthTransaction.month!.substring(0, 4)}-${persianMonthNames[int.parse(monthTransaction.month!.substring(4))]}",
                  monthTransaction.plannedBudget?.toInt() ?? 0,
                ))
            .toList() ??
        [];
    var maxValue = (_transactions
                ?.map((transaction) => transaction.sum ?? 0)
                .toList()
                .reduce(max) ??
            0) +
        1000;
        if (mounted) {
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
          primaryYAxis:
              NumericAxis(isVisible: false, minimum: 0, maximum: maxValue),
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            )
          ],
          tooltipBehavior: _tooltipBehavior,
        ),
      ),
    );
        }
        else{
          return Center();
        }
    
  }

  Future<Widget> getMonthReport(String date) async {
    final _transaction = context.read<MTransaction>();
    var inputDateString = "";
    if (PhoneLocalHelper.phoneLocal == "ir") {
      var inputDate =
          Jalali(int.parse(date.split("-")[0]), int.parse(date.split("-")[1]));
      inputDateString =
          "${inputDate.year.toString().padLeft(2, "0")}${inputDate.month.toString().padLeft(2, "0")}";
    } else {
      var inputDate = DateTime(
          int.parse(date.split("-")[0]), int.parse(date.split("-")[1]));
      inputDateString =
          "${inputDate.year.toString().padLeft(2, "0")}${inputDate.month.toString().padLeft(2, "0")}";
    }
    var _transactions =
        await _transaction.getTransactions(widget.groupId, inputDateString);
    var groupTransactions = groupBy(
      _transactions ?? <MoneyTransaction>[],
      (MoneyTransaction transaction) => transaction.categoryId,
    );

    var monthBudget =
        await _transaction.getMonthBudget(widget.groupId, inputDateString);
    var categories = await _transaction.getAllCategories(widget.groupId);
    var maxValue = 0.0;
    List<TransactionPerCategory>? tempTransactions = [];
    for (var group in groupTransactions.entries) {
      double _sum = 0;
      var category = await categories.firstWhere((category) =>
          category.categoryId == group.value.firstOrNull?.categoryId);
      for (var transaction in group.value) {
        _sum += transaction.amount!;
      }
      if (_sum > maxValue) maxValue = _sum;
      group.value.sort((a, b) => a.insertDate!.compareTo(b.insertDate!));
      tempTransactions
          .add(TransactionPerCategory(sum: _sum, category: category));
    }

    final List<ChartData> chartData = tempTransactions
        .map((transaction) => ChartData(
            "${transaction.category?.categoryName ?? "Default"}",
            transaction.sum?.toInt() ?? 0))
        .toList();

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
          primaryYAxis: NumericAxis(
              isVisible: false,
              minimum: 0,
              maximum: monthBudget?.budgetValue ?? 1.0),
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
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.top,
                  textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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

  Future<List<Category>> getAllCategories() async {
    return await _transaction.getAllCategories(widget.groupId);
  }

  getNow() {
    return PhoneLocalHelper.phoneLocal == "ir"
        ? "${Jalali.now().year}-${Jalali.now().month}"
        : "${DateTime.now().year}-${DateTime.now().month}";
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
      {super.key,
      required this.width,
      required this.heght,
      required this.title,
      this.icon,
      required this.spinner,
      required this.onTap,
      this.isSelected});

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
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 1, color: Colors.blue.shade200))),
            padding:
                WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))),
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
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'انتخاب نوع گزارش',
                          style: Theme.of(context).textTheme.headlineLarge,
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
                              shadowColor: selectIndex == 0
                                  ? Colors.blue.shade500
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 0
                                  ? Theme.of(context).cardTheme.color
                                  : Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 0
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide.none)
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Colors.blue.shade200)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش کلی',
                                      textDirection: TextDirection.rtl,
                                      style: selectIndex == 0
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.white)
                                          : Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.black),
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
                              shadowColor: selectIndex == 1
                                  ? Colors.blue.shade500
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 1
                                  ? Theme.of(context).cardTheme.color
                                  : Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 1
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide.none)
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Colors.blue.shade200)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش ماهانه',
                                      textDirection: TextDirection.rtl,
                                      style: selectIndex == 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.white)
                                          : Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.black),
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
                              shadowColor: selectIndex == 2
                                  ? Colors.blue.shade500
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 2
                                  ? Theme.of(context).cardTheme.color
                                  : Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: selectIndex == 2
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide.none)
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Colors.blue.shade200)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'گزارش بر حسب دسته بندی',
                                      textDirection: TextDirection.rtl,
                                      style: selectIndex == 1
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.white)
                                          : Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      });
}

Future<List<Category>> getAllCategories(
    BuildContext context, String groupId) async {
  var _transaction = context.read<MTransaction>();
  return await _transaction.getAllCategories(groupId);
}

Future<String?> _categoryReportBottomSheet(
    BuildContext context, String groupId) async {
      String? selectedItem;
  return await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: FutureBuilder(
                        future: getAllCategories(context, groupId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.data!.isNotEmpty
                                ? CategorySelectionGridView(
                                    snapshot.data!.toList(),(item){
                                      selectedItem=item.categoryName.toString();
                                      Navigator.pop(context, selectedItem);
                                    })
                                : Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child:
                                                Assets.images.emptyPage.image(),
                                          ),
                                        ),
                                        Text(
                                          'دسته بندی نداری!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'میتوانید برای خود دسته بندی ایجاد کنید.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500),
                                          textDirection: TextDirection.rtl,
                                        ),
                                        SizedBox(
                                          height: 32,
                                        )
                                      ],
                                    ),
                                  );
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          }
                          return CircularProgressIndicator();
                        },
                      )),
                ));
      });
}

Future<String?> _monthCalendarBottomSheet(
    BuildContext context, String initDate) async {
  var selectedDate = initDate;
  return await showModalBottomSheet<String?>(
    context: context,
    builder: (context) => CustomDatePicker(
      initialDate: selectedDate,
      minimumYear: PhoneLocalHelper.phoneLocal == "ir"
          ? Jalali.now().year - 10
          : DateTime.now().year - 10,
      onDateChanged: (value) {
        selectedDate = value;
        Navigator.pop(context, selectedDate);
      },
    ),
  );
}

Future<String?> _dateDurationCalendarBottomSheet(
    BuildContext context, String initDate) async {
  return await showModalBottomSheet<String?>(
    context: context,
    builder: (context) => PersianCalendarTable(),
  );
}

Future<int?> _categoryBottomSheet(BuildContext context, String initDate) async {
  return await showModalBottomSheet<int?>(
      context: context, builder: (context) => SizedBox());
}

class CategorySelectionGridView extends StatefulWidget {
  final List<Category> Categories;
    final Function(Category selectedItem) onTap;

  CategorySelectionGridView(this.Categories, this.onTap);

  @override
  State<CategorySelectionGridView> createState() =>
      _CategorySelectionGridViewState();
}

class _CategorySelectionGridViewState extends State<CategorySelectionGridView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: widget.Categories.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 1,
              maxCrossAxisExtent: 145,
              mainAxisExtent: 140),
          itemBuilder: (context, position) {
            return CategorySelectionGridViewItem(
              item: widget.Categories[position],
              onTap: (item) {
                if (mounted) {
                  setState(() {
                  widget.onTap(item);
                });
                }
              },
            );
          }),
    );
  }
}

class CategorySelectionGridViewItem extends StatefulWidget {
  final Category item;
final Function(Category selectedItem) onTap ;
  CategorySelectionGridViewItem({
    required this.onTap,
    required this.item,
  });

  @override
  State<CategorySelectionGridViewItem> createState() =>
      _CategorySelectionGridViewItemState();
}

class _CategorySelectionGridViewItemState
    extends State<CategorySelectionGridViewItem> {
  bool selectFlag = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
          widget.onTap(widget.item);
          selectFlag ? selectFlag=false : selectFlag=true;
        });
        }
      },
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selectFlag
                  ? Color.fromARGB(255, 21, 60, 96)
                  : Color(0xffBCDFFF),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 19, 125, 157), blurRadius: 0.8)
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.fromString(widget.item.icon!),
                    color: selectFlag?Colors.white:Color(0xff1F50D3)),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.item.categoryName!,
                  style: TextStyle(
                      color: selectFlag?Colors.white :Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
