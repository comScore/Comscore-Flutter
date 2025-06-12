import 'package:comscore_analytics_flutter/src/client_configuration.dart';
import 'package:comscore_analytics_flutter/src/partner_configuration.dart';
import 'package:comscore_analytics_flutter/src/publisher_configuration.dart';
import 'package:comscore_analytics_flutter/src/live_transmission_mode.dart';
import 'package:comscore_analytics_flutter/src/offline_cache_mode.dart';
import 'package:comscore_analytics_flutter/src/usage_properties_auto_update_mode.dart';
import 'package:comscore_analytics_flutter/src/utils/args.dart';
import 'package:comscore_analytics_flutter/src/utils/event_channel_stream_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef OnCrossPublisherUniqueDeviceIdChange = void Function(String);

class Configuration {
  Configuration.private();

  @visibleForTesting
  final methodChannel = const MethodChannel("com.comscore.configuration");
  Stream? _crossPublisherUniqueDeviceIdChangeStream;
  final List<OnCrossPublisherUniqueDeviceIdChange>
  _onCrossPublisherUniqueDeviceIdChangeListenerList = [];

  Future<void> addClient(ClientConfiguration? client) async {
    if (client == null) {
      return;
    }
    await methodChannel.invokeMethod<void>('addClient', {
      Args.refId: client.refId,
    });
  }

  Future<void> enableImplementationValidationMode() {
    return methodChannel.invokeMethod('enableImplementationValidationMode');
  }

  void addCrossPublisherUniqueDeviceIdChangeListener(
    OnCrossPublisherUniqueDeviceIdChange callback,
  ) async {
    if (!_onCrossPublisherUniqueDeviceIdChangeListenerList.contains(callback)) {
      _onCrossPublisherUniqueDeviceIdChangeListenerList.add(callback);
    }
    if (_crossPublisherUniqueDeviceIdChangeStream == null) {
      _crossPublisherUniqueDeviceIdChangeStream = EventChannelStreamHelper()
          .getStream(
            EventChannelStreamHelper.crossPublisherChangeListenerEventChannel,
          );
      _crossPublisherUniqueDeviceIdChangeStream!.listen((event) {
        for (var callback
            in _onCrossPublisherUniqueDeviceIdChangeListenerList) {
          callback(event);
        }
      });
      methodChannel.invokeMethod(
        'addCrossPublisherUniqueDeviceIdChangeListener',
      );
    }
  }

  void removeCrossPublisherUniqueDeviceIdChangeListener(
    OnCrossPublisherUniqueDeviceIdChange callback,
  ) {
    _onCrossPublisherUniqueDeviceIdChangeListenerList.remove(callback);
  }

  /// Returns the PartnerConfiguration object for the specific partner ID
  /// @param partnerId Partner ID to retrieve.
  /// @return The PartnerConfiguration representing the partner ID or null if it does not exist
  Future<PartnerConfiguration?> getPartnerConfiguration(
    String partnerId,
  ) async {
    String? refId = await methodChannel.invokeMethod(
      'getPartnerConfiguration',
      {Args.partnerId: partnerId},
    );
    if (refId == null) {
      return null;
    }
    PartnerConfiguration partner = PartnerConfiguration.init(refId);
    return partner;
  }

  /// Returns the  PublisherConfiguration object for the specific publisher ID
  /// @param publisherId Publisher ID to retrieve.
  /// @return The  PublisherConfiguration representing the publisher ID or null if it does not exist
  Future<PublisherConfiguration?> getPublisherConfiguration(
    String publisherId,
  ) async {
    String? refId = await methodChannel.invokeMethod(
      'getPublisherConfiguration',
      {Args.publisherId: publisherId},
    );
    if (refId == null) {
      return null;
    }
    PublisherConfiguration publisher = PublisherConfiguration.init(refId);
    return publisher;
  }

  ///  Returns all  PublisherConfiguration objects
  /// @return List of all  PublisherConfiguration objects
  Future<List<PublisherConfiguration>> getPublisherConfigurations() async {
    List? refIdList = await methodChannel.invokeMethod(
      'getPublisherConfigurations',
    );
    if (refIdList == null) {
      return [];
    }
    List<PublisherConfiguration> publishers = [];
    for (var refId in refIdList) {
      publishers.add(PublisherConfiguration.init(refId));
    }
    return publishers;
  }

  ///  Returns all  PartnerConfiguration objects
  /// @return List of all  PartnerConfiguration objects
  Future<List<PartnerConfiguration>> getPartnerConfigurations() async {
    List? refIdList = await methodChannel.invokeMethod(
      'getPartnerConfigurations',
    );
    if (refIdList == null) {
      return [];
    }
    List<PartnerConfiguration> partners = [];
    for (var refId in refIdList) {
      partners.add(PartnerConfiguration.init(refId));
    }
    return partners;
  }

