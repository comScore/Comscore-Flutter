enum ContentDistributionModel {
  tvAndOnline(901),
  exclusivelyOnline(902);

  const ContentDistributionModel(this.value);
  final int value;

  static ContentDistributionModel? getByValue(num i) {
    for (var value in ContentDistributionModel.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
