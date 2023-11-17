import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';

class AuthRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();

  Future<void> login(String email, String password) async {
    final response = await _httpClient.post(
      _apiConfig.getAuthActionUri('login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String firstName, String lastName, String email, String password) async {
    final response = await _httpClient.post(
      _apiConfig.getAuthActionUri('register'),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print('Register successful');
    } else {
      throw Exception('Failed to register');
    }
  }
}