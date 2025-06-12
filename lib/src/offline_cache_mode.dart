enum OfflineCacheMode {
  /// The OfflineCache will not store any event nor send any event.
  disabled(20104),

  /// Only flushing the cache  is allowed if the device is connected to a local area network. (for
  /// instance: wifi or ethernet).
  lan(20103),

  /// Normal behavior. It will store and flush automatically the events in the cache.
  enabled(20101),

  /// The OfflineCache is not flushed automatically. To flush it call OfflineCache#flush() manually.
  manualFlush(20102);

  const OfflineCacheMode(this.mode);
  final int mode;

  static OfflineCacheMode getByValue(num i) {
    return OfflineCacheMode.values.firstWhere(
      (x) => x.mode == i,
      orElse: () => enabled,
    );
  }
}
