import 'dart:convert';
import 'package:http/http.dart' as http;

class InquilinoApi {
  static const String _baseUrl = 'http://localhost:8080/ContractImovel/api/inquilinos';

  Future<List<dynamic>> listar() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Falha ao carregar inquilinos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<dynamic> buscarPorId(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Falha ao buscar inquilino: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<dynamic> inserir(Map<String, dynamic> inquilino) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquilino),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao inserir inquilino: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<dynamic> atualizar(int id, Map<String, dynamic> inquilino) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquilino),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Inquilino não encontrado');
      } else {
        throw Exception('Falha ao atualizar inquilino: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<void> remover(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Falha ao remover inquilino: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}