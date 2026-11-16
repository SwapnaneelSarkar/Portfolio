import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/blocs/theme/theme_cubit.dart';
import 'package:portfolio/presentation/shell/nav.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

class Sidebar extends StatelessWidget {
  final String location;
  final VoidCallback onSearch;

  /// Called with a route when an item is picked; the shell decides how to
  /// navigate (and closes the drawer on small screens).
  final ValueChanged<String> onNavigate;

  const Sidebar({
    super.key,
    required this.location,
    required this.onSearch,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    const profile = PortfolioContent.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
          child: _WorkspaceHeader(onHome: () => onNavigate('/')),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _SearchField(onTap: onSearch),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              for (final item in Nav.primary)
                _NavTile(
                  icon: item.icon,
                  label: item.label,
                  active: Nav.isActive(location, item.route),
                  onTap: () => onNavigate(item.route),
                ),
              const _GroupLabel('Portfolio'),
              for (final item in Nav.portfolio)
                _NavTile(
                  icon: item.icon,
                  label: item.label,
                  count: item.count,
                  active: Nav.isActive(location, item.route),
                  onTap: () => onNavigate(item.route),
                ),
              const _GroupLabel('Links'),
              const _NavTile(
                icon: Icons.file_download_outlined,
                label: 'Resume (PDF)',
                external: true,
                onTap: openResume,
              ),
              _NavTile(
                icon: FontAwesomeIcons.linkedinIn,
                label: 'LinkedIn',
                external: true,
                onTap: () => openExternal(profile.linkedInUrl),
              ),
              _NavTile(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                external: true,
                onTap: () => openExternal(profile.githubUrl),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: _AvailabilityCard(onTap: () => onNavigate('/contact')),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
          child: ThemeSwitchTile(),
        ),
      ],
    );
  }
}

/// Avatar + name. Clicking it five times in a row opens the hidden game.
class _WorkspaceHeader extends StatefulWidget {
  final VoidCallback onHome;

  const _WorkspaceHeader({required this.onHome});

  @override
  State<_WorkspaceHeader> createState() => _WorkspaceHeaderState();
}

class _WorkspaceHeaderState extends State<_WorkspaceHeader> {
  int _clicks = 0;
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);

  void _onTap() {
    final now = DateTime.now();
    _clicks = now.difference(_last).inMilliseconds < 600 ? _clicks + 1 : 1;
    _last = now;
    if (_clicks >= 5) {
      _clicks = 0;
      context.push('/easter-egg');
      return;
    }
    widget.onHome();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: _onTap,
      semanticLabel: 'Swapnaneel Sarkar, go to overview',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: s.hovered ? p.hover : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: focusOutline(context, s.focused),
        ),
        child: Row(
          children: [
            const Avatar(size: 30, radius: 8),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PortfolioContent.profile.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.ui(
                      size: 13.5,
                      weight: FontWeight.w600,
                      color: p.text,
                      height: 1.25,
                    ),
                  ),
                  Text(
                    'Product Manager',
                    style: AppText.ui(
                      size: 12,
                      color: p.textFaint,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchField({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Search, ${Nav.searchShortcut}',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 34,
        padding: const EdgeInsets.only(left: 10, right: 6),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(8),
          border: s.focused
              ? Border.all(color: p.accent, width: 2)
              : Border.all(color: s.hovered ? p.borderStrong : p.border),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 16, color: p.textFaint),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search or jump to…',
                style: AppText.ui(size: 13, color: p.textFaint),
              ),
            ),
            Kbd(Nav.searchShortcut),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;

  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 6),
      child: Text(
        label,
        style: AppText.ui(
          size: 12,
          weight: FontWeight.w500,
          color: context.palette.textFaint,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final bool external;
  final int? count;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.external = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Pressable(
        onTap: onTap,
        isLink: true,
        semanticLabel: external ? '$label, opens in a new tab' : label,
        builder: (context, s) => AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: active
                ? p.selected
                : s.hovered
                    ? p.hover
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: focusOutline(context, s.focused),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: active ? p.text : p.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.ui(
                    size: 13.5,
                    weight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? p.text : p.textMuted,
                  ),
                ),
              ),
              if (count != null)
                Text(
                  '$count',
                  style: AppText.mono(size: 11.5, color: p.textFaint),
                ),
              if (external)
                Icon(Icons.north_east, size: 13, color: p.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AvailabilityCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Panel(
      onTap: onTap,
      semanticLabel: 'Open to Product Manager roles. Get in touch.',
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Dot(p.shipped, size: 7),
              const SizedBox(width: 9),
              Text(
                'Open to PM roles',
                style: AppText.ui(
                  size: 13,
                  weight: FontWeight.w600,
                  color: p.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Supply chain · AI · SaaS',
            style: AppText.ui(size: 12, color: p.textMuted),
          ),
        ],
      ),
    );
  }
}

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    void toggle() =>
        context.read<ThemeCubit>().toggle(Theme.of(context).brightness);
    return Pressable(
      onTap: toggle,
      semanticLabel: p.isDark ? 'Switch to light theme' : 'Switch to dark theme',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: s.hovered ? p.hover : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: focusOutline(context, s.focused),
        ),
        child: Row(
          children: [
            Icon(
              p.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 15,
              color: p.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Dark theme',
                style: AppText.ui(
                  size: 13.5,
                  weight: FontWeight.w500,
                  color: p.textMuted,
                ),
              ),
            ),
            _MiniSwitch(on: p.isDark),
          ],
        ),
      ),
    );
  }
}

class _MiniSwitch extends StatelessWidget {
  final bool on;

  const _MiniSwitch({required this.on});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 28,
      height: 16,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: on ? p.primary : p.borderStrong,
        borderRadius: BorderRadius.circular(99),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: on ? p.onPrimary : Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
