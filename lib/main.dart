import 'package:flutter/material.dart';
import 'package:fulupo_ums/app.dart';
import 'package:fulupo_ums/config/app_intialize.dart';

Future<void> main() async {
  await AppInitialize.start();
  runApp( MyApp());
}
