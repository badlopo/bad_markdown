library bad_markdown;

import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

part 'renderer.dart';

part 'style.dart';

part 'token.dart';

// OPTIMIZE: use 'InheritedModel' instead
class _ConfigProvider extends InheritedWidget {
  static _ConfigProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ConfigProvider>()!;
  }

  static TokenRenderer<Heading> headingRendererOf(BuildContext context) {
    return of(context).renderer.heading;
  }

  static TokenRenderer<Blockquote> blockquoteRendererOf(BuildContext context) {
    return of(context).renderer.blockquote;
  }

  final MarkdownRenderer renderer;

  const _ConfigProvider({required super.child, required this.renderer});

  @override
  bool updateShouldNotify(covariant _ConfigProvider oldWidget) {
    return oldWidget.renderer != renderer;
  }
}

class BadMarkdown extends StatefulWidget {
  final MarkdownRenderer renderer;
  final String content;

  const BadMarkdown({
    super.key,
    this.renderer = const MarkdownRenderer(),
    required this.content,
  });

  @override
  State<BadMarkdown> createState() => _MarkdownState();
}

class _MarkdownState extends State<BadMarkdown> {
  List<MarkdownToken> tokens = [];

  @override
  void initState() {
    super.initState();

    tokens = MarkdownToken.parse(widget.content);
  }

  @override
  void didUpdateWidget(covariant BadMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content) {
      tokens = MarkdownToken.parse(widget.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return GptMarkdown(widget.content);
    return _ConfigProvider(
      renderer: widget.renderer,
      child: _MarkdownRendererDelegate(tokens),
    );
  }
}

class _MarkdownRendererDelegate extends StatelessWidget {
  final List<MarkdownToken> tokens;

  const _MarkdownRendererDelegate(this.tokens);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [for (final token in tokens) token.render(context)]),
      style: BadMarkdownStyles.base,
    );
  }
}
