import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/app/theme/mytheme.dart';
import 'package:thrill_quest/features/auth/presentation/view/login_view.dart';
import 'package:thrill_quest/features/auth/presentation/view/signup_view.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:thrill_quest/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:thrill_quest/features/splash/presentation/view/splash_screen.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':
            (context) => BlocProvider(
              create: (context) => serviceLocator<SplashViewModel>(),
              child: const SplashScreen(),
            ),
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
        '/dashboard':
            (context) => BlocProvider(
              create: (context) => serviceLocator<DashboardViewModel>(),
              child: DashboardView(),
            ),
      },
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
    );
  }
}
