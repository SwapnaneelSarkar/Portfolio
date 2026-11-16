import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_content.dart';

class NavItem {
  final String label;

  /// Shorter label for the mobile tab bar.
  final String shortLabel;
  final String route;
  final IconData icon;
  final int? count;

  const NavItem({
    required this.label,
    required this.route,
    required this.icon,
    String? shortLabel,
    this.count,
  }) : shortLabel = shortLabel ?? label;
}

class Nav {
  static const overview = NavItem(
    label: 'Overview',
    shortLabel: 'Home',
    route: '/',
    icon: Icons.space_dashboard_outlined,
  );
  static const contact = NavItem(
    label: 'Contact',
    route: '/contact',
    icon: Icons.mail_outline,
  );
  static final projects = NavItem(
    label: 'Projects',
    route: '/projects',
    icon: Icons.inventory_2_outlined,
    count: PortfolioContent.projects.length,
  );
  static final caseStudies = NavItem(
    label: 'Case studies',
    shortLabel: 'Studies',
    route: '/case-studies',
    icon: Icons.description_outlined,
    count: PortfolioContent.caseStudies.length,
  );
  static final experience = NavItem(
    label: 'Experience',
    route: '/experience',
    icon: Icons.view_timeline_outlined,
    count: PortfolioContent.experiences.length,
  );
  static final education = NavItem(
    label: 'Education',
    route: '/education',
    icon: Icons.school_outlined,
    count: PortfolioContent.education.length,
  );

  static List<NavItem> get primary => const [overview, contact];
  static List<NavItem> get portfolio =>
      [projects, caseStudies, experience, education];
  static List<NavItem> get tabs =>
      [overview, projects, caseStudies, experience, contact];
  static List<NavItem> get all => [...primary, ...portfolio];

  static bool isActive(String location, String route) => route == '/'
      ? location == '/'
      : location == route || location.startsWith('$route/');

  /// Breadcrumb trail for a path: (label, route) with a null route for the
  /// current page.
  static List<(String, String?)> crumbs(String location) {
    if (location == '/') return const [('Overview', null)];
    final trail = <(String, String?)>[('Overview', '/')];
    final match = all.where((n) => n.route != '/' && isActive(location, n.route));
    if (match.isEmpty) return [...trail, ('Page not found', null)];
    final section = match.first;
    if (location == section.route) return [...trail, (section.label, null)];
    final slug = location.substring(section.route.length + 1);
    final study = PortfolioContent.caseStudyBySlug(slug);
    return [
      ...trail,
      (section.label, section.route),
      (study?.title ?? 'Not found', null),
    ];
  }

  static bool get isApple =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static String get searchShortcut => isApple ? '⌘K' : 'Ctrl K';
}
