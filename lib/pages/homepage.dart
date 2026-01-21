// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fulupo_ums/models/productDetails.dart';
// import 'package:fulupo_ums/provider/UserProvider.dart';
// import 'package:fulupo_ums/util/appconstant.dart';
// import 'package:fulupo_ums/widgets/dilogue.dart';
// import 'package:fulupo_ums/widgets/productSearch.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:fulupo_ums/pages/drawer.dart';
// import 'package:fulupo_ums/util/colors.dart';
// import 'package:fulupo_ums/util/style.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart'; // ✅ Added for proper directory handling

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

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
//   bool isSubmitting = false;

//   String _selectedWeightUnit = 'kg';
//   String _selectedHeightUnit = 'cm';
//   String _selectedWidthUnit = 'cm';
//   String _selectedLengthUnit = 'cm';

//   String? selectedProductId;
//   String? selectedProductCode;
//   List<int> savedImageIndexes = [];
//   UserProvider get provider => context.read<UserProvider>();

//   /// Always copy to permanent storage
//   Future<File> _copyToPermanent(File src) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final dst = File(
//       '${dir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg',
//     );
//     await dst.writeAsBytes(await src.readAsBytes());
//     return dst;
//   }


// Future<void> _pickImageFromCamera() async {
//   final pickMultiple = await showDialog<bool>(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: Text('Camera Options'),
//       content: Text('Single or multiple photos?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           child: Text('Single'),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: Text('Multiple'),
//         ),
//       ],
//     ),
//   );
  
//   if (pickMultiple == true) 
//     await _takeMultiplePhotos();
//   else if (pickMultiple == false) 
//     await _takeSinglePhoto();
// }

// Future<void> _takeSinglePhoto() async {
//   try {
//     final picker = ImagePicker();
//     final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//     if (photo == null) return;
    
//     // Show loading indicator
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Center(child: CircularProgressIndicator()),
//     );
    
//     final cropped = await ImageCropper().cropImage(
//       sourcePath: photo.path,
//       compressQuality: 90,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: AppColor.greenColor,
//           toolbarWidgetColor: Colors.white,
//         ),
//         IOSUiSettings(
//           title: 'Crop Image',
//         ),
//       ],
//     );
    
//     // Dismiss loading indicator
//     Navigator.pop(context);
    
//     if (cropped != null) {
//       final file = File(cropped.path);
//       final perm = await _copyToPermanent(file);
//       setState(() => _images.add(perm));
//     }
//   } catch (e) {
//     // Handle errors
//     Navigator.pop(context); // Dismiss loading indicator if shown
//     print('Error taking photo: $e');
//     AppDialogue.toast('Failed to process image');
//   }
// }

// Future<void> _takeMultiplePhotos() async {
//   bool takingMore = true;
  
//   while (takingMore) {
//     try {
//       final picker = ImagePicker();
//       final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//       if (photo == null) {
//         takingMore = false;
//         continue;
//       }
      
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => Center(child: CircularProgressIndicator()),
//       );
      
//       final cropped = await ImageCropper().cropImage(
//         sourcePath: photo.path,
//         compressQuality: 90,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: AppColor.greenColor,
//             toolbarWidgetColor: Colors.white,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//           ),
//         ],
//       );
      
//       // Dismiss loading indicator
//       Navigator.pop(context);
      
//       if (cropped != null) {
//         final file = File(cropped.path);
//         final perm = await _copyToPermanent(file);
//         setState(() => _images.add(perm));
//       }
      
//       // Ask if user wants to take another
//       takingMore = await showDialog<bool>(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Take Another?'),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No')),
//             TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes')),
//           ],
//         ),
//       ) ?? false;
      
//     } catch (e) {
//       // Handle errors
//       if (Navigator.canPop(context)) Navigator.pop(context); // Dismiss loading indicator if shown
//       print('Error taking photo: $e');
//       AppDialogue.toast('Failed to process image');
//       takingMore = false;
//     }
//   }
// }

// Future<void> _pickImagesFromGallery() async {
//   try {
//     final picker = ImagePicker();
//     final List<XFile> photos = await picker.pickMultiImage();
    
//     for (final photo in photos) {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => Center(child: CircularProgressIndicator()),
//       );
      
//       final cropped = await ImageCropper().cropImage(
//         sourcePath: photo.path,
//         compressQuality: 90,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: AppColor.greenColor,
//             toolbarWidgetColor: Colors.white,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//           ),
//         ],
//       );
      
//       // Dismiss loading indicator
//       Navigator.pop(context);
      
//       if (cropped != null) {
//         final file = File(cropped.path);
//         final perm = await _copyToPermanent(file);
//         setState(() => _images.add(perm));
//       }
//     }
//   } catch (e) {
//     // Handle errors
//     if (Navigator.canPop(context)) Navigator.pop(context); // Dismiss loading indicator if shown
//     print('Error selecting images: $e');
//     AppDialogue.toast('Failed to process images');
//   }
// }


