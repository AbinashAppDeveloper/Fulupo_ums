// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fulupo_ums/models/productDetails.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:fulupo_ums/pages/drawer.dart';
// import 'package:fulupo_ums/util/colors.dart';
// import 'package:fulupo_ums/util/style.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   // Static list to store all submitted products
//   static List<ProductData> submittedProducts = [];

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _unitController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _widthController = TextEditingController();
//   final TextEditingController _lengthController = TextEditingController();

//   List<File> _images = [];
//   bool isLoading = false;

//   String _selectedWeightUnit = 'kg';
//   String _selectedHeightUnit = 'cm';
//   String _selectedWidthUnit = 'cm';
//   String _selectedLengthUnit = 'cm';

//   List<int> savedImageIndexes = [];

//   Future<void> _pickImageFromCamera() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? photo = await picker.pickImage(source: ImageSource.camera);

//     if (photo == null) return;

//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: photo.path,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: AppColor.whiteColor,
//           toolbarWidgetColor: Colors.black,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(title: 'Crop Image'),
//       ],
//     );

//     if (croppedFile != null) {
//       setState(() {
//         _images.add(File(croppedFile.path));
//       });
//     }
//   }

//   Future<void> _pickImagesFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile> pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles.isEmpty) return;

//     for (var file in pickedFiles) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: file.path,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: AppColor.whiteColor,
//             toolbarWidgetColor: Colors.black,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           IOSUiSettings(title: 'Crop Image'),
//         ],
//       );

//       if (croppedFile != null) {
//         setState(() {
//           _images.add(File(croppedFile.path));
//         });
//       }
//     }
//   }

//   void _showImageSourcePicker() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: AppColor.greenColor,
//                     shape: BoxShape.circle,
//                     // boxShadow: [
//                     //   BoxShadow(
//                     //     color: Colors.black.withOpacity(0.2),
//                     //     blurRadius: 4,
//                     //     offset: Offset(2, 2),
//                     //   ),
//                     // ],
//                   ),
//                   child: Icon(Icons.camera_alt, color: AppColor.whiteColor),
//                 ),
//                 title: Text(
//                   "Take Photo",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textScaler: TextScaler.linear(1),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImageFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: AppColor.greenColor,
//                     shape: BoxShape.circle,
//                     // boxShadow: [
//                     //   BoxShadow(
//                     //     color: Colors.black.withOpacity(0.2),
//                     //     blurRadius: 4,
//                     //     offset: Offset(2, 2),
//                     //   ),
//                     // ],
//                   ),
//                   child: Icon(Icons.photo_library, color: AppColor.whiteColor),
//                 ),
//                 title: Text(
//                   "Choose from Gallery",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textScaler: TextScaler.linear(1),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImagesFromGallery();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Future<void> _showFinishDialog() {
//   //   return showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: Text(
//   //           "Product Details",
//   //           style: TextStyle(fontSize: 25),
//   //           textScaler: TextScaler.linear(1),
//   //         ),
//   //         content: SingleChildScrollView(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               TextField(
//   //                 controller: _productNameController,
//   //                 decoration: InputDecoration(
//   //                   labelText: "Product Name",
//   //                   labelStyle: TextStyle(
//   //                     fontSize: MediaQuery.textScalerOf(context).scale(11),
//   //                   ),
//   //                   contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                   border: OutlineInputBorder(),
//   //                 ),
//   //               ),
//   //               SizedBox(height: 16),

