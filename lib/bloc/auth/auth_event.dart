part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithEmail extends AuthEvent {

  final LoginRequest loginRequest;

  const LoginWithEmail(this.loginRequest);

  @override
  List<Object?> get props => [loginRequest];
}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus authStatus;

  const AuthStatusChanged(this.authStatus);

  @override
  List<Object?> get props => [authStatus];
}