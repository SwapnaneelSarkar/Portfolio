import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/pages/memory_game_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const double _barHeight = 58;
const double _barTop = 14;

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  int _logoClickCount = 0;
  OverlayEntry? _menuOverlay;
  late AnimationController _animationController;
  late Animation<double> _menuAnimation;

  final List<Map<String, String>> _menuItems = [
    {'title': 'Home', 'route': '/'},
    {'title': 'Projects', 'route': '/projects'},
    {'title': 'Case studies', 'route': '/case-studies'},
    {'title': 'Experience', 'route': '/experience'},
    {'title': 'Education', 'route': '/education'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _menuAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _menuOverlay?.remove();
    _animationController.dispose();
    super.dispose();
  }

  String _currentPath(BuildContext context) {
    try {
      return GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    } catch (_) {
      return '';
    }
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_menuOverlay != null) return;
    final current = _currentPath(context);

    _menuOverlay = OverlayEntry(
      builder: (context) => _CompactMenuOverlay(
        animation: _menuAnimation,
        menuItems: _menuItems,
        currentPath: current,
        onClose: _closeMenu,
        onNavigate: (route) {
          this.context.go(route);
          this.context.read<NavigationBloc>().add(NavigateToPage(route));
          _closeMenu();
        },
        onShowGame: () async {
          await _closeMenu();
          if (mounted) _showEasterEgg(this.context, false);
        },
      ),
    );
    Overlay.of(context).insert(_menuOverlay!);
    setState(() {
      _isMenuOpen = true;
    });
    _animationController.forward(from: 0);
  }

  Future<void> _closeMenu() async {
    if (_menuOverlay == null) return;

    setState(() {
      _isMenuOpen = false;
    });
    await _animationController.reverse();
    _menuOverlay?.remove();
    _menuOverlay = null;
  }

  void _onLogoTap() {
    context.go('/');

    // Easter egg trigger - click logo 5 times
    setState(() {
      _logoClickCount++;
      if (_logoClickCount >= 5) {
        _logoClickCount = 0;
        _showEasterEgg(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 1040;
    final showName = width >= 420;
    final gutter = AppLayout.gutter(width);
    final current = _currentPath(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        width < 600 ? 12 : gutter - 8,
        _barTop,
        width < 600 ? 12 : gutter - 8,
        0,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth + 16,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: _barHeight,
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    _Logo(showName: showName, onTap: _onLogoTap),
                    const Spacer(),
                    if (!isCompact) ...[
                      for (final item in _menuItems)
                        _NavItem(
                          title: item['title']!,
                          route: item['route']!,
                          active: current == item['route'],
                        ),
                      const SizedBox(width: 10),
                      AnimatedButton(
                        onPressed: () => context.go('/contact'),
                        text: 'Contact',
                        isPrimary: true,
                        compact: true,
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ] else
                      _MenuButton(isOpen: _isMenuOpen, onTap: _toggleMenu),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEasterEgg(BuildContext context, bool isSnakeGame) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            isSnakeGame ? const SnakeGamePage() : const MemoryGamePage(),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool showName;
  final VoidCallback onTap;

  const _Logo({required this.showName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Swapnaneel Sarkar, home',
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 12, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AvatarBadge(size: 40),
              if (showName) ...[
                const SizedBox(width: 10),
                Text(
                  'Swapnaneel Sarkar',
                  style: AppText.display(
                    size: 14,
                    weight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Round avatar on a lilac→indigo tile. Shared by nav, footer and splash.
class AvatarBadge extends StatelessWidget {
  final double size;

  const AvatarBadge({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lilac, Color(0xFF5B3FD9)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        Assets.avatarCutout,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.1),
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.person,
          color: AppColors.textPrimary,
          size: size * 0.55,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _MenuButton({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isOpen ? 'Close menu' : 'Open menu',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOpen
                ? AppColors.marigold
                : Colors.white.withValues(alpha: 0.06),
          ),
          child: Icon(
            isOpen ? Icons.close_rounded : Icons.menu_rounded,
            color: isOpen ? AppColors.backgroundDark : AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _CompactMenuOverlay extends StatelessWidget {
  final Animation<double> animation;
  final List<Map<String, String>> menuItems;
  final String currentPath;
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;
  final VoidCallback onShowGame;

  const _CompactMenuOverlay({
    required this.animation,
    required this.menuItems,
    required this.currentPath,
    required this.onClose,
    required this.onNavigate,
    required this.onShowGame,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelWidth = size.width < 520 ? size.width - 24 : 400.0;
    const top = _barTop + _barHeight + 10;
    final profile = PortfolioContent.profile;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final v = animation.value;
          return Stack(
            children: [
              Positioned(
                top: _barTop + _barHeight + 4,
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: Container(
                    color: AppColors.backgroundDark.withValues(
                      alpha: 0.55 * v,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: top,
                right: 12,
                width: panelWidth,
                child: Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, -12 * (1 - v)),
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...menuItems.map((item) {
                final active = currentPath == item['route'];
                return InkWell(
                  onTap: () => onNavigate(item['route']!),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['title']!,
                            style: AppText.display(
                              size: 20,
                              weight: FontWeight.w600,
                              letterSpacing: -0.3,
                              color: active
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (active)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.marigold,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onNavigate('/contact'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    iconAlignment: IconAlignment.end,
                    label: const Text('Contact'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    icon: FontAwesomeIcons.linkedinIn,
                    label: 'LinkedIn',
                    onTap: () => _open(profile.linkedInUrl),
                  ),
                  _SocialIcon(
                    icon: FontAwesomeIcons.github,
                    label: 'GitHub',
                    onTap: () => _open(profile.githubUrl),
                  ),
                  _SocialIcon(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email',
                    onTap: () => _open('mailto:${profile.email}'),
                  ),
                  _SocialIcon(
                    icon: FontAwesomeIcons.gamepad,
                    label: 'Play a game',
                    onTap: onShowGame,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Center(
              child: FaIcon(icon, color: AppColors.textSecondary, size: 17),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String route;
  final bool active;

  const _NavItem({
    required this.title,
    required this.route,
    required this.active,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final lit = widget.active || _isHovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () {
          context.go(widget.route);
          context.read<NavigationBloc>().add(NavigateToPage(widget.route));
        },
        onHover: (v) => setState(() => _isHovered = v),
        customBorder: const StadiumBorder(),
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.active
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            widget.title,
            style: AppText.body(
              size: 14.5,
              weight: FontWeight.w500,
              height: 1,
              color: lit ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
