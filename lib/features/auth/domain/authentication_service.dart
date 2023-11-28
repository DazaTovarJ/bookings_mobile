import 'package:bookings_app/features/auth/data/auth_repository.dart';
import 'package:bookings_app/features/users/data/user_repository.dart';
import 'package:bookings_app/features/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<void> register(String firstName, String lastName, String email, String password) async {
    return await _authRepository.register(firstName, lastName, email, password);
  }

  Future<User?> getUserInfo(int id) async {
    var userResponse = await _userRepository.getUser(id);

    return userResponse.data;
  }

  Future<User> checkSharedPrefs() async {
    var prefs = await _prefs;
    await prefs.reload();
    var token = prefs.getString('token');
    var userId = prefs.getInt('id') ?? 0;
    if ((token == null || token.isEmpty) || userId == 0)  {
      return Future.error("No credentials found");
    }

    var user = await getUserInfo(userId);

    if (user == null) {
      return Future.error("No se encontró el usuario");
    }

    updateSharedPrefs(token, user.id!);

    return user;
  }

  Future<void> updateSharedPrefs(String token, int id) async {
    var prefs = await _prefs;

    await prefs.clear();
    await prefs.setString('token', token);
    await prefs.setInt('id', id);

    print("Saved: ${prefs.getString("token")}");
  }

  Future<void> logout() async {
    var prefs = await _prefs;

    await prefs.reload();
    await prefs.remove('token');
    await prefs.remove('id');
  }
}