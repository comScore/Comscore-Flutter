
class Dimensions {
  final int width, height;

  Dimensions(this.width, this.height);

  Map<String, dynamic>? toMap() {
    return {"width": width, "height": height};
  }
}
