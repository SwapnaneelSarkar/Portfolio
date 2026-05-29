import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/presentation/blocs/animation/animation_bloc.dart';
import 'package:portfolio/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/hero_section.dart';
import 'package:portfolio/presentation/widgets/about_section.dart';
import 'package:portfolio/presentation/widgets/skills_section.dart';
import 'package:portfolio/presentation/widgets/experience_preview.dart';
import 'package:portfolio/presentation/widgets/projects_preview.dart';
import 'package:portfolio/presentation/widgets/case_studies_preview.dart';
import 'package:portfolio/presentation/widgets/contact_preview.dart';
import 'package:portfolio/presentation/widgets/scroll_indicator.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _heroAnimationController;
  late final AnimationController _backgroundAnimationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    _heroAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    context.read<AnimationBloc>().add(const StartAnimation('hero'));
    context.read<AnimationBloc>().add(const StartAnimation('background'));
  }

  void _onScroll() {
    context.read<ScrollBloc>().add(UpdateScrollPosition(_scrollController.offset));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroAnimationController.dispose();
    _backgroundAnimationController.dispose();
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
          AnimatedBackground(controller: _backgroundAnimationController),
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(controller: _heroAnimationController),
                const FadeInSection(
                  delay: Duration(milliseconds: 100),
                  child: AboutSection(),
                ),
                const FadeInSection(
                  delay: Duration(milliseconds: 200),
                  child: SkillsSection(),
                ),
                const FadeInSection(
                  delay: Duration(milliseconds: 300),
                  child: ExperiencePreview(),
                ),
                const FadeInSection(
                  delay: Duration(milliseconds: 400),
                  child: ProjectsPreview(),
                ),
                const FadeInSection(
                  delay: Duration(milliseconds: 500),
                  child: CaseStudiesPreview(),
                ),
                const FadeInSection(
                  delay: Duration(milliseconds: 600),
                  child: ContactPreview(),
                ),
                const Footer(),
              ],
            ),
          ),
          const ScrollIndicator(),
        ],
      ),
    );
  }
}
