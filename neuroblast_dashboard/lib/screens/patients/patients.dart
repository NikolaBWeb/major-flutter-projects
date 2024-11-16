import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_optios_row.dart';
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
    final width = MediaQuery.of(context).size.width;

    print('Building PatientsScreen'); // Add this debug print
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                if (width > 600) ...[
                  Icon(
                    Icons.people,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 10),
                  if (width > 800)
                    Text(
                      'PATIENTS',
                      style: TextStyle(
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle?.color,
                      ),
                    ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 200),
                    child: const PatientSearchBar(),
                  ),
                ),
                const SizedBox(width: 10),
                if (width > 600)
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
                  )
                else
                  IconButton(
                    onPressed: () {
                      ref
                          .read(contentProvider.notifier)
                          .updateContent('Add Patients');
                    },
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.secondary,
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
          PatientOptionsRow(),
          Expanded(child: PatientList()),
        ],
      ),
    );
  }
}
