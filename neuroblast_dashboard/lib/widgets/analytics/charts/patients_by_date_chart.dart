import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientsByDateChart extends ConsumerStatefulWidget {
  const PatientsByDateChart({super.key});

  @override
  ConsumerState<PatientsByDateChart> createState() =>
      PatientsByDateChartState();
}

class PatientsByDateChartState extends ConsumerState<PatientsByDateChart> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
      case 1:
        text = 'Feb';
      case 2:
        text = 'Mar';
      case 3:
        text = 'Apr';
      case 4:
        text = 'May';
      case 5:
        text = 'Jun';
      case 6:
        text = 'Jul';
      case 7:
        text = 'Aug';
      case 8:
        text = 'Sep';
      case 9:
        text = 'Oct';
      case 10:
        text = 'Nov';
      case 11:
        text = 'Dec';
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).patients;

    // Calculate monthly patient counts
    final monthlyPatientCounts = List<int>.generate(12, (index) {
      return patients
              ?.where(
                (patient) => patient.createdAt.toDate().month == index + 1,
              )
              .length ??
          0;
    });

    // Calculate the maximum monthly count
    final maxMonthlyCount =
        monthlyPatientCounts.reduce((a, b) => a > b ? a : b);

    // Calculate the Y-axis maximum (110% of the max monthly count)
    final yAxisMax = (maxMonthlyCount * 1.1).ceil().toDouble();

    return AspectRatio(
      aspectRatio: 1.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: yAxisMax, // Set the maximum Y value
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: bottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
                interval:
                    yAxisMax / 5, // Adjust interval for 5 labels on Y-axis
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            checkToShowHorizontalLine: (value) => value % 10 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: 4.0 * 400 / 400,
          barGroups:
              getData(monthlyPatientCounts, 8.0 * 400 / 400, 4.0 * 400 / 400),
          minY: 1, // Start from 1 to avoid logarithm of zero
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(
    List<int> monthlyPatientCounts,
    double barsWidth,
    double barsSpace,
  ) {
    return monthlyPatientCounts.asMap().entries.map((entry) {
      final index = entry.key;
      final count = entry.value;
      return BarChartGroupData(
        x: index,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            rodStackItems: [
              BarChartRodStackItem(0, count * 0.4, Colors.blue),
              BarChartRodStackItem(count * 0.4, count * 0.7, Colors.blue),
              BarChartRodStackItem(count * 0.7, count.toDouble(), Colors.blue),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      );
    }).toList();
  }
}