//   //               Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Expanded(
//   //                     flex: 3,
//   //                     child: TextField(
//   //                       controller: _unitController,
//   //                       decoration: InputDecoration(
//   //                         labelText: "Weight",
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(11),
//   //                         ),
//   //                         contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       keyboardType: TextInputType.numberWithOptions(
//   //                         decimal: true,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   const SizedBox(width: 12),
//   //                   Expanded(
//   //                     flex: 2,
//   //                     child: DropdownButtonFormField<String>(
//   //                       value: _selectedWeightUnit,
//   //                       decoration: InputDecoration(
//   //                         labelText: 'Unit',
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(10),
//   //                         ),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       items: const [
//   //                         DropdownMenuItem(
//   //                           value: 'kg',
//   //                           child: Text('kg', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'gm',
//   //                           child: Text('gm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'lb',
//   //                           child: Text('lb', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'oz',
//   //                           child: Text('oz', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'No.',
//   //                           child: Text(
//   //                             'No.',
//   //                             textScaler: TextScaler.linear(1),
//   //                           ),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'mL',
//   //                           child: Text('mL', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'L',
//   //                           child: Text('L', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'gal',
//   //                           child: Text(
//   //                             'gal',
//   //                             textScaler: TextScaler.linear(1),
//   //                           ),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'fl oz',
//   //                           child: Text(
//   //                             'fl oz',
//   //                             textScaler: TextScaler.linear(1),
//   //                           ),
//   //                         ),
//   //                       ],
//   //                       onChanged: (value) {
//   //                         if (value != null) {
//   //                           setState(() {
//   //                             _selectedWeightUnit = value;
//   //                           });
//   //                         }
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //               SizedBox(height: 16),

//   //               Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Expanded(
//   //                     flex: 3,
//   //                     child: TextField(
//   //                       controller: _heightController,
//   //                       decoration: InputDecoration(
//   //                         labelText: "Height",
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(12),
//   //                         ),
//   //                         contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       keyboardType: TextInputType.numberWithOptions(
//   //                         decimal: true,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   const SizedBox(width: 12),
//   //                   Expanded(
//   //                     flex: 2,
//   //                     child: DropdownButtonFormField<String>(
//   //                       value: _selectedHeightUnit,
//   //                       decoration: InputDecoration(
//   //                         labelText: 'Unit',
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(10),
//   //                         ),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       items: const [
//   //                         DropdownMenuItem(
//   //                           value: 'cm',
//   //                           child: Text('cm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'm',
//   //                           child: Text('m', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'mm',
//   //                           child: Text('mm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'in',
//   //                           child: Text('in', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'ft',
//   //                           child: Text('ft', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                       ],
//   //                       onChanged: (value) {
//   //                         if (value != null) {
//   //                           setState(() {
//   //                             _selectedHeightUnit = value;
//   //                           });
//   //                         }
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //               SizedBox(height: 16),

//   //               Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Expanded(
//   //                     flex: 3,
//   //                     child: TextField(
//   //                       controller: _widhtController,
//   //                       decoration: InputDecoration(
//   //                         labelText: "Width",
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(12),
//   //                         ),
//   //                         contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       keyboardType: TextInputType.numberWithOptions(
//   //                         decimal: true,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   const SizedBox(width: 12),
//   //                   Expanded(
//   //                     flex: 2,
//   //                     child: DropdownButtonFormField<String>(
//   //                       value: _selectedWidthUnit,
//   //                       decoration: InputDecoration(
//   //                         labelText: 'Unit',
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(10),
//   //                         ),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       items: const [
//   //                         DropdownMenuItem(
//   //                           value: 'cm',
//   //                           child: Text('cm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'm',
//   //                           child: Text('m', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'mm',
//   //                           child: Text('mm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'in',
//   //                           child: Text('in', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'ft',
//   //                           child: Text('ft', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                       ],
//   //                       onChanged: (value) {
//   //                         if (value != null) {
//   //                           setState(() {
//   //                             _selectedWidthUnit = value;
//   //                           });
//   //                         }
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //               SizedBox(height: 16),

