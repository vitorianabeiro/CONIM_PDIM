import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<Map<String, dynamic>?> fetchSettings() async {
    final res = await http.get(Uri.parse("$baseUrl/settings"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<bool> saveSettings(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse("$baseUrl/settings"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
