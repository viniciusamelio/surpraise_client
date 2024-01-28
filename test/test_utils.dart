import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:surpraise_client/core/external_dependencies.dart';

Widget testWidgetTemplate({
  required Widget sut,
  void Function(BuildContext context)? contextCallback,
}) {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting("pt_BR");
  return BlurpleThemeData.defaultTheme(
    child: MaterialApp(
      locale: const Locale("pt", "BR"),
      home: Builder(builder: (context) {
        if (contextCallback != null) {
          contextCallback(context);
        }
        return Sizer(builder: (context, orientation, deviceType) {
          return Scaffold(body: sut);
        });
      }),
    ),
  );
}
