import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  String? _selectedGender;
  String? _selectedDiagnosis;

  Future<void> _addPatient({
    required String name,
    required String surname,
    required String gender,
    required String primaryDiagnosis,
    required String age,
  }) async {
    try {
      await patientsDB.collection('patients').add({
        'name': name,
        'surname': surname,
        'age': age,
        'primaryDiagnosis': primaryDiagnosis,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding patient: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        gender: _selectedGender!,
        primaryDiagnosis: _selectedDiagnosis!,
        age: _ageController.text,
      );

      // Reset sending state
      setState(() {
        _isSending = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Patient added successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }

      // Reset form fields after successful submission
      _formKey.currentState!.reset();
      _selectedGender = null;
      _selectedDiagnosis = null;

      ref.read(contentProvider.notifier).updateContent('Patients');
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
                      if (int.tryParse(value) == null ||
                          int.parse(value) > 120) {
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
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a gender';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Primary Diagnosis',
                    ),
                    value: _selectedDiagnosis,
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
                      setState(() {
                        _selectedDiagnosis = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a diagnosis';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSending ? null : _submitForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSending)
                    const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  const SizedBox(width: 10),
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
