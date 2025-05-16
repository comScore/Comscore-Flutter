import 'package:comscore_analytics_flutter/streaming/advertisement_delivery_type.dart';
import 'package:comscore_analytics_flutter/streaming/advertisement_owner.dart';
import 'package:comscore_analytics_flutter/streaming/advertisement_type.dart';
import 'package:comscore_analytics_flutter/streaming/asset_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/content_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/stacked_advertisement_metadata.dart';
import 'package:comscore_analytics_flutter/streaming/streaming_dimensions.dart';

class AdvertisementMetadata extends AssetMetadata {
  final Map<String, StackedAdvertisementMetadata> stack;
  final Map<String, String> customLabels;
  final ContentMetadata? relatedContentMetadata;

  /// Used to populate labels ns_st_ct, ns_st_li and ns_st_ad
  final AdvertisementType? mediaType;

  /// Used to populate labels ns_st_ct and ns_st_ty
  final bool? classifyAsAudioStream;

  /// Used to populate label ns_st_cs
  final Dimensions? videoDimensions;

  /// Used to populate label ns_st_cl
  final int? length;

  /// Used to populate label ns_st_fee
  final int? fee;

  /// Used to populate label ns_st_cu
  final String? clipUrl;

  /// Used to populate label ns_st_bn
  final int? breakNumber;

  /// Used to populate label ns_st_tb
  final int? totalBreaks;

  /// Used to populate label ns_st_an
  final int? numberInBreak;

  /// Used to populate label ns_st_ta
  final int? totalInBreak;

  /// Used to populate label ns_st_ami
  final String? uniqueId;

  /// Used to populate label ns_st_amt
  final String? title;

  /// Used to populate label ns_st_ams
  final String? server;

  /// Used to populate label ns_st_amc
  final String? callToActionUrl;

  /// Used to populate label ns_st_amg
  final String? serverCampaignId;

  /// Used to populate label ns_st_amp
  final String? placementId;

  /// Used to populate label ns_st_amw
  final String? siteId;
  final AdvertisementDeliveryType? deliveryType;
  final AdvertisementOwner? owner;

  AdvertisementMetadata._({
    Map<String, StackedAdvertisementMetadata>? stack,
    Map<String, String>? customLabels,
    this.relatedContentMetadata,
    this.mediaType,
    this.classifyAsAudioStream,
    this.videoDimensions,
    this.length,
    this.fee,
    this.clipUrl,
    this.breakNumber,
    this.totalBreaks,
    this.numberInBreak,
    this.totalInBreak,
    this.uniqueId,
    this.title,
    this.server,
    this.callToActionUrl,
    this.serverCampaignId,
    this.placementId,
    this.siteId,
    this.deliveryType,
    this.owner,
  })  : customLabels = Map.unmodifiable(customLabels ?? {}),
        stack = Map.unmodifiable(stack ?? {});

  @override
  Map<String, dynamic> toMap() {
    return {
      "type": "advertisementMetadata",
      "stack": stack.map(((key, value) => MapEntry(key, value.toMap()))),
      "labels": customLabels,
      "relatedContentMetadata": relatedContentMetadata?.toMap(),
      "mediaType": mediaType?.type,
      "classifyAsAudioStream": classifyAsAudioStream,
      "videoDimensions": videoDimensions?.toMap(),
      "length": length,
      "fee": fee,
      "clipUrl": clipUrl,
      "breakNumber": breakNumber,
      "totalBreaks": totalBreaks,
      "numberInBreak": numberInBreak,
      "totalInBreak": totalInBreak,
      "uniqueId": uniqueId,
      "title": title,
      "server": server,
      "callToActionUrl": callToActionUrl,
      "serverCampaignId": serverCampaignId,
      "placementId": placementId,
      "siteId": siteId,
      "deliveryType": deliveryType?.value,
      "owner": owner?.value,
    };
  }

  static AdvertisementMetadataBuilder builder() => AdvertisementMetadataBuilder();
}

class AdvertisementMetadataBuilder {
  Map<String, StackedAdvertisementMetadata>? _stack;
  Map<String, String>? _labels;
  ContentMetadata? _relatedContentMetadata;
  AdvertisementType? _mediaType;
  bool? _classifyAsAudioStream;
  Dimensions? _videoDimensions;
  int? _length;
  int? _fee;
  String? _clipUrl;
  int? _breakNumber;
  int? _totalBreaks;
  int? _numberInBreak;
  int? _totalInBreak;
  String? _uniqueId;
  String? _title;
  String? _server;
  String? _callToActionUrl;
  String? _serverCampaignId;
  String? _placementId;
  String? _siteId;
  AdvertisementDeliveryType? _deliveryType;
  AdvertisementOwner? _owner;

