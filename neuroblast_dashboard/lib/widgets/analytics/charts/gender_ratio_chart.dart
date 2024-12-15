import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenderRatioChart extends ConsumerStatefulWidget {
  const GenderRatioChart({super.key});

  @override
  ConsumerState<GenderRatioChart> createState() => _GenderRatioChartState();
}

class _GenderRatioChartState extends ConsumerState<GenderRatioChart> {
  int touchedIndex = -1;
  int _malePatientsCount = 0;
  int _femalePatientsCount = 0;

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).patients;

    if (patients == null || patients.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    _malePatientsCount =
        patients.where((patient) => patient.gender == 'Male').length;
    _femalePatientsCount =
        patients.where((patient) => patient.gender == 'Female').length;
    final totalPatients = _malePatientsCount + _femalePatientsCount;

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.square, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Male'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.square, color: Colors.pink),
                  SizedBox(width: 4),
                  Text('Female'),
                ],
              ),
            ],
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
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
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(totalPatients),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(int totalPatients) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 15.0;
      final radius = isTouched ? 60.0 : 50.0;
      final borderWidth = isTouched ? 4.0 : 1.0;

      switch (i) {
        case 0:
          final malePercentage = totalPatients > 0
              ? '${(_malePatientsCount / totalPatients * 100).toStringAsFixed(1)}%'
              : '0%';
          return PieChartSectionData(
            color: Colors.blue,
            value: _malePatientsCount.toDouble(),
            title: isTouched ? _malePatientsCount.toString() : malePercentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderSide: BorderSide(color: Colors.white, width: borderWidth),
          );
        case 1:
          final femalePercentage = totalPatients > 0
              ? '${(_femalePatientsCount / totalPatients * 100).toStringAsFixed(1)}%'
              : '0%';
          return PieChartSectionData(
            color: Colors.pink,
            value: _femalePatientsCount.toDouble(),
            title:
                isTouched ? _femalePatientsCount.toString() : femalePercentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderSide: BorderSide(color: Colors.white, width: borderWidth),
          );

        default:
          throw Error();
      }
    });
  }
}
