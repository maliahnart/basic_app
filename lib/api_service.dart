import 'dart:convert';

import 'package:demo_app/model/product_info.dart';
import 'package:demo_app/model/product_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<ProductResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    print('service start');
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'),
    );
    print('after http');
    print("Status: ${response.body}");
    final data = jsonDecode(response.body);
    print('after decode');
    print('before parse');
    final result = ProductResponse.fromJson(data);
    print('after parse');
    print(data.runtimeType);
    print(data.keys);
    return result;
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/$id'),
    );
    return Product.fromJson(jsonDecode(response.body));
  }
}
