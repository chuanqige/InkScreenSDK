//
//  UIView+Extension.h
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;


- (void)removeAllSubviews;

// 视图转成图像 scale图像密度为1
- (UIImage *)renderInContext;

// 视图转成图像 scale为图像密度
- (UIImage *)renderInContextScale:(CGFloat)scale;

// 视图转成图像 opaque:图像是否透明  scale:图像密度
- (UIImage *)renderInContextOpaque:(BOOL)opaque scale:(CGFloat)scale;

// 视图转成图像 size:图像大小 opaque:图像是否透明  scale:图像密度
- (UIImage *)renderInContextSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale;


// 设置圆角
- (void)rounded:(CGFloat)cornerRadius;

// 设置边框
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

// 设置圆角和边框
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(nullable UIColor *)borderColor;

// 给哪几个角设置圆角
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

// 设置阴影
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;



@end
