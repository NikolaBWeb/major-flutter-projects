import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
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
                Text(
                  'PATIENTS',
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(contentProvider.notifier)
                        .updateContent('Add Patients');
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text(
                    'Add Patient',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
