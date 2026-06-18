class Category {
  final String id;
  final String name;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '🌱',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String brand;
  final String country;
  final String packageSize;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> advantages;
  final String plantingPeriod;
  final String harvestInfo;
  final String yieldInfo;
  final String farmerResults;
  final bool isPopular;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.brand,
    required this.country,
    required this.packageSize,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.advantages,
    required this.plantingPeriod,
    required this.harvestInfo,
    required this.yieldInfo,
    required this.farmerResults,
    this.isPopular = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var advantagesJson = json['advantages'];
    List<String> advList = [];
    if (advantagesJson is List) {
      advList = advantagesJson.map((e) => e.toString()).toList();
    } else if (advantagesJson is String) {
      advList = advantagesJson.split('\n').where((s) => s.trim().isNotEmpty).toList();
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      packageSize: json['package_size']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      advantages: advList,
      plantingPeriod: json['planting_period']?.toString() ?? '',
      harvestInfo: json['harvest_info']?.toString() ?? '',
      yieldInfo: json['yield_info']?.toString() ?? '',
      farmerResults: json['farmer_results']?.toString() ?? '',
      isPopular: json['is_popular'] == true,
    );
  }
}
