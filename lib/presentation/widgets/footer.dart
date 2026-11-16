import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(context);
    final isMobile = width < 700;
    final profile = PortfolioContent.profile;

    final identity = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AvatarBadge(size: 44),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: AppText.display(size: 16, weight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Product Manager · 0→1 Builder',
              style: AppText.body(
                size: 13.5,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );

    final socials = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialButton(
          FontAwesomeIcons.linkedinIn,
          'LinkedIn',
          profile.linkedInUrl,
        ),
        const SizedBox(width: 10),
        _buildSocialButton(
          FontAwesomeIcons.github,
          'GitHub',
          profile.githubUrl,
        ),
        const SizedBox(width: 10),
        _buildSocialButton(
          FontAwesomeIcons.envelope,
          'Email',
          'mailto:${profile.email}',
        ),
      ],
    );

    final smallPrint = AppText.mono(size: 11.5, color: AppColors.textFaint);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppLayout.maxContentWidth + gutter * 2,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, 40, gutter, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile) ...[
                  identity,
                  const SizedBox(height: 24),
                  socials,
                ] else
                  Row(children: [identity, const Spacer(), socials]),
                const SizedBox(height: 28),
                // Links carry their own hit padding; pull the row back so the
                // first label lines up with the edge above.
                Transform.translate(
                  offset: const Offset(-10, 0),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: const [
                      _FooterLink(label: 'Home', route: '/'),
                      _FooterLink(label: 'Projects', route: '/projects'),
                      _FooterLink(
                        label: 'Case studies',
                        route: '/case-studies',
                      ),
                      _FooterLink(label: 'Experience', route: '/experience'),
                      _FooterLink(label: 'Education', route: '/education'),
                      _FooterLink(label: 'Contact', route: '/contact'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '© 2026 ${profile.name}. All rights reserved.',
                      style: smallPrint,
                    ),
                    Text('Designed & built in Flutter', style: smallPrint),
                    // Easter egg hint
                    InkWell(
                      onTap: () => _showEasterEgg(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '// there is a hidden game somewhere',
                          style: smallPrint.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    return Tooltip(
      message: label,
      child: Semantics(
        link: true,
        label: label,
        child: InkWell(
          onTap: () => _launchUrl(url),
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
    return InkWell(
      onTap: () => context.go(widget.route),
      onHover: (v) => setState(() => _hovered = v),
      borderRadius: BorderRadius.circular(999),
      hoverColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          widget.label,
          style: AppText.body(
            size: 14,
            weight: FontWeight.w500,
            height: 1,
            color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
