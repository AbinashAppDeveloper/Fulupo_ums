class MastercategoryModel {
  final String id;
  final String name;
  final String description;
  final String categoryImage;
  MastercategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryImage,
  });
  factory MastercategoryModel.fromJson(Map<String, dynamic> json) {
    return MastercategoryModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      categoryImage: json["icon"] ?? "",
    );
  }
}
