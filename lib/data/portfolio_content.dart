import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class ProfileInfo {
  final String name;
  final String title;
  final String summary;
  final List<String> animatedRoles;
  final String email;
  final String phone;
  final String location;
  final String linkedInUrl;
  final String githubUrl;

  const ProfileInfo({
    required this.name,
    required this.title,
    required this.summary,
    required this.animatedRoles,
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedInUrl,
    required this.githubUrl,
  });
}

class ImpactMetric {
  final String value;
  final String label;

  const ImpactMetric({required this.value, required this.label});
}

class ExperienceEntry {
  final String company;
  final String position;
  final String period;
  final String location;
  final String description;
  final List<String> responsibilities;
  final Color color;

  const ExperienceEntry({
    required this.company,
    required this.position,
    required this.period,
    this.location = 'Remote',
    required this.description,
    required this.responsibilities,
    required this.color,
  });
}

/// Shipped products and builds (portfolio projects).
class ProjectEntry {
  final String title;
  final String role;
  final String period;
  final String description;
  final List<String> highlights;
  final List<String> technologies;
  final Color color;
  final String? projectUrl;

  const ProjectEntry({
    required this.title,
    required this.role,
    required this.period,
    required this.description,
    required this.highlights,
    required this.technologies,
    required this.color,
    this.projectUrl,
  });
}

/// Product strategy write-ups hosted externally.
class CaseStudyEntry {
  final String slug;
  final String title;
  final String subtitle;
  final String summary;
  final List<String> tags;
  final String externalUrl;
  final Color color;

  const CaseStudyEntry({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.tags,
    required this.externalUrl,
    required this.color,
  });
}

class SkillGroup {
  final String name;
  final List<String> skills;
  final IconData icon;
  final Color color;

  const SkillGroup({
    required this.name,
    required this.skills,
    required this.icon,
    required this.color,
  });
}

class EducationEntry {
  final String institution;
  final String degree;
  final String period;
  final String location;
  final String? detail;

  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.period,
    required this.location,
    this.detail,
  });
}

class PortfolioContent {
  static const profile = ProfileInfo(
    name: 'Swapnaneel Sarkar',
    title: 'Product Manager',
    summary:
        'Product Manager with hands-on experience across supply chain, ERP, workforce management, and SaaS — including AI-powered and LLM/RAG-based products. I turn messy business problems into clear product bets, own discovery and prioritization, and partner with engineering to ship products that move the needle.',
    animatedRoles: ['Product Manager', 'Product Strategist', '0→1 Builder'],
    email: 'swapnaneel.devwork@gmail.com',
    phone: '+91 8967853033',
    location: 'Cooch Behar, West Bengal, India',
    linkedInUrl: 'https://www.linkedin.com/in/swapnaneel-sarkar/',
    githubUrl: 'https://github.com/SwapnaneelSarkar',
  );

  static const impactMetrics = [
    ImpactMetric(value: '\$150k+', label: 'Project value overseen (6 months)'),
    ImpactMetric(
      value: '10+',
      label: 'Products published incl. enterprise products',
    ),
    ImpactMetric(
      value: 'INR 15–30L',
      label: 'Annual savings unlocked through my product solution',
    ),
    ImpactMetric(value: '0→1', label: 'AI & LLM/RAG products shipped'),
  ];

