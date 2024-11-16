import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neuroblast_dashboard/widgets/patients/patient_details.dart';
import 'package:neuroblast_dashboard/providers/patients_provider.dart';

class PatientList extends ConsumerStatefulWidget {
  const PatientList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientListState();
}

class _PatientListState extends ConsumerState<PatientList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget _buildPatientCard(Map<String, dynamic> patient, String patientId) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      elevation: 1,
      child: ListTile(
        title: Text('${patient['name']} ${patient['surname']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gender: ${patient['gender']}'),
            Text('Age: ${patient['age']}'),
            Text('Primary Diagnosis: ${patient['primaryDiagnosis']}'),
          ],
        ),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Patient Details', style: TextStyle(fontSize: 13)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward),
          ],
        ),
        onTap: () => _navigateToDetails(patient, patientId),
      ),
    );
  }

  Widget _buildPatientGrid(Map<String, dynamic> patient, String patientId) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _navigateToDetails(patient, patientId),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${patient['name']} ${patient['surname']}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Gender: ${patient['gender']}'),
              Text('Age: ${patient['age']}'),
              Text('Primary Diagnosis: ${patient['primaryDiagnosis']}'),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Details', style: TextStyle(fontSize: 13)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(Map<String, dynamic> patient, String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => PatientDetails(
          name: patient['name'] as String,
          surname: patient['surname'] as String,
          age: patient['age'] as String,
          gender: patient['gender'] as String,
          primaryDiagnosis: patient['primaryDiagnosis'] as String,
          patientId: patientId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewType = ref.watch(patientsProvider).viewType;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patients')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Error loading patients: ${snapshot.error}'),);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No patients found'));
        }

        final patients = snapshot.data!.docs;

        return viewType == PatientViewType.list
            ? ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient =
                      patients[index].data()! as Map<String, dynamic>;
                  return _buildPatientCard(patient, patients[index].id);
                },
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient =
                      patients[index].data()! as Map<String, dynamic>;
                  return _buildPatientGrid(patient, patients[index].id);
                },
              );
      },
    );
  }
}
