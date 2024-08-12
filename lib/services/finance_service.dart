import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persoal_finance/models/expense_model.dart';
import 'package:persoal_finance/models/income_model.dart';

class UserService with ChangeNotifier{

  static const String _incomeBoxName = 'incomes';
  static const String _expenseBoxName = 'expense';

  double _totalIncomes=0.0;
  double _totalExpense=0.0;

  double get totalIncome=>_totalIncomes;
  double get totalExpense=>_totalExpense;

  Future<void> calculateTotalIncomeForUser(String userId) async {
    await _calculateTotalIncome(userId);
    notifyListeners();
  }
  Future<void> calculateTotalExpenseForUser(String userId) async {
    await _calculateTotalExpense(userId);
    notifyListeners();
  }

  Future<Box<IncomeModel>> openIncomeBox()async{
    return await Hive.openBox<IncomeModel>(_incomeBoxName);
  }

  Future <Box<ExpenseModel>> openExpenseBox()async{
    return await Hive.openBox<ExpenseModel>(_expenseBoxName);
  }

  Future<void> addIncome(IncomeModel income)async{
    final incomeBox = await openIncomeBox();
    await incomeBox.add(income);
    await _calculateTotalIncome(income.uid);
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense)async{
    final expenseBox = await openExpenseBox();
    await expenseBox.add(expense);
    await _calculateTotalExpense(expense.uid);
    notifyListeners();
  }

  Future<List<IncomeModel>> getAllIncome(String uid)async{
    final incomeBox = await openIncomeBox();
    return incomeBox.values.where((income)=> income.uid == uid).toList();
  }

  Future<List<ExpenseModel>> getAllExpense(String uid)async{
    final expenseBox = await openExpenseBox();
    return expenseBox.values.where((expense)=> expense.uid == uid).toList();
  }

  Future<void> _calculateTotalIncome(String uid)async{
    final incomeBox =await openIncomeBox();
    final List<IncomeModel> incomes =await getAllIncome(uid);
    _totalIncomes = incomes.fold(0.0, (previousValue, income)=>previousValue+income.amount);
  }

  Future<void> _calculateTotalExpense(String uid)async{
    final expenseBox =await openExpenseBox();
    final List<ExpenseModel> expenses =await getAllExpense(uid);
    _totalExpense = expenses.fold(0.0, (previousValue, expense)=>previousValue+expense.amount);
  }



}