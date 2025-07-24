import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/expense_model.dart';
import '../../../models/report_model.dart';
import '../../../services/report_service.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService reportService;

  ReportBloc({required this.reportService}) : super(ReportInitial()) {
    on<ReportDataRequested>(_onReportDataRequested);
    on<ReportFilterChanged>(_onReportFilterChanged);
    on<ReportTypeChanged>(_onReportTypeChanged);
  }

  Future<void> _onReportDataRequested(
    ReportDataRequested event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading(
      startDate: event.startDate,
      endDate: event.endDate,
      selectedCategory: event.category,
      reportType: state.reportType,
    ));

    try {
      // Variables to hold processed data
      double totalAmount = 0;
      int expensesCount = 0;
      Map<String, double> categoryData = {};
      List<TrendData> trendData = [];
      List<MonthlyData> monthlyData = [];
      double averageDaily = 0;

      switch (state.reportType) {
        case ReportType.daily:
          final dailyReport = await reportService.getDailyReport(event.endDate);
          totalAmount = dailyReport.totalAmount;
          expensesCount = dailyReport.expensesCount;
          categoryData = dailyReport.categories;
          averageDaily = totalAmount; // For daily, average is the same as total
          
          // For daily report, create a single trend point
          trendData.add(TrendData(
            date: dailyReport.date,
            amount: dailyReport.totalAmount,
            category: 'total',
          ));
          break;

        case ReportType.weekly:
          final weeklyReport = await reportService.getWeeklyReport(
            startDate: event.startDate,
          );
          totalAmount = weeklyReport.totalAmount;
          expensesCount = weeklyReport.expensesCount;
          categoryData = weeklyReport.categories;
          
          // Calculate daily average
          final days = weeklyReport.weekEnd.difference(weeklyReport.weekStart).inDays + 1;
          averageDaily = totalAmount / days;
          
          // Create trend data from daily breakdown
          for (final daily in weeklyReport.dailyBreakdown) {
            trendData.add(TrendData(
              date: daily.date,
              amount: daily.totalAmount,
              category: 'total',
            ));
          }
          break;

        case ReportType.monthly:
          final monthlyReport = await reportService.getMonthlyReport(
            year: event.endDate.year,
            month: event.endDate.month,
          );
          totalAmount = monthlyReport.totalAmount;
          expensesCount = monthlyReport.expensesCount;
          categoryData = monthlyReport.categories;
          averageDaily = monthlyReport.dailyAverage;
          
          // Create monthly data from weekly breakdown if available
          if (monthlyReport.weeklyBreakdown != null) {
            for (int i = 0; i < monthlyReport.weeklyBreakdown!.length; i++) {
              final weekly = monthlyReport.weeklyBreakdown![i];
              monthlyData.add(MonthlyData(
                month: 'Week ${i + 1}',
                amount: weekly.totalAmount,
                count: weekly.expensesCount,
              ));
              
              // Also create trend data for each week
              trendData.add(TrendData(
                date: weekly.weekStart,
                amount: weekly.totalAmount,
                category: 'weekly_total',
              ));
            }
          }
          break;
      }

      // Find highest category
      String highestCategory = 'None';
      double highestCategoryAmount = 0;
      if (categoryData.isNotEmpty) {
        categoryData.forEach((category, amount) {
          if (amount > highestCategoryAmount) {
            highestCategory = category;
            highestCategoryAmount = amount;
          }
        });
      }

      // Create ReportModel for compatibility
      final reportData = ReportModel(
        totalExpenses: totalAmount,
        averageDaily: averageDaily,
        totalTransactions: expensesCount,
        highestCategory: highestCategory,
        highestCategoryAmount: highestCategoryAmount,
        expenses: [], // API doesn't return individual expenses
      );

      emit(ReportLoaded(
        reportData: reportData,
        categoryData: categoryData,
        monthlyData: monthlyData,
        trendData: trendData,
        startDate: event.startDate,
        endDate: event.endDate,
        selectedCategory: event.category,
        reportType: state.reportType,
      ));
    } catch (e) {
      emit(ReportError(
        message: e.toString(),
        startDate: event.startDate,
        endDate: event.endDate,
        selectedCategory: event.category,
        reportType: state.reportType,
      ));
    }
  }

  Future<void> _onReportFilterChanged(
    ReportFilterChanged event,
    Emitter<ReportState> emit,
  ) async {
    final startDate = event.startDate ?? state.startDate;
    final endDate = event.endDate ?? state.endDate;
    final category = event.category;

    add(ReportDataRequested(
      startDate: startDate,
      endDate: endDate,
      category: category,
    ));
  }

  void _onReportTypeChanged(
    ReportTypeChanged event,
    Emitter<ReportState> emit,
  ) {
    // Update the state with new report type
    final currentState = state;
    if (currentState is ReportLoaded) {
      emit(ReportLoaded(
        reportData: currentState.reportData,
        categoryData: currentState.categoryData,
        monthlyData: currentState.monthlyData,
        trendData: currentState.trendData,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        selectedCategory: currentState.selectedCategory,
        reportType: event.reportType,
      ));
    } else {
      emit(ReportInitial());
    }
    
    // Adjust date range based on report type
    DateTime startDate;
    final endDate = DateTime.now();
    
    switch (event.reportType) {
      case ReportType.daily:
        startDate = endDate; // Same day
        break;
      case ReportType.weekly:
        // Start from beginning of the week (Sunday)
        final weekday = endDate.weekday;
        startDate = endDate.subtract(Duration(days: weekday % 7));
        break;
      case ReportType.monthly:
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
    }
    
    // Request new data with adjusted dates
    add(ReportDataRequested(
      startDate: startDate,
      endDate: endDate,
      category: currentState.selectedCategory,
    ));
  }
}