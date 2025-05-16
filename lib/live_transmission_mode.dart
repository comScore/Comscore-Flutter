enum LiveTransmissionMode {
  /// The Events are requested to be stored in the OfflineCache even if a network connection is available.
  cache(20003),

  /// Only sends Events if the device is connected to a local area network (for instance: wifi
  /// or ethernet), otherwise the Events are requested to be stored in the OfflineCache.
  lan(20002),

  /// Standard behavior. It will send the Events if there is a network connection.
  standard(20001);

  const LiveTransmissionMode(this.mode);
  final int mode;

  static LiveTransmissionMode getByValue(num i) {
    return LiveTransmissionMode.values.firstWhere((x) => x.mode == i, orElse: () => standard);
  }
}
