import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../models/transaction_model.dart';
import '../screens/scanner_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/split_bill_screen.dart';
import '../screens/investment_hub_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/select_contacts_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    List<Transaction> transactions = [
      Transaction(
        name: 'Starbucks',
        time: 'Today, 10:30 AM',
        category: 'Food',
        amount: '-₹450',
        icon: '☕',
      ),
      Transaction(
        name: 'Amazon',
        time: 'Yesterday',
        category: 'Shopping',
        amount: '-₹1,200',
        icon: '📦',
      ),
      Transaction(
        name: 'Uber',
        time: 'Oct 15, 2023',
        category: 'Transport',
        amount: '-₹350',
        icon: '🚗',
      ),
      Transaction(
        name: 'Salary',
        time: 'Oct 1, 2023',
        category: 'Income',
        amount: '+₹45,000',
        icon: '💰',
      ),
    ];

    return Scaffold(
      bottomNavigationBar: _BottomNavigationBar(navController: navController),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:
                    MediaQuery.of(context).padding.bottom +
                    90, // Footer height + safe area
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight -
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
                              'Good Morning,',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                            ),
                            Text(
                              'Alex',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF06B6D4)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF06B6D4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Balance Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '₹25,000',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Spent this month',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₹12,500',
                                    style: TextStyle(
                                      color: Color(0xFFEA580C),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Remaining',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₹12,500',
                                    style: TextStyle(
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
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final itemWidth =
                            (screenWidth - 52) /
                            2; // Accounting for padding and spacing
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
                                onTap: () =>
                                    Get.to(() => const ScannerScreen()),
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _QuickActionButton(
                                icon: Icons.add,
                                label: 'Add Expense',
                                borderColor: const Color(0xFFDC2626),
                                onTap: () =>
                                    Get.to(() => const AddExpenseScreen()),
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _QuickActionButton(
                                icon: Icons.people,
                                label: 'Split Bill',
                                borderColor: Colors.grey,
                                onTap: () =>
                                    Get.to(() => const SplitBillScreen()),
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _QuickActionButton(
                                icon: Icons.trending_up,
                                label: 'Invest',
                                borderColor: const Color(0xFF10B981),
                                onTap: () =>
                                    Get.to(() => const InvestmentHubScreen()),
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
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const AnalyticsScreen()),
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF06B6D4),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...transactions.map(
                      (tx) => _TransactionItem(transaction: tx),
                    ),
                  ],
                ),
              ),
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
          color: const Color(0xFF1E293B),
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
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Text(transaction.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${transaction.time} • ${transaction.category}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.amount.contains('+')
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEA580C),
              fontWeight: FontWeight.bold,
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
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: navController.currentPage.value == 'dashboard',
                onTap: () => navController.changePage(0),
              ),
              // Analytics
              _NavItem(
                icon: Icons.bar_chart_outlined,
                label: 'Analytics',
                isActive: navController.currentPage.value == 'analytics',
                onTap: () => navController.changePage(1),
              ),
              // Scanner (Center - Highlighted)
              _NavItem(
                icon: Icons.camera_alt_outlined,
                label: '',
                isActive: false,
                isCenter: true,
                onTap: () => navController.navigateTo('scanner'),
              ),
              // Wallet
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
                isActive: navController.currentPage.value == 'wallet',
                onTap: () => navController.changePage(2),
              ),
              // Profile
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: navController.currentPage.value == 'profile',
                onTap: () => navController.changePage(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isCenter = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isCenter) {
      // Center item with highlighted circular background
      final centerSize = (screenWidth * 0.14).clamp(48.0, 60.0);
      final iconSize = (screenWidth * 0.07).clamp(24.0, 32.0);

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: centerSize,
          height: centerSize,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Icon(icon, color: const Color(0xFF06B6D4), size: iconSize),
        ),
      );
    }

    final iconSize = (screenWidth * 0.06).clamp(20.0, 28.0);
    final fontSize = (screenWidth * 0.027).clamp(10.0, 12.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF06B6D4) : Colors.grey,
              size: iconSize,
            ),
            if (label.isNotEmpty) ...[
              SizedBox(height: screenWidth * 0.01),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF06B6D4) : Colors.grey,
                  fontSize: fontSize,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import '../../controllers/navigation_controller.dart';
// import '../../firebase_service.dart';
// import '../../screens/scanner_screen.dart';
// import '../../screens/add_expense_screen.dart';
// import '../../screens/split_bill_screen.dart';
// import '../../screens/investment_hub_screen.dart';
// import '../../screens/analytics_screen.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final FirebaseService _firebaseService = FirebaseService();

//   @override
//   void initState() {
//     super.initState();
//     _initializeUserData();
//   }

