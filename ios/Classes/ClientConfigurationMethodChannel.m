#import "ClientConfigurationMethodChannel.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation ClientConfigurationMethodChannel

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.clientConfiguration"
                                                                        binaryMessenger:[registrar messenger]];
    
    
    ClientConfigurationMethodChannel* instance = [[ClientConfigurationMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
}

+ (void) fillClientConfigurationBuilder: (SCORClientConfigurationBuilder*) builder arguments:(id) arguments{
    if (arguments[HTTP_REDIRECT_CACHING] != [NSNull null]) {
        builder.httpRedirectCachingEnabled = [arguments[HTTP_REDIRECT_CACHING] boolValue];
    }
    if (arguments[KEEP_ALIVE_MEASUREMENT] != [NSNull null]) {
        builder.keepAliveMeasurementEnabled = [arguments[KEEP_ALIVE_MEASUREMENT] boolValue];
    }
    if (arguments[SECURE_TRANSMISSION] != [NSNull null]) {
        builder.secureTransmissionEnabled = [arguments[SECURE_TRANSMISSION] boolValue];
    }
    if (arguments[PERSISTENT_LABELS] != [NSNull null]) {
        builder.persistentLabels = arguments[PERSISTENT_LABELS];
    }
    if (arguments[START_LABELS] != [NSNull null]) {
        builder.startLabels = arguments[START_LABELS];
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"newInstance" isEqualToString:call.method]) {
        SCORClientConfiguration * client;
        NSString *clientId = call.arguments[CLIENT_ID];
        if ([@"publisherConfiguration" isEqualToString:call.arguments[TYPE]]) {
            client = [SCORPublisherConfiguration publisherConfigurationWithBuilderBlock:^(SCORPublisherConfigurationBuilder *builder) {
                [ClientConfigurationMethodChannel fillClientConfigurationBuilder:builder arguments:call.arguments];
                builder.publisherId = clientId;
            }];
        } else if ([@"partnerConfiguration" isEqualToString:call.arguments[TYPE]]) {
            client = [SCORPartnerConfiguration partnerConfigurationWithBuilderBlock:^(SCORPartnerConfigurationBuilder *builder) {
                [ClientConfigurationMethodChannel fillClientConfigurationBuilder:builder arguments:call.arguments];
                builder.partnerId = clientId;
                if (call.arguments[@"externalClientId"] != [NSNull null]) {
                    builder.externalClientId = call.arguments[@"externalClientId"];
                }
            }];
        }
        NSString *refId = [ObjTracker trackObj:client];
        result(refId);
    } else if ([@"getClientId" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        NSString *clientId;
        if ([@"publisherConfiguration" isEqualToString:call.arguments[TYPE]]) {
            clientId = [(SCORPublisherConfiguration*)client publisherId];
        } else if ([@"partnerConfiguration" isEqualToString:call.arguments[TYPE]]) {
            clientId = [(SCORPartnerConfiguration*)client partnerId];
        }
        result(clientId);
    } else if ([@"removeAllPersistentLabels" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        [client removeAllPersistentLabels];
        result(nil);
    } else if ([@"getStartLabels" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client startLabels]);
    } else if ([@"containsStartLabel" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client containsStartLabel:call.arguments[LABEL_NAME]] ? @(YES) : @(NO));
    } else if ([@"removePersistentLabel" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        [client removePersistentLabelWithName:call.arguments[LABEL_NAME]];
        result(nil);
    } else if ([@"setPersistentLabel" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        [client setPersistentLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"getPersistentLabel" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client persistentLabelWithName:call.arguments[LABEL_NAME]]);
    } else if ([@"getPersistentLabels" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client persistentLabels]);
    } else if ([@"containsPersistentLabel" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client containsPersistentLabel:call.arguments[LABEL_NAME]] ? @(YES) : @(NO));
    } else if ([@"addPersistentLabels" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        [client addPersistentLabels:  obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else if ([@"isKeepAliveMeasurementEnabled" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client keepAliveMeasurementEnabled] ? @(YES) : @(NO));
    } else if ([@"isSecureTransmissionEnabled" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client secureTransmissionEnabled] ? @(YES) : @(NO));
    } else if ([@"isHttpRedirectCachingEnabled" isEqualToString:call.method]) {
        SCORClientConfiguration *client = [ObjTracker trackedObjFromArguments:call.arguments];
        result([client httpRedirectCachingEnabled] ? @(YES) : @(NO));
    } else {
    result(FlutterMethodNotImplemented);
  }
}




@end
