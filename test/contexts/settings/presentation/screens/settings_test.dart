import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/settings/settings.dart';
import 'package:surpraise_client/core/di/di.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/core/protocols/protocols.dart';
import 'package:surpraise_client/shared/presentation/controllers/controllers.dart';
import 'package:surpraise_client/shared/presentation/molecules/loader.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group("Settings Screen: ", () {
    late final LinkHandler linkHandler;
    late final SettingsRepository settingsRepository;
    setUpAll(() {
      HttpOverrides.global = null;
      linkHandler = MockLinkHandler();
      settingsRepository = MockSettingsRepository();
      inject<SessionController>(MockSessionController());

      inject<SettingsController>(
        DefaultSettingsController(
          linkHandler: linkHandler,
          settingsRepository: settingsRepository,
          sessionController: injected(),
        ),
      );

      when(() => settingsRepository.get(userId: any(named: "userId")))
          .thenAnswer(
        (_) async => Right(
          const GetSettingsOutput(
            pushNotificationsEnabled: false,
          ),
        ),
      );
    });

    tearDown(() {
      resetMocktailState();
    });

    testWidgets(
      "sut should sucessfully openlink when clicking on linkedin and coffee buttons",
      (tester) async {
        when(
          () => linkHandler.openLink(
            link: any(named: "link"),
          ),
        ).thenAnswer((_) async => Right(""));

        await tester.pumpWidget(
          testWidgetTemplate(
            sut: const SettingsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.coffee), findsOneWidget);

        await tester.tap(find.byIcon(Icons.coffee));
        await tester.pumpAndSettle();

        verify(
          () => linkHandler.openLink(
            link: "https://github.com/viniciusamelio/surpraise_client",
          ),
        ).called(1);

        expect(find.byIcon(FontAwesomeIcons.linkedin), findsOneWidget);

        await tester.tap(find.byIcon(FontAwesomeIcons.linkedin));
        await tester.pumpAndSettle();

        verify(
          () => linkHandler.openLink(
            link: "https://linkedin.com/in/vinicius-amelio-jesus/",
          ),
        ).called(1);

        await tester.pumpWidget(
          testWidgetTemplate(
            sut: const SettingsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Switch), findsOneWidget);
        Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isFalse);
      },
    );

    testWidgets(
      "sut should have notifications enabled switch changed according to get response",
      (tester) async {
        when(() => settingsRepository.get(userId: any(named: "userId")))
            .thenAnswer(
          (_) async => Right(
            const GetSettingsOutput(
              pushNotificationsEnabled: true,
            ),
          ),
        );

        await tester.pumpWidget(
          testWidgetTemplate(
            sut: const SettingsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Switch), findsOneWidget);
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);
      },
    );

    testWidgets(
      "sut should show loading state when get request isnt finished yet",
      (tester) async {
        when(() => settingsRepository.get(userId: any(named: "userId")))
            .thenAnswer(
          (_) async {
            return Right(
              const GetSettingsOutput(
                pushNotificationsEnabled: true,
              ),
            );
          },
        );

        await tester.pumpWidget(
          testWidgetTemplate(
            sut: const SettingsScreen(),
          ),
        );

        expect(find.byType(LoaderMolecule), findsOneWidget);
      },
    );
  });
}
