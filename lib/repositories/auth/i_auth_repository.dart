part of 'auth_repository.dart';

abstract class IAuthRepository {
  Stream<AuthStatus> get status;
  Stream<String> get msg;

  Future<void> login(LoginRequest loginRequest);

  void dispose();
}