import 'feed.dart';
import '../../core/di/di.dart';

Future<void> feedDependencies() async {
  inject<FeedRepository>(
    DefaultFeedRepository(
      databaseDatasource: injected(),
      httpClient: injected(),
    ),
  );
  inject<FeedController>(
    DefaultFeedController(
      feedRepository: injected(),
    ),
  );
}
