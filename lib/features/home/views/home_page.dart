import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../expenses/views/expenses_page.dart';
import '../../reports/views/reports_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ExpensesPage(),
    ReportsPage(),
  ];

  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.receipt_long, label: 'Expenses'),
    NavItem(icon: Icons.bar_chart, label: 'Reports'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Expense Tracker',
        style: ShadTheme.of(context).textTheme.h4,
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Text(
                      state.user.name,
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    const SizedBox(width: 12),
                    ShadButton.outline(
                      size: ShadButtonSize.sm,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ShadDialog.alert(
                            title: const Text('Logout'),
                            description: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              ShadButton.outline(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ShadButton(
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthLogoutRequested());
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedIndex == index;

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 24,
                          color: isSelected
                              ? ShadTheme.of(context).colorScheme.primary
                              : ShadTheme.of(context)
                                  .colorScheme
                                  .mutedForeground,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                color: isSelected
                                    ? ShadTheme.of(context).colorScheme.primary
                                    : ShadTheme.of(context)
                                        .colorScheme
                                        .mutedForeground,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}