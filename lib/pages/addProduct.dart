import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fulupo_ums/models/productModel.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:fulupo_ums/widgets/dilogue.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

// ✅ add these
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fulupo_ums/util/appconstant.dart' as appconst;

class Addproduct extends StatefulWidget {
  final String? preSelectedCategory;
  const Addproduct({super.key, this.preSelectedCategory});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  List<File> _images = [];
  bool _isLoading = false;
  bool _isCategorySet = false;

  Category? _selectedCategory;
  String? _selectedProductName;

  // ✅ store the matched product id/code for GSM submit
  String? _selectedProductId;
  String? _selectedProductCode;

  final TextEditingController _categorySearchController =
      TextEditingController();
  final TextEditingController _productSearchController =
      TextEditingController();

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();

    if (widget.preSelectedCategory != null) {
      _preFillCategory(widget.preSelectedCategory!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isCategorySet) {
        _showCategoryDialog();
      }
    });
  }

  void _preFillCategory(String catName) {
    final categories = _getCategoriesFromProvider();
    final match = categories.firstWhere(
      (c) => c.name.toLowerCase() == catName.toLowerCase(),
      orElse: () => Category(id: '', name: ''),
    );

    if (match.id.isNotEmpty) {
      _selectedCategory = match;
      _isCategorySet = false; // Still requires product name selection
    }
  }

  List<String> _getProductNames() {
    final products = provider.products ?? [];
    final names = <String>{};
    for (final p in products) {
      if (p.name.trim().isNotEmpty) names.add(p.name.trim());
    }
    final sorted = names.toList()..sort();
    return sorted;
  }

  List<Category> _getCategoriesFromProvider() {
    try {
      final products = provider.products ?? [];
      final Map<String, Category> unique = {};
      for (final p in products) {
        if (p.categoryId.id.isNotEmpty) {
          unique[p.categoryId.id] = p.categoryId;
        }
      }
      final list = unique.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  void dispose() {
    _categorySearchController.dispose();
    _productSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          shadowColor: Colors.black26,
          backgroundColor: Colors.transparent,
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColor.greenGradient,
                image: const DecorationImage(
                  image: AssetImage('assets/Appbar3.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Hi, Abinash 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: AppColor.greenColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.greenColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Add Product",
                  style: Styles.textStyleButton2(
                    context,
                    color: AppColor.blackColor,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_images.isEmpty)
                        _buildImageUploadSection(sh, sw)
                      else
                        _buildImagePreviewSection(),
                      SizedBox(height: _images.isNotEmpty ? 80 : 150),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.greenColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              10,
              10,
              10,
              MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickImagesFromGallery,
                        icon: Icon(
                          Icons.photo_library_outlined,
                          color: AppColor.greenColor,
                        ),
                        label: const Text(
                          "Open Gallery",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.greenColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColor.greenColor,
                        ),
                        label: const Text(
                          "Open Camera",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.greenColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _goToNextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "NEXT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========= Category + Product selection dialog (searchable) =========]

  void _showCategoryDialog() {
    final categories = _getCategoriesFromProvider();
    final productNames = _getProductNames();

    // filtered
    var filteredCategories = List<Category>.from(categories);
    var filteredProducts = List<String>.from(productNames);
    // ✅ AUTO-PREFILL CATEGORY IN SEARCH BOX WHEN PASSED
    // ✅ AUTO-PREFILL CATEGORY IN SEARCH BOX WHEN PASSED
    if (_selectedCategory != null) {
      _categorySearchController.text = _selectedCategory!.name;

      // ✅ Only keep the selected category in list
      filteredCategories = [_selectedCategory!];
    }

    showDialog(
      context: context,
      barrierDismissible:
          false, // Changed to false to prevent dismissing by tapping outside
      builder: (dialogContext) => WillPopScope(
        // Prevent back button from dismissing the dialog without proper handling
        onWillPop: () async {
          // Show a confirmation dialog
          final shouldPop =
              await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Cancel product selection?',
                    textScaler: TextScaler.linear(1),
                  ),
                  content: const Text(
                    'Product selection is required. Are you sure you want to go back?',
                    textScaler: TextScaler.linear(1),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(ctx).pop(false), // Don't allow back
                      child: const Text('No', textScaler: TextScaler.linear(1)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true); // Allow back
                      },
                      child: const Text(
                        'Yes',
                        textScaler: TextScaler.linear(1),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;

          return shouldPop;
        },
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: AppColor.greenColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Product',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textScaler: TextScaler.linear(1),
                              ),
                            ],
                          ),
                          // Close button with confirmation
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[600]),
                            onPressed: () async {
                              final shouldClose =
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        'Cancel product selection?',
                                        textScaler: TextScaler.linear(1),
                                      ),
                                      content: const Text(
                                        'Product selection is required. Are you sure you want to cancel?',
                                        textScaler: TextScaler.linear(1),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            ctx,
                                          ).pop(false), // Don't close
                                          child: const Text(
                                            'No',
                                            textScaler: TextScaler.linear(1),
                                          ),
                                        ),
                                        TextButton(
                                          //  onPressed: () => Navigator.of(ctx).pop(true), // Close
                                          onPressed: () => AppRouteName
                                              .homepage1
                                              .pushAndRemoveUntil(
                                                context,
                                                (route) => false,
                                              ),
                                          child: const Text(
                                            'Yes',
                                            textScaler: TextScaler.linear(1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (shouldClose) {
                                Navigator.pop(
                                  dialogContext,
                                ); // Just close dialog
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Product Category',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _categorySearchController,
                          decoration: InputDecoration(
                            hintText:
                                _selectedCategory?.name ?? 'Search category...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: Icon(
                              Icons.search,
                              color: AppColor.greenColor,
                            ),
                          ),
                          onChanged: (v) {
                            setDialogState(() {
                              filteredCategories = v.isEmpty
                                  ? List.from(categories)
                                  : categories
                                        .where(
                                          (c) => c.name.toLowerCase().contains(
                                            v.toLowerCase(),
                                          ),
                                        )
                                        .toList();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_categorySearchController.text.isNotEmpty &&
                          filteredCategories.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredCategories.length,
                            itemBuilder: (_, i) {
                              final cat = filteredCategories[i];
                              return ListTile(
                                title: Text(
                                  cat.name,
                                  style: const TextStyle(fontSize: 14),
                                  textScaler: TextScaler.linear(1),
                                ),
                                trailing: _selectedCategory?.id == cat.id
                                    ? Icon(
                                        Icons.check,
                                        color: AppColor.greenColor,
                                      )
                                    : null,
                                onTap: () {
                                  setDialogState(() {
                                    _selectedCategory = cat;
                                    _categorySearchController.text = cat.name;
                                    filteredCategories.clear();
                                  });
                                },
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 20),

                      const Text(
                        'Product Name',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _productSearchController,
                          decoration: InputDecoration(
                            hintText:
                                _selectedProductName ?? 'Search product...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: Icon(
                              Icons.search,
                              color: AppColor.greenColor,
                            ),
                          ),
                          onChanged: (v) {
                            setDialogState(() {
                              filteredProducts = v.isEmpty
                                  ? List.from(productNames)
                                  : productNames
                                        .where(
                                          (p) => p.toLowerCase().contains(
                                            v.toLowerCase(),
                                          ),
                                        )
                                        .toList();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_productSearchController.text.isNotEmpty &&
                          filteredProducts.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredProducts.length,
                            itemBuilder: (_, i) {
                              final name = filteredProducts[i];
                              return ListTile(
                                title: Text(
                                  name,
                                  style: const TextStyle(fontSize: 14),
                                  textScaler: TextScaler.linear(1),
                                ),
                                trailing: _selectedProductName == name
                                    ? Icon(
                                        Icons.check,
                                        color: AppColor.greenColor,
                                      )
                                    : null,
                                onTap: () {
                                  // ✅ find id & code of first match
                                  final match = (provider.products ?? [])
                                      .firstWhere(
                                        (p) =>
                                            p.name.trim().toLowerCase() ==
                                            name.trim().toLowerCase(),
                                        orElse: () => ProductModel(
                                          id: '',
                                          name: name,
                                          productCode: '',
                                          categoryId:
                                              _selectedCategory ??
                                              Category(id: '', name: ''),
                                          productImage: '',
                                          description: '',
                                        ),
                                      );
                                  setDialogState(() {
                                    _selectedProductName = name;
                                    _selectedProductId = match.id;
                                    _selectedProductCode = match.productCode;
                                    _productSearchController.text = name;
                                    filteredProducts.clear();
                                  });
                                },
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedCategory == null ||
                                _selectedProductName == null) {
                              AppDialogue.toast(
                                'Please select category and product name',
                              );
                              return;
                            }
                            setState(() => _isCategorySet = true);
                            Navigator.pop(dialogContext);
                            _categorySearchController.clear();
                            _productSearchController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.greenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // void _showCategoryDialog() {
  //   final categories = _getCategoriesFromProvider();
  //   final productNames = _getProductNames();

  //   // filtered
  //   var filteredCategories = List<Category>.from(categories);
  //   var filteredProducts = List<String>.from(productNames);

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, setDialogState) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.symmetric(horizontal: 20),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(25),
  //           ),
  //           child: Container(
  //             padding: const EdgeInsets.all(20),
  //             constraints: BoxConstraints(
  //               maxHeight: MediaQuery.of(context).size.height * 0.8,
  //             ),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: Colors.green.shade100,
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Icon(
  //                           Icons.add_shopping_cart,
  //                           color: AppColor.greenColor,
  //                           size: 22,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       const Text(
  //                         'Add Product',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black87,
  //                         ),textScaler: TextScaler.linear(1),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 24),

  //                   const Text(
  //                     'Product Category',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey,
  //                       fontWeight: FontWeight.w500,
  //                     ),textScaler: TextScaler.linear(1),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.grey.shade300),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: TextField(
  //                       controller: _categorySearchController,
  //                       decoration: InputDecoration(
  //                         hintText:
  //                             _selectedCategory?.name ?? 'Search category...',
  //                         border: InputBorder.none,
  //                         contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 12,
  //                         ),
  //                         suffixIcon: Icon(
  //                           Icons.search,
  //                           color: AppColor.greenColor,
  //                         ),
  //                       ),
  //                       onChanged: (v) {
  //                         setDialogState(() {
  //                           filteredCategories = v.isEmpty
  //                               ? List.from(categories)
  //                               : categories
  //                                     .where(
  //                                       (c) => c.name.toLowerCase().contains(
  //                                         v.toLowerCase(),
  //                                       ),
  //                                     )
  //                                     .toList();
  //                         });
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),

  //                   if (_categorySearchController.text.isNotEmpty &&
  //                       filteredCategories.isNotEmpty)
  //                     Container(
  //                       constraints: const BoxConstraints(maxHeight: 150),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         border: Border.all(color: Colors.grey.shade300),
  //                         borderRadius: BorderRadius.circular(12),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.black.withOpacity(0.05),
  //                             blurRadius: 8,
  //                             offset: const Offset(0, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: filteredCategories.length,
  //                         itemBuilder: (_, i) {
  //                           final cat = filteredCategories[i];
  //                           return ListTile(
  //                             title: Text(
  //                               cat.name,
  //                               style: const TextStyle(fontSize: 14),textScaler: TextScaler.linear(1),
  //                             ),
  //                             trailing: _selectedCategory?.id == cat.id
  //                                 ? Icon(
  //                                     Icons.check,
  //                                     color: AppColor.greenColor,
  //                                   )
  //                                 : null,
  //                             onTap: () {
  //                               setDialogState(() {
  //                                 _selectedCategory = cat;
  //                                 _categorySearchController.text = cat.name;
  //                                 filteredCategories.clear();
  //                               });
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ),

  //                   const SizedBox(height: 20),

  //                   const Text(
  //                     'Product Name',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey,
  //                       fontWeight: FontWeight.w500,
  //                     ),textScaler: TextScaler.linear(1),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.grey.shade300),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: TextField(
  //                       controller: _productSearchController,
  //                       decoration: InputDecoration(
  //                         hintText: _selectedProductName ?? 'Search product...',
  //                         border: InputBorder.none,
  //                         contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 12,
  //                         ),
  //                         suffixIcon: Icon(
  //                           Icons.search,
  //                           color: AppColor.greenColor,
  //                         ),
  //                       ),
  //                       onChanged: (v) {
  //                         setDialogState(() {
  //                           filteredProducts = v.isEmpty
  //                               ? List.from(productNames)
  //                               : productNames
  //                                     .where(
  //                                       (p) => p.toLowerCase().contains(
  //                                         v.toLowerCase(),
  //                                       ),
  //                                     )
  //                                     .toList();
  //                         });
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),

  //                   if (_productSearchController.text.isNotEmpty &&
  //                       filteredProducts.isNotEmpty)
  //                     Container(
  //                       constraints: const BoxConstraints(maxHeight: 150),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         border: Border.all(color: Colors.grey.shade300),
  //                         borderRadius: BorderRadius.circular(12),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.black.withOpacity(0.05),
  //                             blurRadius: 8,
  //                             offset: const Offset(0, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: filteredProducts.length,
  //                         itemBuilder: (_, i) {
  //                           final name = filteredProducts[i];
  //                           return ListTile(
  //                             title: Text(
  //                               name,
  //                               style: const TextStyle(fontSize: 14),textScaler: TextScaler.linear(1),
  //                             ),
  //                             trailing: _selectedProductName == name
  //                                 ? Icon(
  //                                     Icons.check,
  //                                     color: AppColor.greenColor,
  //                                   )
  //                                 : null,
  //                             onTap: () {
  //                               // ✅ find id & code of first match
  //                               final match = (provider.products ?? [])
  //                                   .firstWhere(
  //                                     (p) =>
  //                                         p.name.trim().toLowerCase() ==
  //                                         name.trim().toLowerCase(),
  //                                     orElse: () => ProductModel(
  //                                       id: '',
  //                                       name: name,
  //                                       productCode: '',
  //                                       categoryId:
  //                                           _selectedCategory ??
  //                                           Category(id: '', name: ''),
  //                                       productImage: '',
  //                                       description: '',
  //                                     ),
  //                                   );
  //                               setDialogState(() {
  //                                 _selectedProductName = name;
  //                                 _selectedProductId = match.id;
  //                                 _selectedProductCode = match.productCode;
  //                                 _productSearchController.text = name;
  //                                 filteredProducts.clear();
  //                               });
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ),

  //                   const SizedBox(height: 24),

  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         if (_selectedCategory == null ||
  //                             _selectedProductName == null) {
  //                           AppDialogue.toast(
  //                             'Please select category and product name',
  //                           );
  //                           return;
  //                         }
  //                         setState(() => _isCategorySet = true);
  //                         Navigator.pop(context);
  //                         _categorySearchController.clear();
  //                         _productSearchController.clear();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: AppColor.greenColor,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(30),
  //                         ),
  //                         elevation: 0,
  //                       ),
  //                       child: const Text(
  //                         'Next',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w500,
  //                         ),textScaler: TextScaler.linear(1),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // ========= Dimension dialog (underline inputs + unit dropdowns) =========
  void _goToNextStep() {
    // controllers
    final lengthCtrl = TextEditingController();
    final widthCtrl = TextEditingController(); // Breath => Width
    final heightCtrl = TextEditingController();
    final weightCtrl = TextEditingController();

    // units (not sent to API; UI only)
    String lengthUnit = 'cm';
    String widthUnit = 'cm';
    String heightUnit = 'cm';
    String weightUnit = 'gm';

    const dimensionUnits = ['cm', 'm', 'inch', 'ft'];
    const weightUnits = ['gm', 'kg', 'mg', 'ml'];

    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> submit() async {
            if (lengthCtrl.text.trim().isEmpty ||
                widthCtrl.text.trim().isEmpty ||
                heightCtrl.text.trim().isEmpty ||
                weightCtrl.text.trim().isEmpty) {
              AppDialogue.toast('Please fill all fields');
              return;
            }
            if (_selectedProductId == null || _selectedProductName == null) {
              AppDialogue.toast('Please choose product first');
              return;
            }

            setDialogState(() => isSubmitting = true);

            try {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString(appconst.AppConstants.token) ?? '';

              final ok = await provider.submitGsmProduct(
                token: token,
                name: _selectedProductName!, // from selection
                productCode: _selectedProductCode ?? '', // from selection
                masterProductId: _selectedProductId ?? '', // from selection
                // 🚫 As per your answer, DO NOT append units in payload
                netQty: weightCtrl.text.trim(),
                height: heightCtrl.text.trim(),
                width: widthCtrl.text.trim(),
                length: lengthCtrl.text.trim(),
                images: _images,
              );

              if (ok) {
                Navigator.pop(context); // close dimension dialog
                AppDialogue.toast('Product uploaded successfully!');
                Navigator.pop(
                  context,
                  true,
                ); // ✅ go back + tell homepage to reload
                return;
              } else {
                AppDialogue.toast('Upload failed. Please try again.');
              }
            } catch (e) {
              AppDialogue.toast('An error occurred. Please try again.');
            } finally {
              if (mounted) setDialogState(() => isSubmitting = false);
            }
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.grid_view_rounded,
                            color: AppColor.greenColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),

                    _dimensionRow(
                      label: 'Length',
                      controller: lengthCtrl,
                      selectedUnit: lengthUnit,
                      unitList: dimensionUnits,
                      onChanged: (v) => setDialogState(() => lengthUnit = v),
                    ),
                    _dimensionRow(
                      label: 'Width',
                      controller: widthCtrl,
                      selectedUnit: widthUnit,
                      unitList: dimensionUnits,
                      onChanged: (v) => setDialogState(() => widthUnit = v),
                    ),
                    _dimensionRow(
                      label: 'Height',
                      controller: heightCtrl,
                      selectedUnit: heightUnit,
                      unitList: dimensionUnits,
                      onChanged: (v) => setDialogState(() => heightUnit = v),
                    ),
                    _dimensionRow(
                      label: 'Weight',
                      controller: weightCtrl,
                      selectedUnit: weightUnit,
                      unitList: weightUnits,
                      onChanged: (v) => setDialogState(() => weightUnit = v),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textScaler: TextScaler.linear(1),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ========= Reusable row (underline input + dropdown without borders) =========
  Widget _dimensionRow({
    required String label,
    required TextEditingController controller,
    required String selectedUnit,
    required List<String> unitList,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade800,
            ),
            textScaler: TextScaler.linear(1),
          ),
          Row(
            children: [
              SizedBox(
                width: 70,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.greenColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedUnit,
                  alignment: Alignment.center,
                  items: unitList
                      .map(
                        (u) => DropdownMenuItem(
                          value: u,
                          child: Text(
                            u,
                            style: TextStyle(
                              color: AppColor.greenColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onChanged(v);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========= Images UI / helpers (unchanged visuals) =========
  Widget _buildImageUploadSection(double sh, double sw) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/addimage.svg',
            height: sh * 0.3,
            width: sw * 0.3,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            "Upload product images to add into your store gallery",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textScaler: TextScaler.linear(1),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected Images (${_images.length})",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textScaler: TextScaler.linear(1),
              ),
              TextButton.icon(
                onPressed: _clearAllImages,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 20,
                ),
                label: Text(
                  "Clear All",
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w500,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: _images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, i) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _images[i],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => _removeImage(i),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      setState(() => _isLoading = true);
      final picker = ImagePicker();
      final photos = await picker.pickMultiImage();
      if (photos.isNotEmpty) {
        for (final p in photos) {
          final cropped = await ImageCropper().cropImage(
            sourcePath: p.path,
            compressQuality: 90,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: AppColor.greenColor,
                toolbarWidgetColor: Colors.white,
              ),
              IOSUiSettings(title: 'Crop Image'),
            ],
          );
          if (cropped != null) {
            final file = File(cropped.path);
            final perm = await _copyToPermanent(file);
            setState(() => _images.add(perm));
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to process images',
            textScaler: TextScaler.linear(1),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoading = true);
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final cropped = await ImageCropper().cropImage(
          sourcePath: photo.path,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColor.greenColor,
              toolbarWidgetColor: Colors.white,
            ),
            IOSUiSettings(title: 'Crop Image'),
          ],
        );
        if (cropped != null) {
          final file = File(cropped.path);
          final perm = await _copyToPermanent(file);
          setState(() => _images.add(perm));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to process image',
            textScaler: TextScaler.linear(1),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<File> _copyToPermanent(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(file.path);
    final destFile = File('${directory.path}/product_$name');
    return file.copy(destFile.path);
  }

  void _removeImage(int index) => setState(() => _images.removeAt(index));

  void _clearAllImages() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Clear All Images?',
          textScaler: TextScaler.linear(1),
        ),
        content: const Text(
          'Are you sure you want to remove all selected images?',
          textScaler: TextScaler.linear(1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', textScaler: TextScaler.linear(1)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _images.clear());
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: Colors.red[400]),
              textScaler: TextScaler.linear(1),
            ),
          ),
        ],
      ),
    );
  }
}
