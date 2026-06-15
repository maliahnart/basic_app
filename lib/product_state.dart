import 'package:demo_app/model/product_info.dart';

class ProductState {
  final List<Product> products;

  final bool isLoading;

  final bool isLoadingMore;

  final bool hasMore;

  final String? error;

  final int skip;

  const ProductState({
    required this.products,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.error,
    required this.skip,
  });

  factory ProductState.initial() {
    return const ProductState(
      products: [],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      error: null,
      skip: 0,
    );
  }

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    int? skip,
  }) {
    return ProductState(
      products:
          products ?? this.products,
      isLoading:
          isLoading ??
          this.isLoading,
      isLoadingMore:
          isLoadingMore ??
          this.isLoadingMore,
      hasMore:
          hasMore ?? this.hasMore,
      error: error,
      skip: skip ?? this.skip,
    );
  }
}