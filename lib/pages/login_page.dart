import 'package:compasiamap/bloc/auth/auth_bloc.dart';
import 'package:compasiamap/args/login_request.dart';
import 'package:compasiamap/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: BlocProvider(
        create: (_) => AuthBloc(authRepo: GetIt.I()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state != const AuthState.initial()) {
                      emailController.text = '';
                      passwordController.text = '';
                    }

                    if (state == const AuthState.success()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapPage()),
                      );
                      return;
                    }

                    if (state.msg != null && state.msg != '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.msg!),
                          )
                      );
                    }
                  },
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              border: UnderlineInputBorder()
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text?.isEmpty == true) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5.0,),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                              hintText: 'Password',
                              border: UnderlineInputBorder()
                          ),
                          obscureText: true,
                          validator: (text) {
                            if (text?.isEmpty == true) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0,),
                        ElevatedButton(onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthBloc>().add(
                                LoginWithEmail(
                                    LoginRequest(
                                        email: emailController.text,
                                        password: passwordController.text))
                            );
                          }
                        }, child: const Text('Submit'))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}