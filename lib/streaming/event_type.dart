enum EventType {
  /// Unknown event (Ignored)
  undefined(-1),
  /// Play
  play(0),
  /// Pause
  pause(1),
  /// Pause on Buffering (Generated internally)
  pauseOnBuffering(2),
  /// End.
  end(3),
  /// Buffer
  buffer(4),
  /// Buffer Stop
  bufferStop(5),
  /// Keep Alive (Generated internally)
  keepAlive(6),
  /// Heart Beat (Generated internally)
  heartBeat(7),
  /// Custom (User defined)
  custom(8),
  /// Load
  load(9),
  /// Start
  start(10),
  /// Seek start
  seekStart(11),
  /// Ad Skip
  adSkip(12),
  /// Call to action
  cta(13),
  /// Error
  error(14),
  /// Transfer playback
  transfer(15),
  /// DRM check failed
  drmFailed(16),
  /// DRM check approved
  drmApproved(17),
  /// DRM check denied
  drmDenied(18),
  /// Changed bit rate
  bitRate(19),
  /// Changed Playback rate
  playbackRate(20),
  /// Changed volume
  volume(21),
  /// Changed window state
  windowState(22),
  /// Changed Audio file/channel/language
  audio(23),
  /// Changed Video file/channel
  video(24),
  /// Changed subs file/channel/language
  subs(25),
  /// Changed CDN service
  cdn(26);

  const EventType(this.value);
  final int value;

  static EventType? getByValue(num i) {
    for (var value in EventType.values) {
      if (value.value == i) {
        return value;
      }
    }
    return null;
  }
}
