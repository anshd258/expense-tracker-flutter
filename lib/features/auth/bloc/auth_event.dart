import 'package:equatable/equatable.dart';
import '../../../models/auth_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final LoginRequest loginRequest;

  const AuthLoginRequested(this.loginRequest);

  @override
  List<Object> get props => [loginRequest];
}

class AuthRegisterRequested extends AuthEvent {
  final RegisterRequest registerRequest;

  const AuthRegisterRequested(this.registerRequest);

  @override
  List<Object> get props => [registerRequest];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}