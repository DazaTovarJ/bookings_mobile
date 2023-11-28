import 'package:bookings_app/features/auth/domain/authentication_service.dart';
import 'package:bookings_app/features/auth/pages/login_page.dart';
import 'package:bookings_app/shared/auth_state.dart';
import 'package:bookings_app/shared/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({super.key});

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  int userId = 0;

  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    try {
      var user = await _authenticationService.checkSharedPrefs();
      if (!context.mounted) return;

      BlocProvider.of<UserCubit>(context).login(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
        ),
      );
    } catch (e) {
      showLogoutNotification(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  static Widget showLogoutNotification(BuildContext context) =>
      _showNotification(context, 'Sesión Cerrada', 'Su sesión ha sido cerrada');

  static Widget _showNotification(
      BuildContext context, String title, String message) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            AuthenticationService().logout();
            BlocProvider.of<UserCubit>(context).logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('OK'),
        ),
      ],
    );

    return dialog;
  }
}
