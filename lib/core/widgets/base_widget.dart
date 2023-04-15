// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:RefApp/core/utils/navigator.dart';
// import 'package:navigator_map/data/dataStore.dart';
// import 'package:navigator_map/ui/widgets/app_drawer.dart';
// import 'package:navigator_map/ui/widgets/select_item_widget.dart';
// import 'package:sizer/sizer.dart';

// class BaseWidget extends StatelessWidget {
//   final String appBarTitle;
//   final Widget widget;
//   final Widget? fabWidget;

//   const BaseWidget(
//       {super.key,
//       required this.appBarTitle,
//       required this.widget,
//       this.fabWidget});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: AppDrawer(),
//         body: OfflineBuilder(
//           connectivityBuilder: (
//             BuildContext context,
//             ConnectivityResult connectivity,
//             Widget child,
//           ) {
//             //todo  perform operation based on online and offline status
//             DataStore.isOffline = connectivity == ConnectivityResult.none;

//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Positioned(
//                   height: 100.0.h,
//                   left: 0.0,
//                   right: 0.0,
//                   child: Column(
//                     children: [
//                       Container(
//                         color: !DataStore.isOffline
//                             ? Color(0xFF00EE44)
//                             : Color(0xFFEE4400),
//                         child: Center(
//                           child: Text(
//                             "${!DataStore.isOffline ? 'ONLINE' : 'OFFLINE'}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 1.5.h),
//                           ),
//                         ),
//                       ),
//                       AppBar(
//                         title: Text(
//                           appBarTitle,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 2.0.h),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 0.0.w, right: 0.0.w, top: 0.0.h),
//                             child: widget),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               new Text(
//                 'There are no bottons to push :)',
//               ),
//               new Text(
//                 'Just turn off your internet.',
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: fabWidget,
//       ),
//     );
//   }
// }
