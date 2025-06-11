import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Путь к вашему AuthProvider

/// Виджет экрана панели администратора.
class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр AuthProvider из контекста для кнопки выхода.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель администратора'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Вызываем метод logout из AuthProvider.
              authProvider.logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Это панель администратора.'),
      ),
    );
  }
}
