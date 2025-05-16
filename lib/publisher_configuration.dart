import 'package:comscore_analytics_flutter/client_configuration.dart';

class PublisherConfiguration extends ClientConfiguration {
  PublisherConfiguration.init(super.refId);

  static Future<PublisherConfiguration?> build(
      {required String publisherId,
      bool? httpRedirectCaching,
      bool? keepAliveMeasurement,
      bool? secureTransmission,
      Map<String, String>? persistentLabels,
      Map<String, String>? startLabels}) async {
    var refId = await ClientConfiguration.newInstance(
        type: ClientConfigurationType.publisherConfiguration,
        clientId: publisherId,
        httpRedirectCaching: httpRedirectCaching,
        keepAliveMeasurement: keepAliveMeasurement,
        secureTransmission: secureTransmission,
        persistentLabels: persistentLabels,
        startLabels: startLabels);

    if (refId == null) {
      return null;
    }
    return PublisherConfiguration.init(refId);
  }

  /// Returns the publisher ID.
  Future<String?> getPublisherId() {
    return getClientId(ClientConfigurationType.publisherConfiguration);
  }
}
