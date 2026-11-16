import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';
import 'package:url_launcher/url_launcher.dart';

/// What I'm looking for + fastest ways to reach me — the site's strongest
/// conversion element, shared by the home contact preview and /contact.
class HiringPanel extends StatelessWidget {
  const HiringPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioContent.profile;

    return GlassCard(
      accentColor: AppColors.accentPrimary,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusPill(
            label: 'Currently open to',
            color: AppColors.now,
            pulse: true,
          ),
          const SizedBox(height: 18),
          Text(
            'Product Manager · APM\n0→1 Product Roles',
            style: AppText.display(
              size: 22,
              weight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Supply chain, ERP & AI products a specialty\nFull-time · Hybrid or Remote · Available now',
            style: AppText.body(
              size: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 20),
          Row(
            children: [
              _social(FontAwesomeIcons.linkedinIn, profile.linkedInUrl),
              const SizedBox(width: 12),
              _social(FontAwesomeIcons.github, profile.githubUrl),
              const SizedBox(width: 12),
              _social(FontAwesomeIcons.envelope, 'mailto:${profile.email}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _social(IconData icon, String url) {
    return InkWell(
      onTap: () => launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      ),
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Center(
          child: FaIcon(icon, color: AppColors.textSecondary, size: 16),
        ),
      ),
    );
  }
}
