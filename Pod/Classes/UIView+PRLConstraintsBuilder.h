//
//  UIView+PRLConstraintsBuilder.h
//  Pods
//
//  Created by Danil on 11/10/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (PRLConstraintsBuilder)

- (void)addAnchorsToBaseView;
- (void)addAnchorsToScrollView:(UIScrollView *)scrollView skipView:(UIView *)skipView;
- (void)addAnchorsToContentView:(UIView *)contentView;
@end