  static const experiences = [
    ExperienceEntry(
      company: 'Heizen Hybrid',
      position: 'Technical Product Manager Intern',
      period: 'November 2025 – Present',
      location: 'Hyderabad',
      description:
          'Owned product discovery, scope, roadmaps, and delivery for 10+ published products across supply chain, ERP, workforce management, AI, B2C SaaS, and enterprise workflows.',
      responsibilities: [
        'Oversaw \$150k+ in total project value within 6 months',
        'Published 10+ products, including enterprise products, from discovery through release',
        'Designed a product solution projected to save INR 15–30 lakhs/year, then partnered with Heizen engineers to build and ship it',
        'Took multiple products from 0 to 1, including AI-powered and LLM/RAG-based platforms',
        'Shipped B2B SaaS features through user interviews, PRDs, prioritization, and sprint-ready specs',
        'Ran client discovery sessions and turned ambiguous briefs into requirements, wireframes, and release plans',
      ],
      color: AppColors.accentPrimary,
    ),
    ExperienceEntry(
      company: 'Crowdbuzz',
      position: 'Manager',
      period: 'April 2025 – October 2025',
      location: 'Remote · Dubai & UK clients',
      description:
          'Managed three simultaneous client projects end-to-end while coordinating designers and engineers. Primary stakeholders were overseas clients in Dubai and the UK — balancing time zones, delivery cadence, and clear product communication.',
      responsibilities: [
        'Led 3 concurrent projects as manager, from discovery through release',
        'Worked directly with overseas clients in Dubai and the UK on requirements and demos',
        'Translated business objectives into roadmaps, milestones, and technical specifications',
        'Ran Agile ceremonies and sprint planning; maintained on-time delivery across all engagements',
        'Coordinated cross-functional teams and unblocked engineering and design dependencies',
      ],
      color: AppColors.accentSecondary,
    ),
    ExperienceEntry(
      company: 'Meet & More',
      position: 'Flutter Developer Intern',
      period: 'April 2025 – October 2025',
      location: 'Remote',
      description:
          'Developed end-to-end mobile applications using Flutter with BLoC state management and RESTful API integration in an Agile environment.',
      responsibilities: [
        'Built mobile apps with BLoC architecture and RESTful APIs',
        'Implemented real-time chat and Firebase Cloud Messaging notifications',
        'Collaborated with product and design on feature specs and release timelines',
        'Delivered cross-platform features with attention to performance and UX',
      ],
      color: AppColors.accentTertiary,
    ),
    ExperienceEntry(
      company: 'Taxian',
      position: 'Software Engineer Intern',
      period: 'March 2025 – April 2025',
      location: 'Remote',
      description:
          'Developed scalable web and mobile experiences using Flutter, with focus on user experience, payments, and reliable deployment workflows.',
      responsibilities: [
        'Developed cross-platform UI using Flutter for web and mobile',
        'Integrated RESTful APIs and Firebase Cloud Messaging for notifications',
        'Implemented Stripe and PayPal payment gateway flows',
        'Supported CI/CD setup and Play Store publication',
        'Collaborated with backend and DevOps on end-to-end delivery',
      ],
      color: AppColors.accentSecondary,
    ),
    ExperienceEntry(
      company: 'Apps AiT',
      position: 'Android Developer Intern',
      period: 'September 2024 – March 2025',
      location: 'Remote',
      description:
          'Built mobile applications using Flutter and Firebase in an Agile team, translating designs into production-ready features.',
      responsibilities: [
        'Developed mobile applications using Flutter and Firebase',
        'Translated Figma designs into functional, reusable UI components',
        'Integrated machine learning models and managed cloud storage',
        'Contributed to apps that crossed 1,000+ downloads on Google Play Store',
        'Collaborated with cross-functional teams for efficient sprint delivery',
      ],
      color: AppColors.accentTertiary,
    ),
  ];

  static const projects = [
    ProjectEntry(
      title: 'CodeContext CLI',
      role: 'Founder & Product Lead',
      period: '2025',
      description:
          'Open-source CLI that indexes local codebases into compact .ai-context/ bundles for AI coding assistants — per-file summaries, dependency graphs, and agent-ready markdown.',
      highlights: [
        '0→1 MIT-licensed developer tool',
        'Tree-sitter parsing with Ollama default + cloud LLM opt-in',
        'Incremental updates via content-hash manifests',
      ],
      technologies: [
        'TypeScript',
        'Node.js',
        'Tree-sitter',
        'Turborepo',
        'Next.js',
      ],
      color: AppColors.accentPrimary,
      projectUrl: 'https://github.com/SwapnaneelSarkar/codecontext-cli',
    ),
    ProjectEntry(
      title: 'Bird — Quick Commerce',
      role: 'Product Lead & Flutter Developer',
      period: '2025',
      description:
          'Dual-platform quick commerce app with real-time order tracking, led with a team of four engineers.',
      highlights: [
        'Product roadmap and client discovery',
        'BLoC + FCM + REST real-time tracking',
        'Dual-platform Flutter delivery',
      ],
      technologies: ['Flutter', 'BLoC', 'REST APIs', 'FCM'],
      color: AppColors.accentSecondary,
      projectUrl:
          'https://apps.apple.com/in/app/bird-instant-delivery/id6752969848',
    ),
    ProjectEntry(
      title: 'Grape — Healthcare Platform',
      role: 'Flutter Developer',
      period: '2025',
      description:
          'Healthcare mobile app with Firebase, maps for nearby care, and an AI symptom assistant.',
      highlights: [
        'Firebase Auth, DB, Storage, FCM',
        'Google Maps for pharmacies and hospitals',
        'AI-assisted symptom tracking',
      ],
      technologies: ['Flutter', 'Firebase', 'Google Maps', 'FCM'],
      color: AppColors.accentTertiary,
      projectUrl: 'https://github.com/SwapnaneelSarkar/grape',
    ),
  ];

