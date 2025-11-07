import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';

// Screens
import 'screens/dashboard_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/split_bill_screen.dart';
import 'screens/select_contacts_screen.dart';
import 'screens/investment_hub_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/profile_screen.dart';

// Controllers
import 'controllers/navigation_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetX controllers
  final themeController = Get.put(ThemeController());
  final settingsController = Get.put(SettingsController());
  Get.put(NavigationController());

  // Load settings before running the app
  await Future.wait([
    themeController.loadInitialSettings(),
    settingsController.loadInitialSettings(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // Access both observables to ensure Obx rebuilds when either changes
      final themeMode = themeController.themeMode;
      final accentColor = themeController.accentColor;
      
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance App',
        theme: themeController.getLightTheme(),
        darkTheme: themeController.getDarkTheme(),
        themeMode: themeMode,
        home: const SplashScreen(),
      );
    });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return Scaffold(
          body: Obx(() => _buildScreen(controller.currentPage.value)),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
                controller.changePage(index);
              },
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E293B)
                  : Colors.white,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Analytics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreen(String page) {
    switch (page) {
      case 'dashboard':
        return const DashboardScreen();
      case 'analytics':
        return const AnalyticsScreen();
      case 'wallet':
        return const WalletScreen();
      case 'profile':
        return const ProfileScreen();
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
