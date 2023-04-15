import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../app_button.dart';

// class showBottonSheet {
//   Future<void> showBottomSheet() {
//     // example bottomSheet
//     OneContext().showBottomSheet(
//       builder: (context) => Container(
//         alignment: Alignment.topCenter,
//         height: 200,
//         child: IconButton(
//             icon: Icon(Icons.arrow_drop_down),
//             iconSize: 50,
//             color: Colors.white,
//             onPressed: () => Navigator.of(context)
//                 .pop('sucess')), // or OneContext().popDialog('sucess');
//       ),
//     );
//   }
// }

Future<void> showStatusBottomSheet(
  BuildContext context, {
  required String subtitle,
  required Function onButtonClick,
  required bool isSUcessful,
  required bool isDismissible,
}) {
  return showBlurBarrierBottomSheet(
    context: context,
    isDismissible: isDismissible,
    child: _Body(
      subtitle: subtitle,
      onButtonClick: onButtonClick,
      isSUcessful: isSUcessful,
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.subtitle,
    required this.onButtonClick,
    required this.isSUcessful,
  }) : super(key: key);

  final String subtitle;
  final bool isSUcessful;
  final Function onButtonClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5.5.h),
        SvgPicture.asset(
          isSUcessful ? 'assets/images/success.svg' : 'assets/images/error.svg',
          height: 11.3.h,
          width: 24.5.w,
        ),
        SizedBox(height: 3.9.h),
        Text(
          isSUcessful ? Constants.sucessfulStatus : Constants.failedStatus,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 2.5.h, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 1.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 1.8.h,
                fontWeight: FontWeight.bold,
                color: AppColors.grayDark,
              ),
        ),
        SizedBox(height: 4.9.h),
        AppButton(
          title: 'OK',
          onTap: onButtonClick,
        ),
      ],
    );
  }
}

Future<dynamic> showBlurBarrierBottomSheet({
  required BuildContext context,
  required bool isDismissible,
  required Widget child,
  bool enableDrag = true,
  bool transparent = false,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SafeArea(
        child: SingleChildScrollView(
          //padding: EdgeInsets.,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 2.h,
              right: 5.3.w,
              left: 5.3.w,
              bottom: 3.9.h,
            ),
            decoration: BoxDecoration(
              color: transparent ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
