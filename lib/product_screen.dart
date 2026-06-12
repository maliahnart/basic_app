import 'package:demo_app/controller/product_list_controller.dart';
import 'package:demo_app/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  final controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('products'.tr),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'vi') {
                Get.updateLocale(const Locale('vi', 'VN'));
              }

              if (value == 'en') {
                Get.updateLocale(const Locale('en', 'US'));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
              const PopupMenuItem(value: 'en', child: Text('English')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                ElevatedButton(
                  onPressed: controller.refreshProducts,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshProducts,
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount:
                controller.products.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.products.length) {
                final item = controller.products[index];
                return CustomProductCard(
                  product: item,
                  onTap: () {
                    Get.toNamed('/products/${item.id}');
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
