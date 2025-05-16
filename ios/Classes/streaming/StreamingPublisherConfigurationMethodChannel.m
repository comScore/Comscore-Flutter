#import "StreamingPublisherConfigurationMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation StreamingPublisherConfigurationMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.streaming.streamingPublisherConfiguration"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    StreamingPublisherConfigurationMethodChannel* instance = [[StreamingPublisherConfigurationMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"removeAllLabels" isEqualToString:call.method]) {
        SCORStreamingPublisherConfiguration *streamingPublisherConfig = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingPublisherConfig removeAllLabels];
        result(nil);
    } else if ([@"removeLabel" isEqualToString:call.method]) {
        SCORStreamingPublisherConfiguration *streamingPublisherConfig = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingPublisherConfig removeLabelWithName:call.arguments[LABEL_NAME]];
        result(nil);
    } else if ([@"setLabel" isEqualToString:call.method]) {
        SCORStreamingPublisherConfiguration *streamingPublisherConfig = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingPublisherConfig setLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"addLabels" isEqualToString:call.method]) {
        SCORStreamingPublisherConfiguration *streamingPublisherConfig = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingPublisherConfig addLabels: obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else {
    result(FlutterMethodNotImplemented);
  }
}




@end
