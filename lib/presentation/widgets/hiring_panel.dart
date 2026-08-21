import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// What I'm looking for + fastest ways to reach me — the site's strongest
/// conversion element, shared by the home contact preview and /contact.
class HiringPanel extends StatelessWidget {
  const HiringPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profile = PortfolioContent.profile;

    return GlassCard(
      accentColor: AppColors.accentPrimary,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENTLY OPEN TO',
            style: AppFonts.mono(
              fontSize: 11,
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Product Manager · APM\n0→1 Product Roles',
            style: textTheme.headlineSmall?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 16),
          Text(
            'Supply chain, ERP & AI products a specialty\nFull-time · Hybrid or Remote · Available now',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 20),
          Row(
            children: [
              _social(FontAwesomeIcons.linkedin, profile.linkedInUrl),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        ),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Center(
            child: FaIcon(icon, color: AppColors.textPrimary, size: 17),
          ),
        ),
      ),
    );
  }
}
