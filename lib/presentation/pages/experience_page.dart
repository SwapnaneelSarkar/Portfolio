import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({Key? key}) : super(key: key);

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  bool _isVisible = false;
  
  final List<Map<String, dynamic>> _experiences = [
    {
      'company': 'Laugh Buddha Technologies pvt. Ltd.',
      'position': 'Flutter Developer (Intern)',
      'period': 'April, 2025 - Present',
      'description': 'Sole Flutter developer responsible for end-to-end mobile app development using BLoC architecture and reusable component design. Coordinated closely with UI/UX designers to implement pixel-perfect, responsive interfaces and custom animations. Integrated RESTful APIs and collaborated with the backend team to manage data flow, debug payloads, and support real-time communication (RTC) features. Owned the complete app lifecycle — from feature development and debugging to optimization and cross-platform deployment.',
      'responsibilities': [
        'Developed and maintained mobile applications using Flutter and Dart',
        'Implemented BLoC and used clean architecture',
        'Created reusable UI components for consistent design',
        'Integrated RESTful APIs for data fetching and manipulation',
        'Collaborated with UI/UX designers for pixel-perfect implementation',
        'Implemented custom animations for enhanced user experience',
        'Managed the complete app lifecycle from development to deployment',
      ],
      'color': AppColors.accentPrimary,
      'animation': 'https://assets5.lottiefiles.com/packages/lf20_iorpbol0.json',
    },
    {
    'company': 'Taxian',
    'position': 'Software Developer (Intern)',
    'period': 'March, 2025 - April, 2025',
    'description': 'Developed UI for web applications using Flutter, ensuring seamless user experiences. Integrated APIs for dynamic data flow and implemented notification systems with FCM. Implemented payment gateway integration for secure transactions. Set up CI/CD pipelines for smooth deployment and published app to Play Store. Ensured app efficiency and optimal user experience through performance optimization. Collaborated with backend and DevOps teams to build robust, user-friendly solutions.',
    'responsibilities': [
        'Developed both web and mobile app using Flutter for cross-platform compatibility',
        'Integrated RESTful APIs for data fetching and manipulation',
        'Implemented Firebase Cloud Messaging for notifications',
        'Set up payment gateway integration for secure transactions',
        'Configured CI/CD pipelines for automated testing and deployment',
        'Published and maintained application on Google Play Store',
        'Collaborated with backend and DevOps teams for end-to-end development',
    ],
    'color': AppColors.accentSecondary,
    'animation': 'https://assets9.lottiefiles.com/packages/lf20_w51pcehl.json',
},
    {
      'company': 'Apps AiT',
      'position': 'Flutter Developer (Intern)',
      'period': 'September, 2024 - March, 2025',
      'description': 'Developed real-time mobile applications using Flutter and Firebase, translating Figma designs into user-friendly interfaces. Integrated machine learning models into apps, enabling advanced features and seamless database management. Led the development of a food delivery app with real-time order tracking and backend integration for notifications. Delivered scalable, high-performance solutions by collaborating with cross-functional teams.',
      'responsibilities': [
        'Developed mobile applications using Flutter and Firebase',
        'Translated Figma designs into functional UI components',
        'Integrated machine learning models for advanced features',
        'Led the development of a food delivery application',
        'Implemented real-time order tracking functionality',
        'Set up backend integration for push notifications',
        'Collaborated with cross-functional teams for efficient delivery',
      ],
      'color': AppColors.accentTertiary,
      'animation': 'https://assets3.lottiefiles.com/packages/lf20_v4isjbj5.json',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    // Add post-frame callback to start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
      });
      _contentController.forward();
    });
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(controller: _backgroundController),
          
          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            'My Experience',
                            style: textTheme.displayMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 700),
                          child: SizedBox(
                            height: 50,
                            child: DefaultTextStyle(
                              style: textTheme.headlineSmall!.copyWith(
                                color: AppColors.accentSecondary,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Professional journey',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'Skills in action',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'Career highlights',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Experience Timeline
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: _buildExperienceTimeline(textTheme, size),
                ),
                
                // Footer
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExperienceTimeline(TextTheme textTheme, Size size) {
    final isMobile = size.width < 768;
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _experiences.length,
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == _experiences.length - 1;
        
        return AnimatedBuilder(
          animation: _contentController,
          builder: (context, child) {
            final delay = _contentController.value - (index * 0.2);
            final offset = delay < 0 ? 100.0 : 0.0;
            final opacity = delay < 0 ? 0.0 : 1.0;
            
            return Transform.translate(
              offset: Offset(offset, 0),
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: isFirst,
            isLast: isLast,
            indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: Container(
                decoration: BoxDecoration(
                  color: _experiences[index]['color'],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            beforeLineStyle: LineStyle(
              color: _experiences[index]['color'].withOpacity(0.5),
              thickness: 3,
            ),
            afterLineStyle: LineStyle(
              color: index < _experiences.length - 1 
                  ? _experiences[index + 1]['color'].withOpacity(0.5) 
                  : _experiences[index]['color'].withOpacity(0.5),
              thickness: 3,
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 80),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExperienceContent(_experiences[index], textTheme),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            height: 200,
                            child: Lottie.network(
                              _experiences[index]['animation'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildExperienceContent(_experiences[index], textTheme),
                        ),
                        Expanded(
                          flex: 2,
                          child: Lottie.network(
                            _experiences[index]['animation'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildExperienceContent(Map<String, dynamic> experience, TextTheme textTheme) {
    // Using a completely different approach for the content
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: experience['color'].withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: experience['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(  // Using IntrinsicHeight to ensure the column takes the height of its children
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    experience['company'],
                    style: textTheme.headlineSmall?.copyWith(
                      color: experience['color'],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: experience['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    experience['period'],
                    style: TextStyle(
                      color: experience['color'],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              experience['position'],
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Wrap the description in Flexible to allow it to shrink if needed
            Flexible(
              child: Text(
                experience['description'],
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Key Responsibilities',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.accentSecondary,
              ),
            ),
            const SizedBox(height: 12),
            // Use ListView instead of Column for the responsibilities
            // This ensures the content doesn't overflow
            SizedBox(
              height: 200, // Fixed height for the responsibilities section
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (experience['responsibilities'] as List<String>).length,
                itemBuilder: (context, idx) {
                  final responsibility = experience['responsibilities'][idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: experience['color'],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            responsibility,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}