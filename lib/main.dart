
import 'dart:collection';

import 'package:fl_animated_linechart/chart/chart_line.dart';
import 'package:fl_animated_linechart/chart/chart_point.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double textShownOnScreenDown = 0.0;
  double rotationX = 0.0, rotationY = 0.0 , rotationZ = 0.0;

  List<double> xSamplesList = [];
  List<double> ySamplesList = [1 , 2 , 0];
  List<double> zSamplesList = [1 , 2 , 0];

  List<_ChartData>? _chartData;



  @override
  void initState() {

    super.initState();
    _fillChartData();
    sensors.accelerometerEventStream().listen((event) {
      setState(() {
        textShownOnScreenDown = math.sqrt(
                event.x * event.x +
                event.y * event.y +
                event.z * event.z);
      }
      );
    });

    sensors.gyroscopeEventStream(samplingPeriod: const Duration(microseconds: 10)).listen((event) {
      setState(() {
        rotationX += event.x;
        rotationY += event.y;
        rotationZ += event.z;
        //_fillChartData();
         //xSamplesList[];
        // ySamplesList.add(rotationY);
        // zSamplesList.add(rotationZ);
        //
        // if(xSamplesList.length >= 500) {
        //   xSamplesList.removeAt(0);
        // }

        // if(ySamplesList.length >= 500) {
        //   ySamplesList.removeAt(0);
        // }
        //
        // if(zSamplesList.length >= 500) {
        //   zSamplesList.removeAt(0);
        // }
      }
      );
    });
    



  }
  List<LineSeries<_ChartData, num>> _getDefaultLineSeries(){
    return <LineSeries<_ChartData,num>> [
      LineSeries<_ChartData,num>(dataSource: _chartData! ,
          xValueMapper: (_ChartData D, _) => D.x ,
          yValueMapper: (_ChartData D, _) => D.y)

    ];
  }

  void _fillChartData(){
    math.Random r = math.Random();
    _chartData = <_ChartData>[];
    _chartData!.clear();
    for(int i = 0; i <11; i++){
      _chartData!.add(_ChartData(i, r.nextDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SfCartesianChart(
              primaryXAxis: NumericAxis(),
              series: _getDefaultLineSeries(),
            ),
            Text(
              "x: ${rotationX.toStringAsFixed(4)}, "
                  " y: ${rotationY.toStringAsFixed(4)},"
                  "  z: ${rotationZ.toStringAsFixed(4)}"
            ),
            Text(
              //_accelerometerEvent?.x.toStringAsFixed(3) ?? 'eshanki',
              textShownOnScreenDown.toStringAsFixed(3),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

          ],
        ),
      ),
    );
  }



}




class _ChartData {
  _ChartData(this.x,this.y);

  final int x;
  final double y;
}