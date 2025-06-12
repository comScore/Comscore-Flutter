import 'package:comscore_analytics_flutter/src/streaming/streaming_time.dart';
import 'package:comscore_analytics_flutter/src/streaming/streaming_date.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_delivery_advertisement_capability.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_delivery_composition.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_delivery_mode.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_delivery_subscription_type.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_distribution_model.dart';
import 'package:comscore_analytics_flutter/src/streaming/content_media_format.dart';
import 'package:comscore_analytics_flutter/src/streaming/stacked_metadata.dart';

class StackedContentMetadata extends StackedMetadata {
  final Map<String, String>? labels;

  /// Used to populate label ns_st_ci
  final String? uniqueId;

  /// Used to populate label ns_st_pu
  final String? publisherName;

  /// Used to populate label ns_st_pr
  final String? programTitle;

  /// Used to populate label ns_st_ep
  final String? episodeTitle;

  /// Used to populate label ns_st_sn
  final String? episodeSeasonNumber;

  /// Used to populate label ns_st_en
  final String? episodeNumber;

  /// Used to populate label ns_st_ge
  final String? genreName;

  /// Used to populate label ns_st_tge
  final String? genreId;

  /// Used to populate label ns_st_dt
  final Date? productionDate;

  /// Used to populate label ns_st_tm
  final Time? productionTime;

  /// Used to populate label ns_st_ddt
  final Date? digitalAiringDate;

  /// Used to populate label ns_st_dtm.
  final Time? digitalAiringTime;

  /// Used to populate label ns_st_tdt
  final Date? tvAiringDate;

  /// Used to populate label ns_st_ttm
  final Time? tvAiringTime;

  /// Used to populate label ns_st_st
  final String? stationTitle;

  /// Used to populate label ns_st_stc
  final String? stationCode;

  /// Used to populate label ns_st_tpr
  final String? programId;

  /// Used to populate label ns_st_tep
  final String? episodeId;

  /// Used to populate label ns_st_sta
  final String? networkAffiliate;

  /// Used to populate label ns_st_fee
  final int? fee;

  /// Used to populate label ns_st_pl
  final String? playlistTitle;
  final String? dictionaryClassificationC3;
  final String? dictionaryClassificationC4;
  final String? dictionaryClassificationC6;
  ContentDeliveryMode? deliveryMode;
  ContentDeliverySubscriptionType? deliverySubscriptionType;
  ContentDeliveryComposition? deliveryComposition;
  ContentDeliveryAdvertisementCapability? deliveryAdvertisementCapability;
  ContentDistributionModel? distributionModel;
  ContentMediaFormat? mediaFormat;

  StackedContentMetadata({
    Map<String, String>? customLabels,
    this.uniqueId,
    this.publisherName,
    this.programTitle,
    this.episodeTitle,
    this.episodeSeasonNumber,
    this.episodeNumber,
    this.genreName,
    this.genreId,
    this.productionDate,
    this.productionTime,
    this.digitalAiringDate,
    this.digitalAiringTime,
    this.tvAiringDate,
    this.tvAiringTime,
    this.stationTitle,
    this.stationCode,
    this.programId,
    this.episodeId,
    this.networkAffiliate,
    this.fee,
    this.playlistTitle,
    this.dictionaryClassificationC3,
    this.dictionaryClassificationC4,
    this.dictionaryClassificationC6,
    this.deliveryMode,
    this.deliverySubscriptionType,
    this.deliveryComposition,
    this.deliveryAdvertisementCapability,
    this.distributionModel,
    this.mediaFormat,
  }) : labels = Map.unmodifiable(customLabels ?? {});

  @override
  Map<String, dynamic> toMap() {
    return {
      "type": "stackedContentMetadata",
      "labels": labels,
      "uniqueId": uniqueId,
      "publisherName": publisherName,
      "programTitle": programTitle,
      "episodeTitle": episodeTitle,
      "episodeSeasonNumber": episodeSeasonNumber,
      "episodeNumber": episodeNumber,
      "genreName": genreName,
      "genreId": genreId,
      "productionDate": productionDate?.toMap(),
      "productionTime": productionTime?.toMap(),
      "digitalAiringDate": digitalAiringDate?.toMap(),
      "digitalAiringTime": digitalAiringTime?.toMap(),
      "tvAiringDate": tvAiringDate?.toMap(),
      "tvAiringTime": tvAiringTime?.toMap(),
      "stationTitle": stationTitle,
      "stationCode": stationCode,
      "programId": programId,
      "episodeId": episodeId,
      "networkAffiliate": networkAffiliate,
      "fee": fee,
      "playlistTitle": playlistTitle,
      "dictionaryClassificationC3": dictionaryClassificationC3,
      "dictionaryClassificationC4": dictionaryClassificationC4,
      "dictionaryClassificationC6": dictionaryClassificationC6,
      "deliveryMode": deliveryMode?.value,
      "deliverySubscriptionType": deliverySubscriptionType?.value,
      "deliveryComposition": deliveryComposition?.value,
      "deliveryAdvertisementCapability": deliveryAdvertisementCapability?.value,
      "distributionModel": distributionModel?.value,
      "mediaFormat": mediaFormat?.value,
    };
  }
}
