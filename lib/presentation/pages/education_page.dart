import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  static const _education = [
    (
      institution: 'Vellore Institute of Technology, Andhra Pradesh (VIT-AP)',
      degree: 'B.Tech in Computer Science and Business Systems',
      period: 'Sep 2022 – May 2026',
      location: 'Amaravati',
      description:
          'Pursuing B.Tech in Computer Science and Business Systems with a CGPA of 8.19/10.0.',
      courses: [
        'Data Structures and Algorithms',
        'Object-Oriented Programming',
        'Database Management Systems',
        'Software Engineering',
        'Web Technologies',
        'Mobile Application Development',
      ],
      color: AppColors.accentPrimary,
    ),
    (
      institution: 'Kendriya Vidyalaya, Cooch Behar',
      degree: 'Higher Secondary Education',
      period: 'Apr 2010 – Jul 2022',
      location: 'Cooch Behar, West Bengal',
      description:
          'Completed higher secondary education with focus on science and mathematics.',
      courses: [
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'English',
        'Computer Science',
      ],
      color: AppColors.accentSecondary,
    ),
  ];

  static final _certificates = [
    (
      title: 'Problem Solving',
      issuer: 'HackerRank',
      date: 'January 2024',
      description:
          'Certification for problem-solving skills in algorithms and data structures.',
      url: Assets.certificateUrls['Problem Solving'],
    ),
    (
      title: 'Software Engineer',
      issuer: 'LinkedIn Learning',
      date: 'March 2024',
      description:
          'Comprehensive certification covering software engineering principles and practices.',
      url: Assets.certificateUrls['Software Engineer'],
    ),
    (
      title: 'Flutter & Dart',
      issuer: 'Udemy',
      date: 'November 2023',
      description:
          'Complete Flutter development bootcamp with Dart programming language.',
      url: Assets.certificateUrls['Flutter & Dart'],
    ),
    (
      title: 'Flutter Essentials',
      issuer: 'Google Developers',
      date: 'December 2023',
      description:
          'Essential Flutter development concepts and best practices.',
      url: Assets.certificateUrls['Flutter Essentials'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final showRail = MediaQuery.sizeOf(context).width >= 700;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Education',
            subtitle: 'Foundation',
          ),
        ),
        const SizedBox(height: 48),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _education.length; i++)
                _buildTimelineEntry(
                  context,
                  textTheme,
                  _education[i],
                  isLast: i == _education.length - 1,
                  showRail: showRail,
                  index: i,
                ),
              const SizedBox(height: 56),
              FadeInSection(
                child: Text(
                  'CERTIFICATIONS',
                  style: AppFonts.mono(
                    fontSize: 11,
                    color: AppColors.accentPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInSection(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final twoCol = constraints.maxWidth >= 800;
                    final cardWidth = twoCol
                        ? (constraints.maxWidth - 20) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        for (final cert in _certificates)
                          SizedBox(
                            width: cardWidth,
                            child: _CertificateCard(
                              title: cert.title,
                              issuer: cert.issuer,
                              date: cert.date,
                              description: cert.description,
                              url: cert.url,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineEntry(
    BuildContext context,
    TextTheme textTheme,
    ({
      Color color,
      List<String> courses,
      String degree,
      String description,
      String institution,
      String location,
      String period
    }) entry, {
    required bool isLast,
    required bool showRail,
    required int index,
  }) {
    final card = FadeInSection(
      delay: Duration(milliseconds: 80 * (index % 2)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: GlassCard(
          accentColor: entry.color,
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.institution, style: textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          entry.degree,
                          style: textTheme.titleMedium?.copyWith(
                            color: entry.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(entry.location, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      entry.period,
                      style: AppFonts.mono(fontSize: 11, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                entry.description,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textBody,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RELEVANT COURSEWORK',
                style: AppFonts.mono(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final course in entry.courses) TagChip(label: course),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!showRail) return card;

    // Stack-based rail: sizes to the card, so cards with Wrap content
    // never get clipped by intrinsic-height guesses.
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: card,
        ),
        Positioned(
          left: 4,
          top: 26,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color,
              boxShadow: [
                BoxShadow(
                  color: entry.color.withValues(alpha: 0.55),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Positioned(
            left: 9.25,
            top: 46,
            bottom: 0,
            child: Container(
              width: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    entry.color.withValues(alpha: 0.5),
                    Colors.white.withValues(alpha: 0.06),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String title;
  final String issuer;
  final String date;
  final String description;
  final String? url;

  const _CertificateCard({
    required this.title,
    required this.issuer,
    required this.date,
    required this.description,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      accentColor: AppColors.accentPrimary,
      padding: const EdgeInsets.all(24),
      onTap: url == null
          ? null
          : () => launchUrl(
                Uri.parse(url!),
                mode: LaunchMode.externalApplication,
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                color: AppColors.accentPrimary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: textTheme.titleMedium),
              ),
              if (url != null)
                const Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  issuer,
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                date.toUpperCase(),
                style: AppFonts.mono(
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
