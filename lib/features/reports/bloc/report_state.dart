import 'package:equatable/equatable.dart';
import '../../../models/report_model.dart';
import 'report_event.dart';

abstract class ReportState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedCategory;
  final ReportType reportType;

  const ReportState({
    required this.startDate,
    required this.endDate,
    this.selectedCategory,
    this.reportType = ReportType.weekly,
  });

  @override
  List<Object?> get props => [startDate, endDate, selectedCategory, reportType];
}

class ReportInitial extends ReportState {
  ReportInitial()
      : super(
          startDate: DateTime.now().subtract(const Duration(days: 7)),
          endDate: DateTime.now(),
          reportType: ReportType.weekly,
        );
}

class ReportLoading extends ReportState {
  const ReportLoading({
    required super.startDate,
    required super.endDate,
    super.selectedCategory,
    super.reportType,
  });
}

class ReportLoaded extends ReportState {
  final ReportModel reportData;
  final Map<String, double> categoryData;
  final List<MonthlyData> monthlyData;
  final List<TrendData> trendData;

  const ReportLoaded({
    required this.reportData,
    required this.categoryData,
    required this.monthlyData,
    required this.trendData,
    required super.startDate,
    required super.endDate,
    super.selectedCategory,
    super.reportType,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        reportData,
        categoryData,
        monthlyData,
        trendData,
      ];
}

class ReportError extends ReportState {
  final String message;

  const ReportError({
    required this.message,
    required super.startDate,
    required super.endDate,
    super.selectedCategory,
    super.reportType,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

class MonthlyData {
  final String month;
  final double amount;
  final int count;

  MonthlyData({
    required this.month,
    required this.amount,
    required this.count,
  });
}

class TrendData {
  final DateTime date;
  final double amount;
  final String category;

  TrendData({
    required this.date,
    required this.amount,
    required this.category,
  });
}