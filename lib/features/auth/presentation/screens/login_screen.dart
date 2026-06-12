import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      context.read<AuthBloc>().add(
        LoginSubmitted(username: username, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF00E676).withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E676).withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.go('/dashboard');
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    backgroundColor: Colors.red.shade900,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.terminal,
                    size: 48,
                    color: Color(0xFF00E676),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SYSTEM ACCESS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Admin ID',
                      labelStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E676)),
                      ),
                      prefixIcon: Icon(
                        Icons.shield_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Passphrase',
                      labelStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E676)),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: state is AuthLoading ? null : _onLoginPressed,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'INITIALIZE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
