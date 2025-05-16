enum UsagePropertiesAutoUpdateMode {
  /// Usage properties will not auto update.
  disabled(20502),

  /// Usage properties will auto update in foreground and background.
  foregroundAndBackground(20501),

  /// Usage properties will auto update only while in foreground.
  foregroundOnly(20500);

  const UsagePropertiesAutoUpdateMode(this.mode);
  final int mode;

  static UsagePropertiesAutoUpdateMode getByValue(num i) {
    return UsagePropertiesAutoUpdateMode.values.firstWhere((x) => x.mode == i, orElse: () => foregroundOnly);
  }
}
