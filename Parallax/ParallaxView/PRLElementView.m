//
//  PRLElementView.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLElementView.h"

@interface PRLElementView ()

@property (nonatomic, readwrite) CGFloat slippingCoefficient;
@property (nonatomic, readwrite) CGFloat offsetX;
@property (nonatomic, readwrite) CGFloat offsetY;
@property (nonatomic, readwrite) NSInteger pageNumber;
@property (nonatomic, readwrite) NSString *imageName;

@end

@implementation PRLElementView

- (instancetype)initWithImageName:(NSString *)imageName
                          offsetX:(CGFloat)offsetX
                          offsetY:(CGFloat)offsetY
                       pageNumber:(NSInteger)pageNumber
              slippingCoefficient:(CGFloat)slippingCoefficient;
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        NSLog(@"No image with name %@ loaded",imageName);
        return nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
//    CGPoint centerView = [self.view center]
//    centerView.x += offsetX;
//    centerView.y += offsetY;
//    self.center = centerView;
    
    CGFloat postionX = (SCREEN_WIDTH - image.size.width) / 2;
    CGFloat postionY = (SCREEN_HEIGHT - image.size.height) / 2;
    
    if (self = [super initWithFrame:CGRectMake(postionX + offsetX + SCREEN_WIDTH * slippingCoefficient * pageNumber,
                                               postionY + offsetY,
                                               image.size.width,
                                               image.size.height)]) {
        self.slippingCoefficient = slippingCoefficient;
        self.offsetX = offsetX;
        self.offsetY = offsetY;
        self.pageNumber = pageNumber;
        self.imageName = imageName;
        [self addSubview:imageView];
    }
    
    return self;
}

@end
