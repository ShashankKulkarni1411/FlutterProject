import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentPage = 'dashboard'.obs;
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        currentPage.value = 'dashboard';
        break;
      case 1:
        currentPage.value = 'analytics';
        break;
      case 2:
        currentPage.value = 'wallet';
        break;
      case 3:
        currentPage.value = 'profile';
        break;
    }
  }

  void navigateTo(String page) {
    currentPage.value = page;
    update();
  }

  void backToDashboard() {
    currentPage.value = 'dashboard';
    currentIndex.value = 0;
    update();
  }
}
