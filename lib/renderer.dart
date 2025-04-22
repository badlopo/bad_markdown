part of 'bad_markdown.dart';

typedef TokenRenderer<Token extends MarkdownToken> = InlineSpan Function(
    Token token);

InlineSpan _headingRenderer(Heading token) {
  return WidgetSpan(
    child: Text(
      token.title,
      style: BadMarkdownStyles.headingStyles[token.level - 1],
    ),
  );
}

WidgetSpan _blockquoteRenderer(Blockquote token) {
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

TextSpan _strongRenderer(Strong token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(fontWeight: FontWeight.bold),
  );
}

TextSpan _emphasisRenderer(Emphasis token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(fontStyle: FontStyle.italic),
  );
}

TextSpan _deleteRenderer(Delete token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(decoration: TextDecoration.lineThrough),
  );
}

class MarkdownRenderer {
  final TokenRenderer<Heading> heading;
  final TokenRenderer<Blockquote> blockquote;
  final TokenRenderer<Strong> strong;
  final TokenRenderer<Emphasis> emphasis;
  final TokenRenderer<Delete> delete;

  const MarkdownRenderer({
    this.heading = _headingRenderer,
    this.blockquote = _blockquoteRenderer,
    this.strong = _strongRenderer,
    this.emphasis = _emphasisRenderer,
    this.delete = _deleteRenderer,
  });
}
