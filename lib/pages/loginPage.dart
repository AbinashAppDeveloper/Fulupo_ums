import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/components/my_button.dart';
import 'package:fulupo_ums/route_generator.dart';
import 'package:fulupo_ums/util/colors.dart';
import 'package:fulupo_ums/util/style.dart';

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
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: keyboardHeight,
            top: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: keyboardHeight > 0 ? sh * 0.15 : sh * 0.4,
                    child: Image.asset("assets/Fulupo-UMS-logo.png"),
                  ),
                  Positioned(
                    bottom: 0,
                    top: 260,
                    child: Text(
                      "Login",
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
              FittedBox(
                child: Text(
                  "Please enter your valid User ID",
                  style: Styles.text1(context, color: AppColor.textColor),
                  textScaler: TextScaler.linear(1),
                ),
              ),
              // FittedBox(
              //   child: Text(
              //     "valid User ID",
              //     style: Styles.text1(context, color: AppColor.textColor),
              //     textScaler: TextScaler.linear(1),
              //   ),
              // ),
              SizedBox(height: sh * 0.03),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: mobile,
                  keyboardType: TextInputType.number,
                  maxLength: 10,

                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your User ID';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                      return 'Enter a valid 10-digit User ID';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Your User ID',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 109, 107, 107),
                      // fontSize: MediaQuery.textScalerOf(
                      //   context,
                      // ).scale(8.0), // ✅ Correct now!
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
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),

              SizedBox(height: sh * 0.05),
              MyButton(
                text: isLoading ? "Sending..." : "NEXT".toUpperCase(),
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
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    await Future.delayed(Duration(seconds: 2));

                    setState(() {
                      isLoading = false;
                    });

                    AppRouteName.otpPage.push(
                      context,
                      args: mobile.text.trim(),
                    );
                  }
                },
              ),
              SizedBox(height: sh * 0.03),
              FittedBox(
                child: Row(
                  children: [
                    Text(
                      "Don't worry ! your details are safe with us.",
                      style: Styles.text2(context, color: AppColor.textColor),
                      textScaler: TextScaler.linear(1),
                    ),
                    Icon(Icons.privacy_tip, color: Colors.amber),
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
