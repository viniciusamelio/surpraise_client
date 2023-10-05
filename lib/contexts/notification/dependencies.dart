import '../../core/di/di.dart';
import '../../core/external_dependencies.dart';
import 'notification.dart';

Future<void> notificationDependencies() async {
  inject<GetNotificationsRepository>(
    DefaultGetNotificationsRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<ReadNotificationsRepository>(
    DefaultReadNotificationsRepository(
      databaseDatasource: injected(),
    ),
  );
  inject<NotificationsController>(
    DefaultNotificationsController(
      getNotificationsRepository: injected(),
      readNotificationsRepository: injected(),
    ),
    singleton: true,
  );
}
