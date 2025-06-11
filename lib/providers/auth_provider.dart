import 'package:flutter/foundation.dart'; // Для ChangeNotifier

/// Класс AuthProvider управляет состоянием аутентификации пользователя.
/// Он расширяет ChangeNotifier, позволяя виджетам слушать изменения.
class AuthProvider with ChangeNotifier {
  // Приватные переменные для хранения состояния аутентификации и администратора.
  // Инициализированы как false по умолчанию.
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  /// Геттер для получения состояния аутентификации.
  bool get isAuthenticated => _isAuthenticated;

  /// Геттер для получения состояния администратора.
  bool get isAdmin => _isAdmin;

  /// Метод для имитации входа в систему.
  /// Обновляет состояние и уведомляет слушателей.
  void login(String username, String password) {
    // Здесь должна быть ваша реальная логика аутентификации (например, вызов API).
    // Для примера:
    if (username == 'admin' && password == 'admin123') {
      _isAuthenticated = true;
      _isAdmin = true;
    } else if (username == 'user' && password == 'user123') {
      _isAuthenticated = true;
      _isAdmin = false;
    } else {
      _isAuthenticated = false;
      _isAdmin = false;
    }
    // Уведомляем всех, кто слушает этот провайдер, о том, что данные изменились.
    notifyListeners();
  }

  /// Метод для имитации выхода из системы.
  /// Сбрасывает состояние и уведомляет слушателей.
  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    notifyListeners();
  }
}
