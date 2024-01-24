import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      body: Column(
        children: [
          SafeArea(child: Text("data")),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: Row(
              children: <Widget>[
                /*const SizedBox(
                  height: 18,
                ),*/
                Container(
                  margin: EdgeInsets.only(left: context.getWidth*0.18),
                  width: context.getWidth*0.6,
                  height: context.getHeight*0.3,
                  child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(1,2,3,4,5),
                      ),
                    ),
                 
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    /*Indicator(
                      color: Colors.blue,
                      text: 'First',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorYellow,
                      text: 'Second',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorPurple,
                      text: 'Third',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorGreen,
                      text: 'Fourth',
                      isSquare: true,
                    ),*/
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ),
        ],
      )
      ,
    );
 
  }

  List<PieChartSectionData> showingSections(double oneStar,double twoStar,double threeStar,double fourStar,double fiveStar) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: oneStar,
            title: '%${((oneStar/(oneStar+twoStar+threeStar+fourStar+fiveStar))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: twoStar,
            title: '%${((twoStar/(oneStar+twoStar+threeStar+fourStar+fiveStar))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: threeStar,
            title: '%${((threeStar/(oneStar+twoStar+threeStar+fourStar+fiveStar))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.yellow,
            value: fourStar,
            title: '%${((fourStar/(oneStar+twoStar+threeStar+fourStar+fiveStar))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.green,
            value: fiveStar,
            title: '%${((fiveStar/(oneStar+twoStar+threeStar+fourStar+fiveStar))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}