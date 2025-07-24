import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/auth_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<ShadFormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.saveAndValidate()) {
      final loginRequest = LoginRequest(
        email: _emailController.text,
        password: _passwordController.text,
      );
      context.read<AuthBloc>().add(AuthLoginRequested(loginRequest));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: ShadForm(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back',
                  style: ShadTheme.of(context).textTheme.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your expense tracker account',
                  style: ShadTheme.of(context).textTheme.muted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ShadInputFormField(
                  controller: _emailController,
                  placeholder: const Text('Email'),
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.email_outlined, size: 16),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ShadInputFormField(
                  controller: _passwordController,
                  placeholder: const Text('Password'),
                  obscureText: true,
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.lock_outline, size: 16),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ShadToaster.of(context).show(
                        ShadToast.destructive(
                          title: const Text('Login Failed'),
                          description: Text(state.message),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ShadButton(
                      onPressed: state is AuthLoading ? null : _handleLogin,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    ShadButton.link(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}