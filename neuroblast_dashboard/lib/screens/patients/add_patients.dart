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
        actions: [
          IconButton(
            onPressed: () {
              ref.read(contentProvider.notifier).updateContent('Patients');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Icon(
            Icons.person_add_alt_1,
            color: Theme.of(context).colorScheme.secondary,
            size: 25,
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Add Patient',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const Spacer(),
        ],
      ),
      body: const AddPatientForm(),
    );
  }
}
