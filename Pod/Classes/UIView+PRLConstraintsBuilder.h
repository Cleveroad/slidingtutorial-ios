//
//  UIView+PRLConstraintsBuilder.h
//  Pods
//
//  Created by Danil on 11/10/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (PRLConstraintsBuilder)
extern CGFloat const kHeightSkipView;

- (void)addConstraintsToBaseView;
- (void)addConstraintsToScrollView:(UIScrollView *)scrollView skipView:(UIView *)skipView;
- (void)addConstraintsToStackView:(UIStackView *)stackView;

@end