  /// Returns a copy of the label order used when sending events.
  /// @return Copy of the labels order.
  ///
  /// @see ClientConfiguration
  Future<List<String>?> getLabelOrder() async {
    var labelOrder = await methodChannel.invokeMethod('getLabelOrder');
    if (labelOrder == null) {
      return null;
    }
    return List.unmodifiable(labelOrder);
  }

  /// Sets the label order used while sending events. The labels are sorted following the
  /// specified order. If the order doesn't specify a label then that label will be added at
  /// the end not following any order.
  /// @param labelOrder Label order to follow when sending the event
  Future<void> setLabelOrder(List<String> labelOrder) {
    return methodChannel.invokeMethod('setLabelOrder', {
      Args.labelOrder: labelOrder,
    });
  }

  /// Sets the live end point URL.
  /// @param liveEndpointUrl Live Endpoint URL
  Future<void> setLiveEndpointUrl(String liveEndpointUrl) {
    return methodChannel.invokeMethod('setLiveEndpointUrl', {
      Args.liveEndpointUrl: liveEndpointUrl,
    });
  }

  /// Sets the offline flush end point URL.
  /// @param offlineFlushEndpointUrl Offline flush endpoint URL
  Future<void> setOfflineFlushEndpointUrl(String offlineFlushEndpointUrl) {
    return methodChannel.invokeMethod('setOfflineFlushEndpointUrl', {
      Args.offlineFlushEndpointUrl: offlineFlushEndpointUrl,
    });
  }

  /// Sets the application name. On some platforms like Android and iOS this information is
  /// retrieved automatically.
  /// @param appName Application name
  Future<void> setApplicationName(String appName) {
    return methodChannel.invokeMethod('setApplicationName', {
      Args.appName: appName,
    });
  }

  /// Sets the application version. On some platforms like Android and iOS this
  /// information is retrieved automatically.
  /// @param appVersion Application version
  Future<void> setApplicationVersion(String appVersion) {
    return methodChannel.invokeMethod('setApplicationVersion', {
      Args.appVersion: appVersion,
    });
  }

  /// Sets a persistent label. If the label exist it will override it with the new value
  /// and if the value is null the label will be removed. Persistent labels are included
  /// in all further events. Persistent labels overrides sdk labels but can be overridden
  /// by event labels.
  /// @param name Label name
  /// @param value Label value
  Future<void> setPersistentLabel(String name, String value) {
    return methodChannel.invokeMethod('setPersistentLabel', {
      Args.labelName: name,
      Args.labelValue: value,
    });
  }

  /// Removes all the persistent labels in this configuration.
  Future<void> removeAllPersistentLabels() {
    return methodChannel.invokeMethod('removeAllPersistentLabels');
  }

  /// Removes an specific persistent label using the name.
  /// @param name Name of the label to remove
  Future<void> removePersistentLabel(String name) {
    return methodChannel.invokeMethod('removePersistentLabel', {
      Args.labelName: name,
    });
  }

  /// Adds a group of persistent labels. Persistent labels are included in all further events.
  /// Persistent labels overrides sdk labels but can be overridden by event labels.
  /// @param labels Labels to be set
  Future<void> addPersistentLabels(Map<String, String> labels) {
    return methodChannel.invokeMethod('addPersistentLabels', {
      Args.labels: labels,
    });
  }

  /// Sets a start label. If the label exist it will override it with the new value
  /// and if the value is null the label will be removed. Persistent labels are included
  /// in all further events. Persistent labels overrides sdk labels but can be overridden
  /// by event labels.
  /// @param name Label name
  /// @param value Label value
  Future<void> setStartLabel(String name, String value) {
    return methodChannel.invokeMethod('setStartLabel', {
      Args.labelName: name,
      Args.labelValue: value,
    });
  }

  /// Removes all the start labels in this configuration.
  Future<void> removeAllStartLabels() {
    return methodChannel.invokeMethod('removeAllStartLabels');
  }

  /// Removes an specific start label using the name.
  /// @param name Name of the label to remove
  Future<void> removeStartLabel(String name) {
    return methodChannel.invokeMethod('removeStartLabel', {
      Args.labelName: name,
    });
  }

  /// Adds a group of start labels. Persistent labels are included in all further events.
  /// Persistent labels overrides sdk labels but can be overridden by event labels.
  /// @param labels Labels
  Future<void> addStartLabels(Map<String, String> labels) {
    return methodChannel.invokeMethod('addStartLabels', {Args.labels: labels});
  }

  /// Enables or disables the keep alive option.
  /// @param enabled Keep alive
  Future<void> setKeepAliveMeasurementEnabled(bool enabled) {
    return methodChannel.invokeMethod('setKeepAliveMeasurementEnabled', {
      Args.enabled: enabled,
    });
  }

  /// Sets the transmission mode. There are 3 modes:
  /// <ul>
  ///     <li>LiveTransmissionMode.cache</li>
  ///     <li>LiveTransmissionMode.lan</li>
  ///     <li>LiveTransmissionMode.standard</li>
  /// </ul>
  /// @see LiveTransmissionMode
  Future<void> setLiveTransmissionMode(
    LiveTransmissionMode liveTransmissionMode,
  ) {
    return methodChannel.invokeMethod('setLiveTransmissionMode', {
      Args.liveTransmissionMode: liveTransmissionMode.mode,
    });
  }

