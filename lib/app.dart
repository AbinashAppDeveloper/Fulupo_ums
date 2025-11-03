import 'package:device_preview/device_preview.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/config/app_theme.dart';
import 'package:fulupo_ums/flavours.dart';
import 'package:fulupo_ums/pages/homepage.dart';
import 'package:fulupo_ums/pages/loginPage.dart';
import 'package:fulupo_ums/pages/splash.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';

import 'package:provider/provider.dart';

ValueNotifier<bool> isDevicePreviewEnabled = ValueNotifier<bool>(false);
bool testingMode = kDebugMode && F.appFlavor == Flavor.dev;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // void initState() {
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDevicePreviewEnabled,
      builder: (context, value, __) {
        return AppThemeData(
          data: AppThemes(ThemeMode.light).customTheme,
          child: DevicePreview(
            enabled: F.appFlavor != Flavor.prod ? value : false,
            // useInheritedMediaQuery:true,
            builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (ctx) => UserProvider()),
                  // ChangeNotifierProvider(create: (ctx) => GetProvider()),
                  //ChangeNotifierProvider(create: (ctx) => AudioProvider()),
                ],
                child: MaterialApp(
                  // debugShowPerformanceOverlay: false,
                  showSemanticsDebugger: false,
                  localizationsDelegates: const [],
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: MediaQuery.of(context).textScaler.clamp(
                          minScaleFactor: 0.5,
                          maxScaleFactor: 1.5,
                        ),
                      ),
                      child: child!,
                    );
                  },

                  navigatorKey: AppConstants.navigatorKey,

                  useInheritedMediaQuery: true,
                  //initialRoute: AppRouteName.login.value,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  theme: AppThemes(ThemeMode.light).theme,
                  darkTheme: AppThemes(ThemeMode.dark).theme,
                  themeMode: ThemeMode.light,
                  home: Splash(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
