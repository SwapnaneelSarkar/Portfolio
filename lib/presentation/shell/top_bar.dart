import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/blocs/theme/theme_cubit.dart';
import 'package:portfolio/presentation/shell/nav.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

/// Header of the main panel: where you are on the left, the two things a
/// recruiter came for (resume, contact) on the right.
class TopBar extends StatelessWidget {
  final String location;
  final bool compact;
  final VoidCallback onMenu;
  final VoidCallback onSearch;

  const TopBar({
    super.key,
    required this.location,
    required this.compact,
    required this.onMenu,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    final onContact = location == '/contact';

    return Container(
      height: AppLayout.topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(bottom: BorderSide(color: p.border)),
      ),
      child: Row(
        children: [
          if (compact) ...[
            IconButton(
              onPressed: onMenu,
              tooltip: 'Open menu',
              icon: const Icon(Icons.menu),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: mobile
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: _MobileTitle(location: location),
                  )
                : _Breadcrumbs(location: location),
          ),
          if (compact)
            IconButton(
              onPressed: onSearch,
              tooltip: 'Search (${Nav.searchShortcut})',
              icon: const Icon(Icons.search),
            ),
          if (compact)
            IconButton(
              onPressed: () => context
                  .read<ThemeCubit>()
                  .toggle(Theme.of(context).brightness),
              tooltip: p.isDark ? 'Switch to light theme' : 'Switch to dark theme',
              icon: Icon(
                p.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
            ),
          if (!mobile) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: openResume,
              icon: const Icon(Icons.file_download_outlined, size: 16),
              label: const Text('Resume'),
            ),
            if (!onContact) ...[
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => context.go('/contact'),
                child: const Text('Contact'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  final String location;

  const _Breadcrumbs({required this.location});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final crumbs = Nav.crumbs(location);
    return Semantics(
      label: 'Breadcrumb',
      child: Row(
        children: [
          for (var i = 0; i < crumbs.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right, size: 15, color: p.textFaint),
              ),
            if (crumbs[i].$2 != null)
              InlineLink(
                crumbs[i].$1,
                onTap: () => context.go(crumbs[i].$2!),
              )
            else
              Flexible(
                child: Text(
                  crumbs[i].$1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.ui(
                    size: 13.5,
                    weight: FontWeight.w600,
                    color: p.text,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _MobileTitle extends StatelessWidget {
  final String location;

  const _MobileTitle({required this.location});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: () => context.go('/'),
      semanticLabel: 'Swapnaneel Sarkar, go to overview',
      builder: (context, s) => Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: focusOutline(context, s.focused),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Avatar(size: 26, radius: 7),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                Nav.crumbs(location).last.$1,
                overflow: TextOverflow.ellipsis,
                style: AppText.ui(
                  size: 15,
                  weight: FontWeight.w600,
                  color: p.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom tab bar for phones.
class MobileTabBar extends StatelessWidget {
  final String location;

  const MobileTabBar({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              for (final item in Nav.tabs)
                Expanded(
                  child: _Tab(
                    item: item,
                    active: Nav.isActive(location, item.route),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final NavItem item;
  final bool active;

  const _Tab({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = active ? p.text : p.textFaint;
    return Pressable(
      onTap: () => context.go(item.route),
      semanticLabel: item.label,
      isLink: true,
      builder: (context, s) => Container(
        decoration: BoxDecoration(border: focusOutline(context, s.focused)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 18,
              height: 2,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: active ? p.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(item.icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(
              item.shortLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.ui(
                size: 11,
                weight: active ? FontWeight.w600 : FontWeight.w500,
                color: color,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
