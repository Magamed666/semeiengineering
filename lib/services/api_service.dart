import 'dart:convert';
import 'dart:io'; // Добавлен для работы с файлами
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // Добавлен для получения директорий
import 'package:open_filex/open_filex.dart'; // Добавлен для открытия файлов
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Предполагается, что вы используете это для хранения токена
import '../models/salary.dart';

// Создаем экземпляр SecureStorage, если он еще не создан
// Это должно быть сделано где-то глобально или передано в ApiService
const FlutterSecureStorage storage = FlutterSecureStorage();

class ApiService {
  final String baseUrl = 'http://<YOUR_BACKEND_IP>:8000'; // Замени IP

  // Статический метод для логина, как и раньше
  static Future<Map<String, dynamic>> login(String username, String password) async {
    // Внимание: Здесь используется статический baseUrl, если вы хотите использовать baseUrl экземпляра,
    // вам нужно будет изменить этот метод на нестатический или передать baseUrl.
    // Для простоты я оставляю его статическим и использую константный baseUrl.
    // Если вы хотите использовать baseUrl экземпляра для логина, сделайте метод нестатическим.
    const String staticBaseUrl = 'http://<YOUR_BACKEND_IP>:8000'; // Дублируем для статического метода
    final res = await http.post(
      Uri.parse('$staticBaseUrl/auth/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return {};
    }
  }

  // Метод для получения зарплат, теперь он будет нестатическим, если вы хотите использовать baseUrl экземпляра
  // или использовать токен из storage.
  // Для согласованности с методом downloadFile, этот метод теперь будет получать токен из secure_storage.
  Future<List<Salary>> fetchSalaries() async {
    final token = await storage.read(key: 'token'); // Получаем токен из secure_storage
    if (token == null) {
      // Обработка случая, если токен не найден (например, пользователь не авторизован)
      throw Exception('Токен авторизации не найден.');
    }

    final res = await http.get(
      Uri.parse('$baseUrl/salaries'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Salary.fromJson(e)).toList();
    } else {
      // Добавлена более информативная обработка ошибок
      throw Exception('Ошибка при получении зарплат: ${res.statusCode}');
    }
  }

  // Метод для загрузки файлов
  Future<String> downloadFile(String endpoint, String filename) async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Токен авторизации не найден.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file.path; // возвращаем путь
    } else {
      throw Exception('Ошибка загрузки файла: ${response.statusCode}');
    }
  }
}

// Здесь вы можете добавить другие методы, например, для админки
// static Future<Map<String, dynamic>> adminAction(...) { ... }
