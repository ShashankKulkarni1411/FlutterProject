import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Currency
  final _selectedCurrency = 'INR'.obs;
  final _currencySymbol = '₹'.obs;

  // Notifications
  final _pushNotifications = true.obs;
  final _emailNotifications = true.obs;
  final _smsNotifications = false.obs;
  final _expenseAlerts = true.obs;
  final _budgetWarnings = true.obs;
  final _weeklyReports = true.obs;
  final _monthlyReports = true.obs;
  final _paymentReminders = true.obs;
  final _categorySuggestions = false.obs;
  final _marketingEmails = false.obs;
  final _productUpdates = true.obs;
  final _newsAndTips = true.obs;

  // Privacy & Security
  final _biometricAuth = true.obs;
  final _autoLock = true.obs;
  final _dataSharing = false.obs;
  final _analyticsTracking = true.obs;

  // Getters
  String get selectedCurrency => _selectedCurrency.value;
  String get currencySymbol => _currencySymbol.value;

  bool get pushNotifications => _pushNotifications.value;
  bool get emailNotifications => _emailNotifications.value;
  bool get smsNotifications => _smsNotifications.value;
  bool get expenseAlerts => _expenseAlerts.value;
  bool get budgetWarnings => _budgetWarnings.value;
  bool get weeklyReports => _weeklyReports.value;
  bool get monthlyReports => _monthlyReports.value;
  bool get paymentReminders => _paymentReminders.value;
  bool get categorySuggestions => _categorySuggestions.value;
  bool get marketingEmails => _marketingEmails.value;
  bool get productUpdates => _productUpdates.value;
  bool get newsAndTips => _newsAndTips.value;

  bool get biometricAuth => _biometricAuth.value;
  bool get autoLock => _autoLock.value;
  bool get dataSharing => _dataSharing.value;
  bool get analyticsTracking => _analyticsTracking.value;

  @override
  void onInit() {
    super.onInit();
    // Don't load here, will be loaded in main
  }

  // Load initial settings - called from main before app starts
  Future<void> loadInitialSettings() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load currency
    _selectedCurrency.value = prefs.getString('currency') ?? 'INR';
    _currencySymbol.value = prefs.getString('currencySymbol') ?? '₹';

    // Load notifications
    _pushNotifications.value = prefs.getBool('pushNotifications') ?? true;
    _emailNotifications.value = prefs.getBool('emailNotifications') ?? true;
    _smsNotifications.value = prefs.getBool('smsNotifications') ?? false;
    _expenseAlerts.value = prefs.getBool('expenseAlerts') ?? true;
    _budgetWarnings.value = prefs.getBool('budgetWarnings') ?? true;
    _weeklyReports.value = prefs.getBool('weeklyReports') ?? true;
    _monthlyReports.value = prefs.getBool('monthlyReports') ?? true;
    _paymentReminders.value = prefs.getBool('paymentReminders') ?? true;
    _categorySuggestions.value = prefs.getBool('categorySuggestions') ?? false;
    _marketingEmails.value = prefs.getBool('marketingEmails') ?? false;
    _productUpdates.value = prefs.getBool('productUpdates') ?? true;
    _newsAndTips.value = prefs.getBool('newsAndTips') ?? true;

    // Load privacy & security
    _biometricAuth.value = prefs.getBool('biometricAuth') ?? true;
    _autoLock.value = prefs.getBool('autoLock') ?? true;
    _dataSharing.value = prefs.getBool('dataSharing') ?? false;
    _analyticsTracking.value = prefs.getBool('analyticsTracking') ?? true;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currency', _selectedCurrency.value);
    await prefs.setString('currencySymbol', _currencySymbol.value);

    await prefs.setBool('pushNotifications', _pushNotifications.value);
    await prefs.setBool('emailNotifications', _emailNotifications.value);
    await prefs.setBool('smsNotifications', _smsNotifications.value);
    await prefs.setBool('expenseAlerts', _expenseAlerts.value);
    await prefs.setBool('budgetWarnings', _budgetWarnings.value);
    await prefs.setBool('weeklyReports', _weeklyReports.value);
    await prefs.setBool('monthlyReports', _monthlyReports.value);
    await prefs.setBool('paymentReminders', _paymentReminders.value);
    await prefs.setBool('categorySuggestions', _categorySuggestions.value);
    await prefs.setBool('marketingEmails', _marketingEmails.value);
    await prefs.setBool('productUpdates', _productUpdates.value);
    await prefs.setBool('newsAndTips', _newsAndTips.value);

    await prefs.setBool('biometricAuth', _biometricAuth.value);
    await prefs.setBool('autoLock', _autoLock.value);
    await prefs.setBool('dataSharing', _dataSharing.value);
    await prefs.setBool('analyticsTracking', _analyticsTracking.value);
  }

  // Currency methods
  void setCurrency(String code, String symbol) {
    _selectedCurrency.value = code;
    _currencySymbol.value = symbol;
    _saveSettings();
    update(); // Notify GetBuilder listeners
  }

  // Notification methods
  void setPushNotifications(bool value) {
    _pushNotifications.value = value;
    _saveSettings();
  }

  void setEmailNotifications(bool value) {
    _emailNotifications.value = value;
    _saveSettings();
  }

  void setSmsNotifications(bool value) {
    _smsNotifications.value = value;
    _saveSettings();
  }

  void setExpenseAlerts(bool value) {
    _expenseAlerts.value = value;
    _saveSettings();
  }

  void setBudgetWarnings(bool value) {
    _budgetWarnings.value = value;
    _saveSettings();
  }

  void setWeeklyReports(bool value) {
    _weeklyReports.value = value;
    _saveSettings();
  }

  void setMonthlyReports(bool value) {
    _monthlyReports.value = value;
    _saveSettings();
  }

  void setPaymentReminders(bool value) {
    _paymentReminders.value = value;
    _saveSettings();
  }

  void setCategorySuggestions(bool value) {
    _categorySuggestions.value = value;
    _saveSettings();
  }

  void setMarketingEmails(bool value) {
    _marketingEmails.value = value;
    _saveSettings();
  }

  void setProductUpdates(bool value) {
    _productUpdates.value = value;
    _saveSettings();
  }

  void setNewsAndTips(bool value) {
    _newsAndTips.value = value;
    _saveSettings();
  }

  // Privacy & Security methods
  void setBiometricAuth(bool value) {
    _biometricAuth.value = value;
    _saveSettings();
  }

  void setAutoLock(bool value) {
    _autoLock.value = value;
    _saveSettings();
  }

  void setDataSharing(bool value) {
    _dataSharing.value = value;
    _saveSettings();
  }

  void setAnalyticsTracking(bool value) {
    _analyticsTracking.value = value;
    _saveSettings();
  }
}
