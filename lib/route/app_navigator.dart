import 'package:demo_app/controller/product_detail_controller.dart';
import 'package:demo_app/detail_screen.dart';
import 'package:demo_app/product_screen.dart';
import 'package:demo_app/route/routes.dart';
import 'package:get/get.dart';


class AppPages{
  static final router = [
    GetPage(
      name: Routes.products,
      page: () =>  ProductScreen(),
    ),
    GetPage(
      name: Routes.productDetail,
      page: () => ProductDetailPage(),
      binding: BindingsBuilder((){
        Get.lazyPut<ProductDetailController>(() => ProductDetailController());
      })
      ),
  ];
}
