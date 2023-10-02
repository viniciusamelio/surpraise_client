import '../../../../core/state/base_state_controller.dart';
import '../../dtos.dart';

abstract class NotificationsController
    extends BaseStateController<Notifications> {
  Future<void> getNotifications({
    required int max,
    required int offset,
  });

  Future<void> readNotifications();
}
