enum ContentDeliveryAdvertisementCapability {
  none(801),
  dynamicLoad(802),
  dynamicReplacement(803),
  linear1Day(804),
  linear2Day(805),
  linear3Day(806),
  linear4Day(807),
  linear5Day(808),
  linear6Day(809),
  linear7Day(810);

  const ContentDeliveryAdvertisementCapability(this.value);
  final int value;

  static ContentDeliveryAdvertisementCapability? getByValue(num i) {
    for (var value in ContentDeliveryAdvertisementCapability.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
