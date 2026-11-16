import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

int _monthIndex(DateTime d) => d.year * 12 + d.month - 1;

DateTime _parseMonth(String text) {
  final parts = text.trim().split(RegExp(r'\s+'));
  final month = _monthNames.indexWhere(
    (m) => parts.first.toLowerCase().startsWith(m.toLowerCase()),
  );
  return DateTime(int.parse(parts.last), month + 1);
}

/// A role's span on the timeline, parsed from "Apr 2025 – Oct 2025" or
/// "Nov 2025 – Present".
class RoleSpan {
  final DateTime start;

  /// Exclusive end: the first day after the last month, or today.
  final DateTime end;
  final bool ongoing;

  /// e.g. the intern → full-time conversion, read from the location line.
  final DateTime? milestone;

  const RoleSpan(this.start, this.end, this.ongoing, this.milestone);

  factory RoleSpan.of(ExperienceEntry e, DateTime now) {
    final parts = e.period.split('–').map((s) => s.trim()).toList();
    final start = _parseMonth(parts.first);
    final ongoing = parts.last.toLowerCase() == 'present';
    final last = ongoing ? now : _parseMonth(parts.last);
    final end = ongoing ? now : DateTime(last.year, last.month + 1);
    final m = RegExp(r'Full-time \(([A-Za-z]{3}) (\d{4})\)')
        .firstMatch(e.location);
    final milestone = m == null ? null : _parseMonth('${m[1]} ${m[2]}');
    return RoleSpan(start, end, ongoing, milestone);
  }

  /// "Nov '25 – now", "Apr – Oct '25", "Sep '24 – Mar '25".
  String get shortLabel {
    String fmt(DateTime d, {bool year = true}) =>
        '${_monthNames[d.month - 1]}${year ? " '${d.year % 100}" : ''}';
    if (ongoing) return '${fmt(start)} – now';
    final last = DateTime(end.year, end.month - 1);
    if (last.year == start.year) {
      return '${fmt(start, year: false)} – ${fmt(last)}';
    }
    return '${fmt(start)} – ${fmt(last)}';
  }
}

bool isProductRole(ExperienceEntry e) =>
    e.position.contains('Product') || e.position.contains('Project Manager');

/// Career as a roadmap: one bar per role on a shared month axis, with a
/// today marker. Product roles and engineering roles get different colours,
/// so the move from building to product management reads at a glance.
class CareerRoadmap extends StatelessWidget {
  final ValueChanged<int>? onSelect;

