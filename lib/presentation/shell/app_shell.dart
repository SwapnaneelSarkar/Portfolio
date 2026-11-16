import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/blocs/theme/theme_cubit.dart';
import 'package:portfolio/presentation/shell/command_palette.dart';
import 'package:portfolio/presentation/shell/nav.dart';
import 'package:portfolio/presentation/shell/sidebar.dart';
import 'package:portfolio/presentation/shell/top_bar.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/widgets/project_sheet.dart';

/// Persistent app frame: sidebar + main panel on desktop, top bar + drawer +
/// tab bar on smaller screens. Pages swap inside it; the frame never
/// re-animates on navigation.
class AppShell extends StatefulWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _paletteOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.keyK) {
      return false;
    }
    final keys = HardwareKeyboard.instance;
    if (!keys.isMetaPressed && !keys.isControlPressed) return false;
    _openPalette();
    return true;
  }

  Future<void> _openPalette() async {
    if (_paletteOpen || !mounted) return;
    _paletteOpen = true;
    await showCommandPalette(context, commands: _commands());
    _paletteOpen = false;
  }

  void _navigate(String route) {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold?.isDrawerOpen ?? false) scaffold!.closeDrawer();
    context.go(route);
  }

  List<Command> _commands() {
    const profile = PortfolioContent.profile;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      for (final item in Nav.all)
        Command(
          group: 'Go to',
          label: item.label,
          icon: item.icon,
          hint: 'Page',
          keywords: item.route,
          run: () => _navigate(item.route),
        ),
      Command(
        group: 'Actions',
        label: 'Copy email address',
        icon: Icons.content_copy,
        hint: profile.email,
        keywords: 'mail contact',
        run: () => copyEmail(context),
      ),
      const Command(
        group: 'Actions',
        label: 'Download resume (PDF)',
        icon: Icons.file_download_outlined,
        hint: '↗',
        keywords: 'cv pdf',
        run: openResume,
      ),
      Command(
        group: 'Actions',
        label: 'Open LinkedIn',
        icon: FontAwesomeIcons.linkedinIn,
        hint: '↗',
        run: () => openExternal(profile.linkedInUrl),
      ),
      Command(
        group: 'Actions',
        label: 'Open GitHub',
        icon: FontAwesomeIcons.github,
        hint: '↗',
        keywords: 'code source',
        run: () => openExternal(profile.githubUrl),
      ),
      Command(
        group: 'Actions',
        label: dark ? 'Switch to light theme' : 'Switch to dark theme',
        icon: dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        keywords: 'theme mode appearance',
        run: () => context
            .read<ThemeCubit>()
            .toggle(dark ? Brightness.dark : Brightness.light),
      ),
      for (final project in PortfolioContent.projects)
        Command(
          group: 'Projects',
          label: project.title,
          icon: Icons.inventory_2_outlined,
          hint: project.period,
          keywords: '${project.description} ${project.technologies.join(' ')}',
          run: () => showProjectSheet(context, project),
        ),
      for (final study in PortfolioContent.caseStudies)
        Command(
          group: 'Case studies',
          label: study.title,
          icon: Icons.description_outlined,
          hint: 'Case study',
          keywords: '${study.subtitle} ${study.tags.join(' ')}',
          run: () => _navigate('/case-studies/${study.slug}'),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    if (AppLayout.hasSidebar(context)) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: p.frame,
        body: Row(
          children: [
            SizedBox(
              width: AppLayout.sidebarWidth,
              child: Sidebar(
                location: widget.location,
                onSearch: _openPalette,
                onNavigate: _navigate,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: p.isDark ? 0.3 : 0.04,
                        ),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TopBar(
                        location: widget.location,
                        compact: false,
                        onMenu: () {},
                        onSearch: _openPalette,
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: p.surface,
      drawer: Drawer(
        width: 280,
        child: SafeArea(
          child: Sidebar(
            location: widget.location,
            onSearch: () {
              _scaffoldKey.currentState?.closeDrawer();
              _openPalette();
            },
            onNavigate: _navigate,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              location: widget.location,
              compact: true,
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              onSearch: _openPalette,
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
      bottomNavigationBar: AppLayout.isMobile(context)
          ? MobileTabBar(location: widget.location)
          : null,
    );
  }
}
