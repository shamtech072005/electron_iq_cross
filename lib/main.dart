// main.dart

import 'package:electron_iq/Auth/auth_gate.dart';
import 'package:flutter/foundation.dart'; // <-- 1. IMPORT FOUNDATION
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

// Create a static instance for the Analytics Observer
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- 2. THIS IS THE FIX ---
  // Only initialize Ads and Analytics for mobile platforms
  if (!kIsWeb) {
    // Initialize the Mobile Ads SDK and register your test device.
    await MobileAds.instance.initialize();
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: ["A089B5790D838861334C356B109E0128"],
    );
    MobileAds.instance.updateRequestConfiguration(configuration);
  }
  // --- END OF FIX ---

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Electron IQ',
      debugShowCheckedModeBanner: false,
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
      home: const AuthGate(),
      // Conditionally add the observer only for non-web platforms
      navigatorObservers: !kIsWeb
          ? [
              FirebaseAnalyticsObserver(analytics: analytics),
            ]
          : [],
    );
  }
}

