class Doctor {
  Doctor({
    required this.name,
    required this.surname,
    required this.email,
  });
  final String name;
  final String surname;
  final String email;

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'email': email,
      };
}
