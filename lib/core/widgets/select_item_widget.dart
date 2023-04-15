import 'package:RefApp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectItemWidget extends StatelessWidget {
  const SelectItemWidget({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      //  behavior: HitTestBehavior.translucent,
      child: Container(
          width: 100.0.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isSelected ? AppColors.primaryColor : AppColors.grayLight,
                  width: 1.5)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 2.0.w,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 1.8.h),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.3.h,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.greyColor,
                    size: 1.8.h,
                  )
                ],
              ))),
    );
  }
}

class SelectItemWidget2 extends StatelessWidget {
  const SelectItemWidget2({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      //  behavior: HitTestBehavior.translucent,
      child: Container(
          width: 100.0.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color:
                      isSelected ? AppColors.primaryColor : AppColors.grayLight,
                  width: 1.5)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 2.0.w,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 1.5.h),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.3.h,
                  ),
                ],
              ))),
    );
  }
}
