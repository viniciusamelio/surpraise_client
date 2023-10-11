import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pressable/pressable.dart';
import 'package:surpraise_client/contexts/profile/presentation/organisms/organisms.dart';
import 'package:surpraise_client/core/di/di.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/core/state/default_state.dart';
import 'package:surpraise_client/shared/presentation/controllers/session.dart';
import 'package:surpraise_client/shared/presentation/molecules/molecules.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group(
    "Communities Tab: ",
    () {
      setUpAll(() {
        inject<SessionController>(MockSessionController());

        HttpOverrides.global = null;
      });
      testWidgets(
        "sut should return a Loader on loading",
        (tester) async {
          await tester.pumpWidget(
            testWidgetTemplate(
              sut: CommunitiesTabOrganism(
                state: ValueNotifier(LoadingState()),
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
              sut: CommunitiesTabOrganism(
                state: ValueNotifier(ErrorState(
                  Exception(),
                )),
              ),
            ),
          );

          expect(find.byType(ErrorWidgetMolecule), findsOneWidget);
          expect(
            find.text("Deu ruim ao recuperar suas comunidadas"),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        "sut should return communities according to state value",
        (tester) async {
          await tester.pumpWidget(
            testWidgetTemplate(
              sut: CommunitiesTabOrganism(
                state: ValueNotifier(
                  SuccessState(
                    [
                      CommunityOutput(
                        id: faker.guid.guid(),
                        ownerId:
                            injected<SessionController>().currentUser.value!.id,
                        description: faker.lorem.words(3).join(","),
                        title: faker.lorem.word(),
                        image: faker.internet.httpsUrl(),
                        role: faker.randomGenerator.element(Role.values),
                      ),
                      CommunityOutput(
                        id: faker.guid.guid(),
                        ownerId: faker.guid.guid(),
                        description: faker.lorem.words(3).join(","),
                        title: faker.lorem.word(),
                        image: faker.internet.httpsUrl(),
                        role: faker.randomGenerator.element(Role.values),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          expect(
            find.byType(ErrorWidgetMolecule),
            findsNothing,
          );
          expect(
            find.byType(PressableScale),
            findsNWidgets(2),
          );
        },
      );
    },
  );
}
