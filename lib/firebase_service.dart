import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get current user name
  String get currentUserName => _auth.currentUser?.displayName ?? 'User';

  // Initialize user data on first login
  Future<void> initializeUserData() async {
    if (currentUserId == null) return;
    
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    
    if (!userDoc.exists) {
      await _firestore.collection('users').doc(currentUserId).set({
        'name': _auth.currentUser?.displayName ?? 'Alex',
        'email': _auth.currentUser?.email,
        'walletBalance': 25000.0,
        'totalIncome': 45000.0,
        'totalExpenses': 12500.0,
        'spentThisMonth': 12500.0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }

  // User Profile Operations
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUserId == null) return null;
    final doc = await _firestore.collection('users').doc(currentUserId).get();
    return doc.data();
  }

  Stream<DocumentSnapshot> getUserProfileStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore.collection('users').doc(currentUserId).snapshots();
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUserId == null) return;
    await _firestore.collection('users').doc(currentUserId).update({
      ...data,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Dashboard Data
  Future<Map<String, dynamic>> getDashboardStats() async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    final userData = userDoc.data() ?? {};
    
    return {
      'totalBalance': userData['walletBalance'] ?? 25000.0,
      'spentThisMonth': userData['spentThisMonth'] ?? 12500.0,
      'totalIncome': userData['totalIncome'] ?? 45000.0,
      'totalExpenses': userData['totalExpenses'] ?? 12500.0,
      'remaining': (userData['totalIncome'] ?? 45000.0) - (userData['spentThisMonth'] ?? 12500.0),
    };
  }

  // Transaction Operations
  Future<void> addTransaction({
    required String name,
    required String category,
    required double amount,
    required String type, // 'income' or 'expense'
    String? icon,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    // Add transaction
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .add({
      'name': name,
      'category': category,
      'amount': amount,
      'type': type,
      'icon': icon ?? (type == 'income' ? '💰' : '🛍️'),
      'timestamp': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });

    // Update user balance and stats
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    final userData = userDoc.data() ?? {};
    
    double currentBalance = (userData['walletBalance'] ?? 0).toDouble();
    double currentExpenses = (userData['totalExpenses'] ?? 0).toDouble();
    double currentIncome = (userData['totalIncome'] ?? 0).toDouble();
    double spentThisMonth = (userData['spentThisMonth'] ?? 0).toDouble();

    if (type == 'expense') {
      currentBalance -= amount;
      currentExpenses += amount;
      spentThisMonth += amount;
    } else {
      currentBalance += amount;
      currentIncome += amount;
    }

    await _firestore.collection('users').doc(currentUserId).update({
      'walletBalance': currentBalance,
      'totalExpenses': currentExpenses,
      'totalIncome': currentIncome,
      'spentThisMonth': spentThisMonth,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTransactionsStream({int? limit}) {
    if (currentUserId == null) throw Exception('No user logged in');
    
    Query query = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .orderBy('timestamp', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }

  Future<List<Map<String, dynamic>>> getRecentTransactions({int limit = 10}) async {
    if (currentUserId == null) return [];
    
    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Transaction',
        'category': data['category'] ?? 'Other',
        'amount': data['amount'] ?? 0.0,
        'type': data['type'] ?? 'expense',
        'icon': data['icon'] ?? '🛍️',
        'timestamp': data['timestamp'],
      };
    }).toList();
  }

  // Wallet Operations
  Future<void> updateWalletBalance(double newBalance) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore.collection('users').doc(currentUserId).update({
      'walletBalance': newBalance,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Wallet Analytics
  Future<Map<String, dynamic>> getWalletAnalytics() async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    final userData = userDoc.data() ?? {};
    
    // Get transactions for weekly spending
    final DateTime now = DateTime.now();
    final DateTime weekAgo = now.subtract(const Duration(days: 7));
    
    final weeklyTransactions = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(weekAgo))
        .where('type', isEqualTo: 'expense')
        .get();
    
    double weeklySpending = 0;
    for (var doc in weeklyTransactions.docs) {
      weeklySpending += (doc.data()['amount'] ?? 0).toDouble();
    }

    // Get category breakdown
    final allTransactions = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .where('type', isEqualTo: 'expense')
        .get();
    
    Map<String, double> categorySpending = {};
    for (var doc in allTransactions.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Other';
      final amount = (data['amount'] ?? 0).toDouble();
      categorySpending[category] = (categorySpending[category] ?? 0) + amount;
    }
    
    String topCategory = 'None';
    double topAmount = 0;
    categorySpending.forEach((category, amount) {
      if (amount > topAmount) {
        topAmount = amount;
        topCategory = category;
      }
    });

    final walletBalance = (userData['walletBalance'] ?? 0).toDouble();
    final investableFunds = walletBalance * 0.2;

    return {
      'weeklySpending': weeklySpending,
      'topCategory': topCategory,
      'topCategoryAmount': topAmount,
      'investableFunds': investableFunds,
      'pendingDues': 1800.0, // You can add bill tracking later
      'healthScore': 78, // Calculate based on spending patterns
    };
  }

  // Investment Operations
  Future<void> addInvestment(Map<String, dynamic> investmentData) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('investments')
        .add({
      ...investmentData,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Stream<QuerySnapshot> getInvestmentsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('investments')
        .snapshots();
  }

  // Bill Operations
  Future<void> addBill(Map<String, dynamic> billData) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('bills')
        .add({
      ...billData,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Stream<QuerySnapshot> getBillsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('bills')
        .where('isPaid', isEqualTo: false)
        .snapshots();
  }

  // Goals Operations
  Future<void> addGoal(Map<String, dynamic> goalData) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .add({
      ...goalData,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> updates) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .doc(goalId)
        .update(updates);
  }

  Future<void> deleteGoal(String goalId) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .doc(goalId)
        .delete();
  }

  Stream<QuerySnapshot> getGoalsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> updateGoalProgress(String goalId, double amount) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final goalDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .doc(goalId)
        .get();
    
    if (goalDoc.exists) {
      final currentAmount = (goalDoc.data()?['currentAmount'] ?? 0).toDouble();
      final newAmount = currentAmount + amount;
      
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('goals')
          .doc(goalId)
          .update({'currentAmount': newAmount});
    }
  }

  Future<double> getGoalProgress(String goalId) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final goalDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('goals')
        .doc(goalId)
        .get();
    
    if (goalDoc.exists) {
      final data = goalDoc.data()!;
      final currentAmount = (data['currentAmount'] ?? 0).toDouble();
      final targetAmount = (data['targetAmount'] ?? 1).toDouble();
      return (currentAmount / targetAmount) * 100;
    }
    return 0.0;
  }

  // Insights Operations
  Future<List<Map<String, dynamic>>> getSpendingTrends({required String period}) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final DateTime now = DateTime.now();
    DateTime startDate;
    
    switch (period) {
      case 'Daily':
        startDate = DateTime(now.year, now.month, now.day - 6); // Last 7 days
        break;
      case 'Weekly':
        startDate = DateTime(now.year, now.month, now.day - 27); // Last 4 weeks
        break;
      case 'Monthly':
        startDate = DateTime(now.year, now.month - 5, 1); // Last 6 months
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day - 27);
    }
    
    final transactions = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(startDate))
        .where('type', isEqualTo: 'expense')
        .orderBy('timestamp', descending: false)
        .get();
    
    // Group by date
    Map<String, double> dateAmounts = {};
    
    for (var doc in transactions.docs) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final date = timestamp.toDate();
        String dateKey;
        
        if (period == 'Daily') {
          dateKey = '${date.month}/${date.day}';
        } else if (period == 'Weekly') {
          // Group by week
          final weekStart = date.subtract(Duration(days: date.weekday - 1));
          dateKey = '${weekStart.month}/${weekStart.day}';
        } else {
          dateKey = '${date.month}/${date.year}';
        }
        
        final amount = (data['amount'] ?? 0).toDouble();
        dateAmounts[dateKey] = (dateAmounts[dateKey] ?? 0) + amount;
      }
    }
    
    return dateAmounts.entries
        .map((e) => {'date': e.key, 'amount': e.value})
        .toList();
  }

  Future<Map<String, double>> getCategoryBreakdown({String? period}) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    Query query = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .where('type', isEqualTo: 'expense');
    
    if (period != null) {
      final DateTime now = DateTime.now();
      DateTime startDate;
      
      switch (period) {
        case 'Monthly':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'Weekly':
          startDate = now.subtract(const Duration(days: 7));
          break;
        default:
          startDate = DateTime(now.year, now.month, 1);
      }
      
      query = query.where('timestamp', isGreaterThan: Timestamp.fromDate(startDate));
    }
    
    final transactions = await query.get();
    
    Map<String, double> categorySpending = {};
    for (var doc in transactions.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final category = data['category'] ?? 'Other';
      final amount = (data['amount'] ?? 0).toDouble();
      categorySpending[category] = (categorySpending[category] ?? 0) + amount;
    }
    
    return categorySpending;
  }

  Future<List<Map<String, dynamic>>> getTopMerchants({int limit = 5}) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final transactions = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('transactions')
        .where('type', isEqualTo: 'expense')
        .get();
    
    Map<String, Map<String, dynamic>> merchantData = {};
    
    for (var doc in transactions.docs) {
      final data = doc.data();
      final name = data['name'] ?? 'Unknown';
      final amount = (data['amount'] ?? 0).toDouble();
      
      if (merchantData.containsKey(name)) {
        merchantData[name]!['count'] = (merchantData[name]!['count'] as int) + 1;
        merchantData[name]!['totalAmount'] = (merchantData[name]!['totalAmount'] as double) + amount;
      } else {
        merchantData[name] = {
          'name': name,
          'count': 1,
          'totalAmount': amount,
        };
      }
    }
    
    final sortedMerchants = merchantData.values.toList()
      ..sort((a, b) => (b['totalAmount'] as double).compareTo(a['totalAmount'] as double));
    
    return sortedMerchants.take(limit).toList();
  }

  Future<Map<String, dynamic>> getBudgetComparison() async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    final userData = userDoc.data() ?? {};
    
    // Get monthly budget if set, otherwise use income as budget
    final budget = (userData['monthlyBudget'] ?? userData['totalIncome'] ?? 45000.0).toDouble();
    final spent = (userData['spentThisMonth'] ?? 0).toDouble();
    final remaining = budget - spent;
    final percentage = (spent / budget) * 100;
    
    return {
      'budget': budget,
      'spent': spent,
      'remaining': remaining,
      'percentage': percentage,
      'hasAlert': percentage >= 90,
      'isOverBudget': spent > budget,
    };
  }

  // Payment Methods Operations
  Future<void> addPaymentMethod(Map<String, dynamic> paymentMethodData) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('paymentMethods')
        .add({
      ...paymentMethodData,
      'addedAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> updatePaymentMethod(String paymentMethodId, Map<String, dynamic> updates) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('paymentMethods')
        .doc(paymentMethodId)
        .update(updates);
  }

  Future<void> deletePaymentMethod(String paymentMethodId) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('paymentMethods')
        .doc(paymentMethodId)
        .delete();
  }

  Stream<QuerySnapshot> getPaymentMethodsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('paymentMethods')
        .snapshots();
  }

  // Round Up Savings Operations
  Future<void> addRoundUpSaving({
    required String transactionId,
    required double originalAmount,
    required double roundedTo,
    required double savedAmount,
    String? investedIn,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('roundUpSavings')
        .add({
      'transactionId': transactionId,
      'originalAmount': originalAmount,
      'roundedTo': roundedTo,
      'savedAmount': savedAmount,
      'investedIn': investedIn,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<Map<String, dynamic>> getRoundUpSavingsStats() async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final DateTime now = DateTime.now();
    final DateTime monthStart = DateTime(now.year, now.month, 1);
    
    final monthlyRoundUps = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('roundUpSavings')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(monthStart))
        .get();
    
    double thisMonthSavings = 0;
    for (var doc in monthlyRoundUps.docs) {
      thisMonthSavings += (doc.data()['savedAmount'] ?? 0).toDouble();
    }
    
    final allRoundUps = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('roundUpSavings')
        .get();
    
    double totalSavings = 0;
    for (var doc in allRoundUps.docs) {
      totalSavings += (doc.data()['savedAmount'] ?? 0).toDouble();
    }
    
    return {
      'thisMonthSavings': thisMonthSavings,
      'totalSavings': totalSavings,
      'transactionCount': allRoundUps.docs.length,
    };
  }

  Stream<QuerySnapshot> getRoundUpSavingsStream({int? limit}) {
    if (currentUserId == null) throw Exception('No user logged in');
    
    Query query = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('roundUpSavings')
        .orderBy('timestamp', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }

  // Budget Operations
  Future<void> setBudget({
    required String category,
    required double monthlyLimit,
    double alertThreshold = 80.0,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('budgets')
        .doc('$category-$monthKey')
        .set({
      'category': category,
      'monthlyLimit': monthlyLimit,
      'spentAmount': 0.0,
      'alertThreshold': alertThreshold,
      'month': monthKey,
      'userId': currentUserId,
    });
  }

  Future<void> updateBudgetSpending(String category, double amount) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final budgetId = '$category-$monthKey';
    
    final budgetDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('budgets')
        .doc(budgetId)
        .get();
    
    if (budgetDoc.exists) {
      final currentSpent = (budgetDoc.data()?['spentAmount'] ?? 0).toDouble();
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('budgets')
          .doc(budgetId)
          .update({'spentAmount': currentSpent + amount});
    }
  }

  Stream<QuerySnapshot> getBudgetsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('budgets')
        .where('month', isEqualTo: monthKey)
        .snapshots();
  }

  // Recurring Expenses Operations
  Future<void> addRecurringExpense(Map<String, dynamic> expenseData) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('recurringExpenses')
        .add({
      ...expenseData,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> updateRecurringExpense(String expenseId, Map<String, dynamic> updates) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('recurringExpenses')
        .doc(expenseId)
        .update(updates);
  }

  Future<void> deleteRecurringExpense(String expenseId) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('recurringExpenses')
        .doc(expenseId)
        .delete();
  }

  Stream<QuerySnapshot> getRecurringExpensesStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('recurringExpenses')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  // Insights Operations
  Future<void> saveInsight({
    required String type,
    required String category,
    required String message,
    double? amount,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('insights')
        .add({
      'type': type,
      'category': category,
      'message': message,
      'amount': amount,
      'date': FieldValue.serverTimestamp(),
      'isRead': false,
      'userId': currentUserId,
    });
  }

  Future<void> markInsightAsRead(String insightId) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('insights')
        .doc(insightId)
        .update({'isRead': true});
  }

  Stream<QuerySnapshot> getUnreadInsightsStream() {
    if (currentUserId == null) throw Exception('No user logged in');
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('insights')
        .where('isRead', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Update split bill to handle contact syncing
  Future<void> addSplitBill({
    required String name,
    required double totalAmount,
    required String description,
    required List<Map<String, dynamic>> splitWith,
    required String category,
    DateTime? dueDate,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('bills')
        .add({
      'name': name,
      'totalAmount': totalAmount,
      'yourShare': totalAmount / (splitWith.length + 1),
      'description': description,
      'splitWith': splitWith,
      'isPaid': false,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> updateBillPaymentStatus(String billId, bool isPaid) async {
    if (currentUserId == null) throw Exception('No user logged in');
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('bills')
        .doc(billId)
        .update({'isPaid': isPaid});
  }

  Future<void> updateParticipantPaymentStatus({
    required String billId,
    required int participantIndex,
    required bool paid,
  }) async {
    if (currentUserId == null) throw Exception('No user logged in');
    
    final billDoc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('bills')
        .doc(billId)
        .get();
    
    if (billDoc.exists) {
      final splitWith = List<Map<String, dynamic>>.from(billDoc.data()?['splitWith'] ?? []);
      if (participantIndex < splitWith.length) {
        splitWith[participantIndex]['paid'] = paid;
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('bills')
            .doc(billId)
            .update({'splitWith': splitWith});
      }
    }
  }
}