import 'package:dio/dio.dart';
import 'package:scientisst_db/scientisst_db.dart';

import '../contexts/auth/auth.dart';
import '../contexts/intro/intro.dart';
import '../env.dart';
import 'core.dart';

export "package:surpraise_core/surpraise_core.dart";

Future<void> _coreDependencies() async {
  inject<AppWriteService>(AppWriteService());
  inject<HttpClient>(
    DioClient.defaultClient(
      Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
        ),
      ),
    ),
  );
  inject<ScientistDBService>(
    ScientistDBService(
      database: ScientISSTdb.instance,
    ),
  );
}

Future<void> setupDependencies() async {
  await _coreDependencies();
  await authDependencies();
  await introDependencies();
}
