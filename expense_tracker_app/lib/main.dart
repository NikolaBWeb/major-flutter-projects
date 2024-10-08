import 'package:flutter/material.dart';

import 'package:expense_tracker_app/widgets/expenses.dart';


var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 1, 184, 80),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 6, 233, 59),
);

void main() {
/*   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) { */
    runApp(
      MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.secondaryContainer,
            ),
          ),
        ),
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: const TextTheme().copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.normal,
              color: kColorScheme.onPrimaryContainer,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const Expenses(),
      ),
    );
  }/* ) */
/* } */
