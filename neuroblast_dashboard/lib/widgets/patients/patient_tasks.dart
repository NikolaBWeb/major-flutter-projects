import 'package:flutter/material.dart';

class PatientTasks extends StatelessWidget {
  const PatientTasks({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.65, // Set height to a portion of the screen
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
