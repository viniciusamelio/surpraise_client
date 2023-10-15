import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surpraise_client/contexts/profile/presentation/presentation.dart';
import 'package:surpraise_client/core/di/di.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/shared/shared.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  late final SessionController sessionController;
  group("Profile Header: ", () {
    sessionController = MockSessionController();
    setUp(() {
      inject<SessionController>(sessionController);
    });
    setUpAll(() {
      HttpOverrides.global = null;
    });

    tearDown(() {
      KiwiContainer().clear();
    });

    testWidgets(
        "sut should show icon instead of avatar image when url is null & cachedImage is null too",
        (tester) async {
      sessionController.updateUser(
        UserDto(
          id: faker.guid.guid(),
          name: faker.person.name(),
          email: faker.internet.email(),
          tag: "@${faker.person.firstName()}",
        ),
      );

      await tester.pumpWidget(
        testWidgetTemplate(
          sut: ProfileHeaderOrganism(
            user: sessionController.currentUser.value!,
            onRemoveAvatarConfirmed: () {},
            uploadAction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byIcon(HeroiconsMini.user), findsOneWidget);
    });

    testWidgets(
        "sut should show icon instead of avatar image when url is empty & cachedImage is null too",
        (tester) async {
      sessionController.updateUser(
        UserDto(
          id: faker.guid.guid(),
          name: faker.person.name(),
          email: faker.internet.email(),
          avatarUrl: "",
          tag: "@${faker.person.firstName()}",
        ),
      );

      await tester.pumpWidget(
        testWidgetTemplate(
          sut: ProfileHeaderOrganism(
            user: sessionController.currentUser.value!,
            onRemoveAvatarConfirmed: () {},
            uploadAction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byIcon(HeroiconsMini.user), findsOneWidget);
    });

    testWidgets("sut should show cached image when it set successfully",
        (tester) async {
      sessionController.updateUser(
        UserDto(
          id: faker.guid.guid(),
          name: faker.person.name(),
          email: faker.internet.email(),
          cachedAvatar: File(""),
          avatarUrl: faker.internet.httpsUrl(),
          tag: "@${faker.person.firstName()}",
        ),
      );

      await tester.pumpWidget(
        testWidgetTemplate(
          sut: ProfileHeaderOrganism(
            user: sessionController.currentUser.value!,
            onRemoveAvatarConfirmed: () {},
            uploadAction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(HeroiconsMini.user), findsNothing);

      final avatarMolecule = tester.widget<AvatarMolecule>(
        find.byType(
          AvatarMolecule,
        ),
      );

      expect(avatarMolecule.imageUrl, isNotEmpty);
      expect(avatarMolecule.imageUrl, isNotNull);
    });

    testWidgets("sut should show network image when it is not null nor empty",
        (tester) async {
      await tester.pumpWidget(
        testWidgetTemplate(
          sut: ProfileHeaderOrganism(
            user: sessionController.currentUser.value!,
            onRemoveAvatarConfirmed: () {},
            uploadAction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(AvatarMolecule), findsOneWidget);

      final avatarMolecule = tester.widget<AvatarMolecule>(
        find.byType(
          AvatarMolecule,
        ),
      );

      expect(avatarMolecule.imageUrl, isNotEmpty);
      expect(avatarMolecule.imageUrl, isNotNull);
      expect(find.byIcon(HeroiconsMini.user), findsNothing);
    });

    testWidgets("sut should runs callback when tapping expected buttons",
        (tester) async {
      // bool removeTapped = false;
      bool uploadTapped = false;

      await tester.pumpWidget(
        testWidgetTemplate(
          sut: ProfileHeaderOrganism(
            user: sessionController.currentUser.value!,
            onRemoveAvatarConfirmed: () {
              // removeTapped = true;
            },
            uploadAction: () {
              uploadTapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(HeroiconsSolid.cloudArrowUp));
      await tester.pumpAndSettle();

      expect(uploadTapped, isTrue);
      // Removido pelo fato de inativar a remoção de imagem no momento
      // await tester.tap(find.byIcon(Icons.close));
      // await tester.pump(const Duration(milliseconds: 200));

      // expect(find.byIcon(HeroiconsMini.camera), findsOneWidget);

      // await tester.tap(
      //   find.byIcon(HeroiconsMini.checkCircle),
      //   warnIfMissed: false,
      // );
      // await tester.pumpAndSettle();

      // expect(removeTapped, isTrue);
    });
  });
}