//   // Future<void> _takeSinglePhoto() async {
//   //   final picker = ImagePicker();
//   //   final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//   //   if (photo == null) return;
//   //   final cropped = await ImageCropper().cropImage(
//   //     sourcePath: photo.path,
//   //     uiSettings: [
//   //       AndroidUiSettings(toolbarTitle: 'Crop'),
//   //       IOSUiSettings(title: 'Crop'),
//   //     ],
//   //   );
//   //   final file = File(cropped?.path ?? photo.path);
//   //   final perm = await _copyToPermanent(file);
//   //   setState(() => _images.add(perm));
//   // }

//   // Future<void> _takeMultiplePhotos() async {
//   //   final picker = ImagePicker();
//   //   bool again = true;
//   //   while (again) {
//   //     final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//   //     if (photo == null) break;
//   //     final cropped = await ImageCropper().cropImage(
//   //       sourcePath: photo.path,
//   //       uiSettings: [
//   //         AndroidUiSettings(toolbarTitle: 'Crop'),
//   //         IOSUiSettings(title: 'Crop'),
//   //       ],
//   //     );
//   //     final file = File(cropped?.path ?? photo.path);
//   //     final perm = await _copyToPermanent(file);
//   //     setState(() => _images.add(perm));
//   //     again =
//   //         await showDialog<bool>(
//   //           context: context,
//   //           builder: (_) => AlertDialog(
//   //             title: Text('Take Another?'),
//   //             actions: [
//   //               TextButton(
//   //                 onPressed: () => Navigator.pop(context, false),
//   //                 child: Text('No'),
//   //               ),
//   //               TextButton(
//   //                 onPressed: () => Navigator.pop(context, true),
//   //                 child: Text('Yes'),
//   //               ),
//   //             ],
//   //           ),
//   //         ) ??
//   //         false;
//   //   }
//   // }

//   // Future<void> _pickImagesFromGallery() async {
//   //   final picker = ImagePicker();
//   //   final files = await picker.pickMultiImage();
//   //   for (var f in files) {
//   //     final cropped = await ImageCropper().cropImage(
//   //       sourcePath: f.path,
//   //       uiSettings: [
//   //         AndroidUiSettings(toolbarTitle: 'Crop'),
//   //         IOSUiSettings(title: 'Crop'),
//   //       ],
//   //     );
//   //     final file = File(cropped?.path ?? f.path);
//   //     final perm = await _copyToPermanent(file);
//   //     setState(() => _images.add(perm));
//   //   }
//   // }

//   // Future<void> _showImageSourcePicker() async {
//   //   showModalBottomSheet(context: context, builder: (_) => Column(
//   //     mainAxisSize: MainAxisSize.min,
//   //     children: [
//   //       ListTile(leading: Icon(Icons.camera_alt), title: Text('Camera'), onTap: () { Navigator.pop(context); _pickImageFromCamera(); }),
//   //       ListTile(leading: Icon(Icons.photo), title: Text('Gallery'), onTap: () { Navigator.pop(context); _pickImagesFromGallery(); }),
//   //     ],
//   //   ));
//   // }
//   Future<void> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString(AppConstants.token ?? "");
//     print("----------------------------------------------->");
//     print(token);
//   }

//   Future<void> _getProducts() async {
//     print("----------------------------------------------->getStores");
//     //  await provider.getStores();
//     await provider.getProducts();
//     await provider.getGSMProducts();
//   }

//   @override
//   void initState() {
//     _getToken();
//     _getProducts();
//     super.initState();
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
//               "FulupoUMS",
//               style: Styles.textStyleTittle(
//                 context,
//                 color: AppColor.blackColor,
//                 fontSize: 25,
//               ),
//               textScaler: TextScaler.linear(1),
//             ),
//           ),
//         ),
//       ),
//       drawer: MyDrawer(
//         imageCount: _images.length,
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
//                           //  await provider.getStores();
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
//                   ),
//                   child: Icon(Icons.camera_alt, color: AppColor.whiteColor),
//                 ),
//                 title: Text(
//                   "Take Photo",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textScaler: TextScaler.linear(1),
//                 ),
//                 subtitle: Text(
//                   "Single or multiple photos",
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
//                   ),
//                   child: Icon(Icons.photo_library, color: AppColor.whiteColor),
//                 ),
//                 title: Text(
//                   "Choose from Gallery",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textScaler: TextScaler.linear(1),
//                 ),
//                 subtitle: Text(
//                   "Select multiple photos",
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

