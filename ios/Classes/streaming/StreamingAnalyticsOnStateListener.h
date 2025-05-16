#import <ComScore/ComScore.h>

@interface StreamingAnalyticsOnStateListener : NSObject<SCORStreamingDelegate>

@property NSString *refId;

- (StreamingAnalyticsOnStateListener*)initWithRefId:(NSString*) refId;

@end
