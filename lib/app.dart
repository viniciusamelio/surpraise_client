import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:surpraise_client/contexts/auth/presentation/screens/signup.dart';

import 'contexts/auth/auth.dart';
import 'core/extensions/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlurpleThemeData.defaultTheme(
      child: Builder(builder: (context) {
        final theme = context.theme;
        return MaterialApp(
          title: '#surpraise',
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: theme.colorScheme.backgroundColor,
            colorScheme: ColorScheme.dark(
              background: theme.colorScheme.backgroundColor,
              primary: theme.colorScheme.accentColor,
            ),
          ),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignupScreen.routeName: (context) => const SignupScreen(),
          },
          initialRoute: LoginScreen.routeName,
        );
      }),
    );
  }
}
