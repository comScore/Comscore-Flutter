enum AdvertisementDeliveryType {
  national(1101),
  local(1102),
  syndication(1103);

  const AdvertisementDeliveryType(this.value);
  final int value;

  static AdvertisementDeliveryType getByValue(num i) {
    return AdvertisementDeliveryType.values.firstWhere((x) => x.value == i, orElse: () => national);
  }
}
