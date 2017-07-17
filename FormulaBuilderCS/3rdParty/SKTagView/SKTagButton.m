

#import "SKTagButton.h"
#import "SKTag.h"

@implementation SKTagButton

+ (instancetype)buttonWithTag: (SKTag *)tag {
	SKTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
	
	if (tag.attributedText) {
		[btn setAttributedTitle: tag.attributedText forState: UIControlStateNormal];
	} else {
		[btn setTitle: [NSString stringWithFormat:@"%@\n%@", tag.text, tag.chineseText] forState:UIControlStateNormal];
		[btn setTitleColor: tag.textColor forState: UIControlStateNormal];
		btn.titleLabel.font = tag.font ?: [UIFont systemFontOfSize: tag.fontSize];
	}
	
	btn.backgroundColor = tag.bgColor;
	btn.contentEdgeInsets = tag.padding;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
	btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //btn.imageView.contentMode = UIViewContentModeScaleToFill;
	
    if (tag.bgImg) {
        [btn setBackgroundImage: tag.bgImg forState: UIControlStateNormal];
    }
    
    if (tag.borderColor) {
        btn.layer.borderColor = tag.borderColor.CGColor;
    }
    
    if (tag.borderWidth) {
        btn.layer.borderWidth = tag.borderWidth;
    }
    
    btn.userInteractionEnabled = tag.enable;
    if (tag.enable) {
        UIColor *highlightedBgColor = tag.highlightedBgColor ?: [self darkerColor:btn.backgroundColor];
        [btn setBackgroundImage:[self imageWithColor:highlightedBgColor] forState:UIControlStateHighlighted];
    }
    
    btn.layer.cornerRadius = tag.cornerRadius;
    btn.layer.masksToBounds = YES;
    
    NSString *imageName = tag.iconName;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIColor *)darkerColor:(UIColor *)color {
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.85
                               alpha:a];
    return color;
}

@end
