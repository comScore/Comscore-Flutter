enum StreamingState {
  undefined(-1),
  idle(0),
  playbackNotStarted(1),
  playing(2),
  paused(3),
  bufferingBeforePlayback(4),
  bufferingDuringPlayback(5),
  bufferingDuringSeeking(6),
  bufferingDuringPause(7),
  seekingBeforePlayback(8),
  seekingDuringPlayback(9),
  seekingDuringBuffering(10),
  seekingDuringPause(11),
  pauseDuringBuffering(12);

  const StreamingState(this.value);
  final int value;

  static StreamingState getByValue(num i) {
    for (var value in StreamingState.values) {
      if (value.value == i) {
        return value;
      }
    }
    return undefined;
  }
}
