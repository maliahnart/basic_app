import 'package:flutter_test/flutter_test.dart';
import 'package:demo_app/model/product_response.dart';

void main() {
  test('Test parsing ProductResponse', () {
    final mockJson = {
      'products': [
        {
          'id': 1,
          'title': 'Test Product',
          'description': 'A description',
          'price': 12.99,
          'thumbnail': 'thumb.png'
        }
      ],
      'total': 1,
      'skip': 0,
      'limit': 10
    };

    expect(() => ProductResponse.fromJson(mockJson), returnsNormally);
  });
}
