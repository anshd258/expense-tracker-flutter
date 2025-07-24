import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'expense_model.g.dart';

enum ExpenseCategory {
  @JsonValue('FOOD')
  food,
  @JsonValue('TRANSPORT')
  transport,
  @JsonValue('SHOPPING')
  shopping,
  @JsonValue('ENTERTAINMENT')
  entertainment,
  @JsonValue('UTILITIES')
  utilities,
  @JsonValue('HEALTHCARE')
  healthcare,
  @JsonValue('OTHER')
  other,

}

@JsonSerializable()
class ExpenseModel extends Equatable {
  final String? id;
  final double amount;
  final String description;
  final ExpenseCategory category;
  final DateTime date;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ExpenseModel({
    this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    String? id,
    double? amount,
    String? description,
    ExpenseCategory? category,
    DateTime? date,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    description,
    category,
    date,
    userId,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class CategoryPrediction extends Equatable {
  final ExpenseCategory category;
  final double confidence;

  const CategoryPrediction({required this.category, required this.confidence});

  factory CategoryPrediction.fromJson(Map<String, dynamic> json) =>
      _$CategoryPredictionFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryPredictionToJson(this);

  @override
  List<Object> get props => [category, confidence];
}

@JsonSerializable()
class ExpenseListResponse extends Equatable {
  final List<ExpenseModel> expenses;
  final int total;

  const ExpenseListResponse({required this.expenses, required this.total});

  factory ExpenseListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseListResponseToJson(this);

  @override
  List<Object> get props => [expenses, total];
}
