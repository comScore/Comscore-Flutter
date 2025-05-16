#import "UtilsMethodChannel.h"
#import "Args.h"
#import "ObjTracker.h"
#import <ComScore/ComScore.h>

@implementation UtilsMethodChannel

static NSMutableDictionary *_objects = nil;

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.utils"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    UtilsMethodChannel* instance = [[UtilsMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"destroyInstance" isEqualToString:call.method]) {
        NSString *refId = [Args refIdFromArgs:[call arguments]];
        [[ObjTracker objects] removeObjectForKey: refId];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
  }
}

@end
