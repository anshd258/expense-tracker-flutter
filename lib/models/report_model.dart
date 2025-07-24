import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'expense_model.dart';

part 'report_model.g.dart';

// Base response model for daily report
@JsonSerializable()
class DailyReportResponse extends Equatable {
  final DateTime date;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'expenses_count')
  final int expensesCount;
  final Map<String, double> categories;

  const DailyReportResponse({
    required this.date,
    required this.totalAmount,
    required this.expensesCount,
    required this.categories,
  });

  factory DailyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyReportResponseToJson(this);

  @override
  List<Object> get props => [date, totalAmount, expensesCount, categories];
}

// Model for daily breakdown in weekly/monthly reports
@JsonSerializable()
class DailyBreakdown extends Equatable {
  final DateTime date;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'expenses_count')
  final int expensesCount;
  final Map<String, double> categories;

  const DailyBreakdown({
    required this.date,
    required this.totalAmount,
    required this.expensesCount,
    required this.categories,
  });

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$DailyBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$DailyBreakdownToJson(this);

  @override
  List<Object> get props => [date, totalAmount, expensesCount, categories];
}

// Weekly report response model
@JsonSerializable()
class WeeklyReportResponse extends Equatable {
  @JsonKey(name: 'week_start')
  final DateTime weekStart;
  @JsonKey(name: 'week_end')
  final DateTime weekEnd;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'expenses_count')
  final int expensesCount;
  @JsonKey(name: 'daily_breakdown')
  final List<DailyBreakdown> dailyBreakdown;
  final Map<String, double> categories;

  const WeeklyReportResponse({
    required this.weekStart,
    required this.weekEnd,
    required this.totalAmount,
    required this.expensesCount,
    required this.dailyBreakdown,
    required this.categories,
  });

  factory WeeklyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyReportResponseToJson(this);

  @override
  List<Object> get props => [
        weekStart,
        weekEnd,
        totalAmount,
        expensesCount,
        dailyBreakdown,
        categories,
      ];
}

// Monthly report response model
@JsonSerializable()
class MonthlyReportResponse extends Equatable {
  @JsonKey(name: 'month_start')
  final DateTime? monthStart;
  @JsonKey(name: 'month_end')
  final DateTime? monthEnd;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'expenses_count')
  final int expensesCount;
  @JsonKey(name: 'weekly_breakdown')
  final List<WeeklyBreakdown>? weeklyBreakdown;
  final Map<String, double> categories;
  @JsonKey(name: 'daily_average')
  final double dailyAverage;

  const MonthlyReportResponse({
    this.monthStart,
    this.monthEnd,
    required this.totalAmount,
    required this.expensesCount,
    this.weeklyBreakdown,
    required this.categories,
    required this.dailyAverage,
  });

  factory MonthlyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyReportResponseToJson(this);

  @override
  List<Object?> get props => [
        monthStart,
        monthEnd,
        totalAmount,
        expensesCount,
        weeklyBreakdown,
        categories,
        dailyAverage,
      ];
}

// Weekly breakdown for monthly reports
@JsonSerializable()
class WeeklyBreakdown extends Equatable {
  @JsonKey(name: 'week_start')
  final DateTime weekStart;
  @JsonKey(name: 'week_end')
  final DateTime weekEnd;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'expenses_count')
  final int expensesCount;
  final Map<String, double> categories;

  const WeeklyBreakdown({
    required this.weekStart,
    required this.weekEnd,
    required this.totalAmount,
    required this.expensesCount,
    required this.categories,
  });

  factory WeeklyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$WeeklyBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyBreakdownToJson(this);

  @override
  List<Object> get props => [
        weekStart,
        weekEnd,
        totalAmount,
        expensesCount,
        categories,
      ];
}

// Keep existing models for compatibility
@JsonSerializable()
class CategorySummary extends Equatable {
  final ExpenseCategory category;
  final double total;
  final int count;

  const CategorySummary({
    required this.category,
    required this.total,
    required this.count,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) =>
      _$CategorySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySummaryToJson(this);

  @override
  List<Object> get props => [category, total, count];
}

@JsonSerializable()
class DailySummary extends Equatable {
  final DateTime date;
  final double total;
  final int count;
  @JsonKey(name: 'by_category')
  final List<CategorySummary> byCategory;

  const DailySummary({
    required this.date,
    required this.total,
    required this.count,
    required this.byCategory,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DailySummaryToJson(this);

  @override
  List<Object> get props => [date, total, count, byCategory];
}

@JsonSerializable()
class ReportSummary extends Equatable {
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'total_expenses')
  final int totalExpenses;
  @JsonKey(name: 'by_category')
  final List<CategorySummary> byCategory;
  @JsonKey(name: 'daily_summaries')
  final List<DailySummary>? dailySummaries;

  const ReportSummary({
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.totalExpenses,
    required this.byCategory,
    this.dailySummaries,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ReportSummaryToJson(this);

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        totalAmount,
        totalExpenses,
        byCategory,
        dailySummaries,
      ];
}

@JsonSerializable()
class ReportModel extends Equatable {
  @JsonKey(name: 'total_expenses')
  final double totalExpenses;
  @JsonKey(name: 'average_daily')
  final double averageDaily;
  @JsonKey(name: 'total_transactions')
  final int totalTransactions;
  @JsonKey(name: 'highest_category')
  final String highestCategory;
  @JsonKey(name: 'highest_category_amount')
  final double highestCategoryAmount;
  final List<ExpenseModel> expenses;

  const ReportModel({
    required this.totalExpenses,
    required this.averageDaily,
    required this.totalTransactions,
    required this.highestCategory,
    required this.highestCategoryAmount,
    required this.expenses,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  @override
  List<Object> get props => [
        totalExpenses,
        averageDaily,
        totalTransactions,
        highestCategory,
        highestCategoryAmount,
        expenses,
      ];
}