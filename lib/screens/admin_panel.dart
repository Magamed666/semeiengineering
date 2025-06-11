import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/salary.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<List<Salary>> _salaries;

  @override
  void initState() {
    super.initState();
    _loadSalaries();
  }

  void _loadSalaries() {
    setState(() {
      _salaries = ApiService().fetchSalaries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель администратора'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSalaries,
          ),
        ],
      ),
      body: FutureBuilder<List<Salary>>(
        future: _salaries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }

          final salaries = snapshot.data!;
          return ListView.builder(
            itemCount: salaries.length,
            itemBuilder: (context, index) {
              final salary = salaries[index];
              return ListTile(
                title: Text('${salary.employeeName} — ${salary.amount} ₸'),
                subtitle: Text(salary.date),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // TODO: реализовать удаление
                  },
                ),
                onTap: () {
                  // TODO: реализовать редактирование
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: реализовать добавление
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