//   //               Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Expanded(
//   //                     flex: 3,
//   //                     child: TextField(
//   //                       controller: _lenghtController,
//   //                       decoration: InputDecoration(
//   //                         labelText: "Length",
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(12),
//   //                         ),
//   //                         contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       keyboardType: TextInputType.numberWithOptions(
//   //                         decimal: true,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   const SizedBox(width: 12),
//   //                   Expanded(
//   //                     flex: 2,
//   //                     child: DropdownButtonFormField<String>(
//   //                       value: _selectLenghtUnit,
//   //                       decoration: InputDecoration(
//   //                         labelText: 'Unit',
//   //                         labelStyle: TextStyle(
//   //                           fontSize: MediaQuery.textScalerOf(
//   //                             context,
//   //                           ).scale(10),
//   //                         ),
//   //                         contentPadding: EdgeInsets.symmetric(vertical: 8),
//   //                         border: OutlineInputBorder(),
//   //                         isDense: true,
//   //                       ),
//   //                       items: const [
//   //                         DropdownMenuItem(
//   //                           value: 'cm',
//   //                           child: Text('cm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'm',
//   //                           child: Text('m', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'mm',
//   //                           child: Text('mm', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'in',
//   //                           child: Text('in', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                         DropdownMenuItem(
//   //                           value: 'ft',
//   //                           child: Text('ft', textScaler: TextScaler.linear(1)),
//   //                         ),
//   //                       ],
//   //                       onChanged: (value) {
//   //                         if (value != null) {
//   //                           setState(() {
//   //                             _selectLenghtUnit = value;
//   //                           });
//   //                         }
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text("Cancel", textScaler: TextScaler.linear(1)),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               final productName = _productNameController.text.trim();
//   //               final unitText = _unitController.text.trim();
//   //               final heightText = _heightController.text.trim();
//   //               final widthText = _widhtController.text.trim();
//   //               final lengthText = _lenghtController.text.trim();

//   //               if (productName.isEmpty ||
//   //                   unitText.isEmpty ||
//   //                   heightText.isEmpty ||
//   //                   widthText.isEmpty ||
//   //                   lengthText.isEmpty) {
//   //                 ScaffoldMessenger.of(context).showSnackBar(
//   //                   SnackBar(
//   //                     content: Text(
//   //                       "Please fill all fields",
//   //                       textScaler: TextScaler.linear(1),
//   //                     ),
//   //                   ),
//   //                 );
//   //                 return;
//   //               }

//   //               if (_selectedHeightUnit != _selectedWidthUnit ||
//   //                   _selectedHeightUnit != _selectLenghtUnit ||
//   //                   _selectedWidthUnit != _selectLenghtUnit) {
//   //                 ScaffoldMessenger.of(context).showSnackBar(
//   //                   SnackBar(
//   //                     content: Text(
//   //                       "Height, Width, and Length units must all be the same",
//   //                       textScaler: TextScaler.linear(1),
//   //                     ),
//   //                   ),
//   //                 );
//   //                 return;
//   //               }

//   //               int startIndex = savedImageIndexes.isNotEmpty
//   //                   ? savedImageIndexes.last + 1
//   //                   : 1;

//   //               List<int> currentIndexes = List.generate(
//   //                 _images.length,
//   //                 (index) => startIndex + index,
//   //               );

//   //               savedImageIndexes.addAll(currentIndexes);

//   //               final productData = ProductData(
//   //                 productName: productName,
//   //                 weight: unitText,
//   //                 weightUnit: _selectedWeightUnit,
//   //                 height: heightText,
//   //                 heightUnit: _selectedHeightUnit,
//   //                 width: widthText,
//   //                 widthUnit: _selectedWidthUnit,
//   //                 length: lengthText,
//   //                 lengthUnit: _selectLenghtUnit,
//   //                 images: List.from(_images),
//   //                 imageIndexes: List.from(currentIndexes),
//   //                 submittedAt: DateTime.now(),
//   //               );

//   //               Homepage.submittedProducts.add(productData);

//   //               print("Saved Image Indexes: $savedImageIndexes");
//   //               print("Product Name: $productName");
//   //               print("Weight: $unitText $_selectedWeightUnit");
//   //               print("Height: $heightText $_selectedHeightUnit");
//   //               print("Width: $widthText $_selectedWidthUnit");
//   //               print("Length: $lengthText $_selectLenghtUnit");
//   //               print("Images selected:");
//   //               for (int i = 0; i < _images.length; i++) {
//   //                 print("Image ${i + 1}: ${_images[i].path}");
//   //               }

