import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import '../firebase_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  
  String selectedCategory = 'Food & Dining';
  String selectedPaymentType = 'cash';
  DateTime selectedDate = DateTime.now();
  bool enableRoundUp = false;
  bool isLoading = false;
  
  final Map<String, String> categoryIcons = {
    'Food & Dining': '🍔',
    'Transport': '🚗',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Health': '💊',
    'Bills & Utilities': '💡',
    'Education': '📚',
    'Travel': '✈️',
    'Other': '📦',
  };

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    // Validation
    if (amountController.text.isEmpty || double.tryParse(amountController.text) == null) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final double amount = double.parse(amountController.text);
    if (amount <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Amount must be greater than zero',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Add the transaction
      await _firebaseService.addTransaction(
        name: noteController.text.isEmpty 
            ? '$selectedCategory Expense' 
            : noteController.text,
        category: selectedCategory,
        amount: amount,
        type: 'expense',
        icon: categoryIcons[selectedCategory] ?? '💰',
      );

      // Handle round-up savings if enabled
      if (enableRoundUp) {
        final double roundedAmount = (amount / 10).ceil() * 10;
        final double savedAmount = roundedAmount - amount;
        
        if (savedAmount > 0) {
          await _firebaseService.addRoundUpSaving(
            transactionId: 'auto_${DateTime.now().millisecondsSinceEpoch}',
            originalAmount: amount,
            roundedTo: roundedAmount,
            savedAmount: savedAmount,
          );
        }
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Expense added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add expense: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final colorScheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => navController.backToDashboard(),
        ),
        title: Text(
          'Add Expense',
          style: TextStyle(color: colorScheme.onBackground),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.surfaceVariant),
              ),
              child: Row(
                children: [
                  Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeController.accentColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Selection
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryIcons.keys.length,
              itemBuilder: (context, index) {
                final category = categoryIcons.keys.elementAt(index);
                final icon = categoryIcons[category]!;
                final isSelected = selectedCategory == category;
                
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeController.accentColor.withOpacity(0.2)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? themeController.accentColor
                            : colorScheme.surfaceVariant,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? themeController.accentColor
                                : colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Date and Payment Type Row
            Row(
              children: [
                // Date Picker
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.surfaceVariant),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: themeController.accentColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormat('MMM d, yyyy').format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Payment Type Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Type',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.surfaceVariant),
                        ),
                        child: DropdownButton<String>(
                          value: selectedPaymentType,
                          onChanged: (val) => setState(() => selectedPaymentType = val!),
                          underline: Container(),
                          isExpanded: true,
                          dropdownColor: colorScheme.surface,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'cash',
                              child: Row(
                                children: [
                                  Text('💵 ', style: TextStyle(fontSize: 16)),
                                  Text('Cash'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'card',
                              child: Row(
                                children: [
                                  Text('💳 ', style: TextStyle(fontSize: 16)),
                                  Text('Card'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'upi',
                              child: Row(
                                children: [
                                  Text('📱 ', style: TextStyle(fontSize: 16)),
                                  Text('UPI'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'netbanking',
                              child: Row(
                                children: [
                                  Text('🏦 ', style: TextStyle(fontSize: 16)),
                                  Text('Net Banking'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notes
            Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.surfaceVariant),
              ),
              child: TextField(
                controller: noteController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add notes about this expense...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Round-Up Savings Toggle
            Container(
              padding: const EdgeInsets.all(16),
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
                      color: themeController.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.savings_outlined,
                      color: themeController.accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Round-Up Savings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Round up to nearest ₹10 and save the difference',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: enableRoundUp,
                    onChanged: (val) => setState(() => enableRoundUp = val),
                    activeColor: themeController.accentColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Preview Round-Up
            if (enableRoundUp && amountController.text.isNotEmpty)
              Builder(
                builder: (context) {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  if (amount > 0) {
                    final rounded = (amount / 10).ceil() * 10;
                    final saved = rounded - amount;
                    if (saved > 0) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: themeController.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: themeController.accentColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: themeController.accentColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '₹${amount.toStringAsFixed(2)} → ₹${rounded.toStringAsFixed(2)} (Save ₹${saved.toStringAsFixed(2)})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Save Button
            ElevatedButton(
              onPressed: isLoading ? null : _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.accentColor,
                disabledBackgroundColor: colorScheme.surfaceVariant,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '✓ Save Expense',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
