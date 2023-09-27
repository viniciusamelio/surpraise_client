import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';

Widget testWidgetTemplate({
  required Widget sut,
  void Function(BuildContext context)? contextCallback,
}) {
  return BlurpleThemeData.defaultTheme(
    child: MaterialApp(
      home: Builder(builder: (context) {
        if (contextCallback != null) {
          contextCallback(context);
        }
        return Scaffold(body: sut);
      }),
    ),
  );
}
