import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';

extension BlurpleTheme on BuildContext {
  BlurpleThemeData get theme => BlurpleThemeData.of(this);
}
