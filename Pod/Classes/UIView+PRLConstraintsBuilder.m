//
//  UIView+PRLConstraintsBuilder.m
//  Pods
//
//  Created by Danil on 11/10/16.
//
//

#import "UIView+PRLConstraintsBuilder.h"

@implementation UIView (PRLConstraintsBuilder)

- (void)addAnchorsToBaseView {
    
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
}

- (void)addAnchorsToScrollView:(UIScrollView *)scrollView skipView:(UIView *)skipView {
    
    [scrollView.leadingAnchor constraintEqualToAnchor:scrollView.superview.leadingAnchor].active = YES;
    [scrollView.trailingAnchor constraintEqualToAnchor:scrollView.superview.trailingAnchor].active = YES;
    [scrollView.topAnchor constraintEqualToAnchor:scrollView.superview.topAnchor].active = YES;
    
    [scrollView.bottomAnchor constraintEqualToAnchor:skipView.topAnchor].active = YES;
    
    [skipView.leadingAnchor constraintEqualToAnchor:skipView.superview.leadingAnchor].active = YES;
    [skipView.trailingAnchor constraintEqualToAnchor:skipView.superview.trailingAnchor].active = YES;
    [skipView.bottomAnchor constraintEqualToAnchor:skipView.superview.bottomAnchor].active = YES;
    //[skipView.heightAnchor constraintEqualToConstant:40.0].active = YES;
}

- (void)addAnchorsToContentView:(UIView *)contentView {
    [contentView.leadingAnchor constraintEqualToAnchor:contentView.superview.leadingAnchor].active = YES;
    [contentView.trailingAnchor constraintEqualToAnchor:contentView.superview.trailingAnchor].active = YES;
    [contentView.topAnchor constraintEqualToAnchor:contentView.superview.topAnchor].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:contentView.superview.bottomAnchor].active = YES;
    
    [contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
//    [contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = NO;
}

@end
