import 'package:demo_app/detail_screen.dart';
import 'package:demo_app/product_screen.dart';
import 'package:go_router/go_router.dart';
part 'routes.dart';
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: Routes.products.path,
      builder:
          (context, state) =>
               ProductScreen(),
    ),

    GoRoute(
      path: Routes.productDetail.path,
      builder: (context, state) {
        final id = int.parse(
          state.pathParameters['id']!,
        );

        return ProductDetailScreen(
          productId: id,
        );
      },
    ),
  ],
);