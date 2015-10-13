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
                    pageCount:(NSInteger)pageCount
             scaleCoefficient:(CGFloat)scaleCoefficient;

- (void)addElementWithName:(NSString *)elementName
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY
       slippingCoefficient:(CGFloat)slippingCoefficient
                   pageNum:(NSInteger)pageNum;

- (void)addBackkgroundColor:(UIColor *)color;

- (void)prepareForShow;

@end
