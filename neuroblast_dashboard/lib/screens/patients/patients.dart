import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_search_bar.dart';
import 'package:neuroblast_dashboard/widgets/patients/patients_list.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  @override
  Widget build(BuildContext context) {
    print('Building PatientsScreen'); // Add this debug print
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                const Text(
                  'PATIENTS',
                  style: TextStyle(color: Colors.black),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    ref.read(patientsProvider.notifier).clearAllPatients();
                  },
                  child: const Text('Clear All'),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(contentProvider.notifier)
                        .updateContent('Add Patients');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Patient',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide.none,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
      body: const Column(
        // Change from Column to ListView
        children: [
          PatientInfoRow(),
          Expanded(child: PatientList()),
        ],
      ),
    );
  }
}
