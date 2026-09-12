import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Fetched products: ${data['products']}'); // Debugging line

      final List products = data['products'];

      return products.map((product) => ProductModel.fromJson(product)).toList();
    }

    throw Exception('Failed to fetch products');
  }
}
