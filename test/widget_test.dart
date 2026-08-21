import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/data/portfolio_content.dart';

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
}
