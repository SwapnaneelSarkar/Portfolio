import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/pages/memory_game_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    {'title': 'Contact', 'route': '/contact'},
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

    _menuOverlay = OverlayEntry(
      builder:
          (context) => _CompactMenuOverlay(
            animation: _menuAnimation,
            menuItems: _menuItems,
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
    final isCompact = size.width < 1360;
    final isMobile = size.width < 768;

    return Stack(
      children: [
        // Main App Bar
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
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
                          child: Image.asset(
                            Assets.avatar,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.2),
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
              if (!isCompact)
                AnimatedButton(
                  onPressed: () => context.go('/contact'),
                  text: 'Contact',
                  isPrimary: true,
                )
              else
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
          ),
        ),
      ],
    );
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                isSnakeGame ? const SnakeGamePage() : const MemoryGamePage(),
      ),
    );
  }
}

class _CompactMenuOverlay extends StatelessWidget {
  final Animation<double> animation;
  final List<Map<String, String>> menuItems;
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;
  final VoidCallback onShowGame;
  final Widget Function(IconData icon, Color color) buildSocialIcon;

  const _CompactMenuOverlay({
    required this.animation,
    required this.menuItems,
    required this.onClose,
    required this.onNavigate,
    required this.onShowGame,
    required this.buildSocialIcon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width < 520 ? size.width * 0.82 : 420.0;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 80,
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
                top: 80,
                right: 0,
                bottom: 0,
                width: panelWidth,
                child: Transform.translate(
                  offset: Offset(panelWidth * (1 - animation.value), 0),
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(-10, 0),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...menuItems.map((item) {
                      return ListTile(
                        title: Text(
                          item['title']!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => onNavigate(item['route']!),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      );
                    }),
                    const Divider(
                      color: AppColors.textSecondary,
                      thickness: 0.5,
                      indent: 30,
                      endIndent: 30,
                    ),
                    ListTile(
                      title: const Text(
                        'Hire Me',
                        style: TextStyle(
                          color: AppColors.accentPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: const Icon(
                        Icons.work_outline,
                        color: AppColors.accentPrimary,
                      ),
                      onTap: () => onNavigate('/contact'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildSocialIcon(
                            FontAwesomeIcons.linkedin,
                            AppColors.accentPrimary,
                          ),
                          buildSocialIcon(
                            FontAwesomeIcons.github,
                            AppColors.accentSecondary,
                          ),
                          buildSocialIcon(
                            FontAwesomeIcons.instagram,
                            AppColors.accentTertiary,
                          ),
                          GestureDetector(
                            onTap: onShowGame,
                            child: buildSocialIcon(
                              FontAwesomeIcons.gamepad,
                              AppColors.primaryLight,
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
                fontSize: 16,
                fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                color:
                    _isHovered
                        ? AppColors.accentPrimary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _isHovered ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColors.accentPrimary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
