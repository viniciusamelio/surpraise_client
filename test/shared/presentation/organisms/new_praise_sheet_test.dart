import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/widgets/input/base_dropdown.dart';
import 'package:blurple/widgets/input/base_input.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/community/community.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/core/external_dependencies.dart'
    hide CommunityRepository, equals;
import 'package:surpraise_client/shared/shared.dart';

import '../../../mocks.dart';

void main() {
  group("New Praise Sheet: ", () {
    late NewPraiseSheet sut;
    late PraiseController controller;
    late SessionController sessionController;
    late GetCommunitiesController communitiesController;
    late PraiseUsecase praiseUsecase;

    late GetCommunitiesByUserQuery communitiesByUserQuery;
    late GetUserByTagQuery getUserByTagQuery;
    setUp(() async {
      communitiesByUserQuery = MockCommunitiesByUserQuery();
      sessionController = MockSessionController();
      getUserByTagQuery = MockGetUserByTagQuery();
      communitiesController = DefaultGetCommunitiesController(
        getCommunitiesByUserQuery: communitiesByUserQuery,
      );

      praiseUsecase = MockPraiseUsecase();

      controller = DefaultPraiseController(
        getUserByTagQuery: getUserByTagQuery,
        praiseUsecase: praiseUsecase,
      );

      inject<SessionController>(sessionController);
      inject<GetCommunitiesController>(communitiesController);
      inject<PraiseController>(controller);
      inject<TranslationService>(DefaultTranslationService());
      inject<ApplicationEventBus>(DefaultBus());
      final translationService = injected<TranslationService>();
      await translationService.init(
        supportedLocales: [
          const Locale("pt"),
        ],
      );
      await translationService.load(const Locale("pt"));
      registerFallbackValue(
        PraiseInput(
          commmunityId: faker.guid.guid(),
          message: faker.lorem.words(4).join(" "),
          praisedId: faker.guid.guid(),
          praiserId: faker.guid.guid(),
          topic: "#kindness",
        ),
      );

      registerFallbackValue(
        GetCommunitiesByUserInput(
          id: faker.guid.guid(),
        ),
      );

      when(() => communitiesByUserQuery.call(any())).thenAnswer(
        (invocation) async => Right(
          GetCommunitiesByUserOutput(
            value: [
              CommunityOutput(
                id: faker.guid.guid(),
                ownerId: faker.guid.guid(),
                description: faker.lorem.word(),
                title: "Mocked Community",
                image: faker.internet.httpsUrl(),
                role: faker.randomGenerator.element(Role.values),
              )
            ],
          ),
        ),
      );
      when(
        () => getUserByTagQuery(
          GetUserByTagQueryInput(
            tag: "@none",
          ),
        ),
      ).thenAnswer(
        (invocation) async => Left(
          QueryError("User not found"),
        ),
      );
      when(
        () => getUserByTagQuery(
          GetUserByTagQueryInput(
            tag: "@vini",
          ),
        ),
      ).thenAnswer(
        (invocation) async => Right(
          GetUserQueryOutput(
            value: GetUserDto(
              tag: "@vini",
              name: "Vinicius",
              email: "vini@surpraise.com",
              id: faker.guid.guid(),
            ),
          ),
        ),
      );

      when(
        () => praiseUsecase.call(any()),
      ).thenAnswer((invocation) async => Right(const PraiseOutput()));

      sut = const NewPraiseSheet();
    });

    testWidgets(
      "sut should follow expected flow",
      (tester) async {
        await tester.pumpWidget(
          BlurpleThemeData.defaultTheme(
            child: MaterialApp(
              home: Builder(builder: (context) {
                return Scaffold(
                  body: MaterialButton(onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => sut,
                    );
                  }),
                );
              }),
            ),
          ),
        );
        await tester.tap(find.byType(MaterialButton));
        await tester.pumpAndSettle();

        expect(
          find.text(
            "Vamos começar selecionando a comunidade de quem vai receber o praise",
          ),
          findsOneWidget,
        );
        expect(
          find.text("Comunidade de quem vai receber o praise"),
          findsOneWidget,
        );

        await tester.tap(
          find.byType(BaseSearchableDropdown<CommunityOutput>),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(
          find.text("Mocked Community", skipOffstage: false),
          findsOneWidget,
        );

        await tester.tap(find.text("Mocked Community", skipOffstage: false));
        await tester.pumpAndSettle();

        expect(controller.activeStep.value, equals(1));

        await tester.enterText(
          find.byType(UserSearchInput),
          "none",
        );
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        expect(controller.userState.value, isA<ErrorState>());
        expect(
          find.text(
            "Não conseguimos encontrar nenhum usuário com o @ especificado",
          ),
          findsOneWidget,
        );

        await tester.enterText(
          find.byType(UserSearchInput),
          "vini",
        );
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        expect(controller.activeStep.value, equals(2));

        await tester.enterText(
          find.byType(
            BaseSearchableDropdown<TopicValues>,
            skipOffstage: false,
          ),
          "kind",
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            TopicValues.kind.name,
            skipOffstage: false,
          ),
          findsNWidgets(2),
        );
        await tester.tap(
          find
              .text(
                TopicValues.kind.name,
                skipOffstage: false,
              )
              .last,
        );
        await tester.pumpAndSettle();

        expect(controller.formData.topic, equals(TopicValues.kind.value));

        await tester.enterText(
          find.byType(BaseInput).last,
          "asuahsauh asuhasuah asuhauashusauhas",
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text("#praise  >"));
        await tester.tap(find.text("#praise  >"));
        await tester.pumpAndSettle();

        expect(find.text("#praise  >"), findsNothing);
      },
    );
  });
}
