import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // ✅ Add this
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), checkAuth);
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.token);
    log("Stored token: $token");

    if (token == null || token.isEmpty) {
      _goToLogin();
      return;
    }

    final isExpired = JwtDecoder.isExpired(token);
    if (isExpired) {
      log("Token expired. Redirecting to login...");
      await prefs.remove(AppConstants.token);
      _goToLogin();
    } else {
      log("Token valid. Redirecting to home...");
      _goToHome();
    }
  }

  void _goToLogin() {
    AppRouteName.loginPage.pushAndRemoveUntil(context, (route) => false);
  }

  void _goToHome() {
    AppRouteName.homepage.pushAndRemoveUntil(context, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Flupo main page.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
