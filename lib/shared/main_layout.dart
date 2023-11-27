import 'package:bookings_app/features/auth/domain/authentication_service.dart';
import 'package:bookings_app/features/auth/pages/login_page.dart';
import 'package:bookings_app/features/bookings/pages/bookings_page.dart';
import 'package:bookings_app/features/rooms/pages/rooms_page.dart';
import 'package:bookings_app/features/users/model/user.dart';
import 'package:bookings_app/shared/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentPage;
  late final PageController _pageController;
  final AuthenticationService _authService = AuthenticationService();

  void _logout() async {
    await _authService.logout();

    if (!context.mounted) return;
    BlocProvider.of<UserCubit>(context).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User?>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state == null) {
          _authService.checkSharedPrefs().then((user) {
            BlocProvider.of<UserCubit>(context).login(user);
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sistema de Reservas de Habitaciones'),
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.account_circle),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text('Perfil'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      onTap: () => _logout(),
                      child: const Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 10),
                          Text('Cerrar sesión'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: const [
              BookingsPage(),
              RoomsPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentPage,
            onDestinationSelected: (page) {
              setState(() {
                _currentPage = page;
                _pageController.animateToPage(page,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: 'Reservas',
              ),
              NavigationDestination(
                icon: Icon(Icons.hotel),
                label: 'Habitaciones',
              ),
            ],
          ),
        );
      },
    );
  }
}
