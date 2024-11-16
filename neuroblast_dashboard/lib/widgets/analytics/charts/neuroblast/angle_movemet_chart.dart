import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MovementAngleChart extends StatelessWidget {
  const MovementAngleChart({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    // Add print statements for random values
    print('Random values for last week:');
    final lastWeekValues = List<double>.generate(7, (_) {
      final value =
          (random.nextInt(101) + 50).roundToDouble(); // Random between 50-150
      print(value);
      return value;
    });
    print('Random values for current week:');
    final currentWeekValues = List<double>.generate(7, (_) {
      final value =
          (random.nextInt(101) + 50).roundToDouble(); // Random between 50-150
      print(value);
      return value;
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            // Line for last week
            LineChartBarData(
              spots: [
                for (int i = 0; i < 7; i++)
                  FlSpot(i.toDouble(), lastWeekValues[i]),
              ],
              barWidth: 3,
              color: Colors.pink,
              belowBarData: BarAreaData(
                color: Colors.pink.withOpacity(0.1),
              ),
              dotData: const FlDotData(show: false),
            ),
            // Line for current week
            LineChartBarData(
              spots: [
                for (int i = 0; i < 7; i++)
                  FlSpot(i.toDouble(), currentWeekValues[i]),
              ],
              barWidth: 3,
              color: Colors.blue,
              belowBarData: BarAreaData(
                color: Colors.blue.withOpacity(0.1),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  if (value.toInt() < 0 || value.toInt() >= days.length) {
                    return const Text('');
                  }
                  return Transform.rotate(
                    angle: -0.5, // Rotate labels slightly
                    child: Text(
                      days[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
                interval: 1, // Ensure all days are shown
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            horizontalInterval:
                50, // Adjust this value as needed for horizontal lines
            verticalInterval:
                1, // This will create 7 vertical lines (one for each day)
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                    Colors.black,
              ),
              left: BorderSide(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                    Colors.black,
              ),
            ),
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 200,
        ),
      ),
    );
  }
}