//   //               // Clear form fields
//   //               _productNameController.clear();
//   //               _unitController.clear();
//   //               _heightController.clear();
//   //               _widhtController.clear();
//   //               _lenghtController.clear();

//   //               // Reset dropdown values
//   //               setState(() {
//   //                 _selectedWeightUnit = 'kg';
//   //                 _selectedHeightUnit = 'cm';
//   //                 _selectedWidthUnit = 'cm';
//   //                 _selectLenghtUnit = 'cm';
//   //               });

//   //               // Clear images after successful submission
//   //               setState(() {
//   //                 _images.clear();
//   //               });

//   //               Navigator.of(context).pop();

//   //               ScaffoldMessenger.of(context).showSnackBar(
//   //                 SnackBar(
//   //                   content: Text(
//   //                     "Product submitted successfully!",
//   //                     textScaler: TextScaler.linear(1),
//   //                   ),
//   //                 ),
//   //               );
//   //             },
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor: AppColor.greenColor,
//   //             ),
//   //             child: Text(
//   //               "Submit",
//   //               style: TextStyle(color: AppColor.whiteColor),
//   //               textScaler: TextScaler.linear(1),
//   //               // Removed textScaler here as Text widget doesn't support it by default
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   Future<void> _showFinishDialog() {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         final screenSize = MediaQuery.of(context).size;
//         final isSmallScreen = screenSize.width < 600;
//         final textScaler = MediaQuery.textScalerOf(context);

//         return AlertDialog(
//           title: Text(
//             "Product Details",
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 25,
//               fontWeight: FontWeight.bold,
//             ),
//             textScaler: TextScaler.linear(1),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: isSmallScreen ? 16 : 24,
//             vertical: 20,
//           ),
//           content: Container(
//             width: double.maxFinite,
//             constraints: BoxConstraints(
//               maxHeight: screenSize.height * 0.7,
//               maxWidth: isSmallScreen ? screenSize.width * 0.9 : 500,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Product Name Field
//                   _buildTextField(
//                     controller: _productNameController,
//                     labelText: "Product Name",
//                     isSmallScreen: isSmallScreen,
//                     textScaler: textScaler,
//                   ),
//                   SizedBox(height: isSmallScreen ? 12 : 16),

//                   // Weight Section
//                   _buildMeasurementRow(
//                     controller: _unitController,
//                     labelText: "Weight",
//                     selectedUnit: _selectedWeightUnit,
//                     units: const [
//                       'kg',
//                       'gm',
//                       'lb',
//                       'oz',
//                       'No.',
//                       'mL',
//                       'L',
//                       'gal',
//                       'fl oz',
//                     ],
//                     onUnitChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedWeightUnit = value;
//                         });
//                       }
//                     },
//                     isSmallScreen: isSmallScreen,
//                     textScaler: textScaler,
//                   ),
//                   SizedBox(height: isSmallScreen ? 12 : 16),

//                   // Height Section
//                   _buildMeasurementRow(
//                     controller: _heightController,
//                     labelText: "Height",
//                     selectedUnit: _selectedHeightUnit,
//                     units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                     onUnitChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedHeightUnit = value;
//                         });
//                       }
//                     },
//                     isSmallScreen: isSmallScreen,
//                     textScaler: textScaler,
//                   ),
//                   SizedBox(height: isSmallScreen ? 12 : 16),

//                   // Width Section
//                   _buildMeasurementRow(
//                     controller:
//                         _widthController, // Fixed typo: _widhtController -> _widthController
//                     labelText: "Width",
//                     selectedUnit: _selectedWidthUnit,
//                     units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                     onUnitChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedWidthUnit = value;
//                         });
//                       }
//                     },
//                     isSmallScreen: isSmallScreen,
//                     textScaler: textScaler,
//                   ),
//                   SizedBox(height: isSmallScreen ? 12 : 16),

//                   // Length Section
//                   _buildMeasurementRow(
//                     controller:
//                         _lengthController, // Fixed typo: _lenghtController -> _lengthController
//                     labelText: "Length",
//                     selectedUnit:
//                         _selectedLengthUnit, // Fixed typo: _selectLenghtUnit -> _selectedLengthUnit
//                     units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                     onUnitChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedLengthUnit = value; // Fixed typo
//                         });
//                       }
//                     },
//                     isSmallScreen: isSmallScreen,
//                     textScaler: textScaler,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 "Cancel",
//                 textScaler: TextScaler.linear(1),
//                 style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _submitProduct(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.greenColor,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isSmallScreen ? 16 : 24,
//                   vertical: isSmallScreen ? 8 : 12,
//                 ),
//               ),
//               child: Text(
//                 "Submit",
//                 style: TextStyle(
//                   color: AppColor.whiteColor,
//                   fontSize: isSmallScreen ? 14 : 16,
//                 ),
//                 textScaler: TextScaler.linear(1),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Helper method for building text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     required bool isSmallScreen,
//     required TextScaler textScaler,
//     TextInputType? keyboardType,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//         contentPadding: EdgeInsets.symmetric(
//           vertical: isSmallScreen ? 10 : 12,
//           horizontal: 12,
//         ),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         isDense: true,
//       ),
//     );
//   }

//   // Helper method for building measurement rows (value + unit dropdown)
//   Widget _buildMeasurementRow({
//     required TextEditingController controller,
//     required String labelText,
//     required String selectedUnit,
//     required List<String> units,
//     required Function(String?) onUnitChanged,
//     required bool isSmallScreen,
//     required TextScaler textScaler,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: isSmallScreen ? 2 : 3,
//           child: _buildTextField(
//             controller: controller,
//             labelText: labelText,
//             isSmallScreen: isSmallScreen,
//             textScaler: textScaler,
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//           ),
//         ),
//         SizedBox(width: isSmallScreen ? 8 : 12),
//         Expanded(
//           flex: isSmallScreen ? 1 : 2,
//           child: DropdownButtonFormField<String>(
//             value: selectedUnit,
//             decoration: InputDecoration(
//               labelText: 'Unit',
//               labelStyle: TextStyle(fontSize: isSmallScreen ? 10 : 12),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: isSmallScreen ? 10 : 12,
//                 horizontal: 12,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               isDense: true,
//             ),
//             items: units.map((String unit) {
//               return DropdownMenuItem<String>(
//                 value: unit,
//                 child: Text(
//                   unit,
//                   textScaler: TextScaler.linear(1),
//                   style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                 ),
//               );
//             }).toList(),
//             onChanged: onUnitChanged,
//           ),
//         ),
//       ],
//     );
//   }

//   // Extracted submit logic for better organization
//   void _submitProduct(BuildContext context) {
//     final productName = _productNameController.text.trim();
//     final unitText = _unitController.text.trim();
//     final heightText = _heightController.text.trim();
//     final widthText = _widthController.text.trim(); // Fixed typo
//     final lengthText = _lengthController.text.trim(); // Fixed typo

//     // Validation
//     if (productName.isEmpty ||
//         unitText.isEmpty ||
//         heightText.isEmpty ||
//         widthText.isEmpty ||
//         lengthText.isEmpty) {
//       _showSnackBar(context, "Please fill all fields");
//       return;
//     }

//     // Check if dimensional units match
//     if (_selectedHeightUnit != _selectedWidthUnit ||
//         _selectedHeightUnit != _selectedLengthUnit || // Fixed typo
//         _selectedWidthUnit != _selectedLengthUnit) {
//       // Fixed typo
//       _showSnackBar(
//         context,
//         "Height, Width, and Length units must all be the same",
//       );
//       return;
//     }

//     // Generate indexes
//     int startIndex = savedImageIndexes.isNotEmpty
//         ? savedImageIndexes.last + 1
//         : 1;
//     List<int> currentIndexes = List.generate(
//       _images.length,
//       (index) => startIndex + index,
//     );
//     savedImageIndexes.addAll(currentIndexes);

//     // Create product data
//     final productData = ProductData(
//       productName: productName,
//       weight: unitText,
//       weightUnit: _selectedWeightUnit,
//       height: heightText,
//       heightUnit: _selectedHeightUnit,
//       width: widthText,
//       widthUnit: _selectedWidthUnit,
//       length: lengthText,
//       lengthUnit: _selectedLengthUnit, // Fixed typo
//       images: List.from(_images),
//       imageIndexes: List.from(currentIndexes),
//       submittedAt: DateTime.now(),
//     );

//     Homepage.submittedProducts.add(productData);

//     // Debug prints
//     print("Saved Image Indexes: $savedImageIndexes");
//     print("Product Name: $productName");
//     print("Weight: $unitText $_selectedWeightUnit");
//     print("Height: $heightText $_selectedHeightUnit");
//     print("Width: $widthText $_selectedWidthUnit");
//     print("Length: $lengthText $_selectedLengthUnit");
//     print("Images selected:");
//     for (int i = 0; i < _images.length; i++) {
//       print("Image ${i + 1}: ${_images[i].path}");
//     }

//     // Clear form
//     _clearForm();

//     Navigator.of(context).pop();
//     _showSnackBar(context, "Product submitted successfully!");
//   }

//   // Helper method for showing snackbars
//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, textScaler: TextScaler.linear(1)),
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }

