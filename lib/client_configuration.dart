import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';
import 'package:flutter/services.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object_extension.dart';

enum ClientConfigurationType { publisherConfiguration, partnerConfiguration }

abstract class ClientConfiguration extends TrackableObject {
  static const _methodChannel = MethodChannel("com.comscore.clientConfiguration");

  ClientConfiguration(super.refId);

  static Future<String?> newInstance(
      {required String clientId,
      required ClientConfigurationType type,
      bool? httpRedirectCaching,
      bool? keepAliveMeasurement,
      bool? secureTransmission,
      Map<String, String>? persistentLabels,
      Map<String, String>? startLabels,
      Map<String, String?>? other}) async {
    Map<String, dynamic> values = <String, dynamic>{
      Args.type: type.name,
      'clientId': clientId,
      'httpRedirectCaching': httpRedirectCaching,
      "keepAliveMeasurement": keepAliveMeasurement,
      "secureTransmission": secureTransmission,
      "persistentLabels": persistentLabels,
      "startLabels": startLabels
    };
    if (other != null) {
      values.addAll(other);
    }
    return await _methodChannel.invokeMethod<String?>('newInstance', values);
  }

  Future<String?> getClientId(ClientConfigurationType type) {
    var args = buildArguments();
    args[Args.type] = type.name;
    return _methodChannel.invokeMethod('getClientId', args);
  }

  /// Removes all the persistent labels in this configuration.
  Future<void> removeAllPersistentLabels() {
    return _methodChannel.invokeMethod('removeAllPersistentLabels', buildArguments());
  }

  /// Returns a copy of the auto start labels in use.
  /// @return Copy of auto start labels
  Future<Map<String, String>?> getStartLabels() async {
    Map result = await _methodChannel.invokeMethod('getStartLabels', buildArguments());
    return Map<String, String>.unmodifiable(result);
  }

  /// Removes an specific persistent label using the name.
  /// @param name Name of the label to remove
  Future<void> removePersistentLabel(String name) {
    var args = buildArguments();
    args[Args.labelName] = name;
    return _methodChannel.invokeMethod('removePersistentLabel', args);
  }

  /// Returns the value of the specified label. If more than one label needs to be checked use
  ///  ClientConfiguration#getPersistentLabels() to retrieve multiple labels.
  /// @param labelName Label name to retrieve the value
  /// @return The label name value
  Future<String?> getPersistentLabel(String labelName) {
    var args = buildArguments();
    args[Args.labelName] = labelName;
    return _methodChannel.invokeMethod('getPersistentLabel', args);
  }

  /// Sets a persistent label. If the label already exists it will be overridden with the new value
  /// and if the provided value is null the label will be removed. Persistent labels are included
  /// in all further events. Persistent labels overrides sdk labels but they can be overridden
  /// by event labels.
  /// @param name Label name
  /// @param value Label value to be set
  Future<void> setPersistentLabel(String labelName, String labelValue) {
    var args = buildArguments();
    args[Args.labelName] = labelName;
    args[Args.labelValue] = labelValue;
    return _methodChannel.invokeMethod('setPersistentLabel', args);
  }

  /// Returns a copy of the persistent labels in use
  /// @return Copy of the persistent labels
  Future<Map<String, String>?> getPersistentLabels() async {
    Map result = await _methodChannel.invokeMethod('getPersistentLabels', buildArguments());
    return Map<String, String>.unmodifiable(result);
  }

  ///  Returns true if the there's a label with the given name.
  ///
  ///  @param labelName Label to check if exists
  Future<bool?> containsPersistentLabel(String labelName) {
    var args = buildArguments();
    args[Args.labelName] = labelName;
    return _methodChannel.invokeMethod('containsPersistentLabel', args);
  }

  ///  Returns true if the there's a label with the given name.
  ///
  ///  @param labelName Label to check if exists
  Future<bool?> containsStartLabel(String labelName) {
    var args = buildArguments();
    args[Args.labelName] = labelName;
    return _methodChannel.invokeMethod('containsStartLabel', args);
  }

  /// Adds a group of persistent labels. Persistent labels are included in all further events.
  /// Persistent labels overrides sdk labels but can be overridden by event labels.
  /// @param labels Map of labels
  Future<void> addPersistentLabels(Map<String, String> labels) {
    var args = buildArguments();
    args[Args.labels] = labels;
    return _methodChannel.invokeMethod('addPersistentLabels', args);
  }

  /// Returns if the keep alive is enabled.
  /// @return True if keep alive is enabled, false otherwise
  Future<bool?> isKeepAliveMeasurementEnabled() {
    return _methodChannel.invokeMethod('isKeepAliveMeasurementEnabled', buildArguments());
  }

  /// Returns the secure mode value.
  /// @return True if is enabled, false otherwise
  Future<bool?> isSecureTransmissionEnabled() {
    return _methodChannel.invokeMethod('isSecureTransmissionEnabled', buildArguments());
  }

  ///  Indicates if http redirects should be cached or not.
  Future<bool?> isHttpRedirectCachingEnabled() {
    return _methodChannel.invokeMethod('isHttpRedirectCachingEnabled', buildArguments());
  }
}