//   Future<void> _showFinishDialog() {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         final screenSize = MediaQuery.of(context).size;
//         final isSmallScreen = screenSize.width < 600;
//         final textScaler = MediaQuery.textScalerOf(context);

//         return StatefulBuilder(
//           // ✅ Added StatefulBuilder for dialog state management
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Text(
//                 "Product Details",
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 20 : 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textScaler: TextScaler.linear(1),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: isSmallScreen ? 16 : 24,
//                 vertical: 20,
//               ),
//               content: Container(
//                 width: double.maxFinite,
//                 constraints: BoxConstraints(
//                   maxHeight: screenSize.height * 0.7,
//                   maxWidth: isSmallScreen ? screenSize.width * 0.9 : 500,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: isSmallScreen ? 12 : 16),
//                       TextField(
//                         controller: _productNameController,
//                         readOnly:
//                             true, // ✅ User taps to search, not type manually
//                         decoration: InputDecoration(
//                           labelText: "Product Name",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         onTap: () async {
//                           final selectedProductIdFromSearch =
//                               await showSearch<String?>(
//                                 context: context,
//                                 delegate: ProductSearchDelegate(
//                                   context.read<UserProvider>().products,
//                                 ),
//                               );

//                           if (selectedProductIdFromSearch != null) {
//                             final selectedProduct = context
//                                 .read<UserProvider>()
//                                 .products
//                                 .firstWhere(
//                                   (p) => p.id == selectedProductIdFromSearch,
//                                 );

//                             setState(() {
//                               _productNameController.text =
//                                   selectedProduct.name;
//                               selectedProductId =
//                                   selectedProduct.id; // ✅ save for API
//                               // Assuming the product has a code field, adjust based on your model
//                               selectedProductCode = selectedProduct.productCode;
//                               // ✅ save product code
//                             });

//                             print(
//                               "✅ Selected Product Name: ${selectedProduct.name}",
//                             );
//                             print("✅ Selected Product ID: $selectedProductId");
//                             print(
//                               "✅ Selected Product Code: $selectedProductCode",
//                             );
//                           }
//                         },
//                       ),

//                       // SizedBox(height: isSmallScreen ? 12 : 16),
//                       SizedBox(height: isSmallScreen ? 12 : 16),
//                       _buildMeasurementRow(
//                         controller: _unitController,
//                         labelText: "Weight",
//                         selectedUnit: _selectedWeightUnit,
//                         units: const [
//                           'kg',
//                           'gm',
//                           'lb',
//                           'oz',
//                           'No.',
//                           'mL',
//                           'L',
//                           'gal',
//                           'fl oz',
//                         ],
//                         onUnitChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               _selectedWeightUnit = value;
//                             });
//                           }
//                         },
//                         isSmallScreen: isSmallScreen,
//                         textScaler: textScaler,
//                       ),
//                       SizedBox(height: isSmallScreen ? 12 : 16),

//                       _buildMeasurementRow(
//                         controller: _heightController,
//                         labelText: "Height",
//                         selectedUnit: _selectedHeightUnit,
//                         units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                         onUnitChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               _selectedHeightUnit = value;
//                             });
//                           }
//                         },
//                         isSmallScreen: isSmallScreen,
//                         textScaler: textScaler,
//                       ),
//                       SizedBox(height: isSmallScreen ? 12 : 16),

//                       _buildMeasurementRow(
//                         controller: _widthController,
//                         labelText: "Width",
//                         selectedUnit: _selectedWidthUnit,
//                         units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                         onUnitChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               _selectedWidthUnit = value;
//                             });
//                           }
//                         },
//                         isSmallScreen: isSmallScreen,
//                         textScaler: textScaler,
//                       ),
//                       SizedBox(height: isSmallScreen ? 12 : 16),

//                       _buildMeasurementRow(
//                         controller: _lengthController,
//                         labelText: "Length",
//                         selectedUnit: _selectedLengthUnit,
//                         units: const ['cm', 'm', 'mm', 'in', 'ft'],
//                         onUnitChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               _selectedLengthUnit = value;
//                             });
//                           }
//                         },
//                         isSmallScreen: isSmallScreen,
//                         textScaler: textScaler,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: isSubmitting
//                       ? null
//                       : () {
//                           Navigator.of(context).pop();
//                         },
//                   child: Text(
//                     "Cancel",
//                     textScaler: TextScaler.linear(1),
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 14 : 16,
//                       color: isSubmitting ? Colors.grey : null,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: isSubmitting
//                       ? null
//                       : () => _submitProduct(context, setDialogState),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.greenColor,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isSmallScreen ? 16 : 24,
//                       vertical: isSmallScreen ? 8 : 12,
//                     ),
//                   ),
//                   child: isSubmitting
//                       ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppColor.whiteColor,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           "Submit",
//                           style: TextStyle(
//                             color: AppColor.whiteColor,
//                             fontSize: isSmallScreen ? 14 : 16,
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

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

//   void _submitProduct(BuildContext context, StateSetter setDialogState) async {
//     // ✅ Start loading state
//     setDialogState(() {
//       isSubmitting = true;
//     });

//     try {
//       // Print all values before submission
//       print("=== PRODUCT SUBMISSION DATA ===");
//       print("Product Name: ${_productNameController.text.trim()}");
//       print("Product ID: ${selectedProductId ?? 'Not Selected'}");
//       print("Product Code: ${selectedProductCode ?? 'Not Available'}");

//       print("Weight: ${_unitController.text.trim()} $_selectedWeightUnit");
//       print("Height: ${_heightController.text.trim()} $_selectedHeightUnit");
//       print("Width: ${_widthController.text.trim()} $_selectedWidthUnit");
//       print("Length: ${_lengthController.text.trim()} $_selectedLengthUnit");
//       print("Number of Images: ${_images.length}");
//       print("===============================");

//       final productName = _productNameController.text.trim();
//       final unitText = _unitController.text.trim();
//       final heightText = _heightController.text.trim();
//       final widthText = _widthController.text.trim();
//       final lengthText = _lengthController.text.trim();

//       // Validation
//       if (productName.isEmpty ||
//           unitText.isEmpty ||
//           heightText.isEmpty ||
//           widthText.isEmpty ||
//           lengthText.isEmpty) {
//         // _showSnackBar(context, "Please fill all fields");
//         AppDialogue.toast("Please fill all fields");
//         return;
//       }

//       if (_selectedHeightUnit != _selectedWidthUnit ||
//           _selectedHeightUnit != _selectedLengthUnit ||
//           _selectedWidthUnit != _selectedLengthUnit) {
//         // _showSnackBar(
//         //   context,
//         //   "Height, Width, and Length units must all be the same",
//         // );
//         AppDialogue.toast(
//           "Height, Width, and Length units must all be the same",
//         );
//         return;
//       }

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString(AppConstants.token ?? "");

//       final success = await provider.submitGsmProduct(
//         token: token ?? "",
//         name: productName,
//         productCode: selectedProductCode ?? "",
//         masterProductId: selectedProductId ?? "",
//         netQty: "$unitText $_selectedWeightUnit",
//         height: "$heightText $_selectedHeightUnit",
//         width: "$widthText $_selectedWidthUnit",
//         length: "$lengthText $_selectedLengthUnit",
//         images: _images,
//       );

//       if (success) {
//         _clearForm();
//         Navigator.of(context).pop();
//         AppDialogue.toast("Product uploaded successfully!");
//       } else {
//         //_showSnackBar(context, "Upload failed. Please try again.");
//         AppDialogue.toast("Upload failed. Please try again");
//       }

//       // Generate image indexes
//       int startIndex = savedImageIndexes.isNotEmpty
//           ? savedImageIndexes.last + 1
//           : 1;
//       List<int> currentIndexes = List.generate(
//         _images.length,
//         (index) => startIndex + index,
//       );
//       savedImageIndexes.addAll(currentIndexes);

//       // Create product data and add to list
//       final productData = ProductData(
//         productName: productName,
//         weight: unitText,
//         weightUnit: _selectedWeightUnit,
//         height: heightText,
//         heightUnit: _selectedHeightUnit,
//         width: widthText,
//         widthUnit: _selectedWidthUnit,
//         length: lengthText,
//         lengthUnit: _selectedLengthUnit,
//         images: List.from(_images),
//         imageIndexes: List.from(currentIndexes),
//         submittedAt: DateTime.now(),
//       );

//       Homepage.submittedProducts.add(productData);

//       // _clearForm();
//       // Navigator.of(context).pop();
//       // _showSnackBar(context, "Product submitted successfully!");
//       AppDialogue.toast("Product submitted successfully!");
//     } catch (e) {
//       print("❌ Exception during submission: $e");
//       // _showSnackBar(context, "An error occurred. Please try again.");
//       AppDialogue.toast("An error occurred. Please try again.");
//     } finally {
//       // ✅ Stop loading state
//       setDialogState(() {
//         isSubmitting = false;
//       });
//     }
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, textScaler: TextScaler.linear(1)),
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _clearForm() {
//     _productNameController.clear();
//     _unitController.clear();
//     _heightController.clear();
//     _widthController.clear();
//     _lengthController.clear();

//     setState(() {
//       _selectedWeightUnit = 'kg';
//       _selectedHeightUnit = 'cm';
//       _selectedWidthUnit = 'cm';
//       _selectedLengthUnit = 'cm';
//       _images.clear();

//       selectedProductId = null;
//       selectedProductCode = null;
//     });
//   }
// }
