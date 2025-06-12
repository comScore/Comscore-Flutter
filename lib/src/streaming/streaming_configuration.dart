import 'package:comscore_analytics_flutter/src/streaming/streaming_publisher_configuration.dart';

abstract class StreamingConfiguration {
  ///  Adds the given label, with the specified value.
  ///
  ///  @param name  Name
  ///  @param value Value
  Future<void> setLabel(String name, String value);

  /// Returns StreamingPublisherConfiguration object
  /// @param publisherId Publisher ID
  /// @return StreamingPublisherConfiguration object
  Future<StreamingPublisherConfiguration?> getStreamingPublisherConfiguration(
    String publisherId,
  );

  Future<void> removeAllLabels();

  Future<void> removeLabel(String name);

  Future<void> addLabels(Map<String, String> labels);
}
