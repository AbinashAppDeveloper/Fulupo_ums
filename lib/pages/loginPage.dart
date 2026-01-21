import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/components/my_button.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:fulupo_ums/widgets/dilogue.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  TextEditingController mobile = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider get provider => context.read<UserProvider>();
  bool _obscureText = true;

  void _verifyOtp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });


      final resp = await provider.login(
        username: mobile.text.trim(),
        password: passWord.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (resp.status) {
        print("✅ Login Success!");
        print("Token: ${resp.data?["token"]}");
        print("User Name: ${resp.data?["data"]?["name"]}");
        AppDialogue.toast("Login Successfully");
        AppRouteName.demohomepage.pushAndRemoveUntil(context, (route) => false);
      } else {
        // Show toast with actual message from API or fallback
        final errorMessage = resp.data?["message"] ?? "Invalid user";
        AppDialogue.toast(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Top section with logo and illustration
              Container(
                height: sh * 0.55,
                width: sw,
                child: Stack(
                  children: [
                    // Logo at the top
                    Positioned(
                     top: sh * 0.05,
                      left: 0,
                      right: 0,
                       child: SvgPicture.asset(
                        'assets/fulupo_ums.svg',
                        height: sh * 0.1,
                        width: sw*0.3,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Main illustration
                    Positioned(
                      top: sh * 0.15,
                      left: 0,
                      right: 0,

                      child: SvgPicture.asset(
                        'assets/Checking_boxes.svg',
                        height: sh * 0.33,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Login form section with rounded corners
              Container(
                width: sw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 15, 24, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Login header
                      Center(
                        child: Text(
                          'Login',

                          style: Styles.textStyleButton(
                            context,
                            color: AppColor.greenColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // User ID field
                      Text(
                        'User ID',
                        style: Styles.text2(
                          context,
                          color: AppColor.blackColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: mobile,
                        decoration: InputDecoration(
                          hintText: 'Enter your user ID',

                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize:
                                13, // 👈 decrease this value to make hint text smaller
                          ),
                          fillColor: Colors.grey[100],
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ), // Rounded corners
                            borderSide: const BorderSide(
                              color: Colors.grey, // Normal border color
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.blue, // Border color when focused
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Password field with forgot password link
                      Row(
                        children: [
                          Text(
                            'Password',
                            style: Styles.text2(
                              context,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: passWord,
                        obscureText:
                            _obscureText, // Use the variable to control visibility
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize:
                                13, // 👈 decrease this value to make hint text smaller
                          ),
                          fillColor: Colors.grey[100],
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          // Add the suffix icon for password visibility toggle
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Change the icon based on password visibility
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              // Toggle password visibility
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 25),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Navigate to forget password page
                            print("Forget password clicked");
                          },
                          child: Text(
                            "Forget password ?",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Verify button
                      MyButton(
                        text: isLoading ? "Verifying..." : "VERIFY",
                        textcolor: AppColor.whiteColor,
                        textsize: 20,
                        fontWeight: FontWeight.bold,
                        letterspacing: 0.7,
                        buttonheight: 55 * (sh / 850),
                        buttonwidth: sw * 0.9,
                        buttoncolor: AppColor.greenColor,
                        radius: radius,
                        borderColor: AppColor.whiteColor,
                        borderWidth: 2,
                        onTap: _verifyOtp,
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
  }
}
