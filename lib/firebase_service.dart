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
}