import 'dart:io';

class ProductData {
  final String productName;
  final String weight;
  final String weightUnit;
  final String height;
  final String heightUnit;
  final String width;
  final String widthUnit;
  final String length;
  final String lengthUnit;
  final List<File> images;
  final List<int> imageIndexes;
  final DateTime submittedAt;

  ProductData({
    required this.productName,
    required this.weight,
    required this.weightUnit,
    required this.height,
    required this.heightUnit,
    required this.width,
    required this.widthUnit,
    required this.length,
    required this.lengthUnit,
    required this.images,
    required this.imageIndexes,
    required this.submittedAt,
  });
}