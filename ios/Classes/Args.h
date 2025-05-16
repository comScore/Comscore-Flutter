#import <Foundation/Foundation.h>

#define obj_or_nil_from_arguments(a) ({ \
    id obj_or_nil = call.arguments[a]; \
    (obj_or_nil == [NSNull null]) ? nil : obj_or_nil; \
})

@interface Args : NSObject

extern NSString * const REF_ID;
extern NSString * const TYPE;
extern NSString * const CLIENT_ID;
extern NSString * const LABEL_NAME;
extern NSString * const LABEL_VALUE;
extern NSString * const LABELS;
extern NSString * const PUBLISHER_ID;
extern NSString * const PARTNER_ID;
extern NSString * const EVENT_INFO_REF_ID;
extern NSString * const DISTRIBUTOR_PARTNER_ID;
extern NSString * const DISTRIBUTOR_CONTENT_ID;
extern NSString * const PUBLISHER_UNIQUE_DEVICE_ID;
extern NSString * const D_KEY;
extern NSString * const URL;
extern NSString * const LABEL_ORDER;
extern NSString * const LIVE_POINT_URL;
extern NSString * const OFFLINE_FLUSH_END_POINT_URL;
extern NSString * const APP_NAME;
extern NSString * const APP_VERSION;
extern NSString * const APP_ID;
extern NSString * const ENABLED;
extern NSString * const LIVE_TRANSMISSION_MODE;
extern NSString * const OFFLINE_CACHE_MODE;
extern NSString * const USAGE_PROPERTIES_AUTO_UPDATE_MODE;
extern NSString * const INTERVAL;
extern NSString * const MAX;
extern NSString * const MINUTES;
extern NSString * const DAYS;
extern NSString * const PRECISION;
extern NSString * const HTTP_REDIRECT_CACHING;
extern NSString * const KEEP_ALIVE_MEASUREMENT;
extern NSString * const SECURE_TRANSMISSION;
extern NSString * const PERSISTENT_LABELS;
extern NSString * const START_LABELS;
extern NSString * const POSITION;
extern NSString * const RATE;
extern NSString * const MEDIA_PLAYER_NAME;
extern NSString * const MEDIA_PLAYER_VERSION;
extern NSString * const METADATA;
extern NSString * const IMPLEMENTATION_ID;
extern NSString * const PROJECT_ID;
extern NSString * const SEGMENT_NUMBER;
extern NSString * const DVR_WINDOW;


+ (NSString*) refIdFromArgs:(NSDictionary*) arguments;

@end
