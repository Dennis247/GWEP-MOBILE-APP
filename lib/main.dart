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

import 'package:RefApp/core/viewmodel/login_viewmodel.dart';
import 'package:RefApp/core/viewmodel/register_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/maploader.dart';
import 'package:here_sdk/search.dart';
import 'package:provider/provider.dart';
import 'package:here_sdk/routing.dart' as Routing;
import 'package:sizer/sizer.dart';

import 'common/application_preferences.dart';
import 'common/custom_map_style_settings.dart';
import 'common/ui_style.dart';
import 'core/data/tables/hubs_data/hub_table.dart';
import 'core/data/tables/water_point_data/water_body_point_table.dart';
import 'core/screen/splash_screen.dart';
import 'core/services/water_point_service.dart';
import 'core/utils/constants.dart';
import 'core/utils/theme.dart';
import 'core/viewmodel/water_point_viewmodel.dart';
import 'core/widgets/bottom_sheet/search_bottom_sheet.dart';
import 'download_maps/download_maps_screen.dart';
import 'download_maps/map_loader_controller.dart';
import 'download_maps/map_regions_list_screen.dart';
import 'landing_screen.dart';
import 'navigation/navigation_screen.dart';
import 'positioning/positioning_engine.dart';
import 'route_preferences/route_preferences_model.dart';
import 'routing/route_details_screen.dart';
import 'routing/routing_screen.dart';
import 'routing/waypoint_info.dart';
import 'routing/waypoints_controller.dart';
import 'search/recent_search_data_model.dart';
import 'search/search_results_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The entry point of the application.
final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SdkContext.init();

  await Hive.initFlutter();

  //register adapter
  Hive.registerAdapter(WaterBodyPointTableAdapter());
  Hive.registerAdapter(HubTableAdapter());

  //register table
  await Hive.openBox<WaterBodyPointTable>(Constants.waterBodyPointTable);
  await Hive.openBox<HubTable>(Constants.hubTable);

  await WaterPointService.getHubArea();

  runApp(MyApp());
}

/// Application root widget.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    SdkContext.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RecentSearchDataModel()),
          ChangeNotifierProvider(
              create: (context) => RoutePreferencesModel.withDefaults()),
          ChangeNotifierProvider(create: (context) => MapLoaderController()),
          ChangeNotifierProvider(create: (context) => AppPreferences()),
          Provider(create: (context) => PositioningEngine()),
          ChangeNotifierProvider(create: (context) => CustomMapStyleSettings()),
          ChangeNotifierProvider(create: (context) => WaterPointViewModel()),
          ChangeNotifierProvider(
              create: (context) => SearchBottomSheetViewModel()),
          ChangeNotifierProvider(create: (context) => LoginViewModel()),
          ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.theme,
          supportedLocales: [
            const Locale('en', ''),
          ],
          // theme: UIStyle.lightTheme,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          onGenerateRoute: (RouteSettings settings) {
            Map<String, WidgetBuilder> routes = {
              SplashScreen.navRoute: (BuildContext context) => SplashScreen(),
              LandingScreen.navRoute: (BuildContext context) => LandingScreen(),
              SearchResultsScreen.navRoute: (BuildContext context) {
                List<dynamic> arguments = settings.arguments as List<dynamic>;
                assert(arguments.length == 3);
                return SearchResultsScreen(
                  queryString: arguments[0] as String,
                  places: arguments[1] as List<Place>,
                  currentPosition: arguments[2] as GeoCoordinates,
                );
              },
              RoutingScreen.navRoute: (BuildContext context) {
                List<dynamic> arguments = settings.arguments as List<dynamic>;
                assert(arguments.length == 4);
                return RoutingScreen(
                  currentPosition: arguments[0] as GeoCoordinates,
                  departure: arguments[1] as WayPointInfo,
                  destination: arguments[2] as WayPointInfo,
                  existingCurrentPosition: arguments[3] == null
                      ? arguments[0] as GeoCoordinates
                      : arguments[3] as GeoCoordinates,
                );
              },
              RouteDetailsScreen.navRoute: (BuildContext context) {
                List<dynamic> arguments = settings.arguments as List<dynamic>;
                assert(arguments.length == 2);
                return RouteDetailsScreen(
                  route: arguments[0] as Routing.Route,
                  wayPointsController: arguments[1] as WayPointsController,
                );
              },
              NavigationScreen.navRoute: (BuildContext context) {
                List<dynamic> arguments = settings.arguments as List<dynamic>;
                assert(arguments.length == 2);
                return NavigationScreen(
                  route: arguments[0] as Routing.Route,
                  wayPoints: arguments[1] as List<Routing.Waypoint>,
                );
              },
              DownloadMapsScreen.navRoute: (BuildContext context) {
                return DownloadMapsScreen();
              },
              MapRegionsListScreen.navRoute: (BuildContext context) {
                List<dynamic> arguments = settings.arguments as List<dynamic>;
                assert(arguments.length == 1);
                return MapRegionsListScreen(
                  regions: arguments[0] as List<Region>,
                );
              },
            };

            WidgetBuilder builder = routes[settings.name]!;
            return MaterialPageRoute(
              builder: (ctx) => builder(ctx),
              settings: settings,
            );
          },
          initialRoute: SplashScreen.navRoute,
        ),
      ),
    );
  }
}
