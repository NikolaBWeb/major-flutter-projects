import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neuroblast_dashboard/widgets/patients/patient_details.dart';

class PatientList extends ConsumerStatefulWidget {
  const PatientList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientListState();
}

class _PatientListState extends ConsumerState<PatientList> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('patients')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Add debug prints

        if (snapshot.hasError) print('Error: ${snapshot.error}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading patients: ${snapshot.error}'),
          ); // Error message
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No patients found'),
          ); // No data message
        } else {
          final patients = snapshot.data!.docs;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index].data()! as Map<String, dynamic>;
              final clickedPatientId = patients[index].id;
              // Add debug print for each patient

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text('${patient['name']} ${patient['surname']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender: ${patient['gender']}'),
                      Text('Age: ${patient['age']}'),
                      Text(
                        'Primary Diagnosis: ${patient['primaryDiagnosis']}',
                      ), // Changed 'pr' to 'primaryDiagnosis' for clarity
                    ],
                  ),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ), // Changed trailing to a Row
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => PatientDetails(
                          name: patient['name'] as String,
                          surname: patient['surname'] as String,
                          age: patient['age'] as String,
                          gender: patient['gender'] as String,
                          primaryDiagnosis:
                              patient['primaryDiagnosis'] as String,
                          patientId: clickedPatientId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
