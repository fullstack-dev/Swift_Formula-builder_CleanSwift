
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKTag : NSObject

@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSString *chineseText;
@property (copy, nonatomic, nullable) NSString *iconName;

@property (copy, nonatomic, nullable) NSAttributedString *attributedText;

@property (strong, nonatomic, nullable) UIColor *textColor;
@property (strong, nonatomic, nullable) UIColor *chineseTextColor;
///backgound color
@property (strong, nonatomic, nullable) UIColor *bgColor;
@property (strong, nonatomic, nullable) UIColor *highlightedBgColor;
///background image
@property (strong, nonatomic, nullable) UIImage *bgImg;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;
///like padding in css
@property (assign, nonatomic) UIEdgeInsets padding;

@property (strong, nonatomic, nullable) UIFont *font;
@property (strong, nonatomic, nullable) UIFont *chineseTextfont;
///if no font is specified, system font with fontSize is used
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat chineeseTextFontSize;
///default:YES
@property (assign, nonatomic) BOOL enable;
@property (assign, nonatomic) BOOL selected;

- (instancetype)initWithText: (nonnull NSString *)text chineseText: (nonnull NSString *)chineseText iconName: (nonnull NSString *)iconName;
+ (nonnull instancetype)tagWithText: (nonnull NSString *)text chineseText:(nullable NSString *)chineseText iconName: (NSString *)iconName;

@end
