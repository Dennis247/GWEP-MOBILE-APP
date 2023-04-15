// import 'package:RefApp/core/data/dataStore.dart';
// import 'package:flutter/material.dart';
// import 'package:RefApp/core/utils/colors.dart';
// import 'package:RefApp/core/utils/constants.dart';
// import 'package:RefApp/core/utils/navigator.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:sizer/sizer.dart';
// import 'package:provider/provider.dart';

// import '../viewmodel/water_point_viewmodel.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SizedBox(
//         height: 100.0.h,
//         width: 100.0.w,
//         child: Column(
//           children: [
//             Container(
//               height: 23.0.h,
//               width: 100.0.w,
//               color: AppColors.primaryColor,
//               child: Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 4.0.h,
//                       backgroundColor: AppColors.white,
//                       child: Text(
//                         "${DataStore.userAccount?.firstName![0]}",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 4.0.h),
//                       ),
//                     ),
//                     Text(
//                       "${DataStore.userAccount?.firstName} ${DataStore.userAccount?.lastName}",
//                       style: TextStyle(
//                           color: AppColors.white,
//                           fontSize: 3.0.h,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "${DataStore.userAccount?.phoneNumber}",
//                       style: TextStyle(
//                           fontSize: 2.0.h,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                     child: Column(
//                   children: [
//                     _buildDrawerTile(
//                         context: context,
//                         onTap: () {
//                           AppNavigator.pushAndRemoveUntil(
//                               context,
//                               WaterPointMapScreen(
//                                 fullReload: true,
//                               ));
//                         },
//                         iconData: FontAwesomeIcons.mapPin,
//                         title: "Water Detection Points"),
//                     _buildDrawerTile(
//                         context: context,
//                         onTap: () async {
//                           Navigator.of(context).pop();
//                           await context
//                               .read<WaterPointViewModel>()
//                               .syncWaterBodyData();
//                         },
//                         iconData: FontAwesomeIcons.recycle,
//                         title: "Synchronize Data"),
//                     SizedBox(
//                       height: 5.0.h,
//                     ),
//                     _buildDrawerTile(
//                         context: context,
//                         onTap: () async {
//                           Navigator.of(context).pop();
//                           await context.read<LoginViewModel>().logOutUser();

//                           AppNavigator.pushAndRemoveUntil(
//                               context, LoginScreen());
//                         },
//                         iconData: FontAwesomeIcons.arrowRightFromBracket,
//                         color: AppColors.redColor,
//                         title: "Log Out")
//                   ],
//                 )),

//                 // Padding(
//                 //   padding: const EdgeInsets.all(10),
//                 //   child: Consumer<DemoViewModel>(
//                 //     builder: (context, value, child) => Row(
//                 //       children: [
//                 //         Text(
//                 //           "Demo Mode",
//                 //           style: TextStyle(
//                 //               fontWeight: FontWeight.bold,
//                 //               color: AppColors.black),
//                 //         ),
//                 //         Switch(
//                 //             value: DataStore.isDemoModeOn!,
//                 //             onChanged: (val) {
//                 //               value.setDemoMode(val);

//                 //               AppNavigator.pushAndRemoveUntil(
//                 //                   context,
//                 //                   WaterPointMapScreen(
//                 //                     fullReload: true,
//                 //                   ));
//                 //             }),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),

//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: SizedBox(
//                     child: Text(
//                       Constants.appVersion,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }

//   _buildDrawerTile(
//       {required BuildContext context,
//       required String title,
//       required Function onTap,
//       required IconData iconData,
//       Color? color}) {
//     return ListTile(
//       leading: Icon(
//         iconData,
//         color: color ?? AppColors.greyColor,
//         size: 2.8.h,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//             fontWeight: FontWeight.bold, color: color ?? AppColors.black),
//       ),
//       onTap: () {
//         onTap();
//       },
//     );
//   }
// }
