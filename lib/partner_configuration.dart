import 'package:comscore_analytics_flutter/client_configuration.dart';

class PartnerConfiguration extends ClientConfiguration {
  PartnerConfiguration.init(super.refId);

  static Future<PartnerConfiguration?> build(
      {required String partnerId,
      bool? httpRedirectCaching,
      bool? keepAliveMeasurement,
      bool? secureTransmission,
      Map<String, String>? persistentLabels,
      Map<String, String>? startLabels,
      String? externalClientId}) async {
    var refId = await ClientConfiguration.newInstance(
        type: ClientConfigurationType.partnerConfiguration,
        clientId: partnerId,
        httpRedirectCaching: httpRedirectCaching,
        keepAliveMeasurement: keepAliveMeasurement,
        secureTransmission: secureTransmission,
        persistentLabels: persistentLabels,
        startLabels: startLabels,
        other: {"externalClientId": externalClientId});

    if (refId == null) {
      return null;
    }
    return PartnerConfiguration.init(refId);
  }

  /// Returns the partner ID.
  Future<String?> getPartnerId() {
    return getClientId(ClientConfigurationType.partnerConfiguration);
  }
}
