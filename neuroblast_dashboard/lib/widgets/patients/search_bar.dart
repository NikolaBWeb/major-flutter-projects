/* import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({super.key});
  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  String query = ''; // Move query to be a class member

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).patients;

    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 8),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (String value) {
            setState(() {
              query = value;
            });
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        // Filter the patients based on the search query
        final filteredPatients = patients
            ?.where(
              (patient) =>
                  patient.name.toLowerCase().contains(query.toLowerCase()) ||
                  patient.surname.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        // Return the list of suggestions
        return List<ListTile>.generate(filteredPatients?.length ?? 0,
            (int index) {
          final patient = filteredPatients![index];
          return ListTile(
            title: Text(
              '${patient.name} ${patient.surname}',
            ), // Display patient's name and surname
            onTap: () {
              controller.closeView('${patient.name} ${patient.surname}');
            },
          );
        });
      },
    );
  }
}
 */