  /// Sets the offline cache mode. There are 3 modes:
  /// <ul>
  ///     <li>OfflineCacheMode.disabled</li>
  ///     <li>OfflineCacheMode.enabled</li>
  ///     <li>OfflineCacheMode.lan</li>
  ///     <li>OfflineCacheMode.manualFlush</li>
  /// </ul>
  /// @see OfflineCacheMode
  Future<void> setOfflineCacheMode(OfflineCacheMode offlineCacheMode) {
    return methodChannel.invokeMethod('setOfflineCacheMode', {
      Args.offlineCacheMode: offlineCacheMode.mode,
    });
  }

  /// UsagePropertiesAutoUpdateMode.foregroundOnly by default.
  /// @param usagePropertiesAutoUpdateMode Auto update mode for properties usage
  Future<void> setUsagePropertiesAutoUpdateMode(
    UsagePropertiesAutoUpdateMode usagePropertiesAutoUpdateMode,
  ) {
    return methodChannel.invokeMethod('setUsagePropertiesAutoUpdateMode', {
      Args.usagePropertiesAutoUpdateMode: usagePropertiesAutoUpdateMode.mode,
    });
  }

  /// Sets the the auto update of usage properties interval in seconds. The interval should be
  /// bigger or equal to 60.
  /// @param interval Interval in seconds
  Future<void> setUsagePropertiesAutoUpdateInterval(int interval) {
    return methodChannel.invokeMethod('setUsagePropertiesAutoUpdateInterval', {
      Args.interval: interval,
    });
  }

  /// Sets the maximum amount of measurements that can be cached.
  /// @param max Amount of measurements
  Future<void> setCacheMaxMeasurements(int max) {
    return methodChannel.invokeMethod('setCacheMaxMeasurements', {
      Args.max: max,
    });
  }

  /// Sets the maximum amount of measurements can be cached in a single file. This is only
  /// available for Android and iOS
  /// @param max Amount of measurements
  Future<void> setCacheMaxBatchFiles(int max) {
    return methodChannel.invokeMethod('setCacheMaxBatchFiles', {Args.max: max});
  }

  /// Sets the maximum amount flushes of cached measurements can be send in a row.
  /// @param max Maximum amount of flushed to be send
  Future<void> setCacheMaxFlushesInARow(int max) {
    return methodChannel.invokeMethod('setCacheMaxFlushesInARow', {
      Args.max: max,
    });
  }

  /// Sets the minimal time between cache flush retries, in case of failure.
  /// @param minutes Minutes to wait.
  Future<void> setCacheMinutesToRetry(int minutes) {
    return methodChannel.invokeMethod('setCacheMinutesToRetry', {
      Args.minutes: minutes,
    });
  }

  ///Sets the time after which the measurements in the cache should expire.
  /// @param days Days to keep cached measurements.
  Future<void> setCacheMeasurementExpiry(int days) {
    return methodChannel.invokeMethod('setCacheMeasurementExpiry', {
      Args.days: days,
    });
  }

  /// Indicates if tracking is enabled. When tracking is disabled, no
  /// measurement is sent and no data is collected.
  Future<bool?> isEnabled() {
    return methodChannel.invokeMethod('isEnabled');
  }

  /// Disables the Core. No measurements will be sent and no data will be collected.
  Future<void> disable() {
    return methodChannel.invokeMethod('disable');
  }

  /// Disables TCF integration.
  Future<void> disableTcfIntegration() {
    return methodChannel.invokeMethod('disableTcfIntegration');
  }

  /// Adds an included publisher.
  /// @param publisherId Publisher ID
  Future<void> addIncludedPublisher(String publisherId) {
    return methodChannel.invokeMethod('addIncludedPublisher', {
      Args.publisherId: publisherId,
    });
  }

  /// Sets the System Clock Jump Detection.
  /// @param isEnabled Set to true to enable, false to disable
  Future<void> setSystemClockJumpDetectionEnabled(bool enabled) {
    return methodChannel.invokeMethod('setSystemClockJumpDetectionEnabled', {
      Args.enabled: enabled,
    });
  }

  /// Sets the system clock jump detection interval.
  /// @param interval Check interval in seconds
  Future<void> setSystemClockJumpDetectionInterval(int interval) {
    return methodChannel.invokeMethod('setSystemClockJumpDetectionInterval', {
      Args.interval: interval,
    });
  }

  /// Sets the system clock jump detection precision.
  /// @param precision Precision
  Future<void> setSystemClockJumpDetectionPrecision(int precision) {
    return methodChannel.invokeMethod('setSystemClockJumpDetectionPrecision', {
      Args.precision: precision,
    });
  }

  /// Enables child directed application mode.
  Future<void> enableChildDirectedApplicationMode() {
    return methodChannel.invokeMethod('enableChildDirectedApplicationMode');
  }
}
