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

  /// Domain chips shown with emphasis (only for differentiating roles).
  final List<String> domains;
  final Color color;

  const ExperienceEntry({
    required this.company,
    required this.position,
    required this.period,
    this.location = 'Remote',
    required this.description,
    required this.responsibilities,
    this.domains = const [],
    required this.color,
  });
}

/// A vertical/domain the candidate has shipped real products in.
class DomainEntry {
  final String title;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color color;

  const DomainEntry({
    required this.title,
    required this.description,
    required this.tags,
    required this.icon,
    required this.color,
  });
}

/// Shipped products and builds (portfolio projects).
class ProjectEntry {
  final String title;
  final String period;
  final String description;
  final List<String> highlights;
  final List<String> technologies;
  final Color color;

  /// Primary link — live product if it exists, otherwise repo/store.
  final String? projectUrl;

  /// Optional source link shown alongside a live [projectUrl].
  final String? githubUrl;

  const ProjectEntry({
    required this.title,
    required this.period,
    required this.description,
    required this.highlights,
    required this.technologies,
    required this.color,
    this.projectUrl,
    this.githubUrl,
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
  final String logoPath;

  const CaseStudyEntry({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.tags,
    required this.externalUrl,
    required this.color,
    required this.logoPath,
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
        'Technical Product Manager working at the intersection of user problems and engineering — with a specialty most early-career PMs don\'t have: supply chain. At Heizen I\'ve shipped procurement software, supplier management platforms, end-to-end SCM solutions, and AI intelligence layers over supply-chain portals, while managing 15+ client engagements worth \$250k+ across ERP, workforce management, and SaaS. I gather requirements, shape roadmaps, and partner with engineering to take products from 0 to 1.',
    animatedRoles: [
      'Product Manager',
      'Supply Chain & ERP PM',
      'AI Product Builder',
      '0→1 Builder',
    ],
    email: 'swapnaneel.devwork@gmail.com',
    phone: '+91 8967853033',
    location: 'Cooch Behar, West Bengal, India',
    linkedInUrl: 'https://www.linkedin.com/in/swapnaneel-sarkar/',
    githubUrl: 'https://github.com/SwapnaneelSarkar',
  );

  static const impactMetrics = [
    ImpactMetric(value: '\$250k+', label: 'Delivery value in 1 year'),
    ImpactMetric(
      value: '15+',
      label: 'Engagements in SCM, ERP & SaaS',
    ),
    ImpactMetric(
      value: '₹15–30L',
      label: 'Client savings unlocked per year',
    ),
    ImpactMetric(value: '0→1', label: 'AI products shipped, incl. AI-over-SCM'),
  ];

  /// Verticals with real shipped products behind them.
  static const domains = [
    DomainEntry(
      title: 'Supply Chain & Procurement',
      description:
          'Shipped procurement software and supplier management platforms at Heizen — owning discovery with client ops teams, mapping source-to-pay workflows, and delivering end-to-end SCM solutions that replaced spreadsheet-driven operations.',
      tags: [
        'Procurement Workflows',
        'Supplier Management',
        'End-to-End SCM',
        'Vendor Onboarding',
      ],
      icon: Icons.inventory_2_outlined,
      color: AppColors.accentPrimary,
    ),
    DomainEntry(
      title: 'AI on Supply Chain',
      description:
          'Defined and launched AI intelligence layers on top of supply-chain portals — LLM/RAG products that let ops teams query suppliers, orders, and procurement data in plain language instead of digging through dashboards.',
      tags: [
        'LLM / RAG',
        'AI Intelligence Layer',
        '0→1 Launches',
        'SCM Portals',
      ],
      icon: Icons.auto_awesome_outlined,
      color: AppColors.accentSecondary,
    ),
    DomainEntry(
      title: 'ERP & Workforce Ops',
      description:
          'Moved clients off manual and legacy processes onto custom ERP and workforce management platforms — unlocking ₹15–30L/year in operational savings per client.',
      tags: [
        'ERP Migration',
        'Workforce Management',
        'Process Digitization',
        'Cost Reduction',
      ],
      icon: Icons.hub_outlined,
      color: AppColors.accentTertiary,
    ),
    DomainEntry(
      title: 'B2B & B2C SaaS',
      description:
          'Shipped revenue-expanding features on a B2B SaaS platform and led consumer products from quick commerce to healthcare — every spec grounded in user interviews, not assumptions.',
      tags: [
        'Feature Discovery',
        'User Interviews',
        'Monetization',
        'Cross-Platform',
      ],
      icon: Icons.rocket_launch_outlined,
      color: AppColors.accentPrimary,
    ),
  ];

  static const experiences = [
    ExperienceEntry(
      company: 'Heizen',
      position: 'Technical Product Manager',
      period: 'Nov 2025 – Present',
      location: 'Hybrid · Hyderabad · Intern → Full-time (Jul 2026)',
      description:
          'Own product delivery from discovery to launch across 15+ client engagements — with deep work in supply chain: procurement software, supplier management platforms, end-to-end SCM solutions, and AI intelligence layers over supply-chain portals. Converted from TPM intern to full-time in July 2026.',
      responsibilities: [
        'Owned product delivery for procurement software and supplier management platforms — ran discovery with client operations teams, mapped procurement and supplier workflows end-to-end, and shipped sprint-ready specs through launch',
        'Defined and shipped an AI intelligence layer over a client\'s supply-chain portal — an LLM/RAG product that lets ops teams query suppliers, orders, and procurement data in plain language',
        'Took end-to-end SCM solutions from 0 to 1, replacing spreadsheet-driven procurement and supplier tracking with custom-built platforms',
        'Managed 15+ client engagements on concurrent projects, overseeing \$250k+ in total project value within a year',
        'Helped 3+ clients cut ₹15–30 lakhs/year in operational costs by migrating manual and legacy ERP and workforce processes onto custom platforms',
        'Shipped new features on a B2B SaaS platform that expanded the paying client base — identified gaps through user interviews and translated them into sprint-ready specs',
      ],
      domains: ['Supply Chain', 'Procurement', 'ERP', 'SCM × AI'],
      color: AppColors.accentPrimary,
    ),
    ExperienceEntry(
      company: 'Crowdbuzz',
      position: 'Project Manager & App Developer (Freelance)',
      period: 'Apr 2025 – Oct 2025',
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
      period: 'Apr 2025 – Oct 2025',
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
      period: 'Mar 2025 – Apr 2025',
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
      period: 'Sep 2024 – Mar 2025',
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
      title: 'Vorizon',
      period: '2026',
      description:
          'AI Employee Platform — build, train, test, and deploy AI voice agents that handle inbound and outbound business phone calls end-to-end, with usage-based billing at \$0.10/conversation minute.',
      highlights: [
        'Swappable voice engine abstraction — mock for testing, Retell AI for real calls',
        'Telephony compliance built in: TCPA consent tracking, Do-Not-Call enforcement, recording disclosure, audit logs',
        'Production hardening — RBAC, rate limiting, non-blocking campaign workers, automatic usage metering with Razorpay billing',
      ],
      technologies: [
        'React',
        'TypeScript',
        'Node.js',
        'MongoDB',
        'Retell AI',
        'Razorpay',
      ],
      color: AppColors.accentPrimary,
      projectUrl: 'https://vorizon.vercel.app/',
      githubUrl: 'https://github.com/SwapnaneelSarkar/Vorizon',
    ),
    ProjectEntry(
      title: 'MindMark',
      period: '2026',
      description:
          'A PWA that captures a knowledge worker\'s mental context at the moment of interruption and uses AI to generate a re-entry brief when they return — built around capture speed, brief quality, and habit formation.',
      highlights: [
        'Sub-200ms capture panel on a global keyboard shortcut — voice and text, with Groq Whisper fallback',
        'AI re-entry briefs via Llama 3.3 70B that surface your next action first',
        'Offline-first PWA with guest mode, Google OAuth, and a visual focus timeline with recovery metrics',
      ],
      technologies: [
        'Next.js 14',
        'TypeScript',
        'Supabase',
        'Groq',
        'Tailwind CSS',
        'Zustand',
      ],
      color: AppColors.accentSecondary,
      projectUrl: 'https://github.com/SwapnaneelSarkar/MindMark',
    ),
    ProjectEntry(
      title: 'APKMaker',
      period: '2026',
      description:
          'An AI-driven Android application compiler that transforms natural language prompts into production-grade, release-signed Flutter APKs, bypassing local setup entirely.',
      highlights: [
        'Dynamic clarification engine powered by Groq Llama-3.3-70B completion model',
        'NPM workspaces monorepo structure (Next.js 15, NestJS backend, and shared TypeScript spec protocol)',
        'Resilient execution pipelines supporting BullMQ + Redis async tasks with automated memory queue fallback',
      ],
      technologies: [
        'Next.js',
        'NestJS',
        'Flutter',
        'TypeScript',
        'Groq LLM',
        'BullMQ',
        'Supabase',
      ],
      color: AppColors.accentTertiary,
      projectUrl: 'https://github.com/SwapnaneelSarkar/APKmaker',
    ),
    ProjectEntry(
      title: 'PortfolioHub',
      period: '2026',
      description:
          'SaaS portfolio builder for product managers — "prove your judgment, not just your title." Structured case studies with measurable impact, artifact attachments, and public portfolio pages at /p/username.',
      highlights: [
        'Guided PM path that extracts the reasoning behind product decisions',
        'Artifact proof — attach PRDs, strategy decks, and roadmap documents',
        'One-click hosting: SEO-optimized, mobile-responsive public portfolio pages',
      ],
      technologies: [
        'Next.js',
        'TypeScript',
        'Tailwind CSS',
        'Supabase',
        'Vercel',
      ],
      color: AppColors.accentPrimary,
      projectUrl: 'https://port-folio-hub-gray.vercel.app/',
      githubUrl: 'https://github.com/SwapnaneelSarkar/PortFolioHub',
    ),
    ProjectEntry(
      title: 'CodeContext CLI',
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
      color: AppColors.accentSecondary,
      projectUrl: 'https://github.com/SwapnaneelSarkar/codecontext-cli',
    ),
    ProjectEntry(
      title: 'Bird — Quick Commerce',
      period: '2025',
      description:
          'Dual-platform quick commerce app with real-time order tracking, led with a team of four engineers.',
      highlights: [
        'Product roadmap and client discovery',
        'BLoC + FCM + REST real-time tracking',
        'Dual-platform Flutter delivery',
      ],
      technologies: ['Flutter', 'BLoC', 'REST APIs', 'FCM'],
      color: AppColors.accentTertiary,
      projectUrl:
          'https://apps.apple.com/in/app/bird-instant-delivery/id6752969848',
    ),
    ProjectEntry(
      title: 'Grape — Healthcare Platform',
      period: '2025',
      description:
          'Healthcare mobile app with Firebase, maps for nearby care, and an AI symptom assistant.',
      highlights: [
        'Firebase Auth, DB, Storage, FCM',
        'Google Maps for pharmacies and hospitals',
        'AI-assisted symptom tracking',
      ],
      technologies: ['Flutter', 'Firebase', 'Google Maps', 'FCM'],
      color: AppColors.accentPrimary,
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
      externalUrl: 'https://docs.google.com/presentation/d/e/2PACX-1vSBN5S3uvh-EVLk2MFka5U3jb0CJQ3cTVTFCW3kZht8v9dHnaH88DZcAzueaOmnuoiGnwJiuokvDOey/pub?start=false&loop=false&delayms=5000',
      color: AppColors.accentSecondary,
      logoPath: 'assets/images/hitwicket_logo.png',
    ),
    CaseStudyEntry(
      slug: 'rapido',
      title: 'Rapido',
      subtitle: 'Strategic product analysis · Indian urban mobility',
      summary:
          'Rapido found a problem embedded in daily Indian life — from a Bengaluru dorm-room idea in 2015 to a \$1.1B unicorn completing 3.3M rides a day in 2025. This case study examines Rapido\'s journey, structural cracks in its model, and four high-conviction strategic interventions grounded in user behavior, operational economics, and Indian urban mobility.',
      tags: ['Mobility', 'Strategy', 'India', 'Growth'],
      externalUrl: 'https://docs.google.com/presentation/d/e/2PACX-1vQ3rq54jbtTAaNcRm0pveJQcdfR22N87B4uTJIIoX2jqYuA3HTlgcmMuvk350BJvC4yJi0WXoiJ2Gn3/pub?start=false&loop=false&delayms=5000',
      color: AppColors.accentPrimary,
      logoPath: 'assets/images/rapido_logo.png',
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
      name: 'Supply Chain & ERP Domain',
      skills: [
        'Procurement Workflows',
        'Supplier Management',
        'Source-to-Pay',
        'Inventory & Order Flows',
        'ERP Migration',
        'Workforce Management',
        'AI over SCM Portals',
      ],
      icon: Icons.account_tree_outlined,
      color: AppColors.accentSecondary,
    ),
    SkillGroup(
      name: 'Technical',
      skills: [
        'Flutter & Dart',
        'TypeScript',
        'SQL',
        'Python',
        'REST APIs',
        'Firebase',
        'LLM/RAG Products',
        'AI Product Workflows',
        'System Design Basics',
        'Figma',
        'Wireframing',
      ],
      icon: Icons.code,
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
      detail: 'CGPA: 8.19/10.0',
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
