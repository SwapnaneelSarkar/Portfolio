import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/experience_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ExperiencePreview extends StatelessWidget {
  const ExperiencePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = PortfolioContent.experiences.take(2).toList();

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Experience',
            subtitle: 'Discovery to launch across clients and products',
          ),
          const SizedBox(height: 40),
          ...preview.map(
            (exp) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ExperienceCard(experience: exp),
            ),
          ),
          const SizedBox(height: 32),
          AnimatedButton(
            onPressed: () => context.go('/experience'),
            text: 'View Full Experience',
            isPrimary: false,
          ),
        ],
      ),
    );
  }
}
