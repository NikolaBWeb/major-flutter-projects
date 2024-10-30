import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class DeceaseDiversityChart extends ConsumerStatefulWidget {
  const DeceaseDiversityChart({super.key});

  @override
  ConsumerState<DeceaseDiversityChart> createState() =>
      _DeceaseDiversityChartState();
}

class _DeceaseDiversityChartState extends ConsumerState<DeceaseDiversityChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).patients;

    return AspectRatio(
      aspectRatio: 1.4,
      child: Row(
        children: <Widget>[
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.square, color: Colors.red),
                      SizedBox(width: 4),
                      Text('Stroke'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.square, color: Colors.green),
                      SizedBox(width: 4),
                      Text("Parkinson's Disease"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.square, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('Cerebral Palsy'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.square, color: Colors.purple),
                      SizedBox(width: 4),
                      Text('Multiple Sclerosis'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
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
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(patients ?? []),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Patient> patients) {
    final diagnosisCounts = {
      'Stroke': 0,
      'Cerebral Palsy': 0,
      'Multiple Sclerosis': 0,
      "Parkinson's Disease": 0,
    };

    for (final patient in patients) {
      if (diagnosisCounts.containsKey(patient.diagnosis)) {
        diagnosisCounts[patient.diagnosis] =
            diagnosisCounts[patient.diagnosis]! + 1;
      }
    }

    final colors = [Colors.red, Colors.orange, Colors.purple, Colors.green];
    final nonZeroDiagnoses =
        diagnosisCounts.entries.where((entry) => entry.value > 0).toList();

    return List.generate(nonZeroDiagnoses.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 15.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(blurRadius: 1)];
      final borderWidth = isTouched ? 4 : 1;

      final diagnosis = nonZeroDiagnoses[i].key;
      final count = nonZeroDiagnoses[i].value;
      final percentage = (count / patients.length * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[diagnosisCounts.keys.toList().indexOf(diagnosis)],
        value: count.toDouble(),
        title: isTouched ? count.toString() : '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
        borderSide: BorderSide(
          color: Colors.white,
          width: borderWidth.toDouble(),
        ),
      );
    });
  }
}
