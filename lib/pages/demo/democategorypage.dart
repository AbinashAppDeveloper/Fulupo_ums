import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/MasterCategory_model.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:fulupo_ums/pages/productDetailpage.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoCategoryProductsPage extends StatefulWidget {
  final MastercategoryModel category;

  const DemoCategoryProductsPage({Key? key, required this.category})
    : super(key: key);

  @override
  State<DemoCategoryProductsPage> createState() =>
      _DemoCategoryProductsPageState();
}

class _DemoCategoryProductsPageState extends State<DemoCategoryProductsPage> {
  String userName = "";
  bool isGridView = true;
  bool isLoading = true;
  List<Gsmproductmodel> categoryProducts = [];

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    _getUser();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    await provider.getProducts();
    await provider.getGSMProducts();

    _filterProductsByCategory();
    setState(() => isLoading = false);
  }

  void _filterProductsByCategory() {
    Map<String, String> productToCategoryMap = {};

    for (var masterProduct in provider.products) {
      if (masterProduct.categoryId?.id != null) {
        productToCategoryMap[masterProduct.id] = masterProduct.categoryId!.id;
      }
    }

    print(
      "📋 Master Products mapping: ${productToCategoryMap.length} products mapped to categories",
    );

    categoryProducts = provider.gsmproducts.where((gsmProduct) {
      String? masterProductId = gsmProduct.masterProductId?.id;

      if (masterProductId != null &&
          productToCategoryMap.containsKey(masterProductId)) {
        String categoryId = productToCategoryMap[masterProductId]!;
        return categoryId == widget.category.id;
      }
      return false;
    }).toList();

    print(
      "✅ Found ${categoryProducts.length} products for category ${widget.category.name}",
    );
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(AppConstants.UserName);
    setState(() {
      userName = name ?? "";
    });
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";

    print("🔍 Original path: $path");

    if (path.startsWith('http://') || path.startsWith('https://')) {
      print("✅ Using as-is: $path");
      return path;
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;

    String baseUrl = AppConstants.BASE_URL;
    if (baseUrl.endsWith('/') && cleanPath.startsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    } else if (!baseUrl.endsWith('/') && !cleanPath.startsWith('/')) {
      cleanPath = '/' + cleanPath;
    }

    String fullUrl = baseUrl + cleanPath;
    print("🔗 Constructed URL: $fullUrl");
    return fullUrl;
  }

  void _navigateToProductDetail(Gsmproductmodel product) {
    print("⭐ Navigating to product: ${product.name}");
    print("📸 Product has ${product.dimensionImages.length} images:");
    for (var i = 0; i < product.dimensionImages.length; i++) {
      print("   Image $i: ${product.dimensionImages[i]}");
      print("   Full URL: ${getImageUrl(product.dimensionImages[i])}");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  Widget getProductImage(String? imageUrl, {double height = 90}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      print("⚠️ Empty image URL");
      return _placeholder(height);
    }

    final String fullUrl = getImageUrl(imageUrl);
    print("🖼️ Loading image: $fullUrl");

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        fullUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            print("✅ Image loaded successfully: $fullUrl");
            return child;
          }
          return _shimmerBox(height: height, width: double.infinity);
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Image loading error: $error');
          print('🔗 Failed URL: $fullUrl');
          print('📋 Stack trace: $stackTrace');
          return _placeholder(height);
        },
      ),
    );
  }

  Widget _placeholder(double height) {
    return Container(
      height: height,
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

  Widget _shimmerBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops: const [0.1, 0.3, 0.4],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildGridDesign() {
    if (categoryProducts.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      itemCount: categoryProducts.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = categoryProducts[index];
        String? imageUrl = product.dimensionImages.isNotEmpty
            ? product.dimensionImages.first
            : null;

        String itemsText = "${product.dimensionImages.length} items";

        return InkWell(
          onTap: () => _navigateToProductDetail(product),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: getProductImage(imageUrl)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.greenColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaler: const TextScaler.linear(1),
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
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
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

  Widget _buildListDesign() {
    if (categoryProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: categoryProducts.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        final product = categoryProducts[index];
        String? imageUrl = product.dimensionImages.isNotEmpty
            ? product.dimensionImages.first
            : null;

        String itemsText = "${product.dimensionImages.length} items";

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () => _navigateToProductDetail(product),
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: getProductImage(imageUrl, height: 60),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            color: AppColor.greenColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          itemsText,
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.greenColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            "No products available",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "in ${widget.category.name}",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: _iconDecoration(),
            child: Icon(Icons.arrow_back, color: AppColor.greenColor, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.category.name,
            style: Styles.textStyleButton2(context, color: AppColor.blackColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => setState(() => isGridView = !isGridView),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: _iconDecoration(),
            child: Icon(
              isGridView ? Icons.list_rounded : Icons.grid_view_rounded,
              color: AppColor.greenColor,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _loadData,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: _iconDecoration(),
            child: Icon(Icons.refresh, color: AppColor.greenColor, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.greenGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () async {
          final result = await AppRouteName.addProduct.push(
            context,
            args: {"category": widget.category.name},
          );

          if (result == true) _loadData();
          ;
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }

  BoxDecoration _iconDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: const Offset(2, 3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          shadowColor: Colors.black26,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildAppBar(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.greenColor,
                      ),
                    )
                  : isGridView
                  ? _buildGridDesign()
                  : _buildListDesign(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
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
              children: [
                Text(
                  "Hi, $userName 👋",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.green, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
