#import "ParsedDimensions.h"

@implementation ParsedDimensions;


- (ParsedDimensions*)initWithData:(id) data {
    self = [super init];
    if(self) {
        if (data == [NSNull null] || data == nil) {
            self.width = -1;
            self.height = -1;
            self.isValid = NO;
        } else {
            self.width = data[@"width"] != [NSNull null] ? [data[@"width"] intValue] : -1;
            self.height = data[@"height"] != [NSNull null] ? [data[@"height"] intValue] : -1;
            self.isValid = !(self.width < 0 || self.height < 0);
        }
    }
    return self;
}

@end
