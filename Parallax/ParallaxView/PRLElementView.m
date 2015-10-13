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
              slippingCoefficient:(CGFloat)slippingCoefficient
                 scaleCoefficient:(CGFloat)scaleCoefficient;
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        NSLog(@"No image with name %@ loaded",imageName);
        return nil;
    }
    
    CGSize destinationSize = CGSizeMake(image.size.width * scaleCoefficient, image.size.height * scaleCoefficient);
    UIGraphicsBeginImageContextWithOptions(destinationSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resizedImage];
    
    CGFloat postionX = (SCREEN_WIDTH - resizedImage.size.width) / 2;
    CGFloat postionY = (SCREEN_HEIGHT - resizedImage.size.height) / 2;
    
    if (self = [super initWithFrame:CGRectMake(postionX + offsetX * scaleCoefficient + SCREEN_WIDTH * slippingCoefficient * pageNumber ,
                                               postionY + offsetY * scaleCoefficient,
                                               resizedImage.size.width,
                                               resizedImage.size.height)]) {
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
