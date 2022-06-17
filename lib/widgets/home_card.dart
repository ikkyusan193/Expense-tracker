


import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/expense.dart';
import '../utils/constant.dart';


/// Category card class, i created
/// Parsed information about expenses
/// could only parse in Expense
/// but i decide to parse in information
/// so the card can be use other that expenses.
class HomeCard extends StatelessWidget {
  final Map<String, double> costMap;
  final double total;
  final String title;


  const HomeCard(
      {Key? key,
        required this.title,
        required this.costMap,
        required this.total})
      : super(key: key);

  /// we use Pie chart library (look more in import)
  @override
  Widget build(BuildContext context) {
    return PieChart(
          dataMap: costMap,
          colorList: kColorList,
          chartRadius: MediaQuery.of(context).size.width /2.75,
          centerText: "$title\n\$$total",
          chartType: ChartType.ring,
          ringStrokeWidth: 30,
          animationDuration: const Duration(seconds: 1),
          baseChartColor: Colors.grey[300]!,
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: true,
            showChartValueBackground: false,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            chartValueStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15),
            decimalPlaces: 0,
          ),
          legendOptions: const LegendOptions(
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54), // TODO
          ),
        );
  }
}

