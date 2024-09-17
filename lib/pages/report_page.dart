import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
              decoration: BoxDecoration( borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(CupertinoIcons.arrow_right,color: Colors.white,),
              ),
            ),
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
      body: Column(
        children: [
          renderReportType(), renderReport(),
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
    return 
    Container(width: MediaQuery.of(context).size.width / 0.7, child: //Container()
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          borderWidth: 0,
          primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0,),),
          primaryYAxis: NumericAxis(isVisible: false,),
          axes: <ChartAxis>[
                       NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0,),
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
              borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
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
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true
                                ),
                        )
                    ]);
  }

  renderReportType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomDropdown(
          items: const {
            0: 'گزارش کلی',
            1: 'گزارش جزئی',
          },
          hintText: 'انتخاب نوع گزارش',
          icon: Icon(
            MdiIcons.chartLineStacked,
            size: 20,
          ),
          onChanged: (value) {
            setState(() {
              selectedDropdownValue = value;
            });
          },
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
