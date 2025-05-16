import 'package:comscore_analytics_flutter/streaming/content_type.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_date.dart';
import 'package:comscore_analytics_flutter/streaming/asset_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/content_delivery_advertisement_capability.dart';
import 'package:comscore_analytics_flutter/streaming/content_delivery_composition.dart';
import 'package:comscore_analytics_flutter/streaming/content_delivery_mode.dart';
import 'package:comscore_analytics_flutter/streaming/content_delivery_subscription_type.dart';
import 'package:comscore_analytics_flutter/streaming/content_distribution_model.dart';
import 'package:comscore_analytics_flutter/streaming/content_feed_type.dart';
import 'package:comscore_analytics_flutter/streaming/content_media_format.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_time.dart';
import 'package:comscore_analytics_flutter/streaming/stacked_content_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_dimensions.dart';

class ContentMetadata extends AssetMetadata {
  final Map<String, StackedContentMetadata> stack;
  final Map<String, String> customLabels;

  /// Used to populate labels ns_st_ct and ns_st_li
  final ContentType? mediaType;

  /// Used to populate labels ns_st_ct and ns_st_ty
  final bool? classifyAsAudioStream;

  /// Used to populate label ns_st_ce
  final bool? classifyAsCompleteEpisode;

  /// Used to populate label ns_st_ia
  final bool? carryTvAdvertisementLoad;

  /// Used to populate label ns_st_ci
  final String? uniqueId;

  /// Used to populate label ns_st_cl
  final int? length;

  /// Used to populate label ns_st_tp
  final int? totalSegments;

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

  /// Used to populate label ns_st_dtm
  final Time? digitalAiringTime;

  /// Used to populate label ns_st_tdt
  final Date? tvAiringDate;

  /// Used to populate label ns_st_ttm.
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

  /// Used to populate label ns_st_cu
  final String? clipUrl;

  /// Used to populate label ns_st_pl
  final String? playlistTitle;

  /// Used to populate label ns_st_ft
  final ContentFeedType? feedType;

  /// Used to populate label ns_st_cs
  final Dimensions? videoDimensions;
  final String? dictionaryClassificationC3;
  final String? dictionaryClassificationC4;
  final String? dictionaryClassificationC6;
  final ContentDeliveryMode? deliveryMode;
  final ContentDeliverySubscriptionType? deliverySubscriptionType;
  final ContentDeliveryComposition? deliveryComposition;
  final ContentDeliveryAdvertisementCapability? deliveryAdvertisementCapability;
  final ContentDistributionModel? distributionModel;
  final ContentMediaFormat? mediaFormat;

  ContentMetadata._(
      {Map<String, StackedContentMetadata>? stack,
      Map<String, String>? customLabels,
      this.mediaType,
      this.classifyAsAudioStream,
      this.classifyAsCompleteEpisode,
      this.carryTvAdvertisementLoad,
      this.uniqueId,
      this.length,
      this.totalSegments,
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
      this.clipUrl,
      this.playlistTitle,
      this.feedType,
      this.videoDimensions,
      this.dictionaryClassificationC3,
      this.dictionaryClassificationC4,
      this.dictionaryClassificationC6,
      this.deliveryMode,
      this.deliverySubscriptionType,
      this.deliveryComposition,
      this.deliveryAdvertisementCapability,
      this.distributionModel,
      this.mediaFormat})
      : customLabels = Map.unmodifiable(customLabels ?? {}),
        stack = Map.unmodifiable(stack ?? {});

  @override
  Map<String, dynamic> toMap() {
    return {
      "type": "contentMetadata",
      "stack": stack.map(((key, value) => MapEntry(key, value.toMap()))),
      "labels": customLabels,
      "mediaType": mediaType?.value,
      "classifyAsAudioStream": classifyAsAudioStream,
      "classifyAsCompleteEpisode": classifyAsCompleteEpisode,
      "carryTvAdvertisementLoad": carryTvAdvertisementLoad,
      "uniqueId": uniqueId,
      "length": length,
      "totalSegments": totalSegments,
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
      "clipUrl": clipUrl,
      "playlistTitle": playlistTitle,
      "feedType": feedType?.value,
      "videoDimensions": videoDimensions?.toMap(),
      "dictionaryClassificationC3": dictionaryClassificationC3,
      "dictionaryClassificationC4": dictionaryClassificationC4,
      "dictionaryClassificationC6": dictionaryClassificationC6,
      "deliveryMode": deliveryMode?.value,
      "deliveryComposition": deliverySubscriptionType?.value,
      "deliveryAdvertisementCapability": deliveryComposition?.value,
      "contentDeliveryAdvertisementCapability": deliveryAdvertisementCapability?.value,
      "distributionModel": distributionModel?.value,
      "mediaFormat": mediaFormat?.value
    };
  }
  static ContentMetadataBuilder builder() => ContentMetadataBuilder();

}

