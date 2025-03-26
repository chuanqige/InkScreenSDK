//
//  CALayer+JPExtension.h
//  

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (JPExtension)

+ (CABasicAnimation *)jp_backwardsAnimationWithKeyPath:(NSString *)keyPath
                                             fromValue:(id)fromValue
                                               toValue:(id)toValue
                                    timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                              duration:(NSTimeInterval)duration;

@end

@interface CALayer (JPExtension)

- (void)jp_addBackwardsAnimationWithKeyPath:(NSString *)keyPath
                                  fromValue:(id)fromValue
                                    toValue:(id)toValue
                         timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                   duration:(NSTimeInterval)duration;

@end
