import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales.dart';
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

  @override
  void initState() {
    super.initState();
    _currentUserId();
    _fetchStoredData();
  }

  String employeeId, userEmail, stationId, accType;
  Future _fetchStoredData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    // print("Fetched from shared p ${_sp.getString("employeeId")}");
    setState(() {
      employeeId = _sp.getString("employeeId");
      userEmail = _sp.getString("email");
      stationId = _sp.getString("stationId");
      accType = _sp.getString("accType");
    });
    print('----------------------------------------------------------');
    print(accType);
  }

  _generateData(myData) {
    _seriesBarData = [];
    _seriesLineData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => DateFormat()
            .add_yMd()
            .format(sales.date.toDate())
            .toString(), //x-axis
        measureFn: (Sales sales, _) => sales.lpg, //y-axis
        id: 'Lpg',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff517664)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => DateFormat()
            .add_yMd()
            .format(sales.date.toDate())
            .toString(), //x-axis
        measureFn: (Sales sales, _) => sales.lube, //y-axis
        id: 'Lube',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffE6D517)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => DateFormat()
            .add_yMd()
            .format(sales.date.toDate())
            .toString(), //x-axis
        measureFn: (Sales sales, _) => sales.fuel, //y-axis
        id: 'Fuel',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff9E2B25)),
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff9E2B25)),
        id: 'Lube',
        data: myData,
        domainFn: (Sales sales, _) => int.parse(
            DateFormat().add_d().format(sales.date.toDate()).toString()),
        measureFn: (Sales sales, _) => sales.lube,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff517664)),
        id: 'Lpg',
        data: myData,
        domainFn: (Sales sales, _) => int.parse(
            DateFormat().add_d().format(sales.date.toDate()).toString()),
        measureFn: (Sales sales, _) => sales.lpg,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffE6D517)),
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

  String uid;
  Future<String> _currentUserId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      uid = user.uid;
    });
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: accType == "Filling Station Attendant #OEEM02C"
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Sales Analysis Reports'),
                  backgroundColor: Color(0xff322C40),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('You do NOT have authorization to view this page',
                          style: TextStyle(
                              color: Color(0xff322C40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.1),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.1,
                            color: Color(0xff322C40),
                            child: Center(
                                child: Text(
                              'Go Back',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Sales Analysis Reports'),
                  backgroundColor: Color(0xff322C40),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.date_range_outlined),
                        onPressed: () => _pickDateRange(context)),
                    IconButton(
                        icon: Icon(Icons.download_outlined),
                        onPressed: () async {
                          pdf.addPage(
                            pw.MultiPage(
                              build: (context) => [
                                pw.Text("Monthly Data"),
                                pw.Table.fromTextArray(
                                    context: context,
                                    data: <List<String>>[
                                      <String>[
                                        'LPG (litres)',
                                        'FUEL (litres)',
                                        'LUBE (liters)',
                                        'Date This Month',
                                      ],
                                      ...myData.map((msg) => [
                                            msg.lpg.toString(),
                                            msg.fuel.toString(),
                                            msg.lube.toString(),
                                            msg.date.toDate().day.toString(),
                                          ])
                                    ]),
                              ],
                            ),
                          );
                          final outPut = await getExternalStorageDirectory();

                          String path = outPut.path + '/monthly report.pdf';
                          final file = File(path);
                          // I changed here
                          //file.writeAsBytesSync(pdf.save());

                          print(outPut.path);
                          Fluttertoast.showToast(msg: "Download Complete");
                        }),
                  ],
                  bottom: TabBar(
                    indicatorColor: Color(0xff322C40),
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
              .where("stationId", isEqualTo: stationId)
              .where("date", isGreaterThanOrEqualTo: start)
              .where("date", isLessThanOrEqualTo: end)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('fuels')
              .where("stationId", isEqualTo: stationId)
              .snapshots(),
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
              .where("userId", isEqualTo: uid)
              .where("date", isGreaterThanOrEqualTo: start)
              .where("date", isLessThanOrEqualTo: end)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('fuels')
              .where("userId", isEqualTo: uid)
              .snapshots(),
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
                    ),
                    new charts.ChartTitle('Date',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle('Products(litres)',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
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
