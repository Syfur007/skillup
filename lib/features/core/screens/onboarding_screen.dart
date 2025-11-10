import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillup/core/navigation/navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Track Your Progress',
      description: 'Monitor your learning journey with detailed statistics',
      illustration: const FlutterLogo(size: 200),
    ),
    OnboardingPage(
      title: 'Learn Together',
      description: 'Join study groups and share knowledge with peers',
      illustration: const Icon(
        Icons.group,
        size: 200,
        color: Colors.blueAccent,
      ),
    ),
    OnboardingPage(
      title: 'Achieve Goals',
      description: 'Set and accomplish your learning objectives',
      illustration: const Icon(
        Icons.emoji_events,
        size: 200,
        color: Colors.amber,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Use the same key the router's onboarding provider checks
    await prefs.setBool('onboardingCompleted', true);

    // Invalidate/refetch the onboarding provider so GoRouter's redirect sees the new value
    // `ref` is provided by ConsumerState
    ref.invalidate(onboardingCompletedProvider);

    // Wait for the provider to resolve so the router's redirect will observe the updated value.
    // This avoids racing with GoRouter's redirect that would otherwise send us back to onboarding.
    try {
      final isCompleted = await ref.read(onboardingCompletedProvider.future);
      if (isCompleted && mounted) {
        context.goToNamed(RouteNames.login);
      }
    } catch (_) {
      // If anything goes wrong, still try navigating to login as a fallback.
      if (mounted) context.goToNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == pages.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: pages[index]);
            },
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: pages.length,
                  effect: const WormEffect(),
                ),
                TextButton(
                  onPressed: () {
                    if (isLastPage) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(isLastPage ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final Widget illustration; // changed from image path to widget

  OnboardingPage({
    required this.title,
    required this.description,
    required this.illustration,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // render the provided illustration widget (no external image needed)
          page.illustration,
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
