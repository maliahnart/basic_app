import 'package:get/get.dart';

class AppTranslation extends Translations{
   @override
   Map<String, Map<String,String>> get keys => {
    'en_US': {
      'products': 'Products',
      'product_detail': 'Product Detail',
      'retry': 'Retry',
      'Product Screen': 'Product Screen',
    },
    'vi_VN': {
      'products': 'Sản phẩm',
      'product_detail': 'Chi tiết sản phẩm',
      'retry': 'Thử lại',
      'Product Screen': 'Màn hình Sản phẩm',
    },
   };
}