import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  //var _enteredTitle = '';
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }
  void _presentDatePicker() async {
    final now = DateTime.now();

    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      //--->future method that return value in future asynchronous computation
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    //print(pickedDate); // this line execute when pickedDate has value obtainind from shoDatePicker
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Invalid Input"),
                  content: const Text(
                      "Please male sure valid title,amount,date and category was enterted"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text("Okay"))
                  ]));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    'Please make sure valid title,amount,date and category was entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay"),
                  ),
                ],
              ));
    }
  }

  void _submitExpenseData() {
    final validTitle = _titleController.text.trim().isEmpty;

    final enteredAmount = double.tryParse(_amountController
        .text); // tryParse("1.21")-->1.21,tryparse("hie")-->null

    final validAmount = enteredAmount == null || enteredAmount <= 0;

    final dateNotEmpty = _selectedDate == null;

    if (validTitle || validAmount || dateNotEmpty) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      //this code will execute if input is proper
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();

    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      // print(constraints.minWidth);
      //print(constraints.maxWidth);
      //print(constraints.maxHeight);
      //print(constraints.minHeight);
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        //width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboard + 16),
            child: Column(
              children: [
                if (width > 430)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                            controller: _titleController,
                            keyboardType: TextInputType.text,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text("Title"),
                            )),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      )
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width > 430)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values.map((category) {
                          return DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()));
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      Text(_selectedDate == null
                          ? 'No Selected Date'
                          : formatter.format(
                              _selectedDate!)), //--->! is used so that _selexctedDate will not give null value
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _presentDatePicker,
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          // onChanged: _saveTitleInput,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: const InputDecoration(
                            label: Text("Amount"),
                            prefixText: '\$',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      //const Spacer(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No Selected Date'
                                : formatter.format(
                                    _selectedDate!)), //--->! is used so that _selexctedDate will not give null value
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: _presentDatePicker,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width > 430)
                  Row(
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values.map((category) {
                          return DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()));
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
