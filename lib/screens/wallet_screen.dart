/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String selectedTab = 'Overview'; // Overview, Insights, Goals

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        title: const Text("Alex's Wallet"),
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=3',
            ),
            radius: 20,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Selector
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: ['Overview', 'Insights', 'Goals'].map((tab) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = tab),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedTab == tab
                              ? const Color(0xFF06B6D4).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: selectedTab == tab
                              ? Border.all(color: const Color(0xFF06B6D4))
                              : null,
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedTab == tab
                                ? const Color(0xFF06B6D4)
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            if (selectedTab == 'Overview') ...[
              // Total Balance Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Total Balance',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 8),
                        Text('₹25,000',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('+18%',
                          style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Income and Expenses
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Income',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11)),
                          SizedBox(height: 8),
                          Text('₹45,000',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Expenses',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11)),
                          SizedBox(height: 8),
                          Text('₹12,500',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEA580C))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Smart Wallet Overview
              const Text('Smart Wallet Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _WalletCard(
                    title: 'Spend This Week',
                    amount: '₹3,250',
                    subtitle: '↑8% vs last week',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Weekly spending details')),
                    ),
                  ),
                  _WalletCard(
                    title: 'Pending Dues',
                    amount: '₹1,800',
                    subtitle: 'Next due: 2 days',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pending dues details')),
                    ),
                  ),
                  _WalletCard(
                    title: 'Top Category',
                    amount: 'Food & Dining',
                    subtitle: '₹4,200 this month',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Top category details')),
                    ),
                  ),
                  _WalletCard(
                    title: 'Investable Funds',
                    amount: '₹5,000',
                    subtitle: '20% of balance',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Investment options')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Money Health Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF8B5CF6), width: 3),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('78',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Text('/100',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Money Health Score',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                              'Your financial health is good, but\nthere\'s room for improvement.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('💡 Reduce dining expenses to\nimprove',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF06B6D4))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (selectedTab == 'Insights') ...[
              const Text('Insights & Analytics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: const [
                      Icon(Icons.analytics_outlined,
                          size: 64, color: Color(0xFF06B6D4)),
                      SizedBox(height: 16),
                      Text('Detailed insights coming soon',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Text('Savings Goals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: const [
                      Icon(Icons.flag_outlined,
                          size: 64, color: Color(0xFF06B6D4)),
                      SizedBox(height: 16),
                      Text('Goals management coming soon',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],

            // Recent Transactions
            if (selectedTab == 'Overview') ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Transactions',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('View all transactions')),
                    ),
                    child: const Text('View All',
                        style:
                            TextStyle(color: Color(0xFF06B6D4), fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TransactionTile(
                name: 'Starbucks',
                time: '10:30 AM',
                amount: '-₹450',
                icon: '☕',
              ),
              _TransactionTile(
                name: 'Amazon',
                time: 'Yesterday',
                amount: '-₹1,200',
                icon: '📦',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final VoidCallback onTap;

  const _WalletCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 11)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amount,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String name;
  final String time;
  final String amount;
  final String icon;

  const _TransactionTile({
    required this.name,
    required this.time,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name transaction details')),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(time,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Text(amount,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEA580C))),
          ],
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../firebase_service.dart';
import '../controllers/theme_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String selectedTab = 'Overview';
  Map<String, dynamic>? _analyticsData;
  bool _loadingAnalytics = false;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _loadingAnalytics = true);
    try {
      final data = await _firebaseService.getWalletAnalytics();
      setState(() {
        _analyticsData = data;
        _loadingAnalytics = false;
      });
    } catch (e) {
      setState(() => _loadingAnalytics = false);
      print('Error loading analytics: $e');
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return DateFormat('h:mm a').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firebaseService.getUserProfileStream(),
          builder: (context, snapshot) {
            final dataMap = snapshot.data?.data() as Map<String, dynamic>?;
            final userName = dataMap?['name'] ?? 'Alex';
            return Text("$userName's Wallet");
          },
        ),
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=3',
            ),
            radius: 20,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService.getUserProfileStream(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
          final totalBalance = (userData?['walletBalance'] ?? 25000).toDouble();
          final totalIncome = (userData?['totalIncome'] ?? 45000).toDouble();
          final totalExpenses = (userData?['totalExpenses'] ?? 12500).toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab Selector
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;
                    final themeController = Get.find<ThemeController>();
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.surfaceVariant),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: ['Overview', 'Insights', 'Goals'].map((tab) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTab = tab),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedTab == tab
                                      ? themeController.accentColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: selectedTab == tab
                                      ? Border.all(color: themeController.accentColor)
                                      : null,
                                ),
                                child: Text(
                                  tab,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedTab == tab
                                        ? themeController.accentColor
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                if (selectedTab == 'Overview') ...[
                  // Total Balance Card
                  Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.surfaceVariant),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Balance',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${totalBalance.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '+18%',
                                style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Income and Expenses
                  Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colorScheme.surfaceVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Income',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${totalIncome.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colorScheme.surfaceVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expenses',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${totalExpenses.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEA580C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Smart Wallet Overview
                  Text(
                    'Smart Wallet Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_loadingAnalytics)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _WalletCard(
                          title: 'Spend This Week',
                          amount: '₹${(_analyticsData?['weeklySpending'] ?? 3250).toStringAsFixed(0)}',
                          subtitle: '↑8% vs last week',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Weekly spending details')),
                          ),
                        ),
                        _WalletCard(
                          title: 'Pending Dues',
                          amount: '₹${(_analyticsData?['pendingDues'] ?? 1800).toStringAsFixed(0)}',
                          subtitle: 'Next due: 2 days',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pending dues details')),
                          ),
                        ),
                        _WalletCard(
                          title: 'Top Category',
                          amount: _analyticsData?['topCategory'] ?? 'Food & Dining',
                          subtitle: '₹${(_analyticsData?['topCategoryAmount'] ?? 4200).toStringAsFixed(0)} this month',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Top category details')),
                          ),
                        ),
                        _WalletCard(
                          title: 'Investable Funds',
                          amount: '₹${(_analyticsData?['investableFunds'] ?? 5000).toStringAsFixed(0)}',
                          subtitle: '20% of balance',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Investment options')),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Money Health Score
                  Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      final themeController = Get.find<ThemeController>();
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.surfaceVariant),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF8B5CF6),
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${_analyticsData?['healthScore'] ?? 78}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      '/100',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Money Health Score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your financial health is good, but\nthere\'s room for improvement.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '💡 Reduce dining expenses to\nimprove',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: themeController.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Recent Transactions
                  Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      final themeController = Get.find<ThemeController>();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('View all transactions')),
                            ),
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: themeController.accentColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  StreamBuilder<QuerySnapshot>(
                    stream: _firebaseService.getTransactionsStream(limit: 5),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        final colorScheme = Theme.of(context).colorScheme;
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.surfaceVariant),
                          ),
                          child: Center(
                            child: Text(
                              'No transactions yet',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }

                      final transactions = snapshot.data!.docs;

                      return Column(
                        children: transactions.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return _TransactionTile(
                            name: data['name'] ?? 'Transaction',
                            time: _formatTimestamp(data['timestamp']),
                            amount: data['type'] == 'income'
                                ? '+₹${(data['amount'] ?? 0).toStringAsFixed(0)}'
                                : '-₹${(data['amount'] ?? 0).toStringAsFixed(0)}',
                            icon: data['icon'] ?? '🛍️',
                          );
                        }).toList(),
                      );
                    },
                  ),
                ] else if (selectedTab == 'Insights') ...[
                  Text(
                    'Insights & Analytics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: const [
                          Icon(Icons.analytics_outlined,
                              size: 64, color: Color(0xFF06B6D4)),
                          SizedBox(height: 16),
                          Text('Detailed insights coming soon',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Savings Goals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: const [
                          Icon(Icons.flag_outlined,
                              size: 64, color: Color(0xFF06B6D4)),
                          SizedBox(height: 16),
                          Text('Goals management coming soon',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final VoidCallback onTap;

  const _WalletCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String name;
  final String time;
  final String amount;
  final String icon;

  const _TransactionTile({
    required this.name,
    required this.time,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name transaction details')),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.surfaceVariant),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: amount.contains('+')
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEA580C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}