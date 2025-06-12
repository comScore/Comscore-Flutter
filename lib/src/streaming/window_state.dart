enum WindowState {
  normal(400),
  fullScreen(401),
  minimized(402),
  maximized(403);

  const WindowState(this.value);
  final int value;

  static WindowState? getByValue(num i) {
    for (var value in WindowState.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
