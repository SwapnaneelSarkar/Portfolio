import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/pages/memory_game_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  int _logoClickCount = 0;
  late AnimationController _animationController;
  late Animation<double> _menuAnimation;
  
  final List<Map<String, String>> _menuItems = [
    {'title': 'Home', 'route': '/'},
    {'title': 'Projects', 'route': '/projects'},
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
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              GestureDetector(
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
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentPrimary,
                              AppColors.accentSecondary,
                              AppColors.primaryLight,
                              AppColors.accentTertiary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'SS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
              
              // Navigation
              if (!isMobile)
                Row(
                  children: _menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _NavItem(
                        title: item['title']!,
                        route: item['route']!,
                      ),
                    );
                  }).toList(),
                ),
              
              // Contact button or menu button
              if (!isMobile)
                AnimatedButton(
                  onPressed: () => context.go('/contact'),
                  text: 'Hire Me',
                  isPrimary: true,
                )
              else
                GestureDetector(
                  onTap: _toggleMenu,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isMenuOpen 
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
        
        // Mobile Menu Overlay
        if (isMobile)
          AnimatedBuilder(
            animation: _menuAnimation,
            builder: (context, child) {
              return Positioned(
                top: 80,
                right: 0,
                bottom: 0,
                width: size.width * 0.8,
                child: Transform.translate(
                  offset: Offset(size.width * 0.8 * (1 - _menuAnimation.value), 0),
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...List.generate(_menuItems.length, (index) {
                      final item = _menuItems[index];
                      return ListTile(
                        title: Text(
                          item['title']!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          context.go(item['route']!);
                          context.read<NavigationBloc>().add(NavigateToPage(item['route']!));
                          _toggleMenu();
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
                      onTap: () {
                        context.go('/contact');
                        _toggleMenu();
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSocialIcon(FontAwesomeIcons.linkedin, AppColors.accentPrimary),
                          _buildSocialIcon(FontAwesomeIcons.github, AppColors.accentSecondary),
                          _buildSocialIcon(FontAwesomeIcons.instagram, AppColors.accentTertiary),
                          GestureDetector(
                            onTap: () => _showEasterEgg(context, false),
                            child: _buildSocialIcon(FontAwesomeIcons.gamepad, AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        // Backdrop for mobile menu
        if (_isMenuOpen && isMobile)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
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
      child: Center(
        child: FaIcon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
  
  void _showEasterEgg(BuildContext context, bool isSnakeGame) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => isSnakeGame 
            ? const SnakeGamePage() 
            : const MemoryGamePage(),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String route;
  
  const _NavItem({
    Key? key,
    required this.title,
    required this.route,
  }) : super(key: key);

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
                color: _isHovered ? AppColors.accentPrimary : AppColors.textPrimary,
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
