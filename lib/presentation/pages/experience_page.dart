import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/experience_card.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Experience',
            subtitle: 'Roles, scope, and outcomes',
          ),
        ),
        const SizedBox(height: 32),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: PortfolioContent.experiences.asMap().entries.map((entry) {
              return FadeInSection(
                delay: Duration(milliseconds: 80 + entry.key * 70),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ExperienceCard(experience: entry.value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
