import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:fulupo_ums/models/productDetails.dart';
import 'package:fulupo_ums/pages/homepage.dart'; 
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:provider/provider.dart';

class Storepage extends StatefulWidget {
  const Storepage({super.key});

  @override
  State<Storepage> createState() => _StorepageState();
}

class _StorepageState extends State<Storepage> {
  bool isGridView = true;
  UserProvider get provider => context.read<UserProvider>();

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _getProducts() async {
    print("----------------------------------------------->getStores");
    //  await provider.getStores();
    // await provider.getProducts();
    await provider.getGSMProducts();
  }

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gsmProducts = context.watch<UserProvider>().gsmproducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.greenColor,
        title: Text(
          'Product Library',
          textScaler: TextScaler.linear(1),
          style: Styles.textStyleTittle(
            context,
            color: AppColor.whiteColor,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        actions: [
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: gsmProducts.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Stats Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.greenColor.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Products',
                        gsmProducts.length.toString(),
                        Icons.inventory_2,
                      ),
                      _buildStatCard(
                        'Total Images',
                        gsmProducts
                            .fold(
                              0,
                              (sum, product) =>
                                  sum + product.dimensionImages.length,
                            )
                            .toString(),
                        Icons.photo_library,
                      ),
                    ],
                  ),
                ),
                // Products View
                Expanded(
                  child: isGridView
                      ? _buildGridView(gsmProducts)
                      : _buildListView(gsmProducts),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Your Product Library is Empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            'Start adding products from the homepage\nto build your digital library',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColor.greenColor, size: 24),
          SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.blackColor,
            ),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textScaler: TextScaler.linear(1),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Gsmproductmodel> gsmProducts) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12, // Reduced spacing for 3 columns
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // Adjusted ratio to give more height
      ),
      itemCount: gsmProducts.length,
      itemBuilder: (context, index) {
        final product = gsmProducts[index];
        return _buildProductCard(product, index);
      },
    );
  }

  Widget _buildListView(List<Gsmproductmodel> gsmProducts) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: gsmProducts.length,
      itemBuilder: (context, index) {
        final product = gsmProducts[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: _buildProductListTile(product, index),
        );
      },
    );
  }

  Widget _buildProductCard(Gsmproductmodel product, int index) {
    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[200],
                ),
                child: product.dimensionImages.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          'https://fulupostore.tsitcloud.com/${product.dimensionImages.first}',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        size: 35,
                        color: Colors.grey[400],
                      ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    Flexible(
                      child: Text(
                        capitalizeFirstLetter(product.name),
                        style: TextStyle(
                          fontSize: 13, // Smaller font for 3 columns
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor,
                        ),
                        textScaler: TextScaler.linear(1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Bottom info row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            product.netQty,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTile(Gsmproductmodel product, int index) {
    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: product.dimensionImages.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://fulupostore.tsitcloud.com/${product.dimensionImages.first}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.inventory_2_outlined,
                      size: 30,
                      color: Colors.grey[400],
                    ),
            ),
            SizedBox(width: 16),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeFirstLetter(product.name),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackColor,
                    ),
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.netQty,
                    textScaler: TextScaler.linear(1),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.greenColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.dimensionImages.length} images',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.greenColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(Gsmproductmodel product) async {
    // For now, just navigate to a simple detail page showing basic info
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GsmProductDetailPage(product: product),
      ),
    );
    setState(() {}); // Refresh after return if needed
  }
}

// New GSM Product Detail Page for Gsmproductmodel
class GsmProductDetailPage extends StatelessWidget {
  final Gsmproductmodel product;

