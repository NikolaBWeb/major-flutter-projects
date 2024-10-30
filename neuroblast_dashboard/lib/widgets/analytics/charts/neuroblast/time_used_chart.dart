import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeUsedChart extends StatelessWidget {
  const TimeUsedChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RotatedBox(
        quarterTurns: 1, // Add this wrapper
        child: BarChart(
          BarChartData(
            alignment:
                BarChartAlignment.spaceAround, // Changed from spaceBetween
            groupsSpace: 40, // Added space between groups
            maxY: 140,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                rotateAngle: -90,
                getTooltipColor: (value) => Colors.transparent,
              ),
            ),
            titlesData: FlTitlesData(
              // Left titles now show minutes
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    return RotatedBox(
                      quarterTurns: -1,
                      child: Text('${value.toInt()} min'),
                    );
                  },
                ),
              ),
              // Bottom titles now show days
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80,
                  getTitlesWidget: (value, meta) {
                    return RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        switch (value.toInt()) {
                          0 => 'Monday',
                          1 => 'Tuesday',
                          2 => 'Wednesday',
                          3 => 'Thursday',
                          4 => 'Friday',
                          5 => 'Saturday',
                          6 => 'Sunday',
                          _ => '',
                        },
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            gridData: const FlGridData(
              horizontalInterval: 20, // Match interval with left titles
              verticalInterval: 1, // Match interval with days
            ),
            borderData: FlBorderData(
              border: const Border(
                bottom: BorderSide(),
                left: BorderSide(),
                right: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            barGroups: _buildBarData(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarData() {
    final lastWeekData = [128, 123, 107, 87, 87, 87, 87];
    final currentWeekData = [129, 92, 106, 95, 95, 95, 95];

    return List.generate(7, (index) {
      return BarChartGroupData(
        showingTooltipIndicators: [0, 1],
        x: index,
        barRods: [
          BarChartRodData(
            toY: lastWeekData[index].toDouble(),
            color: Colors.pink,
            width: 15,
            borderRadius: BorderRadius.circular(0),
          ),
          BarChartRodData(
            toY: currentWeekData[index].toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: 0, // Space between the bars for "last" and "current" week
      );
    });
  }
}
