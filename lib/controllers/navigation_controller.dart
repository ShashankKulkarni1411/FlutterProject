import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentPage = 'dashboard'.obs;
  var currentIndex = 0.obs;

  void changePage(int index) {
    print('Changing page to index: $index');
    currentIndex.value = index;

    switch (index) {
      case 0:
        currentPage.value = 'dashboard';
        print('Navigated to: dashboard');
        break;
      case 1:
        currentPage.value = 'analytics';
        print('Navigated to: analytics');
        break;
      case 2:
        currentPage.value = 'wallet';
        print('Navigated to: wallet');
        break;
      case 3:
        currentPage.value = 'profile';
        print('Navigated to: profile');
        break;
    }
    update();
  }

  void navigateTo(String page) {
    print('Navigating to: $page');
    currentPage.value = page;
    currentIndex.value = 0;
    update();
  }

  void backToDashboard() {
    print('Back to dashboard');
    currentPage.value = 'dashboard';
    currentIndex.value = 0;
    update();
  }
}