  const GsmProductDetailPage({super.key, required this.product});

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: 16,
            ),
            textScaler: TextScaler.linear(1),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: AppColor.blackColor, fontSize: 16),
            textScaler: TextScaler.linear(1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.greenColor,
        title: Text(
          capitalizeFirstLetter(product.name),
          style: TextStyle(color: AppColor.whiteColor),
          textScaler: TextScaler.linear(1),
        ),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Gallery
              if (product.dimensionImages.isNotEmpty) ...[
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: product.dimensionImages.length,
                    itemBuilder: (context, index) {
                      final imageUrl =
                          'https://fulupostore.tsitcloud.com/${product.dimensionImages[index]}';
                      return GestureDetector(
                        onTap: () => _showImageDialog(context, imageUrl),
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
              Text(
                'Product Specifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackColor,
                ),
                textScaler: TextScaler.linear(1),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Weight', product.netQty),
                    Divider(height: 24),
                    _buildDetailRow(
                      'Dimensions',
                      '${product.height} × ${product.width} × ${product.length}',
                    ),
                    Divider(height: 24),
                    _buildDetailRow(
                      'Created On',
                      product.createdAt != null
                          ? '${product.createdAt!.day}/${product.createdAt!.month}/${product.createdAt!.year} at ${product.createdAt!.hour.toString().padLeft(2, '0')}:${product.createdAt!.minute.toString().padLeft(2, '0')}'
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fulupo_ums/models/productDetails.dart';
// import 'package:fulupo_ums/pages/homepage.dart'; // Import to access ProductData
// import 'package:fulupo_ums/util/colors.dart';
// import 'package:fulupo_ums/util/style.dart';

// class Storepage extends StatefulWidget {
//   const Storepage({super.key});

//   @override
//   State<Storepage> createState() => _StorepageState();
// }

// class _StorepageState extends State<Storepage> {
//   bool isGridView = true; // Toggle between grid and list view

//   String capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final submittedProducts = Homepage.submittedProducts;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.greenColor,
//         title: Text(
//           'Product Library',
//           textScaler: TextScaler.linear(1),
//           style: Styles.textStyleTittle(
//             context,
//             color: AppColor.whiteColor,
//             fontSize: 25,
//           ),
//         ),
//         iconTheme: IconThemeData(color: AppColor.whiteColor),
//         actions: [
//           IconButton(
//             icon: Icon(
//               isGridView ? Icons.view_list : Icons.grid_view,
//               color: AppColor.whiteColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 isGridView = !isGridView;
//               });
//             },
//           ),
//         ],
//       ),
//       body: submittedProducts.isEmpty
//           ? _buildEmptyState()
//           : Column(
//               children: [
//                 // Stats Header
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColor.greenColor.withOpacity(0.1),
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey[300]!),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildStatCard(
//                         'Products',
//                         submittedProducts.length.toString(),
//                         Icons.inventory_2,
//                       ),
//                       _buildStatCard(
//                         'Total Images',
//                         submittedProducts
//                             .fold(
//                               0,
//                               (sum, product) => sum + product.images.length,
//                             )
//                             .toString(),
//                         Icons.photo_library,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Products View
//                 Expanded(
//                   child: isGridView ? _buildGridView() : _buildListView(),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.library_books_outlined,
//             size: 100,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Your Product Library is Empty',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//             textScaler: TextScaler.linear(1),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Start adding products from the homepage\nto build your digital library',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//             textScaler: TextScaler.linear(1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String count, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//       decoration: BoxDecoration(
//         color: AppColor.whiteColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: AppColor.greenColor, size: 24),
//           SizedBox(height: 4),
//           Text(
//             count,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: AppColor.blackColor,
//             ),
//             textScaler: TextScaler.linear(1),
//           ),
//           Text(
//             title,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             textScaler: TextScaler.linear(1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGridView() {
//     final submittedProducts = Homepage.submittedProducts;

//     return GridView.builder(
//       padding: EdgeInsets.all(16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 12, // Reduced spacing for 3 columns
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.75, // Adjusted ratio to give more height
//       ),
//       itemCount: submittedProducts.length,
//       itemBuilder: (context, index) {
//         final product = submittedProducts[index];
//         return _buildProductCard(product, index);
//       },
//     );
//   }

//   Widget _buildListView() {
//     final submittedProducts = Homepage.submittedProducts;

//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: submittedProducts.length,
//       itemBuilder: (context, index) {
//         final product = submittedProducts[index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 12),
//           child: _buildProductListTile(product, index),
//         );
//       },
//     );
//   }

//   Widget _buildProductCard(ProductData product, int index) {
//     return GestureDetector(
//       onTap: () => _navigateToProductDetail(product, index),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColor.whiteColor,
//           borderRadius: BorderRadius.circular(12), // Slightly smaller radius
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Expanded(
//               flex: 3,
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                   color: Colors.grey[200],
//                 ),
//                 child: product.images.isNotEmpty
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(12),
//                         ),
//                         child: Image.file(
//                           product.images.first,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Icon(
//                         Icons.inventory_2_outlined,
//                         size: 35, // Smaller icon for 3-column layout
//                         color: Colors.grey[400],
//                       ),
//               ),
//             ),
//             // Product Info
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(8), // Reduced padding
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Product Name
//                     Flexible(
//                       child: Text(
//                         capitalizeFirstLetter(product.productName),
//                         style: TextStyle(
//                           fontSize: 13, // Smaller font for 3 columns
//                           fontWeight: FontWeight.bold,
//                           color: AppColor.blackColor,
//                         ),
//                         textScaler: TextScaler.linear(1),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     // Bottom info row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         // Image count badge
//                         // Flexible(
//                         //   child: Container(
//                         //     padding: EdgeInsets.symmetric(
//                         //       horizontal: 4,
//                         //       vertical: 2,
//                         //     ),
//                         //     decoration: BoxDecoration(
//                         //       color: AppColor.greenColor.withOpacity(0.1),
//                         //       borderRadius: BorderRadius.circular(6),
//                         //     ),
//                         //     child: Text(
//                         //       '${product.images.length}',
//                         //       style: TextStyle(
//                         //         fontSize: 9,
//                         //         color: AppColor.greenColor,
//                         //         fontWeight: FontWeight.w600,
//                         //       ),
//                         //       textScaler: TextScaler.linear(1),
//                         //     ),
//                         //   ),
//                         // ),
//                         // SizedBox(width: 4),
//                         // Weight info
//                         Flexible(
//                           flex: 2,
//                           child: Text(
//                             '${product.weight}${product.weightUnit}',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey[600],
//                             ),
//                             textScaler: TextScaler.linear(1),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductListTile(ProductData product, int index) {
//     return GestureDetector(
//       onTap: () => _navigateToProductDetail(product, index),
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: AppColor.whiteColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Product Image
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.grey[200],
//               ),
//               child: product.images.isNotEmpty
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         product.images.first,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : Icon(
//                       Icons.inventory_2_outlined,
//                       size: 30,
//                       color: Colors.grey[400],
//                     ),
//             ),
//             SizedBox(width: 16),
//             // Product Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     capitalizeFirstLetter(product.productName),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColor.blackColor,
//                     ),
//                     textScaler: TextScaler.linear(1),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${product.weight} ${product.weightUnit} • ${product.height}×${product.width}×${product.length} ${product.heightUnit}',
//                     textScaler: TextScaler.linear(1),
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColor.greenColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '${product.images.length} images',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: AppColor.greenColor,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                       ),
//                       Spacer(),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 14,
//                         color: AppColor.textColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToProductDetail(ProductData product, int index) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ProductDetailPage(product: product, productIndex: index),
//       ),
//     );

//     if (result == true) {
//       // The product was deleted, rebuild UI
//       setState(() {});
//     }
//   }
// }

// // Product Detail Page
// class ProductDetailPage extends StatelessWidget {
//   final ProductData product;
//   final int productIndex;

//   const ProductDetailPage({
//     super.key,
//     required this.product,
//     required this.productIndex,
//   });

//   String capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }

//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Product', textScaler: TextScaler.linear(1)),
//         content: Text(
//           'Are you sure you want to delete this product?',
//           textScaler: TextScaler.linear(1),
//         ),
//         actions: [
//           TextButton(
//             child: Text('Cancel', textScaler: TextScaler.linear(1)),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           ElevatedButton(
//             child: Text('Delete', textScaler: TextScaler.linear(1)),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () {
//               Homepage.submittedProducts.removeAt(productIndex);
//               Navigator.of(context).pop(); // Close dialog
//               Navigator.of(context).pop(true); // Go back from detail page

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'Product deleted successfully',
//                     textScaler: TextScaler.linear(1),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.greenColor,
//         title: Text(
//           capitalizeFirstLetter(product.productName),
//           style: TextStyle(color: AppColor.whiteColor),
//           textScaler: TextScaler.linear(1),
//         ),
//         iconTheme: IconThemeData(color: AppColor.whiteColor),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               _confirmDelete(context);
//               //  Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hero Image Section
//             Container(
//               height: 300,
//               width: double.infinity,
//               color: Colors.grey[100],
//               child: product.images.isNotEmpty
//                   ? PageView.builder(
//                       itemCount: product.images.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () =>
//                               _showImageDialog(context, product.images[index]),
//                           child: Image.file(
//                             product.images[index],
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Icon(
//                         Icons.inventory_2_outlined,
//                         size: 100,
//                         color: Colors.grey[400],
//                       ),
//                     ),
//             ),

//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Title and Image Count
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           capitalizeFirstLetter(product.productName),
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: AppColor.blackColor,
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColor.greenColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${product.images.length} images',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: AppColor.greenColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 24),

//                   // Product Specifications
//                   Text(
//                     'Product Specifications',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: AppColor.blackColor,
//                     ),
//                     textScaler: TextScaler.linear(1),
//                   ),
//                   SizedBox(height: 16),

//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[200]!),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildDetailRow(
//                           'Weight',
//                           '${product.weight} ${product.weightUnit}',
//                         ),
//                         Divider(height: 24),
//                         _buildDetailRow(
//                           'Dimensions',
//                           '${product.height} × ${product.width} × ${product.length} ${product.heightUnit}',
//                         ),
//                         Divider(height: 24),
//                         _buildDetailRow(
//                           'Submitted On',
//                           '${product.submittedAt.day}/${product.submittedAt.month}/${product.submittedAt.year} at ${product.submittedAt.hour}:${product.submittedAt.minute.toString().padLeft(2, '0')}',
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: 24),

//                   // Images Gallery
//                   if (product.images.isNotEmpty) ...[
//                     Text(
//                       'Image Gallery',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.blackColor,
//                       ),
//                       textScaler: TextScaler.linear(1),
//                     ),
//                     SizedBox(height: 16),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                       ),
//                       itemCount: product.images.length,
//                       itemBuilder: (context, imageIndex) {
//                         return GestureDetector(
//                           onTap: () => _showImageDialog(
//                             context,
//                             product.images[imageIndex],
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: AppColor.greenColor,
//                                 width: 2,
//                               ),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.file(
//                                 product.images[imageIndex],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 120,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//               fontSize: 16,
//             ),
//             textScaler: TextScaler.linear(1),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(color: AppColor.blackColor, fontSize: 16),
//             textScaler: TextScaler.linear(1),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showImageDialog(BuildContext context, File image) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Stack(
//             children: [
//               Center(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxHeight: MediaQuery.of(context).size.height * 0.8,
//                     maxWidth: MediaQuery.of(context).size.width * 0.9,
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(image, fit: BoxFit.contain),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 40,
//                 right: 20,
//                 child: GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.close, color: Colors.white, size: 24),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
