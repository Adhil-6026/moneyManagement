import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persoal_finance/constants/colors.dart';
import 'package:persoal_finance/models/expense_model.dart';
import 'package:persoal_finance/models/income_model.dart';
import 'package:persoal_finance/models/user_model.dart';
import 'package:persoal_finance/screens/add_expense.dart';
import 'package:persoal_finance/screens/add_income.dart';
import 'package:persoal_finance/screens/expense_list.dart';
import 'package:persoal_finance/screens/home_page.dart';
import 'package:persoal_finance/screens/income_list.dart';
import 'package:persoal_finance/screens/login_page.dart';
import 'package:persoal_finance/screens/profile_page.dart';
import 'package:persoal_finance/screens/register_page.dart';
import 'package:persoal_finance/screens/splash_page.dart';
import 'package:persoal_finance/services/auth_services.dart';
import 'package:persoal_finance/services/finance_service.dart';
import 'package:provider/provider.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IncomeModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());

  await AuthService().openBox();
  await UserService().openIncomeBox();
  await UserService().openExpenseBox();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> AuthService()),
        ChangeNotifierProvider(create: (context)=> UserService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme(displaySmall: TextStyle(color: Colors.white, fontSize: 17)),
          scaffoldBackgroundColor: scaffoldColor
        ),
        initialRoute: '/',
        routes: {
          '/':(context)=>const SplashPage(),
          'login':(context)=> const LoginPage(),
          'register':(context)=> const RegisterPage(),
          'home':(context)=> const HomePage(),
          'addExpense':(context)=> const AddExpense(),
          'addIncome':(context)=> const AddIncome(),
          'profile':(context)=> const ProfilePage(),
          'incomeList':(context)=> const IncomeList(),
          'expenseList':(context)=> const ExpenseList(),
        },
      ),
    );
  }
}