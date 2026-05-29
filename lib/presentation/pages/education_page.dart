import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portfolio/assets.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  bool _isVisible = false;

  final List<Map<String, dynamic>> _education = [
    {
      'institution': 'Vellore Institute of Technology, Andhra Pradesh (VIT-AP)',
      'degree': 'B.Tech in Computer Science and Business Systems',
      'period': 'September 2022 – May 2026',
      'location': 'Amaravati',
      'description':
          'Pursuing B.Tech in Computer Science and Business Systems with a CGPA of 8.05/10.0.',
      'courses': [
        'Data Structures and Algorithms',
        'Object-Oriented Programming',
        'Database Management Systems',
        'Software Engineering',
        'Web Technologies',
        'Mobile Application Development',
      ],
      'color': AppColors.accentPrimary,
      'animation': Assets.educationAnimation,
    },
    {
      'institution': 'Kendriya Vidyalaya, Cooch Behar',
      'degree': 'Higher Secondary Education',
      'period': 'April 2010 – July 2022',
      'location': 'Cooch Behar, West Bengal',
      'description':
          'Completed higher secondary education with focus on science and mathematics.',
      'courses': [
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'English',
        'Computer Science',
      ],
      'color': AppColors.accentSecondary,
      'animation': Assets.schoolAnimation,
    },
  ];

  final List<Map<String, dynamic>> _certificates = [
    {
      'title': 'Problem Solving',
      'issuer': 'HackerRank',
      'date': 'January 2024',
      'description':
          'Certification for problem-solving skills in algorithms and data structures.',
      'color': AppColors.accentPrimary,
      'url': Assets.certificateUrls['Problem Solving'],
    },
    {
      'title': 'Software Engineer',
      'issuer': 'LinkedIn Learning',
      'date': 'March 2024',
      'description':
          'Comprehensive certification covering software engineering principles and practices.',
      'color': AppColors.accentSecondary,
      'url': Assets.certificateUrls['Software Engineer'],
    },
    {
      'title': 'Flutter & Dart',
      'issuer': 'Udemy',
      'date': 'November 2023',
      'description':
          'Complete Flutter development bootcamp with Dart programming language.',
      'color': AppColors.accentTertiary,
      'url': Assets.certificateUrls['Flutter & Dart'],
    },
    {
      'title': 'Flutter Essentials',
      'issuer': 'Google Developers',
      'date': 'December 2023',
      'description':
          'Essential Flutter development concepts and best practices.',
      'color': AppColors.accentPrimary,
      'url': Assets.certificateUrls['Flutter Essentials'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isVisible = true);
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
        preferredSize: Size.fromHeight(72),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          AnimatedBackground(controller: _backgroundController),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: 280,
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
                      ..._education.asMap().entries.map((entry) {
                        return _buildEducationCard(
                          entry.value,
                          entry.key,
                          textTheme,
                          size,
                        );
                      }),
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
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(
    Map<String, dynamic> education,
    int index,
    TextTheme textTheme,
    Size size,
  ) {
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
          child: Opacity(opacity: opacity, child: child),
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

  Widget _buildEducationContent(
    Map<String, dynamic> education,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (education['color'] as Color).withValues(alpha: 0.2),
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
                  color: (education['color'] as Color).withValues(alpha: 0.1),
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
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: education['color'], size: 16),
              const SizedBox(width: 4),
              Text(
                education['location'],
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(education['description'], style: textTheme.bodyLarge),
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
                  color: (education['color'] as Color).withValues(alpha: 0.1),
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
        return Opacity(opacity: _contentController.value, child: child);
      },
      child: isMobile
          ? Column(
              children: _certificates
                  .map((cert) => _buildCertificateCard(cert, textTheme))
                  .toList(),
            )
          : GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2.0,
              children: _certificates
                  .map((cert) => _buildCertificateCard(cert, textTheme))
                  .toList(),
            ),
    );
  }

  Widget _buildCertificateCard(
    Map<String, dynamic> certificate,
    TextTheme textTheme,
  ) {
    return GestureDetector(
      onTap: () => _showCertificateDialog(certificate),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (certificate['color'] as Color).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: certificate['color'], size: 24),
                const SizedBox(width: 8),
                Flexible(
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
                Flexible(
                  child: Text(
                    certificate['issuer'],
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (certificate['color'] as Color).withValues(alpha: 0.1),
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
            const SizedBox(height: 8),
            Text(
              certificate['description'],
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tap to view',
                  style: TextStyle(
                    color: certificate['color'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.touch_app, color: certificate['color'], size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificateDialog(Map<String, dynamic> certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          certificate['title'],
          style: TextStyle(
            color: certificate['color'],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download this certificate to verify credentials.',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Maybe Later',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadCertificate(certificate['url']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: certificate['color'],
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadCertificate(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch certificate URL: $url');
    }
  }
}
