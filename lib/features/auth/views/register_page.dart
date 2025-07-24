import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../models/auth_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.saveAndValidate()) {
      final registerRequest = RegisterRequest(
        full_name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      context.read<AuthBloc>().add(AuthRegisterRequested(registerRequest));
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
                  'Create Account',
                  style: ShadTheme.of(context).textTheme.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your expenses today',
                  style: ShadTheme.of(context).textTheme.muted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ShadInputFormField(
                  controller: _nameController,
                  placeholder: const Text('Full Name'),
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.person_outline, size: 16),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ShadInputFormField(
                  controller: _confirmPasswordController,
                  placeholder: const Text('Confirm Password'),
                  obscureText: true,
                  prefix: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.lock_outline, size: 16),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
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
                          title: const Text('Registration Failed'),
                          description: Text(state.message),
                        ),
                      );
                    } else if (state is AuthAuthenticated) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  builder: (context, state) {
                    return ShadButton(
                      onPressed: state is AuthLoading ? null : _handleRegister,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Register'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    ShadButton.link(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
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