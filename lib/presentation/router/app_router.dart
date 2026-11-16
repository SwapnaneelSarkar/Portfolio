import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/pages/case_studies_page.dart';
import 'package:portfolio/presentation/pages/case_study_detail_page.dart';
import 'package:portfolio/presentation/pages/contact_page.dart';
import 'package:portfolio/presentation/pages/education_page.dart';
import 'package:portfolio/presentation/pages/experience_page.dart';
import 'package:portfolio/presentation/pages/home_page.dart';
import 'package:portfolio/presentation/pages/memory_game_page.dart';
import 'package:portfolio/presentation/pages/not_found_page.dart';
import 'package:portfolio/presentation/pages/projects_page.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/shell/app_shell.dart';

/// Quick cross-fade between pages inside the shell. The frame stays put, so
/// a short fade reads as "content changed" without feeling like a reload.
CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 160),
    reverseTransitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.of(context).disableAnimations) return child;
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

/// The hidden games keep their own dark arcade look.
Page<void> _game(GoRouterState state, Widget child) => _page(
      state,
      Theme(data: AppTheme.dark, child: child),
    );

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => AppShell(
      location: state.uri.path,
      child: const NotFoundPage(),
    ),
    routes: [
      GoRoute(path: '/splash', redirect: (context, state) => '/'),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _page(state, const HomePage()),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) =>
                _page(state, const ProjectsPage()),
          ),
          GoRoute(
            path: '/case-studies',
            pageBuilder: (context, state) =>
                _page(state, const CaseStudiesPage()),
          ),
          GoRoute(
            path: '/case-studies/:slug',
            pageBuilder: (context, state) => _page(
              state,
              CaseStudyDetailPage(slug: state.pathParameters['slug']!),
            ),
          ),
          GoRoute(
            path: '/experience',
            pageBuilder: (context, state) =>
                _page(state, const ExperiencePage()),
          ),
          GoRoute(
            path: '/education',
            pageBuilder: (context, state) =>
                _page(state, const EducationPage()),
          ),
          GoRoute(
            path: '/contact',
            pageBuilder: (context, state) => _page(state, const ContactPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/easter-egg',
        pageBuilder: (context, state) => _game(state, const SnakeGamePage()),
      ),
      GoRoute(
        path: '/memory',
        pageBuilder: (context, state) => _game(state, const MemoryGamePage()),
      ),
    ],
  );
}
