import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:persoal_finance/constants/colors.dart';
import 'package:persoal_finance/models/user_model.dart';
import 'package:persoal_finance/services/auth_services.dart';
import 'package:persoal_finance/widgets/app_text.dart';
import 'package:persoal_finance/widgets/dashboard_widget.dart';
import 'package:persoal_finance/widgets/my_divider.dart';
import 'package:provider/provider.dart';

import '../services/finance_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData(context);
    });
  }

  Future<void> _fetchInitialData(BuildContext context) async {
    final finService = Provider.of<UserService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userModel = await authService.getCurrentUser();
    if (userModel != null) {
      finService.calculateTotalIncomeForUser(userModel.id);
      finService.calculateTotalExpenseForUser(userModel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<UserService>(
        builder: (context, finService, _) {
          return _buildBody(context, finService);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserService finService) {
    final totalExpense = finService.totalExpense;
    final totalIncome = finService.totalIncome;

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return FutureBuilder<UserModel?>(
                  future: authService.getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        final userData = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      AppText(
                                        data: "Welcome!",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AppText(
                                        data: userData.name,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'profile');
                                  },
                                  child: CircleAvatar(
                                    child: Text(
                                      userData.name[0].toUpperCase(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const MyDivider(),
                            const SizedBox(height: 20,),
                            DashboardWidget(
                              onTap1: (){
                                Navigator.pushNamed(context, 'expenseList', arguments: totalExpense);
                              },
                              textOne: 'Expanse\n $totalExpense',
                              onTap2: (){
                                Navigator.pushNamed(context, 'incomeList', arguments: totalIncome);
                              },
                              textTwo: 'Income\n $totalIncome',
                            ),
                            const SizedBox(height: 20,),
                            DashboardWidget(
                                onTap1: (){
                                  Navigator.pushNamed(context, 'addExpense', arguments: userData.id);
                                },
                                textOne: 'Add Expanse',
                                onTap2: (){
                                  Navigator.pushNamed(context, 'addIncome', arguments: userData.id);
                                },
                                textTwo: 'Add Income'),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    data: "Income vs Expense",
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 20,),
                                  AspectRatio(
                                    aspectRatio: 1.3,
                                    child: PieChart(PieChartData(
                                      sectionsSpace: 5,
                                      centerSpaceColor: Colors.transparent,
                                      sections: [
                                        PieChartSectionData(
                                          radius: 50,
                                          color: chartColor1,
                                          value: finService.totalExpense,
                                          title: "Expense",
                                          titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          color: chartColor2,
                                          value: finService.totalIncome,
                                          title: "Income",
                                          radius: 50,
                                        ),
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}