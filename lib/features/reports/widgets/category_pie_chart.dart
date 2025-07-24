import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final total = widget.data.values.fold(0.0, (sum, value) => sum + value);

    return ShadCard(
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Expenses by Category', style: theme.textTheme.h4),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 0,
                          sections: _generateSections(total),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildLegend(theme, total),
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

  List<PieChartSectionData> _generateSections(double total) {
    if (widget.data.isEmpty || total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1,
          title: '',
          radius: 100,
        ),
      ];
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
    ];

    return widget.data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 110.0 : 100.0;
      final percentage = (data.value / total * 100);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: data.value,
        title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(ShadThemeData theme, double total) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.data.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final percentage = total > 0 ? (data.value / total * 100) : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getCategoryLabel(data.key),
                      style: theme.textTheme.p.copyWith(
                        fontSize: 12,
                        fontWeight: touchedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${NumberFormat.currency(symbol: '\$').format(data.value)} (${percentage.toStringAsFixed(1)}%)',
                      style: theme.textTheme.muted.copyWith(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryLabel(String category) {
    final labels = {
      'FOOD': 'Food & Dining',
      'TRANSPORT': 'Transportation',
      'SHOPPING': 'Shopping',
      'ENTERTAINMENT': 'Entertainment',
      'BILLS': 'Bills & Utilities',
      'UTILITIES': 'Utilities',
      'HEALTH': 'Healthcare',
      'HEALTHCARE': 'Healthcare',
      'EDUCATION': 'Education',
      'OTHER': 'Other',
      'food': 'Food & Dining',
      'transport': 'Transportation',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'bills': 'Bills & Utilities',
      'utilities': 'Utilities',
      'health': 'Healthcare',
      'healthcare': 'Healthcare',
      'education': 'Education',
      'other': 'Other',
    };
    return labels[category] ??
        category
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
            )
            .join(' ');
  }
}
