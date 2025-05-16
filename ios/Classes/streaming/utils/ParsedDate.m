#import "ParsedDate.h"

@implementation ParsedDate;


- (ParsedDate*)initWithData:(id) data {
    self = [super init];
    if(self) {
        if (data == [NSNull null] || data == nil) {
            self.year = -1;
            self.month = -1;
            self.day = -1;
            self.isValid = NO;
        } else {
            self.year = data[@"year"] != [NSNull null] ? [data[@"year"] intValue] : -1;
            self.month = data[@"month"] != [NSNull null] ? [data[@"month"] intValue] : -1;
            self.day = data[@"day"] != [NSNull null] ? [data[@"day"] intValue] : -1;
            self.isValid = !(self.year < 0 || self.month < 0 || self.day < 0);
        }
    }
    return self;
}

@end
