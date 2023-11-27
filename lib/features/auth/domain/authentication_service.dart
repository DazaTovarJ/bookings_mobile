import 'package:bookings_app/features/auth/data/auth_repository.dart';
import 'package:bookings_app/features/users/data/user_repository.dart';
import 'package:bookings_app/features/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<void> register(String firstName, String lastName, String email, String password) async {
    return await _authRepository.register(firstName, lastName, email, password);
  }

  Future<User> getUserInfo(int id) async {
    return await _userRepository.getUser(id);
  }

  Future<User> checkSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('id') ?? 0;
    if ((token == null || token.isEmpty) || userId == 0)  {
      return Future.error("No credentials found");
    }

    var user = await getUserInfo(userId);

    updateSharedPrefs(token, user.id!);

    return user;
  }

  Future<void> updateSharedPrefs(String token, int id) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setInt('id', id);
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('id');
  }
}