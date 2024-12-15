import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      aspectRatio: 1.3,
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
    final strokePatients =
        patients.where((patient) => patient.diagnosis == 'Stroke').length;
    final cerebralPalsyPatients = patients
        .where((patient) => patient.diagnosis == 'Cerebral Palsy')
        .length;
    final multipleSclerosisPatients = patients
        .where((patient) => patient.diagnosis == 'Multiple Sclerosis')
        .length;
    final parkinsonsPatients = patients
        .where((patient) => patient.diagnosis == "Parkinson's Disease")
        .length;

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 15.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(blurRadius: 2)];
      final borderWidth = isTouched ? 4 : 1;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: strokePatients.toDouble(),
            title: isTouched
                ? strokePatients.toString()
                : '${(strokePatients / patients.length * 100).toStringAsFixed(1)}%',
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
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: cerebralPalsyPatients.toDouble(),
            title: isTouched
                ? cerebralPalsyPatients.toString()
                : '${(cerebralPalsyPatients / patients.length * 100).toStringAsFixed(1)}%',
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
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: multipleSclerosisPatients.toDouble(),
            title: isTouched
                ? multipleSclerosisPatients.toString()
                : '${(multipleSclerosisPatients / patients.length * 100).toStringAsFixed(1)}%',
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
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: parkinsonsPatients.toDouble(),
            title: isTouched
                ? parkinsonsPatients.toString()
                : '${(parkinsonsPatients / patients.length * 100).toStringAsFixed(1)}%',
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
        default:
          throw Error();
      }
    });
  }
}
