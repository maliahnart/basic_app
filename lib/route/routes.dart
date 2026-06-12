// part of 'app_navigator.dart';

// enum Routes {
//   products('/'),
//   productDetail('/products/:id');

//   final String path;
//   const Routes(this.path);
// }
abstract class Routes {
  static const String products = '/';
  static const String productDetail = '/products/:id';
}