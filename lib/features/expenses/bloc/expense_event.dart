import 'package:equatable/equatable.dart';
import '../../../models/expense_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class ExpenseLoadRequested extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final ExpenseCategory? category;
  final int? limit;
  final int? offset;

  const ExpenseLoadRequested({
    this.startDate,
    this.endDate,
    this.category,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [startDate, endDate, category, limit, offset];
}

class ExpenseAddRequested extends ExpenseEvent {
  final ExpenseModel expense;

  const ExpenseAddRequested(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseUpdateRequested extends ExpenseEvent {
  final String id;
  final ExpenseModel expense;

  const ExpenseUpdateRequested(this.id, this.expense);

  @override
  List<Object> get props => [id, expense];
}

class ExpenseDeleteRequested extends ExpenseEvent {
  final String id;

  const ExpenseDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}

class ExpenseCategoryPredictionRequested extends ExpenseEvent {
  final String description;

  const ExpenseCategoryPredictionRequested(this.description);

  @override
  List<Object> get props => [description];
}