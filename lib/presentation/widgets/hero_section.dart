import 'dart:ui' show FontFeature, PathMetric;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/roadmap_board.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

class HeroSection extends StatelessWidget {
  final AnimationController controller;

  const HeroSection({
    super.key,
    required this.controller,
  });

  Animation<double> _interval(double start, double end) => CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(context);
    final wide = width >= 1080;
    final isMobile = width < 700;

    final text = _buildText(context, isMobile);
    final board = _Rise(
      animation: _interval(0.2, 0.7),
      distance: 40,
      child: RoadmapBoard(entrance: controller),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppLayout.maxContentWidth + gutter * 2,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            gutter,
            isMobile ? 124 : 168,
            gutter,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 11, child: text),
                    const SizedBox(width: 48),
                    Expanded(flex: 10, child: board),
                  ],
                )
              else ...[
                text,
                SizedBox(height: isMobile ? 48 : 64),
                board,
              ],
              SizedBox(height: isMobile ? 40 : 72),
              _Rise(
                animation: _interval(0.45, 0.95),
                child: const _ImpactBand(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Rise(
          animation: _interval(0.0, 0.4),
          child: StatusPill(
            label: isMobile
                ? 'Open to Product Manager roles'
                : 'Open to PM roles · Supply chain / AI / SaaS',
            color: AppColors.now,
            pulse: true,
          ),
        ),
        SizedBox(height: isMobile ? 22 : 28),
        _Name(
          first: _interval(0.06, 0.5),
          second: _interval(0.14, 0.58),
          isMobile: isMobile,
        ),
        SizedBox(height: isMobile ? 22 : 30),
        _Rise(
          animation: _interval(0.24, 0.66),
          child: _Tagline(
            underline: _interval(0.55, 0.95),
            isMobile: isMobile,
          ),
        ),
        const SizedBox(height: 14),
        _Rise(
          animation: _interval(0.3, 0.72),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              'With rare depth in supply chain and ERP: procurement software, '
              'supplier platforms, and AI layers over SCM portals.',
              style: AppText.body(
                size: isMobile ? 16 : 18,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 30 : 38),
        _Rise(
          animation: _interval(0.36, 0.78),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AnimatedButton(
                onPressed: () => context.go('/case-studies'),
                text: 'Read case studies',
                isPrimary: true,
                trailingIcon: Icons.arrow_forward_rounded,
              ),
              AnimatedButton(
                onPressed: () => context.go('/projects'),
                text: 'Products I\'ve shipped',
                isPrimary: false,
              ),
              TextButton.icon(
                onPressed: () => _launchUrl(Assets.resumeUrl),
                icon: const Icon(Icons.north_east_rounded, size: 16),
                iconAlignment: IconAlignment.end,
                label: const Text('Resume (PDF)'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

/// Fade + rise driven by a parent interval. Skipped under reduced motion.
class _Rise extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final double distance;

  const _Rise({
    required this.animation,
    required this.child,
    this.distance = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, distance * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }
}

/// Name set big in Unbounded; each line slides up out of its own mask.
class _Name extends StatelessWidget {
  final Animation<double> first;
  final Animation<double> second;
  final bool isMobile;

  const _Name({
    required this.first,
    required this.second,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final parts = PortfolioContent.profile.name.split(' ');
    final style = AppText.display(
      size: isMobile ? 52 : 88,
      weight: FontWeight.w800,
      height: 1.0,
      letterSpacing: isMobile ? -1.5 : -3,
    );
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget line(String text, Animation<double> a, {bool dot = false}) {
      final rich = Text.rich(
        TextSpan(
          text: text,
          children: [
            if (dot)
              const TextSpan(
                text: '.',
                style: TextStyle(color: AppColors.marigold),
              ),
          ],
        ),
        style: style,
        maxLines: 1,
      );
      final fitted = FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: rich,
      );
      if (reduceMotion) return fitted;
      return ClipRect(
        child: AnimatedBuilder(
          animation: a,
          child: fitted,
          builder: (context, child) => FractionalTranslation(
            translation: Offset(0, 1.0 - a.value),
            child: child,
          ),
        ),
      );
    }

    return Semantics(
      header: true,
      label: PortfolioContent.profile.name,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            line(parts.first, first),
            line(parts.skip(1).join(' '), second, dot: true),
          ],
        ),
      ),
    );
  }
}

/// "I turn ambiguous briefs into shipped products." with a marker stroke
/// drawn under "shipped products", like someone circling it on a whiteboard.
class _Tagline extends StatelessWidget {
  final Animation<double> underline;
  final bool isMobile;

  const _Tagline({required this.underline, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final style = AppText.body(
      size: isMobile ? 22 : 28,
      weight: FontWeight.w500,
      height: 1.35,
    );
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'I turn ambiguous briefs into '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: AnimatedBuilder(
                animation: underline,
                builder: (context, child) => CustomPaint(
                  foregroundPainter: _MarkerPainter(
                    progress: reduceMotion ? 1 : underline.value,
                  ),
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    'shipped products',
                    style: style.copyWith(color: AppColors.marigold),
                  ),
                ),
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
        style: style,
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  final double progress;

  _MarkerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final y = size.height - 1;
    final path = Path()
      ..moveTo(2, y)
      ..quadraticBezierTo(size.width * 0.45, y + 4, size.width - 2, y - 3);

    final PathMetric metric = path.computeMetrics().first;
    final partial = metric.extractPath(0, metric.length * progress);

    canvas.drawPath(
      partial,
      Paint()
        ..color = AppColors.marigold.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MarkerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Impact numbers as one scorecard strip rather than four floating cards.
/// The count-up controller lives here, above the rows, so re-measuring the
/// rows after web fonts load doesn't restart it.
class _ImpactBand extends StatefulWidget {
  const _ImpactBand();

  @override
  State<_ImpactBand> createState() => _ImpactBandState();
}

class _ImpactBandState extends State<_ImpactBand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _count = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _count.value = 1;
    } else if (_count.isDismissed) {
      _count.forward();
    }
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = PortfolioContent.impactMetrics;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 700 ? 2 : 4;
    final counting = CurvedAnimation(parent: _count, curve: Curves.easeOutExpo);

    // Counts every number in a value up from 0: "$250k+" → "$141k+" → …
    String interpolate(String value, double t) => value.replaceAllMapped(
          RegExp(r'\d+'),
          (m) => (int.parse(m[0]!) * t).round().toString(),
        );

    Widget cell(ImpactMetric m) {
      final style = AppText.display(
        size: width < 700 ? 24 : 32,
        weight: FontWeight.w700,
        letterSpacing: -1,
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width < 700 ? 18 : 26,
          vertical: width < 700 ? 20 : 26,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: counting,
                builder: (context, _) => Text(
                  interpolate(m.value, counting.value),
                  maxLines: 1,
                  style: style,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              m.label,
              style: AppText.body(
                size: 13.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      );
    }

    final rows = <List<ImpactMetric>>[];
    for (var i = 0; i < metrics.length; i += columns) {
      rows.add(metrics.sublist(i, (i + columns).clamp(0, metrics.length)));
    }

    const divider = BorderSide(color: AppColors.borderSubtle);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          for (var r = 0; r < rows.length; r++)
            Container(
              decoration: BoxDecoration(
                border: r == 0 ? null : const Border(top: divider),
              ),
              child: FontSafeIntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var c = 0; c < rows[r].length; c++)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: c == 0 ? null : const Border(left: divider),
                          ),
                          child: cell(rows[r][c]),
                        ),
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
