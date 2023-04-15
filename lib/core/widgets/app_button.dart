import 'package:RefApp/core/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;

  final Function onTap;
  final Color buttonColor;
  final bool isDisabled;
  final Color disabledColor;
  final bool isLoading;
  final TextStyle? textStyle;

  const AppButton({
    Key? key,
    required this.title,
    this.width,
    required this.onTap,
    this.isDisabled = false,
    this.disabledColor = const Color(0xffe6eefc),
    this.buttonColor = const Color(0xff1152FD),
    this.isLoading = false,
    this.height,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: isDisabled ? AppColors.grayLightest2 : AppColors.primaryColor,
      minWidth: width ?? 90.0.w,
      height: height ?? 6.5.h,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () {
        if (!isDisabled) {
          if (!isLoading) {
            onTap();
          }
        }
      },
      child: isLoading
          ? SizedBox(
              height: 3.2.h,
              width: 3.2.h,
              child: const CircularProgressIndicator(
                color: AppColors.white,
                backgroundColor: AppColors.primaryColor,
                semanticsLabel: "loading...",
              ),
            )
          : Text(
              title,
              style: isDisabled
                  ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayDark,
                      fontSize: 2.0.h)
                  : Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 2.0.h),
            ),
    );
  }
}
