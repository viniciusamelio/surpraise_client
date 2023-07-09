import '../../core/core.dart';
import 'intro.dart';

Future<void> introDependencies() async {
  inject<IntroController>(
    DefaultIntroController(
      authPersistanceService: injected(),
      storageService: injected(),
      authService: injected(),
    ),
  );
}
