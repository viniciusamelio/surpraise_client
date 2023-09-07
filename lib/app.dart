import 'package:blurple/themes/theme_data.dart';
import 'package:flutter/material.dart';

import 'contexts/auth/auth.dart';
import 'contexts/auth/presentation/screens/signup.dart';
import 'contexts/community/community.dart';
import 'contexts/feed/presentation/presentation.dart';
import 'contexts/intro/intro.dart';
import 'contexts/main/main_screen.dart';
import 'contexts/profile/presentation/presentation.dart';
import 'core/core.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlurpleThemeData.defaultTheme(
      child: Builder(builder: (context) {
        final theme = context.theme;
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            title: '#surpraise',
            theme: ThemeData(
              useMaterial3: false,
              scaffoldBackgroundColor: theme.colorScheme.backgroundColor,
              colorScheme: ColorScheme.dark(
                background: theme.colorScheme.backgroundColor,
                primary: theme.colorScheme.accentColor,
              ),
            ),
            navigatorKey: navigatorKey,
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              SignupScreen.routeName: (context) => const SignupScreen(),
              FeedScreen.routeName: (context) => const FeedScreen(),
              IntroScreen.routeName: (context) => const IntroScreen(),
              ProfileScreen.routeName: (context) => const ProfileScreen(),
              MainScreen.routeName: (context) => const MainScreen(),
              CommunityDetailsScreen.routeName: (context) =>
                  const CommunityDetailsScreen(),
            },
          ),
        );
      }),
    );
  }
}
