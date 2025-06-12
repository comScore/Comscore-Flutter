import 'package:comscore_analytics_flutter/src/streaming/stacked_metadata.dart';

class StackedAdvertisementMetadata extends StackedMetadata {
  final Map<String, String>? labels;

  /// Used to populate label ns_st_ami
  final String? uniqueId;

  /// Used to populate label ns_st_amt
  final String? title;

  /// Used to populate label ns_st_amg
  final String? serverCampaignId;

  /// Used to populate label ns_st_amp
  final String? placementId;

  /// Used to populate label ns_st_amw
  final String? siteId;

  /// Used to populate label ns_st_fee
  final int? fee;

  StackedAdvertisementMetadata({
    Map<String, String>? customLabels,
    this.fee,
    this.uniqueId,
    this.title,
    this.serverCampaignId,
    this.placementId,
    this.siteId,
  }) : labels = Map.unmodifiable(customLabels ?? {});

  @override
  Map<String, dynamic> toMap() {
    return {
      "type": "stackedAdvertisementMetadata",
      "labels": labels,
      "fee": fee,
      "uniqueId": uniqueId,
      "title": title,
      "serverCampaignId": serverCampaignId,
      "placementId": placementId,
      "siteId": siteId,
    };
  }
}
