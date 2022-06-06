import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {


  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {

    final email = Provider.of<AuthProvider>(context, listen: false).userCredentials['email'];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('webUsers').where('email',isEqualTo: email).snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SizedBox(height: 25.0,width: 25.0,child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: const Text('Error, could not load data, refresh page!'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 8.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(context,snapshot),
              ),
            );
          } else {
            return Center(child: const Text('Data not available!'));
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );

  }

  LineChartData mainData(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
    int year = DateTime.now().year;
    final salesGraph = snapshot.data!.docs[0].get('salesGraph');

    //final salesGraph = Provider.of<AuthProvider>(context, listen: false).userCredentials['salesGraph'];

    print(double.parse(salesGraph['1-$year'].toStringAsFixed(2)));

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black45.withOpacity(0.1),
            strokeWidth: 0.3,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black45.withOpacity(0.1),
            strokeWidth: 0.3,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) {
            //for(int i = 0; i< 3; i++){
            // if( value == 2)
            //   return month1;
            // if( value == 5)
            //   return month2;
            // if( value == 8)
            //   return month3;
            //}
           switch (value.toInt()) {
             case 0:
               return 'JAN';
             case 1:
               return 'FEB';
             case 2:
               return 'MAR';
             case 3:
               return 'APR';
             case 4:
               return 'MAY';
             case 5:
               return 'JUN';
             case 6:
               return 'JUL';
             case 7:
               return 'AUG';
             case 8:
               return 'SEP';
             case 9:
               return 'OCT';
             case 10:
               return 'NOV';
             case 11:
               return 'DEC';
           }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
            }
            return '';
          },
          reservedSize: 20,
          margin: 5,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: Colors.black45.withOpacity(0.1), width: 1)),
      minX: 0,   // actual size of graph
      maxX: 11,
      minY: 0,
      maxY: 20,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(0, salesGraph['1-$year']),//first month
            FlSpot(1,  salesGraph['2-$year']),//first month
            FlSpot(2, salesGraph['3-$year']),//first month
            FlSpot(3, salesGraph['4-$year']),//second month
            FlSpot(4, salesGraph['5-$year']),
            FlSpot(5, salesGraph['6-$year']),//third month
            FlSpot(6, salesGraph['7-$year']),//third month
            FlSpot(7, salesGraph['8-$year']),
            FlSpot(8, salesGraph['9-$year']),
            FlSpot(9, salesGraph['10-$year']),
            FlSpot(10, salesGraph['11-$year']),
            FlSpot(11, salesGraph['12-$year']),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

}
