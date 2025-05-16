@interface ParsedDate : NSObject

@property int year;
@property int month;
@property int day;
@property bool isValid;

- (ParsedDate*)initWithData:(id) data;

@end
