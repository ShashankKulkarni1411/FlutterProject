import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import '../firebase_service.dart';
import '../screens/scanner_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/split_bill_screen.dart';
import '../screens/investment_hub_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      await _firebaseService.initializeUserData();
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';

    final date = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showUpdateBalanceDialog(BuildContext context, double currentBalance) {
    final TextEditingController amountController = TextEditingController();
    String updateType = 'add'; // 'add' or 'set'
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colorScheme = Theme.of(context).colorScheme;
            final themeController = Get.find<ThemeController>();

            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                'Update Balance',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance: ₹${currentBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Update Type Selector
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() => updateType = 'add'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: updateType == 'add'
                                    ? themeController.accentColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Add/Remove',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: updateType == 'add'
                                      ? Colors.white
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() => updateType = 'set'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: updateType == 'set'
                                    ? themeController.accentColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Set New',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: updateType == 'set'
                                      ? Colors.white
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount Input
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: updateType == 'add'),
                    autofocus: true,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: updateType == 'add' 
                          ? 'Amount to Add/Remove (use - for remove)' 
                          : 'New Balance Amount',
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      hintText: updateType == 'add' ? 'e.g. 5000 or -1000' : 'e.g. 25000',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                      prefixText: '₹ ',
                      prefixStyle: TextStyle(
                        color: themeController.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.surfaceVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeController.accentColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Preview
                  if (amountController.text.isNotEmpty)
                    Builder(
                      builder: (context) {
                        final amount = double.tryParse(amountController.text) ?? 0;
                        final newBalance = updateType == 'add' 
                            ? currentBalance + amount 
                            : amount;
                        
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeController.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: themeController.accentColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'New Balance:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '₹${newBalance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: themeController.accentColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // Validation
                          if (amountController.text.isEmpty) {
                            Get.snackbar(
                              'Invalid Amount',
                              'Please enter an amount',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          final amount = double.tryParse(amountController.text);
                          if (amount == null) {
                            Get.snackbar(
                              'Invalid Amount',
                              'Please enter a valid number',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          final newBalance = updateType == 'add' 
                              ? currentBalance + amount 
                              : amount;

                          if (newBalance < 0) {
                            Get.snackbar(
                              'Invalid Balance',
                              'Balance cannot be negative',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            // Update balance in Firebase
                            await _firebaseService.updateWalletBalance(newBalance);

                            // If adding money, also update total income
                            if (updateType == 'add' && amount > 0) {
                              final userData = await _firebaseService.getUserProfile();
                              final currentIncome = (userData?['totalIncome'] ?? 0).toDouble();
                              await _firebaseService.updateUserProfile({
                                'totalIncome': currentIncome + amount,
                              });
                            }

                            Navigator.pop(context);
                            Get.snackbar(
                              'Success',
                              'Balance updated to ₹${newBalance.toStringAsFixed(2)}',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            Get.snackbar(
                              'Error',
                              'Failed to update balance: $e',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: colorScheme.surfaceVariant,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      bottomNavigationBar: _BottomNavigationBar(navController: navController),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firebaseService.getUserProfileStream(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${userSnapshot.error}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
            final userName = userData?['name'] ?? 'User';
            final totalBalance = (userData?['walletBalance'] ?? 0).toDouble();
            final spentThisMonth = (userData?['spentThisMonth'] ?? 0).toDouble();
            final totalIncome = (userData?['totalIncome'] ?? 0).toDouble();
            final remaining = totalIncome - spentThisMonth;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 90,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight -
                          MediaQuery.of(context).padding.top -
                          90,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getGreeting()},',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                  ),
                                ),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeController.accentColor,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                color: themeController.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Balance Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colorScheme.surfaceVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showUpdateBalanceDialog(context, totalBalance),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: themeController.accentColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: themeController.accentColor.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            size: 14,
                                            color: themeController.accentColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Update',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: themeController.accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${totalBalance.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Spent this month',
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${spentThisMonth.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Color(0xFFEA580C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Remaining',
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${remaining.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Quick Actions
                        Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = MediaQuery.of(context).size.width;
                            final itemWidth = (screenWidth - 52) / 2;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: itemWidth,
                                  child: _QuickActionButton(
                                    icon: Icons.camera_alt,
                                    label: 'Scan Receipt',
                                    borderColor: const Color(0xFF06B6D4),
                                    onTap: () => Get.to(() => const ScannerScreen()),
                                  ),
                                ),
                                SizedBox(
                                  width: itemWidth,
                                  child: _QuickActionButton(
                                    icon: Icons.add,
                                    label: 'Add Expense',
                                    borderColor: const Color(0xFFDC2626),
                                    onTap: () => Get.to(() => const AddExpenseScreen()),
                                  ),
                                ),
                                SizedBox(
                                  width: itemWidth,
                                  child: _QuickActionButton(
                                    icon: Icons.people,
                                    label: 'Split Bill',
                                    borderColor: Colors.grey,
                                    onTap: () => Get.to(() => const SplitBillScreen()),
                                  ),
                                ),
                                SizedBox(
                                  width: itemWidth,
                                  child: _QuickActionButton(
                                    icon: Icons.trending_up,
                                    label: 'Invest',
                                    borderColor: const Color(0xFF10B981),
                                    onTap: () => Get.to(() => const InvestmentHubScreen()),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Recent Transactions
                        Row(
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
                              onTap: () => Get.to(() => const AnalyticsScreen()),
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: themeController.accentColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Transaction List from Firebase
                        StreamBuilder<QuerySnapshot>(
                          stream: _firebaseService.getTransactionsStream(limit: 4),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colorScheme.surfaceVariant),
                                ),
                                child: Center(
                                  child: Text(
                                    'Error loading transactions',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colorScheme.surfaceVariant),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 48,
                                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'No transactions yet',
                                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Add your first expense to get started!',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final transactions = snapshot.data!.docs;

                            return Column(
                              children: transactions.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return _TransactionItem(
                                  name: data['name'] ?? 'Transaction',
                                  time: _formatTimestamp(data['timestamp']),
                                  category: data['category'] ?? 'Other',
                                  amount: data['type'] == 'income'
                                      ? '+₹${(data['amount'] ?? 0).toStringAsFixed(0)}'
                                      : '-₹${(data['amount'] ?? 0).toStringAsFixed(0)}',
                                  icon: data['icon'] ?? '🛍️',
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color borderColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = (screenWidth * 0.08).clamp(24.0, 32.0);
    final fontSize = (screenWidth * 0.03).clamp(11.0, 14.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: borderColor, size: iconSize),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String name;
  final String time;
  final String category;
  final String amount;
  final String icon;

  const _TransactionItem({
    required this.name,
    required this.time,
    required this.category,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = amount.startsWith('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
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
                  '$time • $category',
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEA580C),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final NavigationController navController;

  const _BottomNavigationBar({required this.navController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return Container(
        height: 75,
        decoration: BoxDecoration(
          color: colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: navController.currentIndex.value == 0,
              onTap: () => navController.changePage(0),
            ),
            _NavItem(
              icon: Icons.bar_chart,
              label: 'Analytics',
              isSelected: navController.currentIndex.value == 1,
              onTap: () => navController.changePage(1),
            ),
            _NavItem(
              icon: Icons.account_balance_wallet,
              label: 'Wallet',
              isSelected: navController.currentIndex.value == 2,
              onTap: () => navController.changePage(2),
            ),
            _NavItem(
              icon: Icons.person,
              label: 'Profile',
              isSelected: navController.currentIndex.value == 3,
              onTap: () => navController.changePage(3),
            ),
          ],
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? themeController.accentColor
                : colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? themeController.accentColor
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
