import 'package:blurple/themes/theme_data.dart';
import 'package:blurple/tokens/color_tokens.dart';
import 'package:blurple/widgets/buttons/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';

import 'contexts/auth/auth.dart';
import 'contexts/auth/presentation/screens/signup.dart';
import 'contexts/community/community.dart';
import 'contexts/feed/presentation/presentation.dart';
import 'contexts/intro/intro.dart';
import 'contexts/main/main_screen.dart';
import 'contexts/profile/presentation/presentation.dart';
import 'core/core.dart';
import 'core/external_dependencies.dart';
import 'shared/dtos/dtos.dart';
import 'shared/presentation/molecules/error_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting("pt_BR");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return BlurpleThemeData.defaultTheme(
      child: Builder(builder: (context) {
        final theme = context.theme;
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            title: '#surpraise',
            debugShowCheckedModeBanner: false,
            locale: const Locale('pt', 'BR'),
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
              SignupScreen.routeName: (context) => SignupScreen(
                    formData: ModalRoute.of(context)!.settings.arguments
                        as SignupFormDataDto?,
                  ),
              PasswordRecoveryScreen.routeName: (context) =>
                  const PasswordRecoveryScreen(),
              FeedScreen.routeName: (context) => FeedScreen(
                    user: ModalRoute.of(context)!.settings.arguments as UserDto,
                  ),
              IntroScreen.routeName: (context) => const IntroScreen(),
              ProfileScreen.routeName: (context) => const ProfileScreen(),
              MainScreen.routeName: (context) => const MainScreen(),
              CommunityDetailsScreen.routeName: (context) =>
                  CommunityDetailsScreen(
                    community: ModalRoute.of(context)?.settings.arguments
                        as CommunityOutput,
                  ),
            },
            builder: (context, child) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ErrorWidgetMolecule(
                          message: kDebugMode
                              ? errorDetails.exceptionAsString()
                              : "Algo estranho aconteceu com o app",
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      BorderedButton(
                        text: "Reiniciar o app",
                        borderSide: BorderSide(
                          width: 2,
                          color: ColorTokens.red,
                        ),
                        foregroundColor: ColorTokens.red,
                        onPressed: () {
                          Restart.restartApp(
                            webOrigin: LoginScreen.routeName,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                );
              };

              return Sizer(builder: (context, orientation, deviceType) {
                return child!;
              });
            },
          ),
        );
      }),
    );
  }
}
