import 'package:animate_do/animate_do.dart';
import 'package:bookings_app/features/auth/domain/authentication_service.dart';
import 'package:bookings_app/features/users/model/user.dart';
import 'package:bookings_app/shared/auth_state.dart';
import 'package:bookings_app/shared/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool obscurePass = true;

  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.purple.shade900,
                      const Color.fromARGB(255, 149, 70, 199),
                      const Color.fromARGB(255, 155, 51, 173),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: const Text(
                              "Bienvenido al Sistema de Reservas de Habitaciones",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: const Text(
                              "Inicie sesión para continuar",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 60),
                                FadeInUp(
                                  duration: const Duration(microseconds: 1400),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(224, 69, 3, 95),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                          child: TextFormField(
                                            controller: _emailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              hintText: "Ingrese Usuario",
                                              hintStyle: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.email,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingrese un usuario';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            obscureText: obscurePass,
                                            decoration: InputDecoration(
                                              hintText: "Ingrese Contraseña",
                                              hintStyle: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.key,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    obscurePass = !obscurePass;
                                                  });
                                                },
                                                icon: Icon(
                                                  !obscurePass
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingrese una contraseña';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1600),
                                  child: FilledButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              _login().then((value) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              });
                                            }
                                          },
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      var email = _emailController.text;
      var password = _passwordController.text;

      var response = await _authService.login(email, password);

      if (!response.containsKey("user")) {
        _showDialog(response["message"] ??
            "No se pudo iniciar sesión. Intente de nuevo");
        return;
      }

      var user = User.fromJson(response["user"]);
      var token = response["token"];

      await _authService.updateSharedPrefs(token, user.id!);
      if (!context.mounted) return;
      BlocProvider.of<UserCubit>(context).login(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
        ),
      );
    } catch (e) {
      _showDialog("No se pudo iniciar sesión. Intente de nuevo");
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer)),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(message,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
