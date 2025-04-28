library bad_markdown;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets show Image;

part 'renderer.dart';

part 'style.dart';

part 'token.dart';

typedef OnLinkTap = void Function(Link token);

// OPTIMIZE: use 'InheritedModel' instead
class _ConfigProvider extends InheritedWidget {
  static _ConfigProvider _of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ConfigProvider>()!;
  }

  static TokenRenderer<Heading> headingRendererOf(BuildContext context) {
    return _of(context).renderer.heading;
  }

  static TokenRenderer<Blockquote> blockquoteRendererOf(BuildContext context) {
    return _of(context).renderer.blockquote;
  }

  static TokenRenderer<Hr> hrRendererOf(BuildContext context) {
    return _of(context).renderer.hr;
  }

  static TokenRenderer<Strong> strongRendererOf(BuildContext context) {
    return _of(context).renderer.strong;
  }

  static TokenRenderer<Emphasis> emphasisRendererOf(BuildContext context) {
    return _of(context).renderer.emphasis;
  }

  static TokenRenderer<Delete> deleteRendererOf(BuildContext context) {
    return _of(context).renderer.delete;
  }

  static TokenRenderer<Image> imageRendererOf(BuildContext context) {
    return _of(context).renderer.image;
  }

  static TokenRenderer<Link> linkRendererOf(BuildContext context) {
    return _of(context).renderer.link;
  }

  static OnLinkTap? onLinkOf(BuildContext context) {
    return _of(context).onLink;
  }

  final MarkdownRenderer renderer;
  final OnLinkTap? onLink;

  const _ConfigProvider({
    required super.child,
    required this.renderer,
    this.onLink,
  });

  @override
  bool updateShouldNotify(covariant _ConfigProvider oldWidget) {
    return oldWidget.renderer != renderer;
  }
}

class BadMarkdown extends StatefulWidget {
  final MarkdownRenderer renderer;
  final OnLinkTap? onLinkTap;
  final String content;

  const BadMarkdown({
    super.key,
    this.renderer = const MarkdownRenderer(),
    this.onLinkTap,
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
      onLink: widget.onLinkTap,
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
