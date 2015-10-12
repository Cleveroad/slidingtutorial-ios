//
//  PRLView.h
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    pageCount:(NSUInteger)pageCount;

- (void)addElementWithName:(NSString *)elementName
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY
       slippingCoefficient:(CGFloat)slippingCoefficient
                   pageNum:(NSUInteger)pageNum;

- (void)addBackkgroundColor:(UIColor *)color;

@end
