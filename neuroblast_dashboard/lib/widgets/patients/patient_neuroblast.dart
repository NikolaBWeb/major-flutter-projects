import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/neuroblast/acceleration_chart.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/neuroblast/angle_movemet_chart.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/neuroblast/pressure_chart.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/neuroblast/time_used_chart.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_calendar.dart';
// Import other chart widgets as needed

class PatientNeuroblast extends StatelessWidget {
  const PatientNeuroblast({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Neuroblast Telemetry',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.bar_chart_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildChartSection(
                  'Angle of Movement',
                  const MovementAngleChart(),
                  300,
                  true,
                  Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(height: 20),
                _buildChartSection(
                  'Time Used',
                  const TimeUsedChart(),
                  400,
                  true,
                  Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildChartSection(
                        'Acceleration',
                        const AccelerationChart(),
                        400,
                        false,
                        Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildChartSection(
                        'Pressure',
                        const PressureChart(),
                        400,
                        false,
                        Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
                _buildChartSection(
                  'Calendar',
                  const PatientCalendar(),
                  400,
                  false,
                  Theme.of(context).colorScheme.surface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(
    String title,
    Widget chart,
    double height,
    bool legend,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              if (legend)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 15,
                      height: 3,
                    ),
                    const SizedBox(width: 5),
                    const Text('Last week '),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 15,
                      height: 3,
                    ),
                    const SizedBox(width: 5),
                    const Text('Current week'),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: height, // Adjust the height as needed
            child: chart,
          ),
        ],
      ),
    );
  }
}
