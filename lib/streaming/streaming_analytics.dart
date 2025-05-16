import 'package:comscore_analytics_flutter/streaming/asset_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_configuration.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_extended_analytics.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_publisher_configuration.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_state.dart';
import 'package:comscore_analytics_flutter/utils/event_channel_stream_helper.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object_extension.dart';

typedef OnStreamingStateChange =
    void Function(StreamingState oldState, StreamingState newState, Map<String, String> eventLabels);

class StreamingAnalytics extends TrackableObject {
  static const _methodChannel = MethodChannel("com.comscore.streaming.streamingAnalytics");
  static Stream? _onStreamingStateChangeStream;
  static final Map<String, List<OnStreamingStateChange>> _onStreamingStateChangeListenerMap = {};

  StreamingConfiguration? _configuration;
  StreamingConfiguration? get configuration => _configuration;
  StreamingExtendedAnalytics? _extendedAnalytics;

  StreamingAnalytics._init(super.streamingAnalyticsRefId, String streamingConfigurationRefId) {
    _configuration = _StreamingConfigurationImpl(streamingConfigurationRefId);
  }

  static Future<StreamingAnalytics?> build({
    List<String>? includedPublishers,
    Map<String, String>? labels,
    bool? pauseOnBuffering,
    int? pauseOnBufferingInterval,
    int? keepAliveInterval,
    bool? keepAliveMeasurement,
    List<Map<String, int>>? heartbeatIntervals,
    bool? heartbeatMeasurement,
    int? customStartMinimumPlayback,
    bool? autoResumeStateOnAssetChange,
  }) async {
    Map<String, dynamic> config = <String, dynamic>{
      "includedPublishers": includedPublishers,
      Args.labels: labels,
      "pauseOnBuffering": pauseOnBuffering,
      "pauseOnBufferingInterval": pauseOnBufferingInterval,
      "keepAliveInterval": keepAliveInterval,
      "keepAliveMeasurement": keepAliveMeasurement,
      "heartbeatIntervals": heartbeatIntervals,
      "heartbeatMeasurement": heartbeatMeasurement,
      "customStartMinimumPlayback": customStartMinimumPlayback,
      "autoResumeStateOnAssetChange": autoResumeStateOnAssetChange,
    };

    var refIds = await _methodChannel.invokeMethod<Map?>('newInstance', config);
    if (refIds == null) {
      return null;
    }

    return StreamingAnalytics._init(refIds["streamingAnalyticsRefId"], refIds["streamingConfigurationRefId"]);
  }

  Future<StreamingExtendedAnalytics?> getExtendedAnalytics() async {
    if (_extendedAnalytics == null) {
      var refId = await _methodChannel.invokeMethod<String>('getExtendedAnalytics', buildArguments());
      if (refId != null) {
        _extendedAnalytics = StreamingExtendedAnalytics(refId);
      }
    }
    return Future.value(_extendedAnalytics);
  }

  ///  Sets a new playback session.
  ///
  Future<void> createPlaybackSession() {
    return _methodChannel.invokeMethod<void>('createPlaybackSession', buildArguments());
  }

  /// Notifies of the start from position
  /// @param position Position
  Future<void> startFromPosition(int position) {
    var args = buildArguments();
    args[Args.position] = position;
    return _methodChannel.invokeMethod<void>('startFromPosition', args);
  }

  ///  Notifies of a new Play event.
  Future<void> notifyPlay() {
    return _methodChannel.invokeMethod<void>('notifyPlay', buildArguments());
  }

  ///  Notifies of a new Pause event.
  Future<void> notifyPause() {
    return _methodChannel.invokeMethod<void>('notifyPause', buildArguments());
  }

  ///  Notifies of a new End event.
  Future<void> notifyEnd() {
    return _methodChannel.invokeMethod<void>('notifyEnd', buildArguments());
  }

  ///  Notifies of a new Buffer Start event.
  Future<void> notifyBufferStart() {
    return _methodChannel.invokeMethod<void>('notifyBufferStart', buildArguments());
  }

  ///  Notifies of a new Buffer End event.
  Future<void> notifyBufferStop() {
    return _methodChannel.invokeMethod<void>('notifyBufferStop', buildArguments());
  }

  /// Returns the ComScore log level.
  /// @see ComScoreLogLevel
  /// @return ComScore log level
  Future<void> notifySeekStart() {
    return _methodChannel.invokeMethod<void>('notifySeekStart', buildArguments());
  }

  ///  Clears offline cache
  Future<void> notifyChangePlaybackRate(double rate) {
    var args = buildArguments();
    args[Args.rate] = rate;
    return _methodChannel.invokeMethod<void>('notifyChangePlaybackRate', args);
  }

