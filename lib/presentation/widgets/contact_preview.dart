import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/hiring_panel.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ContactPreview extends StatelessWidget {
  const ContactPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 900;

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Get In Touch',
            subtitle: 'Let\'s build something that ships',
          ),
          const SizedBox(height: 56),
          isMobile
              ? Column(
                  children: [
                    _buildContactContent(context, textTheme),
                    const SizedBox(height: 32),
                    const HiringPanel(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildContactContent(context, textTheme),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(flex: 2, child: HiringPanel()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactContent(BuildContext context, TextTheme textTheme) {
    final profile = PortfolioContent.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hiring for a product role?',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'I\'m happy to walk you through any of my case studies, products, or how I\'d approach your problem space. Reach out — I respond fast.',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        _buildContactItem(Icons.email_outlined, 'Email', profile.email),
        const SizedBox(height: 16),
        _buildContactItem(Icons.phone_outlined, 'Phone', profile.phone),
        const SizedBox(height: 16),
        _buildContactItem(
            Icons.location_on_outlined, 'Location', profile.location),
        const SizedBox(height: 36),
        AnimatedButton(
          onPressed: () => context.go('/contact'),
          text: 'Contact Me',
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.accentPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accentPrimary.withValues(alpha: 0.25),
            ),
          ),
          child: Icon(icon, color: AppColors.accentPrimary, size: 19),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFonts.mono(
                fontSize: 10,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
