import 'package:dio/dio.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:surpraise_infra/surpraise_infra.dart' hide DatabaseDatasource;

import '../contexts/praise/praise.dart';
import '../contexts/auth/auth.dart';
import '../contexts/community/community.dart';
import '../contexts/feed/feed.dart';
import '../contexts/intro/intro.dart';
import '../contexts/profile/dependencies.dart';
import '../env.dart';
import 'core.dart';

export "package:surpraise_core/surpraise_core.dart";

Future<void> _coreDependencies() async {
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
  inject<DatabaseDatasource>(
    SupabaseDatasource(
      supabase: Supabase.instance.client,
    ),
  );
  inject<ImageManager>(ImagePickerService());
  inject<SupabaseCloudClient>(
    SupabaseCloudClient(
      supabase: Supabase.instance.client,
    ),
  );
  inject<IdService>(UuidService());
  inject<StorageService>(
    SupabaseStorageService(
      supabaseClient: injected(),
    ),
  );
  inject<ImageUploader>(
    DefaultImageUploader(
      supabaseCloudClient: injected(),
    ),
  );
  inject<ImageController>(
    DefaultImageController(
      imageUploader: injected(),
    ),
  );
}

Future<void> setupDependencies() async {
  await _coreDependencies();
  await authDependencies();
  await introDependencies();
  await feedDependencies();
  await communityDependencies();
  await praiseDependencies();
  await profileDependencies();
}
