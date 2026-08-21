import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profile = PortfolioContent.profile;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'About Me',
            subtitle: 'Product leadership with technical depth',
          ),
          const SizedBox(height: 56),
          isMobile
              ? Column(
                  children: [
                    _buildAboutContent(textTheme, profile),
                    const SizedBox(height: 32),
                    const _HowIShipPanel(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildAboutContent(textTheme, profile),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(flex: 2, child: _HowIShipPanel()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildAboutContent(TextTheme textTheme, ProfileInfo profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.summary, style: textTheme.bodyLarge),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildInfoItem(Icons.work_outline, profile.title),
            _buildInfoItem(
                Icons.school_outlined, 'VIT-AP · CS & Business Systems'),
            _buildInfoItem(Icons.location_on_outlined, profile.location),
            _buildInfoItem(Icons.email_outlined, profile.email),
            _buildInfoItem(Icons.phone_outlined, profile.phone),
          ],
        ),
        const SizedBox(height: 32),
        AnimatedButton(
          onPressed: () => _launchUrl(Assets.resumeUrl),
          text: 'Download Resume',
          isPrimary: true,
          trailingIcon: Icons.download_outlined,
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accentPrimary, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
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

/// The operating loop — how a brief becomes a shipped product.
class _HowIShipPanel extends StatelessWidget {
  const _HowIShipPanel();

  static const _steps = [
    (
      index: '01',
      title: 'Discover',
      detail: 'User interviews, workflow mapping, and problem framing',
    ),
    (
      index: '02',
      title: 'Define',
      detail: 'PRDs, roadmaps, prioritization, and sprint-ready specs',
    ),
    (
      index: '03',
      title: 'Deliver',
      detail: 'Ship with engineering, measure impact, iterate',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      accentColor: AppColors.accentSecondary,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW I SHIP',
            style: AppFonts.mono(
              fontSize: 11,
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < _steps.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ).createShader(bounds),
                  child: Text(
                    _steps[i].index,
                    style: AppFonts.mono(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_steps[i].title, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(_steps[i].detail, style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            if (i != _steps.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
