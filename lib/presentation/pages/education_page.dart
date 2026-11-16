import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  static const _education = [
    (
      institution: 'Vellore Institute of Technology, Andhra Pradesh (VIT-AP)',
      degree: 'B.Tech in Computer Science and Business Systems',
      period: 'Sep 2022 – May 2026',
      location: 'Amaravati',
      description:
          'Pursuing B.Tech in Computer Science and Business Systems with a CGPA of 8.19/10.0.',
      courses: [
        'Data Structures and Algorithms',
        'Object-Oriented Programming',
        'Database Management Systems',
        'Software Engineering',
        'Web Technologies',
        'Mobile Application Development',
      ],
    ),
    (
      institution: 'Kendriya Vidyalaya, Cooch Behar',
      degree: 'Higher Secondary Education',
      period: 'Apr 2010 – Jul 2022',
      location: 'Cooch Behar, West Bengal',
      description:
          'Completed higher secondary education with focus on science and mathematics.',
      courses: [
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'English',
        'Computer Science',
      ],
    ),
  ];

  static final _certificates = [
    (
      title: 'Problem Solving',
      issuer: 'HackerRank',
      date: 'Jan 2024',
      url: Assets.certificateUrls['Problem Solving'],
    ),
    (
      title: 'Software Engineer',
      issuer: 'LinkedIn Learning',
      date: 'Mar 2024',
      url: Assets.certificateUrls['Software Engineer'],
    ),
    (
      title: 'Flutter & Dart',
      issuer: 'Udemy',
      date: 'Nov 2023',
      url: Assets.certificateUrls['Flutter & Dart'],
    ),
    (
      title: 'Flutter Essentials',
      issuer: 'Google Developers',
      date: 'Dec 2023',
      url: Assets.certificateUrls['Flutter Essentials'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);

    return PageBody(
      children: [
        const PageHeader(
          title: 'Education',
          description: 'Computer Science and Business Systems at VIT-AP, plus '
              'certifications in problem solving, software engineering, and '
              'Flutter.',
        ),
        for (final e in _education)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Panel(
              padding: EdgeInsets.all(mobile ? 16 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: p.tint(p.docs),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(Icons.school_outlined, size: 18, color: p.docs),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.institution,
                              style: AppText.ui(
                                size: 16,
                                weight: FontWeight.w600,
                                color: p.text,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${e.degree} · ${e.location}',
                              style: AppText.ui(size: 13.5, color: p.textMuted),
                            ),
                            if (mobile) ...[
                              const SizedBox(height: 4),
                              Text(
                                e.period,
                                style: AppText.mono(size: 12, color: p.textFaint),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (!mobile) ...[
                        const SizedBox(width: 16),
                        Text(
                          e.period,
                          style: AppText.mono(size: 12, color: p.textFaint),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    e.description,
                    style: AppText.ui(size: 15, color: p.text, height: 1.6),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Relevant coursework',
                    style: AppText.ui(
                      size: 12.5,
                      weight: FontWeight.w500,
                      color: p.textFaint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final c in e.courses) LabelChip(c)],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 32),
        SectionTitle('Certifications', count: '${_certificates.length}'),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < _certificates.length; i++) ...[
                if (i > 0) Divider(height: 1, color: p.border),
                _CertRow(
                  title: _certificates[i].title,
                  issuer: _certificates[i].issuer,
                  date: _certificates[i].date,
                  url: _certificates[i].url,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CertRow extends StatelessWidget {
  final String title;
  final String issuer;
  final String date;
  final String? url;

  const _CertRow({
    required this.title,
    required this.issuer,
    required this.date,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: url == null ? null : () => openExternal(url!),
      isLink: true,
      semanticLabel: url == null
          ? '$title, $issuer, $date'
          : '$title, $issuer, $date. View certificate',
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: s.hovered ? p.sunken : null,
          border: focusOutline(context, s.focused),
        ),
        child: Row(
          children: [
            Icon(Icons.verified_outlined, size: 17, color: p.shipped),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.ui(
                      size: 14,
                      weight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  Text(
                    issuer,
                    style: AppText.ui(size: 13, color: p.textMuted),
                  ),
                ],
              ),
            ),
            Text(date, style: AppText.mono(size: 12, color: p.textFaint)),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: url == null
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'View',
                          style: AppText.ui(
                            size: 13,
                            weight: FontWeight.w500,
                            color: s.hovered ? p.text : p.textMuted,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.north_east, size: 13, color: p.textFaint),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
