import 'package:flutter/material.dart';

class PatientInfoRow extends StatelessWidget {
  const PatientInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(15), child: Text('Name')),
        Padding(padding: EdgeInsets.all(15), child: Text('Gender')),
        Padding(padding: EdgeInsets.all(15), child: Text('Age')),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text('Primary Diagnosis'),
        ),
      ],
    );
  }
}