//   Future<void> _initializeUserData() async {
//     try {
//       await _firebaseService.initializeUserData();
//     } catch (e) {
//       print('Error initializing user data: $e');
//     }
//   }

//   String _formatTimestamp(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown';

//     final date = timestamp.toDate();
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final transactionDate = DateTime(date.year, date.month, date.day);

//     if (transactionDate == today) {
//       return 'Today, ${DateFormat('h:mm a').format(date)}';
//     } else if (transactionDate == yesterday) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('MMM d, yyyy').format(date);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final navController = Get.find<NavigationController>();

//     return Scaffold(
//       bottomNavigationBar: _BottomNavigationBar(navController: navController),
//       body: SafeArea(
//         bottom: false,
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: _firebaseService.getUserProfileStream(),
//           builder: (context, userSnapshot) {
//             if (userSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (userSnapshot.hasError) {
//               return Center(child: Text('Error: ${userSnapshot.error}'));
//             }

//             final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
//             final userName = userData?['name'] ?? 'Alex';
//             final totalBalance = (userData?['walletBalance'] ?? 25000)
//                 .toDouble();
//             final spentThisMonth = (userData?['spentThisMonth'] ?? 12500)
//                 .toDouble();
//             final totalIncome = (userData?['totalIncome'] ?? 45000).toDouble();
//             final remaining = totalIncome - spentThisMonth;

//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   padding: EdgeInsets.only(
//                     left: 20,
//                     right: 20,
//                     top: 20,
//                     bottom: MediaQuery.of(context).padding.bottom + 90,
//                   ),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight:
//                           constraints.maxHeight -
//                           MediaQuery.of(context).padding.top -
//                           90,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Good Morning,',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize:
//                                         MediaQuery.of(context).size.width *
//                                         0.035,
//                                   ),
//                                 ),
//                                 Text(
//                                   userName,
//                                   style: TextStyle(
//                                     fontSize:
//                                         MediaQuery.of(context).size.width *
//                                         0.06,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: const Color(0xFF06B6D4),
//                                 ),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: const Icon(
//                                 Icons.notifications_none,
//                                 color: Color(0xFF06B6D4),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         // Balance Card
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1E293B),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: const Color(0xFF334155)),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Total Balance',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '₹${totalBalance.toStringAsFixed(0)}',
//                                 style: const TextStyle(
//                                   fontSize: 32,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Spent this month',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 11,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         '₹${spentThisMonth.toStringAsFixed(0)}',
//                                         style: const TextStyle(
//                                           color: Color(0xFFEA580C),
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Remaining',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 11,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         '₹${remaining.toStringAsFixed(0)}',
//                                         style: const TextStyle(
//                                           color: Color(0xFF10B981),
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Quick Actions
//                         const Text(
//                           'Quick Actions',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         LayoutBuilder(
//                           builder: (context, constraints) {
//                             final screenWidth = MediaQuery.of(
//                               context,
//                             ).size.width;
//                             final itemWidth = (screenWidth - 52) / 2;
//                             return Wrap(
//                               spacing: 12,
//                               runSpacing: 12,
//                               children: [
//                                 SizedBox(
//                                   width: itemWidth,
//                                   child: _QuickActionButton(
//                                     icon: Icons.camera_alt,
//                                     label: 'Scan Receipt',
//                                     borderColor: const Color(0xFF06B6D4),
//                                     onTap: () =>
//                                         Get.to(() => const ScannerScreen()),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: itemWidth,
//                                   child: _QuickActionButton(
//                                     icon: Icons.add,
//                                     label: 'Add Expense',
//                                     borderColor: const Color(0xFFDC2626),
//                                     onTap: () =>
//                                         Get.to(() => const AddExpenseScreen()),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: itemWidth,
//                                   child: _QuickActionButton(
//                                     icon: Icons.people,
//                                     label: 'Split Bill',
//                                     borderColor: Colors.grey,
//                                     onTap: () =>
//                                         Get.to(() => const SplitBillScreen()),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: itemWidth,
//                                   child: _QuickActionButton(
//                                     icon: Icons.trending_up,
//                                     label: 'Invest',
//                                     borderColor: const Color(0xFF10B981),
//                                     onTap: () => Get.to(
//                                       () => const InvestmentHubScreen(),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 24),

//                         // Recent Transactions
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Recent Transactions',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () =>
//                                   Get.to(() => const AnalyticsScreen()),
//                               child: const Text(
//                                 'View All',
//                                 style: TextStyle(
//                                   color: Color(0xFF06B6D4),
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),

//                         // Transaction List from Firebase
//                         StreamBuilder<QuerySnapshot>(
//                           stream: _firebaseService.getTransactionsStream(
//                             limit: 4,
//                           ),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(20),
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               );
//                             }

