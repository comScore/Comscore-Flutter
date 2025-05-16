import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';
import 'package:flutter/services.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object_extension.dart';

class EventInfo extends TrackableObject {
  static const _methodChannel = MethodChannel("com.comscore.eventInfo");

  EventInfo._init(super.refId);

  static Future<EventInfo?> build() async {
    var refId = await _methodChannel.invokeMethod<String?>('newInstance');
    if (refId == null) {
      return null;
    }
    return EventInfo._init(refId);
  }

  /// Adds a dictionary as labels for the event. These labels will be sent for all the specified publishers.
  /// @param labels Labels to add
  Future<void> addLabels(Map<String, String> labels) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod('addLabels', args);
  }

  /// Sets a label for the event. This label will be sent for all the specified publishers.
  /// @param name Label name
  /// @param value Label value
  Future<void> setLabel(String name, String value) {
    var args = buildArguments();
    args[Args.labelName] = name;
    args[Args.labelValue] = value;
    return _methodChannel.invokeMethod('setLabel', args);
  }

  /// Adds a publisher specific labels. This labels will be only associated with the specified publisher.
  /// @param publisherId Publisher ID
  /// @param labels Labels to add
  Future<void> addPublisherLabels(String publisherId, Map<String, String> labels) {
    var args = buildArguments();
    args[Args.publisherId] = publisherId;
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod('addPublisherLabels', args);
  }

  /// Sets a publisher specific label. This labels will be only associated with the specified publisher.
  /// @param publisherId Publisher ID
  /// @param name Label name
  /// @param value Label value
  Future<void> setPublisherLabel(String publisherId, String name, String value) {
    var args = buildArguments();
    args[Args.publisherId] = publisherId;
    args[Args.labelName] = name;
    args[Args.labelValue] = value;
    return _methodChannel.invokeMethod('setPublisherLabel', args);
  }

  /// Adds a publisher if it doesn't exist.
  /// @param publisherId Publisher ID to add
  Future<void> addIncludedPublisher(String publisherId) {
    var args = buildArguments();
    args[Args.publisherId] = publisherId;
    return _methodChannel.invokeMethod('addIncludedPublisher', args);
  }
}
