import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Theme Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select how you want the app to look',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Column(
                children: [
                  _buildThemeOption(
                    context: context,
                    value: 'light',
                    title: 'Light Mode',
                    description: 'Bright and clear interface',
                    icon: Icons.light_mode,
                    isSelected: themeController.themeMode == ThemeMode.light,
                    onTap: () => themeController.setThemeMode('light'),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeOption(
                    context: context,
                    value: 'dark',
                    title: 'Dark Mode',
                    description: 'Easy on the eyes in low light',
                    icon: Icons.dark_mode,
                    isSelected: themeController.themeMode == ThemeMode.dark,
                    onTap: () => themeController.setThemeMode('dark'),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeOption(
                    context: context,
                    value: 'system',
                    title: 'System Default',
                    description: 'Follow device settings',
                    icon: Icons.smartphone,
                    isSelected: themeController.themeMode == ThemeMode.system,
                    onTap: () => themeController.setThemeMode('system'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Accent Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildColorOption(
                    themeController,
                    const Color(0xFF06B6D4),
                    'Cyan',
                  ),
                  _buildColorOption(
                    themeController,
                    const Color(0xFF3B82F6),
                    'Blue',
                  ),
                  _buildColorOption(
                    themeController,
                    const Color(0xFF8B5CF6),
                    'Purple',
                  ),
                  _buildColorOption(
                    themeController,
                    const Color(0xFFEC4899),
                    'Pink',
                  ),
                  _buildColorOption(
                    themeController,
                    const Color(0xFFF59E0B),
                    'Amber',
                  ),
                  _buildColorOption(
                    themeController,
                    const Color(0xFF10B981),
                    'Green',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF334155)
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: themeController.accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Theme changes are applied immediately',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String value,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeController.accentColor
                : (isDark ? const Color(0xFF334155) : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeController.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: themeController.accentColor, size: 28),
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: themeController.accentColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(
    ThemeController controller,
    Color color,
    String name,
  ) {
    final isSelected = controller.accentColor.value == color.value;

    return GestureDetector(
      onTap: () {
        controller.setAccentColor(color);
        Get.snackbar(
          'Accent Color',
          '$name accent selected',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white24,
                width: isSelected ? 3 : 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
