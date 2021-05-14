import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ola_energy/models/sales.dart';
import 'package:date_range_picker/date_range_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';

class AnalyticsPage extends StatefulWidget {
  final Widget child;

  AnalyticsPage({Key key, this.child}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<charts.Series<Sales, String>> _seriesBarData;
  List<charts.Series<Sales, int>> _seriesLineData;
  List<Sales> myData = [];
  final pdf = pw.Document();

  _generateData(myData) {
    _seriesBarData = List<charts.Series<Sales, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();

    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) =>
            DateFormat().add_yMd().format(sales.date.toDate()).toString(),
        //x-axis
        measureFn: (Sales sales, _) => sales.lpg,
        //y-axis
        id: 'Lpg',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) =>
            DateFormat().add_yMd().format(sales.date.toDate()).toString(),
        //x-axis
        measureFn: (Sales sales, _) => sales.lube,
        //y-axis
        id: 'Lube',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) =>
            DateFormat().add_yMd().format(sales.date.toDate()).toString(),
        //x-axis
        measureFn: (Sales sales, _) => sales.fuel,
        //y-axis
        id: 'Fuel',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Lube',
        data: myData,
        domainFn: (Sales sales, _) => int.parse(
            DateFormat().add_d().format(sales.date.toDate()).toString()),
        measureFn: (Sales sales, _) => sales.lube,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Lpg',
        data: myData,
        domainFn: (Sales sales, _) => int.parse(
            DateFormat().add_d().format(sales.date.toDate()).toString()),
        measureFn: (Sales sales, _) => sales.lpg,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Fuel',
        data: myData,
        domainFn: (Sales sales, _) => int.parse(
            DateFormat().add_d().format(sales.date.toDate()).toString()),
        measureFn: (Sales sales, _) => sales.fuel,
      ),
    );
  }

  DateTime pickedDate;
  DateTime start;
  DateTime end;

  Future _pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    DateTimeRange newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 8),
      lastDate: DateTime(DateTime.now().year + 8),
      initialDateRange: initialDateRange,
    );

    if (newDateRange == null) return null;

    setState(() {
      print("Picked Date : ${newDateRange.start}");
      print("Picked Date : ${newDateRange.end}");
      start = newDateRange.start;
      end = newDateRange.end;
    });
  }

  // _pickedDate() async {
  //   DateTime date = await showDatePicker(
  //     context: context,
  //     initialDate: pickedDate,
  //     firstDate: DateTime(DateTime.now().year - 8),
  //     lastDate: DateTime(DateTime.now().year + 8),
  //   );
  //   if (date != null) {
  //     setState(() {
  //       //controllerDate = _pickedDate();
  //       pickedDate = date;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sales Analysis Graphs'),
            backgroundColor: Color(0xff07239d),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: [
              IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () => _pickDateRange(context)),
              IconButton(
                  icon: Icon(Icons.download_outlined),
                  onPressed: () async {
                    pdf.addPage(
                      pw.MultiPage(
                        build: (context) => [
                          pw.Table.fromTextArray(
                              context: context,
                              data: <List<String>>[
                                <String>[
                                  'LPG',
                                  'FUEL',
                                  'LUBE',
                                  'DateTime',
                                ],
                                ...myData.map((msg) => [
                                      msg.lpg.toString(),
                                      msg.fuel.toString(),
                                      msg.lube.toString(),
                                      msg.date.toString()
                                    ])
                              ]),
                        ],
                      ),
                    );
                    final outPut = await getExternalStorageDirectory();

                    String path = outPut.path + '/example.pdf';
                    final file = File(path);
                    file.writeAsBytesSync(pdf.save());

                    print(outPut.path);
                    Fluttertoast.showToast(msg: "Download Complete");
                  }),
            ],
            bottom: TabBar(
              indicatorColor: Color(0xff07239d),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.chartLine),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            _buildBody(context),
            _buildLineBody(context),
          ]),
        ),
      ),
    );
  }

  Widget _buildBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (end != null && start != null)
          ? FirebaseFirestore.instance
              .collection('fuels')
              .where("date", isGreaterThanOrEqualTo: start)
              .where("date", isLessThanOrEqualTo: end)
              .snapshots()
          : FirebaseFirestore.instance.collection('fuels').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          print("[ANALYSIS($start,$end)] ${snapshot.data.docs}");
          List<Sales> sales = snapshot.data.docs
              .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildLineBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (end != null && start != null)
          ? FirebaseFirestore.instance
              .collection('fuels')
              .where("date", isGreaterThanOrEqualTo: start)
              .where("date", isLessThanOrEqualTo: end)
              .snapshots()
          : FirebaseFirestore.instance.collection('fuels').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          print("[ANALYSIS($start,$end)] ${snapshot.data.docs}");
          List<Sales> sales = snapshot.data.docs
              .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data()))
              .toList();
          return _buildLine(context, sales);
        }
      },
    );
  }

  Widget _buildLine(context, List<Sales> sales) {
    myData = sales;
    _generateData(myData);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.LineChart(_seriesLineData,
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.SeriesLegend(
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      ),
                      new charts.ChartTitle('Day',
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle('Sales',
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      // new charts.ChartTitle('Departments',
                      //   behaviorPosition: charts.BehaviorPosition.end,
                      //   titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                      // )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Sales> sales) {
    myData = sales;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Sales from the past month',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  animationDuration: Duration(seconds: 2),
                  behaviors: [
                    new charts.SeriesLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectDates extends StatefulWidget {
  @override
  _SelectDatesState createState() => _SelectDatesState();
}

class _SelectDatesState extends State<SelectDates> {
  DateTime pickedDateRange;

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 8),
      lastDate: DateTime(DateTime.now().year + 8),
      initialDateRange: pickedDateRange ?? initialDateRange,
    );

    if (newDateRange == null) return null;

    setState(() {
      pickedDateRange = newDateRange as DateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: OutlineButton(
        padding: EdgeInsets.symmetric(horizontal: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          pickDateRange;
        },
        child: Text("Select Date Range",
            style: TextStyle(
                fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
      ),
    );
  }
}
