part of 'app_navigator.dart';

enum Routes {
  products('/'),
  productDetail('/products/:id');

  final String path;
  const Routes(this.path);
}
