import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(width);
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
              profile.title,
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
        _buildSocialButton(FontAwesomeIcons.github, 'GitHub', profile.githubUrl),
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
                  Row(
                    children: [identity, const Spacer(), socials],
                  ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('© 2026 ${profile.name}', style: smallPrint),
                    Text('Built with Flutter', style: smallPrint),
                    // Easter egg hint
                    InkWell(
                      onTap: () => _showEasterEgg(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Psst... there\'s a hidden game somewhere',
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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SnakeGamePage()));
  }
}
