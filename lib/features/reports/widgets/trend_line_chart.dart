import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bloc/report_state.dart';

class TrendLineChart extends StatelessWidget {
  final List<TrendData> data;

  const TrendLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final groupedData = _groupDataByCategory();

    if (data.isEmpty) {
      return ShadCard(
        padding: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No trend data available',
              style: theme.textTheme.muted,
            ),
          ),
        ),
      );
    }

    return ShadCard(
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expense Trends', style: theme.textTheme.h4),
                if (groupedData.keys.length > 1)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildLegend(theme, groupedData.keys.toList()),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: _getInterval(),
                    verticalInterval: data.length > 7
                        ? (data.length / 7).ceilToDouble()
                        : 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.border,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.border,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (data.isEmpty) return const SizedBox.shrink();

                          final index = value.toInt();
                          if (index < 0 || index >= data.length) {
                            return const SizedBox.shrink();
                          }

                          // Show fewer labels if there are many data points
                          final showInterval = data.length > 7
                              ? (data.length / 7).ceil()
                              : 1;

                          if (index % showInterval == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: data.length > 10 ? 1 : 0,
                                child: Text(
                                  DateFormat(
                                    data.length > 10 ? 'MM/dd' : 'MMM dd',
                                  ).format(data[index].date),
                                  style: TextStyle(
                                    color: theme.colorScheme.mutedForeground,
                                    fontSize: data.length > 10 ? 9 : 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getInterval(),
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              NumberFormat.compact().format(value),
                              style: TextStyle(
                                color: theme.colorScheme.mutedForeground,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: theme.colorScheme.border,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: (data.length - 1).toDouble(),
                  minY: 0,
                  maxY: _getMaxY(),
                  lineBarsData: _generateLineBars(groupedData),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          theme.colorScheme.popover,
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          if (touchedSpot.barIndex >= groupedData.keys.length) {
                            return null;
                          }
                          final category = groupedData.keys
                              .toList()[touchedSpot.barIndex];
                          return LineTooltipItem(
                            '${_getCategoryLabel(category)}\n',
                            TextStyle(
                              color: theme.colorScheme.popoverForeground,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: NumberFormat.currency(
                                  symbol: '\$',
                                ).format(touchedSpot.y),
                                style: TextStyle(
                                  color: theme.colorScheme.popoverForeground,
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<TrendData>> _groupDataByCategory() {
    final grouped = <String, List<TrendData>>{};
    for (final item in data) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  List<LineChartBarData> _generateLineBars(
    Map<String, List<TrendData>> groupedData,
  ) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
    ];

    return groupedData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final categoryData = entry.value;

      final spots = <FlSpot>[];
      for (int i = 0; i < data.length; i++) {
        final dayData = data[i];
        final categoryValue = categoryData.value
            .where((item) => item.date == dayData.date)
            .firstOrNull;
        spots.add(FlSpot(i.toDouble(), categoryValue?.amount ?? 0));
      }

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: colors[index % colors.length],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: data.length <= 7,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 3,
              color: colors[index % colors.length],
              strokeWidth: 1,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: colors[index % colors.length].withValues(alpha: 0.1),
        ),
      );
    }).toList();
  }

  Widget _buildLegend(ShadThemeData theme, List<String> categories) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: categories.take(3).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;

        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 3,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _getCategoryLabel(category),
                style: theme.textTheme.muted.copyWith(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _getMaxY() {
    if (data.isEmpty) return 100;
    final max = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return max * 1.2; // Add 20% padding
  }

  double _getInterval() {
    final max = _getMaxY();
    if (max < 100) return 20;
    if (max < 1000) return 200;
    if (max < 10000) return 2000;
    return 5000;
  }

  String _getCategoryLabel(String category) {
    final labels = {
      'total': 'Total',
      'weekly_total': 'Weekly Total',
      'FOOD': 'Food',
      'TRANSPORT': 'Transport',
      'SHOPPING': 'Shopping',
      'ENTERTAINMENT': 'Entertainment',
      'BILLS': 'Bills',
      'UTILITIES': 'Utilities',
      'HEALTH': 'Health',
      'HEALTHCARE': 'Healthcare',
      'EDUCATION': 'Education',
      'OTHER': 'Other',
      'food': 'Food',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'bills': 'Bills',
      'utilities': 'Utilities',
      'health': 'Health',
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
                  ? word[0].toUpperCase() + word.substring(1)
                  : '',
            )
            .join(' ');
  }
}
