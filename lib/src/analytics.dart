import 'package:comscore_analytics_flutter/src/configuration.dart';
import 'package:comscore_analytics_flutter/src/event_info.dart';
import 'package:comscore_analytics_flutter/src/log_level.dart';
import 'package:comscore_analytics_flutter/src/utils/connector.dart';
import 'package:flutter/services.dart';
import 'package:comscore_analytics_flutter/src/utils/args.dart';

class Analytics {
  Analytics._();

  static const _methodChannel = MethodChannel("com.comscore.analytics");
  static Configuration get configuration => Configuration.private();

  /// Start the ComScore SDK with the default configuration. The startup logic will take place in
  /// a background thread.
  /// @param context Required context to initialize the SDK
  static Future<void> start() async {
    Analytics.configuration.setPersistentLabel("ns_ap_cv", Connector.version);
    Analytics.configuration.setPersistentLabel(
      "ns_ap_pfm",
      Connector.platformName,
    );
    // Analytics.configuration.setPersistentLabel("ns_ap_pv", ); // It is not possible to retrieve the flutter version
    await _methodChannel.invokeMethod<void>('start');
  }

  /// Gets the ComScore SDK version.
  ///
  /// @return ComScore SDK version.
  static Future<String?> getVersion() {
    return _methodChannel.invokeMethod<String>('getVersion');
  }

  /// Notifies in a background thread a view event using the EventInfo object.
  /// The labels passed in the EventInfo will override any sdk or persistent
  /// label.
  ///
  /// @param eventInfo Information to send in the event.
  /// @param labels Labels that should be added to the event.
  static Future<void> notifyViewEvent({
    EventInfo? eventInfo,
    Map<String, String>? labels,
  }) {
    var args = <String, dynamic>{
      Args.eventInfoRefId: eventInfo?.refId,
      Args.labels: labels,
    };
    return _methodChannel.invokeMethod<void>('notifyViewEvent', args);
  }

  /// Notifies in a background thread a hidden event using the EventInfo object.
  /// The labels passed in the EventInfo will override any sdk or persistent
  /// label.
  ///
  /// @param eventInfo Information to send in the event.
  static Future<void> notifyHiddenEvent({
    EventInfo? eventInfo,
    Map<String, String>? labels,
  }) {
    var args = <String, dynamic>{
      Args.eventInfoRefId: eventInfo?.refId,
      Args.labels: labels,
    };
    return _methodChannel.invokeMethod<void>('notifyHiddenEvent', args);
  }

  /// Notifies that an application is in the foreground. Several application components
  /// can be notified in the foreground because several calls to this methods are stacked but each
  /// of these application components should be unstacked when they exit foreground by calling
  /// notifyExitForeground().
  static Future<void> notifyEnterForeground() {
    return _methodChannel.invokeMethod<void>('notifyEnterForeground');
  }

  /// Notifies that an application exists the foreground state. Several application components
  /// can be notified in the foreground because several calls to this methods are stacked but each
  /// of these application components should be unstacked when they exit foreground by calling
  /// notifyEnterForeground().
  static Future<void> notifyExitForeground() {
    return _methodChannel.invokeMethod<void>('notifyExitForeground');
  }

  /// Call this method to notify that the application is executing a task that provides a user
  /// experience (e.g. playing music). Several calls to this method are stacked so multiple user
  /// experience tasks can be notified but each task should be unstacked using
  /// notifyUxInactive.
  static Future<void> notifyUxActive() {
    return _methodChannel.invokeMethod<void>('notifyUxActive');
  }

  /// Call this method to notify that the application finished executing a task that provides a
  /// user experience (e.g. playing music). If several user experience tasks were notified using
  /// notifyUxActive(). each of those tasks should notify they ended by calling
  /// this method. If no user experience tasks were notified using notifyUxActive()
  /// then calling this method has no effect. All
  static Future<void> notifyUxInactive() {
    return _methodChannel.invokeMethod<void>('notifyUxInactive');
  }

  /// Flushes offline cached measurements.
  static Future<void> flushOfflineCache() {
    return _methodChannel.invokeMethod<void>('flushOfflineCache');
  }

  /// Change the log level of the comScore SDK.
  /// to define the logging level.
  ///
  /// @param level Log level
  ///
  /// @see ComScoreLogLevel
  static Future<void> setLogLevel(ComScoreLogLevel level) {
    return _methodChannel.invokeMethod<void>('setLogLevel', level.level);
  }

  /// Returns the ComScore log level.
  /// @see ComScoreLogLevel
  /// @return ComScore log level
  static Future<ComScoreLogLevel?> getLogLevel() async {
    var rawLogLevel = await _methodChannel.invokeMethod<int?>('getLogLevel');
    return ComScoreLogLevel.getByValue(rawLogLevel ?? 0);
  }

  ///  Clears offline cache
  static Future<void> clearOfflineCache() {
    return _methodChannel.invokeMethod<void>('clearOfflineCache');
  }

  ///  Clears internal data
  static Future<void> clearInternalData() {
    return _methodChannel.invokeMethod<void>('clearInternalData');
  }

  /// Notifies about distributed content view event
  /// @param distributorPartnerId Distributed partner ID
  /// @param distributorContentId Distributed content ID
  static Future<void> notifyDistributedContentViewEvent(
    String distributorPartnerId,
    String distributorContentId,
  ) {
    var args = <String, dynamic>{
      Args.distributorPartnerId: distributorPartnerId,
      Args.distributorContentId: distributorContentId,
    };
    return _methodChannel.invokeMethod<void>(
      'notifyDistributedContentViewEvent',
      args,
    );
  }
}
