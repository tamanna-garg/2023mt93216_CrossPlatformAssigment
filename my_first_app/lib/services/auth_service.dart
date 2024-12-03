import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/back4app_config.dart';

class AuthService {
  static String? _currentUserId;

  static String? get currentUserId => _currentUserId;

  static Future<void> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Back4AppConfig.serverUrl}/users'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': email,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw jsonDecode(response.body)['error'] ?? 'Sign-up failed';
    }
  }

  static Future<void> login(String email, String password) async {
    final response = await http.get(
      Uri.parse(
          '${Back4AppConfig.serverUrl}/login?username=$email&password=$password'),
      headers: {
        'X-Parse-Application-Id': Back4AppConfig.appId,
        'X-Parse-Client-Key': Back4AppConfig.clientKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentUserId = data['objectId']; // Save user ID
    } else {
      throw jsonDecode(response.body)['error'] ?? 'Login failed';
    }
  }

  static Future<void> logout() async {
    _currentUserId = null;
  }
}