  ///  Adds a new listener to be notified of changes of states.
  ///
  ///  @param listener Must comply with StreamingListener
  Future<void> addListener(OnStreamingStateChange listener) {
    List<OnStreamingStateChange> listeners;
    if (!_onStreamingStateChangeListenerMap.containsKey(refId)) {
      listeners = [];
      _onStreamingStateChangeListenerMap[refId] = listeners;
    } else {
      listeners = _onStreamingStateChangeListenerMap[refId]!;
    }
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    } else {
      return Future.value();
    }
    if (_onStreamingStateChangeStream == null) {
      _onStreamingStateChangeStream = EventChannelStreamHelper().getStream(
        EventChannelStreamHelper.streamingStateChangeListenerEventChannel,
      );
      _onStreamingStateChangeStream!.listen(_onEventStream);
    }
    return _methodChannel.invokeMethod('addListener', buildArguments());
  }

  static _onEventStream(event) {
    String refId = event[Args.refId];
    int oldState = event["oldState"];
    int newState = event["newState"];
    Map result = event["eventLabels"];
    var callbacks = _onStreamingStateChangeListenerMap[refId];
    if (callbacks != null) {
      for (var callback in callbacks) {
        callback(
          StreamingState.getByValue(oldState),
          StreamingState.getByValue(newState),
          Map<String, String>.unmodifiable(result),
        );
      }
    }
  }

  ///  Removes the given listener
  Future<void> removeListener(OnStreamingStateChange listener) {
    var listeners = _onStreamingStateChangeListenerMap[refId];
    if (listeners?.isEmpty == true) {
      return Future.value();
    }
    listeners?.remove(listener);
    if (listeners?.isEmpty == true) {
      return _methodChannel.invokeMethod('removeListener', buildArguments());
    }
    return Future.value();
  }

  /// Sets the DVR window length.
  Future<void> setDvrWindowLength(int newDvrWindowLength) {
    var args = buildArguments();
    args[Args.dvrWindow] = newDvrWindowLength;
    return _methodChannel.invokeMethod<void>('setDvrWindowLength', args);
  }

  /// Sets the DVR window offset.
  Future<void> startFromDvrWindowOffset(int newDvrWindowOffset) {
    var args = buildArguments();
    args[Args.dvrWindow] = newDvrWindowOffset;
    return _methodChannel.invokeMethod<void>('startFromDvrWindowOffset', args);
  }

  /// Sets the media player name
  /// @param mediaPlayerName Media player name
  Future<void> setMediaPlayerName(String mediaPlayerName) {
    var args = buildArguments();
    args[Args.mediaPlayerName] = mediaPlayerName;
    return _methodChannel.invokeMethod<void>('setMediaPlayerName', args);
  }

  /// Sets the media player version
  /// @param mediaPlayerVersion Media player version
  Future<void> setMediaPlayerVersion(String mediaPlayerVersion) {
    var args = buildArguments();
    args[Args.mediaPlayerVersion] = mediaPlayerVersion;
    return _methodChannel.invokeMethod<void>('setMediaPlayerVersion', args);
  }

  /// Sets the asset
  /// @param metadata the AssetMetadata instance with the new clip metadata.
  Future<void> setMetadata(AssetMetadata metadata) {
    var args = buildArguments();
    args[Args.metadata] = metadata.toMap();
    return _methodChannel.invokeMethod<void>('setMetadata', args);
  }

  /// Sets the Implementation ID
  /// @param implementationId Implementation ID
  Future<void> setImplementationId(String implementationId) {
    var args = buildArguments();
    args[Args.implementationId] = implementationId;
    return _methodChannel.invokeMethod<void>('setImplementationId', args);
  }

  /// Sets the project ID
  /// @param projectId Project ID
  Future<void> setProjectId(String projectId) {
    var args = buildArguments();
    args[Args.projectId] = projectId;
    return _methodChannel.invokeMethod<void>('setProjectId', args);
  }

  /// Returns Playback session ID
  /// @return Playback session ID
  Future<String?> getPlaybackSessionId() {
    return _methodChannel.invokeMethod<String>('getPlaybackSessionId', buildArguments());
  }

  /// Notifies about start from segment
  /// @param segmentNumber Segment Number
  Future<void> startFromSegment(int segmentNumber) {
    var args = buildArguments();
    args[Args.segmentNumber] = segmentNumber;
    return _methodChannel.invokeMethod<void>('startFromSegment', args);
  }

  /// Notifies about looping playback session
  Future<void> loopPlaybackSession() {
    return _methodChannel.invokeMethod<void>('loopPlaybackSession', buildArguments());
  }
}

class _StreamingConfigurationImpl extends TrackableObject implements StreamingConfiguration {
  static const _methodChannel = MethodChannel("com.comscore.streaming.streamingConfiguration");

  _StreamingConfigurationImpl(super.refId);

  @override
  Future<void> setLabel(String name, String value) {
    var args = buildArguments();
    args[Args.labelName] = name;
    args[Args.labelValue] = value;
    return _methodChannel.invokeMethod('setLabel', args);
  }

  @override
  Future<StreamingPublisherConfiguration?> getStreamingPublisherConfiguration(String publisherId) async {
    var args = buildArguments();
    args[Args.publisherId] = publisherId;
    var refId = await _methodChannel.invokeMethod<String>('getStreamingPublisherConfiguration', args);
    if (refId == null) {
      return null;
    }
    return StreamingPublisherConfiguration.init(refId);
  }

  @override
  Future<void> removeAllLabels() {
    return _methodChannel.invokeMethod('removeAllLabels', buildArguments());
  }

  @override
  Future<void> removeLabel(String name) {
    var args = buildArguments();
    args[Args.labelName] = name;
    return _methodChannel.invokeMethod('removeLabel', args);
  }

  @override
  Future<void> addLabels(Map<String, String> labels) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod('addLabels', args);
  }
}
