import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

/// Scrollable, width-capped page content with the shared footer.
class PageBody extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;
  final ScrollController? controller;

  const PageBody({
    super.key,
    required this.children,
    this.maxWidth = AppLayout.maxContentWidth,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final gutter = AppLayout.gutter(context);
    final mobile = AppLayout.isMobile(context);
    return SingleChildScrollView(
      controller: controller,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth + gutter * 2),
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, mobile ? 24 : 40, gutter, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...children,
                SizedBox(height: mobile ? 48 : 72),
                const PageFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Page title block: display headline plus one line of context.
class PageHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;

  const PageHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = AppLayout.isMobile(context);
    final titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppText.display(size: mobile ? 32 : 42, color: p.text),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              description!,
              style: AppText.ui(size: 16, color: p.textMuted, height: 1.55),
            ),
          ),
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: mobile ? 28 : 36),
      child: trailing == null || mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titles,
                if (trailing != null) ...[
                  const SizedBox(height: 16),
                  trailing!,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: titles),
                const SizedBox(width: 24),
                trailing!,
              ],
            ),
    );
  }
}

class PageFooter extends StatelessWidget {
  const PageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = AppText.ui(size: 12.5, color: p.textFaint);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('© ${DateTime.now().year} Swapnaneel Sarkar', style: style),
          Text('Designed and built in Flutter', style: style),
          InlineLink(
            '// there is a hidden game somewhere',
            size: 12.5,
            color: p.textFaint,
            onTap: () => context.push('/easter-egg'),
          ),
        ],
      ),
    );
  }
}
