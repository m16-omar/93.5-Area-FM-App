class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String packageType;
  final double price;
  final List<String> features;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.packageType,
    required this.price,
    this.features = const [],
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      packageType: json['packageType'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'packageType': packageType,
      'price': price,
      'features': features,
    };
  }
}
