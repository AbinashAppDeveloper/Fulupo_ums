class ProductModel {
  final String id;
  final String name;
  final String productCode;
  final String categoryId;
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
      categoryId: json["categoryId"] ?? "",
      productImage: json["productImage"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "productCode": productCode,
      "categoryId": categoryId,
      "productImage": productImage,
      "description": description,
    };
  }
}
