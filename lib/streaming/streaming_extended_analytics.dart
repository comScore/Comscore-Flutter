import 'package:comscore_analytics_flutter/streaming/window_state.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object_extension.dart';

class StreamingExtendedAnalytics extends TrackableObject {
  static const _methodChannel = MethodChannel("com.comscore.streaming.streamingExtendedAnalytics");

  StreamingExtendedAnalytics(super.refId);

  ///
  /// Notifies of a new Load event.
  /// @param labels Labels
  ///
  Future<void> notifyLoad([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyLoad', args);
  }

  ///
  /// Notifies of a new Start event.
  /// @param labels Labels
  ///
  Future<void> notifyEngage([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyEngage', args);
  }

  ///
  /// Notifies of a new Skip Ad event.
  /// @param labels Labels
  ///
  Future<void> notifySkipAd([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifySkipAd', args);
  }

  ///
  /// Notifies of a new Call to Action event with associated labels.
  ///
  /// @param labels map of labels associated with the current event
  ///
  Future<void> notifyCallToAction([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyCallToAction', args);
  }

  ///
  /// Notifies of a new Error event.
  ///
  /// @param errorIdentifier Used to populate label ns_st_er
  /// @param labels Map of labels associated with the current event
  ///
  Future<void> notifyError(String errorIdentifier, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["error"] = errorIdentifier;
    return _methodChannel.invokeMethod<void>('notifyError', args);
  }

  ///
  /// Notifies of a new Transfer Playback event.
  ///
  /// @param targetDevice Used to populate label ns_st_rp on the measurement event
  /// @param labels Labels
  ///
  Future<void> notifyTransferPlayback(String targetDevice, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["targetDevice"] = targetDevice;
    return _methodChannel.invokeMethod<void>('notifyTransferPlayback', args);
  }

  ///
  /// Notifies of a new DRM Fail event.
  /// @param labels Labels
  ///
  Future<void> notifyDrmFail([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyDrmFail', args);
  }

  ///
  /// Notifies of a new DRM Approve event.
  /// @param labels Labels
  ///
  Future<void> notifyDrmApprove([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyDrmApprove', args);
  }

  ///
  /// Notifies of a new DRM Deny event.
  /// @param labels Labels
  ///
  Future<void> notifyDrmDeny([Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod<void>('notifyDrmDeny', args);
  }

  ///
  /// Notifies of a new Change of Bitrate event with the given new rate (in bps).
  ///
  /// @param newRate   The new bitrate in bps
  /// @param labels Labels
  ///
  Future<void> notifyChangeBitrate(int newRate, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args[Args.rate] = newRate;
    return _methodChannel.invokeMethod<void>('notifyChangeBitrate', args);
  }

  ///
  /// Notifies of a new Change Volume event with the given new state.
  ///
  /// @param newState One of these: WindowState.NORMAL, WindowState.FULL_SCREEN, WindowState.MINIMIZED or WindowState.MAXIMIZED
  /// @param labels Labels
  ///
  Future<void> notifyChangeWindowState(WindowState newState, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newState"] = newState.value;
    return _methodChannel.invokeMethod<void>('notifyChangeWindowState', args);
  }

  ///
  /// Notifies of a new Change Audio event with the given new audio.
  ///
  /// @param newAudio  New audio track/name/language
  /// @param labels Labels
  ///
  Future<void> notifyChangeAudioTrack(String newAudio, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newAudio"] = newAudio;
    return _methodChannel.invokeMethod<void>('notifyChangeAudioTrack', args);
  }

  ///
  /// Notifies of a new Change Video event with the given new video.
  ///
  /// @param newVideo  New audio track/name
  /// @param labels Labels
  ///
  Future<void> notifyChangeVideoTrack(String newVideo, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newVideo"] = newVideo;
    return _methodChannel.invokeMethod<void>('notifyChangeVideoTrack', args);
  }

  ///
  /// Notifies of a new Change Subtitle event with the given new subtitle.
  ///
  /// @param newSubtitle  New subtitle track/name/language
  /// @param labels Labels
  ///
  Future<void> notifyChangeSubtitleTrack(String newSubtitle, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newSubtitle"] = newSubtitle;
    return _methodChannel.invokeMethod<void>('notifyChangeSubtitleTrack', args);
  }

  ///
  /// Notifies of a new Custom streaming event with the associated labels.
  ///
  /// @param eventName Event name
  /// @param labels Map of labels associated with the current event
  ///
  Future<void> notifyCustomEvent(String eventName, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["eventName"] = eventName;
    return _methodChannel.invokeMethod<void>('notifyCustomEvent', args);
  }

  /// Expected total playback session length in milliseconds (sum of asset lengths in playback session).
  ///
  /// @param expectedTotalLength Expected total length
  ///
  Future<void> setPlaybackSessionExpectedLength(int expectedTotalLength) {
    var args = buildArguments();
    args["expectedTotalLength"] = expectedTotalLength;
    return _methodChannel.invokeMethod<void>('setPlaybackSessionExpectedLength', args);
  }

  /// Expected total number of assets in playback session (count of individual assets).
  ///
  /// @param expectedNumberOfItems Expected number of items
  ///
  Future<void> setPlaybackSessionExpectedNumberOfItems(int expectedNumberOfItems) {
    var args = buildArguments();
    args["expectedNumberOfItems"] = expectedNumberOfItems;
    return _methodChannel.invokeMethod<void>('setPlaybackSessionExpectedNumberOfItems', args);
  }

  ///
  /// Notifies of a new Change Volume event with the given new rate (in percentage, with 100% being max. volume).
  ///
  /// @param newVolume The new volume rate 0.0-1.0
  ///
  Future<void> notifyChangeVolume(double newVolume, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newVolume"] = newVolume;
    return _methodChannel.invokeMethod<void>('notifyChangeVolume', args);
  }

  ///
  /// Notifies of a new Change CDN event with the given new CDN.
  ///
  /// @param newCDN    New CDN name or server details
  /// @param labels Labels
  ///
  Future<void> notifyChangeCdn(String newCDN, [Map<String, String>? labels]) {
    var args = buildArguments();
    args[Args.labels] = labels;
    args["newCDN"] = newCDN;
    return _methodChannel.invokeMethod<void>('notifyChangeCdn', args);
  }

  ///
  ///Sets the load time offset
  ///
  /// @param offset Offset
  ///
  Future<void> setLoadTimeOffset(int offset) {
    var args = buildArguments();
    args["offset"] = offset;
    return _methodChannel.invokeMethod<void>('setLoadTimeOffset', args);
  }
}
