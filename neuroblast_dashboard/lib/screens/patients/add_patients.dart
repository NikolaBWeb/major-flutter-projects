import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/widgets/patients/add_patient_form.dart';

class AddPatients extends ConsumerStatefulWidget {
  const AddPatients({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPatientsState();
}

class _AddPatientsState extends ConsumerState<AddPatients> {
  @override
  Widget build(BuildContext context) {
    print('Building AddPatients'); // Add this debug print
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(contentProvider.notifier).updateContent('Patients');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Add Patients',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
        title: const Text('Add Patient'),
      ),
      body: const AddPatientForm(),
    );
  }
}
