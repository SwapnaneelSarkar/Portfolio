import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _splashDuration = Duration(milliseconds: 2800);

  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _loadController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _loadController = AnimationController(
      vsync: this,
      duration: _splashDuration - const Duration(milliseconds: 300),
    )..forward();

    Future.delayed(_splashDuration, () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioContent.profile;
    final logo = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(controller: _bgController),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: logo,
                  builder: (context, child) => Opacity(
                    opacity: _logoController.value,
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * logo.value,
                      child: child,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lilac.withValues(alpha: 0.35),
                          blurRadius: 60,
                        ),
                      ],
                    ),
                    child: const AvatarBadge(size: 112),
                  ),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _logoController,
                    curve: const Interval(0.3, 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        profile.name,
                        style: AppText.display(
                          size: 26,
                          weight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.title.toUpperCase(),
                        style: AppText.mono(
                          size: 12,
                          color: AppColors.textSecondary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedBuilder(
                            animation: _loadController,
                            builder: (context, _) => LinearProgressIndicator(
                              value: Curves.easeInOutCubic.transform(
                                _loadController.value,
                              ),
                              minHeight: 3,
                              color: AppColors.marigold,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
