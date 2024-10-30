import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_neuroblast.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_notes.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_tasks.dart';

class PatientDetails extends StatefulWidget {
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
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  late Widget content;
  String activeTab = 'notes'; // Changed from 'neuroblast' to 'notes'

  @override
  void initState() {
    super.initState();
    content = PatientNotes(
      patientId: widget.patientId,
    ); // Changed from PatientNeuroblast to PatientNotes
  }

  Future<void> _removePatient() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Patient'),
          content: const Text(
            'Are you sure you want to remove this patient? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    // Only proceed with deletion if user confirmed
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Patient removed successfully',
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Patient Details',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () async { 
                await _removePatient();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              leading: const Icon(
                Icons.person_remove,
                color: Colors.red,
              ),
              title: const Text('Remove Patient'),
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: widget.gender == 'Male'
                              ? Colors.blue
                              : Colors.pink,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.name} ${widget.surname}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
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
                                  text: ' : ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.patientId,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
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
                                  text: ' : ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.age,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
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
                                  text: ' : ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.gender,
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
                                  text: ' : ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.primaryDiagnosis,
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
                    ],
                  ),
                ),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              activeTab = 'notes';
                              content = PatientNotes(
                                patientId: widget.patientId,
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: activeTab == 'notes'
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.note_add,
                                color: activeTab == 'notes'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Notes',
                                style: activeTab == 'notes'
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              activeTab = 'tasks';
                              content = PatientTasks(
                                patientId: widget.patientId,
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: activeTab == 'tasks'
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.task_alt,
                                color: activeTab == 'tasks'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Tasks',
                                style: activeTab == 'tasks'
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              activeTab = 'neuroblast';
                              content = PatientNeuroblast(
                                patientId: widget.patientId,
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: activeTab == 'neuroblast'
                                ? Theme.of(context).colorScheme.secondary
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: activeTab == 'neuroblast'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Neuroblast',
                                style: activeTab == 'neuroblast'
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          content,
        ],
      ),
    );
  }
}
