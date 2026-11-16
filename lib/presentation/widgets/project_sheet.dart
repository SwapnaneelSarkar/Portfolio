import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

/// Opens a project in a side panel (desktop) or bottom sheet (phone), the
/// way an issue tracker previews an item without leaving the list.
Future<void> showProjectSheet(BuildContext context, ProjectEntry project) {
  if (AppLayout.isMobile(context)) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      builder: (_) => _ProjectDetail(project: project, inSheet: true),
    );
  }

  final reduceMotion = MediaQuery.of(context).disableAnimations;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close project',
    barrierColor: Colors.black.withValues(alpha: 0.22),
    transitionDuration: Duration(milliseconds: reduceMotion ? 0 : 200),
    pageBuilder: (context, _, __) => Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 560,
          child: _ProjectDetail(project: project, inSheet: false),
        ),
      ),
    ),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

class _ProjectDetail extends StatelessWidget {
  final ProjectEntry project;
  final bool inSheet;

  const _ProjectDetail({required this.project, required this.inSheet});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final main = project.projectUrl ?? project.githubUrl;
    final source = project.githubUrl != null && project.githubUrl != main
        ? project.githubUrl
        : null;

    final header = Padding(
      padding: EdgeInsets.fromLTRB(20, inSheet ? 0 : 14, 12, 0),
      child: Row(
        children: [
          StatusBadge(
            'Shipped',
            color: p.shipped,
            leading: const StatusIcon(StatusKind.shipped, size: 12),
          ),
          const SizedBox(width: 10),
          Text(project.period, style: AppText.mono(size: 12, color: p.textFaint)),
          const Spacer(),
          if (!inSheet) ...[
            const Kbd('esc'),
            const SizedBox(width: 4),
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );

    final body = ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        Text(
          project.title,
          style: AppText.display(size: 30, color: p.text, letterSpacing: -0.6),
        ),
        const SizedBox(height: 10),
        Text(
          project.description,
          style: AppText.ui(size: 15.5, color: p.textMuted, height: 1.6),
        ),
        if (main != null) ...[
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => openExternal(main),
                icon: Icon(projectLinkIcon(main), size: 15),
                label: Text(projectLinkLabel(main)),
              ),
              if (source != null)
                OutlinedButton.icon(
                  onPressed: () => openExternal(source),
                  icon: Icon(projectLinkIcon(source), size: 15),
                  label: const Text('Source code'),
                ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        Divider(color: p.border),
        const SizedBox(height: 18),
        Text(
          'Highlights',
          style: AppText.ui(size: 13, weight: FontWeight.w600, color: p.text),
        ),
        const SizedBox(height: 10),
        for (final h in project.highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: StatusIcon(StatusKind.shipped, size: 13),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    h,
                    style: AppText.ui(size: 14.5, color: p.text, height: 1.55),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        Text(
          'Properties',
          style: AppText.ui(size: 13, weight: FontWeight.w600, color: p.text),
        ),
        const SizedBox(height: 6),
        const PropertyRow(
          label: 'Status',
          child: Text('Shipped'),
        ),
        PropertyRow(label: 'Year', child: Text(project.period)),
        if (main != null)
          PropertyRow(
            label: 'Link',
            child: Align(
              alignment: Alignment.centerLeft,
              child: InlineLink(hostOf(main), onTap: () => openExternal(main)),
            ),
          ),
        PropertyRow(
          label: 'Stack',
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final t in project.technologies) LabelChip(t)],
          ),
        ),
      ],
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, Expanded(child: body)],
    );

    if (inSheet) return content;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
      },
      child: Focus(
        autofocus: true,
        child: Material(
          color: p.surface,
          clipBehavior: Clip.antiAlias,
          elevation: 24,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: p.border),
          ),
          child: content,
        ),
      ),
    );
  }
}
