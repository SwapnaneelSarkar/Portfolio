import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/pages/home_page.dart';
import 'package:portfolio/presentation/pages/projects_page.dart';
import 'package:portfolio/presentation/pages/case_studies_page.dart';
import 'package:portfolio/presentation/pages/case_study_detail_page.dart';
import 'package:portfolio/presentation/pages/experience_page.dart';
import 'package:portfolio/presentation/pages/education_page.dart';
import 'package:portfolio/presentation/pages/contact_page.dart';
import 'package:portfolio/presentation/pages/memory_game_page.dart';
import 'package:portfolio/presentation/pages/not_found_page.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';

/// Shared route transition: fade with a subtle upward rise.
CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 380),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AppRouter {
  static final GoRouter router = GoRouter(
    // Land directly on content — the hero entrance IS the intro. A splash
    // delay taxes every recruiter click and traps the browser Back button.
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(path: '/splash', redirect: (context, state) => '/'),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _page(state, const HomePage()),
      ),
      GoRoute(
        path: '/case-studies',
        pageBuilder: (context, state) => _page(state, const CaseStudiesPage()),
      ),
      GoRoute(
        path: '/case-studies/:slug',
        pageBuilder: (context, state) => _page(
          state,
          CaseStudyDetailPage(slug: state.pathParameters['slug']!),
        ),
      ),
      GoRoute(
        path: '/projects',
        pageBuilder: (context, state) => _page(state, const ProjectsPage()),
      ),
      GoRoute(
        path: '/experience',
        pageBuilder: (context, state) => _page(state, const ExperiencePage()),
      ),
      GoRoute(
        path: '/education',
        pageBuilder: (context, state) => _page(state, const EducationPage()),
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (context, state) => _page(state, const ContactPage()),
      ),
      GoRoute(
        path: '/easter-egg',
        pageBuilder: (context, state) => _page(state, const SnakeGamePage()),
      ),
      GoRoute(
        path: '/memory',
        pageBuilder: (context, state) => _page(state, const MemoryGamePage()),
      ),
    ],
  );
}
