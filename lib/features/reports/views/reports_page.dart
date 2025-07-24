import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/utils/file_download_helper.dart';
import '../../../services/report_service.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';
import '../widgets/trend_line_chart.dart';
import '../widgets/report_summary_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    // Default to weekly report (last 7 days)
    context.read<ReportBloc>().add(
      ReportDataRequested(
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ShadTheme.of(context).colorScheme.background,
          body: Column(
            children: [
              _buildHeader(context, state),
              Expanded(
                child: state is ReportLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is ReportLoaded
                    ? _buildReportContent(context, state)
                    : state is ReportError
                    ? _buildErrorState(context, state)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ReportState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.card,
        border: Border(
          bottom: BorderSide(
            color: ShadTheme.of(context).colorScheme.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Financial Reports',
                  style: ShadTheme.of(context).textTheme.h3,
                ),
              ),

              _buildReportTypeSelector(context, state),
            ],
          ),
          const SizedBox(height: 16),
          _buildExportButton(context, state),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context, ReportState state) {
    return ShadButton.outline(
      onPressed: state is ReportLoaded
          ? () => _handleExport(context, state)
          : null,
      icon: const Icon(Icons.download, size: 16),
      child: const Text('Export CSV'),
    );
  }

  Widget _buildReportTypeSelector(BuildContext context, ReportState state) {
    return ShadSelect<ReportType>(
      initialValue: state.reportType,
      onChanged: (value) {
        context.read<ReportBloc>().add(ReportTypeChanged(value));
      },
      options: const [
        ShadOption(value: ReportType.daily, child: Text('Daily')),
        ShadOption(value: ReportType.weekly, child: Text('Weekly')),
        ShadOption(value: ReportType.monthly, child: Text('Monthly')),
      ],
      selectedOptionBuilder: (context, value) {
        return Text(_getReportTypeLabel(value));
      },
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, ReportState state) {
    return Row(
      children: [
        Expanded(
          child: ShadButton.outline(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null && mounted) {
                context.read<ReportBloc>().add(
                  ReportFilterChanged(startDate: date),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(DateFormat('MMM dd, yyyy').format(state.startDate)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward),
        const SizedBox(width: 8),
        Expanded(
          child: ShadButton.outline(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.endDate,
                firstDate: state.startDate,
                lastDate: DateTime.now(),
              );
              if (date != null && mounted) {
                context.read<ReportBloc>().add(
                  ReportFilterChanged(endDate: date),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(DateFormat('MMM dd, yyyy').format(state.endDate)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context, ReportLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(context, state),
          const SizedBox(height: 24),
          _buildChartSection(context, state),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, ReportLoaded state) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        ReportSummaryCard(
          title: 'Total Expenses',
          value: state.reportData.totalExpenses,
          icon: Icons.account_balance_wallet,
          color: ShadTheme.of(context).colorScheme.primary,
        ),
        ReportSummaryCard(
          title: 'Average Daily',
          value: state.reportData.averageDaily,
          icon: Icons.trending_up,
          color: ShadTheme.of(context).colorScheme.secondary,
        ),
        ReportSummaryCard(
          title: 'Total Transactions',
          value: state.reportData.totalTransactions.toDouble(),
          icon: Icons.receipt_long,
          color: Colors.orange,
          isCount: true,
        ),
        ReportSummaryCard(
          title: 'Highest Category',
          value: state.reportData.highestCategoryAmount,
          subtitle: state.reportData.highestCategory,
          icon: Icons.category,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context, ReportLoaded state) {
    return Column(
      children: [
        // Category breakdown chart (for all report types)
        if (state.categoryData.isNotEmpty) ...[
          Text('Category Breakdown', style: ShadTheme.of(context).textTheme.h4),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: CategoryPieChart(data: state.categoryData),
          ),
          const SizedBox(height: 24),
        ],

        // Charts based on report type
        if (state.reportType == ReportType.daily) ...[
          // For daily reports, show a simple summary since it's just one day
          if (state.categoryData.isEmpty)
            Center(
              child: Text(
                'No expenses for this day',
                style: ShadTheme.of(context).textTheme.muted,
              ),
            ),
        ] else if (state.reportType == ReportType.weekly) ...[
          // For weekly reports, show daily trend
          if (state.trendData.isNotEmpty) ...[
            Text(
              'Daily Spending Trend',
              style: ShadTheme.of(context).textTheme.h4,
            ),
            const SizedBox(height: 16),
            SizedBox(height: 300, child: TrendLineChart(data: state.trendData)),
            const SizedBox(height: 24),
          ],
        ] else if (state.reportType == ReportType.monthly) ...[
          // For monthly reports, show weekly breakdown
          if (state.monthlyData.isNotEmpty) ...[
            Text('Weekly Breakdown', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: MonthlyBarChart(data: state.monthlyData),
            ),
            const SizedBox(height: 24),
          ],
          // Also show trend for monthly
          if (state.trendData.isNotEmpty) ...[
            Text('Weekly Trend', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 16),
            SizedBox(height: 300, child: TrendLineChart(data: state.trendData)),
          ],
        ],
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, ReportError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading reports',
            style: ShadTheme.of(context).textTheme.h3,
          ),
          const SizedBox(height: 8),
          Text(state.message, style: ShadTheme.of(context).textTheme.muted),
          const SizedBox(height: 16),
          ShadButton(
            onPressed: () {
              context.read<ReportBloc>().add(
                ReportDataRequested(
                  startDate: state.startDate,
                  endDate: state.endDate,
                ),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getReportTypeLabel(ReportType type) {
    switch (type) {
      case ReportType.daily:
        return 'Daily';
      case ReportType.weekly:
        return 'Weekly';
      case ReportType.monthly:
        return 'Monthly';
    }
  }

  Future<void> _handleExport(BuildContext context, ReportState state) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final reportService = context.read<ReportService>();
      final bytes = await reportService.exportToCsv(
        startDate: state.startDate,
        endDate: state.endDate,
        reportType: state.reportType.name,
      );

      // Generate filename with date range
      final dateFormat = DateFormat('yyyyMMdd');
      final startDateStr = dateFormat.format(state.startDate);
      final endDateStr = dateFormat.format(state.endDate);
      final fileName =
          'expense_report_${state.reportType.name}_${startDateStr}_${endDateStr}.csv';

      // Download the file
      await FileDownloadHelper.downloadFile(bytes: bytes, fileName: fileName);

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
