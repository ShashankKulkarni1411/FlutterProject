import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedView = 'Monthly'; // Weekly, Monthly, Yearly
  bool showBarChart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Spending Analysis'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAnalyticsInfo(context),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // View Selector
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: ['Weekly', 'Monthly', 'Yearly'].map((view) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedView = view),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedView == view
                              ? const Color(0xFF06B6D4).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: selectedView == view
                              ? Border.all(color: const Color(0xFF06B6D4))
                              : null,
                        ),
                        child: Text(
                          view,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedView == view
                                ? const Color(0xFF06B6D4)
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Chart Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => showBarChart = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: showBarChart
                          ? const Color(0xFF06B6D4)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: showBarChart
                            ? const Color(0xFF06B6D4)
                            : const Color(0xFF334155),
                      ),
                    ),
                    child: const Text('Bar Chart',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => showBarChart = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: !showBarChart
                          ? const Color(0xFF06B6D4)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !showBarChart
                            ? const Color(0xFF06B6D4)
                            : const Color(0xFF334155),
                      ),
                    ),
                    child: const Text('Donut Chart',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart Container
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
                  if (showBarChart) ...[
                    const SizedBox(height: 20),
                    _buildBarChart(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('October 2023',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('Details >',
                              style: TextStyle(
                                  color: Color(0xFF06B6D4), fontSize: 12)),
                        ),
                      ],
                    ),
                  ] else ...[
                    Center(
                      child: _buildDonutChart(),
                    ),
                    const SizedBox(height: 20),
                    _buildCategoryLegend(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Smart Insights
            const Text('Smart Insights',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Spending Alert
            GestureDetector(
              onTap: () => _showSpendingAlert(context),
              child: Container(
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
                        color: const Color(0xFFEA580C).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.trending_up,
                          color: Color(0xFFEA580C), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Spending Alert',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'You spent 20% more on dining this month\ncompared to your average.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Savings Opportunity
            GestureDetector(
              onTap: () => _showSavingsOpportunity(context),
              child: Container(
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
                      child: const Icon(Icons.trending_down,
                          color: Color(0xFF06B6D4), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Savings Opportunity',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'Your transport spending decreased by 15%\ncompared to last month.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Smart Tip
            GestureDetector(
              onTap: () => _showSmartTip(context),
              child: Container(
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
                        color: const Color(0xFF8B5CF6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.lightbulb_outline,
                          color: Color(0xFF8B5CF6), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Smart Tip',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                              'Setting a budget for shopping could help\nyou save ₹1,000 monthly.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<double> values = [350, 300, 400, 600, 700, 400, 300];
    double maxValue = 900;

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          double height = (values[index] / maxValue) * 150;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              Text(days[index],
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDonutChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                const Color(0xFFEA580C),
                const Color(0xFF06B6D4),
                const Color(0xFF10B981),
                const Color(0xFF8B5CF6),
                const Color(0xFFEA580C),
              ],
              stops: const [0.0, 0.33, 0.66, 0.99, 1.0],
            ),
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0F172A),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Total Spent',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 4),
            Text('₹12,500',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('+8.5%',
                style: TextStyle(color: Color(0xFF10B981), fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryLegend() {
    final categories = [
      {
        'name': 'Food & Dining',
        'percentage': '33.8%',
        'color': const Color(0xFFEA580C)
      },
      {
        'name': 'Shopping',
        'percentage': '22.4%',
        'color': const Color(0xFFEA580C)
      },
      {
        'name': 'Housing',
        'percentage': '20%',
        'color': const Color(0xFF06B6D4)
      },
      {
        'name': 'Transport',
        'percentage': '12%',
        'color': const Color(0xFF06B6D4)
      },
      {'name': 'Health', 'percentage': '8%', 'color': const Color(0xFF10B981)},
      {'name': 'Utilities', 'percentage': '4%', 'color': Colors.grey},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 3,
      children: categories
          .map((cat) => Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: cat['color'] as Color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['name'] as String,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                        Text(cat['percentage'] as String,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }

  void _showAnalyticsInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics Information')),
    );
  }

  void _showSpendingAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Spending Alert Details')),
    );
  }

  void _showSavingsOpportunity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Savings Opportunity Details')),
    );
  }

  void _showSmartTip(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Get Personalized Tips')),
    );
  }
}
