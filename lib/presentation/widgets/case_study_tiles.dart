import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/primitives.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

/// Case studies as document cards: a page-like cover with the subject's
/// logo, then title, framing and tags.
class CaseStudyGrid extends StatelessWidget {
  final List<CaseStudyEntry> studies;

  const CaseStudyGrid({super.key, required this.studies});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      minCellWidth: 280,
      maxColumns: 3,
      spacing: 16,
      children: [for (final s in studies) DocCard(study: s)],
    );
  }
}

class DocCard extends StatelessWidget {
  final CaseStudyEntry study;

  const DocCard({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Panel(
      padding: EdgeInsets.zero,
      semanticLabel: 'Case study: ${study.title}. ${study.subtitle}',
      onTap: () => context.go('/case-studies/${study.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DocCover(study: study, height: 128),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_outlined, size: 14, color: p.docs),
                      const SizedBox(width: 6),
                      Text(
                        'Case study',
                        style: AppText.ui(
                          size: 12,
                          weight: FontWeight.w600,
                          color: p.docs,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Slide deck',
                        style: AppText.ui(size: 12, color: p.textFaint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    study.title,
                    style: AppText.ui(
                      size: 16,
                      weight: FontWeight.w600,
                      color: p.text,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    study.subtitle,
                    style: AppText.ui(size: 13.5, color: p.textMuted),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in study.tags.take(3)) LabelChip(t),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Read case study',
                        style: AppText.ui(
                          size: 13.5,
                          weight: FontWeight.w500,
                          color: p.text,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 14, color: p.text),
                    ],
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

/// The "page" of a document thumbnail. Logos sit on paper in both themes,
/// since most of them were made for white backgrounds.
class DocCover extends StatelessWidget {
  final CaseStudyEntry study;
  final double height;
  final bool rounded;

  const DocCover({
    super.key,
    required this.study,
    required this.height,
    this.rounded = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final paper = p.isDark ? const Color(0xFFE2E2DD) : p.sunken;
    final initials = study.title
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    final monogram = Container(
      width: height * 0.46,
      height: height * 0.46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF16181D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        initials,
        style: AppText.display(
          size: height * 0.18,
          color: Colors.white,
          letterSpacing: 0,
        ),
      ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: paper,
        borderRadius: rounded ? BorderRadius.circular(10) : null,
        border: rounded
            ? Border.all(color: p.border)
            : Border(bottom: BorderSide(color: p.border)),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        study.logoPath,
        height: height * 0.46,
        fit: BoxFit.contain,
        semanticLabel: '${study.title} logo',
        errorBuilder: (_, __, ___) => monogram,
      ),
    );
  }
}
