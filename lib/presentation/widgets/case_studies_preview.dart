import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseStudiesPreview extends StatefulWidget {
  const CaseStudiesPreview({super.key});

  @override
  State<CaseStudiesPreview> createState() => _CaseStudiesPreviewState();
}

class _CaseStudiesPreviewState extends State<CaseStudiesPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final studies = PortfolioContent.caseStudies;

    return FadeTransition(
      opacity: _controller,
      child: ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Case Studies',
            subtitle: 'Product strategy and analysis (hosted separately)',
          ),
          const SizedBox(height: 40),
          ...studies.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CaseStudyCard(study: s, textTheme: textTheme),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            onPressed: () => context.go('/case-studies'),
            text: 'All Case Studies',
            isPrimary: false,
          ),
        ],
      ),
    ),
    );
  }
}

class _CaseStudyCard extends StatelessWidget {
  final CaseStudyEntry study;
  final TextTheme textTheme;

  const _CaseStudyCard({
    required this.study,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accentColor: study.color,
      onTap: () => _openStudy(study.externalUrl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            study.title,
            style: textTheme.titleLarge?.copyWith(color: study.color),
          ),
          const SizedBox(height: 6),
          Text(study.subtitle, style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(
            study.summary,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: study.tags
                .map((t) => TagChip(label: t, color: study.color))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Read full case study',
                style: textTheme.labelLarge?.copyWith(color: study.color),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_outward, size: 16, color: study.color),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openStudy(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
