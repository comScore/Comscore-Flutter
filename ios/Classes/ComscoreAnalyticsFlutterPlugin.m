#import "ComscoreAnalyticsFlutterPlugin.h"
#import "AnalyticsMethodChannel.h"
#import "EventInfoMethodChannel.h"
#import "UtilsMethodChannel.h"
#import "ClientConfigurationMethodChannel.h"
#import "ConfigurationMethodChannel.h"
#import "streaming/StreamingAnalyticsMethodChannel.h"
#import "streaming/StreamingConfigurationMethodChannel.h"
#import "streaming/StreamingPublisherConfigurationMethodChannel.h"
#import "streaming/StreamingExtendedAnalyticsMethodChannel.h"

@implementation ComscoreAnalyticsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    [AnalyticsMethodChannel registerWithRegistrar: registrar];
    [EventInfoMethodChannel registerWithRegistrar: registrar];
    [UtilsMethodChannel registerWithRegistrar: registrar];
    [ClientConfigurationMethodChannel registerWithRegistrar: registrar];
    [ConfigurationMethodChannel registerWithRegistrar: registrar];
    
    [StreamingAnalyticsMethodChannel registerWithRegistrar: registrar];
    [StreamingConfigurationMethodChannel registerWithRegistrar: registrar];
    [StreamingPublisherConfigurationMethodChannel registerWithRegistrar: registrar];
    [StreamingExtendedAnalyticsMethodChannel registerWithRegistrar: registrar];
    
}

@end
