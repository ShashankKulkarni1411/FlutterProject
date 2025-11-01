import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {'type': 'Visa', 'last4': '4242', 'expiry': '12/25', 'isDefault': true},
    {
      'type': 'Mastercard',
      'last4': '8888',
      'expiry': '09/26',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Payment Methods')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._paymentMethods.map(
              (method) => _buildCardTile(method, isDark, accentColor),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddCardDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add New Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Other Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              isDark: isDark,
              accentColor: accentColor,
              icon: Icons.account_balance,
              title: 'UPI',
              subtitle: 'Link your UPI ID',
              onTap: () => Get.snackbar(
                'UPI Payment',
                'UPI payment setup',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
            _buildPaymentOption(
              isDark: isDark,
              accentColor: accentColor,
              icon: Icons.wallet,
              title: 'Wallets',
              subtitle: 'Paytm, PhonePe, Google Pay',
              onTap: () => Get.snackbar(
                'Wallet Payment',
                'Wallet setup',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
            _buildPaymentOption(
              isDark: isDark,
              accentColor: accentColor,
              icon: Icons.account_balance_wallet,
              title: 'Net Banking',
              subtitle: 'Add your bank account',
              onTap: () => Get.snackbar(
                'Net Banking',
                'Net banking setup',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTile(
    Map<String, dynamic> method,
    bool isDark,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: method['isDefault']
              ? accentColor
              : (isDark ? const Color(0xFF334155) : Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            method['type'] == 'Visa' ? Icons.credit_card : Icons.payment,
            color: accentColor,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${method['type']} •••• ${method['last4']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (method['isDefault']) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(fontSize: 10, color: accentColor),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires ${method['expiry']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'default',
                child: Text('Set as Default'),
              ),
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
              ),
            ],
            onSelected: (value) => _handleCardAction(value.toString(), method),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required bool isDark,
    required Color accentColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
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

  void _handleCardAction(String action, Map<String, dynamic> method) {
    setState(() {
      if (action == 'default') {
        for (var m in _paymentMethods) {
          m['isDefault'] = false;
        }
        method['isDefault'] = true;
        Get.snackbar(
          'Default Payment',
          'Set as default payment method',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (action == 'delete') {
        _paymentMethods.remove(method);
        Get.snackbar(
          'Card Removed',
          'Card removed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (action == 'edit') {
        Get.snackbar(
          'Edit Card',
          'Edit card details',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  void _showAddCardDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).primaryColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: const Text('Add New Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Card Added',
                'Card added successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }
}
