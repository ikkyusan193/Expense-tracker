import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../model/expense.dart';
import 'database_helper.dart';

// class connected to database
// all function related to queries will be put here
class QueryController {

  DatabaseHelper connection = DatabaseHelper();

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Expense>> allExpense() async {
    // Get a reference to the database.
    final db = await connection.database;
    var expenses = await db.query('EXPENSE', orderBy: 'date DESC');
    List<Expense> expenseList = expenses.isNotEmpty
    ? expenses.map((c) => Expense.fromMap(c)).toList() : [];
    return expenseList;
  }

  Future<List<Expense>> allByCategory(String category) async{
    final db = await connection.database;
    final expenses = await db.rawQuery('SELECT * FROM EXPENSE WHERE category=? ORDER BY date DESC', [category]);
    List<Expense> expenseList = expenses.isNotEmpty
        ? expenses.map((c) => Expense.fromMap(c)).toList() : [];
    return expenseList;
  }

  Future<int> add(Expense expense) async {
    final db = await connection.database; // Get a reference to the database.
    return await db.insert(
      'EXPENSE',
      expense.toMap()
    );
  }

  Future<void> update(Expense expense) async {
    // Get a reference to the database.
    final db = await connection.database;
    // Update the given Dog.
    await db.update(
      'EXPENSE',
      expense.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [expense.id],
    );
  }

  Future<void> delete(int? id) async {
    // Get a reference to the database.
    final db = await connection.database;
    // Remove the Dog from the database.
    await db.delete(
      'EXPENSE',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  
  Future sumAll() async{
    final db = await connection.database;
    var sum = await db.rawQuery("SELECT SUM(cost) AS SUM FROM EXPENSE");
    return sum.toList();
  }

  Future sumCategory() async{
    final db = await connection.database;
    var sum = await db.rawQuery("SELECT category, SUM(cost) as SUM FROM EXPENSE GROUP BY category");
    return sum.toList();
  }
  
  Future sumCount() async{
    final db = await connection.database;
    var sum = await db.rawQuery("SELECT category, COUNT(category) as SUM FROM EXPENSE GROUP BY category");
    return sum.toList();
  }

}