// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:RefApp/core/data/dataStore.dart';
import 'package:RefApp/core/model/account_data.dart';
import 'package:RefApp/core/screen/register_screen.dart';
import 'package:RefApp/core/utils/colors.dart';
import 'package:RefApp/core/utils/constants.dart';
import 'package:RefApp/core/utils/helpers.dart';
import 'package:RefApp/core/utils/navigator.dart';
import 'package:RefApp/core/viewmodel/login_viewmodel.dart';
import 'package:RefApp/core/widgets/app_button.dart';
import 'package:RefApp/core/widgets/text_input_widget.dart';
import 'package:RefApp/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';
import '../widgets/bottom_sheet/status_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  late final _phoneNumberFieldFocus = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  final _formKey = GlobalKey<FormState>();

  void _loginUser() async {
    //todo local login
    var pref = await SecureSharedPref.getInstance();
    String? userDetails =
        await pref.getString(Constants.userDetails, isEncrypted: true);

    String phone = _phoneNumberController.text.trim();
    if (userDetails != null) {
      var userData = jsonDecode(userDetails);
      DataStore.userAccount = Account.fromJson(userData);
      if (DataStore.userAccount?.phoneNumber!.trim() == phone) {
        AppNavigator.pushAndRemoveUntil(context, LandingScreen());
      } else {
        await _onlineLogin();
      }
    } else {
      await _onlineLogin();
    }
  }

  _onlineLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginVM = context.read<LoginViewModel>();
      var response = await loginVM.loginUser(
          phoneNumber: _phoneNumberController.text.trim());
      if (!mounted) return;
      if (response.succeeded) {
        //store data in shared prerefence
        var pref = await SecureSharedPref.getInstance();

        var userData = jsonEncode(response.data);
        pref.putString(Constants.userDetails, userData, isEncrypted: true);
        DataStore.userAccount = Account.fromJson(response.data);

        AppNavigator.pushAndRemoveUntil(context, LandingScreen());
      } else {
        showStatusBottomSheet(context, isDismissible: true, isSUcessful: false,
            onButtonClick: () {
          Navigator.of(context).pop();
        }, subtitle: response.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox(
            height: 100.0.h,
            width: 100.0.w,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 100.0.h,
                    width: 100.0.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/white_bg.png"),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                Container(
                  height: 57.h,
                )
              ],
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        height: 50.0.h,
                        width: 100.0.w,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white10,

                                //add more colors for gradient
                              ],
                              begin: Alignment
                                  .bottomCenter, //begin of the gradient color
                              end: Alignment
                                  .topCenter, //end of the gradient color
                              stops: [
                                0.05,
                                0.95,
                              ] //stops for individual color
                              //set the stops number equal to numbers of color
                              ),
                        ))),
                Container(
                  height: 60.0.h,
                  width: 100.0.w,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    child: Consumer<LoginViewModel>(
                      builder: (context, loginVM, child) => Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 3.0.h),
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              Text(
                                "Please enter your phone number",
                                style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 1.7.h),
                              ),
                              SizedBox(
                                height: 5.5.h,
                              ),
                              CustomTextField(
                                // hintText: "Phone number",
                                lableText: "Phone number",

                                filled: true,

                                // prefix: Text(
                                //   "0 - ",
                                //   style: TextStyle(color: AppColors.grayDefault),
                                // ),

                                maxLines: 1,
                                // inputLimit: 11,
                                validator: (value) {
                                  return Helpers.validateString(
                                      value: value!, fieldnAme: 'phone number');
                                },
                                focusNode: _phoneNumberFieldFocus,
                                textEditingController: _phoneNumberController,
                                textInputType: TextInputType.phone,
                                fillColor: _phoneNumberFieldFocus.hasFocus
                                    ? AppColors.white
                                    : AppColors.borderColor,
                                prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: SvgPicture.asset(
                                      'assets/images/phone.svg',
                                      height: 2.5.h,
                                    )),
                              ),
                              SizedBox(
                                height: 4.5.h,
                              ),
                              AppButton(
                                  title: "Submit",
                                  isLoading: loginVM.isLoading,
                                  onTap: () {
                                    _loginUser();
                                  }),
                              SizedBox(
                                height: 3.5.h,
                              ),
                              InkWell(
                                onTap: () {
                                  AppNavigator.to(context, RegisterScreen());
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 4.5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
