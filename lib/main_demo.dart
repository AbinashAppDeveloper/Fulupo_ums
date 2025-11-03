

import 'package:fulupo_ums/flavours.dart';
import 'package:fulupo_ums/main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.demo;
  await runner.main();
}
