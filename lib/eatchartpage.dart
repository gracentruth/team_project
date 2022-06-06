import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


String name='';
List eatList=[];
List nameList=[];

class eatChartPage extends StatefulWidget {
  eatChartPage({required this.n});

  String n;
  @override
  _eatChartPageState createState(){
    name=n;
    return _eatChartPageState();
  }
}

class _eatChartPageState extends State<eatChartPage> {
  late List<EATData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  //final CollectionReference animal = FirebaseFirestore.instance.collection('animal');
  List eatList=[];
  List nameList=[];

  void messagesStream() async {
    eatList=[];
    nameList=[];
    await for (var snapshot in FirebaseFirestore.instance.collection('animal').snapshots()) {
      for (var message in snapshot.docs) {
        eatList.add(message.get('eat'));
        nameList.add(message.get('name'));
      }
      setState(() {

      });
    }
  }





  @override
  void initState() {
    messagesStream();

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    _chartData = getChartData();
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:Text(name),
            centerTitle: true,
          ),
          body:  SfCartesianChart(
            // plotAreaBorderColor: Colors.amberAccent,
            // borderColor:Colors.amberAccent ,
            // backgroundColor: Colors.amberAccent,
            // plotAreaBackgroundColor: Colors.amberAccent,
            title: ChartTitle(text: '식사량 '),
            legend: Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              BarSeries<EATData, String>(
                  color: Colors.amberAccent,
                  name: 'hello',
                  dataSource: _chartData,
                  xValueMapper: (EATData gdp, _) => gdp.continent,
                  yValueMapper: (EATData gdp, _) => gdp.gdp,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                numberFormat: NumberFormat.compact(),
                title: AxisTitle(text: '오늘의 식사')),
          ),
        ));
  }

  List<EATData> getChartData() {




    final List<EATData> chartData = [
      // EATData('Oceania', 1),
      // EATData('Africa', 2),
      // EATData('S America', 3),
      // EATData('Europe', 4),
      // EATData('N America', 5),
      // EATData('Asia', 6),
    ];

    for(var i=0;i<eatList.length;i++){
      chartData.add(EATData(nameList[i],eatList[i].toDouble()));

    }


    return chartData;
  }
}

class EATData {
  EATData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}