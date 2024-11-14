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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.task_alt_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              const Expanded(
                child: Center(
                  child: Text('No tasks available.'),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add_task_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
