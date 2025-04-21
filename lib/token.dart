part of 'bad_markdown.dart';

/// Build [MarkdownToken] from [RegExpMatch] instance.
typedef MarkdownTokenBuilder = MarkdownToken Function(RegExpMatch match);

sealed class MarkdownToken {
  /// Type name of token. (prefixed with `type_`)
  String get typename;

  /// Regexp source of this token.
  String get source;

  const MarkdownToken();

  static const _typename2builder = <String, MarkdownTokenBuilder>{
    // block-level
    Heading._typename: Heading.fromMatch,
    Blockquote._typename: Blockquote.fromMatch,

    // inline-level
    // ...

    // non_exhaustive!()
  };

  /// Generic parser for all [MarkdownToken].
  static MarkdownToken fromMatch(RegExpMatch match) {
    for (final MapEntry(key: typename, value: builder)
        in _typename2builder.entries) {
      final t = match.namedGroup(typename);
      if (t != null) return builder(match);
    }

    return const MarkdownTokenNonsense();
  }
}

class MarkdownTokenNonsense extends MarkdownToken {
  @override
  String get source => throw UnsupportedError('unreachable!');

  @override
  String get typename => throw UnsupportedError('unreachable!');

  const MarkdownTokenNonsense();
}

abstract class MarkdownTokenInline extends MarkdownToken {
  const MarkdownTokenInline();
}

abstract class MarkdownTokenBlock extends MarkdownToken {
  const MarkdownTokenBlock();
}

class Heading extends MarkdownTokenBlock {
  static const String _typename = 'type_heading';

  @override
  String get typename => _typename;

  @override
  String get source => '(?<$_typename>^(?<hashes>#{1,6}) (?<title>.*)\$)';

  final int level;
  final String title;

  const Heading({required this.level, required this.title});

  factory Heading.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(_typename) &&
          names.contains('hashes') &&
          names.contains('title');
    }());

    return Heading(
      level: match.namedGroup('hashes')!.length,
      title: match.namedGroup('title')!,
    );
  }

  @override
  String toString() {
    return '[Heading] <h$level> $title';
  }
}

class Blockquote extends MarkdownTokenBlock {
  static const String _typename = 'type_blockquote';

  @override
  String get typename => _typename;

  @override
  String get source => '(?<$_typename>(> (.*)\n)+)';

  final List<String> lines;

  const Blockquote({required this.lines});

  factory Blockquote.fromMatch(RegExpMatch match) {
    assert(() {
      final names = match.groupNames.toSet();
      return names.contains(_typename);
    }());

    return Blockquote(
      lines: match
          .namedGroup(_typename)!
          .split('\n')
          .where((line) => line.isNotEmpty)
          .map((line) => line.substring(2))
          .toList(),
    );
  }

  @override
  String toString() {
    final int line = lines.length;
    return '[Blockquote] $line line${line == 1 ? '' : 's'}';
  }
}
