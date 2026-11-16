import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/project_list.dart';
import 'package:portfolio/presentation/widgets/project_sheet.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

enum _View { list, board }

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  _View _view = _View.list;

  @override
  Widget build(BuildContext context) {
    const projects = PortfolioContent.projects;
    return PageBody(
      children: [
        PageHeader(
          title: 'Projects',
          description: 'Each of these started as an ambiguous problem. I owned '
              'the product decisions, scoped the MVP, and shipped. '
              '${projects.length} products, from AI voice platforms to '
              'developer tools.',
          trailing: _ViewSwitch(
            value: _view,
            onChanged: (v) => setState(() => _view = v),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _view == _View.list
              ? const ProjectList(projects: projects)
              : const _Board(projects: projects),
        ),
      ],
    );
  }
}

class _ViewSwitch extends StatelessWidget {
  final _View value;
  final ValueChanged<_View> onChanged;

  const _ViewSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget option(_View v, IconData icon, String label) {
      final on = value == v;
      return Pressable(
        onTap: () => onChanged(v),
        semanticLabel: '$label view${on ? ', selected' : ''}',
        builder: (context, s) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: on ? p.surface : (s.hovered ? p.hover : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
            border: s.focused
                ? Border.all(color: p.accent, width: 2)
                : Border.all(color: on ? p.border : Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: on ? p.text : p.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.ui(
                  size: 13,
                  weight: FontWeight.w500,
                  color: on ? p.text : p.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: p.sunken,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(_View.list, Icons.view_agenda_outlined, 'List'),
          const SizedBox(width: 2),
          option(_View.board, Icons.view_week_outlined, 'Board'),
        ],
      ),
    );
  }
}

/// Board view: one column per launch year.
class _Board extends StatelessWidget {
  final List<ProjectEntry> projects;

  const _Board({required this.projects});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final years = <String, List<ProjectEntry>>{};
    for (final project in projects) {
      years.putIfAbsent(project.period, () => []).add(project);
    }

    final columns = [
      for (final entry in years.entries)
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: p.sunken,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
                child: Row(
                  children: [
                    const StatusIcon(StatusKind.shipped),
                    const SizedBox(width: 8),
                    Text(
                      'Shipped in ${entry.key}',
                      style: AppText.ui(
                        size: 13,
                        weight: FontWeight.w600,
                        color: p.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value.length}',
                      style: AppText.mono(size: 12, color: p.textFaint),
                    ),
                  ],
                ),
              ),
              for (final project in entry.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BoardCard(project: project),
                ),
            ],
          ),
        ),
    ];

    return ResponsiveGrid(
      minCellWidth: 320,
      maxColumns: 2,
      spacing: 12,
      children: columns,
    );
  }
}

class _BoardCard extends StatelessWidget {
  final ProjectEntry project;

  const _BoardCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Panel(
      padding: const EdgeInsets.all(14),
      semanticLabel: '${project.title}. ${project.description}',
      onTap: () => showProjectSheet(context, project),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: AppText.ui(size: 14, weight: FontWeight.w600, color: p.text),
          ),
          const SizedBox(height: 4),
          Text(
            project.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.ui(size: 13, color: p.textMuted, height: 1.5),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in project.technologies.take(3)) LabelChip(t),
            ],
          ),
        ],
      ),
    );
  }
}
