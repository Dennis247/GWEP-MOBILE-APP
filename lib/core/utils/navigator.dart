import 'package:flutter/cupertino.dart';

class AppNavigator {
  static void to(BuildContext context, Widget nextScreen) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => nextScreen));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget nextScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => nextScreen,
      ),
      (Route<dynamic> route) => false,
    );
  }
}
