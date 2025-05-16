#import "ObjTracker.h"
#import "Args.h"
#import <ComScore/ComScore.h>

@implementation ObjTracker

NSString * const ERROR_OBJ_REF_NOT_FOUND = @"OBJ_REF_NOT_FOUND";

static NSMutableDictionary *_objects = nil;

+ (NSMutableDictionary*) objects {
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          _objects = [[NSMutableDictionary alloc] init];
      });
    return _objects;
}

+ (NSString* ) trackObj: (id) obj {
    if (obj == nil) {
        return nil;
    }
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * refId = (__bridge_transfer NSString *)uuidStringRef;
    
    [ObjTracker objects][refId] = obj;
    return refId;
}

+ (id) trackedObjFromArguments: (id) args {
    return [ObjTracker trackedObj: args[REF_ID]];
}

+ (id) trackedObj: (NSString *) refId {
    return [ObjTracker objects][refId];
}


@end
