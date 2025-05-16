enum AdvertisementType {
  /// Linear, pre-roll. Linear ads delivered into a media player and presented before, in the middle of,
  /// or after content is consumed by the user. For video the ad completely takes over the full view of
  /// the media player.
  onDemandPreRoll(211),

  /// Linear, mid-roll. Linear ads delivered into a media player and presented before, in the middle of,
  /// or after content is consumed by the user. For video the ad completely takes over the full view of
  /// the media player.
  onDemandMidRoll(212),

  /// Linear, post-roll. Linear ads delivered into a media player and presented before, in the middle of,
  /// or after content is consumed by the user. For video the ad completely takes over the full view of
  /// the media player.
  onDemandPostRoll(213),

  /// Linear, live/simulcast. Linear ads delivered before, in the middle of, or after a
  /// live/simulcast stream of content. For video the ad completely takes over the full view of the
  /// media player.
  live(221),

  /// Branded, pre-roll. Branded entertainment is media that a user may intentionally view (like content),
  /// or it may be served to a user during an ad break (like an advertisement).
  brandedOnDemandPreRoll(231),

  /// Branded, mid-roll. Branded entertainment is media that a user may intentionally view (like content),
  /// or it may be served to a user during an ad break (like an advertisement).
  brandedOnDemandMidRoll(232),

  /// Branded, post-roll. Branded entertainment is media that a user may intentionally view (like content),
  /// or it may be served to a user during an ad break (like an advertisement).
  brandedOnDemandPostRoll(233),

  /// Branded, content. Branded entertainment is media that a user may intentionally view (like content),
  /// or it may be served to a user during an ad break (like an advertisement).
  brandedAsContent(234),

  /// Branded, live/simulcast. Branded entertainment is media that a user may intentionally view (like
  /// content), or it may be served to a user during an ad break (like an advertisement).
  brandedDuringLive(235),

  /// Used if none of the above categories apply.
  other(200);

  const AdvertisementType(this.type);
  final int type;

  static AdvertisementType? getByValue(num i) {
    for (var value in AdvertisementType.values) {
      if (value.type == i) {
        return value;
      }
    }
    return null;
  }
}
