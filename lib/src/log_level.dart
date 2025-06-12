enum ComScoreLogLevel {
  none(30000),
  error(30001),
  warn(30002),
  debug(30003),
  verbose(30004);

  const ComScoreLogLevel(this.level);
  final int level;

  static ComScoreLogLevel? getByValue(num i) {
    for (var value in ComScoreLogLevel.values) {
      if (value.level == i) {
        return value;
      }
    }
    return null;
  }
}
