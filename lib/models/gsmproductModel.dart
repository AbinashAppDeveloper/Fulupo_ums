class Gsmproductmodel {
  final String id;
  final String productCode;
  final String name;
  final List<String> dimensionImages;
  final MasterProduct? masterProductId;
  final String netQty;
  final String height;
  final String width;
  final String length;
  final CreatedBy? createdBy;
  final DateTime? createdAt;

  Gsmproductmodel({
    required this.id,
    required this.productCode,
    required this.name,
    required this.dimensionImages,
    this.masterProductId,
    required this.netQty,
    required this.height,
    required this.width,
    required this.length,
    this.createdBy,
    this.createdAt,
  });

  factory Gsmproductmodel.fromJson(Map<String, dynamic> json) {
    return Gsmproductmodel(
      id: json['_id'] ?? '',
      productCode: json['productCode'] ?? '',
      name: json['name'] ?? '',
      dimensionImages: List<String>.from(json['dimenstionImages'] ?? []),
      masterProductId: json['masterProductId'] is Map<String, dynamic>
          ? MasterProduct.fromJson(json['masterProductId'])
          : null,
      netQty: json['netQty'] ?? '',
      height: json['height'] ?? '',
      width: json['width'] ?? '',
      length: json['length'] ?? '',
      createdBy: json['createdBy'] is Map<String, dynamic>
          ? CreatedBy.fromJson(json['createdBy'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productCode': productCode,
      'name': name,
      'dimenstionImages': dimensionImages,
      'masterProductId': masterProductId?.toJson(),
      'netQty': netQty,
      'height': height,
      'width': width,
      'length': length,
      'createdBy': createdBy?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class MasterProduct {
  final String id;
  final String name;
  final String productCode;

  MasterProduct({
    required this.id,
    required this.name,
    required this.productCode,
  });

  factory MasterProduct.fromJson(Map<String, dynamic> json) {
    return MasterProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      productCode: json['productCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'productCode': productCode,
    };
  }
}

class CreatedBy {
  final String id;
  final String name;

  CreatedBy({
    required this.id,
    required this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
