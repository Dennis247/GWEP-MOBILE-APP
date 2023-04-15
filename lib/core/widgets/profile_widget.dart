import 'package:RefApp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:RefApp/core/utils/colors.dart';
import 'package:sizer/sizer.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
    required this.subTitle,
    required this.title,
    required this.isPending,
    required this.onTap,
  }) : super(key: key);

  final String subTitle;
  final String title;
  final bool isPending;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
          width: 100.0.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isPending
                      ? AppColors.primaryColor
                      : AppColors.grayDefault,
                  width: 1.5)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subTitle,
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 1.8.h,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: AppColors.greyColor, fontSize: 1.7.h),
                      ),
                    ],
                  ),
                  onTap != null
                      ? Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.greyColor,
                          size: 2.2.h,
                        )
                      : const SizedBox()
                ],
              ))),
    );
  }
}
