#import "StreamingAnalyticsMethodChannel.h"
#import "StreamingAnalyticsStreamHandler.h"
#import "StreamingAnalyticsOnStateListener.h"
#import "ObjTracker.h"
#import "Args.h"
#import "utils/ParsedDate.h"
#import "utils/ParsedDimensions.h"
#import "utils/ParsedTime.h"
#import <ComScore/ComScore.h>

FlutterEventSink stereamingEventSink;
NSMutableArray *pendingOnStreamingStateChanged;
dispatch_queue_t streamingAnalyticsDispatchQueue;
NSMutableDictionary *flutterOnStreamingStateChangeListeners;

@implementation StreamingAnalyticsStreamHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    dispatch_async(streamingAnalyticsDispatchQueue, ^{
        stereamingEventSink = eventSink;
        if ([pendingOnStreamingStateChanged count] > 0) {
            for (id object in pendingOnStreamingStateChanged) {
                stereamingEventSink(object);
            }
            [pendingOnStreamingStateChanged removeAllObjects];
        }
    });
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    stereamingEventSink = nil;
  return nil;
}
@end

@implementation StreamingAnalyticsOnStateListener

- (StreamingAnalyticsOnStateListener*)initWithRefId:(NSString*) refId {
    self = [super init];
    if(self) {
        self.refId = refId;
    }
    return self;
}

- (void)onStateChanged:(SCORStreamingState)oldState
              newState:(SCORStreamingState)newState
           eventLabels:(NSDictionary *)eventLabels {
    dispatch_async(streamingAnalyticsDispatchQueue, ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[REF_ID] = self.refId;
        params[@"oldState"] = [NSNumber numberWithInt: (int) oldState];
        params[@"newState"] = [NSNumber numberWithInt: (int) newState];
        params[@"eventLabels"] = eventLabels;
        if (stereamingEventSink) {
            stereamingEventSink(params);
        } else {
            [pendingOnStreamingStateChanged addObject:params];
        }
    });
}

@end

