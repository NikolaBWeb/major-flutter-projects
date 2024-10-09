import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/models/patient/patient.dart';

final patientsProvider = ChangeNotifierProvider<PatientsProvider>((ref) {
  return PatientsProvider();
});

class PatientsProvider extends ChangeNotifier {
  // Holds any error message

  PatientsProvider() {
    _listenToPatients(); // Start listening to patients when the provider is initialized
  }
  List<Patient>? _patients; // Holds the list of patients
  bool _isLoading = true; // Indicates if data is being loaded
  String? _error;

  List<Patient>? get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _listenToPatients() {
    FirebaseFirestore.instance.collection('patients').snapshots().listen(
      (snapshot) {
        _isLoading = true;
        notifyListeners();

        _patients = snapshot.docs.map((doc) {
          final data = doc.data();
          return Patient.fromJson(data, doc.id);
        }).toList();

        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        print('Error listening to patients: $e');
        _error = 'Failed to load patients: $e';
        _patients = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> clearAllPatients() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Delete all documents in the 'patients' collection
      final snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Clear the local list of patients
      _patients = [];
      _error = null;
    } catch (e) {
      print('Error clearing patients: $e');
      _error = 'Failed to clear patients: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
