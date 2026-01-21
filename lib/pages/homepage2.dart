import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:fulupo_ums/pages/productDetailpage.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:fulupo_ums/widgets/shimmer.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  bool isGridView = true;
  bool isLoading = true;
  String? userName = "";

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(AppConstants.UserName);

    setState(() {
      userName = name ?? "";
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    await provider.getGSMProducts();
    await provider.getProducts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preloading not needed as we're using network images now
  }

  // Navigate to subcategory page
  void _navigateToProductDetail(Gsmproductmodel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  // Load network image with proper handling
  Widget getProductImage(String? imageUrl, {double height = 90}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder(height);
    }

    final String fullUrl = imageUrl.startsWith("http")
        ? imageUrl
        : "${AppConstants.BASE_URL}$imageUrl";

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        fullUrl,
        fit: BoxFit.cover,
        // ✅ Shimmer added here
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          // show shimmer until image fully loads
          return shimmerBox(height: height, width: double.infinity);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(height);
        },
      ),
    );
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: height * 0.5,
        color: AppColor.greenColor,
      ),
    );
  }

  // Grid View with products
  Widget _buildGridView() {
    return GridView.builder(
      itemCount: provider.gsmproducts.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7, // Taller cards for better layout
      ),
      itemBuilder: (context, index) {
        final product = provider.gsmproducts[index];
        String? imageUrl = product.dimensionImages.isNotEmpty
            ? product.dimensionImages.first
            : null;

        // Get the image count from dimensionImages array length
        String itemsText = "${product.dimensionImages.length} items";

        return InkWell(
          onTap: () {
            _navigateToProductDetail(product);
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Full width
                children: [
                  // Image takes most of the space
                  Expanded(
                    flex: 2, // 2/3 of available space
                    child: getProductImage(imageUrl),
                  ),
                  // Text info takes 1/3 of space
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.greenColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaler: TextScaler.linear(1),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            itemsText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set global error handler for widgets
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: const Text(
          'An error occurred while rendering UI. Please try again.',
          style: TextStyle(color: Colors.red),
          textScaler: TextScaler.linear(1),
        ),
      );
    };

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
                  
                      Text(
                        "Hi, $userName 👋",
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

      // 🧱 BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Products",
                  style: Styles.textStyleButton2(
                    context,
                    color: AppColor.blackColor,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                const Spacer(),
                // 🔁 Toggle View Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isGridView ? Icons.grid_view_rounded : Icons.list_rounded,
                      color: AppColor.greenColor,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    // Reload products
                    _loadProducts();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: AppColor.greenColor,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Products Display
            Expanded(
              child: isLoading
                  ? _buildLoadingView()
                  : provider.gsmproducts.isEmpty
                  ? _buildEmptyView()
                  : isGridView
                  ? _buildGridView()
                  : _buildListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColor.greenGradient, // ✅ Your gradient here
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await AppRouteName.addProduct.push(context);

            // ✅ If product saved, refresh homepage
            if (result == true) {
              _loadProducts();
            }
          },

          backgroundColor:
              Colors.transparent, // ✅ important → make FAB itself transparent
          elevation: 0, // ✅ remove default white background shadow
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.greenColor),
          const SizedBox(height: 16),
          Text(
            "Loading products...",
            style: TextStyle(
              color: AppColor.greenColor,
              fontWeight: FontWeight.w500,
            ),
            textScaler: TextScaler.linear(1),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No products found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textScaler: TextScaler.linear(1),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _loadProducts,
            icon: Icon(Icons.refresh, color: AppColor.greenColor),
            label: Text(
              "Refresh",
              style: TextStyle(color: AppColor.greenColor),
            ),
          ),
        ],
      ),
    );
  }

  // Grid View with products
  // Widget _buildGridView() {
  //   return GridView.builder(
  //     itemCount: provider.gsmproducts.length,
  //     physics: const BouncingScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       childAspectRatio: 0.75,
  //     ),
  //     itemBuilder: (context, index) {
  //       final product = provider.gsmproducts[index];
  //       String? imageUrl = product.dimensionImages.isNotEmpty
  //           ? product.dimensionImages.first
  //           : null;

  //       return InkWell(
  //         onTap: () {
  //           _navigateToProductDetail(product);
  //         },
  //         borderRadius: BorderRadius.circular(15),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 blurRadius: 4,
  //                 offset: const Offset(1, 2),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               getProductImage(imageUrl, height: 80),
  //               const SizedBox(height: 8),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4),
  //                 child: Text(
  //                   product.name,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: AppColor.greenColor,
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               Text(
  //                 product.netQty,
  //                 style: const TextStyle(color: Colors.grey, fontSize: 12),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // List View with products
  Widget _buildListView() {
    return ListView.builder(
      itemCount: provider.gsmproducts.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        final product = provider.gsmproducts[index];
        String? imageUrl = product.dimensionImages.isNotEmpty
            ? product.dimensionImages.first
            : null;

        // Get the image count from dimensionImages array length
        String itemsText = "${product.dimensionImages.length} items";

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              _navigateToProductDetail(product);
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Image section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 70,
                      height: 70,
                      child: getProductImage(imageUrl, height: 70),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Text content section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            color: AppColor.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textScaler: TextScaler.linear(1),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          itemsText,
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ),

                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColor.greenColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
