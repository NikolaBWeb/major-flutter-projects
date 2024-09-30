import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neuroblast_dashboard/models/patient/patient.dart';

final patientsProvider = ChangeNotifierProvider<PatientsProvider>((ref) {
  return PatientsProvider();
});

class PatientsProvider extends ChangeNotifier {
  final List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  void addPatient(Patient patient) {
    _patients.add(patient);
    notifyListeners();
  }
}
