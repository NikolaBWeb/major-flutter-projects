import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class PatientAgeToTotalChart extends ConsumerStatefulWidget {
  const PatientAgeToTotalChart({super.key});

  @override
  ConsumerState<PatientAgeToTotalChart> createState() =>
      _PatientAgeToTotalChartState();
}

class _PatientAgeToTotalChartState
    extends ConsumerState<PatientAgeToTotalChart> {
  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider);

    if (patients.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (patients.error != null) {
      return Center(child: Text('Error: ${patients.error}'));
    }

    if (patients.patients!.isEmpty) {
      return const Center(child: Text('No patients available'));
    }

    // Prepare data for the chart
    final data = _prepareChartData(patients.patients!);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: data
                .map((e) => e['patientCount']!)
                .reduce((a, b) => a > b ? a : b),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${data[groupIndex]['percentage']!.toStringAsFixed(2)}%',
                    const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final age = data[value.toInt()]['ageGroup']!.toInt();
                    return Text('$age-${age + 9}');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value == value.roundToDouble()) {
                      return Text(value.toInt().toString());
                    }
                    return const Text('');
                  },
                ),
              ),
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: data.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value['patientCount']!,
                    color: const Color(0xFFA2D06B),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    rodStackItems: [
                      BarChartRodStackItem(
                        0,
                        entry.value['patientCount']!,
                        Colors.transparent,
                        BorderSide.none,
                      ),
                    ],
                  ),
                ],
                showingTooltipIndicators: [0],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPercentageText(double value, double percentage) {
    return Text(
      '${percentage.toStringAsFixed(2)}%',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Map<String, double>> _prepareChartData(List<Patient> patients) {
    final groupedData = <int, int>{};
    final totalPatients = patients.length;

    // Group patients by 10-year intervals (e.g., 0-9, 10-19, 20-29, etc.)
    for (final patient in patients) {
      final age = int.parse(patient.age);
      final ageGroup = (age ~/ 10) * 10;
      groupedData.update(ageGroup, (value) => value + 1, ifAbsent: () => 1);
    }

    // Convert to a list of maps for the chart and sort by age group
    final chartData = groupedData.entries.map((entry) {
      return {
        'ageGroup': entry.key.toDouble(),
        'patientCount': entry.value.toDouble(),
        'percentage': double.parse(
          (entry.value / totalPatients * 100).toStringAsFixed(2),
        ),
      };
    }).toList()
      ..sort((a, b) => a['ageGroup']!.compareTo(b['ageGroup']!));

    // Ensure all 10-year gaps are represented, even if there are no patients
    final filledChartData = <Map<String, double>>[];
    if (chartData.isNotEmpty) {
      for (var i = 0;
          i <= (chartData.last['ageGroup']!.toInt() + 10);
          i += 10) {
        final existingEntry = chartData.firstWhere(
          (entry) => entry['ageGroup'] == i.toDouble(),
          orElse: () =>
              {'ageGroup': i.toDouble(), 'patientCount': 0, 'percentage': 0},
        );
        filledChartData.add(existingEntry);
      }
    }

    return filledChartData;
  }
}
