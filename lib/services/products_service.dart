// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://localhost:3000/products';

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        throw Exception('Falha ao carregar produtos');
      }
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      throw Exception('Erro de conexão');
    }
  }

  Future<bool> addProduct(String name, double price) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao adicionar produto: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Falha ao carregar produto');
      }
    } catch (e) {
      print('Erro ao buscar produto: $e');
      throw Exception('Erro de conexão');
    }
  }

  Future<bool> updateProduct(int id, String name, double price) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id/atualizar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id/delete'));

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao deletar produto: $e');
      return false;
    }
  }
}
