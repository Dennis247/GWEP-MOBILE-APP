import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff4641D7);
  static const Color lightBlue = Color(0xffedecff);
  static const Color dashPurple = Color(0xff7907a1);
  static const Color dashBlack = Color(0xff141210);
  static const Color green = Color(0xff27ae60);
  static const Color greendash = Color(0xff6fcf97);
  static const Color greenLight = Color(0xffebfff3);

  static const Color redColor = Colors.red;
  // static const Color borderColor = Colors.grey;
  static const Color disabledBorderColor = Colors.grey;
  static const Color grayLight = Color(0xffE9EBEC);
  static const Color borderColor = Color(0xfffafafa);

  static const Color greyColor = Color(0xff828282);
  static const Color greyColor2 = Color(0xff4F4F4F);
  static const Color greyColor3 = Color(0xff828282);

  static const Color labelColor = Color(0xffbdbdbd);

  static const Color grayDarker = Color(0xff787A7D);
  //static const Color grayDarker = Color(0xff6F7174);

  static const Color grayDefault = Color(0xffC8CCD0);
  static const Color grayDark = Color(0xffA0A3A6);

  static const Color grayLighter = Color(0xffDEE0E3);
  static const Color grayLightest2 = Color(0xffE9EBEC);
  static const Color grayLightest1 = Color(0xffF4F5F6);

  // white
  static const Color whiteShade = Color(0xffF5FAFF);
  static const Color white = Colors.white;

  // black
  static const Color blackShade2 = Color(0xff000A14);
  static const Color blackShade1 = Color(0xff00050A);
  static const Color black = Colors.black;
  static const Color blackShade3 = Color(0xff212529);
  static const Color shadow = Color.fromARGB(255, 209, 209, 209);

  static List<BoxShadow> kShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    )
  ];

  // success
  static const Color successDefault = Color(0xff3CC13B);
  static const Color successLight = Color(0xffE8F8E8);

  // error
  static const Color errorDefault = Color(0xffF03738);
  static const Color errorLight = Color(0xffFEECEC);

  // warning
  static const Color warningDefault = Color(0xffF3BB1C);

  static const linearGradient = LinearGradient(colors: [
    Color(0xff0080FF),
    Color(0xff4361C6),
    Color(0xffA05F9B),
    Color(0xffFF5065),
  ]);

  // savings
  static const kolosave = Color.fromARGB(255, 40, 112, 4);
  static const targetSavings = Color(0xff8114B8);
}
