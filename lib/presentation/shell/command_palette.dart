import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/ui/primitives.dart';

class Command {
  final String group;
  final String label;
  final IconData icon;
  final String? hint;
  final String keywords;
  final VoidCallback run;

  const Command({
    required this.group,
    required this.label,
    required this.icon,
    required this.run,
    this.hint,
    this.keywords = '',
  });

  bool matches(List<String> terms) {
    final haystack = '$label $group $keywords'.toLowerCase();
    return terms.every(haystack.contains);
  }
}

/// ⌘K palette: type to filter, arrows to move, Enter to run.
Future<void> showCommandPalette(
  BuildContext context, {
  required List<Command> commands,
}) {
  final reduceMotion = MediaQuery.of(context).disableAnimations;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close search',
    barrierColor: Colors.black.withValues(alpha: 0.32),
    transitionDuration: Duration(milliseconds: reduceMotion ? 0 : 140),
    pageBuilder: (context, _, __) => _Palette(commands: commands),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
          alignment: Alignment.topCenter,
          child: child,
        ),
      );
    },
  );
}

const double _rowHeight = 40;
const double _groupHeight = 30;

class _Palette extends StatefulWidget {
  final List<Command> commands;

  const _Palette({required this.commands});

  @override
  State<_Palette> createState() => _PaletteState();
}

class _PaletteState extends State<_Palette> {
  final _query = TextEditingController();
  final _scroll = ScrollController();
  int _index = 0;

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<Command> get _results {
    final terms = _query.text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (terms.isEmpty) return widget.commands;
    return widget.commands.where((c) => c.matches(terms)).toList();
  }

  void _move(int delta) {
    final n = _results.length;
    if (n == 0) return;
    // Dart's % is Euclidean, so -1 wraps to the last row.
    setState(() => _index = (_index + delta) % n);
    _reveal();
  }

  /// Keeps the highlighted row inside the scroll viewport.
  void _reveal() {
    if (!_scroll.hasClients) return;
    final results = _results;
    var top = 6.0;
    String? group;
    for (var i = 0; i <= _index && i < results.length; i++) {
      if (results[i].group != group) {
        group = results[i].group;
        top += _groupHeight;
      }
      if (i < _index) top += _rowHeight;
    }
    final view = _scroll.position.viewportDimension;
    final offset = _scroll.offset;
    if (top - _groupHeight < offset) {
      _scroll.jumpTo((top - _groupHeight).clamp(0, _scroll.position.maxScrollExtent));
    } else if (top + _rowHeight > offset + view) {
      _scroll.jumpTo(
        (top + _rowHeight - view + 6).clamp(0, _scroll.position.maxScrollExtent),
      );
    }
  }

  void _run(Command command) {
    Navigator.of(context).pop();
    command.run();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = MediaQuery.sizeOf(context);
    final mobile = AppLayout.isMobile(context);
    final results = _results;
    if (_index >= results.length) _index = 0;

    final rows = <Widget>[];
    String? group;
    for (var i = 0; i < results.length; i++) {
      final c = results[i];
      if (c.group != group) {
        group = c.group;
        rows.add(
          SizedBox(
            height: _groupHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                c.group,
                style: AppText.ui(
                  size: 12,
                  weight: FontWeight.w500,
                  color: p.textFaint,
                ),
              ),
            ),
          ),
        );
      }
      rows.add(
        _ResultRow(
          command: c,
          selected: i == _index,
          onHover: () => setState(() => _index = i),
          onTap: () => _run(c),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          mobile ? 12 : size.height * 0.12,
          12,
          12,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: (size.height * 0.72).clamp(240, 480),
          ),
          child: Material(
            color: p.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: p.borderStrong),
            ),
            elevation: 24,
            shadowColor: Colors.black.withValues(alpha: 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                        _move(1),
                    const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                        _move(-1),
                    const SingleActivator(LogicalKeyboardKey.escape): () =>
                        Navigator.of(context).pop(),
                  },
                  child: TextField(
                    controller: _query,
                    autofocus: true,
                    onChanged: (_) => setState(() => _index = 0),
                    onSubmitted: (_) {
                      if (results.isNotEmpty) _run(results[_index]);
                    },
                    style: AppText.ui(size: 15, color: p.text),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: 'Search pages, projects, case studies…',
                      prefixIcon: Icon(Icons.search, color: p.textFaint),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, color: p.border),
                Flexible(
                  child: results.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(28),
                          child: Text(
                            'Nothing matches “${_query.text.trim()}”. Try a '
                            'project name, “resume” or “email”.',
                            textAlign: TextAlign.center,
                            style: AppText.ui(size: 14, color: p.textMuted),
                          ),
                        )
                      : ListView(
                          controller: _scroll,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 6),
                          children: rows,
                        ),
                ),
                if (!mobile) ...[
                  Divider(height: 1, color: p.border),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    child: Row(
                      children: [
                        _hint(context, '↑↓', 'to move'),
                        const SizedBox(width: 16),
                        _hint(context, '↵', 'to open'),
                        const SizedBox(width: 16),
                        _hint(context, 'esc', 'to close'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hint(BuildContext context, String key, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Kbd(key),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppText.ui(size: 12, color: context.palette.textFaint),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final Command command;
  final bool selected;
  final VoidCallback onHover;
  final VoidCallback onTap;

  const _ResultRow({
    required this.command,
    required this.selected,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    // onHover, not onEnter: rows appearing under a resting cursor shouldn't
    // steal the keyboard selection; only real mouse movement should.
    return MouseRegion(
      onHover: (_) {
        if (!selected) onHover();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: _rowHeight,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? p.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              Icon(
                command.icon,
                size: 16,
                color: selected ? p.text : p.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  command.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.ui(
                    size: 14,
                    weight: FontWeight.w500,
                    color: p.text,
                  ),
                ),
              ),
              if (command.hint != null)
                Text(
                  command.hint!,
                  style: AppText.ui(size: 12, color: p.textFaint),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
