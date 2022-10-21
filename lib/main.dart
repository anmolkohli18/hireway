import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hireway/console/app_console.dart';
import 'package:hireway/respository/firebase/firebase_config.dart';
import 'package:hireway/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.platformOptions);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Hire Way',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            subtitle1: TextStyle(color: primaryColor),
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryButtonColor,
              selectionColor: lightHeadingColor),
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButtonColor)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryButtonColor))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  backgroundColor: Colors.white,
                  foregroundColor: failedColor,
                  side: const BorderSide(color: failedColor))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  textStyle: const TextStyle(fontSize: 14),
                  backgroundColor: successColor,
                  foregroundColor: Colors.white)),
          primarySwatch: primaryConsoleColor,
          scaffoldBackgroundColor: const Color(0xFFF4F6F7),
          colorScheme: const ColorScheme.light(
              background: primaryButtonColor, secondary: secondaryButtonColor)),
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        return MyCustomRoute(
            builder: (_) => AppConsole(
                  routeSettings: settings,
                ),
            settings: RouteSettings(name: settings.name));
      },
    );
  }
}