@implementation StreamingAnalyticsMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.streaming.streamingAnalytics"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    StreamingAnalyticsMethodChannel* instance = [[StreamingAnalyticsMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
    
    // Setup event channel
    streamingAnalyticsDispatchQueue = dispatch_queue_create("com.comscore.flutter.streaming.StreamingAnalyticsListener", NULL);
    pendingOnStreamingStateChanged = [[NSMutableArray alloc] init];
    flutterOnStreamingStateChangeListeners = [[NSMutableDictionary alloc] init];
    FlutterEventChannel *channel = [FlutterEventChannel
                                    eventChannelWithName:@"com.comscore.streaming.streamingAnalytics_OnStreamingStateChange_channel"
                                         binaryMessenger:[registrar messenger]];
    StreamingAnalyticsStreamHandler* streamHandler = [[StreamingAnalyticsStreamHandler alloc] init];
    [channel setStreamHandler:streamHandler];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"newInstance" isEqualToString:call.method]) {
        SCORStreamingConfigurationBuilder *builder = [[SCORStreamingConfigurationBuilder alloc] init];
        
        id includedPublishers = call.arguments[@"includedPublishers"];
        if (includedPublishers != [NSNull null]) {
            builder.includedPublishers = includedPublishers;
        }
        id labels = call.arguments[LABELS];
        if (labels != [NSNull null]) {
            builder.labels = labels;
        }
        id pauseOnBuffering = call.arguments[@"pauseOnBuffering"];
        if (pauseOnBuffering != [NSNull null]) {
            builder.pauseOnBuffering = [pauseOnBuffering boolValue];
        }
        id pauseOnBufferingInterval = call.arguments[@"pauseOnBufferingInterval"];
        if (pauseOnBufferingInterval !=  [NSNull null]) {
            builder.pauseOnBufferingInterval = [pauseOnBufferingInterval longValue];
        }
        id keepAliveInterval = call.arguments[@"keepAliveInterval"];
        if (keepAliveInterval !=  [NSNull null]) {
            builder.keepAliveInterval = [keepAliveInterval longValue];
        }
        id keepAliveMeasurement = call.arguments[@"keepAliveMeasurement"];
        if (keepAliveMeasurement !=  [NSNull null]) {
            builder.keepAliveMeasurement = [keepAliveMeasurement boolValue];
        }
        id rawHeartbeatIntervals = call.arguments[@"heartbeatIntervals"];
        if (rawHeartbeatIntervals !=  [NSNull null]) {
            NSMutableArray *heartbeatIntervals = [[NSMutableArray alloc] init];
            for (NSDictionary* interval in rawHeartbeatIntervals) {
                NSMutableDictionary *heartbeat =[[NSMutableDictionary alloc] init];
                for(id key in interval) {
                    [heartbeat setObject:[interval objectForKey:key] forKey:key];
                }
                [heartbeatIntervals addObject:heartbeat];
            }
            builder.heartbeatIntervals = heartbeatIntervals;
        }
        id heartbeatMeasurement = call.arguments[@"heartbeatMeasurement"];
        if (heartbeatMeasurement !=  [NSNull null]) {
            builder.heartbeatMeasurement = [heartbeatMeasurement boolValue];
        }
        id customStartMinimumPlayback = call.arguments[@"customStartMinimumPlayback"];
        if (customStartMinimumPlayback !=  [NSNull null]) {
            builder.customStartMinimumPlayback = [customStartMinimumPlayback longValue];
        }
        id autoResumeStateOnAssetChange = call.arguments[@"autoResumeStateOnAssetChange"];
        if (autoResumeStateOnAssetChange !=  [NSNull null]) {
            builder.autoResumeStateOnAssetChange = [autoResumeStateOnAssetChange boolValue];
        }
        
        SCORStreamingConfiguration *configuration = [[SCORStreamingConfiguration alloc] initWithBuilder:builder];
        SCORStreamingAnalytics *streamingAnalytics = [[SCORStreamingAnalytics alloc] initWithConfiguration:configuration];
        result(@{
            @"streamingAnalyticsRefId": [ObjTracker trackObj:streamingAnalytics],
            @"streamingConfigurationRefId": [ObjTracker trackObj:[streamingAnalytics configuration]]
        });
    } else if ([@"addListener" isEqualToString:call.method]) {
        NSString *refId = call.arguments[REF_ID];
        StreamingAnalyticsOnStateListener *listener = flutterOnStreamingStateChangeListeners[refId];
        if (listener == nil) {
            SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObj:refId];
            listener = [[StreamingAnalyticsOnStateListener alloc] initWithRefId:refId];
            flutterOnStreamingStateChangeListeners[refId] = listener;
            [streamingAnalytics addListener:listener];
        }
        result(nil);
    } else if ([@"removeListener" isEqualToString:call.method]) {
        NSString *refId = call.arguments[REF_ID];
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObj:refId];
        StreamingAnalyticsOnStateListener *listener = flutterOnStreamingStateChangeListeners[refId];
        if (listener != nil) {
            [streamingAnalytics removeListener:listener];
        }
        result(nil);
    } else if ([@"getExtendedAnalytics" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        result([ObjTracker trackObj:[streamingAnalytics extendedAnalytics]]);
    } else if ([@"createPlaybackSession" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics createPlaybackSession];
        result(nil);
    } else if ([@"startFromPosition" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics startFromPosition:[((NSNumber*) call.arguments[POSITION]) longValue]];
        result(nil);
    } else if ([@"notifyPlay" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyPlay];
        result(nil);
    } else if ([@"notifyPlay" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyPlay];
        result(nil);
    } else if ([@"notifyPause" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyPause];
        result(nil);
    } else if ([@"notifyEnd" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyEnd];
        result(nil);
    } else if ([@"notifyBufferStart" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyBufferStart];
        result(nil);
    } else if ([@"notifyBufferStop" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyBufferStop];
        result(nil);
    } else if ([@"notifySeekStart" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifySeekStart];
        result(nil);
    } else if ([@"notifyChangePlaybackRate" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics notifyChangePlaybackRate: [((NSNumber*) call.arguments[RATE]) floatValue]];
        result(nil);
    } else if ([@"setDvrWindowLength" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setDVRWindowLength:[((NSNumber*) call.arguments[POSITION]) intValue]];
        result(nil);
    } else if ([@"startFromDvrWindowOffset" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics startFromDvrWindowOffset:[((NSNumber*) call.arguments[DVR_WINDOW]) intValue]];
        result(nil);
    } else if ([@"setMediaPlayerName" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setMediaPlayerName: call.arguments[MEDIA_PLAYER_NAME]];
        result(nil);
    } else if ([@"setMediaPlayerVersion" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setMediaPlayerVersion: call.arguments[MEDIA_PLAYER_VERSION]];
        result(nil);
    } else if ([@"setMetadata" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setMetadata:[self buildAssetMetadata:call.arguments[METADATA]]];
        result(nil);
    } else if ([@"setImplementationId" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setImplementationId: call.arguments[IMPLEMENTATION_ID]];
        result(nil);
    } else if ([@"setProjectId" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics setProjectId:call.arguments[PROJECT_ID]];
        result(nil);
    } else if ([@"getPlaybackSessionId" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        result([streamingAnalytics playbackSessionId]);
    } else if ([@"startFromSegment" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics startFromSegment:[((NSNumber*) call.arguments[DVR_WINDOW]) intValue]];
        result(nil);
    } else if ([@"loopPlaybackSession" isEqualToString:call.method]) {
        SCORStreamingAnalytics *streamingAnalytics = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingAnalytics loopPlaybackSession];
        result(nil);
    } else {
    result(FlutterMethodNotImplemented);
  }
}

