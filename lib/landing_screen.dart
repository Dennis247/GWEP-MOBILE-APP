/*
 * Copyright (C) 2020-2023 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:RefApp/common/file_utility.dart';
import 'package:RefApp/core/model/abate_details.dart';
import 'package:RefApp/core/utils/custom_map_styles.dart';
import 'package:RefApp/core/utils/navigator.dart';
import 'package:RefApp/core/widgets/loading_indicator.dart';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:here_sdk/consent.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/location.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'common/application_preferences.dart';
import 'common/custom_map_style_settings.dart';
import 'common/load_custom_style_result_popup.dart';
import 'common/place_actions_popup.dart';
import 'common/reset_location_button.dart';
import 'common/ui_style.dart';
import 'common/util.dart' as Util;
import 'core/data/dataStore.dart';
import 'core/model/water_body_points.dart';
import 'core/screen/login_screen.dart';
import 'core/utils/colors.dart';
import 'core/utils/constants.dart';
import 'core/viewmodel/login_viewmodel.dart';
import 'core/viewmodel/water_point_viewmodel.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_drawer.dart';
import 'core/widgets/bottom_sheet.dart';
import 'core/widgets/bottom_sheet/global_dialogue.dart';
import 'core/widgets/bottom_sheet/search_bottom_sheet.dart';
import 'core/widgets/select_item_widget.dart';
import 'download_maps/download_maps_screen.dart';
import 'download_maps/map_loader_controller.dart';
import 'positioning/no_location_warning_widget.dart';
import 'positioning/positioning.dart';
import 'positioning/positioning_engine.dart';
import 'routing/routing_screen.dart';
import 'routing/waypoint_info.dart';
import 'search/search_popup.dart';

/// The home screen of the application.
class LandingScreen extends StatefulWidget {
  static const String navRoute = "landing-screen";

  LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with Positioning {
  static const int _kLocationWarningDismissPeriod = 5; // seconds
  static const int _kLoadCustomStyleResultPopupDismissPeriod = 5; // seconds

  final GlobalKey<AnimatedFloatingActionButtonState> fabKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  bool _mapInitSuccess = false;
  late HereMapController _hereMapController;
  GlobalKey _hereMapKey = GlobalKey();
  OverlayEntry? _locationWarningOverlay;
  OverlayEntry? _loadCustomSceneResultOverlay;
  ConsentUserReply? _consentState;
  MapMarker? _routeFromMarker;
  Place? _routeFromPlace;
  CustomMapStyleExample? _customMapStyleExample;

  @override
  void dispose() {
    stopPositioning();
    super.dispose();
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _getWaterPointData();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          stopPositioning();
          return true;
        },
        child: Consumer2<AppPreferences, CustomMapStyleSettings>(
          builder: (context, preferences, customStyleSettings, child) =>
              Scaffold(
            appBar: AppBar(
              title: Consumer<WaterPointViewModel>(
                builder: (context, value, child) => Text(
                  DataStore.selectedHub == Constants.abatePoints
                      ? DataStore.selectedHub
                      : '${DataStore.selectedHub} Kebele',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 2.0.h),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      var result = await showBlurBarrierBottomSheet(
                        context: context,
                        transparent: true,
                        child: SizedBox(
                          height: 60.0.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCardWidget(
                                  bgColor: AppColors.green,
                                  onTap: () {
                                    setMapSTyle(mapScheme: MapScheme.satellite);
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Satellite',
                                  iconData: FontAwesomeIcons.satellite),
                              SizedBox(
                                height: 2.0.h,
                              ),
                              _buildCardWidget(
                                  bgColor: Colors.deepOrange,
                                  onTap: () {
                                    setMapSTyle(mapScheme: MapScheme.normalDay);
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Normal Day',
                                  iconData: FontAwesomeIcons.sun),
                              SizedBox(
                                height: 2.0.h,
                              ),
                              _buildCardWidget(
                                  bgColor: Colors.orange,
                                  onTap: () {
                                    setMapSTyle(
                                        mapScheme: MapScheme.normalNight);
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Normal Night',
                                  iconData: FontAwesomeIcons.moon),
                              SizedBox(
                                height: 2.0.h,
                              ),
                              _buildCardWidget(
                                  bgColor: Colors.deepPurple,
                                  onTap: () {
                                    setMapSTyle(mapScheme: MapScheme.hybridDay);
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Hybrid Day',
                                  iconData: FontAwesomeIcons.mapLocation),
                              SizedBox(
                                height: 2.0.h,
                              ),
                              _buildCardWidget(
                                  bgColor: Colors.deepOrangeAccent,
                                  onTap: () {
                                    setMapSTyle(
                                        mapScheme: MapScheme.hybridNight);
                                    Navigator.of(context).pop();
                                  },
                                  title: 'Hybrid Night',
                                  iconData: FontAwesomeIcons.mapLocationDot),
                            ],
                          ),
                        ),
                        isDismissible: true,
                      );

                      if (result != null) {
                        //  value.setSelectedHubArea(result.toString());
                        _getWaterPointData();
                      }
                    },
                    icon: Icon(
                      FontAwesomeIcons.layerGroup,
                      size: 2.0.h,
                    )),
                IconButton(
                    onPressed: () {
                      _onSearch(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 2.0.h,
                    ))
              ],
            ),
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              HereMap(
                key: _hereMapKey,
                onMapCreated: _onMapCreated,
              ),
              Consumer<WaterPointViewModel>(
                  builder: (context, value, child) =>
                      value.isLoadingWaterPointData
                          ? LoadingIndicator2()
                          : SizedBox()),
              Consumer<WaterPointViewModel>(
                builder: (context, value, child) => Positioned(
                  child: Column(
                    children: [
                      value.isDownloadingData
                          ? SizedBox(
                              width: 15.0.w,
                              height: 15.0.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [LoadingIndicator(), Text("Syncing")],
                              ),
                            )
                          : Text(''),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      FloatingActionButton(
                          child: Icon(Icons.gps_fixed),
                          mini: true,
                          onPressed: () {
                            GeoCoordinates coordinates =
                                lastKnownLocation != null
                                    ? lastKnownLocation!.coordinates
                                    : Positioning.initPosition;
                            _hereMapController.camera
                                .lookAtPointWithGeoOrientationAndMeasure(
                              coordinates,
                              GeoOrientationUpdate(double.nan, double.nan),
                              MapMeasure(MapMeasureKind.distance,
                                  Positioning.initDistanceToEarth),
                            );
                          },
                          backgroundColor: AppColors.green),
                    ],
                  ),
                  left: 3.8.w,
                  bottom: 2.5.h,
                ),
              )
            ]),
            floatingActionButton: _mapInitSuccess ? _buildFAB2() : null,
            drawer: buildAppDrawer(preferences),
            extendBodyBehindAppBar: true,
            onDrawerChanged: (isOpened) => _dismissLocationWarningPopup(),
          ),
        ),
      ),
    );
  }

  void setMapSTyle({required MapScheme mapScheme}) {
    DataStore.mapScheme = mapScheme;

    _customMapStyleExample?.loadSelectedMapStyle(mapScheme: mapScheme);

    // _hereMapController.mapScene.loadSceneForMapScheme(mapScheme,
    //     (MapError? error) {
    //   log(error.toString());
    // });
  }

  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;
    _customMapStyleExample = CustomMapStyleExample(hereMapController);

    hereMapController.mapScene.loadSceneForMapScheme(DataStore.mapScheme,
        (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      hereMapController.camera.lookAtPointWithMeasure(
        Positioning.initPosition,
        MapMeasure(MapMeasureKind.distance, Positioning.initDistanceToEarth),
      );

      _addGestureListeners();

      PositioningEngine positioningEngine =
          Provider.of<PositioningEngine>(context, listen: false);

      positioningEngine.getLocationEngineStatusUpdates
          .listen(_checkLocationStatus);

      positioningEngine.initLocationEngine(context: context).then((value) {
        initPositioning(context: context, hereMapController: hereMapController);
        _updateConsentState(positioningEngine);
      });

      setState(() {
        _mapInitSuccess = true;
        if (DataStore.selectedHub.isEmpty) {
          DataStore.selectedHub = DataStore.hubAreas[13];
        }
      });

      Future.delayed(Duration(seconds: 1))
          .then((value) => _getWaterPointData());
    });
  }

  Future<void> _getWaterPointData() async {
    final watrBodyVm = context.read<WaterPointViewModel>();
    watrBodyVm.getAllWaterBodyPoints().then((value) {
      context
          .read<SearchBottomSheetViewModel>()
          .setSelectedItem(watrBodyVm.selectedHubArea);
      setMarkers(watrBodyVm.waterBodyPoints);
    });

    _hereMapController.widgetPins.forEach((x) {
      _hereMapController.widgetPins
          .firstWhere((element) => element == x)
          .unpin();
    });
    _hereMapController.widgetPins.clear();
  }

  void setMarkers(List<WaterBodyPoint> waterBodyPoints) {
    waterBodyPoints.take(300).forEach((element) {
      _hereMapController.pinWidget(
          _mapPin(element),
          new GeoCoordinates(
              element.latitude!.toDouble(), element.longitude!.toDouble()));
    });

    if (waterBodyPoints.isNotEmpty) {
      var cWaterBody = waterBodyPoints[0];
      var centre = new GeoCoordinates(
          cWaterBody.latitude!.toDouble(), cWaterBody.longitude!.toDouble());
      _hereMapController.camera.lookAtPointWithMeasure(
        centre,
        MapMeasure(MapMeasureKind.distance, 512000),
      );
    }
  }

  Widget _mapPin(WaterBodyPoint element) {
    return GestureDetector(
      onTap: () {
        context.read<WaterPointViewModel>().setSelctedWaterBodyStatus(
            vSelctedIsWaterBodyPresent: element.isWaterBodyPresent!,
            vSelectedIsWaterBodyVisited: element.hasBeenVisited!,
            vSelectedWaterBodyId: element.id,
            vWaterBodyPoint: element);

        if (element.isAbateKnownPoint!) {
          var abate = jsonDecode(element.abatePointDetails!);
          var abateDetails = AbatePointDetails.fromJson(abate);
          showCustomBottomSheet(
              context: context,
              height: 40.0.h,
              widget: SizedBox(
                child: Consumer<WaterPointViewModel>(
                  builder: (context, value, child) => SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _detailsWidget(
                            name: 'Captain', value: abateDetails.abateCaptain!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                            name: 'Water Source',
                            value: abateDetails.waterSourceName!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                            name: 'Type of Water Source',
                            value: abateDetails.typeofWaterSource!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                            name: 'Village', value: element.hubName!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                            name: 'Reasion for use',
                            value: abateDetails.reasonsforusingwatersource!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        SizedBox(
                          height: 4.8.h,
                        ),
                        AppButton(
                            title: 'Navigate to Abate Point',
                            isLoading: false,
                            onTap: () async {
                              _showRoutingScreen(WayPointInfo.withCoordinates(
                                  coordinates: GeoCoordinates(
                                element.latitude!.toDouble(),
                                element.longitude!.toDouble(),
                              )));
                            }),
                      ],
                    ),
                  ),
                ),
              ));
        } else {
          showCustomBottomSheet(
              context: context,
              height: 45.0.h,
              widget: SizedBox(
                child: Consumer<WaterPointViewModel>(
                  builder: (context, value, child) => SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _detailsWidget(
                            name: 'Unique ID', value: element.uniquEID!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                            name: 'Confidence', value: element.confidence!),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                          name: "Phase",
                          value: element.phase!,
                        ),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                          name: "Last updated by",
                          value: element.lastUpdatedByName!,
                        ),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        _detailsWidget(
                          name: "Last time updated",
                          value: element.formattedlastUpdatedDate,
                        ),
                        SizedBox(
                          height: 1.8.h,
                        ),
                        waterBodyStatus(
                            id: element.id,
                            title: 'Select Status',
                            status: value.selectedWaterBodyStatus),
                        SizedBox(
                          height: 4.8.h,
                        ),
                        AppButton(
                            title: 'Navigate to water body',
                            isLoading: false,
                            onTap: () async {
                              _showRoutingScreen(WayPointInfo.withCoordinates(
                                  coordinates: GeoCoordinates(
                                element.latitude!.toDouble(),
                                element.longitude!.toDouble(),
                              )));
                            }),
                      ],
                    ),
                  ),
                ),
              ));
        }
      },
      child: Icon(
        FontAwesomeIcons.mapPin,
        color: getMarkerColor(element),
        size: 7.0.w,
      ),
    );
  }

  Row _detailsWidget({required String name, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 1.6.h),
        ),
        SizedBox(
          width: 40.0.w,
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontSize: 1.6.h),
          ),
        ),
      ],
    );
  }

  Color getMarkerColor(WaterBodyPoint waterBodyPoint) {
    if (waterBodyPoint.isAbateKnownPoint!) {
      return Colors.purple;
    } else if (waterBodyPoint.waterBodyStatus == Constants.wetDepresssion ||
        waterBodyPoint.waterBodyStatus == Constants.dryDepressionStatus) {
      return Colors.yellow;
    } else if (waterBodyPoint.waterBodyStatus == Constants.waterBodyPresent) {
      return Colors.green;
    } else if (waterBodyPoint.waterBodyStatus == Constants.noWaterBody) {
      return Colors.red;
    }

    return Colors.blue;
  }

  void _resetMapPin() {
    var oldWIdget =
        context.read<WaterPointViewModel>().oldSelectedWaterBodyPoint;
    var newWidget = context.read<WaterPointViewModel>().selectedWaterBodyPoint;
    _hereMapController.unpinWidget(_mapPin(oldWIdget!));
    _hereMapController.pinWidget(
        _mapPin(newWidget!),
        GeoCoordinates(
            newWidget.latitude!.toDouble(), newWidget.longitude!.toDouble()));
  }

  _resetMapItems({required List<WaterBodyPoint> waterBodyPoints}) {
    _hereMapController.widgetPins.forEach((x) {
      _hereMapController.widgetPins
          .firstWhere((element) => element == x)
          .unpin();
    });
    _hereMapController.widgetPins.clear();
    setMarkers(waterBodyPoints);
  }

  Future<void> _filterConfidence(String confidence) async {
    final watrBodyVm = context.read<WaterPointViewModel>();
    watrBodyVm.filterByConfidence(confidenceLevl: confidence).then((value) {
      _resetMapItems(waterBodyPoints: watrBodyVm.waterBodyPoints);
    });
  }

  Future<void> _filterByAbatePoints() async {
    final watrBodyVm = context.read<WaterPointViewModel>();

    watrBodyVm.filterByAbatePoins().then((value) {
      _resetMapItems(waterBodyPoints: watrBodyVm.waterBodyPoints);
    });
  }

  Future<void> _filterPhase(String phase) async {
    final watrBodyVm = context.read<WaterPointViewModel>();
    watrBodyVm.filterByPhase(phase: phase).then((value) {
      _resetMapItems(waterBodyPoints: watrBodyVm.waterBodyPoints);
    });
  }

  Future<void> _filterVisitations(String visitation) async {
    final watrBodyVm = context.read<WaterPointViewModel>();
    watrBodyVm
        .filterByVisitationStatus(visitationStaus: visitation)
        .then((value) {
      _resetMapItems(waterBodyPoints: watrBodyVm.waterBodyPoints);
    });
  }

  Widget waterBodyStatus(
      {required String title, required id, required String? status}) {
    context.read<WaterPointViewModel>().selectedWaterBodyId = id;
    return Consumer<WaterPointViewModel>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 1.6.h),
          ),
          GestureDetector(
            onTap: () {
              showCustomBottomSheet(
                context: context,
                height: 45.0.h,
                widget: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select status",
                          style: TextStyle(
                              fontSize: 2.0.h, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3.0.h,
                        ),
                        SelectItemWidget2(
                          title: Constants.waterBodyPresent,
                          onTap: () {
                            value.updateWaterBodyStatus(
                                selectedValue: Constants.waterBodyPresent);
                            _resetMapPin();
                            //todo remove the update water body and insert on map

                            Navigator.of(context).pop();
                          },
                          isSelected: value.selectedWaterBodyStatus ==
                              Constants.waterBodyPresent,
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        SelectItemWidget2(
                          title: Constants.wetDepresssion,
                          onTap: () {
                            value.updateWaterBodyStatus(
                                selectedValue: Constants.wetDepresssion);
                            _resetMapPin();
                            Navigator.of(context).pop();
                          },
                          isSelected: value.selectedWaterBodyStatus ==
                              Constants.wetDepresssion,
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        SelectItemWidget2(
                          title: Constants.dryDepressionStatus,
                          onTap: () {
                            value.updateWaterBodyStatus(
                                selectedValue: Constants.dryDepressionStatus);
                            _resetMapPin();
                            Navigator.of(context).pop();
                          },
                          isSelected: value.selectedWaterBodyStatus ==
                              Constants.dryDepressionStatus,
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        SelectItemWidget2(
                          title: Constants.noWaterBody,
                          onTap: () {
                            value.updateWaterBodyStatus(
                                selectedValue: Constants.noWaterBody);
                            _resetMapPin();
                            Navigator.of(context).pop();
                          },
                          isSelected: value.selectedWaterBodyStatus ==
                              Constants.noWaterBody,
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                      ]),
                ),
              );
            },
            child: Container(
              width: 40.0.w,
              height: 4.0.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(
                      color: Color(0x0c000000),
                      offset: Offset(0, 4),
                      blurRadius: 11,
                      spreadRadius: 0)
                ],
              ),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.selectedWaterBodyStatus,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 1.4.h),
                  ),
                  const Icon(Icons.arrow_drop_down_outlined)
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildUserConsentItems(BuildContext context) {
    PositioningEngine positioningEngine =
        Provider.of<PositioningEngine>(context, listen: false);
    _consentState = positioningEngine.userConsentState;

    if (_consentState == null) {
      return [];
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return [
      if (_consentState != ConsentUserReply.granted)
        ListTile(
          title: Text(
            '',
            style:
                TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.privacy_tip,
              color: _consentState == ConsentUserReply.granted
                  ? AppColors.green
                  : AppColors.redColor,
            ),
          ],
        ),
        title: Text(
          'Consent',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: _consentState == ConsentUserReply.granted
            ? Text(
                appLocalizations.consentGranted,
                style: TextStyle(
                    color: AppColors.black, fontWeight: FontWeight.bold),
              )
            : Text(
                '${appLocalizations.consentDenied}',
                style: TextStyle(
                    color: AppColors.black, fontWeight: FontWeight.bold),
              ),
        trailing: Icon(
          Icons.arrow_forward,
          color: colorScheme.onPrimary,
        ),
        onTap: () {
          Navigator.of(context).pop();
          positioningEngine
              .requestUserConsent(context)
              ?.then((_) => _updateConsentState(positioningEngine));
        },
      ),
    ];
  }

  void applyCustomStyle(
      CustomMapStyleSettings customMapStyleSettings, File file) {
    _hereMapController.mapScene.loadSceneFromConfigurationFile(
      file.path,
      (MapError? error) {
        _showLoadCustomSceneResultPopup(error == null);
        if (error != null) {
          print('Custom scene load failed: ${error.toString()}');
        } else {
          customMapStyleSettings.customMapStyleFilepath = file.path;
        }
      },
    );
  }

  Future<void> loadCustomScene(
      CustomMapStyleSettings customMapStyleSettings) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    final File file = File(result.files.single.path!);
    final File? localFile = await FileUtility.createLocalSceneFile(file.path);
    if (localFile != null) {
      applyCustomStyle(customMapStyleSettings, localFile);
    } else {
      customMapStyleSettings.reset();
      FileUtility.deleteScenesDirectory();
      _showLoadCustomSceneResultPopup(false);
    }
  }

  void resetCustomScene(CustomMapStyleSettings customMapStyleSettings) {
    customMapStyleSettings.reset();
    FileUtility.deleteScenesDirectory();
    _hereMapController.mapScene.loadSceneForMapScheme(
      MapScheme.normalDay,
      (MapError? error) {
        if (error != null) {
          print('Map scene not loaded. MapError: ${error.toString()}');
        }
      },
    );
  }

  List<Widget> _buildLoadCustomSceneItem(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    CustomMapStyleSettings customMapStyleSettings =
        Provider.of<CustomMapStyleSettings>(context, listen: false);
    return [
      ListTile(
        onTap: () => loadCustomScene(customMapStyleSettings),
        trailing: customMapStyleSettings.customMapStyleFilepath != null
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
                onPressed: () => resetCustomScene(customMapStyleSettings),
              )
            : null,
        title: Text(
          appLocalizations.loadCustomScene,
          style: TextStyle(color: themeData.colorScheme.onPrimary),
        ),
        subtitle: customMapStyleSettings.customMapStyleFilepath != null
            ? Text(
                customMapStyleSettings.customMapStyleFilename,
                style: TextStyle(color: themeData.hintColor),
              )
            : null,
      ),
    ];
  }

  Widget _buildDrawer(BuildContext context, AppPreferences preferences) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    String title = Util.formatString(
      appLocalizations.appTitleHeader,
      [
        Util.applicationVersion,
        SDKBuildInformation.sdkVersion().versionGeneration,
        SDKBuildInformation.sdkVersion().versionMajor,
        SDKBuildInformation.sdkVersion().versionMinor,
      ],
    );

    return Drawer(
      child: Ink(
        color: colorScheme.primary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: DrawerHeader(
                padding: EdgeInsets.all(UIStyle.contentMarginLarge),
                decoration: BoxDecoration(
                  color: colorScheme.onSecondary,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/app_logo.svg",
                      width: UIStyle.drawerLogoSize,
                      height: UIStyle.drawerLogoSize,
                    ),
                    SizedBox(
                      width: UIStyle.contentMarginMedium,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ..._buildUserConsentItems(context),
            ListTile(
                leading: Icon(
                  Icons.download_rounded,
                  color: colorScheme.onPrimary,
                ),
                title: Text(
                  appLocalizations.downloadMapsTitle,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..pushNamed(DownloadMapsScreen.navRoute);
                }),
            ..._buildLoadCustomSceneItem(context),
            SwitchListTile(
              title: Text(
                appLocalizations.useMapOfflineSwitch,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                ),
              ),
              value: preferences.useAppOffline,
              onChanged: (newValue) async {
                if (newValue) {
                  MapLoaderController controller =
                      Provider.of<MapLoaderController>(context, listen: false);
                  if (controller.getInstalledRegions().isEmpty) {
                    Navigator.of(context).pop();
                    if (!await Util.showCommonConfirmationDialog(
                      context: context,
                      title: appLocalizations.offlineAppMapsDialogTitle,
                      message: appLocalizations.offlineAppMapsDialogMessage,
                      actionTitle: appLocalizations.downloadMapsTitle,
                    )) {
                      return;
                    }
                    Navigator.of(context)
                        .pushNamed(DownloadMapsScreen.navRoute);
                  }
                }
                preferences.useAppOffline = newValue;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB2() {
    final wvm = context.read<WaterPointViewModel>();
    return AnimatedFloatingActionButton(
        key: fabKey,
        fabButtons: <Widget>[
          getFabWidget(
              bgColor: AppColors.primaryColor,
              iconData: FontAwesomeIcons.mapPin,
              onTap: () async {
                var result = await showBlurBarrierBottomSheet(
                  context: context,
                  child: SearchBottomSheet(
                    sourceList: DataStore.hubAreas,
                    title: "Select Kebele",
                  ),
                  isDismissible: true,
                );

                if (result != null) {
                  wvm.setSelectedHubArea(result.toString());
                  _getWaterPointData();
                }
              },
              title: 'Kebeles'),
          getFabWidget(
              bgColor: AppColors.dashPurple,
              iconData: FontAwesomeIcons.thumbsUp,
              onTap: () async {
                var result = await showBlurBarrierBottomSheet(
                  context: context,
                  transparent: true,
                  child: SizedBox(
                    height: 50.0.h,
                    child: Column(
                      children: [
                        _buildCardWidget(
                            bgColor: AppColors.green,
                            onTap: () {
                              _filterConfidence('all');
                              Navigator.of(context).pop();
                            },
                            title: 'All',
                            iconData: FontAwesomeIcons.cloud),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: AppColors.primaryColor,
                            onTap: () {
                              _filterConfidence('high');
                              Navigator.of(context).pop();
                            },
                            title: 'High Confidence',
                            iconData: FontAwesomeIcons.sun),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: Colors.purple,
                            onTap: () {
                              _filterConfidence('medium');
                              Navigator.of(context).pop();
                            },
                            title: 'Medium Confidence',
                            iconData: FontAwesomeIcons.water),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: AppColors.redColor,
                            onTap: () {
                              Navigator.of(context).pop();
                              _filterConfidence('low');
                            },
                            title: 'Low Confidence',
                            iconData: FontAwesomeIcons.moon),
                      ],
                    ),
                  ),
                  isDismissible: true,
                );

                if (result != null) {
                  //  value.setSelectedHubArea(result.toString());
                  _getWaterPointData();
                }
              },
              title: 'Confidence'),
          getFabWidget(
              bgColor: AppColors.green,
              iconData: FontAwesomeIcons.mapLocation,
              onTap: () async {
                fabKey.currentState!.closeFABs();
                wvm.setSelectedHubArea(Constants.abatePoints);
                _filterByAbatePoints();
              },
              title: 'Abate Points'),
          getFabWidget(
              bgColor: Colors.black,
              iconData: FontAwesomeIcons.cloudRain,
              onTap: () async {
                await showBlurBarrierBottomSheet(
                  context: context,
                  transparent: true,
                  child: SizedBox(
                    height: 50.0.h,
                    child: Column(
                      children: [
                        _buildCardWidget(
                            bgColor: AppColors.green,
                            onTap: () {
                              _filterPhase('all');
                              Navigator.of(context).pop();
                            },
                            title: 'All',
                            iconData: FontAwesomeIcons.cloudRain),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: AppColors.dashPurple,
                            onTap: () {
                              _filterPhase(Constants.underCanoy);
                              Navigator.of(context).pop();
                            },
                            title: 'Under Canopy',
                            iconData: FontAwesomeIcons.cloud),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: Colors.blue,
                            onTap: () {
                              _filterPhase(Constants.opneSky);
                              Navigator.of(context).pop();
                            },
                            title: 'Open sky',
                            iconData: FontAwesomeIcons.sun),
                      ],
                    ),
                  ),
                  isDismissible: true,
                );
              },
              title: 'Phase'),
          getFabWidget(
              bgColor: Colors.brown,
              iconData: FontAwesomeIcons.personWalking,
              onTap: () async {
                var result = await showBlurBarrierBottomSheet(
                  context: context,
                  transparent: true,
                  child: SizedBox(
                    height: 50.0.h,
                    child: Column(
                      children: [
                        _buildCardWidget(
                            bgColor: AppColors.green,
                            onTap: () {
                              _filterVisitations('all');
                              Navigator.of(context).pop();
                            },
                            title: 'All',
                            iconData: FontAwesomeIcons.mapLocationDot),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: AppColors.dashPurple,
                            onTap: () {
                              _filterVisitations(Constants.visited);
                              Navigator.of(context).pop();
                            },
                            title: 'Visisted',
                            iconData: FontAwesomeIcons.shoePrints),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        _buildCardWidget(
                            bgColor: AppColors.redColor,
                            onTap: () {
                              _filterVisitations(Constants.notVisited);
                              Navigator.of(context).pop();
                            },
                            title: 'Not Visited',
                            iconData: FontAwesomeIcons.xmark),
                      ],
                    ),
                  ),
                  isDismissible: true,
                );

                if (result != null) {
                  //  value.setSelectedHubArea(result.toString());
                  _getWaterPointData();
                }
              },
              title: 'Visitation Status'),
        ],
        colorStartAnimation: AppColors.primaryColor,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close //To principal button
        );
  }

  Widget getFabWidget(
      {required Function onTap,
      required String title,
      required Color bgColor,
      required IconData iconData}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                "$title ",
                style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 1.8.h),
              ),
            ),
          ),
          SizedBox(
            width: 2.0.w,
          ),
          FloatingActionButton(
            tooltip: 'Select $title',
            onPressed: null,
            backgroundColor: bgColor,
            child: Icon(iconData),
          ),
        ],
      ),
    );
  }

  _buildCardWidget(
      {required onTap,
      required String title,
      required Color bgColor,
      required IconData iconData}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        color: bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Row(
            children: [
              Icon(
                iconData,
                color: AppColors.white,
              ),
              SizedBox(
                width: 5.0.w,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 2.0.h),
              )
            ],
          ),
        ),
      ),
    );
  }

  GeoCoordinates? existingCordinates;
  void _addGestureListeners() {
    _hereMapController.gestures.panListener =
        PanListener((state, origin, translation, velocity) {
      if (enableMapUpdate) {
        setState(() => enableMapUpdate = false);
      }
    });

    _hereMapController.gestures.tapListener = TapListener((point) {
      //check for existing cordinates and remove it
      if (existingCordinates != null) {
        _dismissOldCordinate(existingCordinates!);
        existingCordinates = null;
      }
    });

    _hereMapController.gestures.longPressListener =
        LongPressListener((state, point) {
      if (state == GestureState.begin) {
        if (existingCordinates == null) {
          //do not remove old cordinate from map only add codinate
          existingCordinates = _hereMapController.viewToGeoCoordinates(point);
          _showWayPointPopup(point);
        } else {
          //todo remove old cordinate first from map
          GeoCoordinates? coordinates =
              _hereMapController.viewToGeoCoordinates(point);
          _dismissOldCordinate(existingCordinates!);
          _showWayPointPopup(point);
          existingCordinates = coordinates;
        }
      }
    });
  }

  void _dismissWayPointPopup() {
    if (_hereMapController.widgetPins.isNotEmpty) {
      _hereMapController.widgetPins.first.unpin();
    }
  }

  void _dismissOldCordinate(GeoCoordinates coordinates) {
    try {
      _hereMapController.widgetPins
          .firstWhere((element) => element.coordinates == coordinates)
          .unpin();
    } catch (e) {
      log(e.toString());
    }
  }

  void _showWayPointPopup(Point2D point) {
    //   _dismissWayPointPopup();
    GeoCoordinates coordinates =
        _hereMapController.viewToGeoCoordinates(point) ??
            _hereMapController.camera.state.targetCoordinates;

    _hereMapController.pinWidget(
      PlaceActionsPopup(
        coordinates: coordinates,
        hereMapController: _hereMapController,
        onLeftButtonPressed: (place) {
          _dismissWayPointPopup();
          _routeFromPlace = place;
          _addRouteFromPoint(coordinates);
        },
        leftButtonIcon: SvgPicture.asset(
          "assets/depart_marker.svg",
          width: UIStyle.bigIconSize,
          height: UIStyle.bigIconSize,
        ),
        onRightButtonPressed: (place) {
          _dismissWayPointPopup();
          _showRoutingScreen(place != null
              ? WayPointInfo.withPlace(
                  place: place,
                  originalCoordinates: coordinates,
                )
              : WayPointInfo.withCoordinates(
                  coordinates: coordinates,
                ));
        },
        rightButtonIcon: SvgPicture.asset(
          "assets/route.svg",
          color: UIStyle.addWayPointPopupForegroundColor,
          width: UIStyle.bigIconSize,
          height: UIStyle.bigIconSize,
        ),
      ),
      coordinates,
      anchor: Anchor2D.withHorizontalAndVertical(0.5, 1),
    );
  }

  void _addRouteFromPoint(GeoCoordinates coordinates) {
    if (_routeFromMarker == null) {
      int markerSize =
          (_hereMapController.pixelScale * UIStyle.searchMarkerSize).round();
      _routeFromMarker = Util.createMarkerWithImagePath(
        coordinates,
        "assets/depart_marker.svg",
        markerSize,
        markerSize,
        drawOrder: UIStyle.waypointsMarkerDrawOrder,
        anchor: Anchor2D.withHorizontalAndVertical(0.5, 1),
      );
      _hereMapController.mapScene.addMapMarker(_routeFromMarker!);
      if (!isLocationEngineStarted) {
        locationVisible = false;
      }
    } else {
      _routeFromMarker!.coordinates = coordinates;
    }
  }

  void _removeRouteFromMarker() {
    if (_routeFromMarker != null) {
      _hereMapController.mapScene.removeMapMarker(_routeFromMarker!);
      _routeFromMarker = null;
      _routeFromPlace = null;
      locationVisible = true;
    }
  }

  void _dismissLocationWarningPopup() {
    _locationWarningOverlay?.remove();
    _locationWarningOverlay = null;
  }

  void _checkLocationStatus(LocationEngineStatus status) {
    if (status == LocationEngineStatus.engineStarted ||
        status == LocationEngineStatus.alreadyStarted) {
      _dismissLocationWarningPopup();
      return;
    }

    if (_locationWarningOverlay == null) {
      _locationWarningOverlay = OverlayEntry(
        builder: (context) => NoLocationWarning(
          onPressed: () => _dismissLocationWarningPopup(),
        ),
      );

      Overlay.of(context)!.insert(_locationWarningOverlay!);
      Timer(Duration(seconds: _kLocationWarningDismissPeriod),
          _dismissLocationWarningPopup);
    }
  }

  void _showLoadCustomSceneResultPopup(bool result) {
    _dismissLoadCustomSceneResultPopup();

    _loadCustomSceneResultOverlay = OverlayEntry(
      builder: (context) => LoadCustomStyleResultPopup(
        loadCustomStyleResult: result,
        onClosePressed: () => _dismissLoadCustomSceneResultPopup(),
      ),
    );

    Overlay.of(context)!.insert(_loadCustomSceneResultOverlay!);
    Timer(Duration(seconds: _kLoadCustomStyleResultPopupDismissPeriod),
        _dismissLoadCustomSceneResultPopup);
  }

  void _dismissLoadCustomSceneResultPopup() {
    _loadCustomSceneResultOverlay?.remove();
    _loadCustomSceneResultOverlay = null;
  }

  void _onSearch(BuildContext context) async {
    GeoCoordinates currentPosition =
        _hereMapController.camera.state.targetCoordinates;

    final SearchResult? result = await showSearchPopup(
      context: context,
      currentPosition: currentPosition,
      hereMapController: _hereMapController,
      hereMapKey: _hereMapKey,
    );
    if (result != null) {
      SearchResult searchResult = result;
      assert(searchResult.place != null);
      // _showRoutingScreen(WayPointInfo.withPlace(
      //   place: searchResult.place,
      // ));
      if (existingCordinates != null) {
        _dismissOldCordinate(existingCordinates!);
      }
      existingCordinates = result.place!.geoCoordinates;
      _showWayPointCordinate(existingCordinates!);

      //move camera to cordinate position
      _hereMapController.camera.lookAtPointWithMeasure(
        existingCordinates!,
        MapMeasure(MapMeasureKind.distance, Positioning.initDistanceToEarth),
      );
    }
  }

  void _showWayPointCordinate(GeoCoordinates coordinates) {
    _hereMapController.pinWidget(
      PlaceActionsPopup(
        coordinates: coordinates,
        hereMapController: _hereMapController,
        onLeftButtonPressed: (place) {
          _dismissWayPointPopup();
          _routeFromPlace = place;
          _addRouteFromPoint(coordinates);
        },
        leftButtonIcon: SvgPicture.asset(
          "assets/depart_marker.svg",
          width: UIStyle.bigIconSize,
          height: UIStyle.bigIconSize,
        ),
        onRightButtonPressed: (place) {},
        rightButtonIcon: SvgPicture.asset(
          "assets/route.svg",
          color: UIStyle.addWayPointPopupForegroundColor,
          width: UIStyle.bigIconSize,
          height: UIStyle.bigIconSize,
        ),
      ),
      coordinates,
      anchor: Anchor2D.withHorizontalAndVertical(0.5, 1),
    );
  }

  void _showRoutingScreen(WayPointInfo destination) async {
    //do a check if existing coridnate is null, if it is not null use that as current location

    GeoCoordinates currentPosition = lastKnownLocation != null
        ? lastKnownLocation!.coordinates
        : Positioning.initPosition;

    if (existingCordinates != null) {
      currentPosition = existingCordinates!;
    }

//Todo remove current position
    ///  currentPosition = GeoCoordinates(7.629322846, 34.37388925);

    await Navigator.of(context).pushNamed(
      RoutingScreen.navRoute,
      arguments: [
        currentPosition,
        _routeFromMarker != null
            ? _routeFromPlace != null
                ? WayPointInfo.withPlace(
                    place: _routeFromPlace,
                    originalCoordinates: _routeFromMarker!.coordinates,
                  )
                : WayPointInfo.withCoordinates(
                    coordinates: _routeFromMarker!.coordinates,
                  )
            : WayPointInfo(coordinates: currentPosition),
        destination,
        existingCordinates
      ],
    );

    _routeFromPlace = null;
    _removeRouteFromMarker();
  }

  void _updateConsentState(PositioningEngine positioningEngine) {
    setState(() => _consentState = positioningEngine.userConsentState);
  }

  Widget buildAppDrawer(AppPreferences preferences) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Drawer(
      child: SizedBox(
        height: 100.0.h,
        width: 100.0.w,
        child: Column(
          children: [
            Container(
              height: 23.0.h,
              width: 100.0.w,
              color: AppColors.primaryColor,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 4.0.h,
                      backgroundColor: AppColors.white,
                      child: Text(
                        "${DataStore.userAccount?.firstName![0]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 4.0.h),
                      ),
                    ),
                    Text(
                      "${DataStore.userAccount?.firstName} ${DataStore.userAccount?.lastName}",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 3.0.h,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${DataStore.userAccount?.phoneNumber}",
                      style: TextStyle(
                          fontSize: 2.0.h,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    _buildDrawerTile(
                        context: context,
                        onTap: () {
                          AppNavigator.pushAndRemoveUntil(
                              context, LandingScreen());
                        },
                        iconData: FontAwesomeIcons.mapPin,
                        title: "Water Detection Points"),
                    _buildDrawerTile(
                        context: context,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await context
                              .read<WaterPointViewModel>()
                              .syncWaterBodyData();
                        },
                        iconData: FontAwesomeIcons.recycle,
                        title: "Synchronize Data"),
                    _buildDrawerTile(
                        context: context,
                        onTap: () async {
                          Navigator.of(context)
                            ..pop()
                            ..pushNamed(DownloadMapsScreen.navRoute);
                        },
                        iconData: FontAwesomeIcons.mapLocation,
                        title: "Download Map"),
                    SwitchListTile(
                      title: Row(
                        children: [
                          Icon(FontAwesomeIcons.powerOff),
                          SizedBox(
                            width: 7.0.w,
                          ),
                          Text(
                            'Use offline',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 1.8.h,
                                color: AppColors.black),
                          ),
                        ],
                      ),
                      value: preferences.useAppOffline,
                      onChanged: (newValue) async {
                        if (newValue) {
                          MapLoaderController controller =
                              Provider.of<MapLoaderController>(context,
                                  listen: false);
                          if (controller.getInstalledRegions().isEmpty) {
                            Navigator.of(context).pop();
                            if (!await Util.showCommonConfirmationDialog(
                              context: context,
                              title: appLocalizations.offlineAppMapsDialogTitle,
                              message:
                                  appLocalizations.offlineAppMapsDialogMessage,
                              actionTitle: appLocalizations.downloadMapsTitle,
                            )) {
                              return;
                            }
                            Navigator.of(context)
                                .pushNamed(DownloadMapsScreen.navRoute);
                          }
                        }
                        preferences.useAppOffline = newValue;
                      },
                    ),
                    ..._buildUserConsentItems(context),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    _buildDrawerTile(
                        context: context,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await context.read<LoginViewModel>().logOutUser();

                          AppNavigator.pushAndRemoveUntil(
                              context, LoginScreen());
                        },
                        iconData: FontAwesomeIcons.arrowRightFromBracket,
                        color: AppColors.redColor,
                        title: "Log Out"),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: Text(
                      Constants.appVersion,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  _buildDrawerTile(
      {required BuildContext context,
      required String title,
      required Function onTap,
      required IconData iconData,
      Color? color}) {
    return ListTile(
      leading: Icon(
        iconData,
        color: color ?? AppColors.greyColor,
        size: 2.8.h,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: color ?? AppColors.black),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
