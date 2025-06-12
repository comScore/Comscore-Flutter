enum ContentMediaFormat {
  fullContentGeneric(1001),
  fullContentEpisode(1002),
  fullContentMovie(1003),
  partialContentGeneric(1004),
  partialContentEpisode(1005),
  partialContentMovie(1006),
  previewGeneric(1007),
  previewEpisode(1008),
  previewMovie(1009),
  extraGeneric(1010),
  extraEpisode(1012),
  extraMovie(1013),
  fullContentPodcast(1014),
  partialContentPodcast(1015);

  const ContentMediaFormat(this.value);
  final int value;

  static ContentMediaFormat? getByValue(num i) {
    for (var value in ContentMediaFormat.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
