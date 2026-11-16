import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

/// The hero's signature: a small roadmap board built from real portfolio
/// content. Case studies sit in Research, the current role in In progress,
/// and projects in Shipped. Every card links somewhere.
class RoadmapBoard extends StatefulWidget {
  /// Drives the entrance (cards drop into their lanes in sequence).
  final Animation<double> entrance;

  const RoadmapBoard({super.key, required this.entrance});

  @override
  State<RoadmapBoard> createState() => _RoadmapBoardState();
}

class _BoardItem {
  final String meta;
  final String title;
  final Color color;
  final String? url;
  final String? route;
  final bool inProgress;
  final bool ghost;

  const _BoardItem({
    required this.meta,
    required this.title,
    required this.color,
    this.url,
    this.route,
    this.inProgress = false,
    this.ghost = false,
  });
}

class _Lane {
  final String label;
  final Color color;
  final List<_BoardItem> items;

  const _Lane(this.label, this.color, this.items);
}

String _shortTitle(String title) => title.split(' — ').first;

String _shortPeriod(String period) {
  // "November 2025 – Present" -> "Nov 2025 → now"
  final parts = period.split('–').map((p) => p.trim()).toList();
  String abbreviate(String p) {
    final words = p.split(' ');
    if (words.length == 2 && words.first.length > 3) {
      return '${words.first.substring(0, 3)} ${words.last}';
    }
    return p;
  }

  if (parts.length == 2) {
    final end = parts.last.toLowerCase() == 'present' ? 'now' : parts.last;
    return '${abbreviate(parts.first)} → ${abbreviate(end)}';
  }
  return period;
}

