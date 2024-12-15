import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_details.dart';

class PatientInfoRow extends ConsumerStatefulWidget {
  const PatientInfoRow({super.key});

  @override
  ConsumerState<PatientInfoRow> createState() => _PatientInfoRowState();
}

class _PatientInfoRowState extends ConsumerState<PatientInfoRow> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).patients ?? [];

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (String searchQuery) {
                    setState(() {
                      query = searchQuery;
                    });
                    controller.openView(); // Open suggestions view
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Search patients...',
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                if (controller.text.isEmpty) {
                  return [
                    const ListTile(
                      title: Text(
                        'Type to search for patients by name and surname',
                      ),
                    ),
                  ];
                }
                final searchTerms = controller.text.toLowerCase().split(' ');

                final filteredPatients = patients.where((patient) {
                  final fullName =
                      '${patient.name} ${patient.surname}'.toLowerCase();
                  return searchTerms.every(fullName.contains);
                }).toList();

                return List<ListTile>.generate(filteredPatients.length,
                    (int index) {
                  final patient = filteredPatients[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Icon(
                          patient.gender == 'Male'
                              ? Icons.man_4
                              : Icons.woman_2,
                          color: patient.gender == 'Male'
                              ? Colors.blue
                              : Colors.pink,
                        ),
                        const SizedBox(width: 10),
                        Text('${patient.name} ${patient.surname}'),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        query = '${patient.name} ${patient.surname}';
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => PatientDetails(
                            name: patient.name,
                            surname: patient.surname,
                            age: patient.age,
                            gender: patient.gender,
                            primaryDiagnosis: patient.diagnosis,
                            patientId: patient.id,
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
