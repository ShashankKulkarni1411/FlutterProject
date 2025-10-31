/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService.getUserProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Get user data from Firestore
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final currentUser = _auth.currentUser;
          
          // Fallback to Firebase Auth if Firestore data not available
          final userName = userData?['name'] ?? currentUser?.displayName ?? 'User';
          final userEmail = userData?['email'] ?? currentUser?.email ?? 'No email';
          final memberSince = userData?['createdAt'] != null
              ? DateFormat('MMMM yyyy').format(
                  (userData!['createdAt'] as Timestamp).toDate())
              : 'Recently';
          
          final totalBalance = (userData?['walletBalance'] ?? 0).toDouble();
          final totalTransactions = userData?['totalTransactions'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: currentUser?.photoURL != null
                                ? NetworkImage(currentUser!.photoURL!)
                                : const NetworkImage('https://i.pravatar.cc/200?img=3'),
                            backgroundColor: const Color(0xFF06B6D4),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: snapshot.hasData && snapshot.data!.exists
                                    ? Colors.green
                                    : Colors.orange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1E293B),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                snapshot.hasData && snapshot.data!.exists
                                    ? Icons.check
                                    : Icons.sync,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since $memberSince',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      
                      // Firebase Connection Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: snapshot.hasData && snapshot.data!.exists
                              ? const Color(0xFF10B981).withOpacity(0.2)
                              : const Color(0xFFF59E0B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              snapshot.hasData && snapshot.data!.exists
                                  ? Icons.cloud_done
                                  : Icons.cloud_sync,
                              size: 14,
                              color: snapshot.hasData && snapshot.data!.exists
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              snapshot.hasData && snapshot.data!.exists
                                  ? 'Firebase Connected'
                                  : 'Syncing...',
                              style: TextStyle(
                                fontSize: 11,
                                color: snapshot.hasData && snapshot.data!.exists
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Balance',
                        value: '₹${totalBalance.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Transactions',
                        value: totalTransactions.toString(),
                        icon: Icons.receipt_long,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Account Settings
                const Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your name and details',
                  onTap: () => _showEditProfileDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Manage your cards and accounts',
                  onTap: () => _navigateToPaymentMethods(context),
                ),
                _SettingsTile(
                  icon: Icons.brightness_4_outlined,
                  title: 'Theme',
                  subtitle: 'Dark Mode',
                  onTap: () => _navigateToTheme(context),
                ),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Currency',
                  subtitle: '₹ (INR)',
                  onTap: () => _navigateToCurrency(context),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your alerts',
                  onTap: () => _navigateToNotifications(context),
                ),
                _SettingsTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control your data and permissions',
                  onTap: () => _navigateToPrivacy(context),
                ),
                const SizedBox(height: 24),

                // Firebase Debug (Development only)
                _SettingsTile(
                  icon: Icons.bug_report,
                  title: 'Firebase Debug',
                  subtitle: 'Check connection status',
                  onTap: () => _showFirebaseDebugInfo(context),
                ),
                const SizedBox(height: 24),

                // Support
                const Text(
                  'Support',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'FAQs and support resources',
                  onTap: () => _navigateToHelpCenter(context),
                ),
                _SettingsTile(
                  icon: Icons.message_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get in touch with us',
                  onTap: () => _navigateToContactSupport(context),
                ),
                const SizedBox(height: 24),

                // Other Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Version 1.0.0 • User ID: ${currentUser?.uid.substring(0, 8)}...',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final userData = await _firebaseService.getUserProfile();
    nameController.text = userData?['name'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF06B6D4)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _firebaseService.updateUserProfile({
                  'name': nameController.text,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFirebaseDebugInfo(BuildContext context) async {
    final currentUser = _auth.currentUser;
    final userData = await _firebaseService.getUserProfile();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: const [
            Icon(Icons.bug_report, color: Color(0xFF06B6D4)),
            SizedBox(width: 8),
            Text('Firebase Debug Info'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DebugRow('Firebase Auth', currentUser != null ? '✅ Connected' : '❌ Not logged in'),
              _DebugRow('User ID', currentUser?.uid ?? 'N/A'),
              _DebugRow('Email', currentUser?.email ?? 'N/A'),
              const Divider(color: Color(0xFF334155)),
              _DebugRow('Firestore Data', userData != null ? '✅ Available' : '❌ No data'),
              _DebugRow('User Name', userData?['name'] ?? 'N/A'),
              _DebugRow('Balance', '₹${userData?['walletBalance'] ?? 0}'),
              const Divider(color: Color(0xFF334155)),
              const Text(
                '💡 If you see data above, Firebase is working correctly!',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF10B981),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToPaymentMethods(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Methods - Add/Edit Cards')),
    );
  }

  void _navigateToTheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme Settings - Light/Dark Mode')),
    );
  }

  void _navigateToCurrency(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Currency Selection')),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Settings')),
    );
  }

  void _navigateToPrivacy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy & Security Settings')),
    );
  }

  void _navigateToHelpCenter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help Center - FAQs & Resources')),
    );
  }

  void _navigateToContactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact Support - Chat/Email/Phone')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF06B6D4)),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
              // Navigate to login screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF06B6D4), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF06B6D4), size: 20),
            ),
            const SizedBox(width: 12),
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
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _DebugRow extends StatelessWidget {
  final String label;
  final String value;

  const _DebugRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../firebase_service.dart';
import '../splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService.getUserProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Get user data from Firestore
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final currentUser = _auth.currentUser;
          
          // Fallback to Firebase Auth if Firestore data not available
          final userName = userData?['name'] ?? currentUser?.displayName ?? 'User';
          final userEmail = userData?['email'] ?? currentUser?.email ?? 'No email';
          final memberSince = userData?['createdAt'] != null
              ? DateFormat('MMMM yyyy').format(
                  (userData!['createdAt'] as Timestamp).toDate())
              : 'Recently';
          
          final totalBalance = (userData?['walletBalance'] ?? 0).toDouble();
          final totalTransactions = userData?['totalTransactions'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: currentUser?.photoURL != null
                                ? NetworkImage(currentUser!.photoURL!)
                                : const NetworkImage('https://i.pravatar.cc/200?img=3'),
                            backgroundColor: const Color(0xFF06B6D4),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: snapshot.hasData && snapshot.data!.exists
                                    ? Colors.green
                                    : Colors.orange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1E293B),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                snapshot.hasData && snapshot.data!.exists
                                    ? Icons.check
                                    : Icons.sync,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since $memberSince',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      
                      // Firebase Connection Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: snapshot.hasData && snapshot.data!.exists
                              ? const Color(0xFF10B981).withOpacity(0.2)
                              : const Color(0xFFF59E0B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              snapshot.hasData && snapshot.data!.exists
                                  ? Icons.cloud_done
                                  : Icons.cloud_sync,
                              size: 14,
                              color: snapshot.hasData && snapshot.data!.exists
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              snapshot.hasData && snapshot.data!.exists
                                  ? 'Firebase Connected'
                                  : 'Syncing...',
                              style: TextStyle(
                                fontSize: 11,
                                color: snapshot.hasData && snapshot.data!.exists
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Balance',
                        value: '₹${totalBalance.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Transactions',
                        value: totalTransactions.toString(),
                        icon: Icons.receipt_long,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Account Settings
                const Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your name and details',
                  onTap: () => _showEditProfileDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Manage your cards and accounts',
                  onTap: () => _navigateToPaymentMethods(context),
                ),
                _SettingsTile(
                  icon: Icons.brightness_4_outlined,
                  title: 'Theme',
                  subtitle: 'Dark Mode',
                  onTap: () => _navigateToTheme(context),
                ),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Currency',
                  subtitle: '₹ (INR)',
                  onTap: () => _navigateToCurrency(context),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your alerts',
                  onTap: () => _navigateToNotifications(context),
                ),
                _SettingsTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control your data and permissions',
                  onTap: () => _navigateToPrivacy(context),
                ),
                const SizedBox(height: 24),

                // Firebase Debug (Development only)
                _SettingsTile(
                  icon: Icons.bug_report,
                  title: 'Firebase Debug',
                  subtitle: 'Check connection status',
                  onTap: () => _showFirebaseDebugInfo(context),
                ),
                const SizedBox(height: 24),

                // Support
                const Text(
                  'Support',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'FAQs and support resources',
                  onTap: () => _navigateToHelpCenter(context),
                ),
                _SettingsTile(
                  icon: Icons.message_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get in touch with us',
                  onTap: () => _navigateToContactSupport(context),
                ),
                const SizedBox(height: 24),

                // Other Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Version 1.0.0 • User ID: ${currentUser?.uid.substring(0, 8)}...',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final userData = await _firebaseService.getUserProfile();
    nameController.text = userData?['name'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF06B6D4)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _firebaseService.updateUserProfile({
                  'name': nameController.text,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFirebaseDebugInfo(BuildContext context) async {
    final currentUser = _auth.currentUser;
    final userData = await _firebaseService.getUserProfile();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: const [
            Icon(Icons.bug_report, color: Color(0xFF06B6D4)),
            SizedBox(width: 8),
            Text('Firebase Debug Info'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DebugRow('Firebase Auth', currentUser != null ? '✅ Connected' : '❌ Not logged in'),
              _DebugRow('User ID', currentUser?.uid ?? 'N/A'),
              _DebugRow('Email', currentUser?.email ?? 'N/A'),
              const Divider(color: Color(0xFF334155)),
              _DebugRow('Firestore Data', userData != null ? '✅ Available' : '❌ No data'),
              _DebugRow('User Name', userData?['name'] ?? 'N/A'),
              _DebugRow('Balance', '₹${userData?['walletBalance'] ?? 0}'),
              const Divider(color: Color(0xFF334155)),
              const Text(
                '💡 If you see data above, Firebase is working correctly!',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF10B981),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToPaymentMethods(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Methods - Add/Edit Cards')),
    );
  }

  void _navigateToTheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme Settings - Light/Dark Mode')),
    );
  }

  void _navigateToCurrency(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Currency Selection')),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Settings')),
    );
  }

  void _navigateToPrivacy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy & Security Settings')),
    );
  }

  void _navigateToHelpCenter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help Center - FAQs & Resources')),
    );
  }

  void _navigateToContactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact Support - Chat/Email/Phone')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF06B6D4)),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context); // Close the dialog
              
              // Navigate to splash screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF06B6D4), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF06B6D4), size: 20),
            ),
            const SizedBox(width: 12),
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
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _DebugRow extends StatelessWidget {
  final String label;
  final String value;

  const _DebugRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}