import 'package:emoji_regex/emoji_regex.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:flutter/material.dart';

import '../state.dart';

/// Page/dialog heading. Always start-aligned — titles are never prose and
/// must never be justified.
class AppTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTitle(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? context.textTheme.headlineSmall;
    return Text(
      text,
      textAlign: TextAlign.start,
      style: resolvedStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Normal UI body/label text: settings rows, list titles, short
/// descriptions, technical values. Always start-aligned.
class AppBody extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppBody(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? context.textTheme.bodyMedium;
    return Text(
      text,
      textAlign: TextAlign.start,
      style: resolvedStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Long-form prose: disclaimers, agreements, help/documentation content.
/// Justifies on comfortably wide layouts and falls back to start alignment
/// on narrow ones, where CJK justification would stretch characters
/// unnaturally (small phones, narrow dialogs, split-screen windows).
class AppParagraph extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool selectable;
  final int? maxLines;

  /// Escape hatch for paragraphs that read worse justified — most often
  /// CJK prose carrying a long, unbreakable Latin run (a brand name, a
  /// product name) where justify's gap distribution lands unevenly next
  /// to it. Set false to keep AppParagraph's line height/selectable
  /// behavior while pinning alignment to start regardless of width.
  final bool allowJustify;

  static const double _justifyMinWidth = 280;

  const AppParagraph(
    this.text, {
    super.key,
    this.style,
    this.selectable = false,
    this.maxLines,
    this.allowJustify = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedStyle =
        style ?? context.textTheme.bodyMedium?.copyWith(height: 1.55);

    return LayoutBuilder(
      builder: (context, constraints) {
        final align = allowJustify && constraints.maxWidth >= _justifyMinWidth
            ? TextAlign.justify
            : TextAlign.start;

        if (selectable) {
          return SelectableText(
            text,
            textAlign: align,
            style: resolvedStyle,
            maxLines: maxLines,
          );
        }

        return Text(
          text,
          textAlign: align,
          style: resolvedStyle,
          maxLines: maxLines,
        );
      },
    );
  }
}

class TooltipText extends StatelessWidget {
  final Text text;

  const TooltipText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isOverflow = globalState.measure.computeTextIsOverflow(
          text,
          maxWidth: maxWidth,
        );
        if (isOverflow) {
          return Tooltip(
            triggerMode: TooltipTriggerMode.longPress,
            preferBelow: false,
            message: text.data,
            child: text,
          );
        }
        return text;
      },
    );
  }
}

class TooltipTextV2 extends StatefulWidget {
  final Text text;

  const TooltipTextV2({super.key, required this.text});

  @override
  State<TooltipTextV2> createState() => _TooltipTextV2State();
}

class _TooltipTextV2State extends State<TooltipTextV2> {
  bool _isOverflow = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    if (!mounted) {
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final isOverflow = globalState.measure.computeTextIsOverflow(
      widget.text,
      maxWidth: renderBox.size.width,
    );
    setState(() => _isOverflow = isOverflow);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.longPress,
      preferBelow: false,
      message: _isOverflow ? widget.text.data : '',
      child: widget.text,
    );
  }
}

class EmojiText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const EmojiText(
    this.text, {
    super.key,
    this.maxLines,
    this.overflow,
    this.style,
  });

  List<TextSpan> _buildTextSpans(String emojis) {
    final List<TextSpan> spans = [];
    final matches = emojiRegex().allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style?.copyWith(fontFamily: FontFamily.twEmoji.value),
        ),
      );
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(children: _buildTextSpans(text)),
    );
  }
}

// class HighlightText extends StatelessWidget {
//   const HighlightText({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       textScaler: MediaQuery.of(context).textScaler,
//       maxLines: maxLines,
//       overflow: overflow ?? TextOverflow.clip,
//       text: TextSpan(
//         children: _buildTextSpans(text),
//       ),
//     );
//   }
// }
