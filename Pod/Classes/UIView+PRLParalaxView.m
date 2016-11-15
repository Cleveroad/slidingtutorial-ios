//
//  UIView+PRLParalaxView.m
//  Pods
//
//  Created by Danil on 11/7/16.
//
//

#import "UIView+PRLParalaxView.h"
#import <objc/runtime.h>
#import "UIView+PRLParalaxView.h"

@implementation UIView (PRLParalaxView)

#pragma mark - Setter/Getter

- (void)setSlippingCoefficient:(CGFloat)slippingCoefficient {
    objc_setAssociatedObject(self, @selector(slippingCoefficient), @(slippingCoefficient) , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)slippingCoefficient {
    NSNumber *number = objc_getAssociatedObject(self, @selector(slippingCoefficient));
    return number.floatValue;
}

@end