  AdvertisementMetadataBuilder();

  AdvertisementMetadataBuilder stack(Map<String, StackedAdvertisementMetadata> stack) {
    _stack = stack;
    return this;
  }

  AdvertisementMetadataBuilder customLabels(Map<String, String> customLabels) {
    _labels = customLabels;
    return this;
  }

  AdvertisementMetadataBuilder relatedContentMetadata(ContentMetadata relatedContentMetadata) {
    _relatedContentMetadata = relatedContentMetadata;
    return this;
  }

  AdvertisementMetadataBuilder mediaType(AdvertisementType mediaType) {
    _mediaType = mediaType;
    return this;
  }

  AdvertisementMetadataBuilder classifyAsAudioStream(bool classifyAsAudioStream) {
    _classifyAsAudioStream = classifyAsAudioStream;
    return this;
  }

  AdvertisementMetadataBuilder videoDimensions(Dimensions videoDimensions) {
    _videoDimensions = videoDimensions;
    return this;
  }

  AdvertisementMetadataBuilder length(int length) {
    _length = length;
    return this;
  }

  AdvertisementMetadataBuilder fee(int fee) {
    _fee = fee;
    return this;
  }

  AdvertisementMetadataBuilder clipUrl(String clipUrl) {
    _clipUrl = clipUrl;
    return this;
  }

  AdvertisementMetadataBuilder breakNumber(int breakNumber) {
    _breakNumber = breakNumber;
    return this;
  }

  AdvertisementMetadataBuilder totalBreaks(int totalBreaks) {
    _totalBreaks = totalBreaks;
    return this;
  }

  AdvertisementMetadataBuilder numberInBreak(int numberInBreak) {
    _numberInBreak = numberInBreak;
    return this;
  }

  AdvertisementMetadataBuilder totalInBreak(int totalInBreak) {
    _totalInBreak = totalInBreak;
    return this;
  }

  AdvertisementMetadataBuilder uniqueId(String uniqueId) {
    _uniqueId = uniqueId;
    return this;
  }

  AdvertisementMetadataBuilder title(String title) {
    _title = title;
    return this;
  }

  AdvertisementMetadataBuilder server(String server) {
    _server = server;
    return this;
  }

  AdvertisementMetadataBuilder callToActionUrl(String callToActionUrl) {
    _callToActionUrl = callToActionUrl;
    return this;
  }

  AdvertisementMetadataBuilder serverCampaignId(String serverCampaignId) {
    _serverCampaignId = serverCampaignId;
    return this;
  }

  AdvertisementMetadataBuilder placementId(String placementId) {
    _placementId = placementId;
    return this;
  }

  AdvertisementMetadataBuilder siteId(String siteId) {
    _siteId = siteId;
    return this;
  }

  AdvertisementMetadataBuilder deliveryType(AdvertisementDeliveryType deliveryType) {
    _deliveryType = deliveryType;
    return this;
  }

  AdvertisementMetadataBuilder owner(AdvertisementOwner owner) {
    _owner = owner;
    return this;
  }

  AdvertisementMetadata build() {
    return AdvertisementMetadata._(
      stack: Map.unmodifiable(_stack ?? {}),
      customLabels: Map.unmodifiable(_labels ?? {}),
      relatedContentMetadata: _relatedContentMetadata,
      mediaType: _mediaType,
      classifyAsAudioStream: _classifyAsAudioStream,
      videoDimensions: _videoDimensions,
      length: _length,
      fee: _fee,
      clipUrl: _clipUrl,
      breakNumber: _breakNumber,
      totalBreaks: _totalBreaks,
      numberInBreak: _numberInBreak,
      totalInBreak: _totalInBreak,
      uniqueId: _uniqueId,
      title: _title,
      server: _server,
      callToActionUrl: _callToActionUrl,
      serverCampaignId: _serverCampaignId,
      placementId: _placementId,
      siteId: _siteId,
      deliveryType: _deliveryType,
      owner: _owner,
    );
  }
}