- (SCORStreamingStackedContentMetadata*) buildStackedContentMetadata:(id) data {
    SCORStreamingStackedContentMetadataBuilder *builder = [[SCORStreamingStackedContentMetadataBuilder alloc] init];
    id labels = data[@"labels"];
    if (labels != [NSNull null] && ((NSDictionary*)labels).count > 0) {
        [builder setCustomLabels:labels];
    }
    id uniqueId = data[@"uniqueId"];
    if (uniqueId != [NSNull null]) {
        [builder setUniqueId:uniqueId];
    }
    id programTitle = data[@"programTitle"];
    if (programTitle != [NSNull null]) {
        [builder setProgramTitle:programTitle];
    }
    id episodeTitle = data[@"episodeTitle"];
    if (episodeTitle != [NSNull null]) {
        [builder setEpisodeTitle:episodeTitle];
    }
    id episodeSeasonNumber = data[@"episodeSeasonNumber"];
    if (episodeSeasonNumber != [NSNull null]) {
        [builder setEpisodeSeasonNumber:episodeSeasonNumber];
    }
    id episodeNumber = data[@"episodeNumber"];
    if (episodeNumber != [NSNull null]) {
        [builder setEpisodeNumber:episodeNumber];
    }
    id genreName = data[@"genreName"];
    if (genreName != [NSNull null]) {
        [builder setGenreName:genreName];
    }
    id genreId = data[@"genreId"];
    if (genreId != [NSNull null]) {
        [builder setGenreId:genreId];
    }
    ParsedDate *productionDate = [[ParsedDate alloc] initWithData:data[@"productionDate"]];
    if (productionDate.isValid) {
        [builder setDateOfProductionYear:productionDate.year month:productionDate.month day:productionDate.day];
    }
    ParsedTime *productionTime = [[ParsedTime alloc] initWithData: data[@"productionTime"]];
    if (productionTime.isValid) {
        [builder setTimeOfProductionHours:productionTime.hour minutes:productionTime.minute];
    }
    ParsedDate *digitalAiringDate = [[ParsedDate alloc] initWithData: data[@"digitalAiringDate"]];
    if (digitalAiringDate.isValid) {
        [builder setDateOfDigitalAiringYear:digitalAiringDate.year month:digitalAiringDate.month day:digitalAiringDate.day];
    }
    ParsedTime *digitalAiringTime = [[ParsedTime alloc] initWithData: data[@"digitalAiringTime"]];
    if (digitalAiringTime.isValid) {
        [builder setTimeOfDigitalAiringHours:digitalAiringTime.hour minutes:digitalAiringTime.minute];
    }
    ParsedDate* tvAiringDate = [[ParsedDate alloc] initWithData: data[@"tvAiringDate"]];
    if (tvAiringDate.isValid) {
        [builder setDateOfTvAiringYear:tvAiringDate.year month:tvAiringDate.month day:tvAiringDate.day];
    }
    ParsedTime *tvAiringTime = [[ParsedTime alloc] initWithData: data[@"tvAiringTime"]];
    if (tvAiringTime.isValid) {
        [builder setTimeOfTvAiringHours:tvAiringTime.hour minutes:tvAiringTime.minute];
    }
    id stationTitle = data[@"stationTitle"];
    if (stationTitle != [NSNull null]) {
        [builder setStationTitle:stationTitle];
    }
    id stationCode = data[@"stationCode"];
    if (stationCode != [NSNull null]) {
        [builder setStationCode:stationCode];
    }
    id programId = data[@"programId"];
    if (programId != [NSNull null]) {
        [builder setProgramId:programId];
    }
    id episodeId = data[@"episodeId"];
    if (episodeId != [NSNull null]) {
        [builder setEpisodeId:episodeId];
    }
    id networkAffiliate = data[@"networkAffiliate"];
    if (networkAffiliate != [NSNull null]) {
        [builder setNetworkAffiliate:networkAffiliate];
    }
    id fee = data[@"fee"];
    if (fee != [NSNull null]) {
        [builder setFee:[fee intValue]];
    }
    id playlistTitle = data[@"playlistTitle"];
    if (playlistTitle != [NSNull null]) {
        [builder setPlaylistTitle:playlistTitle];
    }
    id dictionaryClassificationC3 = data[@"dictionaryClassificationC3"];
    if (dictionaryClassificationC3 != [NSNull null]) {
        [builder setDictionaryClassificationC3:dictionaryClassificationC3];
    }
    id dictionaryClassificationC4 = data[@"dictionaryClassificationC4"];
    if (dictionaryClassificationC4 != [NSNull null]) {
        [builder setDictionaryClassificationC4:dictionaryClassificationC4];
    }
    id dictionaryClassificationC6 = data[@"dictionaryClassificationC6"];
    if (dictionaryClassificationC6 != [NSNull null]) {
        [builder setDictionaryClassificationC6:dictionaryClassificationC6];
    }
    id deliveryMode = data[@"deliveryMode"];
    if (deliveryMode != [NSNull null]) {
        [builder setDeliveryMode:[deliveryMode intValue]];
    }
    id deliverySubscriptionType = data[@"deliverySubscriptionType"];
    if (deliverySubscriptionType != [NSNull null]) {
        [builder setDeliverySubscriptionType:[deliverySubscriptionType intValue]];
    }
    id deliveryComposition = data[@"deliveryComposition"];
    if (deliveryComposition != [NSNull null]) {
        [builder setDeliveryComposition:[deliveryComposition intValue]];
    }
    id deliveryAdvertisementCapability = data[@"deliveryAdvertisementCapability"];
    if (deliveryAdvertisementCapability != [NSNull null]) {
        [builder setDeliveryAdvertisementCapability:[deliveryAdvertisementCapability intValue]];
    }
    id distributionModel = data[@"distributionModel"];
    if (distributionModel != [NSNull null]) {
        [builder setDistributionModel:[distributionModel intValue]];
    }
    id mediaFormat = data[@"mediaFormat"];
    if (mediaFormat != [NSNull null]) {
        [builder setMediaFormat:[mediaFormat intValue]];
    }
    return [builder build];
}

