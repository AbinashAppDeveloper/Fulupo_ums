import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fulupo_ums/models/MasterCategory_model.dart';
import 'package:fulupo_ums/models/gsmproductModel.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulupo_ums/enum/enum.dart';
import 'package:fulupo_ums/models/productModel.dart';
import 'package:fulupo_ums/models/storeModel.dart';
import 'package:fulupo_ums/services/api_service.dart';
import 'package:fulupo_ums/services/device_info.dart';
import 'package:fulupo_ums/util/appconstant.dart';
import 'package:fulupo_ums/util/exception.dart';
import 'package:fulupo_ums/util/global.dart';
import 'package:fulupo_ums/util/url_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  List<StoreModel> _stores = [];
  List<StoreModel> get stores => _stores;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<Gsmproductmodel> _gsmproducts = [];
  List<Gsmproductmodel> get gsmproducts => _gsmproducts;

  List<MastercategoryModel> _masterCategory =[];
  List<MastercategoryModel> get masterCategory => _masterCategory;

  Future<void> initialFetch() async {
    AppGlobal.deviceInfo = await DeviceInfoServices.getDeviceInfo();
  }

  Future<APIResp> login({
    required String username,
    required String password,
  }) async {
    print("------------------------ Enter login");

    try {
      final resp = await APIService.post(
        UrlPath.loginUrl.login,
        data: {"username": username, "password": password},
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Data------------------>");
      print(resp.data);

      if (resp.statusCode == 200 && resp.data["token"] != null) {
        final token = resp.data["token"];
        final name = resp.data["data"]?["name"]; // ✅ Fix here
        print("✅ JWT Token: $token");
        print("✅ User Name: $name");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.token, token);
        await prefs.setString(
          AppConstants.UserName,
          name ?? "",
        ); // add fallback
        print("✅ Token and Name saved to SharedPreferences");

        return APIResp(
          status: true,
          statusCode: resp.statusCode,
          data: resp.data,
          fullBody: resp.fullBody,
        );
      } else {
        return APIResp(
          status: false,
          statusCode: resp.statusCode,
          data: resp.data,
          fullBody: resp.fullBody,
        );
      }
    } catch (e) {
      print("❌ Exception in login: $e");
      return APIResp(
        status: false,
        statusCode: 500,
        data: null,
        fullBody: null,
      );
    }
  }

  // Future<APIResp> fetchMasterCategory() async {
  //   print("------------------------ Enter fetchStores");

  //   SharedPreferences prfes = await SharedPreferences.getInstance();
  //   String? token = prfes.getString(AppConstants.token);

  //   try {
  //     final resp = await APIService.get(
  //       UrlPath.loginUrl.mastercategory,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     );

  //     print("Response Status Code: ${resp.statusCode}");
  //     print("Response Status----------------------->");
  //     print(resp.status);
  //     print("Response Data------------------>");
  //     print(resp.data);

  //     if (resp.statusCode == 200 && resp.data["data"] != null) {
  //       return APIResp(
  //         status: true,
  //         statusCode: resp.statusCode,
  //         data: resp.data["data"],
  //         fullBody: resp.fullBody,
  //       );
  //     } else {
  //       return APIResp(
  //         status: false,
  //         statusCode: resp.statusCode,
  //         data: resp.data,
  //         fullBody: resp.fullBody,
  //       );
  //     }
  //   } catch (e) {
  //     print("❌ Exception in fetchStores: $e");
  //     return APIResp(
  //       status: false,
  //       statusCode: 500,
  //       data: null,
  //       fullBody: null,
  //     );
  //   }
  // }

  Future<APIResp> fetchMasterCategory() async {
  print("--------------------- Enter fetchMasterCategory");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(AppConstants.token);
  print("Using token for fetchMasterCategory: $token");

  try {
    final resp = await APIService.get(
      UrlPath.loginUrl.mastercategory,
      params: {},
      console: true,
      auth: true,
      showNoInternet: false,
      forceLogout: false,
      timeout: const Duration(seconds: 30),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print("Response Status Code: ${resp.statusCode}");
    print("Response Data--------------->");
    print(resp.fullBody);

    if (resp.statusCode == 200 && resp.fullBody['data'] != null) {
      List<dynamic> jsonList = resp.fullBody['data'];

      /// ✅ Convert JSON → Model
      List<MastercategoryModel> categories =
          jsonList.map((e) => MastercategoryModel.fromJson(e)).toList();

      /// ✅ Store in provider
      _masterCategory = categories;
      notifyListeners();

      return APIResp(
        status: true,
        statusCode: resp.statusCode,
        data: categories,
        fullBody: resp.fullBody,
      );
    } else {
      throw APIException(
        type: APIErrorType.auth,
        message: resp.data?.toString() ?? "Error fetching master categories.",
      );
    }
  } catch (e) {
    print("❌ Exception in fetchMasterCategory: $e");
    return APIResp(
      status: false,
      statusCode: 500,
      data: null,
      fullBody: null,
    );
  }
}


  Future<APIResp> getStores() async {
    print("--------------------- enter getStores");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);
    print("Using token for getStores: $token");

    try {
      final resp = await APIService.get(
        UrlPath.loginUrl.getStore,
        params: {},
        console: true,
        auth: true,
        showNoInternet: false,
        forceLogout: false,
        timeout: const Duration(seconds: 30),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Status----------------------->");
      print(resp.status);
      print("Response Data------------------>");
      print(resp.data);

      // ✅ Instead of relying on resp.status, check HTTP code & JSON
      if (resp.statusCode == 200 && resp.fullBody['data'] != null) {
        List<dynamic> storeJsonList = resp.fullBody['data'] ?? [];
        _stores = storeJsonList
            .map((json) => StoreModel.fromJson(json))
            .toList();

        notifyListeners();

        return APIResp(
          status: true, // ✅ Force success
          statusCode: resp.statusCode,
          data: _stores,
          fullBody: resp.fullBody,
        );
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Error fetching stores.",
        );
      }
    } catch (e) {
      print("❌ Exception in getStores: $e");
      return APIResp(
        status: false,
        statusCode: 500,
        data: null,
        fullBody: null,
      );
    }
  }

  Future<APIResp> getProducts() async {
    print("--------------------- enter getProducts");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);
    print("Using token for getProducts: $token");

    try {
      final resp = await APIService.get(
        UrlPath.loginUrl.getProduct, // ✅ point to correct endpoint
        params: {},
        console: true,
        auth: true,
        showNoInternet: false,
        forceLogout: false,
        timeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Data------------------>");
      print(resp.data);

      if (resp.statusCode == 200 && resp.fullBody['data'] != null) {
        List<dynamic> productJsonList = resp.fullBody['data'];
        List<ProductModel> products = productJsonList
            .map((e) => ProductModel.fromJson(e))
            .toList();

        /// ✅ store products in provider for UI use
        _products = products;
        notifyListeners();

        return APIResp(
          status: true,
          statusCode: resp.statusCode,
          data: products,
          fullBody: resp.fullBody,
        );
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Error fetching products.",
        );
      }
    } catch (e) {
      print("❌ Exception in getProducts: $e");
      return APIResp(
        status: false,
        statusCode: 500,
        data: null,
        fullBody: null,
      );
    }
  }

  // Future<APIResp> addStoreProduct({
  //   required String productCode,
  //   required String productName,
  //   required String masterProductId,
  //   required String netQty,
  //   String? height,
  //   String? width,
  //   String? length,
  //   List<File>? dimenstionImages,
  // }) async {
  //   print("--------------------- enter addStoreProduct");

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString(AppConstants.token);

  //   try {
  //     /// ✅ Convert images to Base64 with better error handling
  //     List<String> base64Images = [];
  //     if (dimenstionImages != null) {
  //       for (var image in dimenstionImages) {
  //         try {
  //           // ✅ Check if file exists before reading
  //           if (await image.exists()) {
  //             final bytes = await image.readAsBytes();
  //             base64Images.add(base64Encode(bytes));
  //             print("✅ Successfully converted image: ${image.path}");
  //           } else {
  //             print("❌ File does not exist: ${image.path}");
  //           }
  //         } catch (e) {
  //           print("❌ Error processing image ${image.path}: $e");
  //           // Continue with other images even if one fails
  //         }
  //       }
  //     }

  //     print("📸 Total images converted to base64: ${base64Images.length}");

  //     /// ✅ Prepare request body
  //     final body = {
  //       "productCode": productCode,
  //       "name": productName,
  //       "dimenstionImages": base64Images,
  //       "masterProductId": masterProductId,
  //       "netQty": netQty,
  //       "height": height ?? "",
  //       "width": width ?? "",
  //       "length": length ?? "",
  //     };

  //     print("📤 Sending addStoreProduct request with body keys: ${body.keys}");
  //     print("📤 Images count in request: ${base64Images.length}");

  //     /// ✅ API Call using APIService
  //     final resp = await APIService.post(
  //       UrlPath
  //           .loginUrl
  //           .addProduct, // ✅ make sure endpoint is defined in UrlPath
  //       data: body,
  //       console: true,
  //       auth: true,
  //       showNoInternet: false,
  //       forceLogout: false,
  //       timeout: const Duration(seconds: 30),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     );

  //     print("📥 Response Status Code: ${resp.statusCode}");
  //     print("📥 Response Status: ${resp.status}");
  //     print("📥 Response Data: ${resp.data}");

  //     if (resp.status) {
  //       print("✅ Store product added successfully: ${resp.fullBody}");
  //       return APIResp(
  //         status: resp.status,
  //         statusCode: resp.statusCode,
  //         data: resp.data,
  //         fullBody: resp.fullBody,
  //       );
  //     } else {
  //       throw APIException(
  //         type: APIErrorType.auth,
  //         message: resp.data?.toString() ?? "Error adding store product.",
  //       );
  //     }
  //   } catch (e) {
  //     print("❌ Exception in addStoreProduct: $e");
  //     return APIResp(
  //       status: false,
  //       statusCode: 500,
  //       data: null,
  //       fullBody: null,
  //     );
  //   }
  // }

  // Future<APIResp> addStoreProduct({
  //   required String productCode,
  //   required String productName,
  //   required String masterProductId,
  //   required String netQty,
  //   String? height,
  //   String? width,
  //   String? length,
  //   List<File>? dimenstionImages, // Keeping the API's exact spelling
  // }) async {
  //   print("--------------------- enter addStoreProduct");

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString(AppConstants.token);

  //   try {
  //     // 1. Convert images to multipart files
  //     List<MultipartFile> multipartImages = [];
  //     if (dimenstionImages != null && dimenstionImages.isNotEmpty) {
  //       for (var image in dimenstionImages) {
  //         if (await image.exists()) {
  //           multipartImages.add(
  //             await MultipartFile.fromFile(
  //               image.path,
  //               filename:
  //                   'product_${DateTime.now().millisecondsSinceEpoch}${(image.path)}',
  //             ),
  //           );
  //           print("✅ Added image: ${image.path}");
  //         } else {
  //           print("❌ File not found: ${image.path}");
  //         }
  //       }
  //     }

  //     // 2. Prepare form data
  //     final formData = FormData.fromMap({
  //       "productCode": productCode,
  //       "name": productName,
  //       "dimenstionImages": multipartImages, // Matching API's spelling
  //       "masterProductId": masterProductId,
  //       "netQty": netQty,
  //       "height": height ?? "",
  //       "width": width ?? "",
  //       "length": length ?? "",
  //     });

  //     print("📦 Request data keys: ${formData.fields.map((f) => f.key)}");
  //     print("🖼️ Images count: ${multipartImages.length}");

  //     // 3. Make the API call using your existing APIService
  //     final resp = await APIService.post(
  //       UrlPath.loginUrl.addProduct,
  //       data: formData,
  //       console: true,
  //       auth: true,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         // ❌ Don't set 'Content-Type' manually
  //       },
  //     );

  //     if (resp.statusCode == 200 || resp.statusCode == 201) {
  //       print("✅ Store product added successfully");
  //       return APIResp(
  //         status: true,
  //         statusCode: resp.statusCode,
  //         data: resp.data,
  //         fullBody: resp.fullBody,
  //       );
  //     } else {
  //       final errMsg = resp.data?['message'] ?? "Failed to add product";
  //       print("❌ API Failed with message: $errMsg");
  //       throw APIException(type: APIErrorType.auth, message: errMsg);
  //     }
  //   } catch (e) {
  //     print("❌ Exception in addStoreProduct: $e");
  //     return APIResp(
  //       status: false,
  //       statusCode: 500,
  //       data: {'error': e.toString()},
  //       fullBody: null,
  //     );
  //   }
  // }

  // Future<Map<String, dynamic>?> addGsmProduct({
  //   required String token,
  //   required Map<String, dynamic> productData,
  // }) async {
  //   final url = Uri.parse('https://fulupostore.tsitcloud.com/api/gsm/product');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(productData),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final responseData = jsonDecode(response.body);
  //       debugPrint('✅ GSM Product added: ${responseData['data']['name']}');
  //       return responseData;
  //     } else {
  //       debugPrint('❌ Failed to add product: ${response.body}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('🚨 Error adding product: $e');
  //     return null;
  //   }
  // }
  Future<bool> submitGsmProduct({
    required String token,
    required String name,
    required String productCode,
    required String masterProductId,
    required String netQty,
    required String height,
    required String width,
    required String length,
    required List<File> images,
  }) async {
    try {
      var uri = Uri.parse(
        'https://fulupostore.tsitcloud.com/api/gsm/product',
      ); // your endpoint
      log('https://fulupostore.tsitcloud.com/api/gsm/product');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['productCode'] = productCode
        ..fields['masterProductId'] = masterProductId
        ..fields['netQty'] = netQty
        ..fields['height'] = height
        ..fields['width'] = width
        ..fields['length'] = length;

      for (int i = 0; i < images.length; i++) {
        final image = await http.MultipartFile.fromPath(
          'dimenstionImages', // Must match backend field
          images[i].path,
        );
        request.files.add(image);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = jsonDecode(response.body);

        print("✅ Product Upload Success: ${resData['message']}");
        log("✅ Product Upload Success: ${resData['message']}");

        return true;
      } else {
        print("❌ Upload Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception during API call: $e");
      return false;
    }
  }

  Future<APIResp> getGSMProducts() async {
    print("--------------------- enter getGSMProducts");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);
    print("Using token for getGSMProducts: $token");

    try {
      final resp = await APIService.get(
        UrlPath.loginUrl.gsmProduct, // ✅ change to your GSM product endpoint
        params: {},
        console: true,
        auth: true,
        showNoInternet: false,
        forceLogout: false,
        timeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Response Status Code: ${resp.statusCode}");
      print("GSM Product Response Data -->");
      print(resp.data);

      if (resp.statusCode == 200 && resp.fullBody['data'] != null) {
        List<dynamic> gsmJsonList = resp.fullBody['data'];

        List<Gsmproductmodel> gsmProducts = gsmJsonList
            .map((e) => Gsmproductmodel.fromJson(e))
            .toList();

        _gsmproducts =
            gsmProducts; // 🔁 you can declare _gsmProducts list in your provider
        notifyListeners();

        return APIResp(
          status: true,
          statusCode: resp.statusCode,
          data: gsmProducts,
          fullBody: resp.fullBody,
        );
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Error fetching GSM products.",
        );
      }
    } catch (e) {
      print("❌ Exception in getGSMProducts: $e");
      return APIResp(
        status: false,
        statusCode: 500,
        data: null,
        fullBody: null,
      );
    }
  }
}
