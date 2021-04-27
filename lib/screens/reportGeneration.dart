import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_officechart/officechart.dart';

class GenerateReport extends StatefulWidget {
  @override
  _GenerateReportState createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Generate Reports'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            FlatButton(
                onPressed: generateExcel,
                child: Text(
                  'Generate Excel',
                  style: TextStyle(color: Colors.white),
                ),
              color: Color(0xff07239d),
            ),
          ]
        ),
      ),
    );
  }

  Future<void> generateExcel() async
  {
    //Create a Excel document.
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index.
    final Worksheet sheet = workbook.worksheets[0];
    // Set the text value.
    //sheet.getRangeByName('A1').setText('Hello!!');
    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    sheet.enableSheetCalculations();

    //Adding the chart
    final ChartCollection charts = ChartCollection(sheet);
    final Chart chart = charts.add();   //add the chart
    chart.chartType = ExcelChartType.bar;
    chart.chartType = ExcelChartType.pie;
    chart.chartType = ExcelChartType.line;
    sheet.charts = charts;

    //Dispose the document.
    workbook.dispose();

    //Get the storage folder location using path_provider package.
    final Directory directory = await getExternalStorageDirectory();
    //Get directory path
    final String path = directory.path;
    //Create an empty file to write Excel data
    final File file = File('$path/output.xlsx, ');
    //Write Excel data
    await file.writeAsBytes(bytes, flush: true);
    //Launch the file (used open_file package)
    await OpenFile.open('$path/output.xlsx');
  }
}