- (SCORStreamingStackedAdvertisementMetadata*) buildStackedAdvertisementMetadata:(id) data {
    SCORStreamingStackedAdvertisementMetadataBuilder *builder = [[SCORStreamingStackedAdvertisementMetadataBuilder alloc] init];
    id labels = data[@"labels"];
    if (labels != [NSNull null] && ((NSDictionary*)labels).count > 0) {
        [builder setCustomLabels:labels];
    }
    id fee = data[@"fee"];
    if (fee != [NSNull null]) {
        [builder setFee:[fee intValue]];
    }
    id uniqueId = data[@"uniqueId"];
    if (uniqueId != [NSNull null]) {
        [builder setUniqueId:uniqueId];
    }
    id title = data[@"title"];
    if (title != [NSNull null]) {
        [builder setTitle:title];
    }
    id serverCampaignId = data[@"serverCampaignId"];
    if (serverCampaignId != [NSNull null]) {
        [builder setServerCampaignId:serverCampaignId];
    }
    id placementId = data[@"placementId"];
    if (placementId != [NSNull null]) {
        [builder setPlacementId:placementId];
    }
    id siteId = data[@"siteId"];
    if (siteId != [NSNull null]) {
        [builder setSiteId:siteId];
    }
    return [builder build];
}

- (SCORStreamingAssetMetadata* ) buildAssetMetadata:(id) data {
    if (data == [NSNull null] || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if ([@"contentMetadata" isEqualToString:data[@"type"]]) {
        SCORStreamingContentMetadataBuilder *builder = [[SCORStreamingContentMetadataBuilder alloc] init];
        id stack = data[@"stack"];
        if (stack != [NSNull null] && ((NSDictionary*)stack).count > 0) {
            for(id key in stack) {
                [builder setStack:[self buildStackedContentMetadata: data] forPublisher:key];
            }
        }
        id labels = data[@"labels"];
        if (labels != [NSNull null] && ((NSDictionary*)labels).count > 0) {
            [builder setCustomLabels:labels];
        }
        id mediaType = data[@"mediaType"];
        if (mediaType != [NSNull null]) {
            [builder setMediaType:[mediaType intValue]];
        }
        id classifyAsAudioStream = data[@"classifyAsAudioStream"];
        if (classifyAsAudioStream != [NSNull null]) {
            [builder classifyAsAudioStream:[classifyAsAudioStream boolValue]];
        }
        id classifyAsCompleteEpisode = data[@"classifyAsCompleteEpisode"];
        if (classifyAsCompleteEpisode != [NSNull null]) {
            [builder classifyAsCompleteEpisode:[classifyAsCompleteEpisode boolValue]];
        }
        id carryTvAdvertisementLoad = data[@"carryTvAdvertisementLoad"];
        if (carryTvAdvertisementLoad != [NSNull null]) {
            [builder carryTvAdvertisementLoad:[carryTvAdvertisementLoad boolValue]];
        }
        id uniqueId = data[@"uniqueId"];
        if (uniqueId != [NSNull null]) {
            [builder setUniqueId:uniqueId];
        }
        id length = data[@"length"];
        if (length != [NSNull null]) {
            [builder setLength:[length intValue]];
        }
        id totalSegments = data[@"totalSegments"];
        if (totalSegments != [NSNull null]) {
            [builder setTotalSegments:[totalSegments intValue]];
        }
        id publisherName = data[@"publisherName"];
        if (publisherName != [NSNull null]) {
            [builder setPublisherName:publisherName];
        }
        id programTitle = data[@"programTitle"];
        if (programTitle != [NSNull null]) {
            [builder setProgramTitle:programTitle];
        }
        id episodeTitle = data[@"episodeTitle"];
        if (episodeTitle != [NSNull null]) {
            [builder setEpisodeTitle:episodeTitle];
        }
        id episodeSeasonNumber = data[@"episodeSeasonNumber"];
        if (episodeSeasonNumber != [NSNull null]) {
            [builder setEpisodeSeasonNumber:episodeSeasonNumber];
        }
        id episodeNumber = data[@"episodeNumber"];
        if (episodeNumber != [NSNull null]) {
            [builder setEpisodeNumber:episodeNumber];
        }
        id genreName = data[@"genreName"];
        if (genreName != [NSNull null]) {
            [builder setGenreName:genreName];
        }
        id genreId = data[@"genreId"];
        if (genreId != [NSNull null]) {
            [builder setGenreId:genreId];
        }
        ParsedDate *productionDate = [[ParsedDate alloc] initWithData:data[@"productionDate"]];
        if (productionDate.isValid) {
            [builder setDateOfProductionYear:productionDate.year month:productionDate.month day:productionDate.day];
        }
        ParsedTime *productionTime = [[ParsedTime alloc] initWithData: data[@"productionTime"]];
        if (productionTime.isValid) {
            [builder setTimeOfProductionHours:productionTime.hour minutes:productionTime.minute];
        }
        ParsedDate *digitalAiringDate = [[ParsedDate alloc] initWithData: data[@"digitalAiringDate"]];
        if (digitalAiringDate.isValid) {
            [builder setDateOfDigitalAiringYear:digitalAiringDate.year month:digitalAiringDate.month day:digitalAiringDate.day];
        }
        ParsedTime *digitalAiringTime = [[ParsedTime alloc] initWithData: data[@"digitalAiringTime"]];
        if (digitalAiringTime.isValid) {
            [builder setTimeOfDigitalAiringHours:digitalAiringTime.hour minutes:digitalAiringTime.minute];
        }
        ParsedDate* tvAiringDate = [[ParsedDate alloc] initWithData: data[@"tvAiringDate"]];
        if (tvAiringDate.isValid) {
            [builder setDateOfTvAiringYear:tvAiringDate.year month:tvAiringDate.month day:tvAiringDate.day];
        }
        ParsedTime *tvAiringTime = [[ParsedTime alloc] initWithData: data[@"tvAiringTime"]];
        if (tvAiringTime.isValid) {
            [builder setTimeOfTvAiringHours:tvAiringTime.hour minutes:tvAiringTime.minute];
        }
        id stationTitle = data[@"stationTitle"];
        if (stationTitle != [NSNull null]) {
            [builder setStationTitle:stationTitle];
        }
        id stationCode = data[@"stationCode"];
        if (stationCode != [NSNull null]) {
            [builder setStationCode:stationCode];
        }
        id programId = data[@"programId"];
        if (programId != [NSNull null]) {
            [builder setProgramId:programId];
        }
        id episodeId = data[@"episodeId"];
        if (episodeId != [NSNull null]) {
            [builder setEpisodeId:episodeId];
        }
        id networkAffiliate = data[@"networkAffiliate"];
        if (networkAffiliate != [NSNull null]) {
            [builder setNetworkAffiliate:networkAffiliate];
        }
        id fee = data[@"fee"];
        if (fee != [NSNull null]) {
            [builder setFee:[fee intValue]];
        }
        id clipUrl = data[@"clipUrl"];
        if (clipUrl != [NSNull null]) {
            [builder setClipUrl:clipUrl];
        }
        id playlistTitle = data[@"playlistTitle"];
        if (playlistTitle != [NSNull null]) {
            [builder setPlaylistTitle:playlistTitle];
        }
        id feedType = data[@"feedType"];
        if (feedType != [NSNull null]) {
            [builder setFeedType:[feedType intValue]];
        }
        ParsedDimensions *dimensions = [[ParsedDimensions alloc] initWithData: data[@"videoDimensions"]];
        if (dimensions.isValid) {
            [builder setVideoDimensionWidth:dimensions.width height:dimensions.height];
        }
        id dictionaryClassificationC3 = data[@"dictionaryClassificationC3"];
        if (dictionaryClassificationC3 != [NSNull null]) {
            [builder setDictionaryClassificationC3:dictionaryClassificationC3];
        }
        id dictionaryClassificationC4 = data[@"dictionaryClassificationC4"];
        if (dictionaryClassificationC4 != [NSNull null]) {
            [builder setDictionaryClassificationC4:dictionaryClassificationC4];
        }
        id dictionaryClassificationC6 = data[@"dictionaryClassificationC6"];
        if (dictionaryClassificationC6 != [NSNull null]) {
            [builder setDictionaryClassificationC6:dictionaryClassificationC6];
        }
        id deliveryMode = data[@"deliveryMode"];
        if (deliveryMode != [NSNull null]) {
            [builder setDeliveryMode:[deliveryMode intValue]];
        }
        id deliverySubscriptionType = data[@"deliverySubscriptionType"];
        if (deliverySubscriptionType != [NSNull null]) {
            [builder setDeliverySubscriptionType:[deliverySubscriptionType intValue]];
        }
        id deliveryComposition = data[@"deliveryComposition"];
        if (deliveryComposition != [NSNull null]) {
            [builder setDeliveryComposition:[deliveryComposition intValue]];
        }
        id deliveryAdvertisementCapability = data[@"deliveryAdvertisementCapability"];
        if (deliveryAdvertisementCapability != [NSNull null]) {
            [builder setDeliveryAdvertisementCapability:[deliveryAdvertisementCapability intValue]];
        }
        id distributionModel = data[@"distributionModel"];
        if (distributionModel != [NSNull null]) {
            [builder setDistributionModel:[distributionModel intValue]];
        }
        id mediaFormat = data[@"mediaFormat"];
        if (mediaFormat != [NSNull null]) {
            [builder setMediaFormat:[mediaFormat intValue]];
        }
        return [builder build];
    } else if ([@"advertisementMetadata" isEqualToString:data[@"type"]]) {
        SCORStreamingAdvertisementMetadataBuilder *builder = [[SCORStreamingAdvertisementMetadataBuilder alloc] init];
        id stack = data[@"stack"];
        if (stack != [NSNull null] && ((NSDictionary*)stack).count > 0) {
            for(id key in stack) {
                [builder setStack:[self buildStackedAdvertisementMetadata: data] forPublisher:key];
            }
        }
        id labels = data[@"labels"];
        if (labels != [NSNull null] && ((NSDictionary*)labels).count > 0) {
            [builder setCustomLabels:labels];
        }
        id relatedContentMetadata = data[@"relatedContentMetadata"];
        if (relatedContentMetadata != [NSNull null]) {
            [builder setRelatedContentMetadata:(SCORStreamingContentMetadata*)[self buildAssetMetadata: relatedContentMetadata]];
        }
        id mediaType = data[@"mediaType"];
        if (mediaType != [NSNull null]) {
            [builder setMediaType: [mediaType intValue]];
        }
        id classifyAsAudioStream = data[@"classifyAsAudioStream"];
        if (classifyAsAudioStream != [NSNull null]) {
            [builder classifyAsAudioStream:[classifyAsAudioStream boolValue]];
        }
        ParsedDimensions *dimensions = [[ParsedDimensions alloc] initWithData: data[@"videoDimensions"]];
        if (dimensions.isValid) {
            [builder setVideoDimensionWidth:dimensions.width height:dimensions.height];
        }
        id length = data[@"length"];
        if (length != [NSNull null]) {
            [builder setLength: [length intValue]];
        }
        id fee = data[@"fee"];
        if (fee != [NSNull null]) {
            [builder setFee:[fee intValue]];
        }
        id clipUrl = data[@"clipUrl"];
        if (clipUrl != [NSNull null]) {
            [builder setClipUrl:clipUrl];
        }
        id advertisementBreakNumber = data[@"breakNumber"];
        if (advertisementBreakNumber != [NSNull null]) {
            [builder setBreakNumber:[advertisementBreakNumber intValue]];
        }
        id totalBreaks = data[@"totalBreaks"];
        if (totalBreaks != [NSNull null]) {
            [builder setTotalBreaks:[totalBreaks intValue]];
        }
        id numberInBreak = data[@"numberInBreak"];
        if (numberInBreak != [NSNull null]) {
            [builder setNumberInBreak:[numberInBreak intValue]];
        }
        id totalInBreak = data[@"totalInBreak"];
        if (totalInBreak != [NSNull null]) {
            [builder setTotalInBreak:[totalInBreak intValue]];
        }
        id uniqueId = data[@"uniqueId"];
        if (uniqueId != [NSNull null]) {
            [builder setUniqueId:uniqueId];
        }
        id title = data[@"title"];
        if (title != [NSNull null]) {
            [builder setTitle:title];
        }
        id server = data[@"server"];
        if (server != [NSNull null]) {
            [builder setServer:server];
        }
        id callToActionUrl = data[@"callToActionUrl"];
        if (callToActionUrl != [NSNull null]) {
            [builder setCallToActionUrl:callToActionUrl];
        }
        id serverCampaignId = data[@"serverCampaignId"];
        if (serverCampaignId != [NSNull null]) {
            [builder setServerCampaignId:serverCampaignId];
        }
        id placementId = data[@"placementId"];
        if (placementId != [NSNull null]) {
            [builder setPlacementId:placementId];
        }
        id siteId = data[@"siteId"];
        if (siteId != [NSNull null]) {
            [builder setSiteId:siteId];
        }
        id deliveryType = data[@"deliveryType"];
        if (deliveryType != [NSNull null]) {
            [builder setDeliveryType:[deliveryType intValue]];
        }
        id owner = data[@"owner"];
        if (owner != [NSNull null]) {
            [builder setOwner:[owner intValue]];
        }
        return [builder build];
    }
    return nil;
}

@end
