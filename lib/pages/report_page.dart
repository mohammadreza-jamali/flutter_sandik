import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? selectedDropdownValue;

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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  CupertinoIcons.arrow_right,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'گزارش گیری',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: Column(
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SelectionBox(
              width: MediaQuery.of(context).size.width,
              heght: 40,
              title: 'گزارش کلی',
              icon: MdiIcons.finance,
              spinner: true,
              onTap: () {
                _reportTypeBottomSheet(context);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SelectionBox(
              width: MediaQuery.of(context).size.width,
              heght: 40,
              title: 'مهر 1403 ',
              icon: MdiIcons.calendarMonth,
              spinner: false,
              onTap: (){
                _monthCalendarBottomSheet(context);
              }
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child:

          //   renderReportType(
          //     {
          //       0: 'گزارش کلی',
          //       1: 'گزارش جزئی',
          //     },
          //     'انتخاب نوع گزارش',
          //     Icon(
          //       MdiIcons.chartLineStacked,
          //       size: 20,
          //     ),
          //     (value) {
          //       setState(() {
          //         selectedDropdownValue = value;
          //       });
          //     },
          //   ),
          // ),

          // Row(
          //   children: [
          //     Expanded(
          //         child: Padding(
          //       padding: const EdgeInsets.fromLTRB(8, 0, 4, 16),
          //       child: renderReportType(
          //         {
          //           0: 'غذا و خوراک',
          //           1: 'حمل و نقل ',
          //         },
          //         'انتخاب دسته بندی',
          //         Icon(
          //           MdiIcons.chartLineStacked,
          //           size: 20,
          //         ),
          //         (value) {
          //           setState(() {
          //             selectedDropdownValue = value;
          //           });
          //         },
          //       ),
          //     )),
          //     Expanded(
          //         child: Padding(
          //       padding: const EdgeInsets.fromLTRB(4, 0, 8, 16),
          //       child: renderReportType(
          //         {
          //           0: 'گزارش کلی',
          //           1: 'گزارش جزئی',
          //         },
          //         'انتخاب نوع گزارش',
          //         Icon(
          //           MdiIcons.chartLineStacked,
          //           size: 20,
          //         ),
          //         (value) {
          //           setState(() {
          //             selectedDropdownValue = value;
          //           });
          //         },
          //       ),
          //     )),
          //   ],
          // ),
          renderReport(),
          //renderPieReport()
        ],
      ),
    ));
  }

  renderReport() {
    final List<ChartData> chartData = [
      ChartData("اردیبهشت", 35),
      ChartData("خرداد", 23),
      ChartData("تیر", 34),
      ChartData("مرداد", 25),
      ChartData("شهریور", 40)
    ];
    return Container(
      width: MediaQuery.of(context).size.width / 0.7,
      child: //Container()
          SfCartesianChart(
              plotAreaBorderWidth: 0,
              borderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(
                  width: 0,
                ),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
              ),
              axes: <ChartAxis>[
            NumericAxis(
              majorGridLines: const MajorGridLines(
                width: 0,
              ),
              name: 'yAxis1',
              interval: 1000,
              minimum: 0,
              maximum: 7000,
            )
          ],
              series: <CartesianSeries<ChartData, String>>[
            // Renders column chart
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            )
          ]),
    );
  }

  renderPieReport() {
    final List<ChartData> chartData = [
      ChartData("1", 35),
      ChartData("2", 23),
      ChartData("3", 34),
      ChartData("4", 25),
      ChartData("5", 40)
    ];
    return SfCircularChart(
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => "${data.x} : ${data.y}%",
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ]);
  }

  renderReportType(
      Map<int, String> items, String hintText, Icon icon, Function? onChanged) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomDropdown(
        items: items,
        hintText: hintText,
        icon: icon,
        onChanged: onChanged,
      ),
    );
  }
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
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled))
                return Colors.grey.shade800;
              if (states.contains(WidgetState.selected))
                return Colors.grey.shade200;
              return null;
            }),
            shape: WidgetStatePropertyAll(isSelected == true
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 1, color: Colors.blue.shade200))),
            padding:
                WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))),
        onPressed: (){
          onTap();
        },
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      icon != null ? Icon(icon) : SizedBox(),
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

Future _reportTypeBottomSheet(BuildContext context) {
  int selectIndex = 0;
  return showModalBottomSheet(
      backgroundColor: Color(0xff03001C),
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
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 0
                                  ? Colors.blue.shade200
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 0
                                  ? Colors.grey.shade800
                                  : Colors.transparent,
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
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
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 1
                                  ? Colors.blue.shade200
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 1
                                  ? Colors.grey.shade800
                                  : Colors.transparent,
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
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
                            },
                            radius: 64,
                            child: Card(
                              shadowColor: selectIndex == 2
                                  ? Colors.blue.shade200
                                  : Colors.transparent,
                              elevation: 10,
                              color: selectIndex == 2
                                  ? Colors.grey.shade800
                                  : Colors.transparent,
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
                                      'گزارش بازه دلخواه',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
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

Future _monthCalendarBottomSheet(BuildContext context) async{
Jalali? pickedDate = await showModalBottomSheet<Jalali>(
  context: context,
  builder: (context){
    Jalali tempPickedDate;
    return Container(
    height: 250,
    child: PCupertinoDatePicker(
                mode: PCupertinoDatePickerMode.date,
                onDateTimeChanged: (Jalali dateTime) {
                  tempPickedDate = dateTime;
                },
  ) 
);});
}