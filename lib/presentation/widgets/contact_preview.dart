import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:url_launcher/url_launcher.dart';

/// The page's payoff: one bold marigold panel asking for the conversation.
class ContactPreview extends StatelessWidget {
  const ContactPreview({Key? key}) : super(key: key);

  static const Color _ink = AppColors.backgroundDark;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 900;
    final profile = PortfolioContent.profile;

    final pitch = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT',
          style: AppText.mono(
            size: 12,
            weight: FontWeight.w700,
            color: _ink.withValues(alpha: 0.7),
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 18),
        Semantics(
          header: true,
          child: Text(
            'Let\'s build something that ships.',
            style: AppText.display(
              size: isMobile ? 32 : 50,
              weight: FontWeight.w800,
              color: _ink,
              height: 1.05,
              letterSpacing: isMobile ? -1 : -2,
            ),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Hiring for a product role? I\'m happy to walk you through any of '
            'my case studies, products, or how I\'d approach your problem '
            'space. Reach out — I respond fast.',
            style: AppText.body(
              size: isMobile ? 16 : 18,
              color: _ink.withValues(alpha: 0.78),
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _InkButton(
              text: 'Send a message',
              icon: Icons.arrow_forward_rounded,
              filled: true,
              onTap: () => context.go('/contact'),
            ),
            _InkButton(
              text: 'Email me',
              icon: Icons.north_east_rounded,
              filled: false,
              onTap: () => launchUrl(Uri.parse('mailto:${profile.email}')),
            ),
          ],
        ),
      ],
    );

    final facts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (label, value) in [
          ('Open to', 'Product Manager · APM · 0→1 product roles'),
          ('Email', profile.email),
          ('Phone', profile.phone),
        ])
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: _ink.withValues(alpha: 0.16)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppText.mono(
                    size: 10.5,
                    weight: FontWeight.w600,
                    color: _ink.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: AppText.body(
                    size: 16,
                    weight: FontWeight.w600,
                    color: _ink,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return ContentContainer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 28 : 36),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFC566), AppColors.marigold, Color(0xFFFF9A5C)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.marigold.withValues(alpha: 0.22),
              blurRadius: 80,
              offset: const Offset(0, 30),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -120,
              bottom: -160,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _ink.withValues(alpha: 0.08),
                    width: 60,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 28 : 56),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [pitch, const SizedBox(height: 32), facts],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(flex: 7, child: pitch),
                        const SizedBox(width: 56),
                        Expanded(flex: 4, child: facts),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InkButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _InkButton({
    required this.text,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_InkButton> createState() => _InkButtonState();
}

class _InkButtonState extends State<_InkButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    const ink = ContactPreview._ink;
    final fg = widget.filled ? AppColors.textPrimary : ink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _active = v),
        onFocusChange: (v) => setState(() => _active = v),
        customBorder: const StadiumBorder(),
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_active ? const Color(0xFF241D4D) : ink)
                : (_active ? ink.withValues(alpha: 0.08) : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: ink.withValues(alpha: widget.filled ? 1 : 0.35),
              width: _active && !widget.filled ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: AppText.body(
                  size: 15,
                  weight: FontWeight.w600,
                  color: fg,
                  height: 1,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _active ? 12 : 8,
                height: 0,
              ),
              Icon(widget.icon, size: 17, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}
