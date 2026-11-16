import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return PageBody(
      maxWidth: 560,
      children: [
        const SizedBox(height: 40),
        const Align(
          alignment: Alignment.centerLeft,
          child: StatusIcon(StatusKind.todo, size: 28),
        ),
        const SizedBox(height: 18),
        Text(
          'This page doesn\'t exist',
          style: AppText.display(size: 34, color: p.text),
        ),
        const SizedBox(height: 10),
        Text(
          'The link may be out of date, or the page was moved. Everything on '
          'this site is one click away from the overview.',
          style: AppText.ui(size: 16, color: p.textMuted, height: 1.55),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to overview'),
            ),
            OutlinedButton(
              onPressed: () => context.go('/projects'),
              child: const Text('View projects'),
            ),
          ],
        ),
      ],
    );
  }
}
