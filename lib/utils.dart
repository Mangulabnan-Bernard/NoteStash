import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox('appdata');
}