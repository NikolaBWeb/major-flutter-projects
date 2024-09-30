import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuroblast_dashboard/screens/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBlast Dashboard',
      theme: appTheme, // Add your theme here
      home: const HomeScreen(),
    );
  }
}

// Your previous theme definition can be included here
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
      color: const Color(0xFF9FA1AC),
    ),
    bodyMedium: GoogleFonts.lato(
      color: const Color(0xFF656B84),
    ),
    headlineMedium: GoogleFonts.lato(
      color: Colors.white,
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
