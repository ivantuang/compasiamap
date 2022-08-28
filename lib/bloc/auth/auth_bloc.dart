import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compasiamap/repositories/auth/auth_repository.dart';
import 'package:compasiamap/enums.dart';
import 'package:compasiamap/args/login_request.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
   required IAuthRepository authRepo,
  }) : _authRepo = authRepo,
       super(const AuthState()) {
    on<LoginWithEmail>(_onLoginWithEmail);
    on<AuthStatusChanged>(_authStatusChanged);

    _authRepo.status.listen((status) => add(AuthStatusChanged(status)));
    _authRepo.msg.listen((msg) => this.msg = msg);
  }

  final IAuthRepository _authRepo;
  late String msg = '';

  @override
  Future<void> close() {
    _authRepo.dispose();
    return super.close();
  }

  void _onLoginWithEmail(LoginWithEmail event, Emitter<AuthState> emit) async {
    try {
      await _authRepo.login(event.loginRequest);
    } catch (e) {
      emit(AuthState.failed(msg: msg));
    }
  }

  void _authStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) async {
    switch (event.authStatus) {
      case AuthStatus.success:
        emit(AuthState.success(msg: msg));
        break;
      case AuthStatus.failed:
        emit(AuthState.failed(msg: msg));
        break;
      default:
        emit(const AuthState.initial());
        break;
    }
    emit(const AuthState.initial());
  }
}