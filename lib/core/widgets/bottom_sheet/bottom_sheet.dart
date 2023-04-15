import 'package:RefApp/core/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showCustomBottomSheet(
    {required BuildContext context,
    required double height,
    required Widget widget}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: ((context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.h),
              child: Container(
                  height: height,
                  width: 100.0.w,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: widget),
            ),
          )));
}
