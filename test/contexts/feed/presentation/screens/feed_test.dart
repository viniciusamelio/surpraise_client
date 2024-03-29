import 'dart:io';

import 'package:blurple/themes/theme_data.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/feed/feed.dart';
import 'package:surpraise_client/contexts/feed/presentation/molecules/molecules.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/env.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group("Feed Screen: ", () {
    late SessionController sessionController;
    late FeedController controller;
    late AnswerInviteController answerInviteController;

    late FeedRepository feedRepository;
    late RealtimeQuery realtimeQueryClient;
    late Widget sut;

    setUp(() {
      feedRepository = MockFeedRepository();
      realtimeQueryClient = MockSupabaseClient();
      sessionController = MockSessionController();
      answerInviteController = MockAnswerInviteController();
      controller = DefaultFeedController(
        feedRepository: feedRepository,
        realtimeQueryClient: realtimeQueryClient,
      );

      inject<SessionController>(sessionController);
      inject<AnswerInviteController>(answerInviteController);
      inject<FeedController>(controller);
      inject<ApplicationEventBus>(DefaultBus());

      registerFallbackValue(
        const ListenableField(
          value: "value",
          fieldName: "fieldName",
        ),
      );

      when(
        () => realtimeQueryClient.run(
          primaryKeyName: any(named: "primaryKeyName"),
          source: any(named: "source"),
          where: any(named: "where"),
          callback: any(named: "callback"),
        ),
      ).thenReturn(null);

      when(
        () => feedRepository.getInvites(userId: any(named: "userId")),
      ).thenAnswer((_) async => Right([]));

      sut = testWidgetTemplate(
        sut: BlurpleThemeData.defaultTheme(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: Scaffold(
              body: FeedScreen(
                user: sessionController.currentUser.value!,
              ),
            ),
          ),
        ),
      );
    });

    setUpAll(() => HttpOverrides.global = null);
    tearDown(() => KiwiContainer().clear());

    testWidgets(
      "sut should show error widget when feed.get() fails",
      (tester) async {
        when(
          () => feedRepository.get(
            userId: any(named: "userId"),
            max: any(named: "max"),
            offset: any(named: "offset"),
          ),
        ).thenAnswer(
          (_) async => Left(
            Exception(),
          ),
        );

        await tester.pumpWidget(
          sut,
        );
        await tester.pump(const Duration(seconds: 2));

        expect(find.byType(ErrorWidgetMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should show feed when it is returned successfully and it is not empty",
      (tester) async {
        final message = faker.lorem.words(4).join(" ");
        Env.sbUrl = "https://mock.com";
        when(
          () => feedRepository.get(
            userId: any(named: "userId"),
            offset: any(named: "offset"),
            max: any(named: "max"),
          ),
        ).thenAnswer(
          (_) async => Right([
            PraiseDto(
              id: faker.guid.guid(),
              message: message,
              topic: faker.randomGenerator.element(TopicValues.values).value,
              communityName: faker.lorem.word(),
              communityId: faker.guid.guid(),
              praiser: UserDto(
                tag: "@${faker.person.name()}",
                name: faker.person.name(),
                email: faker.internet.email(),
                id: faker.guid.guid(),
              ),
              praised: UserDto(
                tag: "@${faker.person.name()}",
                name: faker.person.name(),
                email: faker.internet.email(),
                id: faker.guid.guid(),
              ),
            )
          ]),
        );

        await tester.pumpWidget(
          sut,
        );
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        expect(find.byType(ErrorWidgetMolecule), findsNothing);
        expect(find.text(message), findsOneWidget);
        expect(find.byType(PraiseCardMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should show empty state screen when no praise is returned",
      (tester) async {
        when(
          () => feedRepository.get(
            userId: any(named: "userId"),
            offset: any(named: "offset"),
            max: any(named: "max"),
          ),
        ).thenAnswer(
          (_) async => Right([]),
        );

        await tester.pumpWidget(
          sut,
        );
        await tester.pump(const Duration(seconds: 2));

        expect(find.text("error"), findsNothing);
        expect(
          find.text(
            "Parece que você não tem novos #praises por aqui, que tal começar enviando um?! É só apertar o botão abaixo",
          ),
          findsOneWidget,
        );
        expect(find.byType(Lottie), findsOneWidget);
      },
    );
  });
}
