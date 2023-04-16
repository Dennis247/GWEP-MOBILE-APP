// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:RefApp/core/utils/constants.dart';
import 'package:RefApp/core/utils/navigator.dart';
import 'package:RefApp/core/viewmodel/register_viewmodel.dart';
import 'package:RefApp/core/widgets/text_input_widget.dart';
import 'package:RefApp/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

import '../data/dataStore.dart';
import '../model/account_data.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../widgets/app_button.dart';
import '../widgets/bottom_sheet/global_dialogue.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  late final _phoneNumberFieldFocus = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  TextEditingController _firstNameController = TextEditingController();
  late final _firstNameFieldFocus = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  TextEditingController _lastNameController = TextEditingController();
  late final _lastNameFieldFocus = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    String phone = _phoneNumberController.text.trim();

    if (_formKey.currentState!.validate()) {
      final registerVM = context.read<RegisterViewModel>();
      var response = await registerVM.registerUser(
          phoneNumber: _phoneNumberController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim());
      if (!mounted) return;
      if (response.succeeded) {
        //store value in shared pref

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
                    height: 70.0.h,
                    width: 100.0.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/white_bg.png"),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                SizedBox(
                  height: 30.0.h,
                ),
              ],
            ),
          ),
          SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 30.0.h,
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
                            end:
                                Alignment.topCenter, //end of the gradient color
                            stops: [
                              0.05,
                              0.95,
                            ] //stops for individual color
                            //set the stops number equal to numbers of color
                            ),
                      )),
                  Container(
                    height: 70.0.h,
                    width: 100.0.w,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: Consumer<RegisterViewModel>(
                        builder: (context, regVM, child) => Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                Text(
                                  "Register",
                                  style: GoogleFonts.poppins(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 3.0.h),
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                  "Please enter your details to register",
                                  style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 1.7.h),
                                ),
                                SizedBox(
                                  height: 5.5.h,
                                ),
                                CustomTextField(
                                  lableText: "Phone number",
                                  filled: true,
                                  maxLines: 1,
                                  //    inputLimit: 11,
                                  validator: (value) {
                                    return Helpers.validateString(
                                        value: value!,
                                        fieldnAme: 'phone number');
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
                                  height: 2.0.h,
                                ),
                                CustomTextField(
                                  lableText: "First name",
                                  filled: true,
                                  maxLines: 1,
                                  //   inputLimit: 11,
                                  validator: (value) {
                                    return Helpers.validateString(
                                        value: value!, fieldnAme: 'first name');
                                  },
                                  focusNode: _firstNameFieldFocus,
                                  textEditingController: _firstNameController,
                                  textInputType: TextInputType.text,

                                  fillColor: _firstNameFieldFocus.hasFocus
                                      ? AppColors.white
                                      : AppColors.borderColor,
                                  prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        FontAwesomeIcons.user,
                                        color: AppColors.grayDefault,
                                      )),
                                ),
                                SizedBox(
                                  height: 2.0.h,
                                ),
                                CustomTextField(
                                  lableText: "Last name",
                                  filled: true,
                                  maxLines: 1,
                                  //   inputLimit: 11,
                                  validator: (value) {
                                    return Helpers.validateString(
                                        value: value!, fieldnAme: 'last name');
                                  },
                                  focusNode: _lastNameFieldFocus,
                                  textEditingController: _lastNameController,
                                  textInputType: TextInputType.text,
                                  fillColor: _lastNameFieldFocus.hasFocus
                                      ? AppColors.white
                                      : AppColors.borderColor,
                                  prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        FontAwesomeIcons.user,
                                        color: AppColors.grayDefault,
                                      )),
                                ),
                                SizedBox(
                                  height: 3.5.h,
                                ),
                                AppButton(
                                    title: "Submit",
                                    isLoading: regVM.isLoading,
                                    onTap: () {
                                      _register();
                                    }),
                                SizedBox(
                                  height: 3.5.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.5.h,
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
            ),
          )
        ],
      )),
    );
  }
}
