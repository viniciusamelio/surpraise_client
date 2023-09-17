import '../../core/external_dependencies.dart';
import '../../shared/shared.dart';

import '../../core/core.dart';

Future<void> praiseDependencies() async {
  inject<PraiseRepository>(
    PraiseRepository(
      datasource: injected(),
    ),
  );
  inject<PraiseUsecase>(
    DbPraiseUsecase(
      createPraiseRepository: injected<PraiseRepository>(),
      findPraiseUsersRepository: injected<PraiseRepository>(),
      idService: injected(),
    ),
  );
  inject<PraiseController>(
    DefaultPraiseController(
      praiseUsecase: injected(),
      communityRepository: injected(),
    ),
  );
}
