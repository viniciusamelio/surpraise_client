import 'feed.dart';
import '../../core/di/di.dart';

Future<void> feedDependencies() async {
  inject<FeedRepository>(
    DefaultFeedRepository(
      databaseDatasource: injected(),
      supabaseCloudClient: injected(),
    ),
  );
  inject<FeedController>(
    DefaultFeedController(
      feedRepository: injected(),
      realtimeQueryClient: injected(),
    ),
  );
  inject<ReactionController>(
    DefaultReactionController(
      feedRepository: injected(),
      eventBus: injected(),
    ),
  );
}
