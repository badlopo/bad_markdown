part of 'bad_markdown.dart';

typedef TokenRenderer<Token extends MarkdownToken> = InlineSpan Function(
    BuildContext context, Token token);

InlineSpan _headingRenderer(BuildContext context, Heading token) {
  return WidgetSpan(
    child: Text(
      token.title,
      style: BadMarkdownStyles.headingStyles[token.level - 1],
    ),
  );
}

WidgetSpan _blockquoteRenderer(BuildContext context, Blockquote token) {
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

WidgetSpan _hrRenderer(BuildContext context, Hr token) {
  return const WidgetSpan(child: Divider());
}

TextSpan _strongRenderer(BuildContext context, Strong token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(fontWeight: FontWeight.bold),
  );
}

TextSpan _emphasisRenderer(BuildContext context, Emphasis token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(fontStyle: FontStyle.italic),
  );
}

TextSpan _deleteRenderer(BuildContext context, Delete token) {
  return TextSpan(
    text: token.content,
    style: const TextStyle(decoration: TextDecoration.lineThrough),
  );
}

WidgetSpan _imageRenderer(BuildContext context, Image token) {
  return WidgetSpan(child: widgets.Image.network(token.src));
}

TextSpan _linkRenderer(BuildContext context, Link token) {
  GestureRecognizer? recognizer;

  final onLink = _ConfigProvider.onLinkOf(context);
  if (onLink != null) {
    recognizer = TapGestureRecognizer()
      ..onTap = () {
        onLink(token);
      };
  }

  return TextSpan(
    text: token.text,
    recognizer: recognizer,
    style: const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue,
    ),
  );
}

class MarkdownRenderer {
  final TokenRenderer<Heading> heading;
  final TokenRenderer<Blockquote> blockquote;
  final TokenRenderer<Hr> hr;
  final TokenRenderer<Strong> strong;
  final TokenRenderer<Emphasis> emphasis;
  final TokenRenderer<Delete> delete;
  final TokenRenderer<Image> image;
  final TokenRenderer<Link> link;

  const MarkdownRenderer({
    this.heading = _headingRenderer,
    this.blockquote = _blockquoteRenderer,
    this.hr = _hrRenderer,
    this.strong = _strongRenderer,
    this.emphasis = _emphasisRenderer,
    this.delete = _deleteRenderer,
    this.image = _imageRenderer,
    this.link = _linkRenderer,
  });
}
