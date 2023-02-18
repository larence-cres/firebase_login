import 'package:firebase_login/extensions/size_extension.dart';
import 'package:firebase_login/home/home_page.dart';
import 'package:firebase_login/login/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: state.when(
          initial: () => buildLoginButton(context, ref),
          authenticated: (_) => _navigateToHome(context),
          error: (message) => Text(message),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: context.heightPercent(7),
      child: SignInButton(
        Buttons.Google,
        onPressed: () async {
          final authNotifier = ref.read(authNotifierProvider.notifier);
          await authNotifier.signInWithGoogle();
        },
      ),
    );
  }

  _navigateToHome(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }
}
