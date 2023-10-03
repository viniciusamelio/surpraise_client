import '../../../../core/di/di.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../core/state/state.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../dtos.dart';

abstract class NotificationsController
    extends BaseStateController<Notifications> {
  AtomNotifier<int> get unreadNotifications;

  Future<void> getNotifications({
    int max = 20,
    int offset = 0,
  });

  Future<void> readNotifications();
}

class DefaultNotificationsController
    with BaseState<Exception, Notifications>
    implements NotificationsController {
  DefaultNotificationsController({
    required GetNotificationsRepository getNotificationsRepository,
  }) : _getNotificationsRepository = getNotificationsRepository {
    state.on<SuccessState<Exception, Notifications>>(
      (value) {
        unreadNotifications
            .set(value.data.where((element) => !element.viewed).length);
      },
    );
  }

  final GetNotificationsRepository _getNotificationsRepository;
  @override
  Future<void> getNotifications({
    int max = 20,
    int offset = 0,
  }) async {
    state.set(LoadingState());
    final notificationsOrError = await _getNotificationsRepository.get(
      userId: injected<SessionController>().currentUser.value!.id,
    );
    notificationsOrError.fold(
      (left) => state.set(ErrorState(left)),
      (right) {
        state.set(
          SuccessState(
            right
                .map(
                  (e) => NotificationDto(
                    id: e.id,
                    userId: e.userId,
                    message: e.message,
                    sentAt: e.sentAt,
                    topic: e.topic,
                    viewed: e.viewed,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Future<void> readNotifications() async {
    // TODO: implement readNotifications
  }

  @override
  final AtomNotifier<int> unreadNotifications = AtomNotifier(0);
}
