import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  bool _isAdmin = false;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get token => _token;

  /// Попытка автологина при старте приложения
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final storedToken = await _storage.read(key: 'token');
    final storedIsAdmin = await _storage.read(key: 'isAdmin');

    if (storedToken != null) {
      _token = storedToken;
      _isAdmin = storedIsAdmin == 'true';
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Авторизация по логину и паролю
  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.login(username, password);

    if (result.containsKey('token')) {
      _token = result['token'];
      _isAdmin = result['is_admin'] == true;
      _isAuthenticated = true;

      await _storage.write(key: 'token', value: _token);
      await _storage.write(key: 'isAdmin', value: _isAdmin.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Выход из аккаунта
  Future<void> logout() async {
    _token = null;
    _isAdmin = false;
    _isAuthenticated = false;

    await _storage.deleteAll();

    notifyListeners();
  }
}
