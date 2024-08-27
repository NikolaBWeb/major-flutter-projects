import 'package:flutter/material.dart';
/* import 'package:fl_chart/fl_chart.dart'; */
/* import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/main.dart'; */

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}

/* PieChartSectionData buildPieChartSection({
  required double value,
  required Color color,
  required String title,
  double radius = 50,
}) {
  return PieChartSectionData(
    value: value,
    color: color,
    title: title,
    radius: radius,
    titleStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );
}

PieChartData getPieChartData(List<Expense> expenses) {
  final foodExpenses =
      ExpenseBucket.forCategory(expenses, Category.food).totalExpenses;
  final leisureExpenses =
      ExpenseBucket.forCategory(expenses, Category.leisure).totalExpenses;
  final travelExpenses =
      ExpenseBucket.forCategory(expenses, Category.travel).totalExpenses;
  final workExpenses =
      ExpenseBucket.forCategory(expenses, Category.work).totalExpenses;

  return PieChartData(
    sectionsSpace: 4, // Space between sections
    centerSpaceRadius: 40, // Radius for the donut effect
    sections: [
      buildPieChartSection(
        value: foodExpenses,
        color:kColorScheme.onSecondaryContainer,
        title: foodExpenses.toStringAsFixed(2),
      ),
      buildPieChartSection(
        value: leisureExpenses,
        color: kColorScheme.onSecondaryContainer,
        title: leisureExpenses.toStringAsFixed(2),
      ),
      buildPieChartSection(
        value: travelExpenses,
        color:kColorScheme.onSecondaryContainer,
        title: travelExpenses.toStringAsFixed(2),
      ),
      buildPieChartSection(
        value: workExpenses,
        color: kColorScheme.onPrimaryContainer,
        title: workExpenses.toStringAsFixed(2),
      ),
    ],
  ); 
}*/