//                             if (snapshot.hasError) {
//                               return Center(
//                                 child: Text('Error: ${snapshot.error}'),
//                               );
//                             }

//                             if (!snapshot.hasData ||
//                                 snapshot.data!.docs.isEmpty) {
//                               return Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF1E293B),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: const Color(0xFF334155),
//                                   ),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     'No transactions yet',
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               );
//                             }

//                             final transactions = snapshot.data!.docs;

//                             return Column(
//                               children: transactions.map((doc) {
//                                 final data = doc.data() as Map<String, dynamic>;
//                                 return _TransactionItem(
//                                   name: data['name'] ?? 'Transaction',
//                                   time: _formatTimestamp(data['timestamp']),
//                                   category: data['category'] ?? 'Other',
//                                   amount: data['type'] == 'income'
//                                       ? '+₹${(data['amount'] ?? 0).toStringAsFixed(0)}'
//                                       : '-₹${(data['amount'] ?? 0).toStringAsFixed(0)}',
//                                   icon: data['icon'] ?? '🛍️',
//                                 );
//                               }).toList(),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _QuickActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color borderColor;
//   final VoidCallback onTap;

//   const _QuickActionButton({
//     required this.icon,
//     required this.label,
//     required this.borderColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final iconSize = (screenWidth * 0.08).clamp(24.0, 32.0);
//     final fontSize = (screenWidth * 0.03).clamp(11.0, 14.0);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         constraints: const BoxConstraints(minHeight: 100),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E293B),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: borderColor, size: iconSize),
//             const SizedBox(height: 8),
//             Flexible(
//               child: Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TransactionItem extends StatelessWidget {
//   final String name;
//   final String time;
//   final String category;
//   final String amount;
//   final String icon;

//   const _TransactionItem({
//     required this.name,
//     required this.time,
//     required this.category,
//     required this.amount,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF334155)),
//       ),
//       child: Row(
//         children: [
//           Text(icon, style: const TextStyle(fontSize: 24)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   '$time • $category',
//                   style: const TextStyle(fontSize: 11, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             amount,
//             style: TextStyle(
//               color: amount.contains('+')
//                   ? const Color(0xFF10B981)
//                   : const Color(0xFFEA580C),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BottomNavigationBar extends StatelessWidget {
//   final NavigationController navController;

//   const _BottomNavigationBar({required this.navController});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F172A),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Container(
//           padding: EdgeInsets.only(
//             left: 8,
//             right: 8,
//             top: 8,
//             bottom: MediaQuery.of(context).padding.bottom + 8,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _NavItem(
//                 icon: Icons.home_outlined,
//                 label: 'Home',
//                 isActive: navController.currentPage.value == 'dashboard',
//                 onTap: () => navController.changePage(0),
//               ),
//               _NavItem(
//                 icon: Icons.bar_chart_outlined,
//                 label: 'Analytics',
//                 isActive: navController.currentPage.value == 'analytics',
//                 onTap: () => navController.changePage(1),
//               ),
//               _NavItem(
//                 icon: Icons.camera_alt_outlined,
//                 label: '',
//                 isActive: false,
//                 isCenter: true,
//                 onTap: () => navController.navigateTo('scanner'),
//               ),
//               _NavItem(
//                 icon: Icons.account_balance_wallet_outlined,
//                 label: 'Wallet',
//                 isActive: navController.currentPage.value == 'wallet',
//                 onTap: () => navController.changePage(2),
//               ),
//               _NavItem(
//                 icon: Icons.person_outline,
//                 label: 'Profile',
//                 isActive: navController.currentPage.value == 'profile',
//                 onTap: () => navController.changePage(3),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final bool isCenter;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     this.isCenter = false,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     if (isCenter) {
//       final centerSize = (screenWidth * 0.14).clamp(48.0, 60.0);
//       final iconSize = (screenWidth * 0.07).clamp(24.0, 32.0);

//       return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: centerSize,
//           height: centerSize,
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E293B),
//             shape: BoxShape.circle,
//             border: Border.all(color: const Color(0xFF06B6D4), width: 2),
//           ),
//           child: Icon(icon, color: const Color(0xFF06B6D4), size: iconSize),
//         ),
//       );
//     }

//     final iconSize = (screenWidth * 0.06).clamp(20.0, 28.0);
//     final fontSize = (screenWidth * 0.027).clamp(10.0, 12.0);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.03,
//           vertical: 8,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isActive ? const Color(0xFF06B6D4) : Colors.grey,
//               size: iconSize,
//             ),
//             if (label.isNotEmpty) ...[
//               SizedBox(height: screenWidth * 0.01),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isActive ? const Color(0xFF06B6D4) : Colors.grey,
//                   fontSize: fontSize,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
