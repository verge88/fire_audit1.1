import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizDataRepository {
  final String url;

  QuizDataRepository(this.url);

  Future<List<dynamic>> getData() async {
    try {
      // Выполнить запрос GET к URL
      final response = await http.get(Uri.parse(url));

      // Проверить код состояния ответа (200 указывает на успешный запрос)
      if (response.statusCode == 200) {
        // Декодировать response.bodyBytes в кодировке UTF-8
        final decodedData = utf8.decode(response.bodyBytes);

        // Преобразовать декодированные данные в JSON
        final jsonData = jsonDecode(decodedData);

        // Вернуть список данных
        return jsonData;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
