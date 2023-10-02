import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'core/core.dart';

import 'app.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseCloudClient.init();
  await Hive.initFlutter();
  await setupDependencies();
  if (kDebugMode) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  }
  OneSignal.initialize(Env.oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);

  runApp(const App());
}
