#import "AnalyticsMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation AnalyticsMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.analytics"
                                                                binaryMessenger:[registrar messenger]];
    
    
    AnalyticsMethodChannel* instance = [[AnalyticsMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"start" isEqualToString:call.method]) {
        [SCORAnalytics start];
        result(nil);
    } else if ([@"getVersion" isEqualToString:call.method]) {
        result([SCORAnalytics version]);
    } else if ([@"notifyViewEvent" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObj: call.arguments[EVENT_INFO_REF_ID]];
        id labels = call.arguments[LABELS];
        if (eventInfo == nil && labels != [NSNull null]) {
            eventInfo = [[SCOREventInfo alloc] init];
        }
        if (labels != [NSNull null]) {
            [eventInfo addLabels: labels];
        }
        if (eventInfo) {
            [SCORAnalytics notifyViewEventWithEventInfo: eventInfo];
        } else {
            [SCORAnalytics notifyViewEvent];
        }
        result(nil);
    } else if ([@"notifyHiddenEvent" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObj: call.arguments[EVENT_INFO_REF_ID]];
        id labels = call.arguments[LABELS];
        if (eventInfo == nil && labels != [NSNull null]) {
            eventInfo = [[SCOREventInfo alloc] init];
        }
        if (labels != [NSNull null]) {
            [eventInfo addLabels: labels];
        }
        if (eventInfo) {
            [SCORAnalytics notifyHiddenEventWithEventInfo: eventInfo];
        } else {
            [SCORAnalytics notifyHiddenEvent];
        }
        result(nil);
    } else if ([@"notifyEnterForeground" isEqualToString:call.method]) {
        [SCORAnalytics notifyEnterForeground];
        result(nil);
    }else if ([@"notifyExitForeground" isEqualToString:call.method]) {
        [SCORAnalytics notifyExitForeground];
        result(nil);
    } else if ([@"notifyEnterForeground" isEqualToString:call.method]) {
        [SCORAnalytics notifyEnterForeground];
        result(nil);
    } else if ([@"notifyUxActive" isEqualToString:call.method]) {
        [SCORAnalytics notifyUxActive];
        result(nil);
    } else if ([@"notifyUxInactive" isEqualToString:call.method]) {
        [SCORAnalytics notifyUxInactive];
        result(nil);
    } else if ([@"flushOfflineCache" isEqualToString:call.method]) {
        [SCORAnalytics flushOfflineCache];
        result(nil);
    } else if ([@"clearOfflineCache" isEqualToString:call.method]) {
        [SCORAnalytics clearOfflineCache];
        result(nil);
    } else if ([@"clearInternalData" isEqualToString:call.method]) {
        [SCORAnalytics clearInternalData];
        result(nil);
    } else if ([@"setLogLevel" isEqualToString:call.method]) {
        [SCORAnalytics setLogLevel:[((NSNumber*) call.arguments) intValue]];
        result(nil);
    } else if ([@"getLogLevel" isEqualToString:call.method]) {
        result([NSNumber numberWithInt:(int) [SCORAnalytics logLevel]]);
    } else {
    result(FlutterMethodNotImplemented);
  }
}




@end
