class ProductInfo {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;

  ProductInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}