  const CareerRoadmap({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final now = DateTime.now();
    const roles = PortfolioContent.experiences;
    final spans = [for (final r in roles) RoleSpan.of(r, now)];

    final first = spans.map((s) => _monthIndex(s.start)).reduce(math.min);
    final last = spans.map((s) => _monthIndex(s.end)).reduce(math.max);
    final rangeStart = first - 1;
    final rangeEnd = math.max(last, _monthIndex(now)) + 2;

    return Panel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _Legend(color: p.accent, label: 'Product roles'),
                _Legend(color: p.info, label: 'Engineering roles'),
                Text(
                  '${_monthNames[spans.last.start.month - 1]} '
                  '${spans.last.start.year} → today',
                  style: AppText.mono(size: 11.5, color: p.textFaint),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: p.border),
          LayoutBuilder(
            builder: (context, constraints) => _Chart(
              width: constraints.maxWidth,
              roles: roles,
              spans: spans,
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              now: now,
              onSelect: onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: p.isDark ? 0.45 : 0.3),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(label, style: AppText.ui(size: 12.5, color: p.textMuted)),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  final double width;
  final List<ExperienceEntry> roles;
  final List<RoleSpan> spans;
  final int rangeStart;
  final int rangeEnd;
  final DateTime now;
  final ValueChanged<int>? onSelect;

  const _Chart({
    required this.width,
    required this.roles,
    required this.spans,
    required this.rangeStart,
    required this.rangeEnd,
    required this.now,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final narrow = width < 640;
    final labelWidth = narrow ? 0.0 : 220.0;
    const axisHeight = 34.0;
    final rowHeight = narrow ? 62.0 : 48.0;
    const pad = 16.0;
    final trackWidth = width - labelWidth - pad * 2;
    final months = rangeEnd - rangeStart;

    double x(DateTime d) {
      final days = DateUtils.getDaysInMonth(d.year, d.month);
      final m = _monthIndex(d) - rangeStart + (d.day - 1) / days;
      return m / months * trackWidth;
    }

    final todayX = x(now);
    final ticks = <(double, String, bool)>[];
    for (var i = rangeStart + 1; i < rangeEnd; i++) {
      final month = i % 12 + 1;
      final year = i ~/ 12;
      if (month % 3 != 1) continue;
      final isYear = month == 1;
      if (narrow && !isYear) continue;
      ticks.add((
        x(DateTime(year, month)),
        isYear ? '$year' : _monthNames[month - 1],
        isYear,
      ));
    }

    final height = axisHeight + rowHeight * roles.length + 10;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: pad + labelWidth,
            top: 0,
            width: trackWidth,
            bottom: 0,
            child: CustomPaint(
              painter: _GridPainter(
                ticks: [for (final t in ticks) (t.$1, t.$3)],
                todayX: todayX,
                line: p.border,
                yearLine: p.borderStrong,
                today: p.text,
                top: axisHeight - 6,
              ),
            ),
          ),
          // Skip axis labels that would sit under the "Today" pill.
          for (final t in ticks)
            if (t.$1 + 40 < todayX - 24 || t.$1 > todayX + 24)
              Positioned(
                left: pad + labelWidth + t.$1 + 6,
                top: 10,
                child: Text(
                  t.$2,
                  style: AppText.mono(
                    size: 11,
                    weight: t.$3 ? FontWeight.w600 : FontWeight.w400,
                    color: t.$3 ? p.textMuted : p.textFaint,
                  ),
                ),
              ),
          Positioned(
            left: pad + labelWidth + todayX - 22,
            top: 7,
            child: Container(
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: p.text,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Today',
                textAlign: TextAlign.center,
                style: AppText.ui(
                  size: 10.5,
                  weight: FontWeight.w600,
                  color: p.surface,
                  height: 1.3,
                ),
              ),
            ),
          ),
          for (var i = 0; i < roles.length; i++)
            Positioned(
              left: 0,
              right: 0,
              top: axisHeight + rowHeight * i,
              height: rowHeight,
              child: _RoleRow(
                role: roles[i],
                span: spans[i],
                narrow: narrow,
                pad: pad,
                labelWidth: labelWidth,
                trackWidth: trackWidth,
                x: x,
                onTap: onSelect == null ? null : () => onSelect!(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleRow extends StatelessWidget {
  final ExperienceEntry role;
  final RoleSpan span;
  final bool narrow;
  final double pad;
  final double labelWidth;
  final double trackWidth;
  final double Function(DateTime) x;
  final VoidCallback? onTap;

  const _RoleRow({
    required this.role,
    required this.span,
    required this.narrow,
    required this.pad,
    required this.labelWidth,
    required this.trackWidth,
    required this.x,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = isProductRole(role) ? p.accent : p.info;
    final left = x(span.start);
    final right = x(span.end);
    const barHeight = 24.0;

    final labelStyle = AppText.mono(
      size: 11,
      weight: FontWeight.w500,
      color: p.text,
    );
    final labelWidthPx = (TextPainter(
      text: TextSpan(text: span.shortLabel, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout())
        .width;
    final labelInside = !narrow && right - left >= labelWidthPx + 18;

    final bar = Tooltip(
      message: '${role.position} · ${role.company}\n'
          '${role.period} · ${role.location}',
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: color.withValues(alpha: p.isDark ? 0.3 : 0.16),
          border: Border.all(color: color.withValues(alpha: 0.75)),
          borderRadius: BorderRadius.horizontal(
            left: const Radius.circular(6),
            right: Radius.circular(span.ongoing ? 2 : 6),
          ),
        ),
        child: labelInside
            ? Text(span.shortLabel, maxLines: 1, style: labelStyle)
            : null,
      ),
    );

    final track = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: left,
          width: math.max(right - left, 6),
          top: 0,
          bottom: 0,
          child: Center(child: bar),
        ),
        if (span.ongoing)
          Positioned(
            left: right + 3,
            right: 0,
            top: 0,
            bottom: 0,
            child: CustomPaint(painter: _DotsPainter(color)),
          ),
        if (!labelInside && !narrow)
          Positioned(
            left: right + 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                span.shortLabel,
                style: labelStyle.copyWith(color: p.textFaint),
              ),
            ),
          ),
        if (span.milestone != null)
          Positioned(
            left: x(span.milestone!) - 6,
            top: 0,
            bottom: 0,
            child: Center(
              child: Tooltip(
                message: 'Converted to full-time · '
                    '${_monthNames[span.milestone!.month - 1]} '
                    '${span.milestone!.year}',
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: p.text,
                      border: Border.all(color: p.surface, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    final title = Text(
      role.company,
      overflow: TextOverflow.ellipsis,
      style: AppText.ui(size: 13.5, weight: FontWeight.w600, color: p.text),
    );

    return Pressable(
      onTap: onTap,
      semanticLabel: '${role.position} at ${role.company}, ${role.period}',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: s.hovered ? p.sunken.withValues(alpha: 0.7) : null,
          border: focusOutline(context, s.focused),
        ),
        padding: EdgeInsets.symmetric(horizontal: pad),
        child: narrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(child: title),
                      const SizedBox(width: 8),
                      Text(
                        span.shortLabel,
                        style: AppText.mono(size: 11, color: p.textFaint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(height: barHeight, child: track),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          Text(
                            role.position,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.ui(
                              size: 12,
                              color: p.textMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: trackWidth, child: track),
                ],
              ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final List<(double, bool)> ticks;
  final double todayX;
  final Color line;
  final Color yearLine;
  final Color today;
  final double top;

  _GridPainter({
    required this.ticks,
    required this.todayX,
    required this.line,
    required this.yearLine,
    required this.today,
    required this.top,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final (x, isYear) in ticks) {
      canvas.drawLine(
        Offset(x, isYear ? 6 : top),
        Offset(x, size.height),
        Paint()
          ..color = isYear ? yearLine : line
          ..strokeWidth = 1,
      );
    }
    canvas.drawLine(
      Offset(todayX, 26),
      Offset(todayX, size.height),
      Paint()
        ..color = today
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.todayX != todayX || old.line != line || old.today != today;
}

/// Dotted tail after an ongoing role: it hasn't ended.
class _DotsPainter extends CustomPainter {
  final Color color;

  _DotsPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.7);
    for (var x = 2.0; x < size.width - 2; x += 7) {
      canvas.drawCircle(Offset(x, size.height / 2), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => old.color != color;
}
