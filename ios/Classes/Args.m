#import "Args.h"

@implementation Args

NSString * const REF_ID = @"refId";
NSString * const TYPE = @"type";
NSString * const CLIENT_ID = @"clientId";
NSString * const LABEL_NAME = @"labelName";
NSString * const LABEL_VALUE = @"labelValue";
NSString * const LABELS = @"labels";
NSString * const PUBLISHER_ID = @"publisherId";
NSString * const PARTNER_ID = @"partnerId";
NSString * const EVENT_INFO_REF_ID = @"eventInfoRefId";
NSString * const DISTRIBUTOR_PARTNER_ID = @"distributorPartnerId";
NSString * const DISTRIBUTOR_CONTENT_ID = @"distributorContentId";
NSString * const PUBLISHER_UNIQUE_DEVICE_ID = @"publisherUniqueDeviceId";
NSString * const D_KEY = @"dkey";
NSString * const URL = @"url";
NSString * const LABEL_ORDER = @"labelOrder";
NSString * const LIVE_POINT_URL = @"liveEndpointUrl";
NSString * const OFFLINE_FLUSH_END_POINT_URL = @"offlineFlushEndpointUrl";
NSString * const APP_NAME = @"appName";
NSString * const APP_VERSION = @"appVersion";
NSString * const ENABLED = @"enabled";
NSString * const LIVE_TRANSMISSION_MODE = @"liveTransmissionMode";
NSString * const OFFLINE_CACHE_MODE = @"offlineCacheMode";
NSString * const USAGE_PROPERTIES_AUTO_UPDATE_MODE = @"usagePropertiesAutoUpdateMode";
NSString * const INTERVAL = @"interval";
NSString * const MAX = @"max";
NSString * const MINUTES = @"minutes";
NSString * const DAYS = @"days";
NSString * const PRECISION = @"precision";
NSString * const HTTP_REDIRECT_CACHING = @"httpRedirectCaching";
NSString * const KEEP_ALIVE_MEASUREMENT = @"keepAliveMeasurement";
NSString * const SECURE_TRANSMISSION = @"secureTransmission";
NSString * const PERSISTENT_LABELS = @"persistentLabels";
NSString * const START_LABELS = @"startLabels";
NSString * const POSITION = @"position";
NSString * const RATE = @"rate";
NSString * const MEDIA_PLAYER_NAME = @"mediaPlayerName";
NSString * const MEDIA_PLAYER_VERSION = @"mediaPlayerVersion";
NSString * const METADATA = @"metadata";
NSString * const IMPLEMENTATION_ID = @"implementationId";
NSString * const PROJECT_ID = @"projectId";
NSString * const SEGMENT_NUMBER = @"segmentNumber";
NSString * const DVR_WINDOW = @"dvrWindow";


+ (NSString*) refIdFromArgs:(NSDictionary*) arguments {
    return arguments[REF_ID];
}

@end
