import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroblast_dashboard/firebase_options.dart';
import 'package:neuroblast_dashboard/screens/home/home_screen.dart';
import 'package:neuroblast_dashboard/screens/main/main_screen.dart';
import 'package:neuroblast_dashboard/screens/main/splash.dart';
import 'package:neuroblast_dashboard/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeuroBlast Dashboard',
      theme: isDarkMode ? darkAppTheme : appTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Show splash screen while waiting for authentication status
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return const MainScreen(); // User is authenticated, show main screen
          } else {
            return const HomeScreen(); // User is not authenticated, show home screen
          }
        },
      ),
    );
  }
}

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF656B84),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF656B84),
    secondary: Color(0xFFA2D06B),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFFF5F5F5),
      foregroundColor: const Color(0xFF656B84),
      side: const BorderSide(color: Color(0xFF656B84)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA2D06B),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(color: Colors.black),
    bodyMedium: GoogleFonts.lato(color: Colors.black),
    headlineMedium: GoogleFonts.lato(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFA2D06B)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFA2D06B),
    foregroundColor: Colors.white,
  ),
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

final ThemeData darkAppTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF303846),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF303846),
    secondary: Color(0xFFA2D06B),
    surface: Color(0xFF252525),
  ),
  scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF303846),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFF252525),
      foregroundColor: const Color(0xFFA2D06B),
      side: const BorderSide(color: Color(0xFFA2D06B)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA2D06B),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.lato(color: Colors.white),
    bodyMedium: GoogleFonts.lato(color: Colors.white),
    headlineMedium: GoogleFonts.lato(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFA2D06B)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFA2D06B),
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA2D06B)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF656B84)),
    ),
    labelStyle: TextStyle(color: Color(0xFFA2D06B)),
  ),
);
