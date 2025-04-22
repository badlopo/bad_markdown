part of 'bad_markdown.dart';

typedef TokenRenderer<Token extends MarkdownToken> = InlineSpan Function(
    Token token);

InlineSpan _heading(Heading token) {
  return WidgetSpan(
    child: Text(
      token.title,
      style: BadMarkdownStyles.headingStyles[token.level - 1],
    ),
  );
}

WidgetSpan _blockquote(Blockquote token) {
  return WidgetSpan(
    child: Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(width: 4, color: Colors.grey)),
      ),
      child: Text(
        token.lines.join('\n'),
        style: BadMarkdownStyles.blockquote,
      ),
    ),
  );
}

class MarkdownRenderer {
  final TokenRenderer<Heading> heading;
  final TokenRenderer<Blockquote> blockquote;

  const MarkdownRenderer({
    this.heading = _heading,
    this.blockquote = _blockquote,
  });
}
