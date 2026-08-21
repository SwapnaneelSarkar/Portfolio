import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioContent.profile;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(controller: _bgController),
          Center(
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoController.value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * _logoController.value),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.accentPrimary.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundLight,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Image.asset(
                          Assets.avatar,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.05),
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.person,
                                color: AppColors.textPrimary,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    profile.name,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Sweeping gradient loading bar.
                  AnimatedBuilder(
                    animation: _bgController,
                    builder: (context, _) {
                      final v = (_bgController.value * 10) % 1.0;
                      return Container(
                        width: 160,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Align(
                          alignment: Alignment(-1 + 2 * v, 0),
                          child: Container(
                            width: 48,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppColors.primaryGradient,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
