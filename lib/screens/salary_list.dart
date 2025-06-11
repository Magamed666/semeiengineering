import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

/// Виджет экрана списка зарплат (для обычных пользователей).
class SalaryList extends StatelessWidget {
  const SalaryList({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список зарплат'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Это экран списка зарплат для обычных пользователей.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ApiService().downloadFile('/salaries/export/pdf', 'salaries.pdf');
                  messenger.showSnackBar(
                    const SnackBar(content: Text('PDF успешно загружен')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Ошибка при загрузке PDF: $e')),
                  );
                }
              },
              child: const Text('Скачать PDF'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ApiService().downloadFile('/salaries/export/excel', 'salaries.xlsx');
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Excel успешно загружен')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Ошибка при загрузке Excel: $e')),
                  );
                }
              },
              child: const Text('Скачать Excel'),
            ),
          ],
        ),
      ),
    );
  }
}
