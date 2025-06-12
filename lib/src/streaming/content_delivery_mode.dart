enum ContentDeliveryMode {
  linear(501),
  onDemand(502);

  const ContentDeliveryMode(this.value);
  final int value;

  static ContentDeliveryMode? getByValue(num i) {
    for (var value in ContentDeliveryMode.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
