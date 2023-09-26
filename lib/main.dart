import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/core.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseCloudClient.init();
  await Hive.initFlutter();
  await setupDependencies();
  runApp(const App());
}
