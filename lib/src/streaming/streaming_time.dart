class Time {
  final int hour, minute;

  Time(this.hour, this.minute);

  Map<String, dynamic>? toMap() {
    return {"hour": hour, "minute": minute};
  }
}
