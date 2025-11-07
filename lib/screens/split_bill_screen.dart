import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import '../firebase_service.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({Key? key}) : super(key: key);

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  String selectedCategory = 'Food & Dining';
  List<Map<String, String>> selectedContacts = [];
  DateTime? dueDate;
  bool isLoading = false;

  final Map<String, String> categoryIcons = {
    'Food & Dining': '🍔',
    'Entertainment': '🎬',
    'Travel': '✈️',
    'Bills & Utilities': '💡',
    'Shopping': '🛍️',
    'Other': '📦',
  };

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  Future<void> _showContactPicker() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final themeController = Get.find<ThemeController>();
        
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text('Add Person', style: TextStyle(color: colorScheme.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Name',
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
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  setState(() {
                    selectedContacts.add({
                      'name': nameController.text,
                      'phoneNumber': phoneController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createSplitBill() async {
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

    if (selectedContacts.isEmpty) {
      Get.snackbar(
        'No Contacts',
        'Please add at least one person to split with',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (descriptionController.text.isEmpty) {
      Get.snackbar(
        'Missing Description',
        'Please add a description for this bill',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Calculate split amount
      final int totalPeople = selectedContacts.length + 1; // +1 for yourself
      final double sharePerPerson = amount / totalPeople;

      // Prepare split data
      final List<Map<String, dynamic>> splitWith = selectedContacts.map((contact) {
        return {
          'name': contact['name']!,
          'phoneNumber': contact['phoneNumber']!,
          'amount': sharePerPerson,
          'paid': false,
        };
      }).toList();

      await _firebaseService.addSplitBill(
        name: descriptionController.text,
        totalAmount: amount,
        description: '${categoryIcons[selectedCategory]} $selectedCategory',
        splitWith: splitWith,
        category: selectedCategory,
        dueDate: dueDate,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Bill split created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create split bill: $e',
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

    final int totalPeople = selectedContacts.length + 1;
    final double amount = double.tryParse(amountController.text) ?? 0;
    final double sharePerPerson = amount > 0 ? amount / totalPeople : 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => navController.backToDashboard(),
        ),
        title: Text(
          'Split Bill',
          style: TextStyle(color: colorScheme.onBackground),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Amount
            Text(
              'Bill Amount',
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
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.surfaceVariant),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                onChanged: (val) => setState(() => selectedCategory = val!),
                underline: Container(),
                isExpanded: true,
                dropdownColor: colorScheme.surface,
                style: TextStyle(color: colorScheme.onSurface),
                items: categoryIcons.keys.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Text(categoryIcons[category]!, style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
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
                controller: descriptionController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's this for? E.g. Dinner at restaurant",
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Due Date
            Text(
              'Due Date (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDueDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.surfaceVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: themeController.accentColor, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      dueDate == null
                          ? 'Select due date'
                          : 'Due: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                      style: TextStyle(
                        color: dueDate == null
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Split With Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split With',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onBackground,
                  ),
                ),
                Text(
                  '$totalPeople people',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeController.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // You (first person)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.surfaceVariant),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: themeController.accentColor.withOpacity(0.2),
                    child: Icon(Icons.person, color: themeController.accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Share: ₹${sharePerPerson.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Selected Contacts
            ...selectedContacts.asMap().entries.map((entry) {
              final index = entry.key;
              final contact = entry.value;
              
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.surfaceVariant),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.surfaceVariant,
                      child: Text(
                        contact['name']![0].toUpperCase(),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Share: ₹${sharePerPerson.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red, size: 20),
                      onPressed: () {
                        setState(() => selectedContacts.removeAt(index));
                      },
                    ),
                  ],
                ),
              );
            }).toList(),

            // Add Person Button
            GestureDetector(
              onTap: _showContactPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeController.accentColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: themeController.accentColor),
                    const SizedBox(width: 8),
                    Text(
                      'Add Person',
                      style: TextStyle(
                        color: themeController.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            if (amount > 0 && selectedContacts.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: themeController.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeController.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₹${amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Split Between:',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$totalPeople people',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Per Person:',
                          style: TextStyle(
                            color: themeController.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '₹${sharePerPerson.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: themeController.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Create Bill Button
            ElevatedButton(
              onPressed: isLoading ? null : _createSplitBill,
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
                      '✓ Create Split Bill',
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
    descriptionController.dispose();
    super.dispose();
  }
}
