import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final Function(ExpenseModel) onEdit;
  final Function(String) onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getCategoryColor(
                  expense.category,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(expense.category),
                color: _getCategoryColor(expense.category),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: ShadTheme.of(context).textTheme.p,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _getCategoryLabel(expense.category),
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontSize: 12,
                          color: ShadTheme.of(
                            context,
                          ).colorScheme.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                          color: ShadTheme.of(
                            context,
                          ).colorScheme.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM d, yyyy').format(expense.date),
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                          fontSize: 12,
                          color: ShadTheme.of(
                            context,
                          ).colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShadButton.outline(
                      size: ShadButtonSize.sm,
                      padding: EdgeInsets.all(8),
                      onPressed: () => _showEditDialog(context),
                      child: const Icon(Icons.edit, size: 20),
                    ),

                    ShadButton.outline(
                      size: ShadButtonSize.sm,
                      padding: EdgeInsets.all(8),
                      onPressed: () => _showDeleteDialog(context),
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: ShadTheme.of(context).colorScheme.destructive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // TODO: Implement edit dialog
    ShadToaster.of(
      context,
    ).show(const ShadToast(title: Text('Edit functionality coming soon')));
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ShadDialog.alert(
        title: const Text('Delete Expense'),
        description: Text(
          'Are you sure you want to delete "${expense.description}"?',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton(
            onPressed: () {
              onDelete(expense.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.shopping:
        return Colors.pink;
      case ExpenseCategory.entertainment:
        return Colors.purple;
      case ExpenseCategory.utilities:
        return Colors.grey;
      case ExpenseCategory.healthcare:
        return Colors.red;

      case ExpenseCategory.other:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.utilities:
        return Icons.home;
      case ExpenseCategory.healthcare:
        return Icons.medical_services;

      case ExpenseCategory.other:
        return Icons.category;
    }
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
