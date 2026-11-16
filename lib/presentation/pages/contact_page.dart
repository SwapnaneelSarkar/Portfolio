import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/assets.dart';

import '../../services/email_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  bool _isVisible = false;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  
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
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        final success = await EmailService.sendEmail(
          name: _nameController.text,
          email: _emailController.text,
          subject: _subjectController.text,
          message: _messageController.text,
        );
        
        setState(() {
          _isSubmitting = false;
          _isSubmitted = success;
        });
        
        if (success) {
          // Reset form after successful submission
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent successfully!'),
              backgroundColor: AppColors.accentSecondary,
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Please try again.'),
              backgroundColor: AppColors.accentTertiary,
            ),
          );
        }
        
        // Reset submission status after a delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isSubmitted = false;
            });
          }
        });
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AppColors.accentTertiary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 768;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          AnimatedBackground(controller: _backgroundController),
          
          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header
                ContentContainer(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.gutter(size.width),
                    isMobile ? 116 : 150,
                    AppLayout.gutter(size.width),
                    isMobile ? 40 : 56,
                  ),
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const SectionHeader(
                      eyebrow: 'Contact',
                      title: 'Have a project in mind?',
                      description:
                          'Let\'s work together. Send a message and I\'ll get back to you as soon as possible.',
                      large: true,
                    ),
                  ),
                ),

                // Contact Content
                ContentContainer(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.gutter(size.width),
                    0,
                    AppLayout.gutter(size.width),
                    isMobile ? 56 : 88,
                  ),
                  child: isMobile
                      ? Column(
                          children: [
                            _buildContactInfo(textTheme),
                            const SizedBox(height: 60),
                            _buildContactForm(textTheme),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildContactInfo(textTheme),
                            ),
                            const SizedBox(width: 56),
                            Expanded(
                              flex: 3,
                              child: _buildContactForm(textTheme),
                            ),
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
  
  Widget _buildContactInfo(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        final offset = 100 * (1 - _contentController.value);
        
        return Transform.translate(
          offset: Offset(-offset, 0),
          child: Opacity(
            opacity: _contentController.value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact information',
            style: AppText.display(size: 22, weight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          Text(
            'Feel free to reach out to me for any inquiries, project collaborations, freelance opportunities, or just to say hello. I\'m always open to discussing new ideas and challenges.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildContactItem(
            Icons.email,
            'Email',
            'swapnaneel.devwork@gmail.com',
            'mailto:swapnaneel.devwork@gmail.com',
          ),
          const SizedBox(height: 24),
          _buildContactItem(
            Icons.phone,
            'Phone',
            '+91 8967853033',
            'tel:+918967853033',
          ),
          const SizedBox(height: 24),
          _buildContactItem(
            Icons.location_on,
            'Location',
            'Cooch Behar, West Bengal, India',
            'https://maps.google.com/?q=Cooch+Behar',
          ),
          const SizedBox(height: 40),
          Text(
            'ELSEWHERE',
            style: AppText.mono(
              size: 11,
              weight: FontWeight.w600,
              color: AppColors.textFaint,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSocialButton(
                FontAwesomeIcons.linkedin,
                'https://www.linkedin.com/in/swapnaneel-sarkar/',
                AppColors.accentPrimary,
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                FontAwesomeIcons.github,
                'https://github.com/SwapnaneelSarkar',
                AppColors.accentSecondary,
              ),
              const SizedBox(width: 16),
              _buildSocialButton(
                FontAwesomeIcons.instagram,
                'https://www.instagram.com/horcrux.x_x/',
                AppColors.accentTertiary,
              ),
            ],
          ),
          const SizedBox(height: 36),
          _buildResumeDownloadButton(),
        ],
      ),
    );
  }
  
  Widget _buildContactItem(IconData icon, String title, String value, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.marigold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.marigold,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppText.mono(
                    size: 10.5,
                    color: AppColors.textFaint,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppText.body(
                    size: 16,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton(IconData icon, String url, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: AppColors.textSecondary,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildResumeDownloadButton() {
    return ElevatedButton.icon(
      onPressed: () => _launchUrl(Assets.resumeUrl),
      icon: const Icon(Icons.download_rounded, size: 18),
      label: const Text('Download resume'),
    );
  }
  
  Widget _buildContactForm(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        final offset = 100 * (1 - _contentController.value);
        
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Opacity(
            opacity: _contentController.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 600 ? 22 : 34,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message',
              style: AppText.display(size: 22, weight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'I\'ll get back to you as soon as possible',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            if (_isSubmitted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.mint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.mint,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your message has been sent successfully! I\'ll get back to you soon.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.mint,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          // Mobile layout
                          return Column(
                            children: [
                              _buildTextField(
                                controller: _nameController,
                                label: 'Name',
                                hint: 'Enter your name',
                                prefixIcon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Enter your email',
                                prefixIcon: Icons.email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        } else {
                          // Desktop layout
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _nameController,
                                  label: 'Name',
                                  hint: 'Enter your name',
                                  prefixIcon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'Enter your email',
                                  prefixIcon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _subjectController,
                      label: 'Subject',
                      hint: 'Enter subject',
                      prefixIcon: Icons.subject,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      hint: 'Enter your message',
                      prefixIcon: Icons.message,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.backgroundDark,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Send message'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
          label,
          style: AppText.body(size: 14, weight: FontWeight.w600, height: 1.2),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.textFaint,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.backgroundDark.withValues(alpha: 0.7),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.accentPrimary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.beginnerLevel,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.beginnerLevel,
                width: 2,
              ),
            ),
          ),
          style: AppText.body(size: 15, height: 1.4),
          validator: validator,
        ),
      ],
    );
  }
  
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
