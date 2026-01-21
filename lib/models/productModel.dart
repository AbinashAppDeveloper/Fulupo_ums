class ProductModel {
  final String id;
  final String name;
  final String productCode;
  final Category categoryId; // 👈 Change from String → Category
  final String productImage;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.productCode,
    required this.categoryId,
    required this.productImage,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      productCode: json["productCode"] ?? "",
      categoryId: Category.fromJson(json["categoryId"] ?? {}), // ✅ nested object
      productImage: json["productImage"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "productCode": productCode,
      "categoryId": categoryId.toJson(),
      "productImage": productImage,
      "description": description,
    };
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
    };
  }
}
