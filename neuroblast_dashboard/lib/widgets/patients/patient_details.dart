import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_notes.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({
    required this.name,
    required this.surname,
    required this.age,
    required this.gender,
    required this.primaryDiagnosis,
    required this.patientId,
    super.key,
  });

  final String name;
  final String surname;
  final String age;
  final String gender;
  final String primaryDiagnosis;
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Patient Details',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name $surname',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Patient ID',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ': ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: patientId,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Age',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ': ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: age,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Gender',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ': ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: gender,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Primary Diagnosis',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ': ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: primaryDiagnosis,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Text(
                            'Notes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Tasks'),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Neuroblast'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          /* PatientNotes(patientId: patientId), */
        ],
      ),
    );
  }
}
