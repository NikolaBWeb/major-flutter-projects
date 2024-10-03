import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class AddPatientForm extends ConsumerStatefulWidget {
  const AddPatientForm({super.key});

  @override
  ConsumerState<AddPatientForm> createState() => _AddPatientFormState();
}

class _AddPatientFormState extends ConsumerState<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();
  final patientsDB = FirebaseFirestore.instance;
  bool _isSending = false;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();

  Future<void> _addPatient({
    required String name,
    required String surname,
    required String gender,
    required String primaryDiagnosis,
    required String age,
  }) async {
    await patientsDB.collection('patients').add({
      'name': name,
      'surname': surname,
      'age': age,
      'primaryDiagnosis': primaryDiagnosis,
      'gender': gender,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true; // Show loading indicator
      });

      // Process the form data
      await _addPatient(
        name: _nameController.text,
        surname: _surnameController.text,
        gender: _genderController.text,
        primaryDiagnosis: _diagnosisController.text,
        age: _ageController.text,
      );

      // Update provider
      ref.read(patientsProvider.notifier).addPatient(
            Patient(
              age: _ageController.text,
              gender: _genderController.text,
              name: _nameController.text,
              surname: _surnameController.text,
              diagnosis: _diagnosisController.text,
            ),
          );

      // Reset sending state
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Patient added successfully!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Surname',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a surname';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Age',
                      counterText: '', // Remove the underline counter
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.parse(value) > 120) {
                        return 'Please enter a valid number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Patient Gender',
                    ),
                    items: [
                      'Male',
                      'Female',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _genderController.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Primary Diagnosis',
                    ),
                    items: [
                      'Cerebral Palsy',
                      'Stroke',
                      'Multiple Sclerosis',
                      "Parkinson's Disease",
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _diagnosisController.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Process the form data
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Data'),
                    ),
                  );
                  await _submitForm();
                  ref.read(contentProvider.notifier).updateContent('Patients');
                  _isSending = false;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSending)
                    const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(),
                    )
                  else
                    const Icon(Icons.add), // Display "add" icon otherwise
                  const SizedBox(width: 10), // Space between icon and text
                  const Text('Add patient'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
