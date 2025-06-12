enum ContentType {
  /// On demand, long form. Content with strong brand equity or brand
  /// recognition, usually created or produced by media and entertainment
  /// companies using professional-grade equipment, talent, and production
  /// crews that hold or maintain the rights for distribution and syndication.
  longFormOnDemand(112),

  /// On demand, short form. Content with strong brand equity or brand
  /// recognition, usually created or produced by media and entertainment
  /// companies using professional-grade equipment, talent, and production
  /// crews that hold or maintain the rights for distribution and syndication.
  shortFormOnDemand(111),

  /// Live/simulcast. Content with strong brand equity or brand recognition,
  /// usually created or produced by media and entertainment companies using
  /// professional-grade equipment, talent, and production crews that hold or
  /// maintain the rights for distribution and syndication.
  live(113),

  /// On demand, long form. Content with little-to-no brand equity or brand
  /// recognition. User-generated content (UGC) has minimal production value,
  /// and is uploaded to the Internet by non-media professionals.
  userGeneratedLongFormOnDemand(122),

  /// On demand, short form. Content with little-to-no brand equity or brand
  /// recognition. User-generated content (UGC) has minimal production value,
  /// and is uploaded to the Internet by non-media professionals.
  userGeneratedShortFormOnDemand(121),

  /// Live/simulcast. Content with little-to-no brand equity or brand
  /// recognition. User-generated content (UGC) has minimal production value,
  /// and is uploaded to the Internet by non-media professionals.
  userGeneratedLive(123),

  /// Bumpers - also known as "billboards" or "slates" - are static promotional
  /// images usually run before video content and usually lasting fewer than 5
  /// seconds with or without a voiceover. They are frequently not true video
  /// streams in the technical sense. Ideally, these would not be tagged due to
  /// their nature. This value can be used in cases where the bumpers have to
  /// be tagged.
  bumper(199),

  /// Used if none of the above categories apply.
  other(100);

  const ContentType(this.value);
  final int value;

  static ContentType? getByValue(num i) {
    for (var value in ContentType.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
