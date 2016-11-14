//
//  UIView+PRLConstraintsBuilder.m
//  Pods
//
//  Created by Danil on 11/10/16.
//
//

#import "UIView+PRLConstraintsBuilder.h"

CGFloat const kHeightSkipView = 40.0;

@implementation UIView (PRLConstraintsBuilder)

- (void)addConstraintsToBaseView {
    
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
}

- (void)addConstraintsToScrollView:(UIScrollView *)scrollView skipView:(UIView *)skipView {
    
    //add constraints to scrollView
    [scrollView.leadingAnchor constraintEqualToAnchor:scrollView.superview.leadingAnchor].active = YES;
    [scrollView.trailingAnchor constraintEqualToAnchor:scrollView.superview.trailingAnchor].active = YES;
    [scrollView.topAnchor constraintEqualToAnchor:scrollView.superview.topAnchor].active = YES;
    
    //connect scrollView bottom with skipView top
    [scrollView.bottomAnchor constraintEqualToAnchor:skipView.topAnchor].active = YES;
    
    //add constraints to skipView
    [skipView.leadingAnchor constraintEqualToAnchor:skipView.superview.leadingAnchor].active = YES;
    [skipView.trailingAnchor constraintEqualToAnchor:skipView.superview.trailingAnchor].active = YES;
    [skipView.bottomAnchor constraintEqualToAnchor:skipView.superview.bottomAnchor].active = YES;
    [skipView.heightAnchor constraintEqualToConstant:kHeightSkipView].active = YES;
}

- (void)addConstraintsToStackView:(UIStackView *)stackView {
    
    [stackView.leadingAnchor constraintEqualToAnchor:stackView.superview.leadingAnchor].active = YES;
    [stackView.trailingAnchor constraintEqualToAnchor:stackView.superview.trailingAnchor].active = YES;
    [stackView.topAnchor constraintEqualToAnchor:stackView.superview.topAnchor].active = YES;
    [stackView.bottomAnchor constraintEqualToAnchor:stackView.superview.bottomAnchor].active = YES;
    
    //set Height and Width of views in StackView
    [stackView.subviews.firstObject.heightAnchor constraintEqualToAnchor:self.heightAnchor constant: - kHeightSkipView].active = YES;
    [stackView.subviews.firstObject.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
}

@end
