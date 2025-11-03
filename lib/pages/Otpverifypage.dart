import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fulupo_ums/components/my_button.dart';
import 'package:fulupo_ums/provider/UserProvider.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';
import 'package:fulupo_ums/widgets/dilogue.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class Otpverifypage extends StatefulWidget {
  final userId;
  const Otpverifypage({super.key, required this.userId});

  @override
  State<Otpverifypage> createState() => _OtpverifypageState();
}

class _OtpverifypageState extends State<Otpverifypage> {
  final formKey = GlobalKey<FormState>();
  final passWord = TextEditingController();
  final mobile = TextEditingController();
  bool haserror = false;
  bool isLoading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  UserProvider get provider => context.read<UserProvider>();

  void _verifyOtp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Call login API
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
        AppRouteName.homepage.pushAndRemoveUntil(context, (route) => false);
      } else {
        // Show toast with actual message from API or fallback
        final errorMessage = resp.data?["message"] ?? "Invalid user";
        AppDialogue.toast(errorMessage);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // ✅ Print or process the userId passed from Login page
    print("👉 Received user ID: ${widget.userId}");

    // ✅ Optional: You can auto-fill a field or call an API
    if (widget.userId != null && widget.userId.toString().isNotEmpty) {
      // Example: autofill the mobile controller if needed
      mobile.text = widget.userId.toString();

      // Or trigger an API call to send OTP
      // sendOtp(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final radius = sqrt(pow(sw, 2) + pow(sh, 2));
    return Scaffold(
      body: Container(
        width: sw,
        height: sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: keyboardHeight > 0 ? sh * 0.15 : sh * 0.4,
                        child: Image.asset("assets/Fulupo-UMS-logo.png"),
                      ),
                      Positioned(
                        bottom:
                            0, // Adjust this value to control how close the text is
                        top: 240,
                        child: Text(
                          "Verification..",
                          style: Styles.textStyleLogin(
                            context,
                            color: AppColor.greenColor,
                            fontSize: 30,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.01),
                  Text(
                    'Please type the Account Password',
                    textAlign: TextAlign.center,
                    style: Styles.text1(context, color: AppColor.textColor),
                    textScaler: TextScaler.linear(1),
                  ),
                  SizedBox(height: 18),

                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: passWord,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textAlign: TextAlign.start,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 109, 107, 107),
                          fontSize: sh * 0.015,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: AppColor.textColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide(color: AppColor.textColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide(color: AppColor.textColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: BorderSide(color: AppColor.textColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sh * 0.04),
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

                  SizedBox(height: sh * 0.04),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Forget Password ",
                      style: Styles.textStyleButton2(
                        context,
                        color: AppColor.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: "click!",
                          style: Styles.textStyleButton2(
                            context,
                            color: AppColor.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
