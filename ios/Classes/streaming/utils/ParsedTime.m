#import "ParsedTime.h"

@implementation ParsedTime;


- (ParsedTime*)initWithData:(id) data {
    self = [super init];
    if(self) {
        if (data == [NSNull null] || data == nil) {
            self.hour = -1;
            self.minute = -1;
            self.isValid = NO;
        } else {
            self.hour = data[@"hour"] != [NSNull null] ? [data[@"hour"] intValue] : -1;
            self.minute = data[@"minute"] != [NSNull null] ? [data[@"minute"] intValue] : -1;
            self.isValid = !(self.hour < 0 || self.minute < 0);
        }
        
    }
    return self;
}

@end
