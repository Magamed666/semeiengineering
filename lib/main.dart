import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/salary_list.dart';
import 'screens/admin_panel.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) {
        final authProvider = AuthProvider();
        authProvider.tryAutoLogin(); // <-- Добавлен вызов авто-логина
        return authProvider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return authProvider.isAuthenticated
              ? (authProvider.isAdmin
              ? const AdminPanel()
              : const SalaryList())
              : const LoginScreen();
        },
      ),
    );
  }
}
