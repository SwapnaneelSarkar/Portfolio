import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profile = PortfolioContent.profile;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'About Me',
            subtitle: 'Product leadership with technical depth',
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: [
                    _buildAboutContent(textTheme, profile),
                    const SizedBox(height: 32),
                    _buildLottie(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: _buildAboutContent(textTheme, profile)),
                    Expanded(flex: 2, child: _buildLottie()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildLottie() {
    return AnimatedBuilder(
      animation: _lottieController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.85 + (0.15 * _lottieController.value),
          child: Opacity(opacity: _lottieController.value, child: child),
        );
      },
      child: Lottie.network(
        Assets.codingAnimation,
        fit: BoxFit.contain,
        height: 280,
      ),
    );
  }

  Widget _buildAboutContent(TextTheme textTheme, ProfileInfo profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Summary',
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.accentPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(profile.summary, style: textTheme.bodyLarge),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildInfoItem(Icons.work_outline, profile.title),
            _buildInfoItem(Icons.school_outlined, 'VIT-AP · CS & Business Systems'),
            _buildInfoItem(Icons.location_on_outlined, profile.location),
            _buildInfoItem(Icons.email_outlined, profile.email),
            _buildInfoItem(Icons.phone_outlined, profile.phone),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () => _launchUrl(Assets.resumeUrl),
          icon: const Icon(Icons.download),
          label: const Text('Download Resume'),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
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
