// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReportResponse _$DailyReportResponseFromJson(Map<String, dynamic> json) =>
    DailyReportResponse(
      date: DateTime.parse(json['date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      expensesCount: (json['expenses_count'] as num).toInt(),
      categories: (json['categories'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$DailyReportResponseToJson(
  DailyReportResponse instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'total_amount': instance.totalAmount,
  'expenses_count': instance.expensesCount,
  'categories': instance.categories,
};

DailyBreakdown _$DailyBreakdownFromJson(Map<String, dynamic> json) =>
    DailyBreakdown(
      date: DateTime.parse(json['date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      expensesCount: (json['expenses_count'] as num).toInt(),
      categories: (json['categories'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$DailyBreakdownToJson(DailyBreakdown instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'total_amount': instance.totalAmount,
      'expenses_count': instance.expensesCount,
      'categories': instance.categories,
    };

WeeklyReportResponse _$WeeklyReportResponseFromJson(
  Map<String, dynamic> json,
) => WeeklyReportResponse(
  weekStart: DateTime.parse(json['week_start'] as String),
  weekEnd: DateTime.parse(json['week_end'] as String),
  totalAmount: (json['total_amount'] as num).toDouble(),
  expensesCount: (json['expenses_count'] as num).toInt(),
  dailyBreakdown: (json['daily_breakdown'] as List<dynamic>)
      .map((e) => DailyBreakdown.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
);

Map<String, dynamic> _$WeeklyReportResponseToJson(
  WeeklyReportResponse instance,
) => <String, dynamic>{
  'week_start': instance.weekStart.toIso8601String(),
  'week_end': instance.weekEnd.toIso8601String(),
  'total_amount': instance.totalAmount,
  'expenses_count': instance.expensesCount,
  'daily_breakdown': instance.dailyBreakdown,
  'categories': instance.categories,
};

MonthlyReportResponse _$MonthlyReportResponseFromJson(
  Map<String, dynamic> json,
) => MonthlyReportResponse(
  monthStart: json['month_start'] == null
      ? null
      : DateTime.parse(json['month_start'] as String),
  monthEnd: json['month_end'] == null
      ? null
      : DateTime.parse(json['month_end'] as String),
  totalAmount: (json['total_amount'] as num).toDouble(),
  expensesCount: (json['expenses_count'] as num).toInt(),
  weeklyBreakdown: (json['weekly_breakdown'] as List<dynamic>?)
      ?.map((e) => WeeklyBreakdown.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  dailyAverage: (json['daily_average'] as num).toDouble(),
);

Map<String, dynamic> _$MonthlyReportResponseToJson(
  MonthlyReportResponse instance,
) => <String, dynamic>{
  'month_start': instance.monthStart?.toIso8601String(),
  'month_end': instance.monthEnd?.toIso8601String(),
  'total_amount': instance.totalAmount,
  'expenses_count': instance.expensesCount,
  'weekly_breakdown': instance.weeklyBreakdown,
  'categories': instance.categories,
  'daily_average': instance.dailyAverage,
};

WeeklyBreakdown _$WeeklyBreakdownFromJson(Map<String, dynamic> json) =>
    WeeklyBreakdown(
      weekStart: DateTime.parse(json['week_start'] as String),
      weekEnd: DateTime.parse(json['week_end'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      expensesCount: (json['expenses_count'] as num).toInt(),
      categories: (json['categories'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$WeeklyBreakdownToJson(WeeklyBreakdown instance) =>
    <String, dynamic>{
      'week_start': instance.weekStart.toIso8601String(),
      'week_end': instance.weekEnd.toIso8601String(),
      'total_amount': instance.totalAmount,
      'expenses_count': instance.expensesCount,
      'categories': instance.categories,
    };

CategorySummary _$CategorySummaryFromJson(Map<String, dynamic> json) =>
    CategorySummary(
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      total: (json['total'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$CategorySummaryToJson(CategorySummary instance) =>
    <String, dynamic>{
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'total': instance.total,
      'count': instance.count,
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'FOOD',
  ExpenseCategory.transport: 'TRANSPORT',
  ExpenseCategory.shopping: 'SHOPPING',
  ExpenseCategory.entertainment: 'ENTERTAINMENT',
  ExpenseCategory.utilities: 'UTILITIES',
  ExpenseCategory.healthcare: 'HEALTHCARE',
  ExpenseCategory.other: 'OTHER',
};

DailySummary _$DailySummaryFromJson(Map<String, dynamic> json) => DailySummary(
  date: DateTime.parse(json['date'] as String),
  total: (json['total'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
  byCategory: (json['by_category'] as List<dynamic>)
      .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DailySummaryToJson(DailySummary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'total': instance.total,
      'count': instance.count,
      'by_category': instance.byCategory,
    };

ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) =>
    ReportSummary(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalExpenses: (json['total_expenses'] as num).toInt(),
      byCategory: (json['by_category'] as List<dynamic>)
          .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailySummaries: (json['daily_summaries'] as List<dynamic>?)
          ?.map((e) => DailySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportSummaryToJson(ReportSummary instance) =>
    <String, dynamic>{
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'total_amount': instance.totalAmount,
      'total_expenses': instance.totalExpenses,
      'by_category': instance.byCategory,
      'daily_summaries': instance.dailySummaries,
    };

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  totalExpenses: (json['total_expenses'] as num).toDouble(),
  averageDaily: (json['average_daily'] as num).toDouble(),
  totalTransactions: (json['total_transactions'] as num).toInt(),
  highestCategory: json['highest_category'] as String,
  highestCategoryAmount: (json['highest_category_amount'] as num).toDouble(),
  expenses: (json['expenses'] as List<dynamic>)
      .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'total_expenses': instance.totalExpenses,
      'average_daily': instance.averageDaily,
      'total_transactions': instance.totalTransactions,
      'highest_category': instance.highestCategory,
      'highest_category_amount': instance.highestCategoryAmount,
      'expenses': instance.expenses,
    };
