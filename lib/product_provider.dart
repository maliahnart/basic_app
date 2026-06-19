import 'package:demo_app/api_service.dart';
import 'package:demo_app/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final productServiceProvider = Provider<ApiService>((ref) => ApiService());
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(ref.read(productServiceProvider)),
);

class ProductNotifier extends StateNotifier<ProductState> {
  final ApiService _service;
  ProductNotifier(this._service) : super(ProductState.initial()) {
    loadProducts();
  }

  static const limit = 10;

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _service.getProducts(limit: limit, skip: 0);

      state = state.copyWith(
        products: response.products,
        skip: response.products.length,
        hasMore: response.products.length < response.total,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    try {
      state = state.copyWith(isLoadingMore: true);

      final response = await _service.getProducts(
        limit: limit,
        skip: state.skip,
      );

      final allProducts = [...state.products, ...response.products];

      state = state.copyWith(
        products: allProducts,
        skip: allProducts.length,
        hasMore: allProducts.length < response.total,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}
