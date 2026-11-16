import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/career_roadmap.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final _keys = [for (final _ in PortfolioContent.experiences) GlobalKey()];
  int? _highlight;
  Timer? _clear;
  bool _handledQuery = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledQuery) return;
    _handledQuery = true;
    final role = int.tryParse(
      GoRouterState.of(context).uri.queryParameters['role'] ?? '',
    );
    if (role != null && role >= 0 && role < _keys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(role));
    }
  }

  @override
  void dispose() {
    _clear?.cancel();
    super.dispose();
  }

  void _reveal(int index) {
    final target = _keys[index].currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
    setState(() => _highlight = index);
    _clear?.cancel();
    _clear = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _highlight = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    const roles = PortfolioContent.experiences;
    final first = roles.last.period.split('–').first.trim();
    return PageBody(
      children: [
        PageHeader(
          title: 'Experience',
          description: '${roles.length} roles since $first. From building '
              'Flutter apps to owning discovery and delivery across 15+ '
              'client engagements.',
        ),
        CareerRoadmap(onSelect: _reveal),
        const SizedBox(height: 40),
        for (var i = 0; i < roles.length; i++)
          Padding(
            key: _keys[i],
            padding: const EdgeInsets.only(bottom: 16),
            child: _RoleCard(
              role: roles[i],
              current: i == 0 && roles[i].period.contains('Present'),
              highlighted: _highlight == i,
            ),
          ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final ExperienceEntry role;
  final bool current;
  final bool highlighted;

  const _RoleCard({
    required this.role,
    required this.current,
    required this.highlighted,
  });

  static final _figurePattern = RegExp(
    r'([\$₹][\d,]+[kKLM]?\+?|\d+[\d,]*(?:–\d+[\d,]*)?\s?(?:lakhs?/year|lakhs?|L/year|L\b|%|\+)|\b\d+\+|\b0 to 1\b)',
  );

  /// Dim prose, bright numbers: the figures are what a skim should catch.
  List<TextSpan> _withFigures(String text, Palette p) {
    final spans = <TextSpan>[];
    var last = 0;
    for (final m in _figurePattern.allMatches(text)) {
      if (m.start > last) spans.add(TextSpan(text: text.substring(last, m.start)));
      spans.add(
        TextSpan(
          text: m[0],
          style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
        ),
      );
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    final color = isProductRole(role) ? p.accent : p.info;
    final dots = [p.accent, p.docs, p.info, p.shipped];

    final period = Text(
      role.period,
      style: AppText.mono(size: 12, color: p.textFaint),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(mobile ? 16 : 22),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlighted ? p.accent : p.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.tint(color),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  role.company.characters.first,
                  style: AppText.display(
                    size: 17,
                    color: color,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          role.position,
                          style: AppText.ui(
                            size: 16,
                            weight: FontWeight.w600,
                            color: p.text,
                            height: 1.35,
                          ),
                        ),
                        if (current)
                          StatusBadge(
                            'Now',
                            color: p.progress,
                            leading: const StatusIcon(
                              StatusKind.progress,
                              size: 11,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${role.company} · ${role.location}',
                      style: AppText.ui(size: 13.5, color: p.textMuted),
                    ),
                    if (mobile) ...[const SizedBox(height: 4), period],
                  ],
                ),
              ),
              if (!mobile) ...[const SizedBox(width: 16), period],
            ],
          ),
          if (role.domains.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < role.domains.length; i++)
                  LabelChip(role.domains[i], dot: dots[i % dots.length]),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Text(
            role.description,
            style: AppText.ui(size: 15, color: p.text, height: 1.65),
          ),
          const SizedBox(height: 12),
          for (final r in role.responsibilities)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 9, right: 12),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: p.textFaint,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: _withFigures(r, p)),
                      style: AppText.ui(
                        size: 14.5,
                        color: p.textMuted,
                        height: 1.6,
                      ),
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
