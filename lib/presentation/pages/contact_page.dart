import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/hiring_panel.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/assets.dart';

import '../../services/email_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final success = await EmailService.sendEmail(
        name: _nameController.text,
        email: _emailController.text,
        subject: _subjectController.text,
        message: _messageController.text,
      );

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isSubmitted = success;
      });

      if (success) {
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: AppColors.accentTertiary,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: AppColors.accentTertiary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Get In Touch',
            subtitle: 'Open to Product Manager roles',
          ),
        ),
        const SizedBox(height: 48),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeInSection(
            child: isMobile
                ? Column(
                    children: [
                      _buildIntro(textTheme),
                      const SizedBox(height: 32),
                      const HiringPanel(),
                      const SizedBox(height: 32),
                      _buildContactForm(textTheme),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntro(textTheme),
                            const SizedBox(height: 32),
                            const HiringPanel(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(flex: 3, child: _buildContactForm(textTheme)),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildIntro(TextTheme textTheme) {
    final profile = PortfolioContent.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hiring for a product role?', style: textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          'I\'m happy to walk you through my case studies — supply-chain and ERP platforms at Heizen, 0→1 AI launches — or how I\'d approach your problem space. I respond within 24 hours.',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textBody),
        ),
        const SizedBox(height: 28),
        _contactItem(
          Icons.email_outlined,
          'EMAIL',
          profile.email,
          'mailto:${profile.email}',
        ),
        const SizedBox(height: 16),
        _contactItem(
          Icons.phone_outlined,
          'PHONE',
          profile.phone,
          'tel:+918967853033',
        ),
        const SizedBox(height: 16),
        _contactItem(
          Icons.location_on_outlined,
          'LOCATION',
          profile.location,
          null,
        ),
        const SizedBox(height: 28),
        TextButton.icon(
          onPressed: () => launchUrl(
            Uri.parse(Assets.resumeUrl),
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.download_outlined, size: 18),
          label: const Text('Download Resume'),
        ),
      ],
    );
  }

  Widget _contactItem(
    IconData icon,
    String title,
    String value,
    String? url,
  ) {
    final row = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.accentPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accentPrimary.withValues(alpha: 0.25),
            ),
          ),
          child: Icon(icon, color: AppColors.accentPrimary, size: 19),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.mono(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (url == null) return row;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        ),
        child: row,
      ),
    );
  }

  Widget _buildContactForm(TextTheme textTheme) {
    return GlassCard(
      accentColor: AppColors.accentPrimary,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send me a message', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'I\'ll get back to you as soon as possible.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          if (_isSubmitted)
            _buildSuccessCard(textTheme)
          else
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 600;
                    final name = _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Your name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your name'
                          : null,
                    );
                    final email = _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@company.com',
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    );
                    if (narrow) {
                      return Column(
                        children: [name, const SizedBox(height: 20), email],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: name),
                        const SizedBox(width: 16),
                        Expanded(child: email),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _subjectController,
                    label: 'Subject',
                    hint: 'What\'s this about?',
                    prefixIcon: Icons.subject,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a subject'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _messageController,
                    label: 'Message',
                    hint: 'Tell me about the role or the problem space',
                    prefixIcon: Icons.message_outlined,
                    maxLines: 5,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your message'
                        : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: _GradientSubmitButton(
                      isSubmitting: _isSubmitting,
                      onPressed: _isSubmitting ? null : _submitForm,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'TYPICAL RESPONSE < 24H',
                      style: AppFonts.mono(
                        fontSize: 10,
                        color: AppColors.accentSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: AppColors.accentPrimary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Message sent — I\'ll get back to you within 24 hours.',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _isSubmitted = false),
            child: const Text('Send another message'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppFonts.mono(
            fontSize: 10,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            prefixIcon: maxLines == 1
                ? Icon(prefixIcon, color: AppColors.textSecondary, size: 19)
                : null,
            filled: true,
            fillColor: AppColors.backgroundDark.withValues(alpha: 0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.accentPrimary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryRedLight,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryRedLight,
                width: 1.5,
              ),
            ),
          ),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          validator: validator,
        ),
      ],
    );
  }
}

class _GradientSubmitButton extends StatefulWidget {
  final bool isSubmitting;
  final VoidCallback? onPressed;

  const _GradientSubmitButton({
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  State<_GradientSubmitButton> createState() => _GradientSubmitButtonState();
}

class _GradientSubmitButtonState extends State<_GradientSubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !widget.isSubmitting
                ? [
                    BoxShadow(
                      color: AppColors.accentPrimary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Center(
            child: widget.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Color(0xFF041018),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Color(0xFF041018),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
