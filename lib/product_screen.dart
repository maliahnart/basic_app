import 'package:demo_app/api_service.dart';
import 'package:demo_app/custom_card.dart';
import 'package:demo_app/product_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService apiService = ApiService();
  List<ProductInfo> allproducts = [];
  List<ProductInfo> visibleProducts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? errorMessage;
  static const int pageSize = 8;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final fetchedProducts = await apiService.fetchData();
      allproducts = fetchedProducts;
      visibleProducts.clear();
      visibleProducts.addAll(allproducts.take(pageSize));
    } catch (e) {
        errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;
    if (visibleProducts.length >= allproducts.length) return;
    setState(() {
      isLoadingMore = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    final nextLength = (visibleProducts.length + pageSize).clamp(
      0,
      allproducts.length,
    );
    visibleProducts.clear();
    visibleProducts.addAll(allproducts.take(nextLength));
    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: refreshProducts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 85, 129, 94),
      appBar: AppBar(title: const Text('Products')),
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: visibleProducts.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= visibleProducts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final product = visibleProducts[index];
            return CustomProductCard(
              product: product,
              onTap: () {
                context.push('/products/${product.id}', extra: product);
              },
            );
          },
        ),
      ),
    );
  }
}
