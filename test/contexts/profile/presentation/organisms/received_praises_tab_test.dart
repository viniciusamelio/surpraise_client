import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surpraise_client/contexts/feed/presentation/molecules/molecules.dart';
import 'package:surpraise_client/contexts/profile/presentation/organisms/organisms.dart';
import 'package:surpraise_client/core/core.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/env.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group("Received Praises Tab: ", () {
    setUpAll(() {
      inject<SessionController>(MockSessionController());
      Env.sbUrl = "https://mock.com";
      HttpOverrides.global = null;
    });
    testWidgets(
      "sut should return a Loader on loading",
      (tester) async {
        await tester.pumpWidget(
          testWidgetTemplate(
            sut: ReceivedPraisesTabOrganism(
              state: AtomNotifier(LoadingState()),
            ),
          ),
        );

        expect(find.byType(LoaderMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should return error widget on error state",
      (tester) async {
        await tester.pumpWidget(
          testWidgetTemplate(
            sut: ReceivedPraisesTabOrganism(
              state: AtomNotifier(ErrorState(Exception())),
            ),
          ),
        );

        expect(find.byType(ErrorWidgetMolecule), findsOneWidget);
      },
    );

    testWidgets(
      "sut should return received praises according to state value",
      (tester) async {
        await tester.pumpWidget(
          testWidgetTemplate(
            sut: ReceivedPraisesTabOrganism(
              state: AtomNotifier(
                SuccessState(
                  [
                    PraiseDto(
                      id: faker.guid.guid(),
                      message: faker.lorem.words(3).join(","),
                      topic: "#fakeTopic",
                      communityName: faker.lorem.word(),
                      communityId: faker.guid.guid(),
                      praiser: UserDto(
                        tag: "@${faker.person.firstName()}",
                        name: faker.person.name(),
                        email: faker.internet.email(),
                        id: faker.guid.guid(),
                      ),
                    ),
                    PraiseDto(
                      id: faker.guid.guid(),
                      message: faker.lorem.words(3).join(","),
                      topic: "#fakeTopic",
                      communityName: faker.lorem.word(),
                      communityId: faker.guid.guid(),
                      praiser: UserDto(
                        tag: "@${faker.person.firstName()}",
                        name: faker.person.name(),
                        email: faker.internet.email(),
                        id: faker.guid.guid(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(PraiseCardMolecule), findsNWidgets(2));
      },
    );
  });
}
