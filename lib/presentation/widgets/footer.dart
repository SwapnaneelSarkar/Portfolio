import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          // Logo and name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.accentPrimary.withOpacity(0.35),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  Assets.avatar,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.2),
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.person,
                        color: AppColors.textPrimary,
                        size: 26,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Swapnaneel Sarkar',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            PortfolioContent.profile.title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                FontAwesomeIcons.linkedin,
                PortfolioContent.profile.linkedInUrl,
                AppColors.accentPrimary,
              ),
              const SizedBox(width: 20),
              _buildSocialButton(
                FontAwesomeIcons.github,
                PortfolioContent.profile.githubUrl,
                AppColors.accentSecondary,
              ),
              const SizedBox(width: 20),
              _buildSocialButton(
                FontAwesomeIcons.envelope,
                'mailto:${PortfolioContent.profile.email}',
                AppColors.accentTertiary,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            '© 2026 Swapnaneel Sarkar. All rights reserved.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Made with Flutter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Made with ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const Icon(
                Icons.favorite,
                color: AppColors.accentTertiary,
                size: 16,
              ),
              const Text(
                ' using ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const FlutterLogo(size: 16),
              const Text(
                ' Flutter',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),

          // Easter egg hint
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showEasterEgg(context),
            child: const Text(
              'Psst... there\'s a hidden game somewhere',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String url, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(child: FaIcon(icon, color: color, size: 20)),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showEasterEgg(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SnakeGamePage()));
  }
}
