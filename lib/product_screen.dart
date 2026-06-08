import 'package:demo_app/api_service.dart';
import 'package:demo_app/detail_screen.dart';
import 'package:demo_app/product_info.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService apiService = ApiService();
  List<ProductInfo> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await apiService.fetchData();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
  Future<void> refreshProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if(errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Center(child: Text('Error: $errorMessage')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: Image.network(product.image, width: 50, height: 50),
              title: Text(product.title),
              subtitle: Text('\$${product.price}'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailScreen(product: product),
                 ));
              },
            );
          },
        ),
      ),
    );
  }
}