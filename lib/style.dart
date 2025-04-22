part of 'bad_markdown.dart';

abstract class BadMarkdownStyles {
  static const TextStyle base = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle h1 = TextStyle(fontSize: 32);
  static const TextStyle h2 = TextStyle(fontSize: 28);
  static const TextStyle h3 = TextStyle(fontSize: 24);
  static const TextStyle h4 = TextStyle(fontSize: 22);
  static const TextStyle h5 = TextStyle(fontSize: 20);
  static const TextStyle h6 = TextStyle(fontSize: 18);

  static const List<TextStyle> headingStyles = [h1, h2, h3, h4, h5, h6];

  static const TextStyle blockquote = TextStyle();

  static const TextStyle paragraph = TextStyle();
}
