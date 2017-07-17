

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SKTag;
@interface SKTagButton: UIButton

@property (nonatomic) BOOL isTapped;
+ (nonnull instancetype)buttonWithTag: (nonnull SKTag *)tag;
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
