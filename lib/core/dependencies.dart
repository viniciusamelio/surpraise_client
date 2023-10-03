import 'dart:ui';

import 'package:hive/hive.dart';

import '../contexts/notification/notification.dart';
import '../contexts/praise/praise.dart';
import '../contexts/auth/auth.dart';
import '../contexts/community/community.dart';
import '../contexts/feed/feed.dart';
import '../contexts/intro/intro.dart';
import '../contexts/profile/dependencies.dart';
import '../contexts/settings/settings.dart';
import '../env.dart';
import 'core.dart';
import 'external_dependencies.dart';

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
      imageManager: injected(),
    ),
  );
  inject<ApplicationEventBus>(
    DefaultBus(),
    singleton: true,
  );
  inject<TranslationService>(
    DefaultTranslationService(),
  );
  final box = await Hive.openBox("user");
  inject<Box>(box);
  inject<LinkHandler>(
    LinkService(),
  );

  await injected<TranslationService>().init(supportedLocales: [
    const Locale("pt"),
  ]);

  await injected<TranslationService>().load(
    const Locale("pt"),
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
  await settingsDependencies();
  await notificationDependencies();
}
