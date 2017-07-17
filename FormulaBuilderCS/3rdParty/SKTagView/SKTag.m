
#import "SKTag.h"

static const CGFloat kDefaultFontSize = 13.0;

@implementation SKTag

- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = kDefaultFontSize;
        _chineeseTextFontSize = kDefaultFontSize;
        
        _textColor = [UIColor blackColor];
        _chineseTextColor = [UIColor blackColor];
        
        _bgColor = [UIColor whiteColor];
        _enable = YES;
        _selected = NO;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text chineseText: (NSString *)chineseText iconName: (NSString *)iconName{
    self = [self init];
    if (self) {
        _text = text;
        _chineseText = chineseText;
        _iconName = iconName;
    }
    return self;
}

+ (instancetype)tagWithText: (NSString *)text chineseText: (NSString *)chineseText iconName: (NSString *)iconName{
    return [[self alloc] initWithText: text chineseText:chineseText iconName:iconName];
}

@end
