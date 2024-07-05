import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/core.dart';

import 'app.dart';
import 'env.dart';
import 'translations/locale_sync.dart';

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

  await LocaleSync.setup(
    apiToken: "dcc993e1-f722-455b-999a-7b9c730c5a74",
    repositoryId: "repository:3vm1yx9dpjg4xlsh7yna",
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDSN;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      FlutterError.onError = (details) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack,
        );
      };
      runApp(
        const App(),
      );
    },
  );
}
