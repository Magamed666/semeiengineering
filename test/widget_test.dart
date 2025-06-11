import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart'; // Нужно для тестирования виджетов, использующих Provider

import 'package:salary_app/main.dart'; // Ваш основной файл приложения
import 'package:salary_app/providers/auth_provider.dart'; // Ваш провайдер аутентификации
import 'package:salary_app/screens/login_screen.dart'; // Ваш экран входа

void main() {
  // Группа тестов для вашего приложения
  group('Salary App Tests', () {
    // Тест для проверки начального экрана (LoginScreen)
    testWidgets('App starts on LoginScreen and shows login elements', (WidgetTester tester) async {
      // Инициализируем наше приложение с провайдером для тестирования
      // Оборачиваем MyApp в ChangeNotifierProvider, чтобы Provider мог быть найден
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          child: const MyApp(), // Убедитесь, что MyApp имеет const конструктор
        ),
      );

      // Ожидаем, что увидим 'Вход в систему' на AppBar LoginScreen
      expect(find.text('Вход в систему'), findsOneWidget);

      // Ожидаем, что увидим поля ввода для имени пользователя и пароля
      expect(find.widgetWithText(TextField, 'Имя пользователя'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Пароль'), findsOneWidget);

      // Ожидаем, что увидим кнопку 'Войти'
      expect(find.widgetWithText(ElevatedButton, 'Войти'), findsOneWidget);
    });

    // Тест для проверки успешного входа администратора
    testWidgets('Admin login successfully navigates to AdminPanel', (WidgetTester tester) async {
      // Инициализируем приложение с провайдером
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          child: const MyApp(),
        ),
      );

      // Вводим имя пользователя и пароль администратора
      await tester.enterText(find.widgetWithText(TextField, 'Имя пользователя'), 'admin');
      await tester.enterText(find.widgetWithText(TextField, 'Пароль'), 'admin123');

      // Нажимаем кнопку "Войти"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));

      // Перестраиваем виджеты после нажатия кнопки, чтобы UI обновился
      await tester.pumpAndSettle(); // Используем pumpAndSettle для обработки всех анимаций и перестроек

      // Ожидаем, что теперь видим "Панель администратора"
      expect(find.text('Панель администратора'), findsOneWidget);
      // И что LoginScreen больше не виден
      expect(find.text('Вход в систему'), findsNothing);
    });

    // Тест для проверки успешного входа обычного пользователя
    testWidgets('User login successfully navigates to SalaryList', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          child: const MyApp(),
        ),
      );

      // Вводим имя пользователя и пароль обычного пользователя
      await tester.enterText(find.widgetWithText(TextField, 'Имя пользователя'), 'user');
      await tester.enterText(find.widgetWithText(TextField, 'Пароль'), 'user123');

      // Нажимаем кнопку "Войти"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));

      await tester.pumpAndSettle();

      // Ожидаем, что теперь видим "Список зарплат"
      expect(find.text('Список зарплат'), findsOneWidget);
      expect(find.text('Вход в систему'), findsNothing);
    });

    // Тест для проверки неудачного входа
    testWidgets('Failed login keeps user on LoginScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          child: const MyApp(),
        ),
      );

      // Вводим неверные учетные данные
      await tester.enterText(find.widgetWithText(TextField, 'Имя пользователя'), 'wronguser');
      await tester.enterText(find.widgetWithText(TextField, 'Пароль'), 'wrongpass');

      // Нажимаем кнопку "Войти"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));

      await tester.pumpAndSettle();

      // Ожидаем, что по-прежнему видим "Вход в систему"
      expect(find.text('Вход в систему'), findsOneWidget);
      // И не видим ни панель администратора, ни список зарплат
      expect(find.text('Панель администратора'), findsNothing);
      expect(find.text('Список зарплат'), findsNothing);
    });
  });
}
