import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';

Map<String, Map<String, dynamic>> _tags = <String, Map<String, dynamic>>{
  '<sb>': <String, dynamic>{
    'regex': '<sb>(.*?)<sb>',
    'style': const TextStyle(fontWeight: FontWeight.w600),
  },
  '<b>': <String, dynamic>{
    'regex': '<b>(.*?)<b>',
    'style': const TextStyle(fontWeight: FontWeight.w700),
  },
  '<primary>': <String, dynamic>{
    'regex': '<primary>(.*?)<primary>',
    'style': const TextStyle(color: AppColors.primary),
  },
  '<small>': <String, dynamic>{
    'regex': '<small>(.*?)<small>',
    'style': const TextStyle(fontSize: 16),
  },
  '<error>': <String, dynamic>{
    'regex': '<error>(.*?)<error>',
    'style': const TextStyle(color: AppColors.red),
  },
};

/// This text support tags to change text style
///
/// * usage:
///   * `<tag>text<tag>`, e.g., `<b>text<b>`
/// * tags:
///   * semi-bold (w600): `<sb>text<sb>`
///   * bold (w700): `<b>text<b>`
///   * primary color: `<primary>text<primary>`
///   * size 16: `<small>text<small>` TODO: make size tags dynamic
class BetterText extends StatelessWidget {
  const BetterText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => SelectableText.rich(
        _buildTextSpan(),
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
        style: style,
      );

  TextSpan _buildTextSpan() {
    Pattern pattern;
    List<InlineSpan> children;

    pattern = RegExp(
      _tags.keys.map((String key) => _tags[key]!['regex'] as String).join('|'),
      multiLine: true,
    );
    children = <InlineSpan>[];

    _applyStyles(pattern, children);

    return TextSpan(style: style, children: children);
  }

  String _applyStyles(Pattern pattern, List<InlineSpan> children) => text.splitMapJoin(
        pattern,
        onMatch: (Match match) {
          String? formattedText;
          TextStyle newStyle;

          newStyle = const TextStyle().merge(style);
          formattedText = match[0];

          for (final String tag in _tags.keys) {
            if (RegExp(_tags[tag]!['regex']! as String).hasMatch(match[0]!)) {
              formattedText = formattedText?.replaceAll(tag, '');
              newStyle = newStyle.merge(_tags[tag]!['style'] as TextStyle);
            }
          }

          children.add(
            TextSpan(
              text: formattedText,
              style: newStyle,
            ),
          );

          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text, style: style));
          return '';
        },
      );

  TextSpan normalSpan(String text) => TextSpan(text: text);

  TextSpan boldSpan(String text) => TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      );
}
