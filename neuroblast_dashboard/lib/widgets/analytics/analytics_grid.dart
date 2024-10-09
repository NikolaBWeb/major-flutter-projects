import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartsGrid extends StatelessWidget {
  const ChartsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(4, (index) {
        return Center(
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(
                show: false,
              ),
              titlesData: const FlTitlesData(
                show: false,
              ),
            ),
          ),
        );
      }),
    );
  }
}
