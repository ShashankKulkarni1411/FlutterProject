import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Notifications')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification Channels',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                context: context,
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: settingsController.pushNotifications,
                onChanged: settingsController.setPushNotifications,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Email Notifications',
                subtitle: 'Get updates via email',
                value: settingsController.emailNotifications,
                onChanged: settingsController.setEmailNotifications,
              ),
              _buildSwitchTile(
                context: context,
                title: 'SMS Notifications',
                subtitle: 'Receive text message alerts',
                value: settingsController.smsNotifications,
                onChanged: settingsController.setSmsNotifications,
              ),
              const SizedBox(height: 24),
              const Text(
                'Activity Alerts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                context: context,
                title: 'Expense Alerts',
                subtitle: 'Get notified when expenses are added',
                value: settingsController.expenseAlerts,
                onChanged: settingsController.setExpenseAlerts,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Budget Warnings',
                subtitle: 'Alert when approaching budget limits',
                value: settingsController.budgetWarnings,
                onChanged: settingsController.setBudgetWarnings,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Payment Reminders',
                subtitle: 'Reminders for upcoming payments',
                value: settingsController.paymentReminders,
                onChanged: settingsController.setPaymentReminders,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Category Suggestions',
                subtitle: 'Smart suggestions for categorizing',
                value: settingsController.categorySuggestions,
                onChanged: settingsController.setCategorySuggestions,
              ),
              const SizedBox(height: 24),
              const Text(
                'Reports & Summaries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                context: context,
                title: 'Weekly Reports',
                subtitle: 'Summary of your weekly spending',
                value: settingsController.weeklyReports,
                onChanged: settingsController.setWeeklyReports,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Monthly Reports',
                subtitle: 'Detailed monthly financial report',
                value: settingsController.monthlyReports,
                onChanged: settingsController.setMonthlyReports,
              ),
              const SizedBox(height: 24),
              const Text(
                'Marketing & Updates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                context: context,
                title: 'Marketing Emails',
                subtitle: 'Promotional offers and deals',
                value: settingsController.marketingEmails,
                onChanged: settingsController.setMarketingEmails,
              ),
              _buildSwitchTile(
                context: context,
                title: 'Product Updates',
                subtitle: 'New features and improvements',
                value: settingsController.productUpdates,
                onChanged: settingsController.setProductUpdates,
              ),
              _buildSwitchTile(
                context: context,
                title: 'News & Tips',
                subtitle: 'Financial tips and articles',
                value: settingsController.newsAndTips,
                onChanged: settingsController.setNewsAndTips,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: accentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quiet Hours',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Set times when you don\'t want notifications',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'Quiet Hours',
                          'Feature coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text('Setup'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: accentColor),
        ],
      ),
    );
  }
}
