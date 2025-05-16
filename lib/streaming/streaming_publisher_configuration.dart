import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';
import 'package:flutter/services.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object_extension.dart';

class StreamingPublisherConfiguration extends TrackableObject {
  StreamingPublisherConfiguration.init(super.refId);
  static const _methodChannel = MethodChannel("com.comscore.streaming.streamingPublisherConfiguration");

  Future<void> removeAllLabels() {
    return _methodChannel.invokeMethod('removeAllLabels', buildArguments());
  }

  Future<void> removeLabel(String name) {
    var args = buildArguments();
    args[Args.labelName] = name;
    return _methodChannel.invokeMethod('removeLabel', args);
  }

  Future<void> setLabel(String name, String value) {
    var args = buildArguments();
    args[Args.labelName] = name;
    args[Args.labelValue] = value;
    return _methodChannel.invokeMethod('setLabel', args);
  }

  Future<void> addLabels(Map<String, String> labels) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod('addLabels', args);
  }
}
