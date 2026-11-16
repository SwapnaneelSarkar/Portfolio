import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/career_roadmap.dart';

void main() {
  test('portfolio content is well-formed', () {
    expect(PortfolioContent.projects, isNotEmpty);
    expect(PortfolioContent.experiences, isNotEmpty);
    expect(PortfolioContent.caseStudies, isNotEmpty);

    for (final p in PortfolioContent.projects) {
      expect(p.title, isNotEmpty);
      expect(p.highlights, isNotEmpty);
      expect(p.technologies, isNotEmpty);
    }
  });

  test('every role period parses onto the roadmap', () {
    final now = DateTime(2026, 11, 16);
    for (final e in PortfolioContent.experiences) {
      final span = RoleSpan.of(e, now);
      expect(span.end.isAfter(span.start), isTrue, reason: e.period);
    }

    final heizen = RoleSpan.of(PortfolioContent.experiences.first, now);
    expect(heizen.ongoing, isTrue);
    expect(heizen.start, DateTime(2025, 11));
    expect(heizen.milestone, DateTime(2026, 7));
    expect(heizen.shortLabel, "Nov '25 – now");
  });
}
