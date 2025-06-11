import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Путь к вашему AuthProvider

/// Виджет экрана входа в систему.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр AuthProvider из контекста.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Контроллеры для полей ввода логина и пароля.
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Вход в систему')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Имя пользователя'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true, // Скрываем ввод пароля
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Вызываем метод login из AuthProvider.
                authProvider.login(usernameController.text, passwordController.text);
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
