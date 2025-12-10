import 'dart:convert';
import 'package:http/http.dart' as http;

class InquilinoApi {
  final String baseUrl = "http://localhost:8080/ContractImovel/api";

  Future<List<dynamic>> listar() async {
    final url = Uri.parse("$baseUrl/inquilinos");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao listar inquilinos: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> buscar({required int id}) async {
    final url = Uri.parse("$baseUrl/inquilinos/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Inquilino não encontrado");
    } else {
      throw Exception("Erro ao buscar inquilino: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> inserir(Map<String, dynamic> inquilino) async {
    final url = Uri.parse("$baseUrl/inquilinos");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(inquilino),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao inserir inquilino: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> atualizar(int id, Map<String, dynamic> inquilino) async {
    final url = Uri.parse("$baseUrl/inquilinos/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(inquilino),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Inquilino não encontrado");
    } else {
      throw Exception("Erro ao atualizar inquilino: ${response.statusCode}");
    }
  }

  Future<void> remover(int id) async {
    final url = Uri.parse("$baseUrl/inquilinos/$id");
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception("Erro ao remover inquilino: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> buscarPorNome(String nome) async {
    final url = Uri.parse("$baseUrl/inquilinos?nome=$nome");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar inquilinos por nome: ${response.statusCode}");
    }
  }

}