class ContentMetadataBuilder {
  Map<String, StackedContentMetadata> _stack = {};
  Map<String, String> _customLabels = {};
  ContentType? _mediaType;
  bool? _classifyAsAudioStream;
  bool? _classifyAsCompleteEpisode;
  bool? _carryTvAdvertisementLoad;
  String? _uniqueId;
  int? _length;
  int? _totalSegments;
  String? _publisherName;
  String? _programTitle;
  String? _episodeTitle;
  String? _episodeSeasonNumber;
  String? _episodeNumber;
  String? _genreName;
  String? _genreId;
  Date? _productionDate;
  Time? _productionTime;
  Date? _digitalAiringDate;
  Time? _digitalAiringTime;
  Date? _tvAiringDate;
  Time? _tvAiringTime;
  String? _stationTitle;
  String? _stationCode;
  String? _programId;
  String? _episodeId;
  String? _networkAffiliate;
  int? _fee;
  String? _clipUrl;
  String? _playlistTitle;
  ContentFeedType? _feedType;
  Dimensions? _videoDimensions;
  String? _dictionaryClassificationC3;
  String? _dictionaryClassificationC4;
  String? _dictionaryClassificationC6;
  ContentDeliveryMode? _deliveryMode;
  ContentDeliverySubscriptionType? _deliverySubscriptionType;
  ContentDeliveryComposition? _deliveryComposition;
  ContentDeliveryAdvertisementCapability? _deliveryAdvertisementCapability;
  ContentDistributionModel? _distributionModel;
  ContentMediaFormat? _mediaFormat;

  ContentMetadataBuilder stack(Map<String, StackedContentMetadata> stack) {
    _stack = stack;
    return this;
  }

  ContentMetadataBuilder customLabels(Map<String, String> labels) {
    _customLabels = labels;
    return this;
  }

  ContentMetadataBuilder mediaType(ContentType mediaType) {
    _mediaType = mediaType;
    return this;
  }

  ContentMetadataBuilder classifyAsAudioStream(bool classifyAsAudioStream) {
    _classifyAsAudioStream = classifyAsAudioStream;
    return this;
  }

  ContentMetadataBuilder classifyAsCompleteEpisode(bool classifyAsCompleteEpisode) {
    _classifyAsCompleteEpisode = classifyAsCompleteEpisode;
    return this;
  }

  ContentMetadataBuilder carryTvAdvertisementLoad(bool carryTvAdvertisementLoad) {
    _carryTvAdvertisementLoad = carryTvAdvertisementLoad;
    return this;
  }

  ContentMetadataBuilder uniqueId(String uniqueId) {
    _uniqueId = uniqueId;
    return this;
  }

  ContentMetadataBuilder length(int length) {
    _length = length;
    return this;
  }

  ContentMetadataBuilder totalSegments(int totalSegments) {
    _totalSegments = totalSegments;
    return this;
  }

  ContentMetadataBuilder publisherName(String publisherName) {
    _publisherName = publisherName;
    return this;
  }

  ContentMetadataBuilder programTitle(String programTitle) {
    _programTitle = programTitle;
    return this;
  }

  ContentMetadataBuilder episodeTitle(String episodeTitle) {
    _episodeTitle = episodeTitle;
    return this;
  }

  ContentMetadataBuilder episodeSeasonNumber(String episodeSeasonNumber) {
    _episodeSeasonNumber = episodeSeasonNumber;
    return this;
  }

  ContentMetadataBuilder episodeNumber(String episodeNumber) {
    _episodeNumber = episodeNumber;
    return this;
  }

  ContentMetadataBuilder genreName(String genreName) {
    _genreName = genreName;
    return this;
  }

  ContentMetadataBuilder genreId(String genreId) {
    _genreId = genreId;
    return this;
  }

  ContentMetadataBuilder productionDate(Date productionDate) {
    _productionDate = productionDate;
    return this;
  }

  ContentMetadataBuilder productionTime(Time productionTime) {
    _productionTime = productionTime;
    return this;
  }

  ContentMetadataBuilder digitalAiringDate(Date digitalAiringDate) {
    _digitalAiringDate = digitalAiringDate;
    return this;
  }

  ContentMetadataBuilder digitalAiringTime(Time digitalAiringTime) {
    _digitalAiringTime = digitalAiringTime;
    return this;
  }

  ContentMetadataBuilder tvAiringDate(Date tvAiringDate) {
    _tvAiringDate = tvAiringDate;
    return this;
  }

  ContentMetadataBuilder tvAiringTime(Time tvAiringTime) {
    _tvAiringTime = tvAiringTime;
    return this;
  }

