import 'feed.dart';
import '../../core/di/di.dart';

Future<void> feedDependencies() async {
  inject<FeedRepository>(
    DefaultFeedRepository(
      httpClient: injected(),
      databaseDatasource: injected(),
    ),
  );
  inject<FeedController>(
    DefaultFeedController(
      feedRepository: injected(),
    ),
  );
}
