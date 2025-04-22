part of 'bad_markdown.dart';

sealed class MarkdownRenderer<Token extends MarkdownToken> {
  final Token token;

  const MarkdownRenderer(this.token);

  InlineSpan span();
}

abstract class MarkdownRendererInline<Token extends MarkdownTokenInline>
    extends MarkdownRenderer<Token> {
  const MarkdownRendererInline(super.token);

  @override
  TextSpan span();
}

abstract class MarkdownRendererBlock<Token extends MarkdownTokenBlock>
    extends MarkdownRenderer<Token> {
  const MarkdownRendererBlock(super.token);

  @override
  InlineSpan span();
}

class HeadingRenderer extends MarkdownRendererBlock<Heading> {
  const HeadingRenderer(super.token);

  @override
  WidgetSpan span() {
    return WidgetSpan(
      child: Text(
        token.title,
        style: BadMarkdownStyles.headingStyles[token.level - 1],
      ),
    );
  }
}
