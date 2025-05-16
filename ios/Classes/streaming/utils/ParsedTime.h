@interface ParsedTime : NSObject

@property int hour;
@property int minute;
@property bool isValid;

- (ParsedTime*)initWithData:(id) data;
@end