  ContentMetadataBuilder stationTitle(String stationTitle) {
    _stationTitle = stationTitle;
    return this;
  }

  ContentMetadataBuilder stationCode(String stationCode) {
    _stationCode = stationCode;
    return this;
  }

  ContentMetadataBuilder programId(String programId) {
    _programId = programId;
    return this;
  }

  ContentMetadataBuilder episodeId(String episodeId) {
    _episodeId = episodeId;
    return this;
  }

  ContentMetadataBuilder networkAffiliate(String networkAffiliate) {
    _networkAffiliate = networkAffiliate;
    return this;
  }

  ContentMetadataBuilder fee(int fee) {
    _fee = fee;
    return this;
  }

  ContentMetadataBuilder clipUrl(String clipUrl) {
    _clipUrl = clipUrl;
    return this;
  }

  ContentMetadataBuilder playlistTitle(String playlistTitle) {
    _playlistTitle = playlistTitle;
    return this;
  }

  ContentMetadataBuilder feedType(ContentFeedType feedType) {
    _feedType = feedType;
    return this;
  }

  ContentMetadataBuilder videoDimensions(Dimensions videoDimensions) {
    _videoDimensions = videoDimensions;
    return this;
  }

  ContentMetadataBuilder dictionaryClassificationC3(String dictionaryClassificationC3) {
    _dictionaryClassificationC3 = dictionaryClassificationC3;
    return this;
  }

  ContentMetadataBuilder dictionaryClassificationC4(String dictionaryClassificationC4) {
    _dictionaryClassificationC4 = dictionaryClassificationC4;
    return this;
  }

  ContentMetadataBuilder dictionaryClassificationC6(String dictionaryClassificationC6) {
    _dictionaryClassificationC6 = dictionaryClassificationC6;
    return this;
  }

  ContentMetadataBuilder deliveryMode(ContentDeliveryMode deliveryMode) {
    _deliveryMode = deliveryMode;
    return this;
  }

  ContentMetadataBuilder deliverySubscriptionType(ContentDeliverySubscriptionType deliverySubscriptionType) {
    _deliverySubscriptionType = deliverySubscriptionType;
    return this;
  }

  ContentMetadataBuilder deliveryComposition(ContentDeliveryComposition deliveryComposition) {
    _deliveryComposition = deliveryComposition;
    return this;
  }

  ContentMetadataBuilder deliveryAdvertisementCapability(ContentDeliveryAdvertisementCapability deliveryAdvertisementCapability) {
    _deliveryAdvertisementCapability = deliveryAdvertisementCapability;
    return this;
  }

  ContentMetadataBuilder distributionModel(ContentDistributionModel distributionModel) {
    _distributionModel = distributionModel;
    return this;
  }

  ContentMetadataBuilder mediaFormat(ContentMediaFormat mediaFormat) {
    _mediaFormat = mediaFormat;
    return this;
  }

  ContentMetadata build() {
    return ContentMetadata._(
      stack: Map.unmodifiable(_stack),
      customLabels: Map.unmodifiable(_customLabels),
      mediaType: _mediaType,
      classifyAsAudioStream: _classifyAsAudioStream,
      classifyAsCompleteEpisode: _classifyAsCompleteEpisode,
      carryTvAdvertisementLoad: _carryTvAdvertisementLoad,
      uniqueId: _uniqueId,
      length: _length,
      totalSegments: _totalSegments,
      publisherName: _publisherName,
      programTitle: _programTitle,
      episodeTitle: _episodeTitle,
      episodeSeasonNumber: _episodeSeasonNumber,
      episodeNumber: _episodeNumber,
      genreName: _genreName,
      genreId: _genreId,
      productionDate: _productionDate,
      productionTime: _productionTime,
      digitalAiringDate: _digitalAiringDate,
      digitalAiringTime: _digitalAiringTime,
      tvAiringDate: _tvAiringDate,
      tvAiringTime: _tvAiringTime,
      stationTitle: _stationTitle,
      stationCode: _stationCode,
      programId: _programId,
      episodeId: _episodeId,
      networkAffiliate: _networkAffiliate,
      fee: _fee,
      clipUrl: _clipUrl,
      playlistTitle: _playlistTitle,
      feedType: _feedType,
      videoDimensions: _videoDimensions,
      dictionaryClassificationC3: _dictionaryClassificationC3,
      dictionaryClassificationC4: _dictionaryClassificationC4,
      dictionaryClassificationC6: _dictionaryClassificationC6,
      deliveryMode: _deliveryMode,
      deliverySubscriptionType: _deliverySubscriptionType,
      deliveryComposition: _deliveryComposition,
      deliveryAdvertisementCapability: _deliveryAdvertisementCapability,
      distributionModel: _distributionModel,
      mediaFormat: _mediaFormat,
    );
  }
}
