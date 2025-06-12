enum AdvertisementOwner {
  distributor(1201),
  originator(1202),
  multiple(1203),
  none(1204);

  const AdvertisementOwner(this.value);
  final int value;

  static AdvertisementOwner? getByValue(num i) {
    for (var value in AdvertisementOwner.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