//   // Helper method for clearing form
//   void _clearForm() {
//     _productNameController.clear();
//     _unitController.clear();
//     _heightController.clear();
//     _widthController.clear(); // Fixed typo
//     _lengthController.clear(); // Fixed typo

//     setState(() {
//       _selectedWeightUnit = 'kg';
//       _selectedHeightUnit = 'cm';
//       _selectedWidthUnit = 'cm';
//       _selectedLengthUnit = 'cm'; // Fixed typo
//       _images.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.whiteColor,
//         leading: Builder(
//           builder: (context) => Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.menu, color: AppColor.blackColor),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ),
//         title: Align(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 50),
//             child: Text(
//               "Fulupo",
//               style: Styles.textStyleTittle(
//                 context,
//                 color: AppColor.blackColor,
//                 fontSize: 25,
//               ),
//               textScaler: TextScaler.linear(1),
//               // style: TextStyle(fontSize: 30),
//               // textScaler: TextScaler.linear(1),
//             ),
//           ),
//         ),
//       ),
//       drawer: MyDrawer(
//         imageCount: _images.length, // Pass current image count here
//         submittedProducts: Homepage.submittedProducts,
//       ),
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(color: AppColor.greenColor),
//         child: Column(
//           children: [
//             if (_images.isNotEmpty)
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(10),
//                   itemCount: _images.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                   ),
//                   itemBuilder: (context, index) {
//                     return Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white, width: 2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.file(
//                               _images[index],
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 4,
//                           left: 6,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.6),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${index + 1}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                               textScaler: TextScaler.linear(1),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 2,
//                           right: 2,
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _images.removeAt(index);
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.6),
//                                 shape: BoxShape.circle,
//                               ),
//                               padding: const EdgeInsets.all(4),
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             if (_images.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: ElevatedButton(
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                           setState(() {
//                             isLoading = true;
//                           });

//                           await _showFinishDialog();

//                           setState(() {
//                             isLoading = false;
//                           });
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.whiteColor,
//                     foregroundColor: AppColor.blackColor,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.check),
//                             SizedBox(width: 8),
//                             Text("Finish", textScaler: TextScaler.linear(1)),
//                           ],
//                         ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         shape: const StadiumBorder(),
//         backgroundColor: AppColor.whiteColor,
//         child: Icon(Icons.camera_alt, color: AppColor.textColor),
//         onPressed: _showImageSourcePicker,
//       ),
//     );
//   }
// }