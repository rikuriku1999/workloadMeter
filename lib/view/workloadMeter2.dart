import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:workload_meter/importer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class WorkloadMeter extends StatefulWidget {
  @override
  State<WorkloadMeter> createState() => _WorkloadMeterState();
}

class _WorkloadMeterState extends State<WorkloadMeter> {
  Map<String, dynamic> data = {};
  // String workloadLevel = '0';
  double workloadlevel = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  Future fetchData() async {
    var response = await http.get(Uri.parse('http://192.168.0.113:5000/data'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        // workloadlevel = data
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: EmptyAppBar(),
        // body: StreamBuilder(
        //   stream: widget.streamController.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       workloadLevel = double.tryParse(snapshot.data!) ?? workloadLevel;
        //     }
        //     return Padding(
        //       padding: EdgeInsets.symmetric(vertical: 24.0),
        //       child: Column(
        //         children: [
        //           _getRadialGauge(),
        //           // Text(snapshot.hasData ? '${snapshot.data}' : ''),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  // _getGauge, _getRadialGauge, _getLinearGauge methods...

  // Widget _getGauge({bool isRadialGauge = false}) {
  //   if (isRadialGauge) {
  //     return _getRadialGauge();
  //   } else {
  //     return _getLinearGauge();
  //   }
  //

  Widget _getRadialGauge() {
    return SfRadialGauge(
        title: GaugeTitle(
            text: 'Speedometer',
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 50,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 50,
                endValue: 100,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 100,
                endValue: 150,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: 90)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: const Text('90.0',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }

  // Widget _getLinearGauge() {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     child: SfLinearGauge(
  //         barPointers: [
  //           LinearBarPointer(
  //             value: workloadLevel,
  //             thickness: 30.0,
  //             color: workloadLevel > 4.0
  //                 ? Colors.red
  //                 : workloadLevel > 2.0
  //                     ? Colors.green
  //                     : Colors.blue,
  //           ),
  //         ],
  //         minimum: 0.0,
  //         maximum: 5.0,
  //         orientation: LinearGaugeOrientation.vertical,
  //         majorTickStyle: LinearTickStyle(length: 20),
  //         axisLabelStyle: TextStyle(fontSize: 20.0, color: Colors.black),
  //         axisTrackStyle: LinearAxisTrackStyle(
  //             color: Colors.blueGrey,
  //             edgeStyle: LinearEdgeStyle.bothFlat,
  //             thickness: 30.0,
  //             borderColor: Colors.grey)),
  //   );
  // }
}
