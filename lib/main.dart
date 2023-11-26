import 'package:bookings_app/features/auth/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF262254),
        error: const Color(0xFFBF002E),
        errorContainer: const Color(0xFFFFDAD9),
        onErrorContainer: const Color(0xFF400009),
      ),
      useMaterial3: true,
    );
    /*var darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF262254),
        error: const Color(0xFFFFB3B3),
        onError: const Color(0xFF680014),
        errorContainer: const Color(0xFF920021),
        onErrorContainer: const Color(0xFFFFDAD9),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );*/

    return MaterialApp(
      title: 'Bookings App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginPage(),
    );
  }
}
