import 'package:demo_app/api_service.dart';
import 'package:demo_app/product_info.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final ProductInfo product;
  final int productId;

  const DetailScreen({super.key, required this.product, required this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService apiService = ApiService();
  ProductInfo? product;
   bool isLoading = true;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }
  Future<void> fetchProductDetail() async {
    try {
      final result = await apiService.getProductDetail(widget.productId);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        product = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if(errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Center(child: Text('Error: $errorMessage')),
      );
    }
    final item = product!;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(item.image, height: 200),
            const SizedBox(height: 16),
            Text(item.description, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