class _RoadmapBoardState extends State<RoadmapBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  late final List<_Lane> _lanes = _buildLanes();

  List<_Lane> _buildLanes() {
    final current = PortfolioContent.experiences.first;
    return [
      _Lane(
        'Research',
        AppColors.research,
        PortfolioContent.caseStudies
            .map(
              (c) => _BoardItem(
                meta: 'Case study · ${c.tags.first}',
                title: c.title,
                color: AppColors.research,
                url: c.externalUrl,
              ),
            )
            .toList(),
      ),
      _Lane('In progress', AppColors.now, [
        _BoardItem(
          meta: _shortPeriod(current.period),
          title: '${current.company} · 10+ products',
          color: AppColors.now,
          route: '/experience',
          inProgress: true,
        ),
        const _BoardItem(
          meta: 'Next up',
          title: 'Your product?',
          color: AppColors.now,
          route: '/contact',
          ghost: true,
        ),
      ]),
      _Lane(
        'Shipped',
        AppColors.shipped,
        PortfolioContent.projects
            .map(
              (p) => _BoardItem(
                meta: '${p.period} · ${p.technologies.first}',
                title: _shortTitle(p.title),
                color: AppColors.shipped,
                url: p.projectUrl,
              ),
            )
            .toList(),
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _progress.stop();
      _progress.value = 0.6;
    } else if (!_progress.isAnimating) {
      _progress.repeat();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _open(_BoardItem item) {
    if (item.route != null) {
      context.go(item.route!);
    } else if (item.url != null) {
      launchUrl(Uri.parse(item.url!), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    var order = 0;

    Widget card(_BoardItem item) {
      final index = order++;
      final start = (0.3 + index * 0.055).clamp(0.0, 0.8);
      final anim = CurvedAnimation(
        parent: widget.entrance,
        curve: Interval(start, (start + 0.3).clamp(0.0, 1.0),
            curve: Curves.easeOutBack),
      );
      final child = _BoardCard(
        item: item,
        progress: _progress,
        onTap: () => _open(item),
      );
      if (reduceMotion) return child;
      return AnimatedBuilder(
        animation: anim,
        child: child,
        builder: (context, child) {
          final v = anim.value;
          return Opacity(
            opacity: v.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, -14 * (1 - v)),
              child: child,
            ),
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
          BoxShadow(
            color: const Color(0xFF5B3FD9).withValues(alpha: 0.18),
            blurRadius: 80,
            spreadRadius: -10,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 520;
          order = 0;

          final header = Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 14),
            child: Row(
              children: [
                ...[AppColors.coral, AppColors.marigold, AppColors.mint].map(
                  (c) => Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Roadmap',
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '2024 → now',
                  style: AppText.mono(size: 11, color: AppColors.textFaint),
                ),
              ],
            ),
          );

          Widget lane(_Lane lane, {required bool wrapCards}) {
            final cards = lane.items.map(card).toList();
            return Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.022),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: lane.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            lane.label.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: AppText.mono(
                              size: 10.5,
                              weight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${lane.items.where((i) => !i.ghost).length}',
                          style: AppText.mono(
                            size: 10.5,
                            color: AppColors.textFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (wrapCards)
                    LayoutBuilder(
                      builder: (context, c) {
                        final w = (c.maxWidth - 8) / 2;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cards
                              .map((x) => SizedBox(width: w, child: x))
                              .toList(),
                        );
                      },
                    )
                  else
                    ...cards.map(
                      (x) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: x,
                      ),
                    ),
                ],
              ),
            );
          }

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                for (final l in _lanes) ...[
                  lane(l, wrapCards: true),
                  if (l != _lanes.last) const SizedBox(height: 10),
                ],
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              FontSafeIntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final l in _lanes) ...[
                      Expanded(child: lane(l, wrapCards: false)),
                      if (l != _lanes.last) const SizedBox(width: 10),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BoardCard extends StatefulWidget {
  final _BoardItem item;
  final Animation<double> progress;
  final VoidCallback onTap;

  const _BoardCard({
    required this.item,
    required this.progress,
    required this.onTap,
  });

  @override
  State<_BoardCard> createState() => _BoardCardState();
}

class _BoardCardState extends State<_BoardCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final active = _hovered || _focused;
    final radius = BorderRadius.circular(14);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.meta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.mono(
            size: 10,
            color: item.ghost ? item.color : AppColors.textFaint,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(
                  size: 13.5,
                  weight: FontWeight.w600,
                  height: 1.25,
                  color: item.ghost
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: active ? 1 : 0,
              child: Icon(
                item.route != null
                    ? Icons.arrow_forward_rounded
                    : Icons.north_east_rounded,
                size: 14,
                color: item.color,
              ),
            ),
          ],
        ),
        if (item.inProgress) ...[
          const SizedBox(height: 10),
          _ProgressBar(animation: widget.progress, color: item.color),
        ],
      ],
    );

    return Semantics(
      link: true,
      label: '${item.title}, ${item.meta}',
      child: InkWell(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _hovered = v),
        onFocusChange: (v) => setState(() => _focused = v),
        borderRadius: radius,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(11, 10, 10, 11),
          decoration: BoxDecoration(
            color: item.ghost
                ? Colors.transparent
                : (active ? AppColors.cardHover : AppColors.cardBackground),
            borderRadius: radius,
            border: Border.all(
              color: active
                  ? item.color.withValues(alpha: _focused ? 0.95 : 0.6)
                  : (item.ghost
                      ? item.color.withValues(alpha: 0.35)
                      : AppColors.borderSubtle),
              width: _focused ? 1.5 : 1,
            ),
            boxShadow: item.ghost
                ? const []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: item.ghost ? _Dashed(color: item.color, child: content) : content,
        ),
      ),
    );
  }
}

/// Dashed outline hint for the "Your product?" placeholder card.
class _Dashed extends StatelessWidget {
  final Color color;
  final Widget child;

  const _Dashed({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1, right: 8),
          child: Icon(Icons.add_rounded, size: 16, color: color),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Animation<double> animation;
  final Color color;

  const _ProgressBar({required this.animation, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: color.withValues(alpha: 0.15)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.68,
              child: ColoredBox(color: color),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, _) => Align(
                alignment: Alignment(-1.6 + animation.value * 3.2, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.25,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
