import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Getting Started',
      'icon': Icons.rocket_launch_outlined,
      'questions': [
        {
          'q': 'How do I create an account?',
          'a':
              'Download the app, tap "Sign Up", and follow the registration process. You\'ll need to provide your email and create a secure password.',
        },
        {
          'q': 'How do I add my first expense?',
          'a':
              'Tap the "+" button on the home screen, enter the amount, select a category, and save. You can also add notes and receipts.',
        },
        {
          'q': 'Can I import my existing data?',
          'a':
              'Yes! Go to Settings > Import Data and upload your CSV or Excel file. We support most standard formats.',
        },
      ],
    },
    {
      'title': 'Expenses & Budgets',
      'icon': Icons.account_balance_wallet_outlined,
      'questions': [
        {
          'q': 'How do I set up a budget?',
          'a':
              'Go to Budgets tab, tap "Create Budget", set your limit, choose categories, and set the time period (weekly/monthly).',
        },
        {
          'q': 'Can I edit or delete expenses?',
          'a':
              'Yes, tap on any expense to view details. You can edit or delete it from the options menu.',
        },
        {
          'q': 'How do categories work?',
          'a':
              'Categories help organize your spending. You can use default categories or create custom ones in Settings.',
        },
      ],
    },
    {
      'title': 'Reports & Analytics',
      'icon': Icons.analytics_outlined,
      'questions': [
        {
          'q': 'How do I view my spending reports?',
          'a':
              'Navigate to the Analytics tab to see charts, trends, and detailed breakdowns of your spending patterns.',
        },
        {
          'q': 'Can I export reports?',
          'a':
              'Yes, you can export reports as PDF or CSV from the Analytics screen using the export button.',
        },
        {
          'q': 'What insights does the app provide?',
          'a':
              'The app analyzes your spending habits and provides personalized insights, alerts, and recommendations.',
        },
      ],
    },
    {
      'title': 'Account & Security',
      'icon': Icons.security_outlined,
      'questions': [
        {
          'q': 'Is my financial data secure?',
          'a':
              'Yes, we use bank-level encryption and security measures. Your data is encrypted both in transit and at rest.',
        },
        {
          'q': 'How do I reset my password?',
          'a':
              'On the login screen, tap "Forgot Password" and follow the instructions sent to your email.',
        },
        {
          'q': 'Can I use biometric authentication?',
          'a':
              'Yes, enable fingerprint or face ID in Settings > Privacy & Security > Biometric Authentication.',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _faqCategories;
    }
    return _faqCategories
        .map((category) {
          final filteredQuestions = category['questions']
              .where(
                (q) =>
                    q['q'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    q['a'].toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
          return filteredQuestions.isNotEmpty
              ? {...category, 'questions': filteredQuestions}
              : null;
        })
        .where((c) => c != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Help Center')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for help...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        isDark: isDark,
                        accentColor: accentColor,
                        icon: Icons.video_library_outlined,
                        title: 'Video Tutorials',
                        onTap: () => Get.snackbar(
                          'Video Tutorials',
                          'Opening video tutorials',
                          snackPosition: SnackPosition.BOTTOM,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        isDark: isDark,
                        accentColor: accentColor,
                        icon: Icons.chat_outlined,
                        title: 'Live Chat',
                        onTap: () => Get.snackbar(
                          'Live Chat',
                          'Starting live chat',
                          snackPosition: SnackPosition.BOTTOM,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                return _buildFAQCategory(
                  _filteredCategories[index],
                  isDark,
                  accentColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required bool isDark,
    required Color accentColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: accentColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCategory(
    Map<String, dynamic> category,
    bool isDark,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : Colors.grey[300]!,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(category['icon'] as IconData, color: accentColor),
          title: Text(
            category['title'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          children: [
            ...List.generate(
              category['questions'].length,
              (index) => _buildFAQItem(category['questions'][index], isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          title: Text(
            faq['q']!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                faq['a']!,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
