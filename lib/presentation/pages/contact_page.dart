import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/shell/nav.dart';
import 'package:portfolio/presentation/ui/actions.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

import '../../services/email_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

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
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    var success = false;
    try {
      success = await EmailService.sendEmail(
        name: _nameController.text,
        email: _emailController.text,
        subject: _subjectController.text,
        message: _messageController.text,
      );
    } catch (_) {
      success = false;
    }

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
          content: Text(
            'Your message didn\'t send. Check your connection and try again, '
            'or email me directly.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        const PageHeader(
          title: 'Contact',
          description: 'Open to Product Manager roles. Messages land in my '
              'inbox, and I reply within 24 hours.',
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final composer = _buildComposer(context, constraints.maxWidth);
            if (constraints.maxWidth < 860) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [composer, const SizedBox(height: 24), const _Side()],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: composer),
                const SizedBox(width: 32),
                const SizedBox(width: 300, child: _Side()),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildComposer(BuildContext context, double width) {
    final p = context.palette;
    const profile = PortfolioContent.profile;
    final narrow = width < 560;

    final header = Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: p.sunken,
      child: Row(
        children: [
          Icon(Icons.edit_outlined, size: 15, color: p.textMuted),
          const SizedBox(width: 10),
          Text(
            _isSubmitted ? 'Message sent' : 'New message',
            style: AppText.ui(size: 13.5, weight: FontWeight.w600, color: p.text),
          ),
        ],
      ),
    );

    if (_isSubmitted) {
      return Panel(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              Divider(height: 1, color: p.border),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusIcon(StatusKind.shipped, size: 22),
                    const SizedBox(height: 14),
                    Text(
                      'Thanks, your message is in my inbox.',
                      style: AppText.ui(
                        size: 17,
                        weight: FontWeight.w600,
                        color: p.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'I\'ll reply within 24 hours.',
                      style: AppText.ui(size: 15, color: p.textMuted),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton(
                      onPressed: () => setState(() => _isSubmitted = false),
                      child: const Text('Write another message'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget row(String label, Widget field) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 68,
                child: Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Text(
                    label,
                    style: AppText.ui(size: 13.5, color: p.textFaint),
                  ),
                ),
              ),
              Expanded(child: field),
            ],
          ),
        );

    final name = _field(
      controller: _nameController,
      hint: 'Your name',
      autofill: AutofillHints.name,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Add your name' : null,
    );
    final email = _field(
      controller: _emailController,
      hint: 'you@company.com',
      autofill: AutofillHints.email,
      keyboard: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Add your email address';
        if (!RegExp(r'^[\w\-\.+]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
          return 'That email address doesn\'t look right';
        }
        return null;
      },
    );

    final divider = Divider(height: 1, color: p.border);

    return Panel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                _submitForm,
            const SingleActivator(LogicalKeyboardKey.enter, control: true):
                _submitForm,
          },
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  divider,
                  row(
                    'To',
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(4, 3, 10, 3),
                          decoration: BoxDecoration(
                            color: p.sunken,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: p.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Avatar(size: 20, radius: 10),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  narrow
                                      ? profile.name
                                      : '${profile.name}  <${profile.email}>',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.ui(size: 13, color: p.text),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  divider,
                  if (narrow) ...[
                    row('Name', name),
                    divider,
                    row('Email', email),
                  ] else
                    row(
                      'From',
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: name),
                          Container(
                            width: 1,
                            height: 24,
                            margin: const EdgeInsets.fromLTRB(8, 10, 12, 0),
                            color: p.border,
                          ),
                          Expanded(child: email),
                        ],
                      ),
                    ),
                  divider,
                  row(
                    'Subject',
                    _field(
                      controller: _subjectController,
                      hint: 'What\'s this about?',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Add a subject'
                          : null,
                    ),
                  ),
                  divider,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _field(
                      controller: _messageController,
                      hint: 'Tell me about the role or the problem space…',
                      minLines: 8,
                      maxLines: 16,
                      keyboard: TextInputType.multiline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Write a message'
                          : null,
                    ),
                  ),
                  divider,
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        FilledButton.icon(
                          onPressed: _isSubmitting ? null : _submitForm,
                          icon: _isSubmitting
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: p.onPrimary,
                                  ),
                                )
                              : const Icon(Icons.send_outlined, size: 15),
                          label: Text(_isSubmitting ? 'Sending…' : 'Send message'),
                        ),
                        if (!AppLayout.isMobile(context)) ...[
                          const SizedBox(width: 12),
                          Kbd(Nav.isApple ? '⌘ ↵' : 'Ctrl ↵'),
                          const SizedBox(width: 6),
                          Text(
                            'to send',
                            style: AppText.ui(size: 12, color: p.textFaint),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          'Replies within 24 hours',
                          style: AppText.ui(size: 12.5, color: p.textFaint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? autofill,
    TextInputType? keyboard,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final p = context.palette;
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboard,
      autofillHints: autofill == null ? null : [autofill],
      validator: validator,
      style: AppText.ui(size: 14.5, color: p.text, height: 1.5),
      decoration: InputDecoration(
        filled: false,
        hintText: hint,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const profile = PortfolioContent.profile;

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            text,
            style: AppText.ui(size: 13, weight: FontWeight.w600, color: p.text),
          ),
        );

    Widget line(IconData icon, String label, VoidCallback? onTap,
        {Widget? trailing}) {
      return SizedBox(
        height: 34,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: onTap == null
                    ? Row(
                        children: [
                          Icon(icon, size: 14.5, color: p.textMuted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.ui(
                                size: 13.5,
                                weight: FontWeight.w500,
                                color: p.textMuted,
                              ),
                            ),
                          ),
                        ],
                      )
                    : InlineLink(label, icon: icon, onTap: onTap),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Panel(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading('Other ways to reach me'),
              line(
                Icons.mail_outline,
                profile.email,
                () => openExternal('mailto:${profile.email}'),
                trailing: IconButton(
                  onPressed: () => copyEmail(context),
                  tooltip: 'Copy email address',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.content_copy, size: 14),
                ),
              ),
              line(
                Icons.phone_outlined,
                profile.phone,
                () => openExternal('tel:${profile.phone.replaceAll(' ', '')}'),
              ),
              line(
                FontAwesomeIcons.linkedinIn,
                'LinkedIn',
                () => openExternal(profile.linkedInUrl),
              ),
              line(Icons.place_outlined, profile.location, null),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Dot(p.shipped, size: 7),
                  const SizedBox(width: 9),
                  Text(
                    'Currently open to',
                    style: AppText.ui(
                      size: 13,
                      weight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Product Manager, APM and 0→1 product roles',
                style: AppText.ui(
                  size: 15,
                  weight: FontWeight.w600,
                  color: p.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Supply chain, ERP and AI products a specialty. Full-time, '
                'hybrid or remote. Available now.',
                style: AppText.ui(size: 13.5, color: p.textMuted, height: 1.55),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: openResume,
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Download resume'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
