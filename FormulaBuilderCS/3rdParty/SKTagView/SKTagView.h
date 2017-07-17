

#import <UIKit/UIKit.h>
#import "SKTag.h"

@interface SKTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);

- (void)addTag: (nonnull SKTag *)tag;
- (void)insertTag: (nonnull SKTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull SKTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;

@end

