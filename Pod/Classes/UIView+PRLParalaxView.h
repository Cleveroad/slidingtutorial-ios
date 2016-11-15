//
//  UIView+PRLParalaxView.h
//  Pods
//
//  Created by Danil on 11/7/16.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (PRLParalaxView)
/**
 @property slippingCoefficient - (Sets in interface builder) ratio bound to scroll offset in scroll view. For 1 pixel content offset of scroll view layer will be slipping for 1 * slippingCoefficient (so if slippingCoefficient == 0.3, it will be equal 0.3px). Sign determines the direction of slipping - left or right.
 */
@property (nonatomic, readonly) IBInspectable CGFloat slippingCoefficient;

@end
