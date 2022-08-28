import 'dart:async';
import 'package:compasiamap/enums.dart';
import 'package:compasiamap/args/login_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'i_auth_repository.dart';

class AuthRepository implements IAuthRepository {

  final _statusController = StreamController<AuthStatus>();
  final _msgController = StreamController<String>();

  @override
  void dispose() {
    // TODO: implement dispose
    _statusController.close();
    _msgController.close();
  }

  @override
  Future<void> login(LoginRequest loginRequest) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginRequest.email,
          password: loginRequest.password
      );

      if (credential.user != null) {
        _statusController.add(AuthStatus.success);
        _msgController.add('Login success');
      }

    } on FirebaseAuthException catch (e) {
      _statusController.add(AuthStatus.failed);

      if (e.code == 'user-not-found') {
        _msgController.add('No user found for that email');

      } else if (e.code == 'wrong-password') {
        _msgController.add('Wrong password provided for that user');
      }
    }
  }

  @override
  // TODO: implement status
  Stream<AuthStatus> get status async* {
    yield* _statusController.stream;
  }
  @override
  // TODO: implement msg
  Stream<String> get msg async* {
    yield* _msgController.stream;
  }
}