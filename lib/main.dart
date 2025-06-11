import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/salary_list.dart';
import 'screens/admin_panel.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    // ChangeNotifierProvider должен быть типизирован AuthProvider
    ChangeNotifierProvider<AuthProvider>(
      // Используем фабричный конструктор для создания экземпляра AuthProvider
      create: (context) => AuthProvider(),
      // Используем const для виджета MyApp, чтобы оптимизировать перерисовки
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // ЭТА СТРОКА ДОЛЖНА БЫТЬ ТАКОЙ. УБЕДИТЕСЬ, ЧТО У НЕЕ ЕСТЬ "const" И "super.key".
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Consumer должен быть типизирован AuthProvider
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Здесь `auth` был изменен на `authProvider` для ясности.
          return authProvider.isAuthenticated
              ? (authProvider.isAdmin
              ? const AdminPanel() // Используйте const для виджетов
              : const SalaryList()) // Используйте const для виджетов
              : const LoginScreen(); // Используйте const для виджетов
        },
      ),
    );
  }
}
