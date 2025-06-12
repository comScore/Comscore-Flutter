enum ContentFeedType {
  eastHd(301),
  westHd(302),
  eastSd(303),
  westSd(304),
  other(300);

  const ContentFeedType(this.value);
  final int value;

  static ContentFeedType? getByValue(num i) {
    for (var value in ContentFeedType.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
