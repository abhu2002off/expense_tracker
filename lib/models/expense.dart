import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid(); // object generates random id
final formatter = DateFormat.yMd(); //---->Utility class

/// object generate date in year/month/day format

enum Category { food, travel, leisure, work }

const categoryIcons = {
  //created map for icon where keys are enum values(Category) and values are Icons
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_class,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid
            .v4(); //Intializer Lists,id is not passed but we intialize with our value

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatteDate {
    // get methos uses other properties in class to return dervied properties
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0.0;
    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
