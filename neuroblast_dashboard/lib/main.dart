import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroblast_dashboard/firebase_options.dart';
import 'package:neuroblast_dashboard/screens/home/home_screen.dart';
import 'package:neuroblast_dashboard/screens/main/main_screen.dart';
import 'package:neuroblast_dashboard/screens/main/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

/// The main application widget that serves as the entry point
/// for the NeuroBlast Dashboard.
/// This widget is responsible for setting up the MaterialApp
///  and defining the overall  theme
/// and home screen of the application. It uses the ProviderScope
/// to enable state  management throughout the app.
///
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  ///
  /// The [key] parameter is used to uniquely identify the widget
  /// in the widget tree. It is optional and can be used for
  /// widget state management.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBlast Dashboard',

      theme: appTheme, // Add your theme here
      home: StreamBuilder<User?>(
        // Updated to use User? as the type
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}');
          print('Has error: ${snapshot.hasError}');
          print('Has data: ${snapshot.hasData}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            print('User is signed in, navigating to MainScreen');
            return const MainScreen();
          } else {
            print('No user signed in, showing HomeScreen');
            return const HomeScreen();
          }
        },
      ),
    );
  }
}

// Your previous theme definition can be included here
/// Defines the application's theme data for the NeuroBlast Dashboard.
///
/// This theme includes settings for primary and secondary colors,
/// background colors, AppBar styles, button styles, text styles,
/// icon themes, and floating action button themes. It utilizes
/// the Google Fonts package to apply custom fonts to the text
/// elements throughout the application.
final ThemeData appTheme = ThemeData(
  // Primary color
  primaryColor: const Color(0xFF656B84),

  // Accent color
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF656B84),
    secondary: Color(0xFFA2D06B),
  ),

  // Background color (for light theme)
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA2D06B), // Use accent color for buttons
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),

  // Text theme
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.lato(
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.lato(
      color: Colors.black,
    ),
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: Color(0xFFA2D06B), // Accent color for icons
  ),

  // Floating Action Button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFA2D06B), // Accent color
    foregroundColor: Colors.white,
  ),

  // Input decorations
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA2D06B)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF656B84)),
    ),
    labelStyle: TextStyle(color: Color(0xFF656B84)),
  ),
);