import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bloc/report_state.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<MonthlyData> data;

  const MonthlyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    if (data.isEmpty) {
      return ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No data available',
              style: theme.textTheme.muted,
            ),
          ),
        ),
      );
    }
    
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.isNotEmpty && data.first.month.startsWith('Week') 
                  ? 'Weekly Breakdown' 
                  : 'Monthly Expenses',
              style: theme.textTheme.h4,
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => theme.colorScheme.popover,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= data.length) return null;
                        return BarTooltipItem(
                          '${data[groupIndex].month}\n',
                          TextStyle(
                            color: theme.colorScheme.popoverForeground,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: NumberFormat.currency(symbol: '\$')
                                  .format(rod.toY),
                              style: TextStyle(
                                color: theme.colorScheme.popoverForeground,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: '\n${data[groupIndex].count} transactions',
                              style: TextStyle(
                                color: theme.colorScheme.muted,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: data.length > 4 ? 1 : 0,
                                child: Text(
                                  data[value.toInt()].month,
                                  style: TextStyle(
                                    color: theme.colorScheme.mutedForeground,
                                    fontSize: data.length > 6 ? 10 : 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: data.length > 4 ? 60 : 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        interval: _getInterval(),
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
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.border,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: theme.colorScheme.border,
                        width: 1,
                      ),
                    ),
                  ),
                  barGroups: _generateBarGroups(theme),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getInterval(),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.border,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(ShadThemeData theme) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final monthData = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthData.amount,
            color: theme.colorScheme.primary,
            width: data.length > 12 ? 10 : 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
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
}