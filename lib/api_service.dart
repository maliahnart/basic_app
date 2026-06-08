import 'dart:convert';

import 'package:demo_app/product_info.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  Future<List<ProductInfo>> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => ProductInfo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ProductInfo> getProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return ProductInfo.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product detail');
    }
  }
}