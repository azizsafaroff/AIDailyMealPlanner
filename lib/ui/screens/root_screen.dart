import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import 'home_screen.dart';
import 'intro_screen.dart';
import 'onboarding_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = context.watch<AppService>().phase;

    return switch (phase) {
      AppPhase.loading => const Scaffold(body: Center(child: CircularProgressIndicator())),
      AppPhase.disclaimer => const IntroScreen(),
      AppPhase.onboarding => const OnboardingScreen(),
      AppPhase.home => const HomeScreen(),
    };
  }
}
