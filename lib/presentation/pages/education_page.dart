import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
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
                ContentContainer(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.gutter(size.width),
                    size.width < 700 ? 116 : 150,
                    AppLayout.gutter(size.width),
                    size.width < 700 ? 40 : 64,
                  ),
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const SectionHeader(
                      eyebrow: 'Education',
                      title: 'Academic journey',
                      description:
                          'Computer Science and Business Systems at VIT-AP, plus certifications in problem solving, software engineering, and Flutter.',
                      accent: AppColors.lilac,
                      large: true,
                    ),
                  ),
                ),
                ContentContainer(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.gutter(size.width),
                    0,
                    AppLayout.gutter(size.width),
                    size.width < 700 ? 56 : 88,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Academic background',
                          style: AppText.display(
                            size: 24,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      ..._education.asMap().entries.map((entry) {
                        return _buildEducationCard(
                          entry.value,
                          entry.key,
                          textTheme,
                          size,
                        );
                      }),
                      const SizedBox(height: 40),
                      AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Certifications',
                          style: AppText.display(
                            size: 24,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _buildEducationContent(education, textTheme),
      ),
    );
  }

  Widget _buildEducationContent(
    Map<String, dynamic> education,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 22 : 32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
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
                  style: AppText.display(
                    size: 20,
                    weight: FontWeight.w600,
                    letterSpacing: -0.3,
                    height: 1.25,
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
                  style: AppText.mono(
                    size: 11.5,
                    weight: FontWeight.w600,
                    color: education['color'],
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
            'COURSES',
            style: AppText.mono(
              size: 11,
              weight: FontWeight.w600,
              color: AppColors.textFaint,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (education['courses'] as List<String>)
                .map((course) => TagChip(label: course))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsGrid(TextTheme textTheme, Size size) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        return Opacity(opacity: _contentController.value, child: child);
      },
      child: ResponsiveGrid(
        minCellWidth: 420,
        maxColumns: 2,
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
    final color = certificate['color'] as Color;

    return GlassCard(
      accentColor: color,
      onTap: () => _showCertificateDialog(certificate),
      semanticLabel: '${certificate['title']} certificate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_rounded, color: color, size: 22),
              const Spacer(),
              Text(
                certificate['date'],
                style: AppText.mono(size: 11.5, color: AppColors.textFaint),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            certificate['title'],
            style: AppText.body(size: 18, weight: FontWeight.w600, height: 1.3),
          ),
          const SizedBox(height: 4),
          Text(
            certificate['issuer'],
            style: AppText.mono(size: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            certificate['description'],
            style: textTheme.bodyMedium,
          ),
          const Spacer(),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'View certificate',
                style: AppText.body(
                  size: 14,
                  weight: FontWeight.w600,
                  color: color,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, color: color, size: 15),
            ],
          ),
        ],
      ),
    );
  }

  void _showCertificateDialog(Map<String, dynamic> certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          certificate['title'],
          style: AppText.display(size: 20, weight: FontWeight.w600),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download this certificate to verify credentials.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Not now',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadCertificate(certificate['url']);
            },
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
