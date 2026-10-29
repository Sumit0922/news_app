enum NewsCategory {
  business('Business'),
  technology('Technology'),
  general('General'),
  science('Science'),
  health('Health'),
  sports('Sports'),
  entertainment('Entertainment');

  const NewsCategory(this.label);

  final String label;

  String get apiValue => name;
}
