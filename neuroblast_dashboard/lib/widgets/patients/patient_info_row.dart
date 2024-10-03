import 'package:flutter/material.dart';



/// A widget that displays a row of patient information including
/// Name, Gender, Age, and Primary Diagnosis.
///
/// This widget is designed to be used in a list of patients
/// to provide a quick overview of each patient's details.
class PatientInfoRow extends StatelessWidget {
  /// Creates an instance of [PatientInfoRow].
  ///
  /// The [key] parameter is used to uniquely identify the widget
  /// in the widget tree. It is optional and can be used for
  /// widget state management.
  const PatientInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Name',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Gender',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Age',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Primary Diagnosis',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
