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

  // Goal Dialog Methods
  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetAmountController = TextEditingController();
    final currentAmountController = TextEditingController(text: '0');
    String selectedCategory = 'vacation';
    String selectedIcon = '🏖️';
    DateTime? selectedDate;

    final categoryIcons = {
      'vacation': '🏖️',
      'emergency': '🚨',
      'house': '🏠',
      'car': '🚗',
      'other': '🎯',
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colorScheme = Theme.of(context).colorScheme;
            final themeController = Get.find<ThemeController>();
            
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text('Add New Goal', style: TextStyle(color: colorScheme.onSurface)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Goal Name',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetAmountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Target Amount (₹)',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: currentAmountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Current Amount (₹)',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Category', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: colorScheme.surface,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                      items: categoryIcons.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text('${categoryIcons[category]} ${category[0].toUpperCase()}${category.substring(1)}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value!;
                          selectedIcon = categoryIcons[value]!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setDialogState(() => selectedDate = date);
                        }
                      },
                      icon: Icon(Icons.calendar_today, color: themeController.accentColor),
                      label: Text(
                        selectedDate == null
                            ? 'Select Target Date'
                            : 'Target: ${DateFormat('MMM d, yyyy').format(selectedDate!)}',
                        style: TextStyle(color: themeController.accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || 
                        targetAmountController.text.isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    try {
                      await _firebaseService.addGoal({
                        'name': nameController.text,
                        'targetAmount': double.parse(targetAmountController.text),
                        'currentAmount': double.parse(currentAmountController.text),
                        'targetDate': Timestamp.fromDate(selectedDate!),
                        'category': selectedCategory,
                        'icon': selectedIcon,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Goal created successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditGoalDialog(BuildContext context, String goalId, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name']);
    final targetAmountController = TextEditingController(
      text: (data['targetAmount'] ?? 0).toString(),
    );
    final currentAmountController = TextEditingController(
      text: (data['currentAmount'] ?? 0).toString(),
    );
    String selectedCategory = data['category'] ?? 'vacation';
    String selectedIcon = data['icon'] ?? '🎯';
    DateTime? selectedDate = (data['targetDate'] as Timestamp?)?.toDate();

    final categoryIcons = {
      'vacation': '🏖️',
      'emergency': '🚨',
      'house': '🏠',
      'car': '🚗',
      'other': '🎯',
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colorScheme = Theme.of(context).colorScheme;
            final themeController = Get.find<ThemeController>();
            
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text('Edit Goal', style: TextStyle(color: colorScheme.onSurface)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Goal Name',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetAmountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Target Amount (₹)',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: currentAmountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Current Amount (₹)',
                        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Category', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: colorScheme.surface,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.surfaceVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeController.accentColor),
                        ),
                      ),
                      items: categoryIcons.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text('${categoryIcons[category]} ${category[0].toUpperCase()}${category.substring(1)}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value!;
                          selectedIcon = categoryIcons[value]!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setDialogState(() => selectedDate = date);
                        }
                      },
                      icon: Icon(Icons.calendar_today, color: themeController.accentColor),
                      label: Text(
                        selectedDate == null
                            ? 'Select Target Date'
                            : 'Target: ${DateFormat('MMM d, yyyy').format(selectedDate!)}',
                        style: TextStyle(color: themeController.accentColor),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || 
                        targetAmountController.text.isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    try {
                      await _firebaseService.updateGoal(goalId, {
                        'name': nameController.text,
                        'targetAmount': double.parse(targetAmountController.text),
                        'currentAmount': double.parse(currentAmountController.text),
                        'targetDate': Timestamp.fromDate(selectedDate!),
                        'category': selectedCategory,
                        'icon': selectedIcon,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Goal updated successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String goalId) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text('Delete Goal?', style: TextStyle(color: colorScheme.onSurface)),
        content: Text(
          'Are you sure you want to delete this goal? This action cannot be undone.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.deleteGoal(goalId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Goal deleted successfully')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context, String goalId, Map<String, dynamic> data) {
    final amountController = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text('Add Money to Goal', style: TextStyle(color: colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['name'] ?? 'Goal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                hintText: 'Enter amount to add',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.surfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeController.accentColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an amount')),
                );
                return;
              }

              try {
                final amount = double.parse(amountController.text);
                await _firebaseService.updateGoalProgress(goalId, amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Money added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeController.accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
                  // Insights Page
                  _InsightsPage(firebaseService: _firebaseService),
                ] else ...[
                  // Goals Page
                  Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      final themeController = Get.find<ThemeController>();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Savings Goals',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showAddGoalDialog(context),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Goal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.accentColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Goals List
                          StreamBuilder<QuerySnapshot>(
                            stream: _firebaseService.getGoalsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 32),
                                      Text(
                                        'Error loading goals',
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () => setState(() {}),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final goals = snapshot.data?.docs ?? [];

                              if (goals.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(48),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.flag_outlined,
                                          size: 64,
                                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No goals yet',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Start saving for your dreams!',
                                          style: TextStyle(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: goals.map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  return _GoalCard(
                                    goalId: doc.id,
                                    name: data['name'] ?? 'Goal',
                                    targetAmount: (data['targetAmount'] ?? 0).toDouble(),
                                    currentAmount: (data['currentAmount'] ?? 0).toDouble(),
                                    targetDate: data['targetDate'] as Timestamp?,
                                    category: data['category'] ?? 'other',
                                    icon: data['icon'] ?? '🎯',
                                    onEdit: () => _showEditGoalDialog(context, doc.id, data),
                                    onDelete: () => _showDeleteConfirmation(context, doc.id),
                                    onAddMoney: () => _showAddMoneyDialog(context, doc.id, data),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      );
                    },
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

class _GoalCard extends StatelessWidget {
  final String goalId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final Timestamp? targetDate;
  final String category;
  final String icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddMoney;

  const _GoalCard({
    required this.goalId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.category,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();
    final progress = targetAmount > 0 ? (currentAmount / targetAmount) : 0.0;
    final progressPercentage = (progress * 100).clamp(0, 100).toInt();
    
    // Calculate days remaining
    String daysRemaining = 'No deadline';
    if (targetDate != null) {
      final deadline = targetDate!.toDate();
      final now = DateTime.now();
      final difference = deadline.difference(now).inDays;
      
      if (difference < 0) {
        daysRemaining = 'Overdue';
      } else if (difference == 0) {
        daysRemaining = 'Due today';
      } else if (difference == 1) {
        daysRemaining = '1 day remaining';
      } else {
        daysRemaining = '$difference days remaining';
      }
    }

    return GestureDetector(
      onTap: onAddMoney,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        daysRemaining,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: 18, color: themeController.accentColor),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${currentAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeController.accentColor,
                  ),
                ),
                Text(
                  'of ₹${targetAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(themeController.accentColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$progressPercentage% complete',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (progress >= 1.0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '✓ Completed',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                      ),
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

// Insights Page Widget
class _InsightsPage extends StatefulWidget {
  final FirebaseService firebaseService;

  const _InsightsPage({required this.firebaseService});

  @override
  State<_InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<_InsightsPage> {
  String selectedPeriod = 'Monthly';
  bool loading = false;
  List<Map<String, dynamic>> spendingTrends = [];
  Map<String, double> categoryBreakdown = {};
  List<Map<String, dynamic>> topMerchants = [];
  Map<String, dynamic>? budgetData;

  @override
  void initState() {
    super.initState();
    _loadInsightsData();
  }

  Future<void> _loadInsightsData() async {
    setState(() => loading = true);
    try {
      final trends = await widget.firebaseService.getSpendingTrends(period: selectedPeriod);
      final categories = await widget.firebaseService.getCategoryBreakdown(period: selectedPeriod);
      final merchants = await widget.firebaseService.getTopMerchants(limit: 5);
      final budget = await widget.firebaseService.getBudgetComparison();

      setState(() {
        spendingTrends = trends;
        categoryBreakdown = categories;
        topMerchants = merchants;
        budgetData = budget;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Error loading insights: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Insights & Analytics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 16),

        // Period Selector
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.surfaceVariant),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: ['Daily', 'Weekly', 'Monthly'].map((period) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedPeriod = period);
                    _loadInsightsData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedPeriod == period
                          ? themeController.accentColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: selectedPeriod == period
                          ? Border.all(color: themeController.accentColor)
                          : null,
                    ),
                    child: Text(
                      period,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedPeriod == period
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
        ),
        const SizedBox(height: 24),

        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: CircularProgressIndicator(),
            ),
          )
        else ...[
          // Spending Trend Chart
          if (spendingTrends.isNotEmpty)
            _buildSpendingTrendCard(colorScheme, themeController),

          const SizedBox(height: 16),

          // Budget vs Actual
          if (budgetData != null)
            _buildBudgetCard(colorScheme, themeController),

          const SizedBox(height: 16),

          // Category Breakdown
          if (categoryBreakdown.isNotEmpty)
            _buildCategoryBreakdownCard(colorScheme, themeController),

          const SizedBox(height: 16),

          // Top Merchants
          if (topMerchants.isNotEmpty)
            _buildTopMerchantsCard(colorScheme, themeController),

          const SizedBox(height: 16),

          // Smart Recommendations
          _buildSmartRecommendations(colorScheme, themeController),
        ],
      ],
    );
  }

  Widget _buildSpendingTrendCard(ColorScheme colorScheme, ThemeController themeController) {
    // Calculate max value for scaling
    double maxAmount = 0;
    for (var trend in spendingTrends) {
      final amount = trend['amount'] as double? ?? 0.0;
      if (amount > maxAmount) maxAmount = amount;
    }

    return Container(
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
            'Spending Trend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          
          // Simple bar chart
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: spendingTrends.take(7).map((trend) {
                final amount = trend['amount'] as double? ?? 0.0;
                final date = trend['date'] as String? ?? '';
                final heightPercent = maxAmount > 0 ? (amount / maxAmount) : 0.0;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '₹${(amount / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 100 * heightPercent,
                          decoration: BoxDecoration(
                            color: themeController.accentColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(ColorScheme colorScheme, ThemeController themeController) {
    final budget = budgetData!['budget'] as double;
    final spent = budgetData!['spent'] as double;
    final remaining = budgetData!['remaining'] as double;
    final percentage = budgetData!['percentage'] as double;
    final hasAlert = budgetData!['hasAlert'] as bool;
    final isOverBudget = budgetData!['isOverBudget'] as bool;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget vs Actual',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (hasAlert)
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '₹${spent.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isOverBudget ? Colors.red : themeController.accentColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '₹${budget.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.red : (hasAlert ? Colors.orange : const Color(0xFF10B981)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOverBudget
                ? 'Over budget by ₹${(-remaining).toStringAsFixed(0)}'
                : 'Remaining: ₹${remaining.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 12,
              color: isOverBudget ? Colors.red : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownCard(ColorScheme colorScheme, ThemeController themeController) {
    final sortedCategories = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topCategories = sortedCategories.take(5).toList();
    final totalSpending = categoryBreakdown.values.fold<double>(0, (sum, val) => sum + val);

    return Container(
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
            'Top Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...topCategories.map((entry) {
            final percentage = totalSpending > 0 ? (entry.value / totalSpending) * 100 : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '₹${entry.value.toStringAsFixed(0)} (${percentage.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: themeController.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (percentage / 100).clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        themeController.accentColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTopMerchantsCard(ColorScheme colorScheme, ThemeController themeController) {
    return Container(
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
            'Top Merchants',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...topMerchants.map((merchant) {
            final name = merchant['name'] as String;
            final count = merchant['count'] as int;
            final total = merchant['totalAmount'] as double;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '$count transaction${count > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: themeController.accentColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSmartRecommendations(ColorScheme colorScheme, ThemeController themeController) {
    // Generate smart recommendations based on data
    List<Map<String, String>> recommendations = [];

    if (budgetData != null) {
      final isOverBudget = budgetData!['isOverBudget'] as bool;
      final hasAlert = budgetData!['hasAlert'] as bool;
      
      if (isOverBudget) {
        recommendations.add({
          'icon': '⚠️',
          'title': 'Budget Alert',
          'message': 'You\'ve exceeded your budget this month. Consider reducing discretionary spending.',
        });
      } else if (hasAlert) {
        recommendations.add({
          'icon': '💡',
          'title': 'Near Budget Limit',
          'message': 'You\'ve used 90% of your budget. Be mindful of your remaining spending.',
        });
      }
    }

    if (categoryBreakdown.isNotEmpty) {
      final sortedCategories = categoryBreakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topCategory = sortedCategories.first;
      
      recommendations.add({
        'icon': '📊',
        'title': 'Top Spending Category',
        'message': 'Your highest spending is in ${topCategory.key} (₹${topCategory.value.toStringAsFixed(0)}). Consider setting a limit.',
      });
    }

    if (topMerchants.isNotEmpty) {
      final topMerchant = topMerchants.first;
      recommendations.add({
        'icon': '🏪',
        'title': 'Frequent Merchant',
        'message': 'You visit ${topMerchant['name']} often. Look for subscription or loyalty benefits.',
      });
    }

    return Container(
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
            'Smart Recommendations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (recommendations.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Keep tracking your expenses to get personalized insights!',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...recommendations.map((rec) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeController.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: themeController.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rec['title']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rec['message']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}