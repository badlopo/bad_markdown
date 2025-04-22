part of 'bad_markdown.dart';

/// Build [MarkdownToken] from [RegExpMatch] instance.
typedef MarkdownTokenBuilder = MarkdownToken Function(RegExpMatch match);

sealed class MarkdownToken {
  static const List<String> _regexes = [
    // block-level
    Heading.source,
    Blockquote.source,
    Hr.source,

    // inline-level
    Strong.source,
    Emphasis.source,
    Delete.source,

    // non_exhaustive!
  ];

  /// Parse raw content into [MarkdownToken] list.
  static List<MarkdownToken> parse(String content) {
    final combinedRegex = RegExp(_regexes.join('|'), multiLine: true);

    List<MarkdownToken> tokens = [];
    content.splitMapJoin(
      combinedRegex,
      onMatch: (match) {
        tokens.add(fromMatch(match as RegExpMatch));
        return '';
      },
      onNonMatch: (segment) {
        tokens.add(Plaintext(segment));
        return '';
      },
    );

    return tokens;
  }

  static const _typename2builder = <String, MarkdownTokenBuilder>{
    // block-level
    Heading.typename: Heading.fromMatch,
    Blockquote.typename: Blockquote.fromMatch,
    Hr.typename: Hr.fromMatch,

    // inline-level
    Strong.typename: Strong.fromMatch,
    Emphasis.typename: Emphasis.fromMatch,
    Delete.typename: Delete.fromMatch,

    // non_exhaustive!
  };

  /// Parse [RegExpMatch] into [MarkdownToken].
  static MarkdownToken fromMatch(RegExpMatch match) {
    for (final MapEntry(key: typename, value: builder)
        in _typename2builder.entries) {
      final t = match.namedGroup(typename);
      if (t != null) return builder(match);
    }

    return const MarkdownTokenNonsense();
  }

  const MarkdownToken();

  InlineSpan render(BuildContext context);
}

class MarkdownTokenNonsense extends MarkdownToken {
  const MarkdownTokenNonsense();

  @override
  InlineSpan render(BuildContext context) {
    return const TextSpan(
      text: 'Unsupported Token',
      style: TextStyle(color: Colors.red),
    );
  }
}

abstract class MarkdownTokenBlock extends MarkdownToken {
  const MarkdownTokenBlock();
}

abstract class MarkdownTokenInline extends MarkdownToken {
  const MarkdownTokenInline();
}

class Heading extends MarkdownTokenBlock {
  static const String typename = 'type_heading';

  static const String source =
      '(?<$typename>^(?<hashes>#{1,6}) (?<title>.*)\$)';

  final int level;
  final String title;

  const Heading({required this.level, required this.title});

  factory Heading.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename) &&
          names.contains('hashes') &&
          names.contains('title');
    }());

    return Heading(
      level: match.namedGroup('hashes')!.length,
      title: match.namedGroup('title')!,
    );
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.headingRendererOf(context)(this);
  }

  @override
  String toString() {
    return '[Heading] <h$level> $title';
  }
}

class Blockquote extends MarkdownTokenBlock {
  static const String typename = 'type_blockquote';

  static const String source = '(?<$typename>(> (.*)\n)+)';

  final List<String> lines;

  const Blockquote({required this.lines});

  factory Blockquote.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename);
    }());

    return Blockquote(
      lines: match
          .namedGroup(typename)!
          .split('\n')
          .where((line) => line.isNotEmpty)
          .map((line) => line.substring(2))
          .toList(),
    );
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.blockquoteRendererOf(context)(this);
  }

  @override
  String toString() {
    final int line = lines.length;
    return '[Blockquote] $line line${line == 1 ? '' : 's'}';
  }
}

class Hr extends MarkdownTokenBlock {
  static const String typename = 'type_hr';

  static const String source =
      '(?<$typename>^[ \t]*(?:(?:-[ \t]*){3,})|(?:(?:\\*[ \t]*){3,})|(?:(?:_[ \t]*){3,})\$)';

  const Hr();

  factory Hr.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename);
    }());

    return const Hr();
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.hrRendererOf(context)(this);
  }
}

class Plaintext extends MarkdownTokenInline {
  final String content;

  const Plaintext(this.content);

  @override
  TextSpan render(BuildContext context) {
    return TextSpan(text: content);
  }

  @override
  String toString() {
    return '[Plaintext] $content';
  }
}

class Strong extends MarkdownTokenInline {
  static const String typename = 'type_strong';

  static const String source =
      '(?<$typename>(?:\\*\\*(?<content>\\S(?:.*\\S)?)\\*\\*)|(?:__(?<content>\\S(?:.*\\S)?)__))';

  final String content;

  const Strong(this.content);

  factory Strong.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename);
    }());

    return Strong(match.namedGroup('content')!);
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.strongRendererOf(context)(this);
  }

  @override
  String toString() {
    return '[Strong] $content';
  }
}

class Emphasis extends MarkdownTokenInline {
  static const String typename = 'type_emphasis';

  static const String source =
      '(?<$typename>(?:\\*(?<content>\\S(?:.*\\S)?)\\*)|(?:_(?<content>\\S(?:.*\\S)?)_))';

  final String content;

  const Emphasis(this.content);

  factory Emphasis.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename);
    }());

    return Emphasis(match.namedGroup('content')!);
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.emphasisRendererOf(context)(this);
  }

  @override
  String toString() {
    return '[Emphasis] $content';
  }
}

class Delete extends MarkdownTokenInline {
  static const String typename = 'type_delete';

  static const String source = '(?<$typename>~~(?<content>\\S(?:.*\\S)?)~~)';

  final String content;

  const Delete(this.content);

  factory Delete.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(typename);
    }());

    return Delete(match.namedGroup('content')!);
  }

  @override
  InlineSpan render(BuildContext context) {
    return _ConfigProvider.deleteRendererOf(context)(this);
  }

  @override
  String toString() {
    return '[Delete] $content';
  }
}
