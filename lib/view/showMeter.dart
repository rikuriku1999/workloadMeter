import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workload_meter/importer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RealTimeData(),
    );
  }
}

class RealTimeData extends StatefulWidget {
  @override
  _RealTimeDataState createState() => _RealTimeDataState();
}

class _RealTimeDataState extends State<RealTimeData> {
  Map<String, dynamic> data = {};
  late double workloadLevel = 4;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  Future fetchData() async {
    var response = await http.get(Uri.parse('http://192.168.0.113:5000/data'));
    if (response.statusCode == 200) {
      var newData = jsonDecode(response.body);
      setState(() {
        data = newData;
        workloadLevel = newData["value"]
            .toDouble(); // サーバーからのレスポンスの"value"フィールドをdouble型にキャストしてworkloadLevelに設定
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real Time Data')),
      body: Center(
          child: Column(
        children: [
          _getLinearGauge(),
          // Text('Data: ${data.toString()}'),
        ],
      )),
    );
  }

  Widget _getLinearGauge() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SfLinearGauge(
          barPointers: [
            LinearBarPointer(
              value: workloadLevel,
              thickness: 30.0,
              color: workloadLevel > 4.0
                  ? Colors.red
                  : workloadLevel > 2.0
                      ? Colors.green
                      : Colors.blue,
            ),
          ],
          minimum: 0.0,
          maximum: 5.0,
          orientation: LinearGaugeOrientation.vertical,
          majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 20.0, color: Colors.black),
          axisTrackStyle: LinearAxisTrackStyle(
              color: Colors.blueGrey,
              edgeStyle: LinearEdgeStyle.bothFlat,
              thickness: 30.0,
              borderColor: Colors.grey)),
    );
  }
}
