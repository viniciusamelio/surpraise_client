import '../../../../core/core.dart';
import '../../../../core/external_dependencies.dart';
import '../../../../shared/presentation/controllers/controllers.dart';
import '../../dtos.dart';
import '../../notification.dart';

abstract class NotificationsController
    extends BaseStateController<Notifications> {
  AtomNotifier<int> get unreadNotifications;

  Future<void> getNotifications({
    int max = 20,
    int offset = 0,
  });

  Future<void> listen();

  Future<void> readNotifications();
}

class DefaultNotificationsController
    with BaseState<Exception, Notifications>
    implements NotificationsController {
  DefaultNotificationsController({
    required GetNotificationsRepository getNotificationsRepository,
    required ReadNotificationsRepository readNotificationsRepository,
  })  : _getNotificationsRepository = getNotificationsRepository,
        _readNotificationsRepository = readNotificationsRepository {
    state.on<SuccessState<Exception, Notifications>>(
      (value) {
        unreadNotifications
            .set(value.data.where((element) => !element.viewed).length);
      },
    );
  }
  final ReadNotificationsRepository _readNotificationsRepository;
  final GetNotificationsRepository _getNotificationsRepository;
  @override
  Future<void> getNotifications({
    int max = 100,
    int offset = 0,
  }) async {
    state.set(LoadingState());
    final notificationsOrError = await _getNotificationsRepository.get(
      userId: injected<SessionController>().currentUser.value!.id,
      limit: max,
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
    await _readNotificationsRepository.read(
      injected<SessionController>().currentUser.value!.id,
    );
    injected<ApplicationEventBus>().add(
      const ReadNotificationsEvent(
        null,
      ),
    );
  }

  @override
  final AtomNotifier<int> unreadNotifications = AtomNotifier(0);

  @override
  Future<void> listen() async {
    Supabase.instance.client
        .from("notification")
        .stream(
          primaryKey: ["id"],
        )
        .eq(
          "user_id",
          injected<SessionController>().currentUser.value!.id,
        )
        .listen(
          (_) => getNotifications(),
        );
  }
}
