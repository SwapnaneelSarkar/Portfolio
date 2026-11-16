import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioContent.profile;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 900;

    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.summary,
          style: AppText.body(
            size: isMobile ? 18 : 21,
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 36),
        const _HowIShip(),
        const SizedBox(height: 36),
        AnimatedButton(
          onPressed: () => _launchUrl(Assets.resumeUrl),
          text: 'Download resume',
          isPrimary: false,
          trailingIcon: Icons.download_rounded,
        ),
      ],
    );

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'About me',
            title: 'Product leadership with technical depth',
          ),
          SizedBox(height: isMobile ? 32 : 48),
          if (isMobile) ...[
            summary,
            const SizedBox(height: 40),
            const _IdCard(),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: summary),
                const SizedBox(width: 56),
                const Expanded(flex: 5, child: _IdCard()),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

/// How I work, as the three steps they actually happen in.
class _HowIShip extends StatelessWidget {
  const _HowIShip();

  static const _steps = [
    ('Discover', 'User interviews, workflow mapping, and problem framing'),
    ('Define', 'PRDs, roadmaps, prioritization, and sprint-ready specs'),
    ('Deliver', 'Ship with engineering, measure impact, iterate'),
  ];

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.sizeOf(context).width < 700;

    Widget step(int i) {
      final (title, detail) = _steps[i];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.marigold.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.marigold.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '${i + 1}',
                  style: AppText.mono(
                    size: 12,
                    weight: FontWeight.w700,
                    color: AppColors.marigold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppText.body(size: 17, weight: FontWeight.w600, height: 1),
              ),
              if (!stacked && i < _steps.length - 1) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Container(height: 1, color: AppColors.borderStrong),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(right: stacked ? 0 : 16),
            child: Text(
              detail,
              style: AppText.body(
                size: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HOW I SHIP',
          style: AppText.mono(
            size: 11,
            weight: FontWeight.w600,
            color: AppColors.textFaint,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        if (stacked)
          for (var i = 0; i < _steps.length; i++) ...[
            step(i),
            if (i < _steps.length - 1) const SizedBox(height: 18),
          ]
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _steps.length; i++)
                Expanded(child: step(i)),
            ],
          ),
      ],
    );
  }
}

/// Avatar + quick facts, styled like a team-directory card.
class _IdCard extends StatelessWidget {
  const _IdCard();

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioContent.profile;
    final education = PortfolioContent.education.first;
    final current = PortfolioContent.experiences.first;

    final facts = <(String, String)>[
      ('Now', '${current.position} · ${current.company}'),
      ('Based in', profile.location),
      ('Studied', '${education.institution} · CS & Business Systems'),
      ('Email', profile.email),
      ('Phone', profile.phone),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 210,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8E74FF), Color(0xFF4B2FC9), Color(0xFF2A1C78)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.marigold.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -8,
                  child: Image.asset(
                    Assets.avatarCutout,
                    height: 220,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    semanticLabel: 'Illustrated avatar of ${profile.name}',
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppText.display(
                    size: 20,
                    weight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.title,
                  style: AppText.body(
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          for (final (label, value) in facts)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 82,
                    child: Text(
                      label.toUpperCase(),
                      style: AppText.mono(
                        size: 10.5,
                        color: AppColors.textFaint,
                        letterSpacing: 1,
                        height: 1.9,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SelectableText(
                      value,
                      style: AppText.body(size: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
