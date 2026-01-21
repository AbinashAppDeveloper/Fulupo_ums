import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/productDetails.dart';
import 'package:fulupo_ums/pages/homepage.dart';
import 'package:fulupo_ums/pages/storepage.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/widgets/dilogue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final int imageCount;
  final List<ProductData> submittedProducts;

  const MyDrawer({
    super.key,
    required this.imageCount,
    required this.submittedProducts,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoading = false;
  UserProvider get provider => context.read<UserProvider>();
  String? username; // <-- add this to hold username
  Future<void> _getUser() async {
    print("----------------------------------------------->_getUser");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString(AppConstants.UserName);
    setState(() {
      username = savedUsername ?? "Guest"; // fallback name if null
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    int totalProducts = widget.submittedProducts.length;
    int totalSubmittedImages = widget.submittedProducts.fold(
      0,
      (sum, product) => sum + product.images.length,
    );
    final gsmProducts = context.watch<UserProvider>().gsmproducts;

    return Stack(
      children: [
        ClipRRect(
          child: Container(
            height: sh * 0.8,
            width: sw * 0.6,
            child: Drawer(
              backgroundColor: AppColor.whiteColor,
              child: Column(
                children: [
                  // Scrollable main content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                          height: 170,
                          color: AppColor.greenColor,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColor.whiteColor,
                                child: Icon(
                                  Icons.person,
                                  color: AppColor.greenColor,
                                  size: 50,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      username ?? "", // <-- use here
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textScaler: TextScaler.linear(1),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      // "Images: $totalSubmittedImages",
                                      "Images: ${gsmProducts.fold(0, (sum, product) => sum + product.dimensionImages.length).toString()}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textScaler: TextScaler.linear(1),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Products: ${gsmProducts.length.toString()}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textScaler: TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Home tile
                        ListTile(
                          leading: Icon(Icons.home, color: AppColor.greenColor),
                          title: Text(
                            'Home',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            if (ModalRoute.of(context)?.settings.name != '/') {
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Homepage(),
                              //   ),
                              //   (route) => false,
                              // );
                            }
                          },
                        ),

                        Divider(),

                        // Store tile
                        ListTile(
                          leading: Icon(
                            Icons.store,
                            color: AppColor.greenColor,
                          ),
                          title: Text(
                            'Store Products',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                          // trailing: totalProducts > 0
                          //     ? Container(
                          //         padding: EdgeInsets.symmetric(
                          //           horizontal: 8,
                          //           vertical: 4,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           color: AppColor.greenColor,
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //         // child: Text(
                          //         //   '$totalProducts',
                          //         //   style: TextStyle(
                          //         //     color: AppColor.whiteColor,
                          //         //     fontSize: 12,
                          //         //     fontWeight: FontWeight.bold,
                          //         //   ),
                          //         //   textScaler: TextScaler.linear(1),
                          //         // ),
                          //       )
                          //     : null,
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Storepage(),
                              ),
                            );
                          },
                        ),

                        Divider(),

                        // if (totalProducts > 0)
                        //   ListTile(
                        //     leading: Icon(Icons.clear_all, color: Colors.red),
                        //     title: Text(
                        //       'Clear All Products',
                        //       style: TextStyle(
                        //         color: Colors.red,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       textScaler: TextScaler.linear(1),
                        //     ),
                        //     onTap: () {
                        //       _showClearAllDialog();
                        //     },
                        //   ),
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: AppColor.greenColor,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),
                          onTap: () {
                            logout();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Container(decoration: BoxDecoration(

                  // ), child: Text("Logout")),
                  // Fixed bottom section — App Information
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: AppColor.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'App Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fulupo UMS v1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        Text(
                          'Product Management System',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear All Products', textScaler: TextScaler.linear(1)),
          content: Text(
            'Are you sure you want to clear all submitted products? This action cannot be undone.',
            textScaler: TextScaler.linear(1),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', textScaler: TextScaler.linear(1)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                //  Homepage.submittedProducts.clear();
                });

                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close drawer

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'All products cleared successfully',
                      textScaler: TextScaler.linear(1),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.white),
                textScaler: TextScaler.linear(1),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    await localData.clear();
    AppDialogue.toast("Logout Successfully");
    Navigator.of(context, rootNavigator: true).pop();
    AppRouteName.loginPage.pushAndRemoveUntil(context, (route) => false);
  }
}
