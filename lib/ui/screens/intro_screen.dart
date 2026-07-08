import 'package:flutter/material.dart';

import 'disclaimer_screen.dart';
import 'splash_screen.dart';

/// First-launch-only intro: the design's splash screen, then the medical
/// disclaimer, before onboarding. Kept as local state (not routed) so
/// accepting the disclaimer — which flips [AppService.phase] to onboarding
/// — cleanly swaps this whole subtree out via [RootScreen] instead of
/// leaving a pushed route stranded on top of it.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _showDisclaimer = false;

  @override
  Widget build(BuildContext context) {
    if (_showDisclaimer) return const DisclaimerScreen();
    return SplashScreen(onGetStarted: () => setState(() => _showDisclaimer = true));
  }
}
