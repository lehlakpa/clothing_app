class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String thumbnail;
  final String? category; // Optional field for category

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.thumbnail,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      thumbnail: json['thumbnail'],
      category: json['category'],
    );
  }
}
