// ignore_for_file: public_member_api_docs

class Patient {
  const Patient({
    required this.name,
    required this.surname,
    required this.gender,
    required this.age,
    required this.diagnosis,
  });
  final String name;
  final String surname;
  final String gender;
  final String age;
  final String diagnosis;
}
