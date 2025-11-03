class StoreModel {
  final String id;
  final String storeName;

  StoreModel({required this.id, required this.storeName});

  // ✅ Factory method to parse JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json["_id"] ?? "",
      storeName: json["store_name"] ?? "",
    );
  }

  // ✅ Convert back to JSON (optional for future)
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "store_name": storeName,
    };
  }
}
