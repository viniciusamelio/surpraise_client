import 'package:flutter/material.dart';
import 'core/core.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  await AppWriteService.init();
  runApp(const App());
}
