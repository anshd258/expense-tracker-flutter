import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsurge_frontend/features/auth/bloc/auth_state.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/views/login_page.dart';
import 'features/home/views/home_page.dart';
import 'features/reports/bloc/report_bloc.dart';
import 'services/auth_service.dart';
import 'services/dio_client.dart';
import 'services/expense_service.dart';
import 'services/report_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => DioClient()),
        RepositoryProvider(
          create: (context) => AuthService(context.read<DioClient>()),
        ),
        RepositoryProvider(
          create: (context) => ExpenseService(context.read<DioClient>()),
        ),
        RepositoryProvider(
          create: (context) => ReportService(context.read<DioClient>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authService: context.read<AuthService>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => ReportBloc(
              reportService: context.read<ReportService>(),
            ),
          ),
        ],
        child: ShadApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: ThemeMode.system,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const HomePage();
              } else if (state is AuthUnauthenticated || state is AuthError) {
                return const LoginPage();
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
