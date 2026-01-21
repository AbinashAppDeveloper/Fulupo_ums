import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/widgets/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// ✅ Global shimmer widget
// Widget shimmerBox({
//   double height = 90,
//   double width = double.infinity,
//   double radius = 8,
// }) {
//   return Shimmer.fromColors(
//     baseColor: Colors.grey.shade300,
//     highlightColor: Colors.grey.shade100,
//     child: Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(radius),
//       ),
//     ),
//   );
// }

class ProductDetailPage extends StatefulWidget {
  final Gsmproductmodel product;
  

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
    String? userName = "";

      @override
  void initState() {
    super.initState();

    _getUser();
  }
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(AppConstants.UserName);

    setState(() {
      userName = name ?? "";
    });
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
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor.greenColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),textScaler: TextScaler.linear(1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey[300], thickness: 1),

          Expanded(
            child: _buildImageGrid(context),
          ),
        ],
      ),
    );
  }
// In the _buildImageGrid method of ProductDetailPage
Widget _buildImageGrid(BuildContext context) {
  if (widget.product.dimensionImages.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined,
              color: Colors.grey[400], size: 64),
          const SizedBox(height: 16),
          Text("No images available",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textScaler: const TextScaler.linear(1)),
        ],
      ),
    );
  }

  print("📸 Building image grid with ${widget.product.dimensionImages.length} images");
  
  return GridView.builder(
    padding: const EdgeInsets.all(10),
    itemCount: widget.product.dimensionImages.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final imagePath = widget.product.dimensionImages[index];
      final String fullUrl = getImageUrl(imagePath);  // Use same getImageUrl method
      
      print("🖼️ Grid image $index: $imagePath");
      print("   Full URL: $fullUrl");

      return GestureDetector(
        onTap: () => _showFullScreenImage(context, index),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: index == 0 ? Colors.red : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              fullUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return shimmerBox();
              },
              errorBuilder: (context, error, stack) {
                print("❌ Error loading grid image $index: $error");
                print("   Failed URL: $fullUrl");
                return Center(
                  child: Icon(Icons.broken_image_outlined,
                      color: Colors.grey[400], size: 32),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

// Add this helper method to ProductDetailPage
String getImageUrl(String? path) {
  if (path == null || path.isEmpty) return "";
  
  print("🔍 Detail page - Original path: $path");
  
  // If already a full URL, return as-is
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }
  
  // Remove leading slash if present
  String cleanPath = path.startsWith('/') ? path.substring(1) : path;
  
  // Ensure BASE_URL doesn't end with slash if cleanPath starts with it
  String baseUrl = AppConstants.BASE_URL;
  if (baseUrl.endsWith('/') && cleanPath.startsWith('/')) {
    baseUrl = baseUrl.substring(0, baseUrl.length - 1);
  } else if (!baseUrl.endsWith('/') && !cleanPath.startsWith('/')) {
    cleanPath = '/' + cleanPath;
  }
  
  String fullUrl = baseUrl + cleanPath;
  print("🔗 Detail page - Constructed URL: $fullUrl");
  return fullUrl;
}


  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageView(
          images: widget.product.dimensionImages,
          initialIndex: index,
          productName: widget.product.name,
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productName;

  const FullScreenImageView({
    Key? key,
    required this.images,
    required this.initialIndex,
    required this.productName,
  }) : super(key: key);

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    // Debug the image URLs
    for (int i = 0; i < widget.images.length; i++) {
      print("📸 FullScreen Image $i path: ${widget.images[i]}");
      print("   Full URL: ${getImageUrl(widget.images[i])}");
    }
  }
  
  // Use the same image URL handling as in the product detail page
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    
    // If already a full URL, return as-is
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    
    // Remove leading slash if present
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    
    // Ensure BASE_URL doesn't end with slash if cleanPath starts with it
    String baseUrl = AppConstants.BASE_URL;
    if (baseUrl.endsWith('/') && cleanPath.startsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    } else if (!baseUrl.endsWith('/') && !cleanPath.startsWith('/')) {
      cleanPath = '/' + cleanPath;
    }
    
    return baseUrl + cleanPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.productName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textScaler: const TextScaler.linear(1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (_, index) {
                final imagePath = widget.images[index];
                final url = getImageUrl(imagePath);  // Use the same method

                print("🔍 Loading fullscreen image $index: $url");
                
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Center(
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return shimmerBox(height: 250, width: 250);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print("❌ Fullscreen image error: $error");
                        print("   Failed URL: $url");
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.broken_image_outlined,
                              size: 48, 
                              color: Colors.white
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Image could not be loaded",
                              style: TextStyle(color: Colors.white),
                              textScaler: TextScaler.linear(1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Path: $imagePath",
                              style: const TextStyle(
                                color: Colors.grey, 
                                fontSize: 12
                              ),
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Indicator
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

