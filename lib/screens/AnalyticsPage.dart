import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ola_energy/models/sales.dart';

class AnalyticsPage extends StatefulWidget {
  final Widget child;

  AnalyticsPage({Key key, this.child}) : super (key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {

  List<charts.Series<Sales, String>> _seriesBarData;
  List<charts.Series<Sales, String>> _seriesPieData;
  List<Sales> myData = [];

  _generateData(myData){
    _seriesBarData = List<charts.Series<Sales, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _)=>DateFormat().add_yMd().format(sales.date.toDate()).toString(),      //x-axis
        measureFn: (Sales sales, _) => sales.lpg,                 //y-axis
        id: 'sales',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _)=>DateFormat().add_yMd().format(sales.date.toDate()).toString(),      //x-axis
        measureFn: (Sales sales, _) => sales.lube,        //y-axis
        id: 'sales',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _)=>DateFormat().add_yMd().format(sales.date.toDate()).toString(),      //x-axis
        measureFn: (Sales sales, _) => sales.fuel,        //y-axis
        id: 'sales',
        data: myData,
        labelAccessorFn: (Sales row, _) => "Sales Weekly",
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    //pie chart
    // _seriesPieData.add(
    //   charts.Series(
    //     domainFn: (Sales sales, _) => sales.fuel.toString(),      //x-axis
    //     measureFn: (Sales sales, _) => sales.lpg,        //y-axis
    //     id: 'sales',
    //     data: myData,
    //     labelAccessorFn: (Sales row, _) => "Sales Weekly",
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sales Analysis Graphs'),
            backgroundColor: Color(0xff07239d),
            bottom: TabBar(
              indicatorColor: Color(0xff07239d),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.chartPie),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.chartLine),
                ),
              ],
            ),
          ),
          body: TabBarView(
              children: [
                _buildBody(context),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Sales for the past 4 weeks',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                          // Expanded(
                          //   child:
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Sales for the past 4 weeks',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                          // Expanded(
                          //   child:
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),

    );
  }

  Widget _buildBody(context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('fuels').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }else{
            List<Sales> sales = snapshot.data.docs
                .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data()))
                .toList();
            return _buildChart(context, sales);
          }
        },
    );
  }

  Widget _buildChart(BuildContext context, List<Sales> sales){
    myData = sales;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Sales from the past month',
                style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
              Expanded(
                  child: charts.BarChart(_seriesBarData,
                    animate: true,
                    barGroupingType:charts.BarGroupingType.grouped,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.purple.shadeDefault,
                      fontFamily: 'Georgia',
                      fontSize: 18),
                      )],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
