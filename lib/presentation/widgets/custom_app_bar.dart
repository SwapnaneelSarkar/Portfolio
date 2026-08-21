import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    {'title': 'Case Studies', 'route': '/case-studies'},
    {'title': 'Experience', 'route': '/experience'},
    {'title': 'Education', 'route': '/education'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _menuAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _menuOverlay?.remove();
    _animationController.dispose();
    super.dispose();
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

    // Capture here: the overlay lives above the route subtree, where
    // GoRouterState.of would throw.
    final currentLocation = GoRouterState.of(context).uri.path;

    _menuOverlay = OverlayEntry(
      builder:
          (context) => _CompactMenuOverlay(
            animation: _menuAnimation,
            menuItems: _menuItems,
            currentLocation: currentLocation,
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
            buildSocialIcon: _buildSocialIcon,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 1080;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        // Main App Bar — frosted glass with a hairline bottom border.
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.6),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          child: Row(
            children: [
              // Logo
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    context.go('/');

                    // Easter egg trigger - click logo 5 times
                    setState(() {
                      _logoClickCount++;
                      if (_logoClickCount >= 5) {
                        _logoClickCount = 0;
                        _showEasterEgg(context, true);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accentPrimary.withOpacity(0.35),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Transform.scale(
                            scale: 1.5,
                            child: Image.asset(
                            Assets.avatar,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.05),
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.textPrimary,
                                  size: 22,
                                ),
                              );
                            },
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (!isMobile)
                        const Text(
                          'Swapnaneel Sarkar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (!isCompact)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          _menuItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: _NavItem(
                                title: item['title']!,
                                route: item['route']!,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              if (!isCompact) const SizedBox(width: 16),
              if (!isCompact) ...[
                AnimatedButton(
                  onPressed: () => _launchResume(),
                  text: 'Resume',
                  isPrimary: false,
                ),
                const SizedBox(width: 12),
                AnimatedButton(
                  onPressed: () => context.go('/contact'),
                  text: 'Contact',
                  isPrimary: true,
                ),
              ] else ...[
                // Keep the conversion CTA visible down to phone widths.
                if (size.width >= 600) ...[
                  AnimatedButton(
                    onPressed: () => context.go('/contact'),
                    text: 'Contact',
                    isPrimary: true,
                  ),
                  const SizedBox(width: 12),
                ],
                GestureDetector(
                  onTap: _toggleMenu,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          _isMenuOpen
                              ? AppColors.accentPrimary.withOpacity(0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: _isMenuOpen ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.menu,
                            color: AppColors.textPrimary,
                            size: 28,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _isMenuOpen ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.accentPrimary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchResume() async {
    final uri = Uri.parse(Assets.resumeUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: FaIcon(icon, color: color, size: 20)),
    );
  }

  void _showEasterEgg(BuildContext context, bool isSnakeGame) {
    context.push(isSnakeGame ? '/easter-egg' : '/memory');
  }
}

class _CompactMenuOverlay extends StatelessWidget {
  final Animation<double> animation;
  final List<Map<String, String>> menuItems;
  final String currentLocation;
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;
  final VoidCallback onShowGame;
  final Widget Function(IconData icon, Color color) buildSocialIcon;

  const _CompactMenuOverlay({
    required this.animation,
    required this.menuItems,
    required this.currentLocation,
    required this.onClose,
    required this.onNavigate,
    required this.onShowGame,
    required this.buildSocialIcon,
  });

  void _openUrl(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width < 520 ? size.width * 0.82 : 420.0;
    final location = currentLocation;
    final profile = PortfolioContent.profile;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 72,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                top: 72,
                right: 0,
                bottom: 0,
                width: panelWidth,
                child: Transform.translate(
                  offset: Offset(panelWidth * (1 - animation.value), 0),
                  child: child,
                ),
              );
            },
            child: ClipRect(
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark.withOpacity(0.98),
                    border: Border(
                      left: BorderSide(
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nav list scrolls on short viewports; the CTA and
                        // socials stay pinned below.
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 28, 30, 12),
                          child: Text(
                            'NAVIGATE',
                            style: AppFonts.mono(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        ...menuItems.map((item) {
                          final route = item['route']!;
                          final active = route == '/'
                              ? location == '/'
                              : location.startsWith(route);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            child: Material(
                              color: active
                                  ? AppColors.accentPrimary
                                      .withOpacity(0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => onNavigate(route),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 13,
                                  ),
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                            milliseconds: 200),
                                        width: 3,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          gradient: active
                                              ? const LinearGradient(
                                                  begin:
                                                      Alignment.topCenter,
                                                  end: Alignment
                                                      .bottomCenter,
                                                  colors: AppColors
                                                      .primaryGradient,
                                                )
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Text(
                                        item['title']!,
                                        style: TextStyle(
                                          color: active
                                              ? AppColors.accentPrimary
                                              : AppColors.textPrimary,
                                          fontSize: 17,
                                          fontWeight: active
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _openUrl(Assets.resumeUrl),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 17),
                                    const Icon(
                                      Icons.download_outlined,
                                      size: 18,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Resume',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30, 0, 30, 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: AnimatedButton(
                              onPressed: () => onNavigate('/contact'),
                              text: 'Hire Me',
                              isPrimary: true,
                              trailingIcon: Icons.arrow_forward_rounded,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30, 0, 30, 30),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _openUrl(profile.linkedInUrl),
                                child: buildSocialIcon(
                                  FontAwesomeIcons.linkedin,
                                  AppColors.accentPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _openUrl(profile.githubUrl),
                                child: buildSocialIcon(
                                  FontAwesomeIcons.github,
                                  AppColors.accentSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _openUrl('mailto:${profile.email}'),
                                child: buildSocialIcon(
                                  FontAwesomeIcons.envelope,
                                  AppColors.accentTertiary,
                                ),
                              ),
                              GestureDetector(
                                onTap: onShowGame,
                                child: buildSocialIcon(
                                  FontAwesomeIcons.gamepad,
                                  AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String route;

  const _NavItem({Key? key, required this.title, required this.route})
    : super(key: key);

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  bool _isActive(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (widget.route == '/') return location == '/';
    return location.startsWith(widget.route);
  }

  @override
  Widget build(BuildContext context) {
    final active = _isActive(context);
    final highlighted = _isHovered || active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          context.go(widget.route);
          context.read<NavigationBloc>().add(NavigateToPage(widget.route));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                color:
                    highlighted
                        ? AppColors.accentPrimary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: highlighted ? 20 : 0,
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