  static const caseStudies = [
    CaseStudyEntry(
      slug: 'hitwicket',
      title: 'HitWicket',
      subtitle: 'Cricket strategy gaming · Product analysis',
      summary:
          'Strategic product analysis of HitWicket — a cricket strategy game built for mobile-first audiences. Examines core loops, monetization, retention mechanics, and growth levers in the sports gaming category.',
      tags: ['Gaming', 'Sports', 'Mobile', 'Strategy'],
      externalUrl: 'https://hitwicket.com',
      color: AppColors.accentSecondary,
    ),
    CaseStudyEntry(
      slug: 'rapido',
      title: 'Rapido',
      subtitle: 'Strategic product analysis · Indian urban mobility',
      summary:
          'Rapido found a problem embedded in daily Indian life — from a Bengaluru dorm-room idea in 2015 to a \$1.1B unicorn completing 3.3M rides a day in 2025. This case study examines Rapido\'s journey, structural cracks in its model, and four high-conviction strategic interventions grounded in user behavior, operational economics, and Indian urban mobility.',
      tags: ['Mobility', 'Strategy', 'India', 'Growth'],
      externalUrl: 'https://test.casestudy.rapido.com',
      color: AppColors.accentPrimary,
    ),
  ];

  static const skillGroups = [
    SkillGroup(
      name: 'Product Management',
      skills: [
        'Agile & Scrum',
        'Roadmap & Prioritization',
        'PRDs & Product Specs',
        'Backlog Management',
        'MVP Definition',
        'Product Discovery',
        'Stakeholder Management',
        'User Stories & Discovery',
        'User Interviews',
        'KPI Definition',
        'Go-to-Market Thinking',
        'Competitive Analysis',
        'Cross-functional Leadership',
      ],
      icon: Icons.lightbulb_outline,
      color: AppColors.accentPrimary,
    ),
    SkillGroup(
      name: 'Technical',
      skills: [
        'Flutter & Dart',
        'BLoC',
        'REST APIs',
        'Firebase',
        'LLM/RAG Products',
        'AI Product Workflows',
        'API Integration',
        'System Design Basics',
        'Figma',
        'Wireframing',
      ],
      icon: Icons.code,
      color: AppColors.accentSecondary,
    ),
    SkillGroup(
      name: 'Languages',
      skills: ['Dart', 'TypeScript', 'C++', 'SQL', 'Swift', 'Python'],
      icon: Icons.terminal,
      color: AppColors.accentTertiary,
    ),
    SkillGroup(
      name: 'Analytics & Delivery',
      skills: [
        'Product Analytics',
        'Funnel Thinking',
        'Release Planning',
        'Sprint Planning',
        'Client Demos',
        'Requirements Gathering',
        'Acceptance Criteria',
      ],
      icon: Icons.insights_outlined,
      color: AppColors.accentPrimary,
    ),
  ];

  static const education = [
    EducationEntry(
      institution: 'VIT-AP University',
      degree: 'B.Tech — Computer Science and Business Systems',
      period: 'September 2022 – May 2026',
      location: 'Amaravati',
      detail: 'CGPA: 8.05/10.0',
    ),
    EducationEntry(
      institution: 'Kendriya Vidyalaya',
      degree: 'Higher Secondary Education',
      period: 'April 2010 – July 2022',
      location: 'Cooch Behar, West Bengal',
    ),
  ];

  static CaseStudyEntry? caseStudyBySlug(String slug) {
    try {
      return caseStudies.firstWhere((c) => c.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
