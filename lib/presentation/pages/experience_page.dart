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
    final entries = PortfolioContent.experiences;
    final showRail = MediaQuery.sizeOf(context).width >= 700;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Experience',
            subtitle: 'Roles · Scope · Outcomes',
          ),
        ),
        const SizedBox(height: 48),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: entries.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              final isLast = index == entries.length - 1;

              final card = FadeInSection(
                delay: Duration(milliseconds: 70 * (index % 4)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ExperienceCard(experience: exp),
                ),
              );

              if (!showRail) return card;

              // Stack-based rail: sizes to the card, so cards with Wrap
              // content never get clipped by intrinsic-height guesses.
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 44),
                    child: card,
                  ),
                  Positioned(
                    left: 4,
                    top: 26,
                    child: _RailDot(color: exp.color),
                  ),
                  if (!isLast)
                    Positioned(
                      left: 9.25,
                      top: 46,
                      bottom: 0,
                      child: _RailLine(color: exp.color),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RailDot extends StatelessWidget {
  final Color color;

  const _RailDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _RailLine extends StatelessWidget {
  final Color color;

  const _RailLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
      ),
    );
  }
}
