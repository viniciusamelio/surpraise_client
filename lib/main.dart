import 'package:flutter/material.dart';
import 'core/core.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseCloudClient.init();
  await setupDependencies();
  runApp(const App());
}
