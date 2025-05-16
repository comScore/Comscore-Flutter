@interface ParsedDimensions : NSObject

@property int width;
@property int height;
@property bool isValid;

- (ParsedDimensions*)initWithData:(id) data;
@end
