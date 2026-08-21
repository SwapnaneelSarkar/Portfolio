import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/scroll_progress_bar.dart';

/// Shared layout: aurora background + frosted nav + scroll progress bar.
class PageScaffold extends StatefulWidget {
  final List<Widget> children;
  final bool showFooter;

  const PageScaffold({
    super.key,
    required this.children,
    this.showFooter = true,
  });

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          AnimatedBackground(controller: _bgController),
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 120),
                ...widget.children,
                const SizedBox(height: 40),
                if (widget.showFooter) const Footer(),
              ],
            ),
          ),
          Positioned(
            top: 72,
            left: 0,
            right: 0,
            child: ScrollProgressBar(controller: _scrollController),
          ),
        ],
      ),
    );
  }
}
