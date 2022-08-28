part of 'auth_bloc.dart';

class AuthState extends Equatable {

  final AuthStatus status;
  final String? msg;

  const AuthState({
    this.status = AuthStatus.initial,
    this.msg = ''
  });

  const AuthState.initial() : this();
  const AuthState.success({String? msg}) : this(status: AuthStatus.success, msg: msg);
  const AuthState.failed({String? msg}) : this(status: AuthStatus.failed, msg: msg);

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}