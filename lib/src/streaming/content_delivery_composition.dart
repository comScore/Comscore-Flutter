enum ContentDeliveryComposition {
  clean(701),
  embed(702);

  const ContentDeliveryComposition(this.value);
  final int value;

  static ContentDeliveryComposition? getByValue(num i) {
    for (var value in ContentDeliveryComposition.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
