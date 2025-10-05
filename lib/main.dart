// main.dart

import 'dart:async'; // <-- 1. IMPORT FOR runZonedGuarded
import 'package:electron_iq/Shared%20Widgets/Screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';


void main() async {
  // --- 2. WRAP in runZonedGuarded FOR GLOBAL ERROR HANDLING ---
  runZonedGuarded<Future<void>>(() async {
    // Ensure that Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Only initialize Ads for mobile platforms
    if (!kIsWeb) {
      // Initialize the Mobile Ads SDK
      await MobileAds.instance.initialize();
      // --- 3. REMOVE TEST DEVICE CONFIGURATION FOR PRODUCTION ---
    }

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    runApp(const MyApp());
  }, (error, stack) {
    // Here you would log errors to a service like Firebase Crashlytics
    // For now, we'll just print them to the console.
    debugPrint("Caught unhandled error: $error");
    debugPrint(stack.toString());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Electron IQ',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        textTheme: GoogleFonts.montserratTextTheme(textTheme).apply(
          bodyColor: const Color(0xFFCCD6F6),
          displayColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          color: const Color(0xFF112240),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF0A192F),
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
      ),
      home: const SplashScreen(),
      navigatorObservers: const [],
    );
  }
}