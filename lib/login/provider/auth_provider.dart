import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/login/data/user_modal.dart';
import 'package:firebase_login/login/provider/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authNotifierProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthProvider(authService);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService(FirebaseAuth.instance);
});

class AuthState {
  final User? user;
  final String? error;

  const AuthState(this.user, this.error);

  factory AuthState.initial() => const AuthState(null, null);

  factory AuthState.authenticated(User user) => AuthState(user, null);

  factory AuthState.error(String error) => AuthState(null, error);

  AuthState copyWith({
    User? user,
    String? error,
  }) {
    return AuthState(user ?? this.user, error ?? this.error);
  }

  T when<T>({
    required T Function() initial,
    required T Function(User) authenticated,
    required T Function(String) error,
  }) {
    if (user != null) {
      return authenticated(user!);
    } else if (this.error != null) {
      return error(this.error as String);
    } else {
      return initial();
    }
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthProvider(this.authService) : super(AuthState.initial());

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential != null) {
        final user = userCredential;

        state = AuthState.authenticated(user);
        // Save the authentication state
        final preferences = await SharedPreferences.getInstance();
        preferences.setBool('isAuthenticated', true);
        final userModal = UserModal.fromFirebase(user);
        await preferences.setString('user', jsonEncode(userModal.toMap()));
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> onSignOut() async {
    await authService.signOut();
    state = AuthState.initial();
  }
}
