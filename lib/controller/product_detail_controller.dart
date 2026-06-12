import 'package:demo_app/api_service.dart';
import 'package:demo_app/product_info.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final product = Rxn<ProductInfo>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  late final int productId;
  @override
  void onInit() {
    super.onInit();
    productId = int.parse(Get.parameters['id']!);
    loadProductDetail();
  }
  Future<void> loadProductDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await Get.find<ApiService>().getProductDetail(productId);
      product.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  } 
}