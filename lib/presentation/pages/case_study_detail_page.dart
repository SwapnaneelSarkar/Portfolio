import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/case_study_tiles.dart';

/// A case study as a document page: cover, title, properties, abstract, and
/// the button to open the full deck.
class CaseStudyDetailPage extends StatelessWidget {
  final String slug;

  const CaseStudyDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final study = PortfolioContent.caseStudyBySlug(slug);
    if (study == null) {
      return PageBody(
        children: [
          const PageHeader(
            title: 'Case study not found',
            description: 'This link doesn\'t match any case study. Pick one '
                'from the list instead.',
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => context.go('/case-studies'),
              child: const Text('See all case studies'),
            ),
          ),
        ],
      );
    }

    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    final others =
        PortfolioContent.caseStudies.where((s) => s.slug != slug).toList();

    return PageBody(
      maxWidth: 760,
      children: [
        DocCover(study: study, height: mobile ? 150 : 200, rounded: true),
        const SizedBox(height: 28),
        Row(
          children: [
            Icon(Icons.description_outlined, size: 15, color: p.docs),
            const SizedBox(width: 6),
            Text(
              'Case study',
              style: AppText.ui(
                size: 13,
                weight: FontWeight.w600,
                color: p.docs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Semantics(
          header: true,
          child: Text(
            study.title,
            style: AppText.display(size: mobile ? 32 : 44, color: p.text),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          study.subtitle,
          style: AppText.ui(size: 17, color: p.textMuted, height: 1.5),
        ),
        const SizedBox(height: 20),
        const PropertyRow(
          label: 'Format',
          child: Text('Slide deck · Google Slides'),
        ),
        PropertyRow(
          label: 'Topics',
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final t in study.tags) LabelChip(t)],
          ),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, color: p.border),
        const SizedBox(height: 24),
        Text(
          study.summary,
          style: AppText.ui(size: 16.5, color: p.text, height: 1.75),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => openExternal(study.externalUrl),
              icon: const Icon(Icons.north_east, size: 15),
              label: const Text('Open the full deck'),
            ),
            OutlinedButton(
              onPressed: () => context.go('/case-studies'),
              child: const Text('All case studies'),
            ),
          ],
        ),
        if (others.isNotEmpty) ...[
          const SizedBox(height: 56),
          const SectionTitle('More case studies'),
          Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < others.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: p.border),
                  _DocRow(study: others[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  final CaseStudyEntry study;

  const _DocRow({required this.study});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: () => context.go('/case-studies/${study.slug}'),
      isLink: true,
      semanticLabel: 'Case study: ${study.title}',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: s.hovered ? p.sunken : null,
          border: focusOutline(context, s.focused),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined, size: 16, color: p.docs),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    study.title,
                    style: AppText.ui(
                      size: 14,
                      weight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  Text(
                    study.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.ui(size: 13, color: p.textMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, size: 15, color: p.textFaint),
          ],
        ),
      ),
    );
  }
}
