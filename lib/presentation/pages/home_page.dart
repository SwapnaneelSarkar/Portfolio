import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/career_roadmap.dart';
import 'package:portfolio/presentation/widgets/case_study_tiles.dart';
import 'package:portfolio/presentation/widgets/project_list.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

/// Overview, laid out like a project page in a PM tool: title and summary,
/// a status update, key results and a properties panel, then the roadmap
/// and the work itself.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = AppLayout.isMobile(context);
    final gap = SizedBox(height: mobile ? 44 : 60);
    const projects = PortfolioContent.projects;
    const roles = PortfolioContent.experiences;

    return PageBody(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(),
                  SizedBox(height: 28),
                  _Properties(),
                  SizedBox(height: 32),
                  _Summary(),
                ],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [_Header(), SizedBox(height: 36), _Summary()],
                  ),
                ),
                SizedBox(width: 40),
                SizedBox(width: 300, child: _Properties()),
              ],
            );
          },
        ),
        gap,
        SectionTitle(
          'Experience',
          count: '${roles.length} roles',
          description: 'From Flutter engineering to product management. '
              'Click a role for the details.',
          actionLabel: mobile ? null : 'Full experience',
          onAction: () => context.go('/experience'),
        ),
        CareerRoadmap(
          onSelect: (i) => context.go('/experience?role=$i'),
        ),
        gap,
        SectionTitle(
          'Shipped products',
          count: '${projects.length}',
          description: '0→1 builds, from AI voice agents to quick commerce.',
          actionLabel: mobile ? null : 'All projects',
          onAction: () => context.go('/projects'),
        ),
        ProjectList(
          projects: projects.take(5).toList(),
          total: projects.length,
          onShowAll: () => context.go('/projects'),
        ),
        gap,
        SectionTitle(
          'Case studies',
          count: '${PortfolioContent.caseStudies.length}',
          description:
              'Product strategy write-ups. Each one opens as a full slide deck.',
          actionLabel: mobile ? null : 'All case studies',
          onAction: () => context.go('/case-studies'),
        ),
        const CaseStudyGrid(studies: PortfolioContent.caseStudies),
        gap,
        const SectionTitle(
          'Where I\'ve shipped',
          description: 'Most PMs my age have shipped a to-do app. '
              'I\'ve shipped procurement systems.',
        ),
        const _Domains(),
        gap,
        const SectionTitle(
          'How I ship',
          description: 'The same three stages on every engagement.',
        ),
        const _Workflow(),
        gap,
        SectionTitle(
          'Skills',
          count: '${PortfolioContent.skillGroups.fold<int>(0, (n, g) => n + g.skills.length)}',
        ),
        const _Skills(),
        gap,
        const _ContactPrompt(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    const profile = PortfolioContent.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(size: mobile ? 56 : 68, radius: mobile ? 14 : 16),
        SizedBox(height: mobile ? 16 : 20),
        Semantics(
          header: true,
          child: Text(
            profile.name,
            style: AppText.display(
              size: mobile ? 38 : 54,
              weight: FontWeight.w700,
              color: p.text,
              letterSpacing: mobile ? -1 : -1.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Product Manager. I turn ambiguous briefs into shipped products.',
          style: AppText.ui(
            size: mobile ? 18 : 20,
            weight: FontWeight.w500,
            color: p.text,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'Rare depth in supply chain and ERP: procurement software, '
            'supplier platforms, and AI layers over SCM portals.',
            style: AppText.ui(size: 16, color: p.textMuted, height: 1.55),
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => context.go('/contact'),
              child: const Text('Contact me'),
            ),
            OutlinedButton.icon(
              onPressed: openResume,
              icon: const Icon(Icons.file_download_outlined, size: 16),
              label: const Text('Download resume'),
            ),
            TextButton(
              onPressed: () => context.go('/case-studies'),
              child: const Text('Read case studies'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Summary, latest update and key results: the left column under the title.
class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final current = PortfolioContent.experiences.first;
    final span = RoleSpan.of(current, DateTime.now());
    const metrics = PortfolioContent.impactMetrics;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          PortfolioContent.profile.summary,
          style: AppText.ui(size: 15.5, color: p.text, height: 1.7),
        ),
        const SizedBox(height: 28),
        const SectionTitle('Latest update'),
        Panel(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Avatar(size: 22, radius: 6),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Swapnaneel Sarkar',
                        children: [
                          if (span.milestone != null)
                            TextSpan(
                              text: '  ${months[span.milestone!.month - 1]} '
                                  '${span.milestone!.year}',
                              style: AppText.ui(
                                size: 13,
                                color: p.textFaint,
                              ),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.ui(
                        size: 13.5,
                        weight: FontWeight.w600,
                        color: p.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    'On track',
                    color: p.shipped,
                    leading: Dot(p.shipped, size: 6),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Converted from TPM intern to full-time at ${current.company}',
                style: AppText.ui(
                  size: 15,
                  weight: FontWeight.w600,
                  color: p.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Now owning delivery across 15+ client engagements: '
                'procurement software, supplier management platforms, '
                'end-to-end SCM, and an AI layer over a client\'s '
                'supply-chain portal.',
                style: AppText.ui(size: 14.5, color: p.textMuted, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SectionTitle(
          'Key results',
          count: '${metrics.length}/${metrics.length}',
        ),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < metrics.length; i++) ...[
                if (i > 0) Divider(height: 1, color: p.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const StatusIcon(StatusKind.shipped),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 84,
                        child: Text(
                          metrics[i].value,
                          style: AppText.mono(
                            size: 14.5,
                            weight: FontWeight.w600,
                            color: p.text,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          metrics[i].label,
                          style: AppText.ui(size: 14, color: p.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Right-hand properties panel, like an issue's sidebar.
class _Properties extends StatelessWidget {
  const _Properties();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const profile = PortfolioContent.profile;
    final current = PortfolioContent.experiences.first;
    final education = PortfolioContent.education.first;
    final dots = [p.accent, p.docs, p.info, p.shipped];

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            text,
            style: AppText.ui(size: 13, weight: FontWeight.w600, color: p.text),
          ),
        );

    return Panel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading('Properties'),
          PropertyRow(
            label: 'Status',
            child: Row(
              children: [
                Dot(p.shipped, size: 7),
                const SizedBox(width: 9),
                const Flexible(child: Text('Open to PM roles')),
              ],
            ),
          ),
          const PropertyRow(
            label: 'Looking for',
            child: Text('Product Manager, APM, 0→1 product roles'),
          ),
          const PropertyRow(
            label: 'Work type',
            child: Text('Full-time · Hybrid or remote'),
          ),
          PropertyRow(label: 'Role', child: Text(current.position)),
          PropertyRow(label: 'Company', child: Text(current.company)),
          PropertyRow(label: 'Location', child: Text(profile.location)),
          PropertyRow(
            label: 'Education',
            child: Text('${education.institution} · B.Tech'),
          ),
          PropertyRow(
            label: 'Focus',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < current.domains.length; i++)
                  LabelChip(current.domains[i], dot: dots[i % dots.length]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: p.border),
          const SizedBox(height: 12),
          heading('Links'),
          const _LinkLine(
            icon: Icons.file_download_outlined,
            label: 'Resume (PDF)',
            onTap: openResume,
          ),
          _LinkLine(
            icon: Icons.work_outline,
            label: 'LinkedIn',
            onTap: () => openExternal(profile.linkedInUrl),
          ),
          _LinkLine(
            icon: Icons.code,
            label: 'GitHub',
            onTap: () => openExternal(profile.githubUrl),
          ),
          _LinkLine(
            icon: Icons.mail_outline,
            label: profile.email,
            onTap: () => openExternal('mailto:${profile.email}'),
            trailing: IconButton(
              onPressed: () => copyEmail(context),
              tooltip: 'Copy email address',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.content_copy, size: 14),
            ),
          ),
          _LinkLine(
            icon: Icons.phone_outlined,
            label: profile.phone,
            onTap: () => openExternal(
              'tel:${profile.phone.replaceAll(' ', '')}',
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _LinkLine({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: InlineLink(label, icon: icon, onTap: onTap),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Domains extends StatelessWidget {
  const _Domains();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final colors = [p.accent, p.docs, p.info, p.shipped];
    const domains = PortfolioContent.domains;
    return ResponsiveGrid(
      minCellWidth: 360,
      maxColumns: 2,
      spacing: 16,
      children: [
        for (var i = 0; i < domains.length; i++)
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: p.tint(colors[i % colors.length]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        domains[i].icon,
                        size: 16,
                        color: colors[i % colors.length],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        domains[i].title,
                        style: AppText.ui(
                          size: 15,
                          weight: FontWeight.w600,
                          color: p.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  domains[i].description,
                  style: AppText.ui(size: 14, color: p.textMuted, height: 1.6),
                ),
                const Spacer(),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [for (final t in domains[i].tags) LabelChip(t)],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Discover → Define → Deliver, drawn with the same status glyphs the rest
/// of the site uses, because it is the same workflow.
class _Workflow extends StatelessWidget {
  const _Workflow();

  static const _steps = [
    (
      StatusKind.todo,
      'Discover',
      'User interviews, workflow mapping, and problem framing',
    ),
    (
      StatusKind.progress,
      'Define',
      'PRDs, roadmaps, prioritization, and sprint-ready specs',
    ),
    (
      StatusKind.shipped,
      'Deliver',
      'Ship with engineering, measure impact, iterate',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final stacked = AppLayout.width(context) < 860;

    Widget step(int i) {
      final (kind, title, detail) = _steps[i];
      return Panel(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusIcon(kind, size: 15),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AppText.ui(
                    size: 15,
                    weight: FontWeight.w600,
                    color: p.text,
                  ),
                ),
                const Spacer(),
                Text(
                  'Step ${i + 1} of 3',
                  style: AppText.mono(size: 11.5, color: p.textFaint),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              detail,
              style: AppText.ui(size: 14, color: p.textMuted, height: 1.55),
            ),
          ],
        ),
      );
    }

    final arrow = Icon(
      stacked ? Icons.south : Icons.east,
      size: 16,
      color: p.textFaint,
    );

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: arrow,
              ),
            step(i),
          ],
        ],
      );
    }

    return FontSafeIntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: arrow),
              ),
            Expanded(child: step(i)),
          ],
        ],
      ),
    );
  }
}

class _Skills extends StatelessWidget {
  const _Skills();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const groups = PortfolioContent.skillGroups;
    final stacked = AppLayout.width(context) < 860;

    return Panel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            if (i > 0) Divider(height: 1, color: p.border),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Flex(
                direction: stacked ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: stacked ? null : 220,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: stacked ? 0 : 3,
                        bottom: stacked ? 10 : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              groups[i].icon,
                              size: 15,
                              color: p.textMuted,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text.rich(
                              TextSpan(
                                text: groups[i].name,
                                children: [
                                  TextSpan(
                                    text: '  ${groups[i].skills.length}',
                                    style: AppText.mono(
                                      size: 11.5,
                                      color: p.textFaint,
                                    ),
                                  ),
                                ],
                              ),
                              style: AppText.ui(
                                size: 14,
                                weight: FontWeight.w600,
                                color: p.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (stacked)
                    _skillWrap(groups[i])
                  else
                    Expanded(child: _skillWrap(groups[i])),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _skillWrap(SkillGroup group) => Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [for (final s in group.skills) LabelChip(s)],
      );
}

class _ContactPrompt extends StatelessWidget {
  const _ContactPrompt();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    return Panel(
      color: p.sunken,
      padding: EdgeInsets.all(mobile ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Dot(p.shipped, size: 7),
              const SizedBox(width: 9),
              Text(
                'Open to Product Manager roles',
                style: AppText.ui(
                  size: 13,
                  weight: FontWeight.w600,
                  color: p.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Hiring for a product role?',
            style: AppText.display(
              size: mobile ? 26 : 32,
              color: p.text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'I\'m happy to walk you through any of my case studies, '
              'products, or how I\'d approach your problem space. '
              'I reply within 24 hours.',
              style: AppText.ui(size: 15.5, color: p.textMuted, height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () => context.go('/contact'),
                child: const Text('Send a message'),
              ),
              OutlinedButton.icon(
                onPressed: () => copyEmail(context),
                icon: const Icon(Icons.content_copy, size: 15),
                label: const Text('Copy email address'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
