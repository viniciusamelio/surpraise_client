import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_client/contexts/settings/settings.dart';
import 'package:surpraise_client/core/di/di.dart';
import 'package:surpraise_client/core/external_dependencies.dart';
import 'package:surpraise_client/core/protocols/protocols.dart';

import '../../../../mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group("Settings Screen: ", () {
    late final LinkHandler linkHandler;
    setUpAll(() {
      HttpOverrides.global = null;
      linkHandler = MockLinkHandler();
      inject<SettingsController>(
        DefaultSettingsController(
          linkHandler: linkHandler,
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
      },
    );
  });
}
