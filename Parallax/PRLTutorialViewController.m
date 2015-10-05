//
//  PRLTutorialViewController.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLTutorialViewController.h"
#import "PRLElementView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
};

@interface PRLTutorialViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@end

@implementation PRLTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color1 = [UIColor colorWithRed:231./255 green:150./255 blue:0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:163./255 green:181./255 blue:0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:35./255 green:75./255 blue:122.0/255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:198./255 green:84./255 blue:0.0/255 alpha:1];
    self.arrayOfBackgroundColors = [@[color1, color2, color3, color4, [UIColor whiteColor]] mutableCopy];
    
    self.arrayOfElements = [NSMutableArray array];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = screenSize.width;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(screenSize.width * (self.arrayOfBackgroundColors.count -1), screenSize.height)];
    [self.scrollView setBackgroundColor:self.arrayOfBackgroundColors[0]];
    [self.view addSubview:self.scrollView];
    
    self.view1 = [[UIView alloc] initWithFrame:rect];
    [self.scrollView addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(width, 0, rect.size.width, rect.size.height)];
   // [self.view2 setBackgroundColor:self.color2];
    [self.scrollView addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(width *2, 0, rect.size.width, rect.size.height)];
    //[self.view3 setBackgroundColor:self.color3];
    [self.scrollView addSubview:self.view3];
    
    [self setupFirstScreen];
}

- (void)setupFirstScreen {
    [self addElementOnView:self.view1 elementName:@"elem01-04" offsetX:0 offsetY:30 slippingCoefficient:0];
    [self addElementOnView:self.view1 elementName:@"elem01-01" offsetX:0 offsetY:-100 slippingCoefficient:0.1];
    [self addElementOnView:self.view1 elementName:@"elem01-02" offsetX:-140 offsetY:0 slippingCoefficient:-0.2];
    [self addElementOnView:self.view1 elementName:@"elem01-03" offsetX:-110 offsetY:100 slippingCoefficient:0.3];
    
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionRight;
        for (PRLElementView *view in self.arrayOfElements) {
            CGFloat offset = fabs(self.lastContentOffset - scrollView.contentOffset.x) * view.slippingCoefficient;
            CGRect rect = view.frame;
            [view setFrame:CGRectMake(rect.origin.x + offset, rect.origin.y, rect.size.width, rect.size.height)];
        }
    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionLeft;
        for (PRLElementView *view in self.arrayOfElements) {
            CGFloat offset = fabs(self.lastContentOffset - scrollView.contentOffset.x) * view.slippingCoefficient;
            CGRect rect = view.frame;
            [view setFrame:CGRectMake(rect.origin.x - offset, rect.origin.y, rect.size.width, rect.size.height)];
        }
    }
    
    self.lastContentOffset = scrollView.contentOffset.x;
    NSInteger pageNum =  floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
    if (pageNum < 0) {
        pageNum = 0;
    }
    if (pageNum > self.arrayOfBackgroundColors.count -1) {
        pageNum = self.arrayOfBackgroundColors.count -1;
    }
    
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[pageNum]
                                        secondColor:self.arrayOfBackgroundColors[pageNum +1]
                                             offset:(CGFloat)scrollView.contentOffset.x];
    [scrollView setBackgroundColor:mixedColor];
}

#pragma mark -

- (void)addElementOnView:(UIView *)viewPage
             elementName:(NSString *)elementName
                 offsetX:(CGFloat)offsetX
                 offsetY:(CGFloat)offsetY
     slippingCoefficient:(CGFloat)slippingCoefficient
{
    UIImage *image = [UIImage imageNamed:elementName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat screenWidht = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat postionX = (screenWidht - image.size.width) / 2;
    CGFloat postionY = (screenHeight - image.size.height) / 2;
    
    PRLElementView *viewSlip = [[PRLElementView alloc] initWithFrame:CGRectMake(postionX + offsetX, postionY + offsetY, image.size.width, image.size.height)];
    viewSlip.slippingCoefficient = slippingCoefficient;
    [viewSlip addSubview:imageView];
    [viewPage addSubview:viewSlip];
    [self.arrayOfElements addObject:viewSlip];
}

- (UIColor *)colorWithFirstColor:(UIColor *)firstColor
                     secondColor:(UIColor *)secondColor
                          offset:(CGFloat)offset;
{
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2, green2, blue2, alpha2;
    [firstColor  getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [secondColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat redDelta = red2 - red1;
    CGFloat greenDelta = green2 - green1;
    CGFloat blueDelta = blue2 - blue1;
    
    offset = fmod(offset, SCREEN_WIDTH);
    CGFloat resultRed = redDelta * (offset / SCREEN_WIDTH) + red1;
    CGFloat resultGreen = greenDelta * (offset / SCREEN_WIDTH) + green1;
    CGFloat resultBlue = blueDelta * (offset / SCREEN_WIDTH) + blue1;
    
    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:1];
}

@end
