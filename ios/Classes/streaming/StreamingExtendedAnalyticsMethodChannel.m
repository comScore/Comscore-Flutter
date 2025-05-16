#import "StreamingExtendedAnalyticsMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import "utils/ParsedDate.h"
#import "utils/ParsedDimensions.h"
#import "utils/ParsedTime.h"
#import <ComScore/ComScore.h>

@implementation StreamingExtendedAnalyticsMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.streaming.streamingExtendedAnalytics"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    StreamingExtendedAnalyticsMethodChannel* instance = [[StreamingExtendedAnalyticsMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"notifyLoad" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyLoadWithLabels:labels];
        result(nil);
    } else if ([@"notifyEngage" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyEngageWithLabels:labels];
        result(nil);
    } else if ([@"notifySkipAd" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifySkipAdWithLabels:labels];
        result(nil);
    } else if ([@"notifyCallToAction" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyCallToActionWithLabels:labels];
        result(nil);
    } else if ([@"notifyError" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *error = call.arguments[@"error"];
        [streamingExtendedAnalytics notifyError:error labels:labels];
        result(nil);
    } else if ([@"notifyTransferPlayback" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *targetDevice = call.arguments[@"targetDevice"];
        [streamingExtendedAnalytics notifyTransferPlayback:targetDevice labels:labels];
        result(nil);
    } else if ([@"notifyDrmFail" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyDrmFailWithLabels:labels];
        result(nil);
    } else if ([@"notifyDrmApprove" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyDrmApproveWithLabels:labels];
        result(nil);
    } else if ([@"notifyDrmDeny" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        [streamingExtendedAnalytics notifyDrmDenyWithLabels:labels];
        result(nil);
    } else if ([@"notifyChangeBitrate" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSInteger rate = [((NSNumber*) call.arguments[RATE]) intValue];
        [streamingExtendedAnalytics notifyChangeBitrate:rate labels:labels];
        result(nil);
    } else if ([@"notifyChangeWindowState" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSInteger newState = [((NSNumber*) call.arguments[@"newState"]) intValue];
        [streamingExtendedAnalytics notifyChangeWindowState:newState labels:labels];
        result(nil);
    } else if ([@"notifyChangeAudioTrack" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *newAudio = call.arguments[@"newAudio"];
        [streamingExtendedAnalytics notifyChangeAudioTrack:newAudio labels:labels];
        result(nil);
    } else if ([@"notifyChangeVideoTrack" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *newVideo = call.arguments[@"newVideo"];
        [streamingExtendedAnalytics notifyChangeVideoTrack:newVideo labels:labels];
        result(nil);
    } else if ([@"notifyChangeSubtitleTrack" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *newSubtitle = call.arguments[@"newSubtitle"];
        [streamingExtendedAnalytics notifyChangeSubtitleTrack:newSubtitle labels:labels];
        result(nil);
    } else if ([@"notifyCustomEvent" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *eventName = call.arguments[@"eventName"];
        [streamingExtendedAnalytics notifyCustomEvent:eventName labels:labels];
        result(nil);
    } else if ([@"setPlaybackSessionExpectedLength" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSInteger expectedTotalLength =  [((NSNumber*) call.arguments[@"expectedTotalLength"]) intValue];
        [streamingExtendedAnalytics setPlaybackSessionExpectedLength:expectedTotalLength];
        result(nil);
    } else if ([@"setPlaybackSessionExpectedNumberOfItems" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSInteger expectedNumberOfItems = [((NSNumber*) call.arguments[@"expectedNumberOfItems"]) intValue];
        [streamingExtendedAnalytics setPlaybackSessionExpectedNumberOfItems:expectedNumberOfItems];
        result(nil);
    } else if ([@"notifyChangeVolume" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        float volume =  [((NSNumber*) call.arguments[@"newVolume"]) floatValue];;
        [streamingExtendedAnalytics notifyChangeVolume:volume labels:labels];
        result(nil);
    } else if ([@"notifyChangeCdn" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        NSDictionary* labels = obj_or_nil_from_arguments(LABELS);
        NSString *newCDN = call.arguments[@"newCDN"];
        [streamingExtendedAnalytics notifyChangeCdn:newCDN labels:labels];
        result(nil);
    } else if ([@"setLoadTimeOffset" isEqualToString:call.method]) {
        SCORStreamingExtendedAnalytics *streamingExtendedAnalytics  = [ObjTracker trackedObjFromArguments:call.arguments];
        long offset = [((NSNumber*) call.arguments[@"offset"]) longValue];
        [streamingExtendedAnalytics setLoadTimeOffset:offset];
        result(nil);
    } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
