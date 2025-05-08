import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/blocs/animation/animation_bloc.dart';
import 'package:portfolio/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/animated_text.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/hero_section.dart';
import 'package:portfolio/presentation/widgets/about_section.dart';
import 'package:portfolio/presentation/widgets/skills_section.dart';
import 'package:portfolio/presentation/widgets/experience_preview.dart';
import 'package:portfolio/presentation/widgets/projects_preview.dart';
import 'package:portfolio/presentation/widgets/contact_preview.dart';
import 'package:portfolio/presentation/widgets/floating_particles.dart';
import 'package:portfolio/presentation/widgets/scroll_indicator.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _heroAnimationController;
  late final AnimationController _backgroundAnimationController;
  late final AnimationController _particlesAnimationController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _heroAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _particlesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    // Start initial animations
    _heroAnimationController.forward();
    
    // Trigger animation events
    context.read<AnimationBloc>().add(const StartAnimation('hero'));
    context.read<AnimationBloc>().add(const StartAnimation('background'));
    context.read<AnimationBloc>().add(const StartAnimation('particles'));
  }
  
  void _onScroll() {
    context.read<ScrollBloc>().add(UpdateScrollPosition(_scrollController.offset));
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _heroAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _particlesAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(controller: _backgroundAnimationController),
          
          // Floating Particles
          FloatingParticles(controller: _particlesAnimationController),
          
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Section
                HeroSection(controller: _heroAnimationController),
                
                // About Section
                const AboutSection(),
                
                // Skills Section
                const SkillsSection(),
                
                // Experience Preview
                const ExperiencePreview(),
                
                // Projects Preview
                const ProjectsPreview(),
                
                // Contact Preview
                const ContactPreview(),
                
                // Footer
                const Footer(),
              ],
            ),
          ),
          
          // Scroll Indicator
          const ScrollIndicator(),
        ],
      ),
    );
  }
}
