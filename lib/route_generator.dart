import 'package:flutter/material.dart';
import 'package:fulupo_ums/pages/Otpverifypage.dart';
import 'package:fulupo_ums/pages/Storepage.dart';
import 'package:fulupo_ums/pages/addProduct.dart';
import 'package:fulupo_ums/pages/demo/demohomepage.dart';
import 'package:fulupo_ums/pages/homepage.dart';
import 'package:fulupo_ums/pages/homepage1.dart';
import 'package:fulupo_ums/pages/homepage2.dart';
import 'package:fulupo_ums/pages/loginPage.dart';
import 'package:fulupo_ums/pages/profilepage.dart';

enum AppRouteName {
  loginPage('/loginPage'),
  otpPage('/Otpverifypage'),
  demohomepage('/demohomepage'),
  homepage('/homepage'),
  homepage2('/homepage2'),
  homepage1('/homepage1'),
  addProduct('/addProduct'),
  profilepage('/profilepage'),
  Storepage('/Storepage');

  final String value;
  const AppRouteName(this.value);
}

extension AppRouteNameExt on AppRouteName {
  Future<T?> push<T extends Object?>(
    BuildContext context, {
    Object? args,
  }) async {
    return await Navigator.pushNamed<T>(context, value, arguments: args);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil<T>(
      context,
      value,
      predicate,
      arguments: args,
    );
  }

  Future<T?> popAndPush<T extends Object?>(
    BuildContext context, {
    Object? args,
  }) async {
    return await Navigator.popAndPushNamed(context, value);
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = AppRouteName.values
        .where((element) => element.value == settings.name)
        .firstOrNull;

    switch (name) {
      case AppRouteName.loginPage:
        return MaterialPageRoute(builder: (_) => Loginpage());
      case AppRouteName.otpPage:
        final userId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => Otpverifypage(userId: userId));
      case AppRouteName.demohomepage:
        return MaterialPageRoute(builder: (_) => DemoHomepage());  
      // case AppRouteName.homepage:
      //   return MaterialPageRoute(builder: (_) => Homepage());
      case AppRouteName.homepage2:
        return MaterialPageRoute(builder: (_) => Homepage2());
      case AppRouteName.homepage1:  


      
        return MaterialPageRoute(builder: (_) => Homepage1());
      // case AppRouteName.addProduct:
      //   return MaterialPageRoute(builder: (_) => Addproduct())  ;

      case AppRouteName.addProduct:
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => Addproduct(
            preSelectedCategory: args?['category'], // ✅ pass it forward
          ),
        );
      case AppRouteName.profilepage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case AppRouteName.Storepage:
        return MaterialPageRoute(builder: (_) => Storepage());
      case null:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text("Route not found"))),
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text("Route Error"))),
        );
    }
  }
}

class AudioScreenArgs<T extends ChangeNotifier, R extends Object?> {
  final T provider;

  AudioScreenArgs({required this.provider});
}
