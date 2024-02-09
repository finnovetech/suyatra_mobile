enum IconPosition {
  left,
  right;
}

enum ArticleType {
  all("Articles"),
  featured("Featured Articles"),
  popular("Popular Articles");

  final String value;

  const ArticleType(this.value);
}