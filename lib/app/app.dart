import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/app/theme/mytheme.dart';
import 'package:thrill_quest/features/auth/presentation/view/login_view.dart';
import 'package:thrill_quest/features/auth/presentation/view/signup_view.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view/home_screen.dart';
import 'package:thrill_quest/features/splash/presentation/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login':
            (context) => BlocProvider.value(
              value: serviceLocator<LoginViewModel>(),
              child: LoginScreen(),
            ),
        '/signup':
            (context) => BlocProvider.value(
              value: serviceLocator<SignupViewModel>(),
              child: SignupView(),
            ),
        '/homeScreen': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
    );
  }
}
