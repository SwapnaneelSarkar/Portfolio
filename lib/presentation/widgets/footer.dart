import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.45),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.07)),
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
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset(
                    Assets.avatar,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.05),
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
            'Product Manager · 0→1 Builder',
            style: AppFonts.mono(
              fontSize: 11,
              color: AppColors.textSecondary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 28),
          // Quick navigation
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: const [
              _FooterLink(label: 'Home', route: '/'),
              _FooterLink(label: 'Projects', route: '/projects'),
              _FooterLink(label: 'Case Studies', route: '/case-studies'),
              _FooterLink(label: 'Experience', route: '/experience'),
              _FooterLink(label: 'Education', route: '/education'),
              _FooterLink(label: 'Contact', route: '/contact'),
            ],
          ),
          const SizedBox(height: 28),
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
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            'DESIGNED & BUILT IN FLUTTER — 2026',
            style: AppFonts.mono(
              fontSize: 10,
              color: AppColors.textSecondary.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showEasterEgg(context),
            child: Text(
              '// there is a hidden game somewhere',
              style: AppFonts.mono(
                fontSize: 9.5,
                color: AppColors.textSecondary.withOpacity(0.5),
                letterSpacing: 1,
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
    context.push('/easter-egg');
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final String route;

  const _FooterLink({required this.label, required this.route});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: _hovered
                  ? AppColors.accentPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
