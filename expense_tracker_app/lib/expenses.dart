import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(title),
  ]
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("The Chart"),
          Text("Expenses List"),
        ],
      ),
    );
  }
}
