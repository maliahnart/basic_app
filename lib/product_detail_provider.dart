import 'package:demo_app/model/product_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_provider.dart';

final productDetailProvider =
    FutureProvider.family<
      Product,
      int
    >((ref, id) {
      return ref
          .read(productServiceProvider)
          .getProductById(id);
    });