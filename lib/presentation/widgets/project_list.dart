import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/project_sheet.dart';

/// Projects as an issue list grouped under "Shipped". Clicking a row opens
/// the detail panel; the trailing link goes straight to the product.
class ProjectList extends StatelessWidget {
  final List<ProjectEntry> projects;
  final int? total;
  final VoidCallback? onShowAll;

  const ProjectList({
    super.key,
    required this.projects,
    this.total,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final hidden = (total ?? projects.length) - projects.length;
    return Panel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: p.sunken,
              child: Row(
                children: [
                  const StatusIcon(StatusKind.shipped),
                  const SizedBox(width: 10),
                  Text(
                    'Shipped',
                    style: AppText.ui(
                      size: 13,
                      weight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${total ?? projects.length}',
                    style: AppText.mono(size: 12, color: p.textFaint),
                  ),
                  const Spacer(),
                  Text(
                    'Click a row for details',
                    style: AppText.ui(size: 12, color: p.textFaint),
                  ),
                ],
              ),
            ),
            for (final project in projects) ...[
              Divider(height: 1, color: p.border),
              _ProjectRow(project: project),
            ],
            if (hidden > 0 && onShowAll != null) ...[
              Divider(height: 1, color: p.border),
              Pressable(
                onTap: onShowAll,
                isLink: true,
                builder: (context, s) => Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: s.hovered ? p.sunken : null,
                    border: focusOutline(context, s.focused),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 15, color: p.textFaint),
                      const SizedBox(width: 10),
                      Text(
                        '$hidden more shipped',
                        style: AppText.ui(
                          size: 13.5,
                          weight: FontWeight.w500,
                          color: s.hovered ? p.text : p.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ProjectEntry project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final url = project.projectUrl ?? project.githubUrl;
    final shown = project.technologies.take(2).toList();
    final extra = project.technologies.length - shown.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Pressable(
          onTap: () => showProjectSheet(context, project),
          semanticLabel: '${project.title}. ${project.description}',
          builder: (context, s) => AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: wide ? 0 : 12,
            ),
            constraints: BoxConstraints(minHeight: wide ? 48 : 0),
            decoration: BoxDecoration(
              color: s.hovered ? p.sunken : null,
              border: focusOutline(context, s.focused),
            ),
            child: wide
                ? Row(
                    children: [
                      const StatusIcon(StatusKind.shipped),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 196,
                        child: Text(
                          project.title,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.ui(
                            size: 14,
                            weight: FontWeight.w600,
                            color: p.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          project.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.ui(size: 13.5, color: p.textMuted),
                        ),
                      ),
                      const SizedBox(width: 16),
                      for (final t in shown) ...[
                        LabelChip(t),
                        const SizedBox(width: 6),
                      ],
                      if (extra > 0)
                        Text(
                          '+$extra',
                          style: AppText.mono(size: 11.5, color: p.textFaint),
                        ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 36,
                        child: Text(
                          project.period,
                          style: AppText.mono(size: 12, color: p.textFaint),
                        ),
                      ),
                      if (url != null)
                        IconButton(
                          onPressed: () => openExternal(url),
                          tooltip: projectLinkLabel(url),
                          icon: Icon(projectLinkIcon(url), size: 15),
                        )
                      else
                        const SizedBox(width: 34),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: StatusIcon(StatusKind.shipped),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    project.title,
                                    style: AppText.ui(
                                      size: 14.5,
                                      weight: FontWeight.w600,
                                      color: p.text,
                                    ),
                                  ),
                                ),
                                Text(
                                  project.period,
                                  style: AppText.mono(
                                    size: 12,
                                    color: p.textFaint,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              project.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.ui(
                                size: 13.5,
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                for (final t in shown) LabelChip(t),
                                if (extra > 0)
                                  Text(
                                    '+$extra',
                                    style: AppText.mono(
                                      size: 11.5,
                                      color: p.textFaint,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
