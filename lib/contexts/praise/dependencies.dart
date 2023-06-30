import '../../shared/shared.dart';

import '../../core/core.dart';
import 'praise.dart';

Future<void> praiseDependencies() async {
  inject<PraiseRepository>(
    DefaultPraiseRepository(
      httpClient: injected(),
    ),
  );
  inject<PraiseController>(
    DefaultPraiseController(
      praiseRepository: injected(),
      communityRepository: injected(),
    ),
  );
}
