library bad_markdown;

import 'package:flutter/material.dart';

part 'renderer.dart';

part 'style.dart';

part 'token.dart';

class BadMarkdown extends StatefulWidget {
  final String content;

  const BadMarkdown({super.key, required this.content});

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
    return Text.rich(
      TextSpan(
        children: [for (final token in tokens) token.render()],
      ),
      style: BadMarkdownStyles.base,
    );
  }
}

// class _MarkdownRendererDelegate extends StatelessWidget {
//   final List<MarkdownToken> tokens;
//
//   const _MarkdownRendererDelegate(this.tokens);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(
//       TextSpan(
//         children: [for (final token in tokens) token.render()],
//       ),
//       style: BadMarkdownStyles.base,
//     );
//   }
// }
