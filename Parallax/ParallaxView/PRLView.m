//
//  PRLView.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLView.h"
#import "PRLElementView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PRLView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray *arrayOfPages;

@end

@implementation PRLView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
                    pageCount:(NSInteger)pageCount;
{
    if (pageCount <= 0) {
        NSLog(@"Wrong page count %li. It should be at least 1", (long)pageCount);
        return nil;
    }
    
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width * pageCount)])) {
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * pageCount, SCREEN_HEIGHT)];
        [self addSubview:self.scrollView];
        
        for (int i = 0; i < pageCount; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.arrayOfPages addObject:view];
            [self.scrollView addSubview:view];
        }
    }
    return  self;
}

- (void)addElementWithName:(NSString *)elementName
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY
       slippingCoefficient:(CGFloat)slippingCoefficient
                   pageNum:(NSInteger)pageNum;
{
    UIImage *image = [UIImage imageNamed:elementName];
    if (!image) {
        NSLog(@"No image with name %@ loaded",elementName);
        return;
    }
    if (pageNum >= self.arrayOfPages.count || pageNum < 0) {
        NSLog(@"Wrong page number %li Range of pages should be from 0 to %lu",(long)pageNum, self.arrayOfPages.count -1);
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat postionX = (SCREEN_WIDTH - image.size.width) / 2;
    CGFloat postionY = (SCREEN_HEIGHT - image.size.height) / 2;
    
    PRLElementView *viewSlip = [[PRLElementView alloc] initWithFrame:CGRectMake(postionX + offsetX + SCREEN_WIDTH * slippingCoefficient * pageNum,
                                                                                postionY + offsetY,
                                                                                image.size.width,
                                                                                image.size.height)];
    viewSlip.slippingCoefficient = slippingCoefficient;
    [viewSlip addSubview:imageView];
    [self.arrayOfPages[pageNum] addSubview:viewSlip];
    [self.arrayOfElements addObject:viewSlip];
}

- (void)addBackkgroundColor:(UIColor *)color;
{
    [self.arrayOfBackgroundColors insertObject:color atIndex:self.arrayOfBackgroundColors.count -1];
}

- (void)prepareForShow;
{
    if (self.arrayOfBackgroundColors.count -1 < self.arrayOfPages.count) {
        NSLog(@"Wrong count of background colors. Should be %lu instead of %lu", self.arrayOfPages.count, self.arrayOfBackgroundColors.count -1);
        NSLog(@"The missing colors will be replaced by white");
        while (self.arrayOfBackgroundColors.count < self.arrayOfPages.count) {
            [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        }
    }
    
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[0]
                                        secondColor:self.arrayOfBackgroundColors[1]
                                             offset:0];
    [self.scrollView setBackgroundColor:mixedColor];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    for (PRLElementView *view in self.arrayOfElements) {
        CGFloat offset = (self.lastContentOffset - contentOffset) * view.slippingCoefficient;
        [view setFrame:CGRectMake(view.frame.origin.x + offset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    }
    
    self.lastContentOffset = contentOffset;
    NSInteger pageNum =  floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
    if (pageNum < 0) {
        pageNum = 0;
    }
    if (pageNum > self.arrayOfBackgroundColors.count -2) {
        pageNum = self.arrayOfBackgroundColors.count -2;
    }
    
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[pageNum]
                                        secondColor:self.arrayOfBackgroundColors[pageNum +1]
                                             offset:scrollView.contentOffset.x];
    [scrollView setBackgroundColor:mixedColor];
}

#pragma mark - Private


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

//- (void)viewWillTransitionToSize:(CGSize)size  withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
////         NSLog(@"Orientation %i",orientation);
////         int i=0;
//         [self.scrollView removeFromSuperview];
//         // do whatever
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//
//         self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//         self.scrollView.delegate = self;
//         self.scrollView.pagingEnabled = YES;
//         [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * (self.arrayOfBackgroundColors.count -1), SCREEN_HEIGHT)];
//         [self.scrollView setBackgroundColor:self.arrayOfBackgroundColors[0]];
//         [self.view addSubview:self.scrollView];
//
//         [self setupFirstScreen];
//         [self setupSecondScreen];
//         [self setupThirdScreen];
//         [self setupFourthScreen];
//     }];
//
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

@end
