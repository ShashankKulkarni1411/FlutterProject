import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/dashboard_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/split_bill_screen.dart';
import 'screens/select_contacts_screen.dart';
import 'screens/investment_hub_screen.dart';
import 'controllers/navigation_controller.dart';

void main() {
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF06B6D4),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return Scaffold(
          body: Obx(() => _buildScreen(controller.currentPage.value)),
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.changePage(index),
                backgroundColor: const Color(0xFF1E293B),
                selectedItemColor: const Color(0xFF06B6D4),
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: 'Analytics'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.wallet), label: 'Wallet'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Profile'),
                ],
              )),
        );
      },
    );
  }

  Widget _buildScreen(String page) {
    switch (page) {
      case 'dashboard':
        return const DashboardScreen();
      case 'scanner':
        return const ScannerScreen();
      case 'expense':
        return const AddExpenseScreen();
      case 'splitbill':
        return const SplitBillScreen();
      case 'contacts':
        return const SelectContactsScreen();
      case 'invest':
        return const InvestmentHubScreen();
      default:
        return const DashboardScreen();
    }
  }
}
