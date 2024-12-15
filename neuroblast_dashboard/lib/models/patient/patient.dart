import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  const Patient({
    required this.id,
    required this.name,
    required this.surname,
    required this.gender,
    required this.age,
    required this.diagnosis,
    required this.createdAt,
    this.notes = const [], // Initialize notes as an empty list
  });

  factory Patient.fromJson(Map<String, dynamic> json, String documentId) {
    return Patient(
      id: documentId,
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      age: json['age']?.toString() ?? '',
      diagnosis: json['primaryDiagnosis'] as String? ?? '',
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      notes: json['notes'] != null
          ? List<Map<String, dynamic>>.from(json['notes'] as Iterable<dynamic>)
          : [], // Initialize to an empty list if 'notes' is null
    );
  }

  final String id;
  final String name;
  final String surname;
  final String gender;
  final String age;
  final String diagnosis;
  final List<Map<String, dynamic>> notes; // Store notes directly
  final Timestamp createdAt;
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'gender': gender,
      'age': age,
      'diagnosis': diagnosis,
      'notes': notes, // Include notes in the JSON representation
      'createdAt': createdAt,
    };
  }
}
