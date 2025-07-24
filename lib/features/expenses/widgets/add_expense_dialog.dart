import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/expense_model.dart';

class AddExpenseDialog extends StatefulWidget {
  final Function(ExpenseModel) onExpenseAdded;

  const AddExpenseDialog({
    super.key,
    required this.onExpenseAdded,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ExpenseCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final expense = ExpenseModel(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        category: _selectedCategory!,
        date: _selectedDate,
      );
      widget.onExpenseAdded(expense);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Add Expense'),
      description: const Text('Enter the details of your expense'),
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShadInputFormField(
              controller: _amountController,
              placeholder: const Text('Amount'),
              prefix: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('\$'),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Amount is required';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              controller: _descriptionController,
              placeholder: const Text('Description'),
              onChanged: (value) {
              
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadSelectFormField<ExpenseCategory>(
              placeholder: const Text('Select Category'),
              options: ExpenseCategory.values
                  .map(
                    (category) => ShadOption(
                      value: category,
                      child: Row(
                        children: [
                          Icon(
                            _getCategoryIcon(category),
                            size: 16,
                            color: _getCategoryColor(category),
                          ),
                          const SizedBox(width: 8),
                          Text(_getCategoryLabel(category)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) {
                return Row(
                  children: [
                    Icon(
                      _getCategoryIcon(value),
                      size: 16,
                      color: _getCategoryColor(value),
                    ),
                    const SizedBox(width: 8),
                    Text(_getCategoryLabel(value)),
                  ],
                );
              },
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadButton.outline(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMMM d, yyyy').format(_selectedDate)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ShadButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add Expense'),
                ),
              ],
            ),
          ],
        ),
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
        return 'FOOD';
      case ExpenseCategory.transport:
        return 'TRANSPORT';
      case ExpenseCategory.shopping:
        return 'SHOPPING';
      case ExpenseCategory.entertainment:
        return 'ENTERTAINMENT';
      case ExpenseCategory.utilities:
        return 'UTILITIES';
      case ExpenseCategory.healthcare:
        return 'HEALTHCARE';
      case ExpenseCategory.other:
        return 'OTHER';
    }
  }
}