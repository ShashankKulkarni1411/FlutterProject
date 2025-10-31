import 'package:get/get.dart';
import '../screens/scanner_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/split_bill_screen.dart';
import '../screens/investment_hub_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/select_contacts_screen.dart';
import '../screens/dashboard_screen.dart';

class NavigationController extends GetxController {
  var currentPage = 'dashboard'.obs;
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        currentPage.value = 'dashboard';
        Get.offAll(() => const DashboardScreen());
        break;
      case 1:
        currentPage.value = 'analytics';
        Get.to(() => const AnalyticsScreen());
        break;
      case 2:
        currentPage.value = 'wallet';
        Get.to(() => const WalletScreen());
        break;
      case 3:
        currentPage.value = 'profile';
        Get.to(() => const ProfileScreen());
        break;
    }
  }

  void navigateTo(String page) {
    currentPage.value = page;
    currentIndex.value = 0;
    
    switch (page) {
      case 'dashboard':
        Get.offAll(() => const DashboardScreen());
        break;
      case 'scanner':
        Get.to(() => const ScannerScreen());
        break;
      case 'expense':
        Get.to(() => const AddExpenseScreen());
        break;
      case 'splitbill':
        Get.to(() => const SplitBillScreen());
        break;
      case 'invest':
        Get.to(() => const InvestmentHubScreen());
        break;
      case 'analytics':
        Get.to(() => const AnalyticsScreen());
        break;
      case 'wallet':
        Get.to(() => const WalletScreen());
        break;
      case 'profile':
        Get.to(() => const ProfileScreen());
        break;
      case 'contacts':
        Get.to(() => const SelectContactsScreen());
        break;
    }
  }

  void backToDashboard() {
    currentPage.value = 'dashboard';
    currentIndex.value = 0;
    Get.back();
  }
}
