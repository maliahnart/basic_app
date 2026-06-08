import 'package:demo_app/detail_screen.dart';
import 'package:demo_app/product_info.dart';
import 'package:demo_app/product_screen.dart';
import 'package:go_router/go_router.dart';

part 'routes.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: Routes.products.path,
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: Routes.productDetail.path,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final product = state.extra as ProductInfo?;
        return DetailScreen(productId: int.parse(id!), product: product!);
      },
    ),
  ],
);
