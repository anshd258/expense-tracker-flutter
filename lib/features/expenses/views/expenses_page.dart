import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';

import '../../../models/expense_model.dart';
import '../../../services/expense_service.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/expense_card.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpenseBloc(expenseService: context.read<ExpenseService>())
            ..add(const ExpenseLoadRequested()),
      child: const ExpensesView(),
    );
  }
}

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  String? _selectedCategory;
  DateTimeRange? _selectedDateRange;

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AddExpenseDialog(
        onExpenseAdded: (expense) {
          context.read<ExpenseBloc>().add(ExpenseAddRequested(expense));
        },
      ),
    );
  }

  void _applyFilters() {
    context.read<ExpenseBloc>().add(
      ExpenseLoadRequested(
        category: _selectedCategory != "All Categories"
            ? ExpenseCategory.values.firstWhere(
                (element) => element.name == _selectedCategory,
              )
            : null,
        startDate: _selectedDateRange?.start,
        endDate: _selectedDateRange?.end,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ExpenseError && state.expenses == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                        const SizedBox(height: 16),
                        ShadButton(
                          onPressed: _applyFilters,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final expenses = _getExpenses(state);
                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses found',
                          style: ShadTheme.of(context).textTheme.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first expense to get started',
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ExpenseBloc>().add(
                      ExpenseLoadRequested(
                        category: _selectedCategory != "All Categories"
                            ? ExpenseCategory.values.firstWhere(
                                (element) => element.name == _selectedCategory,
                              )
                            : null,
                        startDate: _selectedDateRange?.start,
                        endDate: _selectedDateRange?.end,
                      ),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: expenses.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        if (state is ExpenseLoaded) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Total expenses: ${state.total}',
                              style: ShadTheme.of(context).textTheme.h4,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      final expense = expenses[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExpenseCard(
                          expense: expense,
                          onEdit: (expense) {
                            context.read<ExpenseBloc>().add(
                              ExpenseUpdateRequested(expense.id!, expense),
                            );
                          },
                          onDelete: (id) {
                            context.read<ExpenseBloc>().add(
                              ExpenseDeleteRequested(id),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        backgroundColor: ShadTheme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadSelect<String>(
              placeholder: const Text('All Categories'),
              options: [
                const ShadOption(
                  value: "All Categories",
                  child: Text('All Categories'),
                ),
                ...ExpenseCategory.values.map(
                  (category) => ShadOption(
                    value: category.name,
                    child: Text(_getCategoryLabel(category)),
                  ),
                ),
              ],
              selectedOptionBuilder: (context, value) {
                return Text(
                  value == "All Categories"
                      ? 'All Categories'
                      : _getCategoryLabel(
                          ExpenseCategory.values.firstWhere(
                            (element) => element.name == value,
                          ),
                        ),
                );
              },
              onChanged: (value) {
                setState(() => _selectedCategory = value);
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: 12),
          ShadButton.outline(
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _selectedDateRange,
              );
              if (range != null) {
                setState(() => _selectedDateRange = range);
                _applyFilters();
              }
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  _selectedDateRange == null
                      ? 'Date Range'
                      : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                ),
              ],
            ),
          ),
          if (_selectedCategory != null || _selectedDateRange != null) ...[
            const SizedBox(width: 8),
            ShadButton.ghost(
              size: ShadButtonSize.sm,
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedDateRange = null;
                });
                _applyFilters();
              },
              child: const Icon(Icons.clear, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  List<ExpenseModel> _getExpenses(ExpenseState state) {
    if (state is ExpenseLoaded) return state.expenses;
    if (state is ExpenseOperationSuccess) return state.expenses;
    if (state is ExpenseOperationInProgress) return state.expenses;
    if (state is ExpenseError && state.expenses != null) return state.expenses!;
    if (state is ExpenseCategoryPredicted) return state.expenses;
    return [];
  }

  String _getCategoryLabel(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.healthcare:
        return 'Healthcare';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}
