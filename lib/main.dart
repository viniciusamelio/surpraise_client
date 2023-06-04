import 'package:flutter/material.dart';
import 'core/dependencies.dart';

import 'app.dart';

void main() async {
  await setupDependencies();
  runApp(const App());
}
