#import <Flutter/Flutter.h>

extern NSString * const ERROR_OBJ_REF_NOT_FOUND;

@interface ObjTracker : NSObject

+ (NSMutableDictionary*) objects;

+ (NSString* ) trackObj: (id) obj;

+ (id) trackedObjFromArguments: (id) args;
+ (id) trackedObj: (NSString *) refId;

@end
