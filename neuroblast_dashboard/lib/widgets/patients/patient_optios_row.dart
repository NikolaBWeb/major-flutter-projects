import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class PatientOptionsRow extends ConsumerStatefulWidget {
  const PatientOptionsRow({super.key});

  @override
  ConsumerState<PatientOptionsRow> createState() => _PatientOptionsRowState();
}

class _PatientOptionsRowState extends ConsumerState<PatientOptionsRow> {
  @override
  Widget build(BuildContext context) {
    final viewType = ref.watch(patientsProvider).viewType;
    final patients = ref.watch(patientsProvider).patients;
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(' Total Patients: ${patients?.length ?? 0}'),
          ),
          Expanded(
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ref
                        .read(patientsProvider)
                        .setViewType(PatientViewType.list);
                  },
                  icon: Icon(
                    Icons.view_list,
                    color: viewType == PatientViewType.list
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
                Icon(
                  viewType == PatientViewType.list
                      ? Icons.arrow_right
                      : Icons.arrow_left,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(patientsProvider)
                        .setViewType(PatientViewType.grid);
                  },
                  icon: Icon(
                    Icons.view_module,
                    color: viewType == PatientViewType.grid
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
