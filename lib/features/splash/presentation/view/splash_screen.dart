import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_event.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_state.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SplashViewModel>().add(AppStart()),
    );
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state is AuthenticatedUser) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is UnAuthenticatedUser) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Lottie.asset("assets/animation/trillsplash.json"),
          ),
        ),
      ),
    );
  }
}
