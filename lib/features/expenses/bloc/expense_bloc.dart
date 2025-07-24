import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/expense_model.dart';
import '../../../services/expense_service.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseService _expenseService;
  List<ExpenseModel> _expenses = [];

  ExpenseBloc({required ExpenseService expenseService})
    : _expenseService = expenseService,
      super(ExpenseInitial()) {
    on<ExpenseLoadRequested>(_onExpenseLoadRequested);
    on<ExpenseAddRequested>(_onExpenseAddRequested);
    on<ExpenseUpdateRequested>(_onExpenseUpdateRequested);
    on<ExpenseDeleteRequested>(_onExpenseDeleteRequested);
    on<ExpenseCategoryPredictionRequested>(
      _onExpenseCategoryPredictionRequested,
    );
  }

  Future<void> _onExpenseLoadRequested(
    ExpenseLoadRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final response = await _expenseService.getExpenses(
        startDate: event.startDate,
        endDate: event.endDate,
        category: event.category,
        limit: event.limit ?? 100,
        offset: event.offset ?? 0,
      );
      _expenses = response.expenses;
      emit(
        ExpenseLoaded(
          expenses: response.expenses,
          hasMore: response.expenses.length < response.total,
          total: response.total,
        ),
      );
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onExpenseAddRequested(
    ExpenseAddRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseOperationInProgress(_expenses));
    try {
      final newExpense = await _expenseService.createExpense(event.expense);
      _expenses = [newExpense, ..._expenses];
      emit(
        ExpenseOperationSuccess(
          expenses: _expenses,
          message: 'Expense added successfully',
        ),
      );
      emit(ExpenseLoaded(expenses: _expenses, total: _expenses.length));
    } catch (e) {
      emit(ExpenseError(message: e.toString(), expenses: _expenses));
    }
  }

  Future<void> _onExpenseUpdateRequested(
    ExpenseUpdateRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseOperationInProgress(_expenses));
    try {
      final updatedExpense = await _expenseService.updateExpense(
        event.id,
        event.expense,
      );
      _expenses = _expenses.map((e) {
        return e.id == event.id ? updatedExpense : e;
      }).toList();
      emit(
        ExpenseOperationSuccess(
          expenses: _expenses,
          message: 'Expense updated successfully',
        ),
      );
      emit(ExpenseLoaded(expenses: _expenses, total: _expenses.length));
    } catch (e) {
      emit(ExpenseError(message: e.toString(), expenses: _expenses));
    }
  }

  Future<void> _onExpenseDeleteRequested(
    ExpenseDeleteRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseOperationInProgress(_expenses));
    try {
      await _expenseService.deleteExpense(event.id);
      _expenses = _expenses.where((e) => e.id != event.id).toList();
      emit(
        ExpenseOperationSuccess(
          expenses: _expenses,
          message: 'Expense deleted successfully',
        ),
      );
      emit(ExpenseLoaded(expenses: _expenses, total: _expenses.length));
    } catch (e) {
      emit(ExpenseError(message: e.toString(), expenses: _expenses));
    }
  }

  Future<void> _onExpenseCategoryPredictionRequested(
    ExpenseCategoryPredictionRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final prediction = await _expenseService.predictCategory(
        event.description,
      );
      emit(
        ExpenseCategoryPredicted(prediction: prediction, expenses: _expenses),
      );
    } catch (e) {
      emit(
        ExpenseError(
          message: 'Failed to predict category',
          expenses: _expenses,
        ),
      );
    }
  }
}
