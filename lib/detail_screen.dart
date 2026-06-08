import 'package:demo_app/product_info.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final ProductInfo product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.image, height: 200),
            const SizedBox(height: 16),
            Text(product.description, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
