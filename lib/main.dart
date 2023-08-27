import 'package:todo/constants/other_constants.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/utils/logger_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo/route/app_routes.dart' as route;

/// Its true if the application is running in debug mode.
///
/// Use it in place of [kDebugMode] through out the app to check for debug mode.
/// Useful in faking production mode in debug mode by setting it to false.
bool isInDebugMode = kDebugMode;

/// Key used when building the ScaffoldMessenger.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  runZonedGuarded(() async {
    /// Ensure that widget binding is initialized.
    WidgetsFlutterBinding.ensureInitialized();

    /// Initialize Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Initialize logger.
    await setupLogger();

    runApp(
      const ProviderScope(
        child: DynamicColorApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    logger.e('Uncaught error: $error', error, stackTrace);
  });
}

/// The root widget of the app.
class DynamicColorApp extends StatelessWidget {
  /// Creates a [DynamicColorApp].
  const DynamicColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();

          // Repeat for the dark color scheme.
          darkScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback schemes.
          lightScheme = ThemeData.light().colorScheme;
          darkScheme = ThemeData.dark().colorScheme;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            fontFamily: 'LexendDeca',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            fontFamily: 'LexendDeca',
          ),
          themeMode: ThemeMode.system,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          initialRoute: route.AppRoutes.initialScreen,
          onGenerateRoute: route.AppRoutes.controller,
        );
      },
    );
  }
}
