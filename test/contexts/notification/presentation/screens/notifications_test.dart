import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/notification/notification.dart';
import 'package:surpraise_client/core/di/di.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/shared/presentation/controllers/controllers.dart';
import 'package:surpraise_client/shared/presentation/molecules/error_widget.dart';
import 'package:surpraise_client/shared/presentation/molecules/loader.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group("Notifications Screen: ", () {
    late GetNotificationsRepository getNotificationsRepository;
    late NotificationsScreen sut;

    setUpAll(() {
      getNotificationsRepository = MockGetNotificationsRepository();
      inject<SessionController>(MockSessionController());
      inject<NotificationsController>(
        DefaultNotificationsController(
          getNotificationsRepository: getNotificationsRepository,
        ),
      );
      sut = const NotificationsScreen();
    });

    testWidgets(
      "sut should show loader when getting notifications request is loading",
      (tester) async {
        when(
          () => getNotificationsRepository.get(
            userId: any(named: "userId"),
          ),
        ).thenAnswer(
          (_) async => Left(
            Exception(),
          ),
        );

        await tester.pumpWidget(testWidgetTemplate(sut: sut));

        expect(find.byType(LoaderMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should show error widget when getting notifications request fails",
      (tester) async {
        when(
          () => getNotificationsRepository.get(
            userId: any(named: "userId"),
          ),
        ).thenAnswer(
          (_) async => Left(
            Exception(),
          ),
        );

        await tester.pumpWidget(testWidgetTemplate(sut: sut));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(LoaderMolecule), findsNothing);
        expect(find.byType(ErrorWidgetMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should show notification list when getting notifications request succeeds",
      (tester) async {
        final List<GetNotificationOutput> notifications = [];

        for (var i = 0; i < faker.randomGenerator.integer(100); i++) {
          notifications.add(
            GetNotificationOutput(
              id: faker.guid.guid(),
              userId: faker.guid.guid(),
              message: faker.lorem.sentence(),
              sentAt: faker.date.dateTime(),
              topic: faker.lorem.sentence(),
              viewed: faker.randomGenerator.boolean(),
            ),
          );
        }

        when(
          () => getNotificationsRepository.get(
            userId: any(named: "userId"),
          ),
        ).thenAnswer(
          (_) async => Right(notifications),
        );

        await tester.pumpWidget(testWidgetTemplate(sut: sut));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(LoaderMolecule), findsNothing);
        expect(find.byType(ErrorWidgetMolecule), findsNothing);
        expect(
          find.byType(
            NotificationTileMolecule,
            skipOffstage: false,
          ),
          findsNWidgets(notifications.length),
        );
      },
    );
  });
}
