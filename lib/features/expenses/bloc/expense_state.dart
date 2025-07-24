import 'package:equatable/equatable.dart';
import '../../../models/expense_model.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  final bool hasMore;
  final int total;

  const ExpenseLoaded({
    required this.expenses,
    this.hasMore = false,
    required this.total,
  });

  @override
  List<Object> get props => [expenses, hasMore, total];
}

class ExpenseOperationInProgress extends ExpenseState {
  final List<ExpenseModel> expenses;

  const ExpenseOperationInProgress(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class ExpenseOperationSuccess extends ExpenseState {
  final List<ExpenseModel> expenses;
  final String message;

  const ExpenseOperationSuccess({
    required this.expenses,
    required this.message,
  });

  @override
  List<Object> get props => [expenses, message];
}

class ExpenseError extends ExpenseState {
  final String message;
  final List<ExpenseModel>? expenses;

  const ExpenseError({required this.message, this.expenses});

  @override
  List<Object?> get props => [message, expenses];
}

class ExpenseCategoryPredicted extends ExpenseState {
  final CategoryPrediction prediction;
  final List<ExpenseModel> expenses;

  const ExpenseCategoryPredicted({
    required this.prediction,
    required this.expenses,
  });

  @override
  List<Object> get props => [prediction, expenses];
}
