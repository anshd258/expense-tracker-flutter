// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
  id: json['id'] as String?,
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
  date: DateTime.parse(json['date'] as String),
  userId: json['user_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'description': instance.description,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'date': instance.date.toIso8601String(),
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
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

CategoryPrediction _$CategoryPredictionFromJson(Map<String, dynamic> json) =>
    CategoryPrediction(
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$CategoryPredictionToJson(CategoryPrediction instance) =>
    <String, dynamic>{
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'confidence': instance.confidence,
    };

ExpenseListResponse _$ExpenseListResponseFromJson(Map<String, dynamic> json) =>
    ExpenseListResponse(
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ExpenseListResponseToJson(
  ExpenseListResponse instance,
) => <String, dynamic>{'expenses': instance.expenses, 'total': instance.total};
