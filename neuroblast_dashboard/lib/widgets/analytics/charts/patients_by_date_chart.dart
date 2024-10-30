import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

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

    // Check if there's no data
    if (monthlyPatientCounts.every((count) => count == 0)) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Calculate the maximum monthly count
    final maxMonthlyCount =
        monthlyPatientCounts.reduce((a, b) => a > b ? a : b);

    // Calculate the Y-axis maximum (add one more interval)
    final yAxisInterval = calculateYAxisInterval(maxMonthlyCount.toDouble());
    final yAxisMax =
        ((maxMonthlyCount / yAxisInterval).ceil() + 1) * yAxisInterval;

    return AspectRatio(
      aspectRatio: 1.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: yAxisMax,
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
                  // Show all interval values including the max
                  if (value == 0) return const Text('');
                  if (value % yAxisInterval != 0) return const Text('');
                  return Text(value.toInt().toString());
                },
                interval: yAxisInterval,
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            checkToShowHorizontalLine: (value) =>
                value % yAxisInterval == 0 &&
                value != 0, // Show lines at each interval
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1.5,
            ),
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(
            border: const Border(
              left: BorderSide(),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
              bottom: BorderSide(),
            ),
          ),
          groupsSpace: 4.0 * 400 / 400,
          barGroups:
              getData(monthlyPatientCounts, 8.0 * 400 / 400, 4.0 * 400 / 400),
          minY: 0, // Changed from 1 to 0
        ),
      ),
    );
  }

  double calculateYAxisInterval(double yAxisMax) {
    if (yAxisMax <= 5) return 1;
    if (yAxisMax <= 10) return 2;
    return (yAxisMax / 5).ceil().toDouble();
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
