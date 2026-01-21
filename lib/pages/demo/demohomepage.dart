import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/MasterCategory_model.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:fulupo_ums/models/productModel.dart';
import 'package:fulupo_ums/pages/categoryProductsPage%20.dart';
import 'package:fulupo_ums/pages/demo/democategorypage.dart';

import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoHomepage extends StatefulWidget {
  const DemoHomepage({Key? key}) : super(key: key);

  @override
  State<DemoHomepage> createState() => _DemoHomepageState();
}

class _DemoHomepageState extends State<DemoHomepage> {
  bool isLoading = true;
  bool isGridView = true;
  String? userName = "";

  List<MastercategoryModel> masterCategories = [];
  Map<String, List<Gsmproductmodel>> categoryProducts = {};

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    _loadData();
    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(AppConstants.UserName);
    setState(() {
      userName = name ?? "";
    });
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    await provider.getProducts();
    await provider.fetchMasterCategory();
    await provider.getGSMProducts();

    _groupProductsByCategory();

    setState(() => isLoading = false);
  }

  void _groupProductsByCategory() {
    masterCategories = provider.masterCategory;
    categoryProducts.clear();

    Map<String, String> productToCategoryMap = {};

    for (var masterProduct in provider.products) {
      if (masterProduct.categoryId?.id != null) {
        productToCategoryMap[masterProduct.id] = masterProduct.categoryId!.id;
      }
    }

    print(
      "📋 Master Products mapping: ${productToCategoryMap.length} products mapped to categories",
    );

    for (var gsmProduct in provider.gsmproducts) {
      String? masterProductId = gsmProduct.masterProductId?.id;

      if (masterProductId != null &&
          productToCategoryMap.containsKey(masterProductId)) {
        String categoryId = productToCategoryMap[masterProductId]!;

        if (!categoryProducts.containsKey(categoryId)) {
          categoryProducts[categoryId] = [];
        }
        categoryProducts[categoryId]!.add(gsmProduct);

        print(
          "✅ Mapped GSM product '${gsmProduct.name}' to category ID: $categoryId",
        );
      } else {
        print(
          "⚠️ GSM product '${gsmProduct.name}' has no matching category (masterProductId: $masterProductId)",
        );
      }
    }

    print(
      "✅ Grouped ${provider.gsmproducts.length} GSM products into ${categoryProducts.length} categories",
    );

    categoryProducts.forEach((categoryId, products) {
      var category = masterCategories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => MastercategoryModel(
          id: '',
          name: 'Unknown',
          description: '',
          categoryImage: '',
        ),
      );
      print("📦 Category '${category.name}': ${products.length} products");
    });
  }

  void _navigate(MastercategoryModel category) {
    print(
      "🔄 Navigating to category: ${category.name} with ID: ${category.id}",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DemoCategoryProductsPage(category: category),
      ),
    );
  }

  String _fullImageUrl(String path) {
    if (path.isEmpty) return "";

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;

    return "${AppConstants.BASE_URL}/$cleanPath";
  }

  Widget _buildGridView() {
    if (masterCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No categories available",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: masterCategories.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        return _buildCategoryCard(masterCategories[index]);
      },
    );
  }

  Widget _buildListView() {
    if (masterCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No categories available",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: masterCategories.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        final category = masterCategories[index];
        final products = categoryProducts[category.id] ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            onTap: () => _navigate(category),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColor.greenGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: category.categoryImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _fullImageUrl(category.categoryImage),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.category_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.category_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
            ),
            title: Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.greenColor,
              ),
            ),
            subtitle: Text(
              "${products.length} Products",
              style: TextStyle(color: Colors.amber[800]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.greenColor,
              size: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(MastercategoryModel category) {
    int count = categoryProducts[category.id]?.length ?? 0;

    return GestureDetector(
      onTap: () => _navigate(category),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColor.greenGradient,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: category.categoryImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _fullImageUrl(category.categoryImage),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.category_outlined,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.category_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$count Products",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColor.greenColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildAppBar(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColor.greenColor))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isGridView ? _buildGridView() : _buildListView(),
                  ),
                ],
              ),
            ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          "Product Categories",
          style: Styles.textStyleButton2(context, color: AppColor.blackColor),
        ),
        const Spacer(),
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
          final result = await AppRouteName.addProduct.push(context);
          if (result == true) _loadData();
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
                GestureDetector(
                  onTap: (){
                    AppRouteName.profilepage.push(context);
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: AppColor.greenColor,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
