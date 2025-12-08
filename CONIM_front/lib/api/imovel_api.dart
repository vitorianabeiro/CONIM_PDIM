import 'dart:convert';
import 'package:http/http.dart' as http;

class ImovelApi {
  final String baseUrl = "http://localhost:8080/ContractImovel/api"; 

  // ------------------------------
  // LISTAR TODOS
  // ------------------------------
  Future<List<dynamic>> listar() async {
    final url = Uri.parse("$baseUrl/imoveis");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao listar imóveis: ${response.statusCode}");
    }
  }

  // ------------------------------
  // LISTAR DISPONÍVEIS
  // ------------------------------
  Future<List<dynamic>> listarDisponiveis() async {
    final url = Uri.parse("$baseUrl/imoveis/disponiveis");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao listar imóveis disponíveis: ${response.statusCode}");
    }
  }

  // ------------------------------
  // BUSCAR POR ID
  // ------------------------------
  Future<Map<String, dynamic>> buscar({required int id}) async {
    final url = Uri.parse("$baseUrl/imoveis/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar imóvel: ${response.statusCode}");
    }
  }

  // ------------------------------
  // INSERIR
  // ------------------------------
  Future<Map<String, dynamic>> inserir(Map<String, dynamic> imovel) async {
    final url = Uri.parse("$baseUrl/imoveis");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(imovel),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao inserir imóvel: ${response.statusCode}");
    }
  }

  // ------------------------------
  // ATUALIZAR
  // ------------------------------
  Future<Map<String, dynamic>> atualizar(int id, Map<String, dynamic> imovel) async {
    final url = Uri.parse("$baseUrl/imoveis/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(imovel),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao atualizar imóvel: ${response.statusCode}");
    }
  }

  // ------------------------------
  // REMOVER
  // ------------------------------
  Future<void> remover(int id) async {
    final url = Uri.parse("$baseUrl/imoveis/$id");
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception("Erro ao remover imóvel: ${response.statusCode}");
    }
  }
}
