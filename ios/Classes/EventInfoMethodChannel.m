#import "EventInfoMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation EventInfoMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.eventInfo"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    EventInfoMethodChannel* instance = [[EventInfoMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"newInstance" isEqualToString:call.method]) {
        SCOREventInfo *eventInfo = [[SCOREventInfo alloc] init];
        NSString *refId = [ObjTracker trackObj:eventInfo];
        result(refId);
    } else if ([@"addLabels" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObjFromArguments: call.arguments];
        [eventInfo addLabels:  obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else if ([@"setLabel" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObjFromArguments: call.arguments];
        [eventInfo setLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"addPublisherLabels" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObjFromArguments: call.arguments];
        [eventInfo addLabels: obj_or_nil_from_arguments(LABELS) publisherId:call.arguments[PUBLISHER_ID]];
        result(nil);
    } else if ([@"setPublisherLabel" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObjFromArguments: call.arguments];
        [eventInfo setLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE] publisherId:call.arguments[PUBLISHER_ID]];
        result(nil);
    } else if ([@"addIncludedPublisher" isEqualToString:call.method]) {
        SCOREventInfo* eventInfo = [ObjTracker trackedObjFromArguments: call.arguments];
        [eventInfo addIncludedPublisher:call.arguments[PUBLISHER_ID]];
        result(nil);
    } else {
    result(FlutterMethodNotImplemented);
  }
}




@end
