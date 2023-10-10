import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets//chart/chart_bar.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() =>
      _ExpensesState(); // return instance of state class
}

class _ExpensesState extends State<Expenses> {
  void _addExpense(Expense expense) {
    final expenseIndex = _registeredexpenses.indexOf(expense);
    setState(() {
      _registeredexpenses.add(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Expense Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredexpenses.insert(expenseIndex, expense);
              });
            })));
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredexpenses.remove(expense);
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context, //this context is of Expense widget tree
        isScrollControlled: true,
        builder: (ctx) {
          // this context(ctx) is of bottomsheet appearing after click on the icon
          return NewExpense(
              onAddExpense:
                  _addExpense); //passing function as named argument value to new_expense constructor
        });
  }

  final List<Expense> _registeredexpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(width);
    //final height = MediaQuery.of(context).size.height;
    Widget maincontent =
        const Center(child: Text("No Expense found.Start adding some !"));

    if (_registeredexpenses.isNotEmpty) {
      maincontent = ExpensesList(
        expenses: _registeredexpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Flutter Expense Tracker"), actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ]),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredexpenses),
                  Expanded(child: maincontent),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredexpenses)),
                  Expanded(child: maincontent)
                ],
              ));
  }
}
