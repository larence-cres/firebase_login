import 'dart:convert';

import 'package:firebase_login/extensions/size_extension.dart';
import 'package:firebase_login/login/data/user_modal.dart';
import 'package:firebase_login/login/presentation/login_page.dart';
import 'package:firebase_login/login/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final getUserProvider = FutureProvider<UserModal?>((ref) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModal.fromMap(jsonMap);
    }
    return null;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(getUserProvider).value;
          if (user != null) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: context.heightPercent(8),
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(user.photoUrl!),
                  ),
                  SizedBox(
                    height: context.heightPercent(8),
                  ),
                  Text(
                    user.displayName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: context.heightPercent(2),
                  ),
                  Text(
                    user.email!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: context.heightPercent(10),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _signOut(context, ref);
                      _navigateToLogin(context);
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No user data'),
            );
          }
        },
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authNotifierProvider.notifier);
    await auth.onSignOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('user');
  }

  _navigateToLogin(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }
}
