import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/metric_card.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatefulWidget {
  final AnimationController controller;

  /// Home page scroll controller — used to fade the scroll cue and to
  /// scroll past the hero when the cue is clicked.
  final ScrollController? scrollController;

  const HeroSection({
    super.key,
    required this.controller,
    this.scrollController,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  /// Entrance slice of the shared 1200ms hero controller.
  Widget _reveal({
    required double start,
    required double end,
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, c) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - curved.value)),
            child: c,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final profile = PortfolioContent.profile;
    final isMobile = size.width < 900;
    final showOrbit = size.width > 1020;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: size.height * 0.92,
        minWidth: size.width,
      ),
      child: Stack(
        children: [
          Center(
            child: ContentContainer(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 24 : 48,
                120,
                isMobile ? 24 : 48,
                96,
              ),
              child: isMobile
                  ? _buildTextColumn(context, textTheme, profile)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextColumn(context, textTheme, profile),
                        ),
                        if (showOrbit)
                          Expanded(
                            flex: 2,
                            child: _reveal(
                              start: 0.30,
                              end: 1.0,
                              child: RepaintBoundary(
                                child: _OrbitVisual(
                                  controller: _orbitController,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: _ScrollCue(
                controller: _orbitController,
                scrollController: widget.scrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextColumn(
    BuildContext context,
    TextTheme textTheme,
    ProfileInfo profile,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _reveal(
          start: 0.0,
          end: 0.40,
          child: _AvailabilityBadge(
            controller: _orbitController,
            label: isMobile
                ? 'OPEN TO PRODUCT MANAGER ROLES'
                : 'OPEN TO PM ROLES · SUPPLY CHAIN / AI / SAAS',
          ),
        ),
        const SizedBox(height: 24),
        _reveal(
          start: 0.08,
          end: 0.52,
          child: Text(
            profile.name,
            style: textTheme.displayMedium?.copyWith(
              fontSize: isMobile ? 40 : 56,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _reveal(
          start: 0.16,
          end: 0.60,
          child: SizedBox(
            height: 44,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.primaryGradient,
              ).createShader(bounds),
              child: DefaultTextStyle(
                style: textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 26,
                ),
                child: AnimatedTextKit(
                  animatedTexts: profile.animatedRoles
                      .map(
                        (r) => FadeAnimatedText(
                          r,
                          duration: const Duration(milliseconds: 2200),
                        ),
                      )
                      .toList(),
                  repeatForever: true,
                  pause: const Duration(milliseconds: 800),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _reveal(
          start: 0.24,
          end: 0.68,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              'I turn ambiguous briefs into shipped products — with rare depth in supply chain and ERP. At Heizen I\'ve shipped procurement software, supplier platforms, and AI layers over SCM portals: \$250k+ delivered across 15+ engagements, multiple 0→1 AI launches.',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16.5,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),
        _reveal(start: 0.34, end: 0.82, child: _buildMetrics(isMobile)),
        const SizedBox(height: 36),
        _reveal(
          start: 0.46,
          end: 0.95,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AnimatedButton(
                onPressed: () => context.go('/case-studies'),
                text: 'View Case Studies',
                isPrimary: true,
                trailingIcon: Icons.arrow_forward_rounded,
              ),
              AnimatedButton(
                onPressed: () => context.go('/projects'),
                text: 'Products I\'ve Shipped',
                isPrimary: false,
              ),
              TextButton.icon(
                onPressed: () => _launchUrl(Assets.resumeUrl),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Resume'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(bool isMobile) {
    final metrics = PortfolioContent.impactMetrics;
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < metrics.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MetricCard(
                value: metrics[i].value,
                label: metrics[i].label,
                highlight: i == 0,
              ),
            ),
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < metrics.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i == metrics.length - 1 ? 0 : 12,
                ),
                child: MetricCard(
                  value: metrics[i].value,
                  label: metrics[i].label,
                  highlight: i == 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

/// Pulsing "open to roles" pill — the first thing a recruiter reads.
class _AvailabilityBadge extends StatelessWidget {
  final AnimationController controller;
  final String label;

  const _AvailabilityBadge({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final pulse =
                  0.55 + 0.45 * sin(controller.value * 2 * pi * 4).abs();
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPrimary,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppColors.accentPrimary.withValues(alpha: pulse * .7),
                      blurRadius: 8,
                      spreadRadius: pulse * 2.5,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: AppFonts.mono(
                fontSize: 10.5,
                color: AppColors.accentPrimary,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orbital "mission control" visual: avatar core with domain depth in orbit.
class _OrbitVisual extends StatelessWidget {
  final AnimationController controller;

  const _OrbitVisual({required this.controller});

  static const _chips = [
    _OrbitChip(label: 'SUPPLY CHAIN', radius: 138, baseAngle: -0.4, speed: 1),
    _OrbitChip(
        label: '0→1 DELIVERY', radius: 138, baseAngle: pi - 0.4, speed: 1),
    _OrbitChip(label: 'ERP · SCM', radius: 196, baseAngle: pi / 2, speed: -0.55),
    _OrbitChip(
        label: 'AI · LLM', radius: 196, baseAngle: 3 * pi / 2, speed: -0.55),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale =
            (constraints.maxWidth / 500).clamp(0.6, 1.0).toDouble();
        return SizedBox(
          height: 460 * scale,
          child: Transform.scale(
            scale: scale,
            child: _buildOrbit(),
          ),
        );
      },
    );
  }

  Widget _buildOrbit() {
    return SizedBox(
      height: 460,
      child: AnimatedBuilder(
        animation: controller,
        // The avatar core never changes — build it once via `child`.
        child: _AvatarCore(),
        builder: (context, core) {
          final t = controller.value;
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: const Size(440, 440),
                painter: _OrbitRingsPainter(t: t),
              ),
              core!,
              for (final chip in _chips)
                Transform.translate(
                  offset: Offset(
                    cos(chip.baseAngle + t * 2 * pi * chip.speed) * chip.radius,
                    sin(chip.baseAngle + t * 2 * pi * chip.speed) *
                        chip.radius *
                        0.92,
                  ),
                  child: _buildChip(chip.label),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: AppFonts.mono(
              fontSize: 9.5,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withValues(alpha: 0.25),
            blurRadius: 48,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Container(
        width: 128,
        height: 128,
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
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.person,
                color: AppColors.textPrimary,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitChip {
  final String label;
  final double radius;
  final double baseAngle;
  final double speed;

  const _OrbitChip({
    required this.label,
    required this.radius,
    required this.baseAngle,
    required this.speed,
  });
}

class _OrbitRingsPainter extends CustomPainter {
  final double t;

  _OrbitRingsPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.07);

    for (final r in [92.0, 138.0, 196.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 2 * 0.92),
        ringPaint,
      );
    }

    // Rotating gradient sweep on the outer ring.
    final sweepRect = Rect.fromCenter(
      center: center,
      width: 196.0 * 2,
      height: 196.0 * 2 * 0.92,
    );
    canvas.drawOval(
      sweepRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = SweepGradient(
          transform: GradientRotation(t * 2 * pi),
          colors: [
            AppColors.accentPrimary.withValues(alpha: 0),
            AppColors.accentPrimary.withValues(alpha: 0.6),
            AppColors.accentSecondary.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.12, 0.28],
        ).createShader(sweepRect),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitRingsPainter oldDelegate) =>
      oldDelegate.t != t;
}

/// Minimal mouse-outline scroll cue — fades once the user scrolls, and
/// clicking it scrolls past the hero.
class _ScrollCue extends StatelessWidget {
  final AnimationController controller;
  final ScrollController? scrollController;

  const _ScrollCue({required this.controller, this.scrollController});

  @override
  Widget build(BuildContext context) {
    Widget cue = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final v = (controller.value * 12) % 1.0;
            return Container(
              width: 22,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Align(
                alignment: Alignment(0, -0.7 + v * 1.2),
                child: Opacity(
                  opacity: 1 - v,
                  child: Container(
                    width: 4,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.accentPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'SCROLL',
          style: AppFonts.mono(
            fontSize: 9,
            color: AppColors.textSecondary,
            letterSpacing: 3,
          ),
        ),
      ],
    );

    final scroll = scrollController;
    if (scroll == null) return cue;

    cue = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => scroll.animateTo(
          MediaQuery.sizeOf(context).height * 0.92,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        ),
        child: cue,
      ),
    );

    return AnimatedBuilder(
      animation: scroll,
      builder: (context, child) {
        final hidden = scroll.hasClients && scroll.offset > 80;
        return IgnorePointer(
          ignoring: hidden,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            opacity: hidden ? 0 : 1,
            child: child,
          ),
        );
      },
      child: cue,
    );
  }
}
