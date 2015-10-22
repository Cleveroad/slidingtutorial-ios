//
//  PRLView.h
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PRLViewProtocol <NSObject>

- (void)skipTutorial;

@end

@interface PRLView : UIView

@property (weak, nonatomic) id <PRLViewProtocol> delegate;

- (instancetype)initWithPageCount:(NSInteger)pageCount
                 scaleCoefficient:(CGFloat)scaleCoefficient;

- (void)addElementWithName:(NSString *)elementName
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY
       slippingCoefficient:(CGFloat)slippingCoefficient
                   pageNum:(NSInteger)pageNum;

- (void)addBackkgroundColor:(UIColor *)color;

- (void)prepareForShow;

@end
