enum ContentDeliverySubscriptionType {
  traditionalMvpd(601),
  virtualMvpd(602),
  subscription(603),
  advertising(604),
  transactional(605),
  premium(606);

  const ContentDeliverySubscriptionType(this.value);
  final int value;

  static ContentDeliverySubscriptionType? getByValue(num i) {
    for (var value in ContentDeliverySubscriptionType.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
