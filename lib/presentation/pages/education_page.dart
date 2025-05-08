import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  bool _isVisible = false;
  
  final List<Map<String, dynamic>> _education = [
    {
      'institution': 'Vellore Institute of Technology, Andhra Pradesh',
      'degree': 'B. Tech in Computer Science and Business Technology',
      'period': 'September 2022 - Present',
      'location': 'Andhra Pradesh',
      'description': 'Pursuing Bachelors of Technology with a major in Computer Science and Business System with a CGPA of 7.88.',
      'courses': [
        'Data Structures and Algorithms',
        'Object-Oriented Programming',
        'Database Management Systems',
        'Operating Systems',
        'Software Engineering',
        'Web Technologies',
        'Mobile Application Development',
      ],
      'color': AppColors.accentPrimary,
      'animation': 'https://assets9.lottiefiles.com/packages/lf20_q4qbz1wk.json',
    },
    {
      'institution': 'Kendriya Vidyalaya, Cooch Behar',
      'degree': 'Intermediate',
      'period': 'April 2010 - July 2022',
      'location': 'Cooch Behar, West Bengal',
      'description': 'Studied intermediate with Physics, Chemistry, Mathematics and Biology with a percentage of 71.2%.',
      'courses': [
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'English',
        'Computer Science',
      ],
      'color': AppColors.accentSecondary,
      'animation': 'https://assets3.lottiefiles.com/packages/lf20_tfb3estd.json',
    },
  ];
  
  final List<Map<String, dynamic>> _certificates = [
    {
      'title': 'Problem Solving',
      'issuer': 'HackerRank',
      'date': 'January 2024',
      'description': 'Certification for problem-solving skills in algorithms and data structures.',
      'color': AppColors.accentPrimary,
    },
    {
      'title': 'Software Engineer',
      'issuer': 'LinkedIn Learning',
      'date': 'March 2024',
      'description': 'Comprehensive certification covering software engineering principles and practices.',
      'color': AppColors.accentSecondary,
    },
    {
      'title': 'Flutter & Dart',
      'issuer': 'Udemy',
      'date': 'November 2023',
      'description': 'Complete Flutter development bootcamp with Dart programming language.',
      'color': AppColors.accentTertiary,
    },
    {
      'title': 'Flutter Essentials',
      'issuer': 'Google Developers',
      'date': 'December 2023',
      'description': 'Essential Flutter development concepts and best practices.',
      'color': AppColors.accentPrimary,
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
                            'Education',
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
                                    'Academic journey',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'Learning and growth',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'Knowledge foundation',
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
                
                // Education
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Academic Background',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.accentPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ..._education.map((edu) {
                        final index = _education.indexOf(edu);
                        return _buildEducationCard(edu, index, textTheme, size);
                      }).toList(),
                      
                      const SizedBox(height: 80),
                      
                      AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Certifications',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.accentPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildCertificationsGrid(textTheme, size),
                    ],
                  ),
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
  
  Widget _buildEducationCard(Map<String, dynamic> education, int index, TextTheme textTheme, Size size) {
    final isMobile = size.width < 768;
    final isEven = index % 2 == 0;
    
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        final delay = _contentController.value - (index * 0.2);
        final offset = delay < 0 ? 100.0 : 0.0;
        final opacity = delay < 0 ? 0.0 : 1.0;
        
        return Transform.translate(
          offset: Offset(isEven ? -offset : offset, 0),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: isMobile
            ? Column(
                children: [
                  _buildEducationContent(education, textTheme),
                  const SizedBox(height: 30),
                  _buildEducationAnimation(education),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isEven
                    ? [
                        Expanded(
                          flex: 3,
                          child: _buildEducationContent(education, textTheme),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildEducationAnimation(education),
                        ),
                      ]
                    : [
                        Expanded(
                          flex: 2,
                          child: _buildEducationAnimation(education),
                        ),
                        Expanded(
                          flex: 3,
                          child: _buildEducationContent(education, textTheme),
                        ),
                      ],
              ),
      ),
    );
  }
  
  Widget _buildEducationContent(Map<String, dynamic> education, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: education['color'].withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: education['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  education['institution'],
                  style: textTheme.headlineSmall?.copyWith(
                    color: education['color'],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: education['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  education['period'],
                  style: TextStyle(
                    color: education['color'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            education['degree'],
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: education['color'],
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                education['location'],
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            education['description'],
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Courses',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (education['courses'] as List<String>).map((course) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: education['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course,
                  style: TextStyle(
                    color: education['color'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEducationAnimation(Map<String, dynamic> education) {
    return Lottie.network(
      education['animation'],
      fit: BoxFit.contain,
    );
  }
  
  Widget _buildCertificationsGrid(TextTheme textTheme, Size size) {
    final isMobile = size.width < 768;
    
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        return Opacity(
          opacity: _contentController.value,
          child: child,
        );
      },
      child: isMobile
          ? Column(
              children: _certificates.map((cert) {
                return _buildCertificateCard(cert, textTheme);
              }).toList(),
            )
          : GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              children: _certificates.map((cert) {
                return _buildCertificateCard(cert, textTheme);
              }).toList(),
            ),
    );
  }
  
  Widget _buildCertificateCard(Map<String, dynamic> certificate, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: certificate['color'].withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: certificate['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: certificate['color'],
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  certificate['title'],
                  style: textTheme.titleLarge?.copyWith(
                    color: certificate['color'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                certificate['issuer'],
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: certificate['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  certificate['date'],
                  style: TextStyle(
                    color: certificate['color'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            certificate['description'],
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
