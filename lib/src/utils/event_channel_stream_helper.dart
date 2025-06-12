import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EventChannelStreamHelper {
  static final EventChannelStreamHelper _instance =
      EventChannelStreamHelper._internal();

  static const crossPublisherChangeListenerEventChannel =
      "com.comscore.configuration.configuration_CrossPublisherUniqueDeviceIdChanged_channel";
  static const streamingStateChangeListenerEventChannel =
      "com.comscore.streaming.streamingAnalytics_OnStreamingStateChange_channel";

  final Map<String, EventChannel> _eventChannels = {};

  final Map<String, StreamController> _streamControllers = {};

  factory EventChannelStreamHelper() {
    return _instance;
  }

  EventChannelStreamHelper._internal() {
    if (kIsWeb) {
      _streamControllers[crossPublisherChangeListenerEventChannel] =
          StreamController();
      _streamControllers[streamingStateChangeListenerEventChannel] =
          StreamController();
    } else {
      _eventChannels[crossPublisherChangeListenerEventChannel] =
          const EventChannel(crossPublisherChangeListenerEventChannel);
      _eventChannels[streamingStateChangeListenerEventChannel] =
          const EventChannel(streamingStateChangeListenerEventChannel);
    }
  }

  Stream<dynamic> getStream(String name) {
    Stream<dynamic>? result;
    if (kIsWeb) {
      result = _streamControllers[name]?.stream;
    } else {
      result = _eventChannels[name]?.receiveBroadcastStream();
    }
    if (result == null) {
      throw Exception("Unable to find the stream for $name");
    }
    return result;
  }

  StreamController getStreamController(String name) {
    if (kIsWeb && _streamControllers.containsKey(name)) {
      return _streamControllers[name]!;
    }
    throw Exception("Unable to find the streamController for $name");
  }
}
