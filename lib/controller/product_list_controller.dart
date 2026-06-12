import 'package:demo_app/api_service.dart';
import 'package:demo_app/product_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductListController extends GetxController{
  final allProducts = <ProductInfo>[];
  final products = <ProductInfo>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  static const int pageSize = 8;
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    loadProducts();
    scrollController.addListener(_onScroll);
  }
  Future<void> loadProducts() async{
    try{
      isLoading.value = true;
      errorMessage.value = '';
      final result = await Get.find<ApiService>().fetchData();
      allProducts.clear();
      allProducts.addAll(result);
      products.clear();
      products.addAll(allProducts.take(pageSize));
    } catch(e){
      errorMessage.value = e.toString();
    }finally{
      isLoading.value = false;
    }
    }
  
  Future<void> loadMore() async{
    if(isLoadingMore.value) return;
    if(products.length >= allProducts.length) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    final nextLength = (products.length + pageSize).clamp(0, allProducts.length);
    products.assignAll(allProducts.take(nextLength));
    isLoadingMore.value = false;
  }
  Future<void> refreshProducts() async {
    try{
    isLoading.value = true;
    errorMessage.value = '';
    await loadProducts();
    }catch(e){
      errorMessage.value = e.toString();
  }
  }

  void _onScroll(){
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200){
      loadMore();
    }
  }
  @override
  void onClose(){
    scrollController.dispose();
    super.onClose();
  }
}