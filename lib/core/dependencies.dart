import 'package:dio/dio.dart';

import '../contexts/auth/auth.dart';
import 'core.dart';

export "package:surpraise_core/surpraise_core.dart";

Future<void> _coreDependencies() async {
  inject<AppWriteService>(AppWriteService());
  inject<HttpClient>(
    DioClient.defaultClient(
      Dio(),
    ),
  );
}

Future<void> setupDependencies() async {
  await _coreDependencies();
  await authDependencies();
}
