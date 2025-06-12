class Date {
  final int year, month, day;

  Date(this.year, this.month, this.day);

  Map<String, dynamic>? toMap() {
    return {"year": year, "month": month, "day": day};
  }
}
