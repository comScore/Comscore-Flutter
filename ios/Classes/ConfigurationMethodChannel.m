#import "ConfigurationMethodChannel.h"
#import "ConfigurationStreamHandler.h"
#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

FlutterEventSink configurationEventSink;
NSMutableArray *pendingOnCrossPublisherUniqueDeviceIdChanged;
dispatch_queue_t configurationDispatchQueue;

@implementation ConfigurationStreamHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    dispatch_async(configurationDispatchQueue, ^{
        configurationEventSink = eventSink;
        if ([pendingOnCrossPublisherUniqueDeviceIdChanged count] > 0) {
            for (id object in pendingOnCrossPublisherUniqueDeviceIdChanged) {
                configurationEventSink(object);
            }
            [pendingOnCrossPublisherUniqueDeviceIdChanged removeAllObjects];
        }
    });
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    configurationEventSink = nil;
  return nil;
}
@end


@implementation ConfigurationMethodChannel

- (void)crossPublisherUniqueDeviceIdChanged:(NSString *)crospublisherId {
    dispatch_async(configurationDispatchQueue, ^{
        if (configurationEventSink) {
            configurationEventSink(crospublisherId);
        } else {
            [pendingOnCrossPublisherUniqueDeviceIdChanged addObject:crospublisherId];
        }
    });
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* analyticChannel = [FlutterMethodChannel methodChannelWithName:@"com.comscore.configuration"
                                                                        binaryMessenger:[registrar messenger]];
    
    ConfigurationMethodChannel* instance = [[ConfigurationMethodChannel alloc] init];
    [registrar addMethodCallDelegate:instance channel:analyticChannel];
    
    // Setup event channel
    configurationDispatchQueue = dispatch_queue_create("com.comscore.flutter.configuration.crossPublisherUniqueDeviceIdChanged", NULL);
    pendingOnCrossPublisherUniqueDeviceIdChanged = [[NSMutableArray alloc] init];
    FlutterEventChannel *channel = [FlutterEventChannel
                                    eventChannelWithName:@"com.comscore.configuration.configuration_CrossPublisherUniqueDeviceIdChanged_channel"
                                         binaryMessenger:[registrar messenger]];
    ConfigurationStreamHandler* streamHandler = [[ConfigurationStreamHandler alloc] init];
    [channel setStreamHandler:streamHandler];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"enableImplementationValidationMode" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] enableImplementationValidationMode];
        result(nil);
    } else if ([@"addClient" isEqualToString:call.method]) {
        SCORClientConfiguration* client = (SCORClientConfiguration*) [ObjTracker trackedObjFromArguments:call.arguments];
        if (client != nil) {
            [[SCORAnalytics configuration] addClientWithConfiguration:client];
            result(nil);
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Unable to find ClientConfiguration with id %@ and type %@", call.arguments[REF_ID], call.arguments[TYPE]];
            result([FlutterError errorWithCode:ERROR_OBJ_REF_NOT_FOUND message:errorMessage details:call.arguments]);
        }
    } else if ([@"addCrossPublisherUniqueDeviceIdChangeListener" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] addCrossPublisherUniqueDeviceIdChangeDelegate: self];
        result(nil);
    } else if ([@"getPartnerConfiguration" isEqualToString:call.method]) {
        SCORPartnerConfiguration* partner = [[SCORAnalytics configuration] partnerConfigurationWithPartnerId: call.arguments[PARTNER_ID]];
        result([ObjTracker trackObj:partner]);
    } else if ([@"getPublisherConfiguration" isEqualToString:call.method]) {
        SCORPublisherConfiguration* publisher = [[SCORAnalytics configuration] publisherConfigurationWithPublisherId: call.arguments[PUBLISHER_ID]];
        result([ObjTracker trackObj:publisher]);
    } else if ([@"getPublisherConfigurations" isEqualToString:call.method]) {
        NSArray* publishers = [[SCORAnalytics configuration] publisherConfigurations];
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for (SCORPublisherConfiguration* publisher in publishers) {
            [results addObject:[ObjTracker trackObj:publisher]];
        }
        result(results);
    } else if ([@"getPartnerConfigurations" isEqualToString:call.method]) {
        NSArray* partners = [[SCORAnalytics configuration] partnerConfigurations];
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for (SCORPublisherConfiguration* partner in partners) {
            [results addObject:[ObjTracker trackObj:partner]];
        }
        result(results);
    } else if ([@"getLabelOrder" isEqualToString:call.method]) {
        result([[SCORAnalytics configuration] labelOrder]);
    } else if ([@"setLabelOrder" isEqualToString:call.method]) {
        NSArray* labelOrder = call.arguments[LABEL_ORDER];
        [[SCORAnalytics configuration] setLabelOrder:labelOrder];
        result(nil);
    } else if ([@"setLiveEndpointUrl" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setLiveEndpointURL: call.arguments[LIVE_POINT_URL]];
        result(nil);
    } else if ([@"setOfflineFlushEndpointUrl" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setOfflineFlushEndpointURL:call.arguments[OFFLINE_FLUSH_END_POINT_URL]];
        result(nil);
    } else if ([@"setApplicationName" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setApplicationName: call.arguments[APP_NAME]];
        result(nil);
    } else if ([@"setApplicationVersion" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setApplicationVersion: call.arguments[APP_VERSION]];
        result(nil);
    } else if ([@"setPersistentLabel" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setPersistentLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"removeAllPersistentLabels" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] removeAllPersistentLabels];
        result(nil);
    } else if ([@"removePersistentLabel" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] removePersistentLabelWithName: call.arguments[LABEL_NAME]];
        result(nil);
    } else if ([@"addPersistentLabels" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] addPersistentLabels:  obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else if ([@"setStartLabel" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setStartLabelWithName:call.arguments[LABEL_NAME] value:call.arguments[LABEL_VALUE]];
        result(nil);
    } else if ([@"removeAllStartLabels" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] removeAllStartLabels];
        result(nil);
    } else if ([@"removeStartLabel" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] removeStartLabelWithName:call.arguments[LABEL_NAME]];
        result(nil);
    } else if ([@"addStartLabels" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] addStartLabels:  obj_or_nil_from_arguments(LABELS)];
        result(nil);
    } else if ([@"setKeepAliveMeasurementEnabled" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setKeepAliveMeasurementEnabled: [call.arguments[ENABLED] boolValue]];
        result(nil);
    } else if ([@"setLiveTransmissionMode" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setLiveTransmissionMode: [((NSNumber*) call.arguments[LIVE_TRANSMISSION_MODE]) intValue]];
        result(nil);
    } else if ([@"setOfflineCacheMode" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setOfflineCacheMode: [((NSNumber*) call.arguments[OFFLINE_CACHE_MODE]) intValue]];
        result(nil);
    } else if ([@"setUsagePropertiesAutoUpdateMode" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setUsagePropertiesAutoUpdateMode:[((NSNumber*) call.arguments[USAGE_PROPERTIES_AUTO_UPDATE_MODE]) intValue]];
        result(nil);
    } else if ([@"setUsagePropertiesAutoUpdateInterval" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setUsagePropertiesAutoUpdateInterval:[((NSNumber*) call.arguments[INTERVAL]) intValue]];
        result(nil);
    } else if ([@"setCacheMaxMeasurements" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setCacheMaxMeasurements:[((NSNumber*) call.arguments[MAX]) intValue]];
        result(nil);
    } else if ([@"setCacheMaxBatchFiles" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setCacheMaxBatchFiles: [((NSNumber*) call.arguments[MAX]) intValue]];
        result(nil);
    } else if ([@"setCacheMaxFlushesInARow" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setCacheMaxFlushesInARow: [((NSNumber*) call.arguments[MAX]) intValue]];
        result(nil);
    } else if ([@"setCacheMinutesToRetry" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setCacheMinutesToRetry: [((NSNumber*) call.arguments[MINUTES]) intValue]];
        result(nil);
    } else if ([@"setCacheMeasurementExpiry" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setCacheMeasurementExpiry: [((NSNumber*) call.arguments[DAYS]) intValue]];
        result(nil);
    } else if ([@"isEnabled" isEqualToString:call.method]) {
        result([[SCORAnalytics configuration] enabled] ? @(YES) : @(NO));
    } else if ([@"disable" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] disable];
        result(nil);
    } else if ([@"disableTcfIntegration" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] disableTcfIntegration];
        result(nil);
    } else if ([@"addIncludedPublisher" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] addIncludedPublisher: call.arguments[PUBLISHER_ID]];
        result(nil);
    } else if ([@"setSystemClockJumpDetectionEnabled" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setSystemClockJumpDetection: [call.arguments[ENABLED] boolValue]];
        result(nil);
    } else if ([@"setSystemClockJumpDetectionInterval" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setSystemClockJumpDetectionInterval:[((NSNumber*) call.arguments[INTERVAL]) intValue]];
        result(nil);
    } else if ([@"setSystemClockJumpDetectionPrecision" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] setSystemClockJumpDetectionPrecision:[((NSNumber*) call.arguments[PRECISION]) intValue]];
        result(nil);
    } else if ([@"enableChildDirectedApplicationMode" isEqualToString:call.method]) {
        [[SCORAnalytics configuration] enableChildDirectedApplicationMode];
        result(nil);
    }else {
        result(FlutterMethodNotImplemented);
  }
}


@end
