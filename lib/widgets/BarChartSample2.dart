import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarChartSample2 extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Color leftBarColor = Colors.greenAccent;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.orange;
  const BarChartSample2({super.key, required this.data});

  @override
  State<BarChartSample2> createState() => _BarChartSample2State();
}

class _BarChartSample2State extends State<BarChartSample2> {
  final double width = 5;
  late List<String> lables = [];
  late double max_value = 0;
  final fmt = NumberFormat.decimalPattern('vi_VN');

   List<BarChartGroupData> rawBarGroups = [];
   List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  final Color leftBarColor = Colors.greenAccent;
  final Color rightBarColor = Colors.redAccent;
  final Color avgColor = Colors.orangeAccent;

  @override
  void initState() {
    super.initState();
    print("${widget.data}");
    int index = 0;
    final items = widget.data.map((e) {
      return makeGroupData(index++, e["tong_thu"].toDouble()/1_000_000, e["tong_chi"].toDouble()/1000000);
    },).toList();
    for (var item in widget.data){
      max_value = max(max(item["tong_thu"].toDouble()/1_000_000, item["tong_chi"].toDouble()/1_000_000), max_value);
      lables.add("T${DateTime.parse(item["thang"]).month}");
    }
    lables.first = lables.first+"\n${DateTime.parse(widget.data.first["thang"]).year}";
    lables.last = lables.last+"\n${DateTime.parse(widget.data.last["thang"]).year}";

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     makeTransactionsIcon(),
            //     const SizedBox(
            //       width: 38,
            //     ),
            //     const Text(
            //       'Biến động thu chi',
            //       style: TextStyle( fontSize: 22),
            //     ),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     const Text(
            //       '',
            //       style: TextStyle(color: Color(0xff77839a), fontSize: 16),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: max_value,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                          ) {
                        return BarTooltipItem(
                          "${fmt.format(rod.toY*1_000_000)}₫",
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rod.color,
                            fontSize: 12,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 12,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      // if (response == null || response.spot == null) {
                      //   setState(() {
                      //     touchedGroupIndex = -1;
                      //     showingBarGroups = List.of(rawBarGroups);
                      //   });
                      //   return;
                      // }
                      //
                      // touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      //
                      // setState(() {
                      //   if (!event.isInterestedForInteractions) {
                      //     touchedGroupIndex = -1;
                      //     showingBarGroups = List.of(rawBarGroups);
                      //     return;
                      //   }
                      //   showingBarGroups = List.of(rawBarGroups);
                      //   if (touchedGroupIndex != -1) {
                      //     var sum = 0.0;
                      //     for (final rod
                      //     in showingBarGroups[touchedGroupIndex].barRods) {
                      //       sum += rod.toY;
                      //     }
                      //     final avg = sum /
                      //         showingBarGroups[touchedGroupIndex]
                      //             .barRods
                      //             .length;
                      //
                      //     showingBarGroups[touchedGroupIndex] =
                      //         showingBarGroups[touchedGroupIndex].copyWith(
                      //           barRods: showingBarGroups[touchedGroupIndex]
                      //               .barRods
                      //               .map((rod) {
                      //             return rod.copyWith(
                      //                 toY: avg, color: widget.avgColor);
                      //           }).toList(),
                      //         );
                      //   }
                      // });
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                        });
                      } else {
                        setState(() {
                          touchedGroupIndex = -1;
                        });
                      }
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),

                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 10,),
                CircleAvatar(backgroundColor: Colors.greenAccent,radius: 4,),
                SizedBox(width: 8,),
                Text("Thu", style: TextStyle(fontSize: 12),),
                SizedBox(width: 28,),
                CircleAvatar(backgroundColor: Colors.red,radius: 4,),
                SizedBox(width: 8,),
                Text("Chi",style: TextStyle(fontSize: 12) )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    if (value == 0) {
      text = '0M';
    } else if (value == max_value/2) {
      text = '${max_value/2}M';
    } else if (value == max_value) {
      text = '${max_value.toInt()}M';
    } else {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // final titles = <String>['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8','T9','T10','T11','T12'];
    // print(lables);
    final Widget text = Text(
      lables[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 5, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 1,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withValues(alpha: 1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}