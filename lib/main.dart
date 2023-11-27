import 'package:bookings_app/auth_check.dart';
import 'package:bookings_app/shared/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var colorSchemeLight = ColorScheme.fromSeed(
      seedColor: const Color(0xFF262254),
      error: const Color(0xFFBF002E),
      errorContainer: const Color(0xFFFFDAD9),
      onErrorContainer: const Color(0xFF400009),
    );
    var appTheme = ThemeData(
      colorScheme: colorSchemeLight,
      scaffoldBackgroundColor: colorSchemeLight.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: ElevationOverlay.applySurfaceTint(
          colorSchemeLight.surface,
          colorSchemeLight.surfaceTint,
          3,
        ),
        foregroundColor: colorSchemeLight.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return colorSchemeLight.onSurface.withOpacity(0.12);
              }
              return ElevationOverlay.applySurfaceTint(
                colorSchemeLight.surface,
                colorSchemeLight.surfaceTint,
                1,
              );
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return colorSchemeLight.onSurface.withOpacity(0.38);
              }
              return colorSchemeLight.primary;
            },
          ),
        ),
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(null),
        ),
      ],
      child: MaterialApp(
        title: 'Bookings App',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const LoginCheck(),
      ),
    );
  }
}
