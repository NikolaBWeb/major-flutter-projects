import 'dart:io' as io;
import 'package:expense_tracker_app/main.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onAddExpense, super.key});

  final Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_priceController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showInvalidInputDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  void _showInvalidInputDialog() {
    if (io.Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure that valid title, amount, date, and category were entered'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure that valid title, amount, date, and category were entered'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? "No date selected"
              : formatter.format(_selectedDate!),
        ),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<Category>(
      value: _selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(
                category.name.toUpperCase(),
                style: TextStyle(
                  color: kColorScheme.onSecondaryContainer,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final isWideScreen = width >= 600;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
              child: Column(
                children: [
                  if (isWideScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _titleController,
                            label: "Title",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _priceController,
                            label: "Amount",
                            hintText: "Enter amount",
                            prefixText: '\$ ',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  else
                    _buildTextField(
                      controller: _titleController,
                      label: "Title",
                    ),
                  if (isWideScreen)
                    Row(
                      children: [
                        _buildCategoryDropdown(),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDateSelector()),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _priceController,
                            label: "Amount",
                            hintText: "Enter amount",
                            prefixText: '\$ ',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDateSelector()),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (isWideScreen)
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        _buildCategoryDropdown(),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
