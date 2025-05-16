#import "StreamingConfigurationMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation StreamingConfigurationMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.streaming.streamingConfiguration"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    StreamingConfigurationMethodChannel* instance = [[StreamingConfigurationMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"removeAllLabels" isEqualToString:call.method]) {
        SCORStreamingConfiguration *streamingConfiguration = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingConfiguration removeAllLabels];
        result(nil);
    } else if ([@"removeLabel" isEqualToString:call.method]) {
        SCORStreamingConfiguration *streamingConfiguration = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingConfiguration removeLabelWithName: call.arguments[LABEL_NAME]];
        result(nil);
    } else if ([@"setLabel" isEqualToString:call.method]) {
        SCORStreamingConfiguration *streamingConfiguration = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingConfiguration setLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"addLabels" isEqualToString:call.method]) {
        SCORStreamingConfiguration *streamingConfiguration = [ObjTracker trackedObjFromArguments:call.arguments];
        [streamingConfiguration addLabels: obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else if ([@"getStreamingPublisherConfiguration" isEqualToString:call.method]) {
        SCORStreamingConfiguration *streamingConfiguration = [ObjTracker trackedObjFromArguments:call.arguments];
        SCORStreamingPublisherConfiguration *pubConfig = [streamingConfiguration streamingPublisherConfigurationWithPublisherId:call.arguments[PUBLISHER_ID]];
        result([ObjTracker trackObj:pubConfig]);
    } else {
    result(FlutterMethodNotImplemented);
  }
}




@end
