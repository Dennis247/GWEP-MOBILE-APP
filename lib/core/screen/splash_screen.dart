import 'dart:async';
import 'dart:convert';

import 'package:RefApp/core/data/dataStore.dart';
import 'package:RefApp/core/model/account_data.dart';
import 'package:RefApp/core/utils/colors.dart';
import 'package:RefApp/core/utils/navigator.dart';
import 'package:RefApp/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

import '../utils/constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String navRoute = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    doAutoLogin();
    super.initState();
  }

  Future<void> doAutoLogin() async {
    try {
      //   final loginVM = context.read<LoginViewModel>();

      var pref = await SecureSharedPref.getInstance();

      String? userDetails =
          await pref.getString(Constants.userDetails, isEncrypted: true);
      if (userDetails == null) {
        if (!mounted) return;

        AppNavigator.to(context, const LoginScreen());
      } else {
        await Future.delayed(const Duration(seconds: 3));
        var userData = jsonDecode(userDetails);
        DataStore.userAccount = Account.fromJson(userData);

        AppNavigator.pushAndRemoveUntil(context, LandingScreen());
      }
    } catch (e) {
      AppNavigator.to(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 15.0.h,
              ),
              SizedBox(
                height: 2.0.h,
              ),
              Center(
                child: Text(
                  "GWEP Navigator",
                  style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 3.0.h,
                      letterSpacing: 2),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
